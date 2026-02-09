"""Post-grading calibration module.

Analyzes per-criterion scoring patterns across all graded students and
proposes adjustments for instructor review.  Adjustments are recorded as
Override objects for full audit-trail compatibility with the existing
review and export pipeline.

Statistics are parsed from the feedback report files on disk
(``output/reports/*-feedback.md``) rather than the session JSON, so that
every student with a report is included — even if they are missing from
the session (e.g. graded via ``--student`` without a session save).

Usage:
    Standalone:  python grader.py calibrate -c configs/quiz-01.yaml
    Inline:      auto-runs after batch grading completes (before review)
"""

import json
import logging
import os
import random
import re
import subprocess
import time
from dataclasses import dataclass, field
from pathlib import Path
from statistics import mean, median, stdev

from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.table import Table

from .llm_grader import (
    CLAUDE_CLI,
    CLAUDE_MODEL,
    CLAUDE_TIMEOUT_SECONDS,
    MAX_RETRIES,
    BASE_BACKOFF_SECONDS,
    MAX_JITTER_SECONDS,
    select_backend,
)
from .models import GradingSession, Override, QuizConfig

logger = logging.getLogger(__name__)

console = Console()


# ---------------------------------------------------------------------------
# Transient data models (not persisted to session JSON)
# ---------------------------------------------------------------------------

@dataclass
class ParsedCriterionScore:
    """A single criterion score parsed from a feedback report."""

    name: str
    score: int
    max_points: int
    feedback: str = ""


@dataclass
class ParsedFeedbackReport:
    """Structured data parsed from a ``*-feedback.md`` file."""

    student_name: str
    total_score: int
    total_max: int
    file_path: Path
    criteria: list[ParsedCriterionScore] = field(default_factory=list)


@dataclass
class CriterionStats:
    """Per-criterion aggregated statistics across all graded students."""

    criterion_id: str
    criterion_name: str
    max_points: int
    scores: list[int] = field(default_factory=list)
    student_names: list[str] = field(default_factory=list)
    sample_reasoning: list[str] = field(default_factory=list)

    @property
    def mean(self) -> float:
        return mean(self.scores) if self.scores else 0.0

    @property
    def median(self) -> float:
        return median(self.scores) if self.scores else 0.0

    @property
    def stdev(self) -> float:
        return stdev(self.scores) if len(self.scores) >= 2 else 0.0

    @property
    def min_score(self) -> int:
        return min(self.scores) if self.scores else 0

    @property
    def max_score(self) -> int:
        return max(self.scores) if self.scores else 0

    @property
    def pct_zero(self) -> float:
        if not self.scores:
            return 0.0
        return sum(1 for s in self.scores if s == 0) / len(self.scores) * 100

    @property
    def pct_full(self) -> float:
        if not self.scores:
            return 0.0
        return (
            sum(1 for s in self.scores if s == self.max_points)
            / len(self.scores)
            * 100
        )

    def score_roster(self) -> str:
        """Build a compact score->students mapping for the LLM prompt."""
        buckets: dict[int, list[str]] = {}
        for score, name in zip(self.scores, self.student_names):
            buckets.setdefault(score, []).append(name)

        parts = []
        for score in sorted(buckets):
            names = buckets[score]
            if len(names) <= 3:
                names_str = ", ".join(names)
            else:
                names_str = f"{', '.join(names[:3])}, ...{len(names) - 3} more"
            parts.append(f"{score}=[{names_str}]")
        return ", ".join(parts)


@dataclass
class RubricAdjustment:
    """Proposed blanket point adjustment on a criterion for all students."""

    criterion_id: str
    criterion_name: str
    points_change: int
    rationale: str
    current_mean: float = 0.0
    projected_mean: float = 0.0
    affected_count: int = 0


@dataclass
class StudentBump:
    """Proposed score change for specific students on a criterion."""

    criterion_id: str
    criterion_name: str
    student_names: list[str] = field(default_factory=list)
    current_score: int = 0
    new_score: int = 0
    rationale: str = ""


@dataclass
class CalibrationFinding:
    """Informational pattern — no score change proposed."""

    finding_type: str  # "confusing_question", "grading_inconsistency", "notable_pattern"
    criterion_name: str
    description: str
    recommendation: str = ""


@dataclass
class CalibrationReport:
    """Container for all LLM calibration findings."""

    summary: str = ""
    rubric_adjustments: list[RubricAdjustment] = field(default_factory=list)
    student_bumps: list[StudentBump] = field(default_factory=list)
    findings: list[CalibrationFinding] = field(default_factory=list)


# ---------------------------------------------------------------------------
# Report file discovery and parsing
# ---------------------------------------------------------------------------

def _discover_report_files(output_path: Path) -> list[Path]:
    """Glob for feedback report files in ``output/reports/``."""
    reports_dir = output_path / "reports"
    if not reports_dir.is_dir():
        return []
    return sorted(reports_dir.glob("*-feedback.md"))


# Regex patterns for parsing the feedback markdown template
_RE_STUDENT = re.compile(r"^\*\*Student:\*\*\s+(.+)$")
_RE_SCORE = re.compile(r"^\*\*Score:\*\*\s+(\d+)\s*/\s*(\d+)")
_RE_TABLE_ROW = re.compile(
    r"^\|\s*(.+?)\s*\|\s*(\d+)\s*/\s*(\d+)\s*\|\s*(.*?)\s*\|$"
)


def _parse_feedback_report(md_path: Path) -> ParsedFeedbackReport | None:
    """Parse a single feedback markdown file into structured data.

    Returns None if the file cannot be parsed (missing student name or score).
    """
    try:
        text = md_path.read_text(encoding="utf-8")
    except OSError:
        logger.warning("Could not read report file: %s", md_path)
        return None

    student_name: str | None = None
    total_score: int | None = None
    total_max: int | None = None
    criteria: list[ParsedCriterionScore] = []

    for line in text.splitlines():
        line = line.strip()

        # Match **Student:** name
        m = _RE_STUDENT.match(line)
        if m:
            student_name = m.group(1).strip()
            continue

        # Match **Score:** n / m (pct%)
        m = _RE_SCORE.match(line)
        if m:
            total_score = int(m.group(1))
            total_max = int(m.group(2))
            continue

        # Match table data rows: | Criterion | score/max | feedback |
        m = _RE_TABLE_ROW.match(line)
        if m:
            crit_name = m.group(1).strip()
            # Skip header/separator rows — they won't have digits in the
            # score column, so _RE_TABLE_ROW already filters them via \d+
            criteria.append(ParsedCriterionScore(
                name=crit_name,
                score=int(m.group(2)),
                max_points=int(m.group(3)),
                feedback=m.group(4).strip(),
            ))

    if student_name is None or total_score is None or total_max is None:
        logger.warning("Unparseable report (missing header fields): %s", md_path)
        return None

    return ParsedFeedbackReport(
        student_name=student_name,
        total_score=total_score,
        total_max=total_max,
        file_path=md_path,
        criteria=criteria,
    )


def _build_criterion_name_to_id(config: QuizConfig) -> dict[str, str]:
    """Map criterion display names to criterion IDs using config.

    Reports use display names (from the template); the session and LLM
    prompt use criterion IDs.  Since reports are generated from the same
    config, names match exactly.
    """
    name_to_id: dict[str, str] = {}
    for tc in config.tasks:
        for cc in tc.criteria:
            name_to_id[cc.name] = cc.criterion_id
    return name_to_id


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def run_calibration(
    session: GradingSession,
    config: QuizConfig,
    output_path: Path,
) -> GradingSession:
    """Entry point for post-grading calibration.

    Discovers feedback report files on disk, parses them for statistics,
    optionally calls the LLM for pattern analysis, presents findings to
    the instructor, and applies accepted adjustments as Override records
    to the session.

    Args:
        session: The grading session (used for applying adjustments).
        config: The quiz configuration with task/criterion definitions.
        output_path: Root output directory containing ``reports/``.

    Returns:
        The (possibly modified) session with any accepted overrides applied.
    """
    console.print()
    console.print(Panel(
        "[bold]POST-GRADING CALIBRATION[/bold]",
        style="blue",
        expand=False,
    ))

    # Step 1: Discover and parse report files
    report_files = _discover_report_files(output_path)
    if not report_files:
        console.print("[yellow]No feedback reports found in reports/.[/yellow]")
        return session

    parsed_reports: list[ParsedFeedbackReport] = []
    for rf in report_files:
        parsed = _parse_feedback_report(rf)
        if parsed is not None:
            parsed_reports.append(parsed)

    if not parsed_reports:
        console.print("[yellow]No parseable feedback reports found.[/yellow]")
        return session

    # Check for students in reports but not in session
    session_names = {r.student_name for r in session.grade_reports}
    report_names = {r.student_name for r in parsed_reports}
    orphan_names = report_names - session_names
    if orphan_names:
        console.print(
            f"[yellow]{len(orphan_names)} student(s) found in reports but not "
            f"in session:[/yellow] {', '.join(sorted(orphan_names))}"
        )
        console.print(
            "[dim]  (Included in statistics but cannot receive adjustments)[/dim]"
        )

    console.print(f"\nAnalyzing {len(parsed_reports)} feedback reports...\n")

    # Step 2: Compute statistics from parsed reports
    criterion_stats = _compute_criterion_stats(parsed_reports, config)
    class_mean, class_median, class_min, class_max = _compute_class_stats(
        parsed_reports
    )

    # Derive total_possible from the first report or config
    total_possible = (
        parsed_reports[0].total_max if parsed_reports else config.total_points
    )
    num_students = len(parsed_reports)

    # Step 3: Display class overview
    _display_class_overview(
        num_students, class_mean, class_median, class_min, class_max,
        total_possible,
    )

    # Step 4: Display criterion statistics table
    _display_criterion_stats_table(criterion_stats)

    # Step 5: Ask instructor what to do
    console.print()
    choice = Prompt.ask(
        "Calibration options",
        choices=["c", "s", "n"],
        default="c",
    )
    console.print(
        "  [dim]c[/dim]=calibrate (LLM analysis)  "
        "[dim]s[/dim]=stats only  [dim]n[/dim]=no, skip"
    )

    if choice == "n":
        console.print("[dim]Calibration skipped.[/dim]")
        return session

    if choice == "s":
        console.print("[dim]Stats displayed. No LLM analysis.[/dim]")
        return session

    # Step 6: LLM calibration analysis
    all_student_names = report_names
    cal_report = _run_llm_calibration(
        criterion_stats, config, all_student_names,
        num_students, class_mean, class_median, class_min, class_max,
        total_possible,
    )
    if cal_report is None:
        console.print("[yellow]LLM calibration failed. No changes made.[/yellow]")
        return session

    # Step 7: Display findings
    _display_calibration_report(cal_report)

    # Step 8: Walk through proposed adjustments
    adjustments_applied = 0

    if cal_report.rubric_adjustments:
        console.print("\n[bold]RUBRIC-WIDE ADJUSTMENTS[/bold]")
        for adj in cal_report.rubric_adjustments:
            accepted = _review_single_rubric_adjustment(adj)
            if accepted:
                _apply_rubric_adjustment(session, config, adj)
                adjustments_applied += 1

    if cal_report.student_bumps:
        console.print("\n[bold]STUDENT SCORE BUMPS[/bold]")
        for bump in cal_report.student_bumps:
            accepted_names = _review_single_student_bump(bump)
            if accepted_names:
                bump.student_names = accepted_names
                _apply_student_bump(session, config, bump)
                adjustments_applied += 1

    if adjustments_applied > 0:
        console.print(
            f"\n[green]{adjustments_applied} calibration adjustment(s) applied.[/green]"
        )
        # Re-export reports for students who received overrides
        _re_export_affected_reports(session, config, output_path)
    else:
        console.print("\n[dim]No calibration adjustments applied.[/dim]")

    return session


# ---------------------------------------------------------------------------
# Statistics computation (from parsed reports)
# ---------------------------------------------------------------------------

def _compute_criterion_stats(
    parsed_reports: list[ParsedFeedbackReport],
    config: QuizConfig,
) -> list[CriterionStats]:
    """Compute per-criterion statistics from parsed feedback reports."""
    name_to_id = _build_criterion_name_to_id(config)

    # Build max-points lookup from config
    crit_max_lookup: dict[str, int] = {}
    for tc in config.tasks:
        for cc in tc.criteria:
            crit_max_lookup[cc.criterion_id] = cc.points

    # Collect scores per criterion
    crit_data: dict[str, CriterionStats] = {}

    for report in parsed_reports:
        for pc in report.criteria:
            cid = name_to_id.get(pc.name)
            if cid is None:
                logger.debug(
                    "Criterion name '%s' not found in config (student %s)",
                    pc.name, report.student_name,
                )
                continue

            if cid not in crit_data:
                crit_data[cid] = CriterionStats(
                    criterion_id=cid,
                    criterion_name=pc.name,
                    max_points=crit_max_lookup.get(cid, pc.max_points),
                )
            crit_data[cid].scores.append(pc.score)
            crit_data[cid].student_names.append(report.student_name)

            # Collect sample feedback as reasoning (up to 10, culled later)
            if pc.feedback and len(crit_data[cid].sample_reasoning) < 10:
                crit_data[cid].sample_reasoning.append(
                    f"[{report.student_name}, {pc.score}/{pc.max_points}] "
                    f"{pc.feedback[:200]}"
                )

    # Preserve config ordering
    ordered: list[CriterionStats] = []
    for tc in config.tasks:
        for cc in tc.criteria:
            if cc.criterion_id in crit_data:
                ordered.append(crit_data[cc.criterion_id])

    return ordered


def _compute_class_stats(
    parsed_reports: list[ParsedFeedbackReport],
) -> tuple[float, float, int, int]:
    """Compute class-level total score statistics from parsed reports.

    Returns:
        (mean, median, min, max) of total_score across all reports.
    """
    totals = [r.total_score for r in parsed_reports]
    if not totals:
        return 0.0, 0.0, 0, 0
    return mean(totals), median(totals), min(totals), max(totals)


# ---------------------------------------------------------------------------
# Display helpers
# ---------------------------------------------------------------------------

def _display_class_overview(
    num_students: int,
    class_mean: float,
    class_median: float,
    class_min: int,
    class_max: int,
    total_possible: int,
) -> None:
    """Display a summary panel of class-level statistics."""
    pct = (class_mean / total_possible * 100) if total_possible else 0
    content = (
        f"Students: {num_students}  |  "
        f"Mean: {class_mean:.1f}/{total_possible} ({pct:.0f}%)  |  "
        f"Median: {class_median:.1f}  |  "
        f"Range: {class_min}-{class_max}"
    )
    console.print(Panel(content, title="Class Overview", expand=False))


def _display_criterion_stats_table(stats_list: list[CriterionStats]) -> None:
    """Display a table of per-criterion statistics."""
    table = Table(title="Criterion Statistics", show_header=True, header_style="bold")
    table.add_column("Criterion", max_width=40)
    table.add_column("Max", justify="right")
    table.add_column("Mean", justify="right")
    table.add_column("Med", justify="right")
    table.add_column("SD", justify="right")
    table.add_column("%Zero", justify="right")
    table.add_column("%Full", justify="right")

    for cs in stats_list:
        # Color-code based on potential issues
        pct_zero = cs.pct_zero
        zero_style = "red" if pct_zero >= 30 else ("yellow" if pct_zero >= 15 else "")
        full_style = "red" if cs.pct_full <= 5 and cs.max_points > 0 else ""

        table.add_row(
            cs.criterion_name[:40],
            str(cs.max_points),
            f"{cs.mean:.1f}",
            f"{cs.median:.0f}",
            f"{cs.stdev:.1f}",
            f"[{zero_style}]{pct_zero:.0f}%[/{zero_style}]" if zero_style else f"{pct_zero:.0f}%",
            f"[{full_style}]{cs.pct_full:.0f}%[/{full_style}]" if full_style else f"{cs.pct_full:.0f}%",
        )

    console.print(table)


def _display_calibration_report(report: CalibrationReport) -> None:
    """Display the LLM calibration summary and findings."""
    if report.summary:
        console.print()
        console.print(Panel(report.summary, title="Calibration Summary", expand=False))

    if report.findings:
        console.print("\n[bold]NOTABLE FINDINGS[/bold]")
        for f in report.findings:
            icon = {"confusing_question": "?", "grading_inconsistency": "!", "notable_pattern": "*"}.get(
                f.finding_type, "-"
            )
            console.print(f"  [{icon}] [bold]{f.criterion_name}[/bold] ({f.finding_type})")
            console.print(f"      {f.description}")
            if f.recommendation:
                console.print(f"      [dim]Recommendation: {f.recommendation}[/dim]")


# ---------------------------------------------------------------------------
# LLM calibration prompt and call
# ---------------------------------------------------------------------------

CALIBRATION_PROMPT_TEMPLATE = """\
You are an expert instructor reviewing grading patterns for a class of \
{num_students} students on "{quiz_name}".

Below are per-criterion statistics from the grading session. Analyze the \
patterns and propose any adjustments.

{criterion_blocks}

CLASS TOTALS:
  Mean: {class_mean:.1f}/{total_possible}  Median: {class_median:.1f}  \
Range: {class_min}-{class_max}

ANALYSIS INSTRUCTIONS:
1. Identify criteria where the class mean is unusually low — this may \
indicate a confusing question or overly harsh rubric, not just poor student work.
2. Identify students who scored well on approach/SQL criteria but 0 on \
result criteria — this pattern often means correct logic with a minor error.
3. Look for clusters of students making the same mistake — they may \
deserve partial credit if the question was ambiguous.
4. Consider whether the overall class distribution looks reasonable.

Respond with ONLY a JSON object (no markdown fences, no extra text):
{{
  "summary": "<2-3 sentence overview of grading fairness>",
  "rubric_adjustments": [
    {{
      "criterion_id": "<id>",
      "points_change": <positive integer>,
      "rationale": "<why this adjustment is warranted>",
      "affected_count": <number of students who would benefit>
    }}
  ],
  "student_bumps": [
    {{
      "criterion_id": "<id>",
      "student_names": ["<name1>", "<name2>"],
      "current_score": <int>,
      "new_score": <int>,
      "rationale": "<why these specific students deserve a bump>"
    }}
  ],
  "findings": [
    {{
      "finding_type": "confusing_question|grading_inconsistency|notable_pattern",
      "criterion_name": "<name>",
      "description": "<what was observed>",
      "recommendation": "<suggested action>"
    }}
  ]
}}

If no adjustments are needed, return empty arrays. Be conservative — only \
propose changes where the data strongly supports it.\
"""

CRITERION_BLOCK_TEMPLATE = """\
CRITERION: {name} (ID: {cid})
  Max points: {max_points}
  Rubric: {rubric_text}
  Mean: {mean:.1f}  Median: {median:.0f}  SD: {stdev:.1f}  \
Range: {min_score}-{max_score}
  %Zero: {pct_zero:.0f}%  %Full: {pct_full:.0f}%
  Score roster: {score_roster}
  Sample reasoning (lowest/mid/highest):
{sample_reasoning}
"""


def _build_calibration_prompt(
    criterion_stats: list[CriterionStats],
    config: QuizConfig,
    num_students: int,
    class_mean: float,
    class_median: float,
    class_min: int,
    class_max: int,
    total_possible: int,
) -> str:
    """Assemble the full calibration prompt for the LLM."""
    # Build rubric text lookup
    rubric_lookup: dict[str, str] = {}
    for tc in config.tasks:
        for cc in tc.criteria:
            rubric_lookup[cc.criterion_id] = (cc.rubric_text or cc.name)[:500]

    # Build criterion blocks
    blocks = []
    for cs in criterion_stats:
        # Select 3 sample reasoning excerpts: lowest, middle, highest
        samples = _select_sample_reasoning(cs)

        blocks.append(CRITERION_BLOCK_TEMPLATE.format(
            name=cs.criterion_name,
            cid=cs.criterion_id,
            max_points=cs.max_points,
            rubric_text=rubric_lookup.get(cs.criterion_id, cs.criterion_name),
            mean=cs.mean,
            median=cs.median,
            stdev=cs.stdev,
            min_score=cs.min_score,
            max_score=cs.max_score,
            pct_zero=cs.pct_zero,
            pct_full=cs.pct_full,
            score_roster=cs.score_roster(),
            sample_reasoning="\n".join(f"    {s}" for s in samples) or "    (none)",
        ))

    return CALIBRATION_PROMPT_TEMPLATE.format(
        num_students=num_students,
        quiz_name=config.quiz_name,
        criterion_blocks="\n".join(blocks),
        class_mean=class_mean,
        class_median=class_median,
        class_min=class_min,
        class_max=class_max,
        total_possible=total_possible,
    )


def _select_sample_reasoning(cs: CriterionStats) -> list[str]:
    """Pick up to 3 sample reasoning excerpts: lowest, middle, highest scorer."""
    if not cs.sample_reasoning:
        return []

    # Sort by score extracted from the prefix "[Name, score/max]"
    scored_samples: list[tuple[int, str]] = []
    for sample in cs.sample_reasoning:
        try:
            score_part = sample.split(",")[1].strip().split("/")[0].strip().rstrip("]")
            scored_samples.append((int(score_part), sample))
        except (IndexError, ValueError):
            scored_samples.append((0, sample))

    scored_samples.sort(key=lambda x: x[0])

    selected = []
    if scored_samples:
        selected.append(scored_samples[0][1])  # lowest
    if len(scored_samples) >= 3:
        mid_idx = len(scored_samples) // 2
        selected.append(scored_samples[mid_idx][1])  # middle
    if len(scored_samples) >= 2:
        selected.append(scored_samples[-1][1])  # highest

    return selected


def _run_llm_calibration(
    criterion_stats: list[CriterionStats],
    config: QuizConfig,
    all_student_names: set[str],
    num_students: int,
    class_mean: float,
    class_median: float,
    class_min: int,
    class_max: int,
    total_possible: int,
) -> CalibrationReport | None:
    """Call the LLM with calibration prompt and parse the response."""
    backend = select_backend()
    if backend is None:
        console.print("[red]No LLM backend available.[/red]")
        return None

    prompt = _build_calibration_prompt(
        criterion_stats, config,
        num_students, class_mean, class_median, class_min, class_max,
        total_possible,
    )

    with console.status("[bold blue]Running calibration analysis...[/bold blue]"):
        if backend == "cli":
            response_text = _call_cli(prompt)
        else:
            response_text = _call_sdk(prompt)

    if response_text is None:
        return None

    return _parse_calibration_response(
        response_text, criterion_stats, all_student_names,
    )


def _call_cli(prompt: str) -> str | None:
    """Call the Claude CLI with the calibration prompt."""
    cli_env = {k: v for k, v in os.environ.items() if k != "ANTHROPIC_API_KEY"}

    last_error = ""
    for attempt in range(MAX_RETRIES):
        try:
            result = subprocess.run(
                [
                    CLAUDE_CLI,
                    "--print",
                    "--model", CLAUDE_MODEL,
                    "--output-format", "text",
                ],
                input=prompt,
                capture_output=True,
                text=True,
                timeout=CLAUDE_TIMEOUT_SECONDS,
                env=cli_env,
            )

            if result.returncode != 0:
                last_error = result.stderr.strip()[:200]
                logger.warning(
                    "Calibration CLI error (attempt %d/%d): %s",
                    attempt + 1, MAX_RETRIES, last_error,
                )
                if attempt < MAX_RETRIES - 1:
                    backoff = BASE_BACKOFF_SECONDS * (2 ** attempt)
                    jitter = random.uniform(0, MAX_JITTER_SECONDS)
                    time.sleep(backoff + jitter)
                    continue
                console.print(f"[red]CLI error after {MAX_RETRIES} attempts: {last_error}[/red]")
                return None

            output = result.stdout.strip()
            if not output:
                last_error = f"Empty response. stderr: {result.stderr.strip()[:200]}"
                logger.warning(
                    "Calibration CLI returned empty (attempt %d/%d): %s",
                    attempt + 1, MAX_RETRIES, last_error,
                )
                if attempt < MAX_RETRIES - 1:
                    backoff = BASE_BACKOFF_SECONDS * (2 ** attempt)
                    jitter = random.uniform(0, MAX_JITTER_SECONDS)
                    time.sleep(backoff + jitter)
                    continue
                console.print(f"[red]CLI returned empty after {MAX_RETRIES} attempts.[/red]")
                return None

            logger.debug("Calibration CLI raw response (%d chars): %s...", len(output), output[:200])
            return output

        except subprocess.TimeoutExpired:
            logger.warning(
                "Calibration CLI timed out (attempt %d/%d)",
                attempt + 1, MAX_RETRIES,
            )
            if attempt < MAX_RETRIES - 1:
                time.sleep(BASE_BACKOFF_SECONDS * (2 ** attempt))
                continue
            console.print(f"[red]CLI timed out after {MAX_RETRIES} attempts.[/red]")
            return None

    return None


def _call_sdk(prompt: str) -> str | None:
    """Call the Anthropic SDK with the calibration prompt."""
    try:
        import anthropic

        client = anthropic.Anthropic()
        response = client.messages.create(
            model="claude-opus-4-5-20251101",
            max_tokens=2048,
            messages=[{"role": "user", "content": prompt}],
        )
        return response.content[0].text.strip()

    except Exception as exc:
        logger.error("Calibration SDK error: %s", exc)
        console.print(f"[red]SDK error: {exc}[/red]")
        return None


# ---------------------------------------------------------------------------
# Response parsing
# ---------------------------------------------------------------------------

def _extract_json(text: str) -> dict | None:
    """Extract a JSON object from LLM output using multiple strategies.

    LLMs may wrap JSON in markdown fences, add preamble text, or include
    trailing commentary.  This function tries progressively more lenient
    extraction methods:
      1. Direct ``json.loads`` on the stripped text.
      2. Find the outermost ``{ … }`` brace pair and parse that substring.
    """
    stripped = text.strip()

    # Strategy 1: direct parse (ideal case — pure JSON)
    try:
        return json.loads(stripped)
    except (json.JSONDecodeError, TypeError, ValueError):
        pass

    # Strategy 2: locate the outermost { … } in the raw text.
    # This handles markdown fences, preamble text, and trailing commentary.
    first_brace = stripped.find("{")
    last_brace = stripped.rfind("}")
    if first_brace != -1 and last_brace > first_brace:
        candidate = stripped[first_brace : last_brace + 1]
        try:
            return json.loads(candidate)
        except (json.JSONDecodeError, TypeError, ValueError):
            pass

    return None


def _parse_calibration_response(
    response_text: str,
    criterion_stats: list[CriterionStats],
    all_student_names: set[str],
) -> CalibrationReport | None:
    """Parse the LLM JSON response into a CalibrationReport."""
    data = _extract_json(response_text)

    if data is None:
        preview = response_text[:300] if response_text else "(empty)"
        logger.warning(
            "Could not extract JSON from calibration response (%d chars). "
            "Preview: %s",
            len(response_text), preview,
        )
        console.print(
            f"[red]Failed to parse LLM response "
            f"({len(response_text)} chars). "
            f"Preview:[/red]\n{response_text[:300]}"
        )
        return None

    # Build lookup tables for validation
    valid_crit_ids = {cs.criterion_id for cs in criterion_stats}
    crit_name_lookup = {cs.criterion_id: cs.criterion_name for cs in criterion_stats}
    crit_stats_lookup = {cs.criterion_id: cs for cs in criterion_stats}

    report = CalibrationReport(summary=data.get("summary", ""))

    # Parse rubric adjustments
    for adj_data in data.get("rubric_adjustments", []):
        cid = adj_data.get("criterion_id", "")
        if cid not in valid_crit_ids:
            logger.warning("Skipping unknown criterion_id in adjustment: %s", cid)
            continue

        cs = crit_stats_lookup[cid]
        points_change = adj_data.get("points_change", 0)
        if not isinstance(points_change, int) or points_change <= 0:
            continue

        # Count how many students would benefit (those not already at max)
        affected = sum(1 for s in cs.scores if s + points_change <= cs.max_points and s < cs.max_points)

        report.rubric_adjustments.append(RubricAdjustment(
            criterion_id=cid,
            criterion_name=crit_name_lookup[cid],
            points_change=points_change,
            rationale=adj_data.get("rationale", ""),
            current_mean=cs.mean,
            projected_mean=min(cs.mean + points_change, cs.max_points),
            affected_count=adj_data.get("affected_count", affected),
        ))

    # Parse student bumps
    for bump_data in data.get("student_bumps", []):
        cid = bump_data.get("criterion_id", "")
        if cid not in valid_crit_ids:
            logger.warning("Skipping unknown criterion_id in bump: %s", cid)
            continue

        # Validate student names against report names (not just session)
        proposed_names = bump_data.get("student_names", [])
        valid_names = [n for n in proposed_names if n in all_student_names]
        if not valid_names:
            logger.warning("No valid student names in bump for %s", cid)
            continue

        dropped = set(proposed_names) - set(valid_names)
        if dropped:
            logger.info("Dropped unknown student names from bump: %s", dropped)

        new_score = bump_data.get("new_score", 0)
        if not isinstance(new_score, int):
            try:
                new_score = int(new_score)
            except (ValueError, TypeError):
                continue

        report.student_bumps.append(StudentBump(
            criterion_id=cid,
            criterion_name=crit_name_lookup[cid],
            student_names=valid_names,
            current_score=bump_data.get("current_score", 0),
            new_score=new_score,
            rationale=bump_data.get("rationale", ""),
        ))

    # Parse findings
    for finding_data in data.get("findings", []):
        report.findings.append(CalibrationFinding(
            finding_type=finding_data.get("finding_type", "notable_pattern"),
            criterion_name=finding_data.get("criterion_name", ""),
            description=finding_data.get("description", ""),
            recommendation=finding_data.get("recommendation", ""),
        ))

    return report


# ---------------------------------------------------------------------------
# Instructor review UI
# ---------------------------------------------------------------------------

def _review_single_rubric_adjustment(adj: RubricAdjustment) -> bool:
    """Present a rubric adjustment to the instructor for accept/modify/reject.

    Returns True if the adjustment was accepted (possibly modified).
    """
    content = (
        f"Criterion: {adj.criterion_name}\n"
        f"Proposed: +{adj.points_change} points to all students\n"
        f"Current mean: {adj.current_mean:.1f} -> "
        f"Projected: {adj.projected_mean:.1f}\n"
        f"Affects: {adj.affected_count} students\n"
        f"Rationale: {adj.rationale}"
    )
    console.print()
    console.print(Panel(content, title="Rubric Adjustment", expand=False))

    choice = Prompt.ask(
        "  [a]ccept / [m]odify / [r]eject",
        choices=["a", "m", "r"],
        default="r",
    )

    if choice == "a":
        return True
    elif choice == "m":
        new_val = Prompt.ask(
            f"  Points to add (1-{adj.points_change * 2})",
            default=str(adj.points_change),
        )
        try:
            adj.points_change = max(1, int(new_val))
        except ValueError:
            console.print("[red]Invalid number. Keeping original.[/red]")
        return True
    else:
        console.print("[dim]Rejected.[/dim]")
        return False


def _review_single_student_bump(bump: StudentBump) -> list[str]:
    """Present a student bump to the instructor for accept/pick/reject.

    Returns the list of accepted student names (empty = rejected).
    """
    content = (
        f"Criterion: {bump.criterion_name}\n"
        f"Pattern: Got {bump.current_score} but proposed -> {bump.new_score}\n"
        f"Students: {', '.join(bump.student_names)}\n"
        f"Rationale: {bump.rationale}"
    )
    console.print()
    console.print(Panel(content, title="Student Bump", expand=False))

    choice = Prompt.ask(
        "  [a]ccept all / [p]ick students / [r]eject",
        choices=["a", "p", "r"],
        default="r",
    )

    if choice == "a":
        return bump.student_names
    elif choice == "p":
        accepted = []
        for name in bump.student_names:
            include = Prompt.ask(f"  Include {name}?", choices=["y", "n"], default="y")
            if include == "y":
                accepted.append(name)
        return accepted
    else:
        console.print("[dim]Rejected.[/dim]")
        return []


# ---------------------------------------------------------------------------
# Score application
# ---------------------------------------------------------------------------

def _apply_rubric_adjustment(
    session: GradingSession,
    config: QuizConfig,
    adj: RubricAdjustment,
) -> None:
    """Apply a rubric-wide point adjustment to all students on a criterion.

    Creates Override records and recalculates totals.
    """
    max_points = _get_criterion_max(config, adj.criterion_id)

    for report in session.grade_reports:
        for tg in report.task_grades:
            for cr in tg.criteria_results:
                if cr.criterion_id == adj.criterion_id:
                    old_score = cr.score
                    new_score = min(old_score + adj.points_change, max_points)
                    if new_score != old_score:
                        override = Override(
                            criterion_id=adj.criterion_id,
                            original_score=old_score,
                            new_score=new_score,
                            reason=f"Calibration rubric adjustment: +{adj.points_change} "
                                   f"({adj.rationale[:100]})",
                        )
                        report.overrides.append(override)
                        cr.score = new_score

        # Recalculate totals
        _recalculate_totals(report)


def _apply_student_bump(
    session: GradingSession,
    config: QuizConfig,
    bump: StudentBump,
) -> None:
    """Apply a score bump for specific students on a criterion.

    Creates Override records and recalculates totals.
    """
    max_points = _get_criterion_max(config, bump.criterion_id)
    target_names = set(bump.student_names)

    for report in session.grade_reports:
        if report.student_name not in target_names:
            continue

        for tg in report.task_grades:
            for cr in tg.criteria_results:
                if cr.criterion_id == bump.criterion_id:
                    old_score = cr.score
                    new_score = min(max(bump.new_score, 0), max_points)
                    if new_score != old_score:
                        override = Override(
                            criterion_id=bump.criterion_id,
                            original_score=old_score,
                            new_score=new_score,
                            reason=f"Calibration student bump: {old_score}->{new_score} "
                                   f"({bump.rationale[:100]})",
                        )
                        report.overrides.append(override)
                        cr.score = new_score

        _recalculate_totals(report)


def _recalculate_totals(report) -> None:
    """Recalculate task_score/task_max/total_score/total_max after adjustment."""
    for tg in report.task_grades:
        tg.task_score = sum(cr.score for cr in tg.criteria_results)
        tg.task_max = sum(cr.max_points for cr in tg.criteria_results)

    report.total_score = sum(tg.task_score for tg in report.task_grades)
    report.total_max = sum(tg.task_max for tg in report.task_grades)


def _get_criterion_max(config: QuizConfig, criterion_id: str) -> int:
    """Look up the max points for a criterion from the config."""
    for tc in config.tasks:
        for cc in tc.criteria:
            if cc.criterion_id == criterion_id:
                return cc.points
    return 0


# ---------------------------------------------------------------------------
# Report re-export after adjustments
# ---------------------------------------------------------------------------

def _re_export_affected_reports(
    session: GradingSession,
    config: QuizConfig,
    output_path: Path,
) -> None:
    """Re-export feedback reports for students who have Override records.

    After calibration applies adjustments (stored as Overrides on the
    session), the on-disk markdown reports become stale.  This function
    re-renders and overwrites only the affected reports.
    """
    from .reporter import export_single_student_report

    affected = [r for r in session.grade_reports if r.overrides]
    if not affected:
        return

    for report in affected:
        md_path = export_single_student_report(report, config, output_path)
        console.print(f"  [dim]Re-exported: {md_path.name}[/dim]")

    console.print(
        f"[green]{len(affected)} report(s) re-exported with adjustments.[/green]"
    )
