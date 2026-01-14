# SQL Lessons

Hands-on SQL lessons using the **Campus Bites** case study — a campus food delivery service.

## Lessons Overview

| Lesson | Topic | Scenario |
|--------|-------|----------|
| [01-introduction](01-introduction/) | Problem Analysis | "Orders dropped 20%" |
| [02-success-analysis](02-success-analysis/) | Success Analysis | "Revenue up 33%" |

## The Campus Bites Story

Campus Bites is a food delivery service for college students. Through these lessons, you'll use SQL to analyze real business problems:

### Lesson 01: Problem Analysis
The CEO says orders dropped 20% last month. Your mission: find out what happened and recommend a fix.

### Lesson 02: Success Analysis
Revenue jumped 33% in May. Your mission: find out what's working and how to replicate it.

## Database Connection

All lessons use the same database:

| Field | Value |
|-------|-------|
| Host | db.isba.co |
| Port | 3306 |
| Database | campus_bites |
| Username | student |
| Password | learn_sql |

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

## The Analytics Framework

Both lessons teach the same diagnostic approach:

1. **Descriptive**: What happened? (totals, trends)
2. **Diagnostic**: Why did it happen?
   - **WHO** drove the change?
   - **WHY** did they change?
   - **WHEN** did it happen?
3. **Confirm** with multiple signals
4. **Recommend** an action
