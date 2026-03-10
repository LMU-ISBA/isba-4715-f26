-- ============================================================================
-- QUIZ 2 STUDY GUIDE
-- Lessons 03-04 | Closed Book
-- ============================================================================
--
-- Quiz 2 covers: JOINs, Subqueries, CTEs, ROW_NUMBER() OVER (PARTITION BY),
-- MAX(CASE WHEN) flag aggregation, and NTILE().
--
-- IMPORTANT: Quiz 2 is CLOSED BOOK. You cannot use notes, lessons, or
-- documentation during the quiz. You will have the ENTIRE CLASS PERIOD
-- (100 minutes) to complete it. Use this study guide to practice the
-- patterns you need to memorize.
--
-- QUIZ ENVIRONMENT: You will take the quiz on the CLASSROOM COMPUTERS.
-- Internet access will be restricted to Brightspace and CloudBeaver
-- (a web-based SQL editor). You will write and run your queries in
-- CloudBeaver against the quiz database.
--
-- Quiz database: https://dbeaver.isba.co/
--
-- To familiarize yourself with CloudBeaver before the quiz, try it out:
-- https://dbeaver.isba.co/
--
-- INSIGHTS: After running your queries, you will write insights based on
-- the results. Write each insight as a SLIDE TITLE — a single takeaway
-- statement you'd put on a presentation slide. For example:
--   "Evening Orders Grew 4x While Late Night Declined 50%"
--   "Top 20% of Customers Generate 35% of Total Revenue"
--
-- TIP: Practice writing these queries from scratch without looking at the
-- solutions. That's how you'll need to do it on the quiz.
--
-- ============================================================================


-- ============================================================================
-- SYNTAX REFERENCE — Patterns to Memorize
-- ============================================================================
--
-- 1. JOIN
-- --------------------------------------------------------------------------
--    SELECT columns
--    FROM table1
--        JOIN table2 ON table1.key = table2.key
--    GROUP BY ...;
--
--    INNER JOIN = only rows that match in BOTH tables
--    LEFT JOIN  = ALL rows from left table + matches from right
--
--
-- 2. CTE (Common Table Expression)
-- --------------------------------------------------------------------------
--    WITH cte_name AS (
--        SELECT ...
--        FROM ...
--    )
--    SELECT ...
--    FROM cte_name;
--
--    CRITICAL: No semicolon between the CTE and the SELECT!
--
--
-- 3. Chained CTEs
-- --------------------------------------------------------------------------
--    WITH cte1 AS (
--        SELECT ...
--    ),
--    cte2 AS (
--        SELECT ...
--        FROM cte1
--    )
--    SELECT ...
--    FROM cte2;
--
--    CRITICAL: Use a COMMA between CTEs, not another WITH!
--
--
-- 4. ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
-- --------------------------------------------------------------------------
--    WITH ranked AS (
--        SELECT
--            *,
--            ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS row_num
--        FROM orders
--    )
--    SELECT *
--    FROM ranked
--    WHERE row_num = 1;
--
--    ASC  = first/earliest
--    DESC = last/most recent
--
--
-- 5. MAX(CASE WHEN) Flag Aggregation
-- --------------------------------------------------------------------------
--    SELECT
--        user_id,
--        MAX(CASE WHEN condition THEN 1 ELSE 0 END) AS flag_name
--    FROM table
--    GROUP BY user_id;
--
--    WHY MAX not COUNT: If someone did something twice, MAX(1) = 1 (correct).
--    COUNT would give 2, which isn't a flag.
--
--
-- 6. NTILE(n) — Scoring into Tiers
-- --------------------------------------------------------------------------
--    SELECT
--        *,
--        NTILE(4) OVER (ORDER BY total_spending DESC) AS spending_tier
--    FROM customer_totals;
--
--    Divides rows into n roughly equal groups.
--    Tier 1 = highest when ORDER BY ... DESC.
--
--
-- 7. HAVING — Filter After Grouping
-- --------------------------------------------------------------------------
--    SELECT user_id, COUNT(order_id) AS total_orders
--    FROM orders
--    GROUP BY user_id
--    HAVING COUNT(order_id) >= 2;
--
--    WHERE = filters rows BEFORE GROUP BY
--    HAVING = filters groups AFTER GROUP BY (can use aggregates)
--
-- ============================================================================


-- ============================================================================
-- PRACTICE 1: JOIN + GROUP BY
-- ============================================================================
-- For each user, count their total website sessions and total orders.
-- Show the top 5 most active users by session count.
--
-- Tables: website_sessions, orders
-- JOIN ON: website_session_id
-- Think about: Should this be INNER JOIN or LEFT JOIN? (Not every session
-- leads to an order.)
--
-- Write your query below:




-- ANSWER: How many sessions does the most active user have? _____________
-- ANSWER: How many orders did they place? _____________


-- ============================================================================
-- PRACTICE 2: Subquery → CTE Refactoring
-- ============================================================================
-- The query below calculates monthly revenue for 2025 using a SUBQUERY.
-- REWRITE it as a CTE using WITH ... AS syntax.
-- Your output should be identical.

-- GIVEN (subquery version — do NOT modify this, rewrite it below):
/*
SELECT order_year, order_month, month_name, monthly_revenue,
    ROUND(monthly_revenue - LAG(monthly_revenue)
        OVER (ORDER BY order_year, order_month), 2) AS revenue_change
FROM (
    SELECT YEAR(created_at) AS order_year,
           MONTH(created_at) AS order_month,
           MONTHNAME(created_at) AS month_name,
           ROUND(SUM(price_usd), 2) AS monthly_revenue
    FROM orders
    WHERE YEAR(created_at) = 2025
    GROUP BY YEAR(created_at), MONTH(created_at), MONTHNAME(created_at)
) AS monthly_totals
ORDER BY order_year, order_month;
*/

-- YOUR CTE VERSION below:




-- ANSWER: Which month had the biggest revenue increase? _____________
-- ANSWER: Which month had a revenue DECREASE? _____________


-- ============================================================================
-- PRACTICE 3: Chained CTEs
-- ============================================================================
-- Build TWO CTEs chained together:
--
-- CTE 1 (customer_spending):
--   Calculate each customer's total_orders, avg_order_value, and total_spending
--   from the orders table. GROUP BY user_id.
--
-- CTE 2 (above_average):
--   JOIN customer_spending to users table to get names and email.
--   Filter to only customers whose avg_order_value is above the overall average.
--   HINT: Use a subquery in the WHERE clause:
--     WHERE avg_order_value > (SELECT AVG(avg_order_value) FROM customer_spending)
--
-- Final SELECT: Show all columns from above_average, ORDER BY total_spending DESC, LIMIT 10.
--
-- Write your query below:




-- ANSWER: Who is the top spender? _____________
-- ANSWER: What is their total spending? $ _____________


-- ============================================================================
-- PRACTICE 4: ROW_NUMBER — Most Recent Order
-- ============================================================================
-- For each customer, find their MOST RECENT order.
-- Show the 10 most recent orders with customer names.
--
-- Step 1: CTE with ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC)
--         Notice: DESC gives you the MOST RECENT order as row 1
-- Step 2: Filter WHERE order_num = 1
-- Step 3: JOIN to users for names
-- Step 4: ORDER BY created_at DESC, LIMIT 10
--
-- Write your query below:




-- ANSWER: What product_id appears most in the recent orders? _____________


-- ============================================================================
-- PRACTICE 5: MAX(CASE WHEN) Flags
-- ============================================================================
-- Flag whether each customer has placed an order in 2023, 2024, and/or 2025.
-- Show the top 10 customers by total orders.
--
-- Columns needed:
--   user_id
--   MAX(CASE WHEN YEAR(created_at) = 2023 THEN 1 ELSE 0 END) AS ordered_2023
--   MAX(CASE WHEN YEAR(created_at) = 2024 THEN 1 ELSE 0 END) AS ordered_2024
--   MAX(CASE WHEN YEAR(created_at) = 2025 THEN 1 ELSE 0 END) AS ordered_2025
--   COUNT(order_id) AS total_orders
--
-- Remember: MAX not COUNT for flags!
--
-- Write your query below:




-- ANSWER: Do any customers with 3 orders have flags in multiple years? _____________


-- ============================================================================
-- PRACTICE 6: NTILE Quintiles
-- ============================================================================
-- Score ALL customers into QUINTILES (5 tiers) by total spending.
-- Show summary statistics per tier.
--
-- Step 1: CTE (customer_totals) — total_orders and total_spending per user_id
-- Step 2: Subquery or CTE with NTILE(5) OVER (ORDER BY total_spending DESC)
-- Step 3: GROUP BY spending_quintile, show COUNT, MIN, MAX, AVG spending
--
-- Write your query below:




-- ANSWER: How many customers are in each tier? _____________
-- ANSWER: What is the spending range for Tier 1? $ _________ to $ _________


-- ============================================================================
-- KEY TAKEAWAYS
-- ============================================================================
--
-- 1. JOIN Pattern: table1 JOIN table2 ON table1.key = table2.key
--    - Use INNER JOIN when you only want matching rows
--    - Use LEFT JOIN when you want ALL rows from the left table
--
-- 2. CTE Pattern: WITH name AS (subquery) SELECT ... FROM name
--    - NO semicolon between CTE and SELECT!
--    - Chained CTEs use comma: WITH cte1 AS (...), cte2 AS (...) SELECT ...
--
-- 3. ROW_NUMBER: ROW_NUMBER() OVER (PARTITION BY col ORDER BY col)
--    - ASC = first/earliest, DESC = last/most recent
--    - Filter with WHERE order_num = 1 in outer query
--
-- 4. MAX(CASE WHEN): MAX(CASE WHEN condition THEN 1 ELSE 0 END)
--    - Creates binary flags (0/1) for each category
--    - Use MAX not COUNT — "did it happen at least once?"
--
-- 5. NTILE(n): NTILE(n) OVER (ORDER BY col DESC)
--    - Divides rows into n roughly equal groups
--    - Tier 1 = highest when ORDER BY DESC
--
-- 6. HAVING vs WHERE:
--    - WHERE filters BEFORE grouping
--    - HAVING filters AFTER grouping (can use aggregate functions)
--
-- COMMON ERRORS TO AVOID:
--    - Semicolon between CTE and SELECT (query fails)
--    - Writing WITH twice instead of using comma for chained CTEs
--    - Using COUNT instead of MAX for flags
--    - Forgetting PARTITION BY in ROW_NUMBER (numbers ALL rows together)
--    - Using WHERE instead of HAVING with aggregate conditions
--
-- These patterns repeat across all Quiz 02 problems!
-- ============================================================================
