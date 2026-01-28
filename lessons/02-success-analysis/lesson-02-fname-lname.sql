-- ============================================================================
-- LESSON 02: Success Analysis with Descriptive & Diagnostic Analytics
-- ============================================================================
--
-- SCENARIO: After addressing the issue from Lesson 01, business
-- stabilized. Now the CEO says: "Revenue is up 33% in May! What's working?"
--
-- YOUR MISSION: Use SQL to find what drove the growth and how to replicate it.
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                  | Status     | Used In    |
-- |--------------------------|------------|------------|
-- | SELECT, FROM, WHERE      | Review     | Part 1     |
-- | COUNT, SUM, AVG, ROUND   | Review     | Part 1     |
-- | GROUP BY, ORDER BY       | Review     | Parts 1-5  |
-- | CASE WHEN                | Reinforce  | Parts 2-5  |
-- | LAG() window function    | Reinforce  | Part 1     |
-- | Date functions           | Reinforce  | All Parts  |
-- ============================================================================
-- This lesson applies the same diagnostic framework to a POSITIVE trend.
-- Same techniques, different question: "What's working?" vs "What's broken?"
-- ============================================================================


-- ============================================================================
-- PART 1: DESCRIPTIVE ANALYTICS - What Happened?
-- ============================================================================

-- 1.1 Focus on Spring Semester
-- Write a query to show orders and revenue by month for Spring 2026 (March-May).
-- HINT: WHERE order_date BETWEEN '2026-03-01' AND '2026-05-31'
--
-- ANSWER: Which month had the spike in orders? _____________
-- ANSWER: How many orders that month? _____________




-- 1.2 Spring Semester Metrics
-- Write a query to calculate overall metrics for Spring 2026 (March-May):
--   - Total orders, revenue, avg order value, avg delivery time
-- HINT: Use the same BETWEEN filter from 1.1
--
-- ANSWER:
-- | Metric              | Value |
-- |---------------------|-------|
-- | Total Orders        |       |
-- | Total Revenue       | $     |
-- | Average Order Value | $     |
-- | Avg Delivery Time   |  mins |




-- 1.2b Compare Spring 2026 vs Fall 2025
-- Write a query comparing Fall 2025 vs Spring 2026 using CASE WHEN.
-- This shows how the business improved after fixing the late-night issue.
-- HINT: Filter to Fall 2025 OR Spring 2026 dates, then use CASE WHEN to label:
--       CASE WHEN order_date < '2026-01-01' THEN 'Fall 2025' ELSE 'Spring 2026' END
--
-- ANSWER: Which semester had more orders? _____________
-- ANSWER: Did average delivery time improve? _____________




-- 1.3 Month-over-Month Change
-- Write a query using LAG() to calculate month-over-month % change
-- in revenue for Spring 2026 (March-May).
--
-- ANSWER: What was the revenue % change in May? __________%
-- ANSWER: What was the order count % change in May? __________%




-- ============================================================================
-- PART 2: DIAGNOSTIC ANALYTICS - WHO Drove the Growth?
-- ============================================================================

-- 2.1 Orders by Customer Segment (Spring Semester)
-- Write a query to show orders, revenue, and avg order value by segment
-- for Spring 2026 (March-May).
--
-- ANSWER: Which segment has the most orders? _____________
-- ANSWER: Which segment has the highest average order value? _____________




-- 2.1b April vs May Total Orders (Pivot Pattern Intro)
-- Write a query to compare April vs May total orders using CASE WHEN.
-- This "pivot" pattern puts months side-by-side instead of as rows.
-- Pattern: SUM(CASE WHEN MONTH(order_date) = 4 THEN 1 ELSE 0 END) AS april_orders
--
-- ANSWER: April orders = _____________
-- ANSWER: May orders = _____________
-- ANSWER: Change = _____________




-- 2.2 Compare April vs May by Segment
-- Write a query to compare April vs May orders by segment using CASE WHEN.
-- This builds on 2.1b — add GROUP BY customer_segment to see each segment's pivot.
-- HINT: Use the same SUM(CASE WHEN...) pattern from 2.1b, just add GROUP BY
--
-- ANSWER: Which segment grew the most? _____________
-- ANSWER: By how many orders? _____________
-- ANSWER: What % of total growth did this segment drive? _________%




-- ============================================================================
-- PART 3: DIAGNOSTIC ANALYTICS - WHEN Did They Order?
-- ============================================================================

-- 3.1 Time of Day Analysis (May only)
-- Write a query to count orders by time period for May 2026.
-- Use the same time categories as Lesson 01:
--   - Morning: 6 AM - 12 PM
--   - Afternoon: 12 PM - 5 PM
--   - Evening: 5 PM - 10 PM
--   - Late Night: 10 PM - 6 AM
--
-- ANSWER: Which time period had the most orders in May? _____________




-- 3.1b April vs May by Time Period (Combining Patterns)
-- Write a query showing April and May orders side-by-side for each time period.
-- This combines two patterns you've learned:
--   1. CASE WHEN for time period categorization (from 3.1)
--   2. SUM(CASE WHEN) pivot columns (from 2.1b)
--
-- ANSWER: Afternoon had _____ orders in April and _____ in May




-- 3.2 Compare April vs May by Time Period
-- Write a query to compare April vs May by time period WITH the change calculation.
-- This builds on 3.1b — add the order_change column to quantify growth.
-- HINT: Add a third column: may - april AS order_change
--
-- ANSWER: Which time period grew the most? _____________
-- ANSWER: By how many orders? _____________




-- ============================================================================
-- PART 4: DIAGNOSTIC ANALYTICS - WHY Did They Grow?
-- ============================================================================

-- 4.0 Overall Promo Usage (Percentage Pattern Intro)
-- Write a query to calculate the overall promo usage % for Spring 2026 (March-May).
-- This introduces the percentage pattern before adding GROUP BY.
-- Pattern: SUM(CASE WHEN promo_code_used = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(order_id)
-- Note: Use 100.0 (not 100) to get decimal division!
--
-- ANSWER: What % of Spring 2026 orders used a promo code? __________%




-- 4.1 Promo Code Usage by Month
-- Write a query to show promo code usage % by month for Spring 2026 (March-May).
-- This builds on 4.0 — add GROUP BY month to see the trend over time.
-- HINT: Use the same percentage pattern from 4.0, add GROUP BY for year/month
--
-- ANSWER: What was the promo usage % in April? __________%
-- ANSWER: What was the promo usage % in May? __________%
-- ANSWER: What happened to promo usage? _____________




-- 4.2 Promo Usage by Segment (May only)
-- Write a query to show promo usage % by segment for May 2026 only.
--
-- ANSWER: Which segment had the highest promo usage? _____________
-- ANSWER: What was their promo %? __________%




-- ============================================================================
-- PART 5: CONFIRM THE CONNECTION
-- ============================================================================
-- HOW DO WE KNOW TO LOOK HERE?
-- Our diagnostic analysis revealed three separate signals:
--   • Part 2 (WHO): Dorm students drove most of the growth
--   • Part 3 (WHEN): Afternoon orders spiked dramatically
--   • Part 4 (WHY): Promo usage exploded in May
--
-- These three findings point to the same story. Now we confirm it by
-- filtering to ONLY Dorm students in May and checking if all three
-- signals overlap.

-- 5.1 Dorm Students in May - Deep Dive
-- Write a query to analyze Dorm students in May 2026 by time period.
-- Include: order count, promo order count, average order value
-- This confirms whether Dorm + Afternoon + Promo all connect.
--
-- ANSWER: When did Dorm students order most in May? _____________
-- ANSWER: How many promo orders in the Afternoon? _____________




-- ============================================================================
-- PART 6: YOUR ANALYSIS
-- ============================================================================

-- THE COMPLETE STORY:
-- 1. What happened? (Describe the trend)
--    ANSWER: _______________________________________________________________
--
-- 2. Who drove it? (Which customer segment)
--    ANSWER: _______________________________________________________________
--
-- 3. When? (What time period saw the most growth)
--    ANSWER: _______________________________________________________________
--
-- 4. Why? (What caused the growth)
--    ANSWER: _______________________________________________________________

-- YOUR INSIGHT STATEMENT:
-- Write a single sentence using: [WHO] + [DID WHAT] + [BY HOW MUCH] + [WHY]
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________

-- YOUR RECOMMENDATION:
-- What should Campus Bites do to replicate this success?
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________


-- ============================================================================
-- COMPARING THE TWO SCENARIOS
-- ============================================================================
-- | Lesson    | Question                  | Finding | Action |
-- |-----------|---------------------------|---------|--------|
-- | Lesson 01 | "Why did orders DROP?"    |         |        |
-- | Lesson 02 | "Why did revenue GROW?"   |         |        |
--
-- What's the SAME analytical approach?
-- ANSWER: __________________________________________________________________
--
-- What's DIFFERENT about the business response?
-- ANSWER: __________________________________________________________________


-- ============================================================================
-- ON YOUR OWN
-- ============================================================================

-- Challenge 1: Promo Impact on Order Value
-- Do promo orders have higher or lower order values than non-promo orders?
-- Write a query comparing avg order value for promo vs non-promo orders.
--
-- ANSWER: Do promo orders have higher or lower values? _____________
-- ANSWER: What is the avg order value for promo orders? $_____________
-- ANSWER: What is the avg order value for non-promo orders? $_____________




-- Challenge 2: Your Own Analysis
-- Write one or more queries that answer a business question you're curious about.
-- YOUR QUESTION: ___________________________________________________________



-- INSIGHT STATEMENT: _______________________________________________________
--
-- _________________________________________________________________________


-- ============================================================================
-- SQL CONCEPTS COVERED
-- ============================================================================
-- Review: SELECT, FROM, WHERE
-- Review: COUNT(), SUM(), AVG(), ROUND()
-- Review: GROUP BY, ORDER BY
-- Reinforced: CASE WHEN for categorization (time periods, semesters)
-- Reinforced: LAG() for period-over-period comparison
-- Reinforced: Date functions: MONTH(), MONTHNAME(), HOUR(), YEAR()
--
-- NEW PATTERNS LEARNED:
-- • Pivot Pattern: SUM(CASE WHEN condition THEN 1 ELSE 0 END)
--   Puts values side-by-side as columns instead of rows
-- • Percentage Pattern: SUM(CASE WHEN...) * 100.0 / COUNT(order_id)
--   Calculates what % of rows match a condition
-- ============================================================================
--
-- KEY TAKEAWAY: The same diagnostic framework works for PROBLEMS and
-- OPPORTUNITIES. Analytics isn't just for finding problems — it helps you
-- find what's WORKING so you can do more of it.
-- ============================================================================
