"""LLM-based subjective grading module.

Uses the Claude Code CLI (``claude --print``) to score criteria with
type == "subjective".  No API key is required — this piggybacks on the
user's existing Claude Code subscription.

The rubric + student work are combined into a single prompt and piped
to ``claude -p --model claude-opus-4-5-20251101 --output-format text``.  The structured
JSON response is parsed into CriterionResult objects.

After grading, the ``feedback`` field is passed through a humanizer step
(also via ``claude --print`` with opus) to remove signs of AI-generated
writing before it reaches students.

Falls back to the Anthropic Python SDK when ANTHROPIC_API_KEY is set
(for headless / CI environments without Claude Code installed).
"""

import json
import logging
import os
import random
import shutil
import subprocess
import time

from .models import (
    CriterionConfig,
    CriterionResult,
    ParsedSubmission,
    QuizConfig,
    TaskContent,
)

logger = logging.getLogger(__name__)

# Claude Code CLI settings
CLAUDE_CLI = "claude"
CLAUDE_MODEL = "claude-opus-4-5-20251101"  # highest quality for grading accuracy
CLAUDE_TIMEOUT_SECONDS = 120

# Anthropic SDK fallback settings (only used when ANTHROPIC_API_KEY is set)
SDK_MODEL = "claude-opus-4-5-20251101"
SDK_MAX_TOKENS = 1024
MAX_RETRIES = 3
BASE_BACKOFF_SECONDS = 1.0
MAX_JITTER_SECONDS = 0.5

# Humanizer settings
HUMANIZER_MODEL = "claude-opus-4-5-20251101"  # same model for consistent voice
HUMANIZER_TIMEOUT_SECONDS = 90

HUMANIZER_PROMPT = """\
You are editing feedback text written by an AI grader so it reads like a \
real college instructor wrote it. Rewrite the text below, applying ALL of \
these rules:

1. Replace AI vocabulary: "delve", "leverage", "utilize", "robust", \
"streamline", "foster", "comprehensive", "pivotal", "innovative", \
"facilitate", "enhance", "crucial", "optimal" — use plain words instead.
2. Remove em dash (—) overuse — rewrite with commas, periods, or \
parentheses.
3. Break the "rule of three" pattern (listing exactly three items in \
parallel). Use two, four, or rephrase.
4. Remove promotional or inflated language ("excellent work", \
"demonstrates a strong understanding", "well-crafted").
5. Cut filler conjunctive phrases ("Moreover", "Furthermore", \
"Additionally", "It is worth noting that", "In conclusion").
6. Replace vague attributions ("many experts agree", "it is widely \
known") with direct statements.
7. Keep the same meaning, same score justification, same constructive \
advice.
8. Write in a direct, casual-professional tone — like a real instructor \
jotting feedback on a paper.
9. Keep it concise — aim for roughly the same length or shorter.

TEXT TO HUMANIZE:
{feedback_text}

Return ONLY the rewritten feedback text. No preamble, no explanation.\
"""

PROMPT_TEMPLATE = """\
You are an expert SQL instructor grading student work. Score the following \
student submission based on this rubric.

RUBRIC:
{rubric_text}

SCORING INSTRUCTIONS:
- Score must be an integer from 0 to {max_points}
- Provide your reasoning BEFORE deciding the score
- Follow the rubric criteria. When in doubt, give the student the benefit of the doubt.
- If the student's work is blank or missing, score 0

STUDENT SUBMISSION:
{student_work}

Respond with ONLY a JSON object (no markdown, no extra text):
{{"score": <integer 0-{max_points}>, "confidence": "high|medium|low", \
"reasoning": "<your analysis>", "feedback": "<constructive feedback for student>"}}\
"""

JSON_SCHEMA = json.dumps({
    "type": "object",
    "properties": {
        "score": {"type": "integer"},
        "confidence": {"type": "string", "enum": ["high", "medium", "low"]},
        "reasoning": {"type": "string"},
        "feedback": {"type": "string"},
    },
    "required": ["score", "confidence", "reasoning", "feedback"],
})


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def score_subjective(
    parsed: ParsedSubmission,
    config: QuizConfig,
    progress_callback=None,
) -> dict[str, list[CriterionResult]]:
    """Score all criteria using Claude (LLM-only grading pipeline).

    Every criterion — regardless of its ``type`` field in the YAML config —
    is evaluated by the LLM.  This allows the AI to assess both technique
    usage and reasoning quality holistically.

    Tries the Claude Code CLI first (no API key needed).  If the CLI is not
    installed, falls back to the Anthropic Python SDK (requires
    ``ANTHROPIC_API_KEY``).  If neither is available, returns skipped results.

    Args:
        parsed: The student's parsed submission containing task content.
        config: The quiz configuration with tasks and criteria definitions.
        progress_callback: Optional callable invoked after each criterion is
            scored, receiving the number of criteria completed so far.

    Returns:
        A dict mapping ``task_id`` to a list of ``CriterionResult`` objects.
    """
    # Determine which backend to use
    backend = select_backend()
    if backend is None:
        logger.warning("No LLM backend available. Skipping all grading.")
        return _skip_all(config)

    task_content_map: dict[str, TaskContent] = {
        tc.task_id: tc for tc in parsed.tasks
    }

    results: dict[str, list[CriterionResult]] = {}
    criteria_done = 0

    for task in config.tasks:
        if not task.criteria:
            continue

        task_content = task_content_map.get(task.task_id)
        task_results: list[CriterionResult] = []

        for criterion in task.criteria:
            if task_content is None or _is_empty_content(task_content):
                task_results.append(
                    CriterionResult(
                        criterion_id=criterion.criterion_id,
                        score=0,
                        max_points=criterion.points,
                        source="llm",
                        details="No student content to evaluate",
                    )
                )
                criteria_done += 1
                if progress_callback:
                    progress_callback(criteria_done)
                continue

            logger.info(
                "Grading criterion %s for student %s via %s",
                criterion.criterion_id,
                parsed.submission.student_name,
                backend,
            )

            if backend == "cli":
                result = _call_claude_cli(criterion, task_content)
            else:
                result = _call_anthropic_sdk(criterion, task_content)

            # Humanize the feedback so it reads like a real instructor wrote it
            if result.feedback and result.source == "llm":
                result.feedback = _humanize_feedback(result.feedback, backend)

            task_results.append(result)
            criteria_done += 1
            if progress_callback:
                progress_callback(criteria_done)

        if task_results:
            results[task.task_id] = task_results

    return results


# ---------------------------------------------------------------------------
# Backend selection
# ---------------------------------------------------------------------------

def select_backend() -> str | None:
    """Choose the best available LLM backend.

    Returns:
        ``"cli"`` if Claude Code CLI is installed,
        ``"sdk"`` if ANTHROPIC_API_KEY is set,
        or ``None`` if neither is available.
    """
    if shutil.which(CLAUDE_CLI):
        return "cli"
    if os.environ.get("ANTHROPIC_API_KEY"):
        return "sdk"
    return None


# ---------------------------------------------------------------------------
# Claude Code CLI backend
# ---------------------------------------------------------------------------

def _call_claude_cli(
    criterion: CriterionConfig,
    task_content: TaskContent,
) -> CriterionResult:
    """Grade a single criterion by piping a prompt to ``claude --print``.

    The prompt is passed via stdin (not as a CLI argument) to avoid
    shell argument length limits and to ensure the CLI reads input
    correctly without blocking.

    Retries up to ``MAX_RETRIES`` times on transient failures (non-zero
    exit code) with exponential backoff.
    """
    rubric_text = criterion.rubric_text or criterion.name
    student_work = _build_user_message(task_content)
    prompt = PROMPT_TEMPLATE.format(
        rubric_text=rubric_text,
        max_points=criterion.points,
        student_work=student_work,
    )

    # Strip ANTHROPIC_API_KEY from the child environment so the CLI
    # uses subscription auth instead of a potentially invalid API key
    # (the .env file may contain a placeholder value).
    cli_env = {k: v for k, v in os.environ.items() if k != "ANTHROPIC_API_KEY"}

    last_error_detail = ""
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
                error_info = result.stderr.strip() or result.stdout.strip()
                last_error_detail = error_info[:200]
                logger.warning(
                    "claude CLI error for criterion %s (attempt %d/%d, "
                    "rc=%d): %s",
                    criterion.criterion_id,
                    attempt + 1,
                    MAX_RETRIES,
                    result.returncode,
                    error_info[:300],
                )
                if attempt < MAX_RETRIES - 1:
                    backoff = BASE_BACKOFF_SECONDS * (2 ** attempt)
                    jitter = random.uniform(0, MAX_JITTER_SECONDS)
                    time.sleep(backoff + jitter)
                    continue
                return CriterionResult(
                    criterion_id=criterion.criterion_id,
                    score=0,
                    max_points=criterion.points,
                    source="skipped",
                    details=f"CLI error after {MAX_RETRIES} attempts: {last_error_detail}",
                    flagged=True,
                    flag_reason="Claude CLI error",
                )

            response_text = result.stdout.strip()
            return _parse_llm_response(response_text, criterion)

        except subprocess.TimeoutExpired:
            last_error_detail = f"timed out after {CLAUDE_TIMEOUT_SECONDS}s"
            logger.warning(
                "claude CLI timed out for criterion %s (attempt %d/%d)",
                criterion.criterion_id,
                attempt + 1,
                MAX_RETRIES,
            )
            if attempt < MAX_RETRIES - 1:
                backoff = BASE_BACKOFF_SECONDS * (2 ** attempt)
                time.sleep(backoff)
                continue
            return CriterionResult(
                criterion_id=criterion.criterion_id,
                score=0,
                max_points=criterion.points,
                source="skipped",
                details=f"CLI timed out after {MAX_RETRIES} attempts",
                flagged=True,
                flag_reason="Claude CLI timeout",
            )
        except FileNotFoundError:
            logger.error("claude CLI not found on PATH")
            return CriterionResult(
                criterion_id=criterion.criterion_id,
                score=0,
                max_points=criterion.points,
                source="skipped",
                details="claude CLI not found",
                flagged=True,
                flag_reason="Claude CLI not installed",
            )

    # Should not reach here, but just in case
    return CriterionResult(
        criterion_id=criterion.criterion_id,
        score=0,
        max_points=criterion.points,
        source="skipped",
        details=f"CLI failed after {MAX_RETRIES} attempts: {last_error_detail}",
        flagged=True,
        flag_reason="Claude CLI error",
    )


# ---------------------------------------------------------------------------
# Anthropic SDK backend (fallback for headless environments)
# ---------------------------------------------------------------------------

def _call_anthropic_sdk(
    criterion: CriterionConfig,
    task_content: TaskContent,
) -> CriterionResult:
    """Grade a single criterion using the Anthropic Python SDK."""
    import anthropic

    rubric_text = criterion.rubric_text or criterion.name
    student_work = _build_user_message(task_content)

    system_prompt = (
        "You are an expert SQL instructor grading student work. "
        "Score the following student submission based on the rubric.\n\n"
        f"RUBRIC:\n{rubric_text}\n\n"
        "SCORING INSTRUCTIONS:\n"
        f"- Score must be an integer from 0 to {criterion.points}\n"
        "- Provide your reasoning BEFORE deciding the score\n"
        "- Follow the rubric criteria. When in doubt, give the student the benefit of the doubt.\n"
        "- If the student's work is blank or missing, score 0\n\n"
        "Respond with ONLY a JSON object (no markdown, no extra text):\n"
        f'{{"score": <integer 0-{criterion.points}>, '
        '"confidence": "high|medium|low", '
        '"reasoning": "<your analysis>", '
        '"feedback": "<constructive feedback for student>"}}'
    )

    try:
        client = anthropic.Anthropic()
    except Exception as exc:
        logger.error("Failed to initialize Anthropic client: %s", exc)
        return CriterionResult(
            criterion_id=criterion.criterion_id,
            score=0,
            max_points=criterion.points,
            source="skipped",
            details=f"SDK init error: {exc}",
            flagged=True,
            flag_reason="LLM API unavailable",
        )

    last_error: Exception | None = None
    for attempt in range(MAX_RETRIES):
        try:
            response = client.messages.create(
                model=SDK_MODEL,
                max_tokens=SDK_MAX_TOKENS,
                system=[
                    {
                        "type": "text",
                        "text": system_prompt,
                        "cache_control": {"type": "ephemeral"},
                    }
                ],
                messages=[{"role": "user", "content": student_work}],
            )
            response_text = response.content[0].text
            return _parse_llm_response(response_text, criterion)

        except anthropic.RateLimitError as exc:
            last_error = exc
            backoff = BASE_BACKOFF_SECONDS * (2 ** attempt)
            jitter = random.uniform(0, MAX_JITTER_SECONDS)
            time.sleep(backoff + jitter)

        except anthropic.APIError as exc:
            logger.error("API error for criterion %s: %s", criterion.criterion_id, exc)
            return CriterionResult(
                criterion_id=criterion.criterion_id,
                score=0,
                max_points=criterion.points,
                source="skipped",
                details=f"API error: {exc}",
                flagged=True,
                flag_reason="LLM API unavailable",
            )

    return CriterionResult(
        criterion_id=criterion.criterion_id,
        score=0,
        max_points=criterion.points,
        source="skipped",
        details=f"Rate limited after {MAX_RETRIES} retries",
        flagged=True,
        flag_reason="LLM API unavailable",
    )


# ---------------------------------------------------------------------------
# Humanizer — remove AI writing patterns from student-facing feedback
# ---------------------------------------------------------------------------

def _humanize_feedback(feedback: str, backend: str) -> str:
    """Rewrite AI-generated feedback to read like a human instructor wrote it.

    Uses the same backend (CLI or SDK) that performed the grading, but with
    a lighter model (haiku) for speed and cost.  If humanization fails for
    any reason, the original feedback is returned unchanged.
    """
    if not feedback.strip():
        return feedback

    if backend == "cli":
        return _humanize_via_cli(feedback)
    return _humanize_via_sdk(feedback)


def _humanize_via_cli(feedback: str) -> str:
    """Run the humanizer prompt through ``claude --print`` with haiku."""
    prompt = HUMANIZER_PROMPT.format(feedback_text=feedback)
    cli_env = {k: v for k, v in os.environ.items() if k != "ANTHROPIC_API_KEY"}

    try:
        result = subprocess.run(
            [
                CLAUDE_CLI,
                "--print",
                "--model", HUMANIZER_MODEL,
                "--output-format", "text",
            ],
            input=prompt,
            capture_output=True,
            text=True,
            timeout=HUMANIZER_TIMEOUT_SECONDS,
            env=cli_env,
        )

        if result.returncode != 0:
            logger.warning("Humanizer CLI error: %s", result.stderr.strip()[:200])
            return feedback

        humanized = result.stdout.strip()
        return humanized if humanized else feedback

    except (subprocess.TimeoutExpired, FileNotFoundError) as exc:
        logger.warning("Humanizer CLI failed: %s", exc)
        return feedback


def _humanize_via_sdk(feedback: str) -> str:
    """Run the humanizer prompt through the Anthropic SDK with haiku."""
    try:
        import anthropic
        client = anthropic.Anthropic()
        response = client.messages.create(
            model="claude-opus-4-5-20251101",
            max_tokens=512,
            messages=[{
                "role": "user",
                "content": HUMANIZER_PROMPT.format(feedback_text=feedback),
            }],
        )
        humanized = response.content[0].text.strip()
        return humanized if humanized else feedback

    except Exception as exc:
        logger.warning("Humanizer SDK failed: %s", exc)
        return feedback


# ---------------------------------------------------------------------------
# Shared helpers
# ---------------------------------------------------------------------------

def _build_user_message(task_content: TaskContent) -> str:
    """Assemble the student's work into a single string."""
    parts: list[str] = []

    if task_content.sql_queries:
        parts.append("STUDENT SQL QUERIES:")
        for i, query in enumerate(task_content.sql_queries, 1):
            parts.append(f"\n--- Query {i} ---\n{query}")

    if task_content.insight_text:
        parts.append(f"\nSTUDENT ANALYSIS/INSIGHT:\n{task_content.insight_text}")

    if task_content.comments:
        parts.append(f"\nSTUDENT COMMENTS:\n{task_content.comments}")

    if not parts:
        return "(No student content submitted for this task.)"

    return "\n".join(parts)


def _parse_llm_response(
    response_text: str,
    criterion: CriterionConfig,
) -> CriterionResult:
    """Parse the JSON response from the LLM into a CriterionResult."""
    # Strip markdown fences if the LLM wraps the JSON
    cleaned = response_text.strip()
    if cleaned.startswith("```"):
        lines = cleaned.split("\n")
        # Remove first and last lines (``` markers)
        lines = [l for l in lines if not l.strip().startswith("```")]
        cleaned = "\n".join(lines).strip()

    try:
        data = json.loads(cleaned)
    except (json.JSONDecodeError, TypeError) as exc:
        logger.warning(
            "Failed to parse LLM JSON for criterion %s: %s",
            criterion.criterion_id,
            exc,
        )
        return CriterionResult(
            criterion_id=criterion.criterion_id,
            score=0,
            max_points=criterion.points,
            source="llm",
            details=f"Raw LLM response: {response_text[:500]}",
            flagged=True,
            flag_reason="Could not parse LLM response",
        )

    score = data.get("score", 0)
    if not isinstance(score, int):
        try:
            score = int(score)
        except (ValueError, TypeError):
            score = 0

    score = max(0, min(score, criterion.points))

    confidence = data.get("confidence", "medium")
    if confidence not in ("high", "medium", "low"):
        confidence = "medium"

    reasoning = data.get("reasoning", "")
    feedback = data.get("feedback", "")

    flagged = confidence == "low"
    flag_reason = "Low confidence LLM assessment" if flagged else ""

    return CriterionResult(
        criterion_id=criterion.criterion_id,
        score=score,
        max_points=criterion.points,
        source="llm",
        details=reasoning,
        confidence=confidence,
        feedback=feedback,
        flagged=flagged,
        flag_reason=flag_reason,
    )


def _is_empty_content(task_content: TaskContent) -> bool:
    """Check whether a TaskContent has no meaningful student work."""
    has_queries = any(q.strip() for q in task_content.sql_queries)
    has_insight = bool(task_content.insight_text.strip())
    has_comments = bool(task_content.comments.strip())
    return not (has_queries or has_insight or has_comments)


def _skip_all(
    config: QuizConfig,
) -> dict[str, list[CriterionResult]]:
    """Return skipped results for every criterion in the config."""
    results: dict[str, list[CriterionResult]] = {}

    for task in config.tasks:
        if not task.criteria:
            continue

        task_results = [
            CriterionResult(
                criterion_id=c.criterion_id,
                score=0,
                max_points=c.points,
                source="skipped",
                flagged=True,
                flag_reason="No LLM backend available",
            )
            for c in task.criteria
        ]
        results[task.task_id] = task_results

    return results
