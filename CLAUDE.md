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
