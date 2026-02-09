"""Load and validate quiz configuration from YAML files.

Maps the nested YAML structure to flat QuizConfig dataclass.
"""

import yaml
from pathlib import Path

from .models import (
    QuizConfig,
    TaskConfig,
    CriterionConfig,
    PatternDef,
    ExpectedResult,
)


def load_config(config_path: str) -> QuizConfig:
    """Load a quiz configuration from a YAML file.

    Args:
        config_path: Path to the YAML config file.

    Returns:
        QuizConfig with all nested entities populated.

    Raises:
        FileNotFoundError: If config file doesn't exist.
        ValueError: If required fields are missing.
    """
    path = Path(config_path)
    if not path.exists():
        raise FileNotFoundError(f"Config file not found: {config_path}")

    with open(path, "r") as f:
        raw = yaml.safe_load(f)

    if not raw:
        raise ValueError(f"Config file is empty: {config_path}")

    # Validate top-level sections
    for section in ("quiz", "submissions", "tasks"):
        if section not in raw:
            raise ValueError(f"Missing required section '{section}' in {config_path}")

    quiz_section = raw["quiz"]
    submissions_section = raw["submissions"]
    tasks_raw = raw["tasks"]

    # Build task configs
    tasks = []
    for task_raw in tasks_raw:
        criteria = []
        for crit_raw in task_raw.get("criteria", []):
            patterns = [
                PatternDef(
                    regex=p["regex"],
                    weight=p.get("weight", 1.0),
                    description=p.get("description", ""),
                    negative=p.get("negative", False),
                )
                for p in crit_raw.get("patterns", [])
            ]
            criteria.append(
                CriterionConfig(
                    criterion_id=crit_raw["id"],
                    name=crit_raw["name"],
                    points=crit_raw["points"],
                    type=crit_raw["type"],
                    patterns=patterns,
                    expected_result_ref=crit_raw.get("expected_result_ref"),
                    rubric_text=crit_raw.get("rubric_text"),
                )
            )

        expected_results = [
            ExpectedResult(
                result_id=er["id"],
                description=er.get("description", ""),
                columns=er.get("columns", []),
                rows=er.get("rows", []),
                float_tolerance=er.get("float_tolerance", 0.1),
                row_order_matters=er.get("row_order_matters", False),
            )
            for er in task_raw.get("expected_results", [])
        ]

        tasks.append(
            TaskConfig(
                task_id=task_raw["id"],
                task_name=task_raw["name"],
                points=task_raw["points"],
                section_marker=task_raw.get("section_marker", ""),
                criteria=criteria,
                expected_results=expected_results,
            )
        )

    # Resolve submission_dir relative to the config file's directory
    submission_dir = submissions_section["dir"]
    if not Path(submission_dir).is_absolute():
        submission_dir = str((path.parent / submission_dir).resolve())

    return QuizConfig(
        quiz_id=quiz_section["id"],
        quiz_name=quiz_section["name"],
        total_points=quiz_section["total_points"],
        database=quiz_section.get("database", "campus_bites"),
        submission_dir=submission_dir,
        submission_glob=submissions_section.get("glob", "**/*.sql"),
        exclude_patterns=submissions_section.get("exclude", []),
        tasks=tasks,
    )
