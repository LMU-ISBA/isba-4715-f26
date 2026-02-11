-- ============================================================================
-- LESSON 03: Customer Intelligence with RFM Analysis & JOINs
-- ============================================================================
--
-- SCENARIO: You're a data analyst at Basket Craft, an online gift basket
-- company. The VP of Marketing says: "We want to launch a loyalty campaign
-- for our best customers. Who are they, and how do we reach them?"
--
-- YOUR MISSION: Use RFM analysis to identify your best customers, then use
-- JOINs to connect the data you need for a targeted email campaign.
--
-- NOTE: This lesson uses a NEW database: basket_craft
--       (not campus_bites from Lessons 01-02)
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                  | Status     | Used In    |
-- |--------------------------|------------|------------|
-- | SELECT, FROM, WHERE      | Review     | All Parts  |
-- | COUNT, SUM, AVG, ROUND   | Review     | Parts 1-4  |
-- | GROUP BY, ORDER BY       | Review     | All Parts  |
-- | CASE WHEN                | Reinforce  | Part 2     |
-- | CURDATE(), DATEDIFF()    | NEW        | Parts 1-3  |
-- | Subqueries               | NEW        | Parts 2-3  |
-- | INNER JOIN ... ON        | NEW        | Parts 3-4  |
-- | LEFT JOIN ... ON         | NEW        | Part 5     |
-- | IS NULL                  | NEW        | Part 5     |
-- | RANK() OVER ()           | NEW        | Part 6     |
-- | DENSE_RANK() OVER ()     | NEW        | Part 6     |
-- | NTILE(n) OVER ()         | NEW        | Part 6     |
-- ============================================================================
-- RFM Analysis identifies your best customers using three metrics:
--   R (Recency)   = How recently did they buy? (fewer days = better)
--   F (Frequency) = How often do they buy?     (more orders = better)
--   M (Monetary)  = How much do they spend?    (higher total = better)
-- ============================================================================


-- ============================================================================
-- PART 1: EXPLORE THE DATA - What Are We Working With?
-- ============================================================================

-- 1.1 First Look at the Orders Table
-- Write a query to see the first 10 rows of the orders table.
-- This is a NEW database with different tables than campus_bites!
--
-- ANSWER: What columns do you see? _____________
-- ANSWER: What do you think cogs_usd means? _____________




-- 1.2 Overall Business Metrics
-- Write a query to calculate:
--   - Total orders, unique customers, total revenue, avg order value
-- Use WHERE created_at <= CURDATE() to analyze only data through today.
-- HINT: COUNT(DISTINCT user_id) counts unique customers
--
-- ANSWER:
-- | Metric              | Value  |
-- |---------------------|--------|
-- | Total Orders        |        |
-- | Unique Customers    |        |
-- | Total Revenue       | $      |
-- | Avg Order Value     | $      |




-- 1.3 Revenue Trend by Year
-- Write a query showing order count and revenue by year, ordered chronologically.
-- Keep the WHERE created_at <= CURDATE() filter.
-- HINT: Use YEAR(created_at) and GROUP BY
--
-- ANSWER: Which year had the most revenue? _____________
-- ANSWER: Is the business growing or shrinking? _____________




-- ============================================================================
-- PART 2: RFM ANALYSIS - WHO Are Your Best Customers?
-- ============================================================================
-- RFM scores each customer on three dimensions:
--   Recency:   DATEDIFF(CURDATE(), MAX(created_at))  → days since last order
--   Frequency: COUNT(order_id)                        → number of orders
--   Monetary:  SUM(price_usd)                         → total spending
-- ============================================================================

-- 2.1 Calculate RFM Metrics Per Customer
-- Write a query to calculate recency, frequency, and monetary for each customer.
-- Use the formulas from the syntax box above. GROUP BY user_id.
-- NEW: DATEDIFF(date1, date2) returns the number of days between two dates.
-- NEW: CURDATE() returns today's date.
-- Don't forget: WHERE created_at <= CURDATE()
-- Order by monetary DESC and LIMIT 10.
--
-- ANSWER: What is the highest monetary value? $_____________
-- ANSWER: What is the highest frequency? _____________




-- 2.2 Average RFM Metrics
-- Calculate the average recency, frequency, and monetary across ALL customers.
-- We'll use these averages as thresholds to classify customers as High or Low.
-- NEW: A subquery wraps a query inside another query, like a virtual table.
-- Pattern: SELECT ... FROM ( your_inner_query ) AS alias_name
-- Use your 2.1 query (without ORDER BY or LIMIT) as the inner query.
--
-- ANSWER: Avg Recency = _____ days
-- ANSWER: Avg Frequency = _____
-- ANSWER: Avg Monetary = $_____




-- 2.3 Customer Frequency Distribution
-- How many customers ordered once? Twice? Three times?
-- Use the subquery pattern from 2.2.
-- HINT: SELECT frequency, COUNT(*) AS num_customers ... GROUP BY frequency
--
-- ANSWER: Customers with 1 order = _____________
-- ANSWER: Customers with 2 orders = _____________
-- ANSWER: Customers with 3 orders = _____________
-- ANSWER: What % are one-time buyers? _____________% (use a calculator)




-- 2.4 Classify Customers: High vs Low (Reinforce: CASE WHEN)
-- Modify your 2.1 query to add High/Low labels using the averages from 2.2.
-- IMPORTANT: For Recency, LOWER days = MORE recent = BETTER, so:
--   recency <= avg → 'High' (recently active)
--   recency > avg  → 'Low'  (inactive)
-- For Frequency and Monetary, HIGHER = BETTER:
--   value >= threshold → 'High'
--   value < threshold  → 'Low'
--
-- EXAMPLE (Recency only — you write the other two):
--   CASE WHEN DATEDIFF(CURDATE(), MAX(created_at)) <= [your avg recency]
--        THEN 'High' ELSE 'Low' END AS recency_label
--
-- Add LIMIT 20 and scan the results.
-- ANSWER: Do you see any High/High/High customers? _____________




-- 2.5 Count Customers by RFM Segment
-- Wrap your 2.4 query as a subquery and GROUP BY the three labels.
-- This tells us how many customers fall into each segment!
-- Use the same subquery pattern from 2.2 — but this time SELECT the labels
-- and COUNT(*), then GROUP BY the three label columns.
--
-- ANSWER: How many "Best Customers" (High/High/High)? _____________
-- ANSWER: How many "Lost Customers" (Low/Low/Low)? _____________
-- ANSWER: Can you email the Best Customers right now? Why or why not? _____________




-- ============================================================================
-- THE PROBLEM
-- ============================================================================
-- You found your Best Customers — but all you have is user_id!
-- You can't send a loyalty email to "user_id 12345."
--
-- The names and emails live in the USERS table, not the ORDERS table.
--   • ORDERS has: user_id, created_at, price_usd, ...
--   • USERS has:  user_id, first_name, last_name, email, ...
--
-- Both tables share user_id. To CONNECT them, we need a JOIN.
-- ERD: https://r.isba.co/basket_craft_schema
-- ============================================================================


-- ============================================================================
-- PART 3: INNER JOIN - HOW Do We Reach Them?
-- ============================================================================
-- A JOIN combines rows from two tables based on a shared column (the key).
-- INNER JOIN returns ONLY rows that have a match in BOTH tables.
--
-- Syntax:
--   SELECT columns
--   FROM table1 alias1
--   INNER JOIN table2 alias2
--       ON alias1.shared_column = alias2.shared_column
--
-- Table aliases (o, u) are shortcuts so you don't type full table names.
-- ============================================================================

-- 3.1 Your First JOIN
-- Write a query joining orders to users to see customer names with orders.
-- Use the syntax box above. The shared column is user_id.
-- Select a few columns from each table (use aliases: o for orders, u for users).
-- Don't forget: WHERE o.created_at <= CURDATE() and LIMIT 10.
--
-- ANSWER: Can you now see customer names alongside order data? _____________




-- 3.2 Top Customers by Spending (RFM + JOIN)
-- Combine your RFM query from 2.1 with a JOIN to see customer names.
-- HINT: Replace "FROM orders" with "FROM orders o INNER JOIN users u ON ..."
--       Add u.first_name, u.last_name, u.email to both SELECT and GROUP BY.
--
-- ANSWER: Who is the #1 customer by total spending? _____________
-- ANSWER: How much have they spent? $_____________
-- ANSWER: How many orders have they placed? _____________




-- 3.3 Best Customer Email List (The Payoff!)
-- Build the targeted email list: ONLY your Best Customers with names + emails.
-- Wrap your 3.2 query as a subquery, then filter with WHERE to keep only
-- customers whose recency, frequency, and monetary meet the "High" thresholds.
--
-- ANSWER: How many customers are on the email list? _____________
-- ANSWER: Who is at the top of the list? _____________




-- ============================================================================
-- PART 4: PRODUCT ANALYSIS - WHAT Are They Buying?
-- ============================================================================
-- The orders table tells us THAT someone ordered, but not WHAT they bought.
-- Product details are in the PRODUCTS and ORDER_ITEMS tables.
--
-- Table relationships:
--   order_items.product_id → products.product_id
--   order_items.order_id   → orders.order_id
-- ============================================================================

-- 4.1 Explore Products + Join Order Items
-- First: Write SELECT * FROM products to see all products.
-- Then: Join order_items with products to see product names with sales data.
-- Use INNER JOIN the same way you did in Part 3.
-- The shared column is product_id. Use aliases: oi for order_items, p for products.
-- Don't forget: WHERE oi.created_at <= CURDATE() and LIMIT 10.
--
-- ANSWER: How many products does Basket Craft sell? _____________
-- ANSWER: What are their names? _____________




-- 4.2 Revenue and Profit by Product
-- Calculate total items sold, revenue, total profit, and avg profit per item.
-- Profit per item = price_usd - cogs_usd (revenue minus cost of goods sold)
--
-- HINT: GROUP BY p.product_name, use SUM(oi.price_usd - oi.cogs_usd)
--
-- ANSWER: Which product generates the most revenue? _____________
-- ANSWER: Which product has the highest profit per unit? _____________
-- ANSWER: Are the most revenue and most-profitable-per-unit the same? _____________




-- ============================================================================
-- PART 5: LEFT JOIN - WHAT'S Going Wrong?
-- ============================================================================
-- INNER JOIN only returns matches. But sometimes you want to see EVERYTHING
-- from one table, even rows with NO match in the other table.
--
-- LEFT JOIN returns ALL rows from the LEFT table.
-- If there's no match, the right table's columns show NULL.
--
-- This is perfect for finding "what's missing" — like items never refunded.
--
-- Table: order_item_refunds
--   order_item_id     → links to order_items.order_item_id
--   refund_amount_usd → the dollar amount refunded
-- ============================================================================

-- 5.1 Your First LEFT JOIN
-- Join order_items with refunds to see which items were refunded.
-- You'll need TWO joins: INNER JOIN products (for names) and LEFT JOIN refunds.
-- Use the LEFT JOIN syntax from the box above. The shared column is order_item_id.
-- Use aliases: oi for order_items, p for products, r for order_item_refunds.
-- Select: oi.order_item_id, p.product_name, oi.price_usd,
--         r.order_item_refund_id, r.refund_amount_usd
-- Don't forget: WHERE oi.created_at <= CURDATE() and LIMIT 20.
--
-- ANSWER: What do you see in the refund columns for non-refunded items? _____________




-- 5.2 Refund Rate by Product
-- Calculate the refund rate (%) for each product.
-- KEY INSIGHT: COUNT() only counts non-NULL values!
--   COUNT(r.order_item_refund_id) → counts ONLY refunded items
--   COUNT(oi.order_item_id)       → counts ALL items
--
-- HINT: ROUND(COUNT(r.order_item_refund_id) * 100.0
--             / COUNT(oi.order_item_id), 2) AS refund_rate_pct
--
-- ANSWER: Which product has the highest refund rate? _____________
-- ANSWER: What is its refund rate? ___________%
-- ANSWER: Which product has the lowest refund rate? _____________




-- 5.3 Refund Dollar Impact
-- Calculate the total dollar amount refunded by product.
-- This tells us which product costs the business the most in refunds.
--
-- HINT: ROUND(SUM(r.refund_amount_usd), 2) AS total_refunded
--       (SUM automatically ignores NULL values)
--
-- ANSWER: Which product has the highest total refund dollars? _____________
-- ANSWER: How much has been refunded for that product? $_____________




-- ============================================================================
-- PART 6: WINDOW FUNCTIONS - Ranking and Scoring Customers
-- ============================================================================
-- A window function performs a calculation across a set of rows
-- WITHOUT collapsing them like GROUP BY does.
--
-- Syntax:
--   function_name() OVER (ORDER BY column)
--
-- Key window functions:
--   RANK()       — assigns a rank (1, 2, 3...); ties share a rank, then SKIP
--   DENSE_RANK() — assigns a rank; ties share a rank, NO skipping
--   NTILE(n)     — divides rows into n equal-sized buckets (1 to n)
--
-- Example:  RANK() OVER (ORDER BY SUM(price_usd) DESC) AS spending_rank
-- ============================================================================

-- 6.1 Your First Window Function: RANK()
-- Take your top customers query from 3.2 and add a spending_rank column.
-- NEW: RANK() OVER (ORDER BY expression DESC) assigns rank 1, 2, 3...
-- The window function goes in the SELECT alongside your other columns.
-- LIMIT 15 to see the top-ranked customers.
--
-- HINT: Add this column to your 3.2 SELECT:
--       RANK() OVER (ORDER BY SUM(o.price_usd) DESC) AS spending_rank
--
-- ANSWER: Who is ranked #1? _____________
-- ANSWER: Do any customers share the same rank? _____________




-- 6.2 RANK() vs DENSE_RANK() — What Happens with Ties?
-- Rank customers by frequency (number of orders) using BOTH functions.
-- Remember: ~98% of customers ordered exactly once (from Part 2.3).
--
-- HINT: Add both to your SELECT:
--       RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS freq_rank,
--       DENSE_RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS freq_dense_rank
--
-- ANSWER: What RANK() does a one-time buyer get? _____________
-- ANSWER: What DENSE_RANK() does a one-time buyer get? _____________
-- ANSWER: Why are those numbers so different? _____________




-- 6.3 NTILE() — Scoring Customers Like the Pros
-- In Part 2.4, we used CASE WHEN with hardcoded averages for High/Low.
-- NTILE(5) automatically divides customers into 5 equal groups (quintiles).
-- Apply NTILE(5) to each RFM dimension using your 2.1 subquery as the
-- inner query, then add the three NTILE columns in the outer SELECT.
--
-- IMPORTANT: For recency, lower days = better, so ORDER BY recency ASC
--            gives score 1 to the MOST recent customers.
--            For frequency and monetary, higher = better, so ORDER BY ... DESC.
--
-- HINT:
--   NTILE(5) OVER (ORDER BY recency ASC)   AS r_score,
--   NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
--   NTILE(5) OVER (ORDER BY monetary DESC)  AS m_score
--
-- ANSWER: What r_score do the most recent customers get? _____________
-- ANSWER: What does a customer scoring 1-1-1 mean? _____________
-- ANSWER: How is this better than the High/Low approach in Part 2.4? _____________




-- ============================================================================
-- PART 7: YOUR ANALYSIS
-- ============================================================================

-- THE COMPLETE STORY:
-- 1. How big is the business? (Orders, customers, revenue)
--    ANSWER: _______________________________________________________________
--
-- 2. Who are the best customers? (RFM findings)
--    ANSWER: _______________________________________________________________
--
-- 3. What challenge did you face identifying them? (The JOIN problem)
--    ANSWER: _______________________________________________________________
--
-- 4. What products drive the business? (Revenue and profit)
--    ANSWER: _______________________________________________________________
--
-- 5. Any quality concerns? (Refund analysis)
--    ANSWER: _______________________________________________________________

-- YOUR INSIGHT STATEMENT:
-- Write a single sentence summarizing your key finding for the VP of Marketing.
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________

-- YOUR RECOMMENDATION:
-- What should Basket Craft do with these insights?
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________


-- ============================================================================
-- COMPARING THE THREE LESSONS
-- ============================================================================
-- | Lesson    | Question                      | Key Tool      | Action      |
-- |-----------|-------------------------------|---------------|-------------|
-- | Lesson 01 | "Why did orders DROP?"        | CASE WHEN     |             |
-- | Lesson 02 | "Why did revenue GROW?"       | Pivot + %     |             |
-- | Lesson 03 | "Who are our BEST customers?" | RFM + JOINs   |             |
--
-- What's the SAME analytical approach across all three lessons?
-- ANSWER: __________________________________________________________________
--
-- What's NEW about this lesson's approach?
-- ANSWER: __________________________________________________________________


-- ============================================================================
-- ON YOUR OWN
-- ============================================================================

-- Challenge 1: Cross-Sell Analysis
-- The order_items table has is_primary_item (1 = main product, 0 = cross-sell).
-- How many cross-sell items were sold? What's the most common cross-sell product?
--
-- ANSWER: Total cross-sell items = _____________
-- ANSWER: Most common cross-sell product = _____________




-- Challenge 2: Customer Lifetime
-- For customers with 2+ orders, what's the average number of days between
-- their first and last order? Use a JOIN to show their names.
-- HINT: DATEDIFF(MAX(created_at), MIN(created_at)) inside a subquery
--
-- ANSWER: Avg days between first and last order = _____________




-- Challenge 3: Your Own Analysis
-- Write one or more queries that answer a business question you're curious about.
-- YOUR QUESTION: ___________________________________________________________



-- INSIGHT STATEMENT: _______________________________________________________
--
-- _________________________________________________________________________


-- ============================================================================
-- SQL CONCEPTS COVERED
-- ============================================================================
-- Review: SELECT, FROM, WHERE
-- Review: COUNT(), SUM(), AVG(), ROUND(), COUNT(DISTINCT)
-- Review: GROUP BY, ORDER BY
-- Reinforced: CASE WHEN for classification (High/Low RFM labels)
-- NEW: CURDATE() — returns today's date
-- NEW: DATEDIFF(date1, date2) — days between two dates
-- NEW: Subqueries — a query inside another query (FROM ... AS alias)
-- NEW: INNER JOIN ... ON — combine rows from two tables (matches only)
-- NEW: LEFT JOIN ... ON — include ALL left-table rows (NULLs for no match)
-- NEW: IS NULL — check for missing values from LEFT JOIN
-- NEW: Table aliases — shortcut names for tables (orders o, users u)
-- NEW: RANK() OVER () — assigns rank with gaps after ties
-- NEW: DENSE_RANK() OVER () — assigns rank without gaps after ties
-- NEW: NTILE(n) OVER () — divides rows into n equal-sized groups
--
-- KEY PATTERNS LEARNED:
-- • RFM Pattern: GROUP BY customer, then DATEDIFF + COUNT + SUM
-- • Subquery Pattern: SELECT ... FROM (inner_query) AS alias
-- • JOIN Pattern: FROM table1 alias1 JOIN table2 alias2 ON key = key
-- • NULL Pattern: LEFT JOIN + COUNT(right_table.id) for rates
-- • Window Pattern: function() OVER (ORDER BY ...) for ranking/scoring
-- ============================================================================
--
-- KEY TAKEAWAY: Real business questions often require connecting data across
-- multiple tables. JOINs are the bridge that lets you combine customer data,
-- product data, and transaction data into actionable insights.
-- ============================================================================
