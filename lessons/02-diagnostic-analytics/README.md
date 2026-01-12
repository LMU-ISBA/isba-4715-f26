# Lesson 02: Diagnostic Analytics — Diagnosing Success

## Learning Objectives

By the end of this lesson, you will be able to:
- Apply the same diagnostic framework to positive trends
- Identify growth drivers through segmentation
- Analyze behavioral patterns (promo usage, time of day)
- Connect multiple signals to form a complete story
- Formulate actionable recommendations from data insights

## The Scenario

You're still the data analyst at **Campus Bites**. After fixing the late-night delivery issue (from Lesson 01), the CEO has great news:

> "Revenue is up 33% this month! What's working — and how do we do more of it?"

Your mission: Use SQL to identify what drove the growth and recommend how to replicate it.

## Files in This Lesson

| File | Description |
|------|-------------|
| [lesson-02-fname-lname.sql](https://lmu-isba.github.io/isba-4715-f26/lessons/02-diagnostic-analytics/lesson-02-fname-lname.sql) | SQL worksheet template (download, rename with your name, open in DBeaver) |

## Prerequisites

- Completed Lesson 01 (database connection already set up)
- Comfortable with GROUP BY, CASE WHEN, and basic aggregations

## Database Connection

Same as Lesson 01:

| Field | Value |
|-------|-------|
| Host | db.isba.co |
| Port | 3306 |
| Database | campus_bites |
| Username | student |
| Password | learn_sql |

## Key Concepts

### Same Framework, Different Question

| Lesson 01 | Lesson 02 |
|-----------|-----------|
| "Why did orders DROP?" | "Why did revenue GROW?" |
| Find the problem | Find the opportunity |
| Fix the issue | Exploit the success |
| Defensive analytics | Offensive analytics |

### 5-Step Analytics Framework (DC ACT)

1. **Define** the business problem
2. **Collect** and prepare the data
3. **Analyze** the data and generate insights
4. **Communicate** the insights, recommendations, and predictions
5. **Act** and track the change

*The same framework works for problems AND opportunities!*

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

## Duration

100 minutes
