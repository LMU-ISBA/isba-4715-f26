"""Quiz Grader CLI — entry point for grading SQL quiz submissions.

Usage:
    python grader.py grade --config configs/quiz-01.yaml
    python grader.py grade --config configs/quiz-01.yaml --batch
    python grader.py grade --config configs/quiz-01.yaml --resume
    python grader.py grade --config configs/quiz-01.yaml --student "Alice Smith"
    python grader.py calibrate --config configs/quiz-01.yaml
    python grader.py export --config configs/quiz-01.yaml
    python grader.py status --config configs/quiz-01.yaml
"""

import logging
import sys
import time
from datetime import datetime
from pathlib import Path

import click
from dotenv import load_dotenv
from rich.console import Console
from rich.progress import (
    BarColumn,
    MofNCompleteColumn,
    Progress,
    SpinnerColumn,
    TextColumn,
    TimeElapsedColumn,
    TimeRemainingColumn,
)

# Load .env from the quiz-grader directory
load_dotenv(Path(__file__).parent / ".env")

console = Console()

logger = logging.getLogger("grader")

# File handle for the always-on grading log (set during grade command)
_grading_log_fh = None


def _open_grading_log(output_path: Path) -> None:
    """Open the grading log file for appending phase results."""
    global _grading_log_fh  # noqa: PLW0603
    log_path = output_path / "grading.log"
    _grading_log_fh = open(log_path, "w", encoding="utf-8")  # noqa: SIM115


def _close_grading_log() -> None:
    """Flush and close the grading log file."""
    global _grading_log_fh  # noqa: PLW0603
    if _grading_log_fh:
        _grading_log_fh.close()
        _grading_log_fh = None


def _log_phase_results(
    student: str,
    phase: str,
    results: dict[str, list],
    quiz_config,
    *,
    log_only: bool = False,
) -> None:
    """Print per-task scoring results to the console and write to grading.log.

    Shows human-readable task/criterion names, scores, details, and
    feedback (for LLM criteria).  Output goes to both the terminal and
    ``output/grading.log`` so the instructor can ``tail -f`` the log.

    Args:
        log_only: If True, write to the log file only (used in batch mode
                  where the Rich progress bar owns the terminal).
    """
    # Build lookup tables for human-readable names
    task_name_lookup: dict[str, str] = {}
    crit_name_lookup: dict[str, str] = {}
    for tc in quiz_config.tasks:
        task_name_lookup[tc.task_id] = tc.task_name
        for cc in tc.criteria:
            crit_name_lookup[cc.criterion_id] = cc.name

    header = f"── {student} │ {phase} ──"
    _emit(header, log_only=log_only)

    for task_id, criteria in results.items():
        task_label = task_name_lookup.get(task_id, task_id)
        _emit(f"  {task_label}:", log_only=log_only)

        for cr in criteria:
            crit_label = crit_name_lookup.get(cr.criterion_id, cr.criterion_id)
            flag = " [FLAGGED]" if cr.flagged else ""

            # Score line
            score_line = f"    {crit_label}: {cr.score}/{cr.max_points}{flag}"
            _emit(score_line, log_only=log_only)

            # Details (reasoning / match info)
            if cr.details:
                detail = cr.details if len(cr.details) <= 100 else cr.details[:97] + "..."
                _emit(f"      Details: {detail}", log_only=log_only)

            # Feedback (student-facing, LLM only)
            if cr.feedback:
                fb = cr.feedback if len(cr.feedback) <= 120 else cr.feedback[:117] + "..."
                _emit(f"      Feedback: {fb}", log_only=log_only)

    _emit("", log_only=log_only)  # blank line separator


def _emit(line: str, *, log_only: bool = False) -> None:
    """Write a line to the grading log file, and optionally to the console.

    Retries on TimeoutError (common with Google Drive / cloud-synced
    directories) with exponential backoff up to 3 attempts.
    """
    if not log_only:
        console.print(f"  [dim]{line}[/dim]")
    if _grading_log_fh:
        for attempt in range(3):
            try:
                _grading_log_fh.write(line + "\n")
                _grading_log_fh.flush()
                return
            except TimeoutError:
                if attempt < 2:
                    wait = 2 ** attempt  # 1s, 2s
                    logger.warning(
                        "Log write timed out (attempt %d/3), retrying in %ds...",
                        attempt + 1, wait,
                    )
                    time.sleep(wait)
                else:
                    logger.error("Log write failed after 3 attempts, skipping line")


@click.group()
def cli():
    """SQL Quiz Grading Tool — automate grading of student SQL submissions."""
    pass


@cli.command()
@click.option("--config", "-c", required=True, type=click.Path(exists=True),
              help="Path to quiz YAML config file")
@click.option("--resume", "-r", is_flag=True, default=False,
              help="Resume a previously saved grading session")
@click.option("--skip-ai", is_flag=True, default=False,
              help="Skip LLM assessment (mark subjective as 'needs manual scoring')")
@click.option("--batch", "-b", is_flag=True, default=False,
              help="Grade all students first (with progress bar), then review")
@click.option("--verbose", "-v", is_flag=True, default=False,
              help="Enable detailed logging to output/grading.log")
@click.option("--output-dir", "-o", default="./output",
              help="Directory for grades, reports, and state")
@click.option("--student", "-s", default=None,
              help="Regrade a single student by name (requires existing session)")
def grade(config, resume, skip_ai, batch, verbose, output_dir, student):
    """Run the full grading pipeline for a quiz."""
    from src.config_loader import load_config
    from src.submission_loader import discover_submissions
    from src.parser import parse_submission
    from src.llm_grader import score_subjective
    from src.scorer import build_grade_reports, build_single_report
    from src.reviewer import run_review, review_one_student, load_session, save_session
    from src.models import GradingSession

    # Ensure output directories exist
    output_path = Path(output_dir)
    for subdir in ("grades", "reports", "state"):
        (output_path / subdir).mkdir(parents=True, exist_ok=True)

    # Always open the grading log for per-student results
    _open_grading_log(output_path)
    console.print(f"[dim]Grading log → {output_path / 'grading.log'}[/dim]")

    # --verbose additionally enables internal DEBUG logging from scorer modules
    if verbose:
        logging.basicConfig(
            filename=str(output_path / "debug.log"),
            level=logging.DEBUG,
            format="%(asctime)s [%(name)s] %(levelname)s: %(message)s",
            filemode="w",
        )
        console.print(f"[dim]Debug log → {output_path / 'debug.log'}[/dim]")

    # Step 1: Load config
    try:
        quiz_config = load_config(config)
    except (FileNotFoundError, ValueError) as e:
        console.print(f"[red]Configuration error:[/red] {e}")
        sys.exit(2)

    console.print(f"\n[bold]Grading: {quiz_config.quiz_name}[/bold]")
    console.print(f"Total points: {quiz_config.total_points}\n")

    # --student: regrade a single student from existing session
    if student:
        _regrade_student(config, quiz_config, student, output_dir, verbose)
        return

    # Step 2: Check for resume
    session = None
    if resume:
        session = load_session(quiz_config.quiz_id, output_path)
        if session:
            if session.quiz_id != quiz_config.quiz_id:
                console.print(
                    f"[red]Session mismatch:[/red] saved session is for "
                    f"'{session.quiz_id}', but config is '{quiz_config.quiz_id}'"
                )
                sys.exit(2)
            console.print(
                f"[green]Resuming session:[/green] "
                f"{session.students_reviewed}/{session.students_total} students reviewed"
            )
            # Resume always goes to review-only mode
            exit_code = run_review(session, quiz_config, output_path)
            sys.exit(exit_code)
        else:
            console.print("[yellow]No saved session found. Starting fresh.[/yellow]")

    # Step 3: Discover and parse submissions
    console.print("Discovering submissions...")
    submissions = discover_submissions(quiz_config)
    console.print(f"Found [bold]{len(submissions)}[/bold] student submissions\n")

    console.print("Parsing submissions...")
    parsed = [parse_submission(sub, quiz_config) for sub in submissions]
    blank_count = sum(1 for p in parsed if p.is_blank)
    if blank_count:
        console.print(f"[yellow]{blank_count} blank submission(s) detected[/yellow]")

    # Sort alphabetically for predictable order
    sorted_parsed = sorted(parsed, key=lambda p: p.submission.student_name.lower())
    total = len(sorted_parsed)

    if skip_ai:
        console.print("[dim]Skipping AI assessment (--skip-ai)[/dim]")

    # ---------------------------------------------------------------
    # BATCH MODE: grade all students with progress bar, then review
    # ---------------------------------------------------------------
    if batch:
        console.print("\n[bold]Batch mode:[/bold] grading all students first\n")

        llm_results = {}

        with Progress(
            SpinnerColumn(),
            TextColumn("[bold]{task.fields[student]}[/bold]"),
            TextColumn("{task.fields[phase]}"),
            BarColumn(),
            MofNCompleteColumn(),
            TimeElapsedColumn(),
            TextColumn("←"),
            TimeRemainingColumn(),
            console=console,
        ) as progress:
            task = progress.add_task(
                "Grading", total=total, student="", phase="starting...",
            )

            for ps in sorted_parsed:
                name = ps.submission.student_name

                if not skip_ai:
                    progress.update(task, student=name, phase="AI assessment...")
                    llm_results[name] = score_subjective(ps, quiz_config)
                    _log_phase_results(name, "LLM assessment", llm_results[name],
                                       quiz_config, log_only=True)

                progress.advance(task)

        # Build all grade reports at once
        session = build_grade_reports(
            quiz_config, sorted_parsed,
            llm_results,
            config_path=config, output_path=output_path,
        )

        console.print("\n[green]All students graded.[/green]")
        _close_grading_log()

        # Post-grading calibration step (inline)
        from src.calibrator import run_calibration
        session = run_calibration(session, quiz_config, output_path)
        save_session(session, output_path)

        console.print("Starting review...\n")
        exit_code = run_review(session, quiz_config, output_path)
        sys.exit(exit_code)

    # ---------------------------------------------------------------
    # INTERLEAVED MODE (default): grade one → review one → next
    # ---------------------------------------------------------------
    console.print()

    now = datetime.now()
    session = GradingSession(
        session_id=f"{quiz_config.quiz_id}-{now.strftime('%Y%m%d-%H%M%S')}",
        quiz_id=quiz_config.quiz_id,
        config_path=config,
        started_at=now,
        last_updated=now,
        students_total=total,
        students_reviewed=0,
        current_index=0,
        grade_reports=[],
    )

    # Count total criteria for progress display (all scored by LLM)
    criteria_count = sum(len(t.criteria) for t in quiz_config.tasks)

    try:
        for i, ps in enumerate(sorted_parsed):
            name = ps.submission.student_name
            console.print(f"[bold]Student {i + 1}/{total}: {name}[/bold]")

            # --- LLM assessment ---
            llm = {}
            if not skip_ai:
                with console.status("") as status:
                    status.update(
                        f"  AI assessment (0/{criteria_count} criteria)..."
                    )
                    llm = score_subjective(
                        ps, quiz_config,
                        progress_callback=lambda done, total_c=criteria_count: (
                            status.update(
                                f"  AI assessment ({done}/{total_c} criteria)..."
                            )
                        ),
                    )
                console.print(
                    f"  AI assessment ({criteria_count}/{criteria_count} criteria)..."
                    " [green]done[/green]"
                )
                _log_phase_results(name, "LLM assessment", llm, quiz_config)

            # --- Build report for this student ---
            report = build_single_report(quiz_config, ps, llm)
            session.grade_reports.append(report)
            save_session(session, output_path)

            # --- Review immediately ---
            action = review_one_student(
                report, i, total, session, quiz_config, output_path,
            )
            if action == "quit":
                _close_grading_log()
                sys.exit(1)

    except KeyboardInterrupt:
        session.last_updated = datetime.now()
        save_session(session, output_path)
        _close_grading_log()
        console.print(
            "\n[yellow]Interrupted. Session saved. Use --resume to continue.[/yellow]"
        )
        sys.exit(1)

    _close_grading_log()
    session.status = "completed"
    session.last_updated = datetime.now()
    save_session(session, output_path)
    console.print("[green]All students graded and reviewed. Session complete.[/green]")
    sys.exit(0)


def _regrade_student(config_path, quiz_config, student_name, output_dir, verbose):
    """Grade or regrade a single student.

    If the student already has a grade report in the session, re-runs the
    LLM and replaces it (regrade).  If the student is NOT in the session
    but has a submission on disk, grades them fresh and appends the report.
    """
    import difflib
    from src.submission_loader import discover_submissions
    from src.parser import parse_submission
    from src.llm_grader import score_subjective
    from src.scorer import build_single_report
    from src.reviewer import load_session, save_session, review_one_student

    output_path = Path(output_dir)

    # 1. Load existing session
    session = load_session(quiz_config.quiz_id, output_path)
    if not session:
        console.print("[red]No grading session found. Run 'grade' first.[/red]")
        sys.exit(1)

    # 2. Try to find the student in the session (fuzzy match)
    all_names = [r.student_name for r in session.grade_reports]
    exact_match = [n for n in all_names if n.lower() == student_name.lower()]

    is_new_student = False
    matched_name = None

    if exact_match:
        matched_name = exact_match[0]
    else:
        close = difflib.get_close_matches(student_name, all_names, n=3, cutoff=0.5)
        if close:
            if len(close) == 1:
                matched_name = close[0]
                console.print(f"[yellow]Matched to:[/yellow] {matched_name}")
            else:
                console.print("[yellow]Did you mean one of these?[/yellow]")
                for i, name in enumerate(close, 1):
                    console.print(f"  {i}. {name}")
                choice = click.prompt("Enter number", type=int, default=1)
                if 1 <= choice <= len(close):
                    matched_name = close[choice - 1]
                else:
                    console.print("[red]Invalid choice.[/red]")
                    sys.exit(1)

    # 3. If not in session, check submissions on disk
    if matched_name is None:
        submissions = discover_submissions(quiz_config)
        sub_names = [s.student_name for s in submissions]
        sub_exact = [n for n in sub_names if n.lower() == student_name.lower()]

        if sub_exact:
            matched_name = sub_exact[0]
            is_new_student = True
        else:
            sub_close = difflib.get_close_matches(student_name, sub_names, n=3, cutoff=0.5)
            if sub_close:
                if len(sub_close) == 1:
                    matched_name = sub_close[0]
                    is_new_student = True
                    console.print(f"[yellow]Matched to submission:[/yellow] {matched_name}")
                else:
                    console.print("[yellow]Not in session. Did you mean one of these submissions?[/yellow]")
                    for i, name in enumerate(sub_close, 1):
                        console.print(f"  {i}. {name}")
                    choice = click.prompt("Enter number", type=int, default=1)
                    if 1 <= choice <= len(sub_close):
                        matched_name = sub_close[choice - 1]
                        is_new_student = True
                    else:
                        console.print("[red]Invalid choice.[/red]")
                        sys.exit(1)
            else:
                console.print(f"[red]'{student_name}' not found in session or submissions.[/red]")
                sys.exit(1)

    # 4. Discover and parse the student's submission
    if not is_new_student:
        submissions = discover_submissions(quiz_config)
    student_sub = next(
        (s for s in submissions if s.student_name == matched_name), None
    )
    if not student_sub:
        console.print(f"[red]Submission file not found for '{matched_name}'.[/red]")
        sys.exit(1)

    parsed = parse_submission(student_sub, quiz_config)

    if is_new_student:
        console.print(f"\n[bold]Grading (new): {matched_name}[/bold]\n")
    else:
        report_idx = next(
            i for i, r in enumerate(session.grade_reports)
            if r.student_name == matched_name
        )
        old_report = session.grade_reports[report_idx]
        old_score = old_report.total_score
        console.print(f"\n[bold]Regrading: {matched_name}[/bold]")
        console.print(f"[dim]Previous score: {old_score}/{old_report.total_max}[/dim]\n")

    # 5. Run LLM grading
    _open_grading_log(output_path)

    criteria_count = sum(len(t.criteria) for t in quiz_config.tasks)
    with console.status("") as status:
        status.update(f"  AI assessment (0/{criteria_count} criteria)...")
        llm_results = score_subjective(
            parsed, quiz_config,
            progress_callback=lambda done, total_c=criteria_count: (
                status.update(f"  AI assessment ({done}/{total_c} criteria)...")
            ),
        )
    console.print(
        f"  AI assessment ({criteria_count}/{criteria_count} criteria)..."
        " [green]done[/green]"
    )
    label = "LLM assessment (new)" if is_new_student else "LLM assessment (regrade)"
    _log_phase_results(matched_name, label, llm_results, quiz_config)
    _close_grading_log()

    # 6. Build report and insert/replace in session
    new_report = build_single_report(quiz_config, parsed, llm_results)

    if is_new_student:
        session.grade_reports.append(new_report)
        session.grade_reports.sort(key=lambda r: r.student_name.lower())
        session.students_total = len(session.grade_reports)
        report_idx = next(
            i for i, r in enumerate(session.grade_reports)
            if r.student_name == matched_name
        )
        console.print(
            f"\n[green]Grading complete:[/green] "
            f"{new_report.total_score}/{new_report.total_max}"
        )
    else:
        session.grade_reports[report_idx] = new_report
        console.print(
            f"\n[green]Regrade complete:[/green] "
            f"{old_score} → {new_report.total_score}/{new_report.total_max}"
        )

    # 7. Save and drop into review
    save_session(session, output_path)

    total = len(session.grade_reports)
    review_one_student(
        new_report, report_idx, total, session, quiz_config, output_path,
    )
    save_session(session, output_path)
    console.print("[green]Session saved.[/green]")


@cli.command()
@click.option("--config", "-c", required=True, type=click.Path(exists=True),
              help="Path to quiz YAML config file")
@click.option("--format", "-f", "export_format", default="both",
              type=click.Choice(["csv", "markdown", "both"]),
              help="Export format")
@click.option("--output-dir", "-o", default="./output",
              help="Directory for exported files")
@click.option("--reviewed-only", is_flag=True, default=False,
              help="Only export students whose review is complete")
def export(config, export_format, output_dir, reviewed_only):
    """Export grades from a completed or in-progress session."""
    from src.config_loader import load_config
    from src.reviewer import load_session
    from src.reporter import export_grades

    quiz_config = load_config(config)
    output_path = Path(output_dir)

    session = load_session(quiz_config.quiz_id, output_path)
    if not session:
        console.print("[red]No grading session found. Run 'grade' first.[/red]")
        sys.exit(1)

    export_grades(session, quiz_config, output_path, export_format, reviewed_only)
    console.print("[green]Export complete.[/green]")


@cli.command()
@click.option("--config", "-c", required=True, type=click.Path(exists=True),
              help="Path to quiz YAML config file")
@click.option("--output-dir", "-o", default="./output",
              help="Directory for session state")
def calibrate(config, output_dir):
    """Analyze grading patterns and propose score adjustments."""
    from src.config_loader import load_config
    from src.reviewer import load_session, save_session
    from src.calibrator import run_calibration

    quiz_config = load_config(config)
    output_path = Path(output_dir)

    session = load_session(quiz_config.quiz_id, output_path)
    if not session:
        console.print("[red]No grading session found. Run 'grade' first.[/red]")
        sys.exit(1)

    if not session.grade_reports:
        console.print("[red]No grade reports in session. Grade some students first.[/red]")
        sys.exit(1)

    session = run_calibration(session, quiz_config, output_path)
    save_session(session, output_path)
    console.print("[green]Calibration complete. Session saved.[/green]")


@cli.command()
@click.option("--config", "-c", required=True, type=click.Path(exists=True),
              help="Path to quiz YAML config file")
@click.option("--output-dir", "-o", default="./output",
              help="Directory for session state")
def status(config, output_dir):
    """Show grading progress for a quiz session."""
    from src.config_loader import load_config
    from src.reviewer import load_session
    from rich.table import Table

    quiz_config = load_config(config)
    output_path = Path(output_dir)

    session = load_session(quiz_config.quiz_id, output_path)
    if not session:
        console.print("[yellow]No grading session found.[/yellow]")
        return

    table = Table(title=f"Grading Status: {quiz_config.quiz_name}")
    table.add_column("Metric", style="bold")
    table.add_column("Value")

    table.add_row("Status", session.status)
    table.add_row("Students Total", str(session.students_total))
    table.add_row("Students Reviewed", str(session.students_reviewed))
    table.add_row("Next Student Index", str(session.current_index))

    reviewed = [r for r in session.grade_reports if r.reviewed]
    if reviewed:
        avg = sum(r.total_score for r in reviewed) / len(reviewed)
        table.add_row("Average Score (reviewed)", f"{avg:.1f}/{quiz_config.total_points}")

    flagged = sum(
        1 for r in session.grade_reports
        for tg in r.task_grades
        for cr in tg.criteria_results
        if cr.flagged
    )
    table.add_row("Flagged Criteria", str(flagged))

    console.print(table)


if __name__ == "__main__":
    cli()
