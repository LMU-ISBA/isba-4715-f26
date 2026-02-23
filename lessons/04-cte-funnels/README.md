# Lesson 04: Website Conversion Analysis with CTEs

## Overview

In this lesson, you'll learn to write **Common Table Expressions (CTEs)** — named, reusable query blocks that replace messy nested subqueries. You'll also learn **ROW_NUMBER() with PARTITION BY** to identify the first pageview in each website session, enabling landing page and conversion funnel analysis.

By the end, you'll have the exact SQL patterns needed for Assignment 01 Tasks 4 and 5.

## Learning Objectives

By the end of this lesson, you will be able to:
- Refactor nested subqueries into readable CTEs using `WITH ... AS`
- Chain multiple CTEs together for multi-step analysis
- Use `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` to rank rows within groups
- Calculate bounce rates by identifying single-page sessions
- Build a full conversion funnel using `MAX(CASE WHEN ...)` flag aggregation
- Compare A/B test results using revenue per session calculations
- Write a WHAT / SO WHAT business response to analytical findings

## The Scenario

You're still a data analyst at **Basket Craft**. This time, Cheryl (E-commerce Manager) needs your help understanding website performance:

> "I manage our website and I need to understand how visitors behave. Where do they land? How many bounce? And did our A/B tests actually work?"

Your mission: Use CTEs and window functions to analyze website traffic, build conversion funnels, and measure the impact of A/B tests.

## Files in This Lesson

| File | Description |
|------|-------------|
| [lesson-04-fname-lname.sql](https://lmu-isba.github.io/isba-4715-f26/lessons/04-cte-funnels/lesson-04-fname-lname.sql) | SQL worksheet template (download, rename with your name, open in DBeaver) |

## Prerequisites

- Completed Lessons 01-03
- Comfortable with JOINs, GROUP BY, CASE WHEN, and subqueries
- Familiar with the `basket_craft` database schema

## Database Connection

This lesson continues using the `basket_craft` schema. Connection details will be provided in class.

### Tables You'll Use

| Table | Description | Key Columns |
|-------|-------------|-------------|
| website_pageviews | Every page a visitor viewed | website_pageview_id, website_session_id, pageview_url |
| website_sessions | Every visit to the website | website_session_id, utm_source, utm_campaign, http_referer |
| orders | Customer orders | order_id, website_session_id, price_usd |

## Key Concepts

### CTEs (Common Table Expressions)

A CTE is a named temporary result set defined with `WITH ... AS`. Think of it as giving a subquery a name and moving it to the top of your query:

```sql
-- Instead of this (nested subquery):
SELECT * FROM (SELECT ... FROM ...) AS subquery;

-- Write this (CTE):
WITH subquery AS (SELECT ... FROM ...)
SELECT * FROM subquery;
```

### ROW_NUMBER() OVER (PARTITION BY ...)

Numbers rows within each group. When the partition value changes, the count restarts at 1:

```sql
ROW_NUMBER() OVER (PARTITION BY website_session_id ORDER BY website_pageview_id) AS page_num
-- Row 1 = first pageview in that session (the landing page)
```

### Conversion Funnel Pattern

Flag each session's progress through the funnel using `MAX(CASE WHEN ...)`:

```sql
MAX(CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END) AS to_products
-- MAX() not COUNT() — visiting /products twice still means they got there once
```

## The Lesson Flow

```
Bridge:  Refactor a Lesson 03 query from subqueries → CTEs
Part 1:  DESCRIPTIVE — Explore the website_pageviews table
Part 2:  DIAGNOSTIC — Find landing pages + calculate bounce rates (ROW_NUMBER)
Part 3:  CONFIRM — Build a full conversion funnel A/B test (CTEs + CASE WHEN)
Part 4:  QUANTIFY — Billing page revenue A/B test (revenue per session)
Part 5:  Your Analysis — the complete story
On Your Own: Two challenges that prep for Assignment 01 Tasks 1-2
```
