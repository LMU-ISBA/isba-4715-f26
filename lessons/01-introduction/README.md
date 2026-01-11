# Lesson 01: Introduction to SQL Analytics

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

> "Orders dropped 20% last month. What happened — and how do we fix it?"

Your mission: Use SQL to diagnose the problem and recommend a solution.

## Files in This Lesson

| File | Description |
|------|-------------|
| [setup-guide.md](setup-guide.md) | How to install DBeaver and connect to the database |
| [lesson-01-worksheet.sql](lesson-01-worksheet.sql) | SQL exercises to complete during class (open in DBeaver) |

## Before Class

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

### Analytics Framework
- **Descriptive Analytics**: What happened? (totals, trends)
- **Diagnostic Analytics**: Why did it happen? (drill-down, segmentation)

### The Discovery Path
1. Look at overall metrics
2. Find the anomaly in trends
3. Identify WHO drove the change
4. Discover WHY/WHEN it happened
5. Confirm with multiple signals
6. Make a recommendation

## Duration

100 minutes (includes 20 min syllabus review)
