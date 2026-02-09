"""Pattern matching scorer for quiz grading.

Scores student SQL submissions against regex patterns defined in quiz config.
All scoring is deterministic -- no LLM or database required.
"""

import re

from .models import QuizConfig, ParsedSubmission, CriterionResult, TaskContent


def _find_task_content(parsed: ParsedSubmission, task_id: str) -> TaskContent | None:
    """Find TaskContent for a given task_id in a parsed submission."""
    for task in parsed.tasks:
        if task.task_id == task_id:
            return task
    return None


def _score_single_criterion(sql_texts: list[str], criterion) -> CriterionResult:
    """Score a single pattern criterion against a list of SQL query strings.

    Compiles each PatternDef regex (case-insensitive), searches across all SQL
    texts, and computes a weighted score scaled to the criterion's point value.

    Args:
        sql_texts: All SQL queries extracted for the task.
        criterion: A CriterionConfig with type=="pattern" and populated patterns.

    Returns:
        CriterionResult with deterministic scoring details.
    """
    if not criterion.patterns:
        return CriterionResult(
            criterion_id=criterion.criterion_id,
            score=0,
            max_points=criterion.points,
            source="pattern",
            details="No patterns defined for this criterion",
            confidence="deterministic",
            flagged=False,
        )

    # Combine all SQL into one searchable block per query for matching
    combined_sql = "\n".join(sql_texts)

    matched = []
    missed = []
    total_positive_weight = 0.0
    earned_weight = 0.0

    for pattern_def in criterion.patterns:
        try:
            compiled = re.compile(pattern_def.regex, re.IGNORECASE | re.DOTALL)
        except re.error as exc:
            missed.append(f"INVALID REGEX '{pattern_def.regex}': {exc}")
            if not pattern_def.negative:
                total_positive_weight += pattern_def.weight
            continue

        found = compiled.search(combined_sql) is not None

        if pattern_def.negative:
            # Negative patterns: finding them subtracts weight
            if found:
                earned_weight -= pattern_def.weight
                matched.append(f"[-] {pattern_def.description} (found, -{pattern_def.weight})")
            else:
                missed.append(f"[-] {pattern_def.description} (not found, OK)")
        else:
            # Positive patterns: finding them adds weight
            total_positive_weight += pattern_def.weight
            if found:
                earned_weight += pattern_def.weight
                matched.append(f"[+] {pattern_def.description} (+{pattern_def.weight})")
            else:
                missed.append(f"[+] {pattern_def.description} (missing)")

    # Calculate score as proportion of total positive weight
    if total_positive_weight > 0:
        ratio = earned_weight / total_positive_weight
    else:
        # Only negative patterns exist; start from full points, subtract penalties
        ratio = 1.0 + earned_weight  # earned_weight is <= 0 here

    raw_score = round(ratio * criterion.points)

    # Clamp to [0, max_points]
    score = max(0, min(criterion.points, raw_score))

    # Build details string
    detail_parts = []
    if matched:
        detail_parts.append("Matched: " + "; ".join(matched))
    if missed:
        detail_parts.append("Missed: " + "; ".join(missed))
    details = " | ".join(detail_parts) if detail_parts else "No patterns evaluated"

    return CriterionResult(
        criterion_id=criterion.criterion_id,
        score=score,
        max_points=criterion.points,
        source="pattern",
        details=details,
        confidence="deterministic",
        flagged=False,
    )


def score_patterns(
    parsed: ParsedSubmission, config: QuizConfig
) -> dict[str, list[CriterionResult]]:
    """Score all pattern-type criteria for a parsed submission.

    Iterates over each task in the quiz config, finds pattern criteria,
    and evaluates them against the student's extracted SQL queries.

    Args:
        parsed: A student's parsed submission with extracted task content.
        config: The quiz configuration with tasks and pattern criteria.

    Returns:
        Dict mapping task_id to a list of CriterionResult for pattern
        criteria only. Tasks with no pattern criteria are omitted.
    """
    results: dict[str, list[CriterionResult]] = {}

    for task_config in config.tasks:
        pattern_criteria = [c for c in task_config.criteria if c.type == "pattern"]
        if not pattern_criteria:
            continue

        task_content = _find_task_content(parsed, task_config.task_id)
        sql_texts = task_content.sql_queries if task_content else []

        task_results = []
        for criterion in pattern_criteria:
            if not sql_texts:
                task_results.append(
                    CriterionResult(
                        criterion_id=criterion.criterion_id,
                        score=0,
                        max_points=criterion.points,
                        source="pattern",
                        details="No SQL queries found for this task",
                        confidence="deterministic",
                        flagged=False,
                    )
                )
            else:
                task_results.append(_score_single_criterion(sql_texts, criterion))

        results[task_config.task_id] = task_results

    return results
