# Quiz Grader — Usage Guide

A CLI tool for semi-automated grading of student SQL quiz submissions. Combines pattern matching, SQL execution, and AI-powered assessment with an interactive terminal review workflow.

## Table of Contents

- [Quick Start](#quick-start)
- [Setup](#setup)
- [Configuration](#configuration)
- [Grading Pipeline](#grading-pipeline)
- [Commands](#commands)
- [Interactive Review](#interactive-review)
- [Session Management](#session-management)
- [Output Files](#output-files)
- [Flags and Options](#flags-and-options)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

```bash
cd tools/quiz-grader

# 1. Set up Python environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# 2. Copy and edit environment file
cp .env.example .env
# Edit .env with your database credentials

# 3. Grade a quiz
python grader.py grade --config configs/quiz-01.yaml

# 4. Export grades when done
python grader.py export --config configs/quiz-01.yaml
```

---

## Setup

### Prerequisites

- **Python 3.11+**
- **MySQL** with the Campus Bites database loaded (for SQL execution scoring)
- **Claude Code CLI** (for AI-powered subjective grading — no API key needed)

### Install Dependencies

```bash
cd tools/quiz-grader
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Dependencies: `click`, `mysql-connector-python`, `anthropic`, `PyYAML`, `rich`, `Jinja2`, `python-dotenv`, `sqlparse`

### Environment Variables

Copy `.env.example` to `.env` and fill in your values:

```
DB_HOST=localhost
DB_PORT=3306
DB_USER=quiz_grader
DB_PASSWORD=your_secure_password
DB_NAME=campus_bites
ANTHROPIC_API_KEY=sk-ant-your-api-key-here   # Optional — only needed if Claude Code CLI is unavailable
```

**Note:** The `ANTHROPIC_API_KEY` is a fallback. If you have Claude Code installed (which you do if you're reading this), the grader uses `claude --print` directly and no API key is required.

---

## Configuration

Each quiz needs a YAML config file in `configs/`. See `configs/quiz-01.yaml` for a complete example.

### Config Structure

```yaml
quiz:
  id: "quiz-01"
  name: "Quiz 01: Descriptive & Diagnostic Analytics"
  total_points: 100
  database: "campus_bites"

submissions:
  dir: "../../../quizzes/quiz-01/submissions/Quiz 01 Download Feb 6, 2026 310 PM"
  glob: "**/*.sql"
  exclude:
    - "*answer-key*"
    - "*INSTRUCTOR*"
    - "index.html"

tasks:
  - id: "task-01"
    name: "Descriptive Analytics: What Happened?"
    points: 20
    section_marker: "PART 1|TASK 01|Task 1"
    criteria:
      - id: "t1-lag-usage"
        name: "Uses LAG() window function"
        points: 5
        type: "pattern"             # Scored by regex matching
        patterns:
          - regex: "LAG\\s*\\("
            weight: 1.0

      - id: "t1-count-orders"
        name: "Correctly counts orders per month"
        points: 5
        type: "execution"           # Scored by running SQL and comparing results
        expected_result_ref: "t1-monthly-counts"

      - id: "t1-insight-quality"
        name: "Quality of descriptive insight"
        points: 10
        type: "subjective"          # Scored by Claude AI
        rubric_text: |
          Full marks (10): States specific month-over-month change...
          Partial marks (5-9): Identifies decline but missing numbers...
```

### Criterion Types

| Type | How It Works | Requires |
|------|-------------|----------|
| `pattern` | Regex matching against student SQL | Nothing extra |
| `execution` | Runs student SQL, compares results to expected | MySQL connection |
| `subjective` | AI reads rubric + student work, scores with reasoning | Claude Code CLI or API key |

### Submission Discovery

The `submissions.dir` path is resolved relative to the config file location. The loader:
- Finds all `.sql` files matching the glob pattern
- Handles double extensions (`.sql.sql`)
- Deduplicates (keeps latest by timestamp)
- Excludes files matching the exclude patterns
- Extracts student names from filenames

---

## Grading Pipeline

The grading process runs in 6 stages:

```
1. Load Config     → Read quiz YAML, validate structure
2. Discover        → Find student .sql files in submission directory
3. Parse           → Extract per-task SQL queries, comments, and insights
4. Score           → Three parallel scoring methods:
   ├── Pattern     → Regex matching (instant)
   ├── Execution   → Run SQL against MySQL (~1s per query)
   └── LLM         → Claude AI assessment (~15s per criterion)
5. Review          → Interactive terminal UI for instructor review
6. Export          → CSV gradebook + Markdown feedback per student
```

### Scoring Details

**Pattern Matching**: Each pattern has a weight (0.0–1.0). The score is calculated as the weighted ratio of matched patterns times the criterion's max points. Negative patterns subtract from the score.

**SQL Execution**: Runs the student's last query per task against MySQL. Compares the result set to expected results with float tolerance (±0.1) and order-insensitive row matching. Times out after 10 seconds.

**LLM Assessment**: Sends the rubric + student work to Claude. The AI returns a JSON response with `score`, `confidence` (high/medium/low), `reasoning`, and `feedback`. Low-confidence results are automatically flagged for instructor review.

**Feedback Humanizer**: After AI grading, the `feedback` field is automatically passed through a humanizer step (using haiku for speed). This removes common signs of AI-generated writing — inflated language, AI vocabulary ("leverage", "utilize", "comprehensive"), em dash overuse, promotional phrasing — so the feedback reads like a real instructor wrote it.

---

## Commands

### `grade` — Run the grading pipeline

```bash
python grader.py grade --config configs/quiz-01.yaml [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `--config, -c` | Path to quiz YAML config (required) |
| `--resume, -r` | Resume a previously saved session |
| `--skip-ai` | Skip AI assessment; subjective criteria marked "needs manual scoring" |
| `--skip-db` | Skip SQL execution; execution criteria marked "skipped" |
| `--output-dir, -o` | Output directory (default: `./output`) |

**Examples:**

```bash
# Full grading with all scoring methods
python grader.py grade -c configs/quiz-01.yaml

# Grade without database (pattern + AI only)
python grader.py grade -c configs/quiz-01.yaml --skip-db

# Grade without AI (pattern + execution only)
python grader.py grade -c configs/quiz-01.yaml --skip-ai

# Dry run: no AI, no database
python grader.py grade -c configs/quiz-01.yaml --skip-ai --skip-db

# Resume an interrupted session
python grader.py grade -c configs/quiz-01.yaml --resume
```

### `export` — Export grades

```bash
python grader.py export --config configs/quiz-01.yaml [OPTIONS]
```

| Option | Description |
|--------|-------------|
| `--config, -c` | Path to quiz YAML config (required) |
| `--format, -f` | Export format: `csv`, `markdown`, or `both` (default: `both`) |
| `--output-dir, -o` | Output directory (default: `./output`) |
| `--reviewed-only` | Only export students whose review is complete |

### `status` — Check grading progress

```bash
python grader.py status --config configs/quiz-01.yaml
```

Displays a table showing: session status, students reviewed, average score, and flagged criteria count.

---

## Interactive Review

After scoring, the tool presents each student for interactive review in the terminal.

### What You See

For each student, the reviewer displays:
1. **Student header** — name, submission time, review status
2. **Score table** — all criteria with scores, sources, and details
3. **Total score** — sum with percentage
4. **Flagged items** — criteria needing attention (low confidence, skipped, etc.)

### Actions

| Key | Action | Description |
|-----|--------|-------------|
| `a` | Accept | Mark student as reviewed, move to next |
| `o` | Override | Change a criterion score (prompts for criterion, new score, and reason) |
| `f` | Feedback | Add instructor notes for this student |
| `v` | View SQL | Display the student's full SQL submission with syntax highlighting |
| `s` | Skip | Move to next student without marking as reviewed |
| `q` | Quit | Save session and exit (use `--resume` to continue later) |

### Override Flow

1. Press `o` to enter override mode
2. A numbered list of all criteria appears
3. Enter the criterion number to override
4. Enter the new score (0 to max)
5. Enter a reason for the override
6. The score table refreshes with the updated score

---

## Session Management

### Saving

The session auto-saves after every action during review. The session file is stored at:
```
output/state/<quiz-id>-session.json
```

### Resuming

```bash
python grader.py grade -c configs/quiz-01.yaml --resume
```

This loads the saved session and continues from the next unreviewed student. All previous scores, overrides, and notes are preserved. The tool validates that the config's `quiz_id` matches the saved session.

### Crash Recovery

If the tool crashes or you press Ctrl+C, the session is saved automatically. Just run with `--resume` to pick up where you left off.

---

## Output Files

After grading and exporting, the `output/` directory contains:

```
output/
├── grades/
│   └── quiz-01-grades.csv          # Gradebook CSV
├── reports/
│   ├── anders-lodin-feedback.md    # Per-student Markdown feedback
│   ├── che-andrade-feedback.md
│   └── ...
└── state/
    └── quiz-01-session.json        # Session state (for resume)
```

### CSV Gradebook

Columns: `student_name`, `{task-id}_score`, `{task-id}_max` (for each task), `total_score`, `total_max`, `percentage`

Ready for import into your LMS or spreadsheet.

### Markdown Feedback

One file per student containing:
- Quiz name and total score
- Per-task score breakdown with criterion-level feedback
- Instructor notes (if added during review)
- Score adjustments (if any overrides were applied)

---

## Flags and Options

### Degraded Operation Modes

The grader is designed to work even when some backends are unavailable:

| Mode | Pattern | Execution | LLM | Command |
|------|---------|-----------|-----|---------|
| Full | Yes | Yes | Yes | `python grader.py grade -c configs/quiz-01.yaml` |
| No DB | Yes | Skipped | Yes | `... --skip-db` |
| No AI | Yes | Yes | Skipped | `... --skip-ai` |
| Minimal | Yes | Skipped | Skipped | `... --skip-ai --skip-db` |

Skipped criteria are flagged in the review so you can score them manually using the override action.

### LLM Backend Priority

1. **Claude Code CLI** (`claude --print`) — used if `claude` is on your PATH. No API key needed.
2. **Anthropic SDK** — used if `ANTHROPIC_API_KEY` is set but CLI is unavailable (headless/CI environments).
3. **Skip** — if neither is available, all subjective criteria are marked "needs manual scoring."

---

## Troubleshooting

### "No LLM backend available"

The grader can't find `claude` on your PATH and no `ANTHROPIC_API_KEY` is set. Options:
- Install Claude Code CLI: `npm install -g @anthropic-ai/claude-code`
- Or set `ANTHROPIC_API_KEY` in your `.env` file
- Or use `--skip-ai` to grade without AI

### "CLI timed out"

The Claude CLI call took longer than 60 seconds. This can happen with very long student submissions. The criterion is marked as skipped/flagged so you can score it manually.

### Database connection errors

Check your `.env` file credentials. The grader uses `python-dotenv` to load them. Make sure MySQL is running and the `campus_bites` database is accessible.

### "Config file not found"

The `--config` path is relative to your working directory. Make sure you're in `tools/quiz-grader/` or use an absolute path.

### No submissions found

Check the `submissions.dir` path in your YAML config. It's resolved relative to the config file's location. Verify the directory exists and contains `.sql` files.

---

## Creating a New Quiz Config

To grade a different quiz, create a new YAML config:

1. Copy `configs/quiz-01.yaml` as a template
2. Update `quiz.id`, `quiz.name`, `quiz.total_points`
3. Update `submissions.dir` to point to the new submission directory
4. Define tasks with their section markers and criteria
5. For `pattern` criteria: define regex patterns with weights
6. For `execution` criteria: define expected results (columns, rows, tolerance)
7. For `subjective` criteria: write rubric text with scoring guidelines

Run the grader with your new config:

```bash
python grader.py grade -c configs/quiz-02.yaml
```

---

## Architecture Overview

```
grader.py                   # CLI entry point (Click commands)
src/
├── models.py               # All dataclasses (QuizConfig, CriterionResult, etc.)
├── config_loader.py        # YAML → QuizConfig
├── submission_loader.py    # Discover student .sql files
├── parser.py               # Extract per-task SQL, comments, insights
├── pattern_matcher.py      # Regex-based scoring
├── executor.py             # MySQL execution + result comparison
├── llm_grader.py           # Claude AI subjective assessment
├── scorer.py               # Aggregate results → GradeReports
├── reviewer.py             # Rich interactive terminal UI + session persistence
└── reporter.py             # CSV + Markdown export
configs/
└── quiz-01.yaml            # Quiz 01 configuration
templates/
└── student_feedback.md.j2  # Jinja2 template for student feedback
```
