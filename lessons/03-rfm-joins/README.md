# Lesson 03: Customer Intelligence with RFM Analysis & JOINs

## Learning Objectives

By the end of this lesson, you will be able to:
- Calculate RFM (Recency, Frequency, Monetary) metrics per customer
- Use DATEDIFF() and CURDATE() for date-based calculations
- Classify customers into segments using CASE WHEN and subqueries
- Write INNER JOINs to combine data from multiple tables
- Write LEFT JOINs to find missing data (e.g., refunds)
- Connect analytical findings to business actions

## The Scenario

You're still a data analyst, but this time at **Basket Craft**, an online gift basket company. The VP of Marketing has a request:

> "We want to launch a loyalty campaign for our best customers. Who are they, and how do we reach them?"

Your mission: Use RFM analysis to identify the best customers, then use JOINs to get their contact information for a targeted email campaign.

## Files in This Lesson

| File | Description |
|------|-------------|
| [lesson-03-fname-lname.sql](https://lmu-isba.github.io/isba-4715-f26/lessons/03-rfm-joins/lesson-03-fname-lname.sql) | SQL worksheet template (download, rename with your name, open in DBeaver) |

## Prerequisites

- Completed Lessons 01 and 02
- Comfortable with GROUP BY, CASE WHEN, and aggregate functions

## Database Connection

**This lesson uses a DIFFERENT database than Lessons 01-02!**

| Field | Value |
|-------|-------|
| Host | db.isba.co |
| Port | 3306 |
| Database | **basket_craft** |
| Username | student |
| Password | learn_sql |

### Tables You'll Use

| Table | Description | Key Columns |
|-------|-------------|-------------|
| orders | Customer orders | order_id, user_id, created_at, price_usd, cogs_usd |
| users | Customer profiles | user_id, first_name, last_name, email |
| products | Product catalog (4 items) | product_id, product_name |
| order_items | Line items per order | order_item_id, order_id, product_id, price_usd, cogs_usd |
| order_item_refunds | Refunded items | order_item_refund_id, order_item_id, refund_amount_usd |

## Key Concepts

### RFM Analysis

RFM scores each customer on three dimensions:

| Metric | What It Measures | Calculation | Better = |
|--------|-----------------|-------------|----------|
| **R**ecency | How recently they bought | Days since last order | Fewer days |
| **F**requency | How often they buy | Number of orders | More orders |
| **M**onetary | How much they spend | Total spending | Higher total |

### Why JOINs?

Single-table queries can only answer questions about one dataset. But real business questions span multiple tables:

| Question | Tables Needed |
|----------|--------------|
| "Who are our best customers?" | orders + users |
| "What products sell most?" | order_items + products |
| "Which products get refunded?" | order_items + order_item_refunds |

### JOIN Types in This Lesson

| Type | Returns | Use When |
|------|---------|----------|
| INNER JOIN | Only matching rows from both tables | You want data that exists in both tables |
| LEFT JOIN | All rows from left table + matches from right | You want to find what's missing (NULLs) |

### The Lesson Flow

```
Part 1: Explore basket_craft data
Part 2: RFM Analysis → identify best customers (user_ids only!)
   ↓
THE WALL: "We have user_ids but need names and emails..."
   ↓
Part 3: INNER JOIN → connect orders to users → email list!
Part 4: INNER JOIN → connect order_items to products → product analysis
Part 5: LEFT JOIN → find refunds → quality insights
Part 6: Analysis and recommendations
```
