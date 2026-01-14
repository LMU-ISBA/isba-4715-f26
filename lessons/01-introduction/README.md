# Lesson 01: Problem Analysis with Descriptive & Diagnostic Analytics

## Why SQL?

SQL is [one of the most valuable skills](https://www.craigkerstiens.com/2019/02/12/sql-one-of-the-most-valuable-skills/) you can learn for a career in business, data, or technology. It's the universal language for working with data.

## Overview

In this lesson, we'll **review foundational SQL concepts** and **learn new techniques** while solving a real business problem. You'll apply SQL skills to diagnose why a company's orders dropped — the same analytical approach used by data analysts in industry.

## Learning Objectives

By the end of this lesson, you will be able to:
- Connect to a MySQL database using DBeaver
- **Review:** Write basic SQL queries using SELECT, FROM, WHERE
- **Review:** Use aggregate functions (COUNT, SUM, AVG, ROUND)
- **Review:** Group and sort data with GROUP BY and ORDER BY
- **New:** Use CASE WHEN for data categorization
- **New:** Calculate month-over-month changes with LAG() window function
- **Apply:** Use SQL to answer business questions through diagnostic analytics

## The Scenario

You're a data analyst at **Campus Bites**, a campus food delivery service. The CEO says:

> "Orders dropped 20% in October. What happened — and how do we fix it?"

Your mission: Use SQL to diagnose the problem and recommend a solution.

## Files in This Lesson

| File | Description |
|------|-------------|
| [setup-guide.md](setup-guide.md) | How to install DBeaver and connect to the database |
| [lesson-01-fname-lname.sql](https://lmu-isba.github.io/isba-4715-f26/lessons/01-introduction/lesson-01-fname-lname.sql) | SQL worksheet template (download, rename with your name, open in DBeaver) |

## Database Setup

1. Download and install [DBeaver Community Edition](https://dbeaver.io/download/)
2. Follow the [setup guide](setup-guide.md) to connect to the database

## Database Connection

| Field | Value |
|-------|-------|
| Host | db.isba.co |
| Port | 3306 |
| Database | campus_bites |
| Username | student |
| Password | learn_sql |

## Key Concepts

### 5-Step Analytics Framework (DC ACT)

1. **Define** the business problem
2. **Collect** and prepare the data
3. **Analyze** the data and generate insights
4. **Communicate** the insights, recommendations, and predictions
5. **Act** and track the change

### Types of Analytics
- **Descriptive Analytics**: What happened? (totals, trends)
- **Diagnostic Analytics**: Why did it happen? (drill-down, segmentation)

### How to Generate Insights

Look for:
- Highest/lowest values?
- Anomalies/outliers?
- Unexpected/surprising results?
- Trends or patterns?
- Correlations/relationships?
- In a group?
- Compared to other groups?
- **ACTIONABLE?**

### Insight Patterns

| Pattern | Question |
|---------|----------|
| Trends | What's changing over time? |
| Ranking | What's best/worst? |
| Contribution | Who/what drives the total? |
| Comparisons | How do groups stack up? |
| Outliers | What stands out? |
| Relationships | What moves together? |

### The Discovery Path
1. Look at overall metrics
2. Find the anomaly in trends
3. Identify WHO drove the change
4. Discover WHY/WHEN it happened
5. Confirm with multiple signals
6. Make a recommendation

