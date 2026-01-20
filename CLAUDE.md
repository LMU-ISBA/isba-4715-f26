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

Each lesson folder contains:
- `README.md` - Lesson overview and links for students
- `setup-guide.md` - Tool setup instructions (Lesson 01 only)
- `lesson-XX-fname-lname.sql` - Student worksheet template
- `INSTRUCTOR-answer-key.md` - Instructor guide with answers (gitignored)

### Editing the Syllabus

The `index.html` is a self-contained file with embedded CSS. Key sections:
- Header: Course title, subtitle, info badges
- Navigation: Sticky nav with smooth scroll
- Sections: Overview, Instructor, Schedule, Grading, Tips, Policies

CSS variables in `:root` control theming (colors, radius, shadows).

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

## SQL Best Practices
When writing SQL queries in worksheets and instructor keys:

**Formatting:**
- Put major keywords on their own line: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`
- Indent columns and conditions with 4 spaces
- Put each column on its own line in multi-column SELECTs
- Put each expression on its own line in multi-expression GROUP BY and ORDER BY clauses

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
    COUNT(*) AS total_orders,
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
