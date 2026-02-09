"""SQL execution scorer for quiz grading.

Runs student SQL against a MySQL database and compares results to expected
output defined in quiz config. Handles connection errors, timeouts, and
syntax errors gracefully.
"""

import logging
import os

import mysql.connector
from mysql.connector import Error as MySQLError

from .models import (
    QuizConfig,
    ParsedSubmission,
    CriterionResult,
    ExpectedResult,
    TaskContent,
)

logger = logging.getLogger(__name__)


def get_db_connection():
    """Create a MySQL connection using .env credentials.

    Reads DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME from environment
    variables. Sets MAX_EXECUTION_TIME=10000 (10 seconds) for safety.

    Returns:
        mysql.connector connection object.

    Raises:
        mysql.connector.Error: If connection cannot be established.
    """
    conn = mysql.connector.connect(
        host=os.environ.get("DB_HOST", "localhost"),
        port=int(os.environ.get("DB_PORT", "3306")),
        user=os.environ.get("DB_USER", "root"),
        password=os.environ.get("DB_PASSWORD", ""),
        database=os.environ.get("DB_NAME", "campus_bites"),
        connection_timeout=10,
        read_timeout=15,
    )
    cursor = conn.cursor()
    cursor.execute("SET MAX_EXECUTION_TIME=10000;")
    cursor.close()
    return conn


def _find_task_content(parsed: ParsedSubmission, task_id: str) -> TaskContent | None:
    """Find TaskContent for a given task_id in a parsed submission."""
    for task in parsed.tasks:
        if task.task_id == task_id:
            return task
    return None


def _find_expected_result(
    task_config, result_ref: str
) -> ExpectedResult | None:
    """Find an ExpectedResult by result_id within a task config."""
    for er in task_config.expected_results:
        if er.result_id == result_ref:
            return er
    return None


def _values_match(actual, expected, float_tolerance: float) -> bool:
    """Compare two values with type-aware matching.

    - float/Decimal: abs(actual - expected) <= float_tolerance
    - str: case-insensitive, stripped comparison
    - int/other: exact equality
    """
    if actual is None and expected is None:
        return True
    if actual is None or expected is None:
        return False

    # Try numeric comparison first
    try:
        float_actual = float(actual)
        float_expected = float(expected)
        return abs(float_actual - float_expected) <= float_tolerance
    except (TypeError, ValueError):
        pass

    # String comparison: case-insensitive, trimmed
    if isinstance(actual, str) and isinstance(expected, str):
        return actual.strip().lower() == expected.strip().lower()

    # Try converting both to strings for comparison
    try:
        return str(actual).strip().lower() == str(expected).strip().lower()
    except (TypeError, ValueError):
        pass

    return actual == expected


def _row_matches(
    actual_row: dict, expected_row: dict, float_tolerance: float
) -> bool:
    """Check if an actual row matches an expected row across all expected columns."""
    for col, expected_val in expected_row.items():
        col_lower = col.lower()
        actual_val = actual_row.get(col_lower)
        if not _values_match(actual_val, expected_val, float_tolerance):
            return False
    return True


def _compare_results(
    actual_rows: list[dict],
    expected: ExpectedResult,
) -> tuple[bool, str]:
    """Compare actual query results against expected results.

    Args:
        actual_rows: List of dicts with lowercase column keys from query execution.
        expected: ExpectedResult config defining columns, rows, and matching rules.

    Returns:
        Tuple of (all_matched: bool, details: str).
    """
    if not expected.rows:
        return True, "No expected rows to check"

    expected_columns_lower = [c.lower() for c in expected.columns]

    # Check that actual results contain the expected columns
    if actual_rows:
        actual_columns = set(actual_rows[0].keys())
        missing_cols = [c for c in expected_columns_lower if c not in actual_columns]
        if missing_cols:
            return False, f"Missing columns in result: {', '.join(missing_cols)}"

    if len(actual_rows) < len(expected.rows):
        return False, (
            f"Expected {len(expected.rows)} rows, got {len(actual_rows)}"
        )

    if expected.row_order_matters:
        # Compare rows in order
        for i, expected_row in enumerate(expected.rows):
            if i >= len(actual_rows):
                return False, f"Missing row at position {i}"
            if not _row_matches(
                actual_rows[i], expected_row, expected.float_tolerance
            ):
                return False, f"Row {i} does not match expected values"
        return True, f"All {len(expected.rows)} rows match in order"
    else:
        # Find best match for each expected row (order doesn't matter)
        used_indices: set[int] = set()
        for j, expected_row in enumerate(expected.rows):
            found = False
            for i, actual_row in enumerate(actual_rows):
                if i in used_indices:
                    continue
                if _row_matches(
                    actual_row, expected_row, expected.float_tolerance
                ):
                    used_indices.add(i)
                    found = True
                    break
            if not found:
                return False, f"Expected row {j} not found in results"
        return True, f"All {len(expected.rows)} expected rows found"


def _execute_query(conn, sql: str) -> list[dict]:
    """Execute a SQL query and return results as list of dicts with lowercase keys.

    Args:
        conn: Active MySQL connection.
        sql: SQL query string to execute.

    Returns:
        List of row dicts with lowercase column names as keys.

    Raises:
        mysql.connector.Error: On SQL syntax error, timeout, etc.
    """
    cursor = conn.cursor()
    try:
        cursor.execute(sql)
        if cursor.description is None:
            return []
        columns = [desc[0].lower() for desc in cursor.description]
        rows = cursor.fetchall()
        return [dict(zip(columns, row)) for row in rows]
    finally:
        cursor.close()


def score_execution(
    parsed: ParsedSubmission,
    config: QuizConfig,
    conn=None,
) -> dict[str, list[CriterionResult]]:
    """Score all execution-type criteria by running student SQL against MySQL.

    For each execution criterion, runs the student's last SQL query for the
    task and compares results against expected output.

    Args:
        parsed: A student's parsed submission with extracted task content.
        config: The quiz configuration with tasks and execution criteria.
        conn: Optional pre-existing MySQL connection. If None, creates one.

    Returns:
        Dict mapping task_id to a list of CriterionResult for execution
        criteria only. Tasks with no execution criteria are omitted.
    """
    results: dict[str, list[CriterionResult]] = {}

    # Collect all tasks that have execution criteria
    execution_tasks = []
    for task_config in config.tasks:
        exec_criteria = [c for c in task_config.criteria if c.type == "execution"]
        if exec_criteria:
            execution_tasks.append((task_config, exec_criteria))

    if not execution_tasks:
        return results

    # Establish database connection
    owns_connection = False
    if conn is None:
        try:
            conn = get_db_connection()
            owns_connection = True
        except MySQLError as exc:
            logger.warning("Database unavailable: %s", exc)
            # Return skipped results for all execution criteria
            for task_config, exec_criteria in execution_tasks:
                task_results = []
                for criterion in exec_criteria:
                    task_results.append(
                        CriterionResult(
                            criterion_id=criterion.criterion_id,
                            score=0,
                            max_points=criterion.points,
                            source="skipped",
                            details=f"Database unavailable: {exc}",
                            confidence="deterministic",
                            flagged=True,
                            flag_reason="Database unavailable",
                        )
                    )
                results[task_config.task_id] = task_results
            return results

    try:
        # Use the configured database
        cursor = conn.cursor()
        cursor.execute(f"USE `{config.database}`;")
        cursor.close()

        for task_config, exec_criteria in execution_tasks:
            task_content = _find_task_content(parsed, task_config.task_id)
            sql_queries = task_content.sql_queries if task_content else []

            task_results = []
            for criterion in exec_criteria:
                # No SQL found for this task
                if not sql_queries:
                    task_results.append(
                        CriterionResult(
                            criterion_id=criterion.criterion_id,
                            score=0,
                            max_points=criterion.points,
                            source="execution",
                            details="No SQL queries found",
                            confidence="deterministic",
                            flagged=False,
                        )
                    )
                    continue

                # Look up expected result
                expected = None
                if criterion.expected_result_ref:
                    expected = _find_expected_result(
                        task_config, criterion.expected_result_ref
                    )

                if expected is None:
                    task_results.append(
                        CriterionResult(
                            criterion_id=criterion.criterion_id,
                            score=0,
                            max_points=criterion.points,
                            source="execution",
                            details=(
                                f"Expected result ref "
                                f"'{criterion.expected_result_ref}' not found"
                            ),
                            confidence="deterministic",
                            flagged=True,
                            flag_reason="Missing expected result definition",
                        )
                    )
                    continue

                # Execute the LAST query (most likely the final attempt)
                sql = sql_queries[-1]
                try:
                    actual_rows = _execute_query(conn, sql)
                    all_matched, details = _compare_results(actual_rows, expected)
                    score = criterion.points if all_matched else 0
                    task_results.append(
                        CriterionResult(
                            criterion_id=criterion.criterion_id,
                            score=score,
                            max_points=criterion.points,
                            source="execution",
                            details=details,
                            confidence="deterministic",
                            flagged=False,
                        )
                    )
                except MySQLError as exc:
                    error_msg = str(exc)
                    if "MAX_EXECUTION_TIME" in error_msg or "timeout" in error_msg.lower():
                        detail = "Query timed out"
                    else:
                        detail = f"SQL error: {error_msg}"
                    task_results.append(
                        CriterionResult(
                            criterion_id=criterion.criterion_id,
                            score=0,
                            max_points=criterion.points,
                            source="execution",
                            details=detail,
                            confidence="deterministic",
                            flagged=False,
                        )
                    )

            results[task_config.task_id] = task_results
    finally:
        if owns_connection and conn:
            try:
                conn.close()
            except MySQLError:
                pass

    return results
