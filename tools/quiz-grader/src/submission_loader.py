"""Discover student SQL submissions from the filesystem.

Handles LMS download directory structure:
    submissions/<Download Folder>/<Student Name - Date Time>/<file>.sql

Edge cases handled:
    - Double file extensions (.sql.sql)
    - Duplicate submissions (uses latest by timestamp)
    - Exclude patterns (answer keys, index.html)
"""

import re
from datetime import datetime
from fnmatch import fnmatch
from pathlib import Path

from .models import QuizConfig, Submission


# Pattern to parse student directory names from Brightspace LMS downloads:
# "FirstName LastName - Mon DD, YYYY HHMM AM/PM"
_DIR_PATTERN = re.compile(
    r"^(.+?)\s*-\s*(\w+ \d{1,2}, \d{4} \d{3,4} [AP]M)$"
)


def _parse_dir_name(dir_name: str) -> tuple[str, datetime | None]:
    """Extract student name and submission timestamp from directory name."""
    match = _DIR_PATTERN.match(dir_name)
    if not match:
        return dir_name, None

    name = match.group(1).strip()
    time_str = match.group(2)

    # Parse the timestamp: "Feb 4, 2026 1120 AM" → datetime
    try:
        # Handle 3-digit time (e.g., "120 AM" → "0120 AM")
        parts = time_str.rsplit(" ", 2)  # ["Feb 4, 2026", "1120", "AM"]
        if len(parts) == 3 and len(parts[1]) == 3:
            parts[1] = "0" + parts[1]
            time_str = " ".join(parts)
        submitted_at = datetime.strptime(time_str, "%b %d, %Y %I%M %p")
    except ValueError:
        submitted_at = None

    return name, submitted_at


def _should_exclude(file_path: Path, exclude_patterns: list[str]) -> bool:
    """Check if a file matches any exclusion pattern."""
    name = file_path.name
    for pattern in exclude_patterns:
        if fnmatch(name, pattern):
            return True
    return False


def _is_sql_file(file_path: Path) -> bool:
    """Check if file is a SQL file (handles double extensions like .sql.sql)."""
    suffixes = file_path.suffixes
    return any(s.lower() == ".sql" for s in suffixes)


def discover_submissions(config: QuizConfig) -> list[Submission]:
    """Discover all student SQL submissions from the configured directory.

    Returns a deduplicated, sorted list of Submission objects.
    For duplicate submissions (same student), keeps the latest one.
    """
    base_dir = Path(config.submission_dir)
    if not base_dir.exists():
        raise FileNotFoundError(
            f"Submission directory not found: {config.submission_dir}"
        )

    # Find all SQL files matching the glob
    all_files = list(base_dir.glob(config.submission_glob))

    # Filter by SQL extension and exclusion patterns
    sql_files = [
        f for f in all_files
        if f.is_file()
        and _is_sql_file(f)
        and not _should_exclude(f, config.exclude_patterns)
    ]

    # Build submissions, extracting student info from parent directory names
    submissions_by_student: dict[str, Submission] = {}
    for file_path in sql_files:
        # The student directory is the immediate parent of the SQL file
        student_dir = file_path.parent
        student_name, submitted_at = _parse_dir_name(student_dir.name)

        sub = Submission(
            student_name=student_name,
            file_path=str(file_path),
            submitted_at=submitted_at,
        )

        # Handle duplicates: keep the latest submission
        existing = submissions_by_student.get(student_name)
        if existing:
            sub.is_duplicate = True
            existing.is_duplicate = True
            if submitted_at and existing.submitted_at:
                if submitted_at > existing.submitted_at:
                    submissions_by_student[student_name] = sub
            # If we can't compare timestamps, keep the first one found
        else:
            submissions_by_student[student_name] = sub

    # Sort by student name
    result = sorted(submissions_by_student.values(), key=lambda s: s.student_name)
    return result
