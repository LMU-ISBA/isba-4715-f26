"""Interactive terminal reviewer for graded quiz submissions.

Presents each student's grade report in a Rich-powered TUI and accepts
instructor actions: accept, override, feedback, view SQL, skip, or quit.
Session state is persisted to JSON after every action for crash-safe resume.
"""

import json
from dataclasses import asdict
from datetime import datetime
from pathlib import Path
from typing import Optional

from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt
from rich.syntax import Syntax
from rich.table import Table
from rich.text import Text

from .models import (
    CriterionResult,
    GradeReport,
    GradingSession,
    Override,
    ParsedSubmission,
    QuizConfig,
    Submission,
    TaskContent,
    TaskGrade,
)
from .reporter import export_single_student_report

console = Console()


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def review_one_student(
    report: GradeReport,
    idx: int,
    total: int,
    session: GradingSession,
    config: QuizConfig,
    output_path: Path,
) -> str:
    """Review a single student's grade report interactively.

    Extracts the per-student display + action loop from ``run_review()``
    so that it can be called from the interleaved grading workflow.

    Args:
        report: The grade report to review.
        idx: Zero-based index of this student in the session.
        total: Total number of students.
        session: The parent grading session (for SQL view and persistence).
        config: Quiz configuration for task/criterion metadata.
        output_path: Directory tree root for session state files.

    Returns:
        Action string: ``"next"`` (accepted or skipped — advance),
        or ``"quit"`` (instructor quit early).
    """
    task_lookup = {t.task_id: t for t in config.tasks}

    crit_name_lookup: dict[str, str] = {}
    for tc in config.tasks:
        for cc in tc.criteria:
            crit_name_lookup[cc.criterion_id] = cc.name

    while True:
        _display_header(report, idx, total)
        _display_score_table(report, task_lookup, crit_name_lookup)

        pct = (report.total_score / report.total_max * 100) if report.total_max else 0
        console.print(
            f"\n  Total: [bold]{report.total_score}[/bold] / "
            f"{report.total_max}  ({pct:.0f}%)\n"
        )

        _display_flags(report, crit_name_lookup)
        _display_feedback_preview(report, crit_name_lookup)

        console.print(
            "  [dim]a[/dim]=accept  [dim]o[/dim]=override  "
            "[dim]f[/dim]=feedback  [dim]v[/dim]=view SQL  "
            "[dim]s[/dim]=skip  [dim]q[/dim]=quit"
        )
        action = Prompt.ask(
            "[bold]Action[/bold]",
            choices=["a", "o", "f", "v", "s", "q"],
            default="a",
        )

        if action == "a":
            report.reviewed = True
            report.reviewed_at = datetime.now()
            session.students_reviewed += 1
            session.current_index = idx + 1
            session.last_updated = datetime.now()
            save_session(session, output_path)
            md_path = export_single_student_report(report, config, output_path)
            console.print(f"  [dim]Report → {md_path}[/dim]")
            return "next"

        elif action == "o":
            _handle_override(report, crit_name_lookup, task_lookup)
            session.last_updated = datetime.now()
            save_session(session, output_path)
            continue

        elif action == "f":
            notes = Prompt.ask("Instructor notes")
            report.instructor_notes = notes
            console.print("[dim]Notes saved.[/dim]\n")
            session.last_updated = datetime.now()
            save_session(session, output_path)
            continue

        elif action == "v":
            _display_sql(report, session, config)
            continue

        elif action == "s":
            session.current_index = idx + 1
            session.last_updated = datetime.now()
            save_session(session, output_path)
            return "next"

        elif action == "q":
            session.current_index = idx
            session.last_updated = datetime.now()
            save_session(session, output_path)
            console.print("[yellow]Session saved. Use --resume to continue.[/yellow]")
            return "quit"


def run_review(session: GradingSession, config: QuizConfig, output_path: Path) -> int:
    """Run the interactive review loop.

    Displays each student's grade report and accepts instructor actions.
    Auto-saves after every action.

    Args:
        session: The grading session (may be partially reviewed).
        config: Quiz configuration for task/criterion metadata.
        output_path: Directory tree root for session state files.

    Returns:
        0 if all students were reviewed, 1 if the instructor quit early.
    """
    # Build a lookup from task_id -> TaskConfig for display labels
    task_lookup = {t.task_id: t for t in config.tasks}

    # Build criterion name lookup: criterion_id -> criterion name
    crit_name_lookup: dict[str, str] = {}
    for tc in config.tasks:
        for cc in tc.criteria:
            crit_name_lookup[cc.criterion_id] = cc.name

    total = len(session.grade_reports)

    try:
        idx = session.current_index
        while idx < total:
            report = session.grade_reports[idx]

            # --- Student header ---
            _display_header(report, idx, total)

            # --- Score table ---
            _display_score_table(report, task_lookup, crit_name_lookup)

            # --- Total ---
            pct = (report.total_score / report.total_max * 100) if report.total_max else 0
            console.print(
                f"\n  Total: [bold]{report.total_score}[/bold] / "
                f"{report.total_max}  ({pct:.0f}%)\n"
            )

            # --- Flagged items ---
            _display_flags(report, crit_name_lookup)

            # --- Student feedback preview ---
            _display_feedback_preview(report, crit_name_lookup)

            # --- Action prompt ---
            console.print(
                "  [dim]a[/dim]=accept  [dim]o[/dim]=override  "
                "[dim]f[/dim]=feedback  [dim]v[/dim]=view SQL  "
                "[dim]s[/dim]=skip  [dim]q[/dim]=quit"
            )
            action = Prompt.ask(
                "[bold]Action[/bold]",
                choices=["a", "o", "f", "v", "s", "q"],
                default="a",
            )

            if action == "a":
                report.reviewed = True
                report.reviewed_at = datetime.now()
                session.students_reviewed += 1
                md_path = export_single_student_report(report, config, output_path)
                console.print(f"  [dim]Report → {md_path}[/dim]")
                idx += 1

            elif action == "o":
                _handle_override(report, crit_name_lookup, task_lookup)
                # Re-display after override; don't advance
                session.last_updated = datetime.now()
                save_session(session, output_path)
                continue

            elif action == "f":
                notes = Prompt.ask("Instructor notes")
                report.instructor_notes = notes
                console.print("[dim]Notes saved.[/dim]\n")

                # Don't advance — let instructor take another action
                session.last_updated = datetime.now()
                save_session(session, output_path)
                continue

            elif action == "v":
                _display_sql(report, session, config)
                # Don't advance — let instructor take another action
                continue

            elif action == "s":
                idx += 1

            elif action == "q":
                session.current_index = idx
                session.last_updated = datetime.now()
                save_session(session, output_path)
                console.print("[yellow]Session saved. Use --resume to continue.[/yellow]")
                return 1

            # Update index and auto-save
            session.current_index = idx
            session.last_updated = datetime.now()
            save_session(session, output_path)

    except KeyboardInterrupt:
        session.current_index = idx
        session.last_updated = datetime.now()
        save_session(session, output_path)
        console.print(
            "\n[yellow]Interrupted. Session saved. Use --resume to continue.[/yellow]"
        )
        return 1

    session.status = "completed"
    session.last_updated = datetime.now()
    save_session(session, output_path)
    console.print("[green]All students reviewed. Session complete.[/green]")
    return 0


# ---------------------------------------------------------------------------
# Session persistence
# ---------------------------------------------------------------------------

def load_session(quiz_id: str, output_path: Path) -> Optional[GradingSession]:
    """Load a previously saved grading session from JSON.

    Args:
        quiz_id: The quiz identifier used in the filename.
        output_path: Root output directory containing the ``state/`` subdirectory.

    Returns:
        Reconstructed GradingSession, or None if no session file exists.
    """
    path = output_path / "state" / f"{quiz_id}-session.json"
    if not path.exists():
        return None

    with open(path, "r") as f:
        data = json.load(f)

    return _session_from_dict(data)


def save_session(session: GradingSession, output_path: Path) -> None:
    """Save the current grading session to JSON.

    Args:
        session: The session to persist.
        output_path: Root output directory; writes to ``state/<quiz_id>-session.json``.
    """
    state_dir = output_path / "state"
    state_dir.mkdir(parents=True, exist_ok=True)

    path = state_dir / f"{session.quiz_id}-session.json"
    data = _session_to_dict(session)

    with open(path, "w") as f:
        json.dump(data, f, indent=2)


# ---------------------------------------------------------------------------
# Serialization helpers
# ---------------------------------------------------------------------------

def _session_to_dict(session: GradingSession) -> dict:
    """Convert GradingSession to a JSON-serializable dict.

    Datetime values are converted to ISO 8601 strings.  All other fields
    are handled by ``dataclasses.asdict()``.
    """
    data = asdict(session)
    _convert_datetimes_to_str(data)
    return data


def _session_from_dict(data: dict) -> GradingSession:
    """Reconstruct a GradingSession from a dict loaded from JSON.

    ISO 8601 datetime strings are parsed back into datetime objects.
    Nested dataclass structures are rebuilt manually.
    """
    grade_reports = []
    for report_data in data.get("grade_reports", []):
        # Rebuild Submission
        sub_data = report_data["submission"]
        submission = Submission(
            student_name=sub_data["student_name"],
            file_path=sub_data["file_path"],
            submitted_at=_parse_dt(sub_data.get("submitted_at")),
            is_duplicate=sub_data.get("is_duplicate", False),
        )

        # Rebuild TaskGrades
        task_grades = []
        for tg_data in report_data.get("task_grades", []):
            criteria_results = [
                CriterionResult(
                    criterion_id=cr["criterion_id"],
                    score=cr["score"],
                    max_points=cr["max_points"],
                    source=cr["source"],
                    details=cr.get("details", ""),
                    confidence=cr.get("confidence", "deterministic"),
                    feedback=cr.get("feedback", ""),
                    flagged=cr.get("flagged", False),
                    flag_reason=cr.get("flag_reason", ""),
                )
                for cr in tg_data.get("criteria_results", [])
            ]
            task_grades.append(
                TaskGrade(
                    task_id=tg_data["task_id"],
                    criteria_results=criteria_results,
                    task_score=tg_data.get("task_score", 0),
                    task_max=tg_data.get("task_max", 0),
                )
            )

        # Rebuild Overrides
        overrides = [
            Override(
                criterion_id=ov["criterion_id"],
                original_score=ov["original_score"],
                new_score=ov["new_score"],
                reason=ov.get("reason", ""),
            )
            for ov in report_data.get("overrides", [])
        ]

        grade_reports.append(
            GradeReport(
                student_name=report_data["student_name"],
                submission=submission,
                task_grades=task_grades,
                total_score=report_data.get("total_score", 0),
                total_max=report_data.get("total_max", 0),
                instructor_notes=report_data.get("instructor_notes", ""),
                reviewed=report_data.get("reviewed", False),
                reviewed_at=_parse_dt(report_data.get("reviewed_at")),
                overrides=overrides,
            )
        )

    return GradingSession(
        session_id=data["session_id"],
        quiz_id=data["quiz_id"],
        config_path=data.get("config_path", ""),
        started_at=_parse_dt(data["started_at"]) or datetime.now(),
        last_updated=_parse_dt(data["last_updated"]) or datetime.now(),
        status=data.get("status", "in_progress"),
        students_total=data.get("students_total", 0),
        students_reviewed=data.get("students_reviewed", 0),
        current_index=data.get("current_index", 0),
        grade_reports=grade_reports,
    )


def _convert_datetimes_to_str(obj):
    """Recursively convert datetime values in a nested dict/list to ISO strings."""
    if isinstance(obj, dict):
        for key, value in obj.items():
            if isinstance(value, datetime):
                obj[key] = value.isoformat()
            elif isinstance(value, (dict, list)):
                _convert_datetimes_to_str(value)
    elif isinstance(obj, list):
        for i, item in enumerate(obj):
            if isinstance(item, datetime):
                obj[i] = item.isoformat()
            elif isinstance(item, (dict, list)):
                _convert_datetimes_to_str(item)


def _parse_dt(value) -> Optional[datetime]:
    """Parse an ISO 8601 string to datetime, or return None."""
    if value is None:
        return None
    if isinstance(value, datetime):
        return value
    return datetime.fromisoformat(value)


# ---------------------------------------------------------------------------
# Score recalculation
# ---------------------------------------------------------------------------

def _recalculate_totals(report: GradeReport) -> None:
    """Recalculate task_score/task_max/total_score/total_max after an override."""
    for tg in report.task_grades:
        tg.task_score = sum(cr.score for cr in tg.criteria_results)
        tg.task_max = sum(cr.max_points for cr in tg.criteria_results)

    report.total_score = sum(tg.task_score for tg in report.task_grades)
    report.total_max = sum(tg.task_max for tg in report.task_grades)


# ---------------------------------------------------------------------------
# Display helpers
# ---------------------------------------------------------------------------

def _display_header(report: GradeReport, idx: int, total: int) -> None:
    """Display the student header panel."""
    status = "[green]Reviewed[/green]" if report.reviewed else "[dim]Pending[/dim]"
    submitted = (
        report.submission.submitted_at.strftime("%Y-%m-%d %H:%M")
        if report.submission.submitted_at
        else "unknown"
    )

    header_text = (
        f"Student {idx + 1} of {total}  |  Status: {status}\n"
        f"Submitted: {submitted}"
    )
    console.print()
    console.print(Panel(header_text, title=report.student_name, expand=False))


def _display_score_table(
    report: GradeReport,
    task_lookup: dict,
    crit_name_lookup: dict[str, str],
) -> None:
    """Render the score table with conditional styling."""
    table = Table(show_header=True, header_style="bold")
    table.add_column("Task", style="cyan", no_wrap=True)
    table.add_column("Criterion")
    table.add_column("Score", justify="right")
    table.add_column("Source", justify="center")
    table.add_column("Details")

    for tg in report.task_grades:
        task_cfg = task_lookup.get(tg.task_id)
        task_label = task_cfg.task_name if task_cfg else tg.task_id

        for i, cr in enumerate(tg.criteria_results):
            # Only show the task label on the first criterion row
            row_task = task_label if i == 0 else ""

            # Score styling
            score_text = f"{cr.score}/{cr.max_points}"
            if cr.score == cr.max_points and cr.max_points > 0:
                score_style = "green"
            elif cr.score == 0:
                score_style = "red"
            else:
                score_style = "yellow"

            # Criterion name
            crit_label = crit_name_lookup.get(cr.criterion_id, cr.criterion_id)
            if cr.flagged:
                crit_label = f"[bold]{crit_label}[/bold]"

            # Details (truncate long text for table readability)
            details = cr.details
            if len(details) > 60:
                details = details[:57] + "..."

            table.add_row(
                row_task,
                crit_label,
                f"[{score_style}]{score_text}[/{score_style}]",
                cr.source,
                details,
            )

    console.print(table)


def _display_flags(report: GradeReport, crit_name_lookup: dict[str, str]) -> None:
    """Show a summary of flagged items, if any."""
    flagged = []
    for tg in report.task_grades:
        for cr in tg.criteria_results:
            if cr.flagged:
                name = crit_name_lookup.get(cr.criterion_id, cr.criterion_id)
                flagged.append((name, cr.flag_reason))

    if not flagged:
        return

    console.print(f"  [bold red]Flagged items ({len(flagged)}):[/bold red]")
    for name, reason in flagged:
        text = Text()
        text.append(f"    - {name}", style="bold")
        if reason:
            text.append(f": {reason}")
        console.print(text)
    console.print()


def _display_feedback_preview(
    report: GradeReport,
    crit_name_lookup: dict[str, str],
) -> None:
    """Show AI-generated student feedback for criteria that have it.

    Only displays criteria where ``cr.feedback`` is non-empty (typically
    LLM-graded subjective criteria).  This lets the instructor see exactly
    what the student will read before accepting the grade.
    """
    items: list[tuple[str, str]] = []
    for tg in report.task_grades:
        for cr in tg.criteria_results:
            if cr.feedback:
                name = crit_name_lookup.get(cr.criterion_id, cr.criterion_id)
                items.append((name, cr.feedback))

    if not items:
        return

    console.print(f"  [bold blue]Student feedback preview ({len(items)}):[/bold blue]")
    for name, feedback in items:
        console.print(f"    [cyan]{name}:[/cyan] {feedback}")
    console.print()


def _display_sql(
    report: GradeReport,
    session: GradingSession,
    config: QuizConfig,
) -> None:
    """Display the student's raw SQL for each task with syntax highlighting.

    Reads the submission file and displays its content.  If the file cannot
    be read, a warning is shown instead.
    """
    file_path = Path(report.submission.file_path)
    if not file_path.exists():
        console.print(f"[red]File not found: {file_path}[/red]")
        return

    try:
        content = file_path.read_text(encoding="utf-8")
    except OSError as e:
        console.print(f"[red]Error reading file: {e}[/red]")
        return

    console.print()
    syntax = Syntax(
        content,
        "sql",
        theme="monokai",
        line_numbers=True,
        word_wrap=True,
    )
    console.print(Panel(syntax, title=f"SQL: {report.student_name}", expand=True))
    console.print()


# ---------------------------------------------------------------------------
# Action handlers
# ---------------------------------------------------------------------------

def _handle_override(
    report: GradeReport,
    crit_name_lookup: dict[str, str],
    task_lookup: dict,
) -> None:
    """Walk the instructor through overriding a criterion score."""
    # Flatten all criteria into a numbered list
    all_criteria: list[tuple[str, CriterionResult]] = []
    for tg in report.task_grades:
        task_cfg = task_lookup.get(tg.task_id)
        task_label = task_cfg.task_name if task_cfg else tg.task_id
        for cr in tg.criteria_results:
            crit_label = crit_name_lookup.get(cr.criterion_id, cr.criterion_id)
            all_criteria.append((f"{task_label} > {crit_label}", cr))

    # Display numbered list
    console.print("\n[bold]Criteria:[/bold]")
    for i, (label, cr) in enumerate(all_criteria, 1):
        console.print(f"  {i}. {label}  ({cr.score}/{cr.max_points})")

    # Ask which criterion
    choice = Prompt.ask("Criterion number", default="1")
    try:
        idx = int(choice) - 1
        if idx < 0 or idx >= len(all_criteria):
            console.print("[red]Invalid criterion number.[/red]")
            return
    except ValueError:
        console.print("[red]Invalid input.[/red]")
        return

    label, cr = all_criteria[idx]

    # Ask new score
    new_score_str = Prompt.ask(f"New score (0-{cr.max_points})", default=str(cr.score))
    try:
        new_score = int(new_score_str)
        if new_score < 0 or new_score > cr.max_points:
            console.print(f"[red]Score must be between 0 and {cr.max_points}.[/red]")
            return
    except ValueError:
        console.print("[red]Invalid score.[/red]")
        return

    # Ask reason
    reason = Prompt.ask("Reason for override", default="")

    # Record override
    override = Override(
        criterion_id=cr.criterion_id,
        original_score=cr.score,
        new_score=new_score,
        reason=reason,
    )
    report.overrides.append(override)

    # Apply the score change
    cr.score = new_score
    cr.source = "manual"
    if reason:
        cr.details = f"Override: {reason}"

    # Recalculate totals
    _recalculate_totals(report)

    console.print(f"[green]Updated {label}: {override.original_score} -> {new_score}[/green]")

    # Re-display the table
    _display_score_table(report, task_lookup, crit_name_lookup)

    pct = (report.total_score / report.total_max * 100) if report.total_max else 0
    console.print(
        f"\n  Total: [bold]{report.total_score}[/bold] / "
        f"{report.total_max}  ({pct:.0f}%)\n"
    )
