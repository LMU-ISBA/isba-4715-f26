"""Aggregate criterion results into task grades and grade reports.

Collects CriterionResults produced by the LLM grader and assembles them
into per-student GradeReport objects wrapped in a GradingSession for the
interactive reviewer.

Provides both batch assembly (``build_grade_reports``) and single-student
assembly (``build_single_report``) for interleaved grading workflows.
"""

from datetime import datetime
from pathlib import Path

from .models import (
    CriterionResult,
    GradeReport,
    GradingSession,
    ParsedSubmission,
    QuizConfig,
    TaskGrade,
)


def build_grade_reports(
    config: QuizConfig,
    parsed_list: list[ParsedSubmission],
    llm_results: dict[str, dict[str, list[CriterionResult]]],
    config_path: str = "",
    output_path: Path = None,
) -> GradingSession:
    """Build grade reports for all students and wrap them in a GradingSession.

    For each parsed submission, a GradeReport is created from LLM scoring
    results.  Criteria that appear in the config but have no corresponding
    result (e.g. when ``--skip-ai`` was used) are recorded as "skipped" so
    the reviewer can see them.

    Args:
        config: Quiz configuration with task and criterion definitions.
        parsed_list: All parsed student submissions.
        llm_results: ``{student_name: {task_id: [CriterionResult]}}``
            from the LLM grader.
        config_path: Filesystem path to the quiz YAML config file.
        output_path: Directory for session output (unused here but passed
            through to GradingSession metadata).

    Returns:
        A GradingSession containing sorted GradeReports ready for review.
    """
    grade_reports: list[GradeReport] = []

    for parsed in parsed_list:
        student = parsed.submission.student_name
        report = _build_report(config, student, parsed, llm_results.get(student, {}))
        grade_reports.append(report)

    # Sort alphabetically for predictable review order
    grade_reports.sort(key=lambda r: r.student_name.lower())

    now = datetime.now()
    return GradingSession(
        session_id=f"{config.quiz_id}-{now.strftime('%Y%m%d-%H%M%S')}",
        quiz_id=config.quiz_id,
        config_path=config_path,
        started_at=now,
        last_updated=now,
        students_total=len(parsed_list),
        students_reviewed=0,
        current_index=0,
        grade_reports=grade_reports,
    )


def build_single_report(
    config: QuizConfig,
    parsed: ParsedSubmission,
    llm_results: dict[str, list[CriterionResult]],
) -> GradeReport:
    """Build a GradeReport for a single student.

    Same logic as ``build_grade_reports`` but operates on one student at a
    time for use in the interleaved grading workflow.

    Args:
        config: Quiz configuration with task and criterion definitions.
        parsed: A single parsed student submission.
        llm_results: ``{task_id: [CriterionResult]}`` from the LLM grader.

    Returns:
        A fully assembled GradeReport ready for review.
    """
    student = parsed.submission.student_name
    return _build_report(config, student, parsed, llm_results)


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _build_report(
    config: QuizConfig,
    student: str,
    parsed: ParsedSubmission,
    task_results: dict[str, list[CriterionResult]],
) -> GradeReport:
    """Assemble a GradeReport from LLM results for one student.

    Walks every criterion in the config to guarantee coverage — any
    criterion without a corresponding LLM result is marked as "skipped".
    """
    report = GradeReport(
        student_name=student,
        submission=parsed.submission,
    )

    for task_cfg in config.tasks:
        task_id = task_cfg.task_id
        task_grade = TaskGrade(task_id=task_id)

        # Index LLM results by criterion_id for fast lookup
        produced: dict[str, CriterionResult] = {}
        for cr in task_results.get(task_id, []):
            produced[cr.criterion_id] = cr

        # Walk every criterion in the config to guarantee coverage
        for crit_cfg in task_cfg.criteria:
            cid = crit_cfg.criterion_id
            if cid in produced:
                task_grade.criteria_results.append(produced[cid])
            else:
                # No scorer produced a result — mark as skipped
                task_grade.criteria_results.append(
                    CriterionResult(
                        criterion_id=cid,
                        score=0,
                        max_points=crit_cfg.points,
                        source="skipped",
                        details="Criterion skipped (scorer not run)",
                        confidence="n/a",
                    )
                )

        # Compute task totals
        task_grade.task_score = sum(
            cr.score for cr in task_grade.criteria_results
        )
        task_grade.task_max = sum(
            cr.max_points for cr in task_grade.criteria_results
        )
        report.task_grades.append(task_grade)

    # Compute report totals
    report.total_score = sum(tg.task_score for tg in report.task_grades)
    report.total_max = sum(tg.task_max for tg in report.task_grades)
    return report
