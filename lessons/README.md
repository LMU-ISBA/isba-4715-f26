# SQL Lessons

Hands-on SQL lessons using two case studies: **Campus Bites** (a campus food delivery service) and **Basket Craft** (an e-commerce gift basket company).

## Lessons Overview

| Lesson | Topic | Scenario |
|--------|-------|----------|
| [01-introduction](01-introduction/) | Problem Analysis | "Orders dropped 20%" |
| [02-success-analysis](02-success-analysis/) | Success Analysis | "Revenue up 33%" |
| [03-rfm-joins](03-rfm-joins/) | RFM Analysis with JOINs | "Who are our best customers?" |
| [04-cte-funnels](04-cte-funnels/) | Website Conversion with CTEs | "Did our A/B tests work?" |

## The Campus Bites Story (Lessons 01-02)

Campus Bites is a food delivery service for college students. You'll use SQL to analyze real business problems:

### Lesson 01: Problem Analysis
The CEO says orders dropped 20% in October. Your mission: find out what happened and recommend a fix.

### Lesson 02: Success Analysis
Revenue jumped 33% in May. Your mission: find out what's working and how to replicate it.

## The Basket Craft Story (Lessons 03-04)

Basket Craft is an e-commerce company selling gift baskets online. You'll use JOINs, window functions, and CTEs to answer stakeholder questions:

### Lesson 03: RFM Analysis with JOINs
Robert (VP of Marketing) needs a targeted marketing list. Your mission: score customers by Recency, Frequency, and Monetary value using multi-table JOINs and NTILE.

### Lesson 04: Website Conversion Analysis with CTEs
Cheryl (E-commerce Manager) needs to understand visitor behavior. Your mission: build conversion funnels and measure A/B test results using CTEs and ROW_NUMBER.

## Database Connection

All lessons use the same database server. Connection details will be provided in class.

## Getting Started

1. Install [DBeaver Community Edition](https://dbeaver.io/download/)
2. Follow the [setup guide](01-introduction/setup-guide.md)
3. Start with [Lesson 01](01-introduction/)

## File Naming Convention

Each lesson folder contains:

| File | Description |
|------|-------------|
| `README.md` | Lesson overview and objectives |
| `lesson-XX-fname-lname.sql` | Student worksheet (rename with your name) |
| `setup-guide.md` | Setup instructions (Lesson 01 only) |
| `INSTRUCTOR-answer-key.md` | Instructor-only materials |

## SQL Concepts Covered

### Lesson 01
- SELECT, FROM, WHERE
- COUNT(), SUM(), AVG(), ROUND()
- GROUP BY, ORDER BY
- CASE WHEN for categorization
- LAG() for period-over-period comparison
- Date functions: MONTH(), MONTHNAME(), HOUR()

### Lesson 02
- Same concepts, applied to a different scenario
- Multi-level segmentation (segment + time)
- Percentage calculations
- Date range filtering

### Lesson 03
- INNER JOIN, LEFT JOIN (multi-table queries)
- Subqueries in FROM clause
- NTILE() for quantile scoring
- RFM customer segmentation pattern
- COUNT(column) vs COUNT(*) with LEFT JOIN

### Lesson 04
- WITH ... AS (Common Table Expressions)
- Multi-CTE chaining
- ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
- MAX(CASE WHEN ...) flag aggregation
- Conversion funnel pattern
- Revenue per session (A/B test measurement)

## The Analytics Framework

All lessons teach variations of the same diagnostic approach:

1. **Descriptive**: What happened? (totals, trends)
2. **Diagnostic**: Why did it happen?
   - **WHO** drove the change?
   - **WHY** did they change?
   - **WHEN** did it happen?
3. **Confirm** with multiple signals
4. **Recommend** an action
