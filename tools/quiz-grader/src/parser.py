"""Parse student SQL files into structured per-task content.

Uses a hybrid approach:
- Custom state-machine to split file by section markers from config
- sqlparse for SQL statement splitting within each section
- Pre-filters ASCII result tables to avoid treating pasted output as SQL

Edge cases handled:
- Blank submissions (no SQL queries found)
- Pasted result tables (ASCII tables with | and + characters)
- Missing semicolons (sqlparse keyword heuristics)
- Multiple query attempts (all captured for context)
"""

import re

import sqlparse

from .models import QuizConfig, Submission, ParsedSubmission, TaskContent


# Pattern to detect pasted result tables (ASCII art with | or + borders)
_TABLE_LINE = re.compile(r"^\s*[\|+][-\|+]+[\|+]\s*$")
_TABLE_ROW = re.compile(r"^\s*\|.*\|\s*$")

# Pattern to detect comment lines
_COMMENT_LINE = re.compile(r"^\s*--")
_BLOCK_COMMENT_START = re.compile(r"/\*")
_BLOCK_COMMENT_END = re.compile(r"\*/")

# SQL keywords that indicate a new statement (when no semicolons)
_SQL_KEYWORDS = re.compile(
    r"^\s*(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER|WITH)\b",
    re.IGNORECASE,
)

# Insight markers in student files
# Allows optional parenthetical descriptions between keyword and colon,
# e.g. "-- INSIGHT (what the data reveals):" or just "-- INSIGHT:"
_INSIGHT_MARKERS = re.compile(
    r"^\s*--\s*(INSIGHT|ANSWER|FINDING|YOUR ANALYSIS|RECOMMENDATION|PREDICTION)\b[^:]*:",
    re.IGNORECASE,
)


def _strip_result_tables(text: str) -> str:
    """Remove pasted ASCII result tables from text.

    Students sometimes paste query output like:
        /*
        order_month|orders|revenue|
        -----------+------+-------+
        April      |    96|2397.22|
        */
    """
    lines = text.split("\n")
    cleaned = []
    in_table = False
    consecutive_table_lines = 0

    for line in lines:
        is_table_line = bool(_TABLE_LINE.match(line) or _TABLE_ROW.match(line))
        if is_table_line:
            consecutive_table_lines += 1
            if consecutive_table_lines >= 2:
                in_table = True
        else:
            if in_table and consecutive_table_lines >= 2:
                # End of table region, skip the table lines
                in_table = False
            consecutive_table_lines = 0

        if not in_table:
            cleaned.append(line)

    return "\n".join(cleaned)


def _extract_section_text(file_content: str, task_markers: list[tuple[str, str]]) -> dict[str, str]:
    """Split file content into sections based on task markers.

    Args:
        file_content: Raw content of the .sql file.
        task_markers: List of (task_id, section_marker_regex) pairs.

    Returns:
        Dict mapping task_id to the raw text for that section.
    """
    sections: dict[str, str] = {}
    lines = file_content.split("\n")

    # Compile all markers
    compiled = [(tid, re.compile(marker, re.IGNORECASE)) for tid, marker in task_markers]

    # Find the line index where each section starts
    section_starts: list[tuple[str, int]] = []
    for i, line in enumerate(lines):
        for task_id, pattern in compiled:
            if pattern.search(line):
                section_starts.append((task_id, i))
                break

    # Extract text between section starts
    for idx, (task_id, start_line) in enumerate(section_starts):
        if idx + 1 < len(section_starts):
            end_line = section_starts[idx + 1][1]
        else:
            end_line = len(lines)
        sections[task_id] = "\n".join(lines[start_line:end_line])

    return sections


def _extract_sql_queries(section_text: str) -> list[str]:
    """Extract SQL queries from a section of text.

    Uses sqlparse.split() for semicolon-delimited queries,
    with fallback to keyword detection for missing semicolons.
    """
    # Remove comment-only lines for SQL extraction (but keep for insight extraction)
    code_lines = []
    in_block_comment = False

    for line in section_text.split("\n"):
        if _BLOCK_COMMENT_END.search(line):
            in_block_comment = False
            continue
        if in_block_comment:
            continue
        if _BLOCK_COMMENT_START.search(line):
            in_block_comment = True
            continue
        if not _COMMENT_LINE.match(line):
            code_lines.append(line)

    code_text = "\n".join(code_lines).strip()
    if not code_text:
        return []

    # Use sqlparse to split statements
    statements = sqlparse.split(code_text)

    # Filter out empty statements and clean up
    queries = []
    for stmt in statements:
        cleaned = stmt.strip().rstrip(";").strip()
        if cleaned and _SQL_KEYWORDS.match(cleaned):
            queries.append(cleaned)

    return queries


def _extract_insight_text(section_text: str) -> str:
    """Extract insight/answer text from comment lines in a section.

    Handles both ``-- `` single-line comments and ``/* ... */`` block
    comments that follow an insight marker.
    """
    insight_parts = []
    capturing = False
    in_block_comment = False

    for line in section_text.split("\n"):
        stripped = line.strip()

        # Track block comment boundaries
        if in_block_comment:
            if _BLOCK_COMMENT_END.search(line):
                in_block_comment = False
            elif capturing:
                # Capture text inside a block comment after a marker
                text = stripped
                if text and text != "???" and not _is_table_content(text):
                    insight_parts.append(text)
            continue

        if _BLOCK_COMMENT_START.search(line):
            # Block comment opening — if we're capturing, grab inline text
            # and enter block mode
            if capturing:
                # Text on same line as /* (e.g. "/* My insight here")
                after_open = line.split("/*", 1)[1]
                if _BLOCK_COMMENT_END.search(after_open):
                    # Single-line block comment: /* text */
                    text = after_open.split("*/", 1)[0].strip()
                    if text and text != "???" and not _is_table_content(text):
                        insight_parts.append(text)
                else:
                    in_block_comment = True
                    text = after_open.strip()
                    if text and text != "???" and not _is_table_content(text):
                        insight_parts.append(text)
            else:
                # Not capturing yet — skip this block
                if not _BLOCK_COMMENT_END.search(line):
                    in_block_comment = True
            continue

        if _INSIGHT_MARKERS.search(line):
            capturing = True
            # Extract text after the marker
            match = _INSIGHT_MARKERS.search(line)
            if match:
                after = line[match.end():].strip()
                if after and after != "???" and not after.startswith("===") and not after.startswith("---"):
                    insight_parts.append(after)
            continue

        if capturing:
            # Continue capturing indented comment lines
            if stripped.startswith("--"):
                text = stripped[2:].strip()
                if text and text != "???" and not text.startswith("===") and not text.startswith("---"):
                    insight_parts.append(text)
            elif not stripped:
                continue  # Skip blank lines within insight
            else:
                capturing = False  # Non-comment line ends insight capture

    return " ".join(insight_parts).strip()


def _is_table_content(text: str) -> bool:
    """Check if text looks like a pasted result table row."""
    return bool(_TABLE_LINE.match(text) or _TABLE_ROW.match(text))


def _extract_comments(section_text: str) -> str:
    """Extract non-insight comment text from a section (student notes, thinking).

    Handles both ``-- `` single-line comments and ``/* ... */`` block
    comments (excluding insight markers and result tables).
    """
    comments = []
    in_block_comment = False
    in_insight_block = False

    for line in section_text.split("\n"):
        stripped = line.strip()

        # Track block comment boundaries
        if in_block_comment:
            if _BLOCK_COMMENT_END.search(line):
                in_block_comment = False
                in_insight_block = False
            elif not in_insight_block:
                text = stripped
                if text and not _is_table_content(text):
                    comments.append(text)
            continue

        if _BLOCK_COMMENT_START.search(line):
            # Check if this block follows an insight marker (skip those —
            # they're handled by _extract_insight_text)
            if _INSIGHT_MARKERS.search(line):
                in_insight_block = True
            if not _BLOCK_COMMENT_END.search(line):
                in_block_comment = True
            else:
                # Single-line block comment: /* text */
                if not in_insight_block:
                    text = line.split("/*", 1)[1].split("*/", 1)[0].strip()
                    if text and not _is_table_content(text):
                        comments.append(text)
            continue

        # Check if the previous line was an insight marker (next block is insight)
        if _INSIGHT_MARKERS.search(stripped):
            in_insight_block = True
            continue
        elif stripped and not stripped.startswith("--"):
            in_insight_block = False

        if stripped.startswith("--") and not _INSIGHT_MARKERS.search(stripped):
            text = stripped[2:].strip()
            # Skip section headers and separators
            if text and not text.startswith("===") and not text.startswith("---"):
                comments.append(text)

    return "\n".join(comments)


def parse_submission(submission: Submission, config: QuizConfig) -> ParsedSubmission:
    """Parse a student's SQL file into structured per-task content.

    Args:
        submission: The submission to parse.
        config: Quiz configuration with task definitions and section markers.

    Returns:
        ParsedSubmission with TaskContent for each configured task.
    """
    warnings: list[str] = []

    # Read the file
    try:
        with open(submission.file_path, "r", encoding="utf-8", errors="replace") as f:
            raw_content = f.read()
    except OSError as e:
        warnings.append(f"Could not read file: {e}")
        return ParsedSubmission(
            submission=submission,
            is_blank=True,
            parse_warnings=warnings,
        )

    # Pre-filter result tables
    filtered_content = _strip_result_tables(raw_content)

    # Build task markers list
    task_markers = [(t.task_id, t.section_marker) for t in config.tasks]

    # Split into sections
    sections = _extract_section_text(filtered_content, task_markers)

    # Parse each section
    task_contents = []
    total_queries = 0

    for task_config in config.tasks:
        section_text = sections.get(task_config.task_id, "")

        if not section_text:
            warnings.append(f"No section found for {task_config.task_id}")
            task_contents.append(TaskContent(task_id=task_config.task_id))
            continue

        queries = _extract_sql_queries(section_text)
        insight = _extract_insight_text(section_text)
        comments = _extract_comments(section_text)
        total_queries += len(queries)

        task_contents.append(
            TaskContent(
                task_id=task_config.task_id,
                sql_queries=queries,
                comments=comments,
                insight_text=insight,
                raw_text=section_text,
            )
        )

    is_blank = total_queries == 0 and all(
        not tc.insight_text for tc in task_contents
    )

    if is_blank:
        warnings.append("Blank submission: no SQL queries or insights found")

    return ParsedSubmission(
        submission=submission,
        tasks=task_contents,
        is_blank=is_blank,
        parse_warnings=warnings,
    )
