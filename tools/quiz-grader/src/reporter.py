"""Generate CSV gradebook and per-student Markdown feedback reports.

Exports grading results in two formats:
- CSV gradebook for LMS import (one row per student, task-level columns).
- Markdown feedback files rendered from a Jinja2 template (one file per student).
"""

import csv
import re
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

from .models import GradingSession, GradeReport, QuizConfig


def export_single_student_report(
    report: GradeReport,
    config: QuizConfig,
    output_path: Path,
) -> Path:
    """Write one student's Markdown feedback report immediately.

    Called during the review loop when a student is accepted, so the
    instructor gets incremental output rather than waiting for a bulk
    export.

    Args:
        report: The accepted student's grade report.
        config: Quiz configuration for task/criterion names.
        output_path: Root output directory (writes to ``reports/``).

    Returns:
        Path to the written Markdown file.
    """
    reports_dir = output_path / "reports"
    reports_dir.mkdir(parents=True, exist_ok=True)

    template = _load_template()

    criterion_lookup: dict[str, object] = {}
    task_lookup: dict[str, object] = {}
    for task_cfg in config.tasks:
        task_lookup[task_cfg.task_id] = task_cfg
        for crit_cfg in task_cfg.criteria:
            criterion_lookup[crit_cfg.criterion_id] = crit_cfg

    context = _build_template_context(report, config, task_lookup, criterion_lookup)
    rendered = template.render(context)

    slug = _slugify(report.student_name)
    md_path = reports_dir / f"{slug}-feedback.md"
    md_path.write_text(rendered, encoding="utf-8")
    return md_path


def export_grades(
    session: GradingSession,
    config: QuizConfig,
    output_path: Path,
    export_format: str = "both",
    reviewed_only: bool = False,
) -> None:
    """Export grades to CSV and/or Markdown files.

    Args:
        session: Completed or in-progress grading session.
        config: Quiz configuration for task/criterion names.
        output_path: Root output directory.
        export_format: ``"csv"``, ``"markdown"``, or ``"both"``.
        reviewed_only: If True, only export students marked as reviewed.

    Raises:
        ValueError: If *export_format* is not one of the accepted values.
    """
    valid_formats = {"csv", "markdown", "both"}
    if export_format not in valid_formats:
        raise ValueError(
            f"Invalid export_format '{export_format}'. "
            f"Must be one of: {', '.join(sorted(valid_formats))}"
        )

    reports = _filter_reports(session.grade_reports, reviewed_only)

    if export_format in ("csv", "both"):
        _export_csv(reports, config, output_path)

    if export_format in ("markdown", "both"):
        _export_markdown(reports, config, output_path)


# ---------------------------------------------------------------------------
# CSV export
# ---------------------------------------------------------------------------

def _export_csv(
    reports: list[GradeReport],
    config: QuizConfig,
    output_path: Path,
) -> None:
    """Write the gradebook CSV to ``output_path/grades/{quiz_id}-grades.csv``."""
    grades_dir = output_path / "grades"
    grades_dir.mkdir(parents=True, exist_ok=True)

    csv_path = grades_dir / f"{config.quiz_id}-grades.csv"

    # Build column headers from config tasks
    fieldnames = ["student_name"]
    for task_cfg in config.tasks:
        tid = task_cfg.task_id
        fieldnames.extend([f"{tid}_score", f"{tid}_max"])
    fieldnames.extend(["total_score", "total_max", "percentage"])

    with open(csv_path, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames)
        writer.writeheader()

        for report in reports:
            row: dict[str, object] = {"student_name": report.student_name}

            # Build a lookup from task_id to TaskGrade for this student
            task_lookup = {tg.task_id: tg for tg in report.task_grades}

            for task_cfg in config.tasks:
                tid = task_cfg.task_id
                tg = task_lookup.get(tid)
                row[f"{tid}_score"] = tg.task_score if tg else 0
                row[f"{tid}_max"] = tg.task_max if tg else task_cfg.points

            total_max = report.total_max if report.total_max > 0 else config.total_points
            percentage = round(report.total_score / total_max * 100, 1) if total_max > 0 else 0.0

            row["total_score"] = report.total_score
            row["total_max"] = report.total_max
            row["percentage"] = percentage

            writer.writerow(row)


# ---------------------------------------------------------------------------
# Markdown export
# ---------------------------------------------------------------------------

def _export_markdown(
    reports: list[GradeReport],
    config: QuizConfig,
    output_path: Path,
) -> None:
    """Write per-student feedback Markdown to ``output_path/reports/``."""
    reports_dir = output_path / "reports"
    reports_dir.mkdir(parents=True, exist_ok=True)

    template = _load_template()

    # Build criterion config lookup: criterion_id -> CriterionConfig
    criterion_lookup: dict[str, object] = {}
    task_lookup: dict[str, object] = {}
    for task_cfg in config.tasks:
        task_lookup[task_cfg.task_id] = task_cfg
        for crit_cfg in task_cfg.criteria:
            criterion_lookup[crit_cfg.criterion_id] = crit_cfg

    for report in reports:
        context = _build_template_context(report, config, task_lookup, criterion_lookup)
        rendered = template.render(context)

        slug = _slugify(report.student_name)
        md_path = reports_dir / f"{slug}-feedback.md"
        md_path.write_text(rendered, encoding="utf-8")


def _build_template_context(
    report: GradeReport,
    config: QuizConfig,
    task_lookup: dict,
    criterion_lookup: dict,
) -> dict:
    """Build the Jinja2 template context dict for a single student report."""
    total_max = report.total_max if report.total_max > 0 else config.total_points
    percentage = round(report.total_score / total_max * 100, 1) if total_max > 0 else 0.0

    task_grades = []
    for tg in report.task_grades:
        task_cfg = task_lookup.get(tg.task_id)
        task_name = task_cfg.task_name if task_cfg else tg.task_id

        criteria = []
        for cr in tg.criteria_results:
            crit_cfg = criterion_lookup.get(cr.criterion_id)
            crit_name = crit_cfg.name if crit_cfg else cr.criterion_id

            criteria.append({
                "name": crit_name,
                "score": cr.score,
                "max_points": cr.max_points,
                "feedback": cr.feedback,
                "details": cr.details,
            })

        task_grades.append({
            "task_name": task_name,
            "task_score": tg.task_score,
            "task_max": tg.task_max,
            "criteria": criteria,
        })

    overrides = []
    for ov in report.overrides:
        crit_cfg = criterion_lookup.get(ov.criterion_id)
        crit_name = crit_cfg.name if crit_cfg else ov.criterion_id

        overrides.append({
            "criterion_name": crit_name,
            "original_score": ov.original_score,
            "new_score": ov.new_score,
            "reason": ov.reason,
        })

    return {
        "quiz_name": config.quiz_name,
        "student_name": report.student_name,
        "total_score": report.total_score,
        "total_max": total_max,
        "percentage": percentage,
        "task_grades": task_grades,
        "instructor_notes": report.instructor_notes,
        "overrides": overrides,
    }


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _load_template() -> object:
    """Load the Jinja2 feedback template from the ``templates/`` directory."""
    template_dir = Path(__file__).resolve().parent.parent / "templates"
    env = Environment(
        loader=FileSystemLoader(str(template_dir)),
        keep_trailing_newline=True,
        trim_blocks=True,
        lstrip_blocks=True,
    )
    return env.get_template("student_feedback.md.j2")


def _filter_reports(
    reports: list[GradeReport],
    reviewed_only: bool,
) -> list[GradeReport]:
    """Return reports sorted alphabetically, optionally filtered to reviewed only."""
    filtered = [r for r in reports if r.reviewed] if reviewed_only else list(reports)
    filtered.sort(key=lambda r: r.student_name.lower())
    return filtered


def _slugify(name: str) -> str:
    """Convert student name to a filename-safe slug.

    Lowercases the name, replaces spaces with hyphens, and strips
    commas, periods, and other non-alphanumeric/non-hyphen characters.

    Examples:
        >>> _slugify("Jane Doe")
        'jane-doe'
        >>> _slugify("O'Brien, Sean M.")
        'obrien-sean-m'
    """
    slug = name.lower()
    slug = slug.replace(" ", "-")
    slug = re.sub(r"[^a-z0-9\-]", "", slug)
    # Collapse multiple hyphens
    slug = re.sub(r"-{2,}", "-", slug)
    # Strip leading/trailing hyphens
    slug = slug.strip("-")
    return slug
