# Quiz 1 Study Guide
**Wed, Feb 4 | Lessons 01-02 | 40 Minutes | Open Book**

## What to Expect

**Format:**
- **One business scenario** with a problem to diagnose or a success to replicate
- **3 SQL queries**: Descriptive (WHAT) → Diagnostic WHO → Diagnostic WHEN
- **Final insight**: Insight slide title (1 sentence that tells the complete story)
- **Answer blanks**: You'll fill in specific answers based on query results
- **40 minutes total**: ~10-12 min per query + ~5 min for insight

**Important Notes:**
- This quiz is **OPEN BOOK** (notes, lessons, MySQL docs allowed)
- **AI tools are permitted**, but you must be able to explain your work. If asked to explain and you cannot, you will lose all points for that task.
- **Add comments** to explain your thinking and approach — you can receive partial credit for correct logic even if the SQL has errors
- **Quiz 2 will be CLOSED BOOK** (like the midterm interview)
- Practice working efficiently - you won't have time to reference everything

---

## SQL Concepts - Quick Reference

### 1. LAG() - Month-over-Month Comparison
**Purpose**: Compare current row to previous row (e.g., this month vs last month)

```sql
SELECT
    MONTHNAME(order_date) AS month_name,
    COUNT(*) AS orders,
    LAG(COUNT(*)) OVER (ORDER BY MONTH(order_date)) AS prev_month_orders,
    ROUND(
        (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY MONTH(order_date)))
        * 100.0 / LAG(COUNT(*)) OVER (ORDER BY MONTH(order_date)),
        1
    ) AS pct_change
FROM orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);
```

**Key Pattern**: `LAG(column) OVER (ORDER BY sort_column)` gives you previous row's value

### 2. Pivot Pattern - Side-by-Side Month Comparison
**Purpose**: Put months as columns instead of rows for easy comparison

```sql
SELECT
    customer_segment,
    SUM(CASE WHEN MONTH(order_date) = 4 THEN 1 ELSE 0 END) AS april_orders,
    SUM(CASE WHEN MONTH(order_date) = 5 THEN 1 ELSE 0 END) AS may_orders,
    SUM(CASE WHEN MONTH(order_date) = 5 THEN 1 ELSE 0 END) -
    SUM(CASE WHEN MONTH(order_date) = 4 THEN 1 ELSE 0 END) AS change
FROM orders
GROUP BY customer_segment
ORDER BY change DESC;
```

**Key Pattern**: `SUM(CASE WHEN condition THEN 1 ELSE 0 END)` counts rows matching condition

### 3. CASE WHEN - Categorization
**Purpose**: Create categories (e.g., time periods) from numeric values

```sql
SELECT
    CASE
        WHEN HOUR(order_time) >= 6 AND HOUR(order_time) < 12 THEN 'Morning'
        WHEN HOUR(order_time) >= 12 AND HOUR(order_time) < 17 THEN 'Afternoon'
        WHEN HOUR(order_time) >= 17 AND HOUR(order_time) < 22 THEN 'Evening'
        ELSE 'Late Night'
    END AS time_period,
    COUNT(*) AS orders
FROM orders
GROUP BY
    CASE
        WHEN HOUR(order_time) >= 6 AND HOUR(order_time) < 12 THEN 'Morning'
        WHEN HOUR(order_time) >= 12 AND HOUR(order_time) < 17 THEN 'Afternoon'
        WHEN HOUR(order_time) >= 17 AND HOUR(order_time) < 22 THEN 'Evening'
        ELSE 'Late Night'
    END;
```

**Key Pattern**: Must repeat CASE WHEN in both SELECT and GROUP BY

### 4. Percentage Calculations
**Purpose**: Calculate what % one value is of another

```sql
-- Simple percentage
SELECT
    segment_drop * 100.0 / total_drop AS pct_of_drop

-- Percentage with conditional counting
SELECT
    SUM(CASE WHEN promo_code_used = 'Yes' THEN 1 ELSE 0 END) * 100.0
    / COUNT(*) AS promo_pct
```

**Key Pattern**: Multiply by `100.0` (not `100`) to force decimal division

---

## Sample Walkthrough: Fall 2025 Analysis

**Scenario**: October 2025 had fewer orders than September. Analyze WHO drove the drop.

```sql
-- Step 1: See the drop with LAG
SELECT
    MONTHNAME(order_date) AS month_name,
    COUNT(*) AS orders,
    LAG(COUNT(*)) OVER (ORDER BY MONTH(order_date)) AS prev_month,
    ROUND(
        (COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY MONTH(order_date)))
        * 100.0 / LAG(COUNT(*)) OVER (ORDER BY MONTH(order_date)),
        1
    ) AS pct_change
FROM orders
WHERE MONTH(order_date) IN (9, 10) AND YEAR(order_date) = 2025
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);
-- Result: October = 72, September = 90, Change = -20.0%

-- Step 2: Find WHO drove it with pivot pattern
SELECT
    customer_segment,
    SUM(CASE WHEN MONTH(order_date) = 9 THEN 1 ELSE 0 END) AS sept,
    SUM(CASE WHEN MONTH(order_date) = 10 THEN 1 ELSE 0 END) AS oct,
    SUM(CASE WHEN MONTH(order_date) = 10 THEN 1 ELSE 0 END) -
    SUM(CASE WHEN MONTH(order_date) = 9 THEN 1 ELSE 0 END) AS change
FROM orders
WHERE YEAR(order_date) = 2025
GROUP BY customer_segment
ORDER BY change ASC;
-- Result: Grad Student dropped -16 orders (89% of the 18-order drop)
```

---

## Common Mistakes to Avoid

1. **Forgetting `100.0` in percentages**: Use `* 100.0` (decimal) not `* 100` (integer). This forces decimal math and prevents truncation errors. Also, multiply *before* dividing: `segment_drop * 100.0 / total_drop` is safer than `segment_drop / total_drop * 100`.
2. **Not repeating CASE WHEN in GROUP BY**: Must appear in both SELECT and GROUP BY
3. **Wrong date filtering**: `YEAR(order_date) = 2026` vs `order_date >= '2026-01-01'`
4. **LAG() without ORDER BY**: Always specify `OVER (ORDER BY month_column)`
5. **Calculating % of drop wrong**: `segment_drop / total_drop * 100`, not other way around
6. **Time period logic errors**: `HOUR >= 17 AND HOUR < 22` (not `<= 22` - that includes 10pm)

---

## Practice Problems

**Use the Campus Bites database to answer these questions:**

### Practice 1: Basic Month Comparison
Compare April vs May 2026 total orders and revenue. Calculate the percentage change.

### Practice 2: Segment Deep Dive
Which customer segment had the highest order growth from April to May 2026? Show April orders, May orders, and the change.

### Practice 3: Time Period Analysis
For Greek Life customers in Spring 2026, which time period (Morning/Afternoon/Evening/Late Night) had the most orders?

### Practice 4: Combined Analysis
Filter to Off-Campus students only. Compare their April vs May 2026 orders by time period. Which time period grew the most for them?

**Answers will be posted 24 hours before the quiz.**

---

## Strategic Tips & Time Management

**Before the Quiz:**
- Review Lesson Exercises 01 and Lesson Exercises 02
- The quiz follows the same analytical patterns

**Before You Start (2 min):**
- Read the entire scenario and all 3 questions
- Identify: Which months? Which table? What's being compared?
- Note the time period definitions if given

**Time-Saving Tips:**
- Copy-paste repeated CASE WHEN blocks (SELECT → GROUP BY)
- Use previous query as starting point for next (build incrementally)
- Round to 1 decimal place: `ROUND(..., 1)`
- Don't overthink - if it looks right, move on

**Final Insight (6 min):**
- Review all your answers first
- Write as an **insight slide title** - one sentence that tells the complete story
- Include numbers: "[Segment] drove [X]% of the [Y]% [change] in [time period]"
- Example: "Grad Students drove 89% of the 20% order drop, concentrated in Evening hours"

**If You Get Stuck:**
- Check lessons for similar query patterns
- Verify your date filtering first (wrong year = no results)
- Test CASE WHEN logic on a few rows before grouping
- Remember: Open book! Use your resources wisely.

---

## Preparing for Quiz 2 (Closed Book)

Quiz 2 will be **closed book** to mirror the midterm interview. Start preparing now:
- Memorize time period CASE WHEN logic (Morning, Afternoon, Evening, Late Night)
- Practice LAG() syntax without looking it up
- Know the pivot pattern by heart: `SUM(CASE WHEN month = X THEN 1 ELSE 0 END)`
- Understand percentage calculation pattern (numerator * 100.0 / denominator)

**The interview tests your ability to:**
- Break down business problems into SQL queries
- Explain your thinking process out loud
- Debug queries when they don't work
- Interpret results and generate insights

Practice explaining your queries as you write them. "I'm using LAG because..." helps prepare for the verbal component of the interview.
