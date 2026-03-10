-- ============================================================================
-- QUIZ 2 STUDY GUIDE - SOLUTIONS
-- ============================================================================
--
-- Full solutions for all 6 practice problems on the basket_craft database.
--
-- ============================================================================


-- ============================================================================
-- PRACTICE 1: JOIN + GROUP BY
-- ============================================================================
-- For each marketing channel (utm_source), count the total website sessions
-- and total orders. Calculate a conversion rate.

SELECT
    ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) * 100, 2) AS conversion_rate
FROM website_sessions ws
    LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source
ORDER BY total_sessions DESC;

-- Expected Results:
-- | utm_source | total_sessions | total_orders | conversion_rate |
-- |------------|----------------|--------------|-----------------|
-- | google     | 316035         | 21333        | 6.75            |
-- | NULL       | 83328          | 6118         | 7.34            |
-- | bing       | 62823          | 4519         | 7.19            |
-- | facebook   | 10685          | 343          | 3.21            |

-- ANSWER: Google has the most sessions (316,035). Direct/organic (NULL) has
-- the highest conversion rate (7.34%). Facebook converts at less than half
-- the rate of other channels (3.21%).


-- ============================================================================
-- PRACTICE 2: Subquery → CTE Refactoring
-- ============================================================================
-- GIVEN this subquery that calculates monthly revenue for 2025:
--
-- SELECT order_year, order_month, month_name, monthly_revenue,
--     ROUND(monthly_revenue - LAG(monthly_revenue)
--         OVER (ORDER BY order_year, order_month), 2) AS revenue_change
-- FROM (
--     SELECT YEAR(created_at) AS order_year,
--            MONTH(created_at) AS order_month,
--            MONTHNAME(created_at) AS month_name,
--            ROUND(SUM(price_usd), 2) AS monthly_revenue
--     FROM orders
--     WHERE YEAR(created_at) = 2025
--     GROUP BY YEAR(created_at), MONTH(created_at), MONTHNAME(created_at)
-- ) AS monthly_totals
-- ORDER BY order_year, order_month;
--
-- REWRITE it as a CTE using WITH ... AS:

WITH monthly_totals AS (
    SELECT
        YEAR(created_at) AS order_year,
        MONTH(created_at) AS order_month,
        MONTHNAME(created_at) AS month_name,
        ROUND(SUM(price_usd), 2) AS monthly_revenue
    FROM orders
    WHERE YEAR(created_at) = 2025
    GROUP BY
        YEAR(created_at),
        MONTH(created_at),
        MONTHNAME(created_at)
)
SELECT
    order_year,
    order_month,
    month_name,
    monthly_revenue,
    ROUND(monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY order_year, order_month), 2) AS revenue_change
FROM monthly_totals
ORDER BY order_year, order_month;

-- Expected Results:
-- | order_year | order_month | month_name | monthly_revenue | revenue_change |
-- |------------|-------------|------------|-----------------|----------------|
-- | 2025       | 1           | January    | 56766.86        | NULL           |
-- | 2025       | 2           | February   | 65848.56        | 9081.70        |
-- | 2025       | 3           | March      | 68379.68        | 2531.12        |
-- | 2025       | 4           | April      | 78553.47        | 10173.79       |
-- | 2025       | 5           | May        | 89117.24        | 10563.77       |
-- | 2025       | 6           | June       | 79507.37        | -9609.87       |
-- | 2025       | 7           | July       | 83236.56        | 3729.19        |
-- | 2025       | 8           | August     | 85111.99        | 1875.43        |
-- | 2025       | 9           | September  | 92002.52        | 6890.53        |
-- | 2025       | 10          | October    | 103925.99       | 11923.47       |
-- | 2025       | 11          | November   | 128097.00       | 24171.01       |
-- | 2025       | 12          | December   | 145036.97       | 16939.97       |

-- ANSWER: Revenue grew every month in 2025 except June (-$9,609.87).
-- The biggest growth was November (+$24,171.01).


-- ============================================================================
-- PRACTICE 3: Chained CTEs
-- ============================================================================
-- CTE 1: Calculate each customer's average order value and total spending.
-- CTE 2: JOIN to users table, filter to customers with above-average
--         avg order value.
-- Show the top 10 by total spending.

WITH customer_spending AS (
    SELECT
        user_id,
        COUNT(order_id) AS total_orders,
        ROUND(AVG(price_usd), 2) AS avg_order_value,
        ROUND(SUM(price_usd), 2) AS total_spending
    FROM orders
    GROUP BY user_id
),
above_average AS (
    SELECT
        cs.user_id,
        u.first_name,
        u.last_name,
        u.email,
        cs.total_orders,
        cs.avg_order_value,
        cs.total_spending
    FROM customer_spending cs
        JOIN users u ON cs.user_id = u.user_id
    WHERE cs.avg_order_value > (SELECT AVG(avg_order_value) FROM customer_spending)
)
SELECT *
FROM above_average
ORDER BY total_spending DESC
LIMIT 10;

-- Expected Results:
-- | user_id | first_name | last_name | email                        | total_orders | avg_order_value | total_spending |
-- |---------|------------|-----------|------------------------------|--------------|-----------------|----------------|
-- | 341972  | Laura      | Burns     | laura.burns@gmail.com        | 3            | 83.98           | 251.94         |
-- | 324814  | Joshua     | Moore     | joshua.moore@yahoo.com       | 3            | 81.98           | 245.95         |
-- | 172266  | David      | Hicks     | david.hicks@gmail.com        | 3            | 79.32           | 237.95         |
-- | 275098  | Nicholas   | Gutierrez | nicholas.gutierrez@yahoo.com | 3            | 78.65           | 235.95         |
-- | 281298  | Colton     | Wong      | colton.wong@gmail.com        | 2            | 109.98          | 219.96         |
-- | 142410  | Ann        | Myers     | ann.myers@gmail.com          | 3            | 73.32           | 219.96         |
-- | 317773  | Andrew     | Johns     | andrew.johns@gmail.com       | 2            | 107.98          | 215.96         |
-- | 336150  | Rebecca    | Potter    | rebecca.potter@gmail.com     | 3            | 69.98           | 209.95         |
-- | 307597  | Victoria   | Campbell  | victoria.campbell@gmail.com  | 2            | 102.98          | 205.96         |
-- | 158790  | Nicole     | Bishop    | nicole.bishop@aol.com        | 3            | 68.65           | 205.96         |

-- ANSWER: There are 11,433 customers with above-average order values.
-- Laura Burns leads with $251.94 total spending across 3 orders.


-- ============================================================================
-- PRACTICE 4: ROW_NUMBER — Most Recent Order
-- ============================================================================
-- For each customer, find their MOST RECENT order (use DESC, not ASC).
-- Show the 10 most recent orders with customer names and product info.

WITH ranked_orders AS (
    SELECT
        o.order_id,
        o.user_id,
        o.created_at,
        o.price_usd,
        o.primary_product_id,
        ROW_NUMBER() OVER (PARTITION BY o.user_id ORDER BY o.created_at DESC) AS order_num
    FROM orders o
)
SELECT
    ro.user_id,
    u.first_name,
    u.last_name,
    ro.order_id,
    ro.created_at,
    ro.price_usd,
    ro.primary_product_id
FROM ranked_orders ro
    JOIN users u ON ro.user_id = u.user_id
WHERE ro.order_num = 1
ORDER BY ro.created_at DESC
LIMIT 10;

-- Expected Results:
-- | user_id | first_name | last_name | order_id | created_at          | price_usd | primary_product_id |
-- |---------|------------|-----------|----------|---------------------|-----------|--------------------|
-- | 386000  | Leslie     | Woods     | 32313    | 2026-03-19 17:38:31 | 49.99     | 1                  |
-- | 394273  | Leslie     | Riley     | 32312    | 2026-03-19 17:35:57 | 29.99     | 4                  |
-- | 394268  | Michelle   | Parker    | 32311    | 2026-03-19 17:27:28 | 89.98     | 2                  |
-- | 394257  | Kimberly   | Schneider | 32310    | 2026-03-19 16:10:43 | 29.99     | 4                  |
-- | 394255  | Natalie    | Obrien    | 32309    | 2026-03-19 15:58:12 | 49.99     | 1                  |
-- | 394231  | Jessica    | Wheeler   | 32308    | 2026-03-19 14:11:42 | 49.99     | 1                  |
-- | 394226  | Richard    | Smith     | 32307    | 2026-03-19 13:51:39 | 45.99     | 3                  |
-- | 365383  | Susan      | Vega      | 32306    | 2026-03-19 13:42:17 | 29.99     | 4                  |
-- | 377958  | Donald     | Black     | 32305    | 2026-03-19 13:04:35 | 49.99     | 1                  |
-- | 394207  | Scott      | Dodson    | 32304    | 2026-03-19 12:37:21 | 75.98     | 3                  |

-- ANSWER: The most recent orders are from March 2026. Product 1 (Original)
-- and product 4 (Holiday) are the most common recent purchases.


-- ============================================================================
-- PRACTICE 5: MAX(CASE WHEN) Flags
-- ============================================================================
-- Flag whether each customer has placed an order in 2023, 2024, and/or 2025.
-- Show the top 10 customers by total orders.

SELECT
    user_id,
    MAX(CASE WHEN YEAR(created_at) = 2023 THEN 1 ELSE 0 END) AS ordered_2023,
    MAX(CASE WHEN YEAR(created_at) = 2024 THEN 1 ELSE 0 END) AS ordered_2024,
    MAX(CASE WHEN YEAR(created_at) = 2025 THEN 1 ELSE 0 END) AS ordered_2025,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;

-- Expected Results:
-- | user_id | ordered_2023 | ordered_2024 | ordered_2025 | total_orders |
-- |---------|--------------|--------------|--------------|--------------|
-- | 122640  | 0            | 1            | 0            | 3            |
-- | 157480  | 0            | 0            | 1            | 3            |
-- | 24159   | 1            | 0            | 0            | 3            |
-- | 142410  | 0            | 1            | 1            | 3            |
-- | 68624   | 0            | 1            | 0            | 3            |
-- | 69639   | 0            | 1            | 0            | 3            |
-- | 158032  | 0            | 0            | 1            | 3            |
-- | 107850  | 0            | 1            | 0            | 3            |
-- | 99029   | 0            | 1            | 0            | 3            |
-- | 83383   | 0            | 1            | 0            | 3            |

-- ANSWER: Most 3-order customers placed all their orders within a single year.
-- User 142410 is an exception — they ordered in both 2024 and 2025.


-- ============================================================================
-- PRACTICE 6: NTILE Quintiles
-- ============================================================================
-- Score ALL customers into QUINTILES (5 tiers) by total spending.
-- Show summary statistics per tier.

WITH ranked_spending AS (
    SELECT
        user_id,
        ROUND(SUM(price_usd), 2) AS total_spending,
        NTILE(5) OVER (ORDER BY SUM(price_usd) DESC) AS spending_quintile
    FROM orders
    GROUP BY user_id
)
SELECT
    spending_quintile,
    COUNT(user_id) AS customers_in_tier,
    ROUND(MIN(total_spending), 2) AS min_spending,
    ROUND(MAX(total_spending), 2) AS max_spending,
    ROUND(AVG(total_spending), 2) AS avg_spending
FROM ranked_spending
GROUP BY spending_quintile
ORDER BY spending_quintile;

-- Expected Results:
-- | spending_quintile | customers_in_tier | min_spending | max_spending | avg_spending |
-- |-------------------|-------------------|--------------|--------------|--------------|
-- | 1                 | 6340              | 79.98        | 251.94       | 95.44        |
-- | 2                 | 6339              | 49.99        | 79.98        | 63.21        |
-- | 3                 | 6339              | 49.99        | 49.99        | 49.99        |
-- | 4                 | 6339              | 49.99        | 49.99        | 49.99        |
-- | 5                 | 6339              | 29.99        | 49.99        | 47.16        |

-- ANSWER: Tiers 3 and 4 both show $49.99 min and max — most customers bought
-- exactly one item at $49.99 (the Original product). Tier 1 ranges up to $251.94,
-- containing the multi-order customers.


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
-- These patterns will appear throughout the course!
-- ============================================================================
