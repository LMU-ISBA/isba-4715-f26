# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is the course website for **ISBA 4715 - Developing Business Applications Using SQL** at Loyola Marymount University. It includes a syllabus and SQL lessons using the Campus Bites case study, deployed via GitHub Pages.

## Deployment

The site auto-deploys to GitHub Pages on push to `main` via `.github/workflows/pages.yml`. No build step required - static HTML is deployed directly.

## Content Structure

- `index.html` - Main syllabus website (standalone, no framework dependencies)
- `frameworks.md` - Course frameworks/models reference
- `lessons/` - SQL lesson materials organized by topic

### Lessons Structure

**First half (Lessons 01-05):** SQL worksheet format. Each folder contains:
- `README.md` - Lesson overview and links for students
- `setup-guide.md` - Tool setup instructions (Lesson 01 only)
- `lesson-XX-fname-lname.sql` - Student worksheet template
- `INSTRUCTOR-answer-key.md` - Instructor guide with answers (gitignored)

**Second half (Lessons 06+):** Mini-project tutorial format. Each folder contains:
- `README.md` - Lesson overview with scenario, learning objectives, pipeline diagram, and key concepts
- `mpX-tutorial.md` - Step-by-step tutorial (the take-home lesson exercise)
- `data/` - Any data files needed for the mini-project

### Mini-Project Tutorial Template

Tutorial files (`mpX-tutorial.md`) should follow this structure:

1. **Title** - `# Mini-Project X: [Title] Tutorial`
2. **Introduction** - Brief description of what the tutorial covers. If multi-session, list each session with date and step range (see `lessons/09-scrape-pipeline/mp04-tutorial.md` as the reference example).
3. **Table of Contents** - Required. One table per session, organized under `### Session NN: [topic] (date)` subsections. Columns: Step, Topic (linked to anchor), What You Will Do.
4. **Parts** - Each session contains one or more `## Part NN: [topic]` sections. Step numbers run sequentially across all sessions (e.g., Session 01 has Steps 00–07, Session 02 has Steps 08–14). Use leading zeros throughout (Step 08, not Step 8).
5. **Steps** - Each step as `### Step NN: [Title]` with:
   - Brief context (1-2 sentences)
   - `**What to do:**` numbered instructions with Claude Code prompts in code blocks
   - `**Why this matters:**` or similar callout (1-2 sentences)
   - `**Checkpoint:**` how to verify the step worked
6. **Submission** - What to submit per session and what the repo(s) should contain. If session deliverables land in different repos (e.g., L09 Session 01 = practice repo, L09 Session 02 = portfolio repo), list each separately.

### Editing the Syllabus

The `index.html` is a self-contained file with embedded CSS. Key sections:
- Header: Course title, subtitle, info badges
- Navigation: Sticky nav with smooth scroll
- Sections: Overview, Instructor, Schedule, Grading, Tips, Policies

CSS variables in `:root` control theming (colors, radius, shadows).

## Second-Half Course Delivery (Spring 2026)

**Course pivot.** The original Spring 2026 syllabus planned MP03 = API + Streamlit and MP04 = Vector DB + RAG Chatbot. The course pivoted in April 2026 to redirect MP03 → API extraction only (Lesson 08, 1 session, ends at CSV) and MP04 → scrape pipeline + GitHub Actions + knowledge base wiki (Lesson 09, 2 sessions). Lesson 10 (Streamlit Dashboard + Whiteboard Diagram) is a standalone lesson on Apr 29, due May 6. The portfolio project's structured-data path still uses Snowflake + Streamlit + dbt; the knowledge base path uses Firecrawl + Claude Code wiki synthesis (no vector DB, no RAG chatbot). `index.html` and `lessons/README.md` reflect what was actually delivered, not the original plan.

**Superpowers loop is the second-half pedagogical pattern.** Lessons 09 Session 02 onward teach students to use the Superpowers skill chain `brainstorming` → `writing-plans` → `executing-plans` for any non-trivial design-and-build task. The pattern repeats: GitHub Actions workflow design, wiki design, Streamlit dashboard design, resume update. When drafting new tutorial steps for design work, prefer skill-driven prompts over prescriptive context blocks.

**Knowledge base wiki pattern (Karpathy-inspired).** The portfolio knowledge base follows [Karpathy's LLM wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f): three layers (raw sources / wiki / schema) with three operations (ingest, query, lint) documented in the student's repo `CLAUDE.md` as a "Knowledge base schema" section. Students treat `CLAUDE.md` as a contract the agent enforces, not docs. The `log.md` from Karpathy's pattern is intentionally omitted (git history covers iterative-use evidence for the M02 rubric).

**Project rubric clarifications (Apr 26, 2026 reconciliation):**
- M01 Source 1 (API) → Snowflake raw (structured-data path)
- M01 Source 2 (web scrape/docs) → `knowledge/raw/` markdown files (knowledge base path, **not** Snowflake)
- M02 GitHub Actions automates both pipelines, with different write destinations. The scrape workflow needs `permissions: contents: write` and a commit-back step at the end.

**Lesson naming after Lesson 09.** Lesson 10 is *not* a mini-project. It works inside the student's portfolio repo, not a new student-practice repo. Tutorial filename should be `tutorial.md` rather than `mpX-tutorial.md`.

## SQL Worksheet Template

Student worksheet files (`lesson-XX-fname-lname.sql`) should follow this structure:

### Header Section
```sql
-- ============================================================================
-- LESSON XX: [Title]
-- ============================================================================
--
-- SCENARIO: [Business context and problem/opportunity]
--
-- YOUR MISSION: [What students will accomplish]
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                  | Status     | Used In    |
-- |--------------------------|------------|------------|
-- | [Concept 1]              | Review     | Parts X-Y  |
-- | [Concept 2]              | NEW        | Part Z     |
-- | [Concept 3]              | Reinforce  | All Parts  |
-- ============================================================================
```

### Part Naming Conventions
- Use `PART X: [CATEGORY] - [Question]` format
- Categories: `DESCRIPTIVE ANALYTICS`, `DIAGNOSTIC ANALYTICS`, `CONFIRM THE CONNECTION`
- Questions should be action-oriented: "What Happened?", "WHO Drove the Drop?", "WHY Did They Grow?"

### Standard Sections (in order)
1. **PART 1-N**: Analytical exercises with numbered sub-questions (1.1, 1.2, etc.)
2. **YOUR ANALYSIS**: Complete story synthesis with insight statement and recommendation
3. **ON YOUR OWN**: Challenge problems for independent practice
4. **SQL CONCEPTS COVERED**: Summary list of concepts (Review/NEW/Reinforced)

### Exercise Format
```sql
-- X.Y [Exercise Title]
-- [Instructions and hints]
-- HINT: [SQL hint if needed]
--
-- ANSWER: [Blank for student] _____________
```

## Security

- Never include database credentials (hostname, username, password, port) in any file tracked by git
- Connection details are provided to students in class, not in the repo
- If a file needs to reference the database, say "Connection details will be provided in class" or name only the schema (e.g., `basket_craft`)

## SQL Best Practices
When writing SQL queries in worksheets and instructor keys:

**Formatting:**
- Put major keywords on their own line: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`
- Indent columns and conditions with 4 spaces
- Put each column on its own line in multi-column SELECTs
- Put each expression on its own line in multi-expression GROUP BY and ORDER BY clauses

**Counting:**
- Prefer `COUNT(column_name)` over `COUNT(*)` everywhere — aggregates, window functions, subqueries
- Use the primary key column when counting rows: `COUNT(order_id)` not `COUNT(*)`
- Window aggregates follow the same rule: `COUNT(website_pageview_id) OVER (PARTITION BY ...)` not `COUNT(*) OVER (...)`
- In conversion rate patterns, use `COUNT(right_table.pk) / COUNT(left_table.pk)` so students see consistent syntax on both sides of the formula

**Naming:**
- Avoid reserved words as aliases (`year`, `month`, `date`, `order`)
- Use descriptive prefixes: `order_year`, `order_month`, `month_name`
- Use consistent naming: `total_orders`, `total_revenue`, `avg_order_value`

**For BI/Production:**
- Include `YEAR()` when grouping by month to avoid combining data across years
- Use numeric month (`order_month`) for proper sorting, plus `month_name` for display

**Example:**
```sql
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    MONTHNAME(order_date) AS month_name,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY
    YEAR(order_date),
    MONTH(order_date);
```

## What's Next (April 2026)

**Before Wed Apr 29 (Lesson 10 class):**
- Build `lessons/10-streamlit-dashboard/` directory with `README.md` and `tutorial.md` (not `mpX-tutorial.md`, since L10 is not a mini-project)
- Define the Whiteboard Diagram deliverable shape (paired with the Streamlit dashboard for LE10, due Wed May 6)
- Slide deck following the L08/L09 pattern (Marp source + rendered HTML/PDF)

**Before Mon May 4 (Milestone 02 due):**
- Spot-check that `project/README.md` deliverable list still matches what was actually taught
- Consider linking Karpathy's wiki gist directly from `project/README.md` so students see the inspiration alongside the rubric

**Local-only artifacts (gitignored):**
- `docs/chipotle-job-posting.pdf` — Manager, Workforce Management - Volume & Labor role at Chipotle. Used as the "stretch role" demo for Lesson 09 Session 02's wiki design conversation. The role is senior (5+ years) and SQL is implicit rather than explicit; demo framing positions it as "the role you're building toward," not a literal student application target.
- `assignments/project/` — student proposal downloads from Brightspace. Not tracked in git.
- `docs/superpowers/` — internal planning and spec documents. Not tracked in git.
