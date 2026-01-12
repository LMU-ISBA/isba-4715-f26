-- ============================================================================
-- LESSON 01: Campus Bites Analytics - Diagnosing a Problem
-- ============================================================================
--
-- SCENARIO: You're a data analyst at Campus Bites, a campus food delivery
-- service. The CEO says: "Orders dropped 20% last month. What happened?"
--
-- YOUR MISSION: Use SQL to find out what caused the drop and recommend actions.
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                  | Status  | Used In    |
-- |--------------------------|---------|------------|
-- | SELECT, FROM, WHERE      | Review  | Parts 1-2  |
-- | COUNT, SUM, AVG, ROUND   | Review  | Parts 1-2  |
-- | GROUP BY, ORDER BY       | Review  | Parts 2-3  |
-- | CASE WHEN                | NEW     | Parts 4-5  |
-- | LAG() window function    | NEW     | Part 2     |
-- ============================================================================


-- ============================================================================
-- PART 1: CONNECT AND EXPLORE (Review)
-- ============================================================================

-- 1.1 First Look at the Data
-- Write a query to see the first 5 rows of the orders table.
-- Type your query below, then press Ctrl+Enter (Windows) or Cmd+Enter (Mac) to run it.

-- ANSWER: What columns do you see?




-- 1.2 How Much Data?
-- Write a query to count the total number of orders.
-- ANSWER: _________ orders




-- 1.3 Date Range
-- Write a query to find the earliest and latest order dates.
-- ANSWER: From _________ to _________




-- ============================================================================
-- PART 2: DESCRIPTIVE ANALYTICS - What Happened? (Review + New)
-- ============================================================================
-- Descriptive analytics answers: "What happened?" using totals and summaries.

-- 2.1 Overall Metrics (Scorecards)
-- Write a query to calculate:
--   - Total orders
--   - Total revenue (rounded to 2 decimal places)
--   - Average order value (rounded to 2 decimal places)
--   - Average delivery time (rounded to 1 decimal place)
--
-- ANSWER:
-- | Metric              | Value |
-- |---------------------|-------|
-- | Total Orders        |       |
-- | Total Revenue       | $     |
-- | Average Order Value | $     |
-- | Avg Delivery Time   |  mins |




-- 2.2 Monthly Trends
-- Write a query to show orders and revenue by month, ordered chronologically.
-- HINT: Use MONTHNAME() and GROUP BY
--
-- ANSWER: Which month had the lowest orders? _____________
-- ANSWER: Which month had the lowest revenue? _____________




-- 2.3 Calculate Month-over-Month Change (NEW: LAG function)
-- The CEO said orders dropped 20% in October. Let's verify using LAG().
-- LAG() looks at the previous row's value - useful for period comparisons.
--
-- ANSWER: What was the % change in October? __________%




-- ============================================================================
-- PART 3: DIAGNOSTIC ANALYTICS - WHO Drove the Drop? (Review)
-- ============================================================================
-- Diagnostic analytics answers: "Why did it happen?"

-- 3.1 Orders by Customer Segment
-- Write a query to show total orders, total revenue, and average order value
-- by customer segment, ordered by total orders descending.
--
-- ANSWER: Which segment has the most orders? _____________
-- ANSWER: Which segment has the highest average order value? _____________




-- 3.2 Compare September vs October by Segment
-- Write a query to compare September vs October orders by segment.
-- HINT: SUM(CASE WHEN MONTH(order_date) = 9 THEN 1 ELSE 0 END) AS sept_orders
--
-- ANSWER: Which segment dropped the most? _____________
-- ANSWER: By how many orders? _____________




-- ============================================================================
-- PART 4: DIAGNOSTIC ANALYTICS - WHY Did They Drop? (NEW: CASE WHEN)
-- ============================================================================

-- 4.1 Time of Day Analysis
-- Write a query to count orders by time period using CASE WHEN:
--   - Morning: 6 AM - 12 PM (hour >= 6 AND hour < 12)
--   - Afternoon: 12 PM - 5 PM (hour >= 12 AND hour < 17)
--   - Evening: 5 PM - 10 PM (hour >= 17 AND hour < 22)
--   - Late Night: 10 PM - 6 AM (else)
--
-- HINT: Use HOUR(order_time) to extract the hour
--
-- ANSWER: Which time period has the most orders overall? _____________




-- 4.2 Compare September vs October by Time Period
-- Write a query to compare September vs October by time period.
--
-- ANSWER: Which time period dropped the most? _____________
-- ANSWER: By how many orders? _____________




-- 4.3 Who Orders Late Night?
-- Write a query to count late-night orders by customer segment.
-- (Late night = hour < 6 OR hour >= 22)
--
-- ANSWER: Which segment orders most during Late Night? _____________




-- ============================================================================
-- PART 5: CONFIRM THE CONNECTION (Applying New Concepts)
-- ============================================================================

-- 5.1 Grad Students - Time of Day Breakdown
-- Write a query to compare September vs October by time period,
-- but ONLY for Grad Students.
-- HINT: Add WHERE customer_segment = 'Grad Student'
--
-- ANSWER: What time period did Grad Students stop ordering? _____________
-- ANSWER: How many Late Night orders in September? _____________
-- ANSWER: How many Late Night orders in October? _____________




-- ============================================================================
-- PART 6: YOUR ANALYSIS
-- ============================================================================

-- Based on your SQL analysis, answer these questions:

-- THE COMPLETE STORY:
-- 1. What happened? (Describe the trend)
--    ANSWER: _______________________________________________________________
--
-- 2. Who drove it? (Which customer segment)
--    ANSWER: _______________________________________________________________
--
-- 3. Why? (What caused the drop)
--    ANSWER: _______________________________________________________________
--
-- 4. When? (What time period saw the biggest change)
--    ANSWER: _______________________________________________________________

-- YOUR INSIGHT STATEMENT:
-- Write a single sentence using: [WHO] + [DID WHAT] + [BY HOW MUCH] + [WHY]
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________

-- YOUR RECOMMENDATION:
-- What should Campus Bites do to fix this problem?
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________


-- ============================================================================
-- BONUS CHALLENGES
-- ============================================================================

-- Challenge 1: Cuisine Analysis
-- Which cuisine type is most popular? Does it vary by segment?




-- Challenge 2: Repeat Customers
-- What percentage of orders are from repeat customers? (Use is_reorder column)




-- Challenge 3: Your Own Analysis
-- Write a query that answers a business question you're curious about.
-- YOUR QUESTION: ___________________________________________________________



-- YOUR FINDING: ____________________________________________________________


-- ============================================================================
-- SQL CONCEPTS COVERED
-- ============================================================================
-- Review: SELECT, FROM, WHERE
-- Review: COUNT(), SUM(), AVG(), ROUND()
-- Review: GROUP BY, ORDER BY
-- NEW: CASE WHEN for categorization
-- NEW: LAG() for period-over-period comparison
-- NEW: Date functions: MONTH(), MONTHNAME(), HOUR()
-- ============================================================================
