-- ============================================================================
-- LESSON 03, PART 2: Marketing Channel Analysis with Multi-Table JOINs
-- ============================================================================
--
-- SCENARIO: Robert, VP of Marketing at Basket Craft, is planning next
-- quarter's advertising budget. He spends money on Google, Bing, and
-- Facebook ads to drive website traffic but doesn't know what's working.
-- He's sending you a series of emails, each digging deeper.
--
-- YOUR MISSION: Use multi-table JOINs to analyze which marketing channels
-- convert visitors into buyers, and which ones are wasting Robert's budget.
--
-- DATABASE: basket_craft (same as Part 1)
-- NEW TABLE: website_sessions — tracks every visit to the website
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                  | Status     | Used In     |
-- |--------------------------|------------|-------------|
-- | SELECT, FROM, WHERE      | Review     | All Emails  |
-- | COUNT, ROUND             | Review     | Emails 2-4  |
-- | GROUP BY, ORDER BY       | Review     | Emails 3-4  |
-- | Table aliases            | Review     | All Emails  |
-- | INNER JOIN ... ON        | Reinforce  | All Emails  |
-- | LEFT JOIN ... ON         | Reinforce  | Emails 2-3  |
-- | COUNT(column) skips NULL | Reinforce  | Emails 2-3  |
-- | CASE WHEN                | Reinforce  | Email 3     |
-- | Multi-table JOINs (3-4)  | NEW        | Emails 3-4  |
-- ============================================================================
--
-- PREREQUISITE: Complete Lesson 03, Part 1 before starting this lesson.
-- You should be comfortable with 2-table INNER JOINs and LEFT JOINs.
--
-- ============================================================================
-- HOW TO REPLY TO ROBERT
-- ============================================================================
-- After each email, you'll reply with a two-part response:
--
--   WHAT:    Your insight — what does the data show?
--            State a specific finding. Always include a number.
--            Example: "93% of website sessions end without a purchase."
--
--   SO WHAT: Your recommendation — what should Robert do about it?
--            Suggest an action and predict the expected impact.
--            Example: "Invest in conversion optimization rather than
--            more traffic — a 1% lift would add ~4,400 orders."
--
-- Keep each answer to 1-2 sentences. Be specific, not vague.
--   Bad:  "Conversion is low, we should improve it."
--   Good: "Only 6.7% of visitors buy. Prioritize checkout optimization
--          — even a 1% lift adds ~4,400 annual orders."
-- ============================================================================


-- ============================================================================
-- EMAIL 1: "I need to understand our website traffic data"
-- ============================================================================
-- FROM: Robert, VP of Marketing
--
-- "I'm planning our Q2 ad budget and I need your help. We spend money on
-- Google, Bing, and Facebook ads to drive traffic to our website. But I
-- have no idea if it's working. Start by pulling up our website traffic
-- data — I want to understand what we're looking at before we dig in."
-- ============================================================================

-- 1.1 Explore the Website Sessions Table
-- Write a query to see the first 10 rows of the website_sessions table.
-- This is a NEW table you haven't used before!
--
-- ANSWER: What columns do you see? _____________
-- ANSWER: What do you think utm_source means? _____________
-- ANSWER: What are the two device_type values? _____________




-- 1.2 Which Sessions Became Orders?
-- Join website_sessions to orders to see which sessions led to a purchase.
-- The shared column is website_session_id.
-- Use aliases: ws for website_sessions, o for orders.
-- Select: ws.website_session_id, ws.utm_source, ws.device_type,
--         o.order_id, o.price_usd
-- Don't forget: WHERE ws.created_at <= CURDATE() and LIMIT 10.
--
-- HINT: Same INNER JOIN pattern from Part 1:
--       FROM website_sessions ws INNER JOIN orders o ON ...
--
-- ANSWER: Can you see which marketing channel led to each order? _____________




-- 1.3 How Big Is the Gap?
-- Run two quick counts:
--   Query A: SELECT COUNT(website_session_id) FROM website_sessions WHERE created_at <= CURDATE()
--   Query B: Remove the LIMIT from your 1.2 query and count the rows.
--
-- ANSWER: Total sessions: _____________
-- ANSWER: Sessions with orders (from INNER JOIN): _____________
-- ANSWER: What happened to the other sessions? _____________




-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO ROBERT                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- EMAIL 2: "Show me EVERYONE who visited — not just the buyers"
-- ============================================================================
-- FROM: Robert, VP of Marketing
--
-- "Wait — 442,000 sessions but only 30,000 orders?! That means over
-- 400,000 people visited our site and left empty-handed. Your query only
-- showed me buyers. I need to SEE those lost visitors too. Show me
-- everyone who visited, whether they bought or not. Then tell me:
-- what's our actual conversion rate?"
-- ============================================================================

-- 2.1 Run Your Email 1 Query Again (INNER JOIN)
-- Copy your sessions-to-orders JOIN from 1.2 (without the LIMIT).
-- Before running it, predict: how many rows will this return?
--
-- ANSWER: How many rows? _____________
-- ANSWER: Why does INNER JOIN only show this many? _____________




-- 2.2 Change ONE Word: INNER → LEFT
-- Take your 2.1 query and change INNER JOIN to LEFT JOIN.
-- Everything else stays exactly the same — just swap one word.
--
-- ANSWER: How many rows now? _____________
-- ANSWER: What do you see in the order columns for non-buyers? _____________
-- ANSWER: In one sentence, what does LEFT JOIN do differently?
--         _____________




-- 2.3 Calculate the Conversion Rate
-- Using your LEFT JOIN query from 2.2, calculate:
--   - Total sessions
--   - Sessions that converted (had an order)
--   - Conversion rate as a percentage
--
-- HINT: COUNT(o.order_id) only counts non-NULL values — remember this
--       trick from the refund rate in Part 1?
--       ROUND(COUNT(o.order_id) * 100.0 / COUNT(ws.website_session_id), 2) AS conversion_rate_pct
--
-- ANSWER: Total sessions: _____________
-- ANSWER: Sessions with orders: _____________
-- ANSWER: Conversion rate: ___________%




-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO ROBERT                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- EMAIL 3: "Which channels deserve our budget?"
-- ============================================================================
-- FROM: Robert, VP of Marketing
--
-- "6.7% conversion rate — that means 93 out of 100 visitors leave without
-- buying. But I bet it's not the same across all channels. I'm paying for
-- Google, Bing, and Facebook ads. Which ones are actually converting?
-- And does it matter if visitors are on desktop or mobile? Break it down
-- for me — I need to know where to put our money."
-- ============================================================================

-- 3.1 Conversion Rate by Marketing Channel
-- Using the same LEFT JOIN pattern from Email 2, add a GROUP BY on
-- ws.utm_source to see the conversion rate for each channel.
--
-- HINT: Your SELECT should include ws.utm_source, COUNT(ws.website_session_id),
--       COUNT(o.order_id), and the conversion rate formula from 2.3.
--       GROUP BY ws.utm_source. ORDER BY conversion_rate_pct DESC.
--
-- ANSWER: Which channel has the highest conversion rate? _____________
-- ANSWER: Which channel has the lowest conversion rate? _____________
-- ANSWER: What shows up instead of a channel name for some rows? _____________
--         (This means the visitor came directly — no paid ad.)




-- 3.2 Add the Device Dimension
-- Modify your 3.1 query to also GROUP BY ws.device_type.
-- Now you'll see each channel split by desktop vs mobile.
--
-- HINT: Add ws.device_type to SELECT, GROUP BY, and ORDER BY.
--       To clean up the NULL channel name, you can use:
--       CASE WHEN ws.utm_source IS NULL THEN 'direct'
--            ELSE ws.utm_source END AS channel
--
-- ANSWER: Best-converting channel + device combo? _________ at _____%
-- ANSWER: Worst-converting combo? _________ at _____%
-- ANSWER: How many times better does desktop convert vs mobile (roughly)? ____x




-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO ROBERT                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- EMAIL 4: "Show me the full picture — channels x products"
-- ============================================================================
-- FROM: Robert, VP of Marketing
--
-- "Great work on the channel analysis. Now I need the full picture before
-- my budget meeting. I know Google drives the most traffic, but what are
-- people actually BUYING through each channel? Which products sell best
-- through which channels? This is the query that ties it all together —
-- connect the sessions to orders to the actual products purchased."
-- ============================================================================
--
-- Table chain (4 tables):
--   website_sessions → orders → order_items → products
--   (website_session_id)  (order_id)    (product_id)
-- ============================================================================

-- 4.1 Revenue by Channel and Product
-- Write a query joining ALL FOUR tables to show:
--   - Marketing channel (use your CASE WHEN from 3.2 for NULL)
--   - Product name
--   - Number of orders
--   - Total revenue
--
-- HINT: Chain your JOINs — each table connects to the next:
--       FROM website_sessions ws
--       INNER JOIN orders o        ON ws.website_session_id = o.website_session_id
--       INNER JOIN order_items oi  ON o.order_id = oi.order_id
--       INNER JOIN products p      ON oi.product_id = p.product_id
--
-- Don't forget: WHERE ws.created_at <= CURDATE()
-- GROUP BY channel and p.product_name. ORDER BY channel, revenue DESC.
--
-- ANSWER: Which channel generates the most total revenue? _____________
-- ANSWER: What is the #1 product across ALL channels? _____________
-- ANSWER: Which channel has the fewest orders? _____________




-- 4.2 Revenue per Order by Channel
-- Modify your query to show total orders, total revenue, and
-- revenue per order for each channel (without the product breakdown).
--
-- HINT: Remove p.product_name from SELECT and GROUP BY.
--       Add: ROUND(SUM(oi.price_usd) / COUNT(DISTINCT o.order_id), 2)
--            AS revenue_per_order
--
-- ANSWER: Which channel has the highest revenue per order? _____________
-- ANSWER: Does highest volume = highest value per order? _____________




-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO ROBERT                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- YOUR ANALYSIS: Budget Recommendation for Robert
-- ============================================================================

-- THE COMPLETE STORY:
-- 1. How much website traffic does Basket Craft get? (Email 1)
--    ANSWER: _______________________________________________________________
--
-- 2. What is the overall conversion rate? (Email 2)
--    ANSWER: _______________________________________________________________
--
-- 3. Which channel + device converts best? Worst? (Email 3)
--    ANSWER: Best: __________________ Worst: __________________
--
-- 4. Which channel drives the most revenue? Best revenue per order? (Email 4)
--    ANSWER: Most revenue: __________________ Best per order: __________________

-- YOUR INSIGHT STATEMENT:
-- Write a single sentence summarizing your key finding for Robert.
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________

-- YOUR BUDGET RECOMMENDATION:
-- Robert has budget for next quarter. Based on your analysis, where should
-- he increase spending, maintain spending, and cut spending?
--
-- INCREASE: ________________________________________________________________
--
-- MAINTAIN: ________________________________________________________________
--
-- CUT:      ________________________________________________________________


-- ============================================================================
-- SQL CONCEPTS REINFORCED
-- ============================================================================
-- Reinforced: INNER JOIN ... ON — combine rows from two tables (matches only)
-- Reinforced: LEFT JOIN ... ON — include ALL left-table rows (NULLs for no match)
-- Reinforced: COUNT(column) skips NULLs — used for conversion rate calculation
-- Reinforced: CASE WHEN for NULL handling
-- Reinforced: Table aliases for readable multi-table queries
-- NEW: Multi-table JOINs (3-4 tables) — chain JOINs to connect across tables
-- NEW: Conversion rate pattern: LEFT JOIN + COUNT(right.id) / COUNT(left.pk)
--
-- KEY PATTERNS LEARNED:
-- * Conversion Pattern: LEFT JOIN + COUNT(right.id) / COUNT(left.pk) for rates
-- * Multi-Table Chain: FROM t1 JOIN t2 ON ... JOIN t3 ON ... JOIN t4 ON ...
-- * INNER vs LEFT: Same query, one word change, very different results
-- * Channel Analysis: GROUP BY source + device for marketing insights
-- ============================================================================
--
-- KEY TAKEAWAY: INNER JOIN shows you what happened. LEFT JOIN shows you
-- what DIDN'T happen. Sometimes what didn't happen is the bigger story.
-- ============================================================================
