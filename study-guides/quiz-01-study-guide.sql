-- ============================================================================
-- QUIZ 01 STUDY GUIDE - Practice Problems
-- ============================================================================
--
-- Use these problems to practice the three query patterns on the quiz:
--   1. WHAT happened? (LAG for month-over-month change)
--   2. WHO drove it? (Pivot pattern by segment)
--   3. WHEN did it occur? (CASE WHEN time periods)
--
-- ============================================================================


-- ============================================================================
-- PRACTICE 1: WHAT Happened? (Basic Month Comparison)
-- Maps to: Quiz Query 1
-- ============================================================================
-- Compare April vs May 2026 total orders and revenue.
-- Calculate the percentage change using LAG().
--
-- Your output should show:
--   - month_name
--   - orders
--   - revenue
--   - order_pct_change (use LAG to calculate)
--
-- HINT: Filter to MONTH(order_date) IN (4, 5) AND YEAR(order_date) = 2026
-- HINT: Remember to multiply by 100.0 (not 100) for percentage
--
-- ANSWER: Order % change = _____________

-- Write your query here:




-- ============================================================================
-- PRACTICE 2: WHO Drove It? (Segment Deep Dive)
-- Maps to: Quiz Query 2
-- ============================================================================
-- Which customer segment had the highest order growth from April to May 2026?
-- Show April orders, May orders, and the change for each segment.
--
-- Your output should show:
--   - customer_segment
--   - april_orders
--   - may_orders
--   - order_change
--
-- HINT: Use SUM(CASE WHEN MONTH(order_date) = 4 THEN 1 ELSE 0 END) pattern
-- HINT: ORDER BY order_change DESC to see biggest growth first
--
-- ANSWER: Which segment grew most? _____________
-- ANSWER: By how many orders? _____________

-- Write your query here:




-- ============================================================================
-- PRACTICE 3: WHEN Did It Happen? (Time Period Analysis)
-- Maps to: Quiz Query 3 (simplified version)
-- ============================================================================
-- For Greek Life customers in Spring 2026, which time period had the most orders?
--
-- Time period definitions:
--   Morning:    6am - 12pm  (HOUR >= 6 AND HOUR < 12)
--   Afternoon:  12pm - 5pm  (HOUR >= 12 AND HOUR < 17)
--   Evening:    5pm - 10pm  (HOUR >= 17 AND HOUR < 22)
--   Late Night: 10pm - 6am  (everything else)
--
-- Your output should show:
--   - time_period
--   - orders
--
-- HINT: Use CASE WHEN with HOUR(order_time)
-- HINT: The CASE WHEN must appear in BOTH SELECT and GROUP BY (copy-paste it!)
-- HINT: Filter with WHERE customer_segment = 'Greek Life'
--
-- ANSWER: Which time period had most orders? _____________
-- ANSWER: How many orders? _____________

-- Write your query here:




-- ============================================================================
-- PRACTICE 4: WHO + WHEN Combined (Advanced)
-- Maps to: Quiz Query 3 (full version)
-- ============================================================================
-- Filter to Off-Campus students only.
-- Compare their April vs May 2026 orders by time period.
-- Which time period grew the most for them?
--
-- Your output should show:
--   - time_period
--   - april_orders
--   - may_orders
--   - order_change
--
-- This combines the pivot pattern (Practice 2) with time periods (Practice 3).
-- This is the hardest version - it's what Quiz Query 3 looks like!
--
-- HINT: Start with Practice 3's CASE WHEN for time periods
-- HINT: Add Practice 2's SUM(CASE WHEN month...) pattern for the columns
-- HINT: Filter with WHERE customer_segment = 'Off-Campus'
--
-- ANSWER: Which time period grew most? _____________
-- ANSWER: By how many orders? _____________

-- Write your query here:




-- ============================================================================
-- KEY PATTERNS TO REMEMBER
-- ============================================================================
--
-- 1. LAG() for month-over-month:
--    LAG(COUNT(order_id)) OVER (ORDER BY MONTH(order_date))
--
-- 2. Pivot pattern for segment comparison:
--    SUM(CASE WHEN MONTH(order_date) = 4 THEN 1 ELSE 0 END) AS april_orders
--
-- 3. Time period CASE WHEN:
--    CASE
--        WHEN HOUR(order_time) >= 6 AND HOUR(order_time) < 12 THEN 'Morning'
--        WHEN HOUR(order_time) >= 12 AND HOUR(order_time) < 17 THEN 'Afternoon'
--        WHEN HOUR(order_time) >= 17 AND HOUR(order_time) < 22 THEN 'Evening'
--        ELSE 'Late Night'
--    END AS time_period
--
-- 4. Percentage calculation:
--    (new_value - old_value) * 100.0 / old_value
--    Always use 100.0 (decimal) to force proper division!
--
-- ============================================================================
