-- ============================================================================
-- LESSON 04: Website Conversion Analysis with CTEs
-- ============================================================================
--
-- SCENARIO: You're a data analyst at Basket Craft. Cheryl, the E-commerce
-- Manager, needs help understanding website performance. Where do visitors
-- land? How many bounce immediately? And did the A/B tests on the landing
-- page and billing page actually work?
--
-- YOUR MISSION: Use CTEs and ROW_NUMBER() to analyze website traffic,
-- build conversion funnels, and measure A/B test results.
--
-- DATABASE: basket_craft (same as Lessons 03)
-- NEW TABLE: website_pageviews (tracks every page a visitor viewed)
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                           | Status     | Used In        |
-- |-----------------------------------|------------|----------------|
-- | SELECT, FROM, WHERE               | Review     | All Parts      |
-- | COUNT, SUM, ROUND                 | Review     | Parts 2-4      |
-- | GROUP BY, ORDER BY                | Review     | All Parts      |
-- | LEFT JOIN, COUNT(col) skips NULL  | Reinforce  | Parts 2, 4     |
-- | CASE WHEN                         | Reinforce  | Parts 3-4      |
-- | Subqueries (FROM subquery)        | Reinforce  | Bridge         |
-- | NTILE(n) OVER ()                  | Reinforce  | Bridge         |
-- | WITH ... AS (CTE syntax)          | NEW        | Bridge + All   |
-- | Multi-CTE chaining                | NEW        | Parts 2-4      |
-- | ROW_NUMBER() OVER (PARTITION BY)  | NEW        | Parts 2-3      |
-- | MAX() flag aggregation pattern    | NEW        | Part 3         |
-- | Conversion funnel pattern         | NEW        | Part 3         |
-- | Revenue per session (A/B lift)    | NEW        | Part 4         |
-- ============================================================================
--
-- ============================================================================
-- HOW TO REPLY TO CHERYL
-- ============================================================================
-- After each email, you'll reply with a two-part response:
--
--   WHAT:    Your insight — what does the data show?
--            State a specific finding. Always include a number.
--            Example: "53% of visitors who land on /home leave immediately."
--
--   SO WHAT: Your recommendation — what should Cheryl do about it?
--            Suggest an action and predict the expected impact.
--            Example: "Test a new landing page design. Even a 5% bounce
--            rate improvement would keep ~1,500 more visitors on the site."
--
-- Keep each answer to 1-2 sentences. Be specific, not vague.
--   Bad:  "Bounce rate is high, we should fix it."
--   Good: "53% bounce rate on /home means 16,000+ visitors leave
--          immediately. Redesign the hero section to match ad messaging."
-- ============================================================================


-- ============================================================================
-- BRIDGE: From Nested Subqueries to CTEs
-- ============================================================================
-- In Lesson 03, you wrote NTILE(5) for RFM scoring using a nested subquery.
-- That query WORKS, but it's hard to read. CTEs fix that.
-- Same logic. Same output. Just easier to understand.
-- ============================================================================

-- B.1 Review: The Nested Subquery Version
-- Run this query from Lesson 03 Task 6.3 (RFM scoring with NTILE).
-- It works — but look at how the subquery is buried inside the FROM clause.
--
SELECT
    user_id,
    recency,
    frequency,
    monetary,
    NTILE(5) OVER (ORDER BY recency ASC) AS recency_score,
    NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_score,
    NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_score
FROM (
    SELECT
        user_id,
        DATEDIFF(CURDATE(), MAX(created_at)) AS recency,
        COUNT(order_id) AS frequency,
        ROUND(SUM(price_usd), 2) AS monetary
    FROM orders
    WHERE created_at <= CURDATE()
    GROUP BY user_id
) AS rfm;

-- ANSWER: How many rows does this return? _____________
-- ANSWER: Where is the subquery? _____________


-- B.2 Rewrite as a CTE
-- Rewrite the query above using WITH ... AS syntax.
-- The subquery doesn't move. It just gets a name and moves to the TOP.
--
-- ┌──────────────────────────────────────────────────────────┐
-- │  CTE SYNTAX                                              │
-- │                                                          │
-- │  WITH cte_name AS (                                      │
-- │      -- your query goes here                             │
-- │  )                                                       │
-- │  SELECT ... FROM cte_name;                               │
-- │                                                          │
-- │  Think of it as: "Let me define this result set first,   │
-- │  give it a name, then use it below."                     │
-- └──────────────────────────────────────────────────────────┘
--
-- Replace the nested subquery with a CTE named "rfm".
-- The final SELECT stays the same — just change FROM (subquery) to FROM rfm.




-- ANSWER: What changed? (structure or business logic?) _____________
-- ANSWER: What stayed the same? (the output) _____________
-- ANSWER: Which version is easier to read? _____________


-- B.3 Chain Two CTEs
-- Now add a SECOND CTE that JOINs the users table to get customer names.
-- CTEs chain with a comma. No second WITH keyword!
--
-- ┌──────────────────────────────────────────────────────────┐
-- │  CHAINING CTEs                                           │
-- │                                                          │
-- │  WITH cte1 AS (                                          │
-- │      ...                                                 │
-- │  ),                    ← comma, NOT semicolon            │
-- │  cte2 AS (                                               │
-- │      SELECT ... FROM cte1   ← cte2 can use cte1!        │
-- │      JOIN other_table ...                                │
-- │  )                                                       │
-- │  SELECT ... FROM cte2;                                   │
-- └──────────────────────────────────────────────────────────┘
--
-- CTE 1: rfm (same as B.2)
-- CTE 2: rfm_with_names — JOIN rfm to users ON user_id, add first_name
-- Final SELECT: Add NTILE(5) scores from rfm_with_names
--
-- HINT: Your second CTE should SELECT rfm.*, u.first_name, u.last_name
--       FROM rfm INNER JOIN users u ON rfm.user_id = u.user_id




-- ANSWER: How many CTEs did you chain? _____________
-- ANSWER: Can the second CTE reference the first? _____________


-- ============================================================================
-- PART 1: DESCRIPTIVE ANALYTICS — What Does the Website See?
-- ============================================================================
-- ============================================================================
-- CHERYL EMAIL 0
-- ============================================================================
-- From:    Cheryl, E-commerce Manager
-- To:      You, Data Analyst
-- Date:    Monday, February 23, 2026, 8:30 AM
-- Subject: Website analysis — getting started
--
-- "Hi! I manage our website at Basket Craft. I've heard you've been doing
-- great work with the marketing and customer data. Now I need help
-- understanding what visitors DO on our site. Can you start by showing me
-- what the website_pageviews table looks like?"
-- ============================================================================

-- 1.1 First Look at website_pageviews
-- Write a query to see the first 10 rows of the website_pageviews table.
-- This is a NEW table you haven't used before!
--
-- ANSWER: What columns do you see? _____________
-- ANSWER: What do you think website_session_id means? _____________
-- ANSWER: Can one session have multiple pageviews? _____________




-- 1.2 What Pages Do Visitors See?
-- Count the total pageviews for each pageview_url.
-- GROUP BY pageview_url and ORDER BY the count descending.
-- Add WHERE created_at <= CURDATE().
--
-- ANSWER: What is the most-viewed page? _____________
-- ANSWER: What page has the fewest views? _____________
-- ANSWER: How many distinct page URLs exist? _____________




-- 1.3 How Many Pages Per Session?
-- Use a CTE to first count pages per session, then calculate the average.
--
-- CTE: session_pages — COUNT pageviews grouped by website_session_id
-- Final SELECT: AVG, MIN, MAX of the CTE's page count
--
-- This is your first CTE on the new table — same syntax as the Bridge!
--
-- HINT:
-- WITH session_pages AS (
--     SELECT
--         website_session_id,
--         COUNT(website_pageview_id) AS pages_viewed
--     FROM website_pageviews
--     WHERE created_at <= CURDATE()
--     GROUP BY website_session_id
-- )
-- SELECT
--     ROUND(AVG(pages_viewed), 2) AS avg_pages_per_session,
--     ...
--
-- ANSWER: Average pages per session: _____________
-- ANSWER: Maximum pages in a single session: _____________
-- ANSWER: What does 1 page per session mean? (hint: they left immediately) _____________




-- ============================================================================
-- PART 2: DIAGNOSTIC ANALYTICS — Where Do Visitors Land and Leave?
-- ============================================================================
-- ============================================================================
-- CHERYL EMAIL 1
-- ============================================================================
-- From:    Cheryl, E-commerce Manager
-- To:      You, Data Analyst
-- Date:    Monday, February 23, 2026, 9:15 AM
-- Subject: RE: Website analysis — where do visitors start?
--
-- "Good start! Now I need to know: where do visitors START their journey?
-- The first page they see is the 'landing page.' And how many leave
-- immediately after just that one page? That's the 'bounce rate.'
-- A high bounce rate means our landing page isn't convincing visitors
-- to stay and explore."
-- ============================================================================

-- 2.1 Number Pageviews Within Each Session
-- For each session, number the pageviews in order (1st page, 2nd page, etc.)
-- This tells us which page was viewed FIRST (the landing page).
--
-- ┌──────────────────────────────────────────────────────────┐
-- │  ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)       │
-- │                                                          │
-- │  PARTITION BY = the groups (each session is a group)     │
-- │  ORDER BY    = the order within each group               │
-- │                                                          │
-- │  Every time the session_id changes, the count restarts   │
-- │  at 1. So page_num = 1 is always the FIRST pageview.    │
-- │                                                          │
-- │  Session 1: /home (1), /products (2), /cart (3)          │
-- │  Session 2: /lp-1 (1), /products (2)  ← restarts!       │
-- │  Session 3: /home (1)                  ← restarts!       │
-- └──────────────────────────────────────────────────────────┘
--
-- Write a CTE named ranked_pageviews that adds a page_num column:
--   ROW_NUMBER() OVER (PARTITION BY website_session_id
--                       ORDER BY website_pageview_id) AS page_num
--
-- Then SELECT * FROM ranked_pageviews LIMIT 20 to see the result.




-- ANSWER: What page_num does the first pageview in each session get? _____________
-- ANSWER: When does the numbering restart? _____________
-- ANSWER: If a session has 5 pageviews, what numbers do they get? _____________


-- 2.2 Find the Landing Pages
-- Using your ranked_pageviews CTE from 2.1, filter to only page_num = 1.
-- These are the landing pages! Count how many sessions started on each URL.
--
-- Add to your CTE from 2.1:
--   SELECT pageview_url AS landing_page, COUNT(website_session_id) AS total_sessions
--   FROM ranked_pageviews
--   WHERE page_num = 1
--   GROUP BY pageview_url
--   ORDER BY total_sessions DESC
--
-- ANSWER: What is the #1 landing page? _____________
-- ANSWER: How many different landing pages exist? _____________




-- 2.3 Calculate Bounce Rates
-- A "bounce" = the visitor saw only ONE page and left.
-- Add a SECOND CTE that counts pages per session, then JOIN both CTEs.
--
-- CTE 1: ranked_pageviews (from 2.1 — copy it here)
-- CTE 2: session_page_counts — COUNT pages per session
-- Final SELECT: JOIN the two CTEs, filter to page_num = 1 (landing pages),
--               use CASE WHEN num_pages = 1 to flag bounces
--
-- HINT for the final SELECT:
-- SELECT
--     rp.pageview_url AS landing_page,
--     COUNT(rp.website_session_id) AS total_sessions,
--     SUM(CASE WHEN spc.num_pages = 1 THEN 1 ELSE 0 END) AS bounced_sessions,
--     ROUND(
--         SUM(CASE WHEN spc.num_pages = 1 THEN 1 ELSE 0 END) * 100.0
--         / COUNT(rp.website_session_id), 2
--     ) AS bounce_rate_pct
-- FROM ranked_pageviews rp
-- INNER JOIN session_page_counts spc
--     ON rp.website_session_id = spc.website_session_id
-- WHERE rp.page_num = 1
-- GROUP BY rp.pageview_url
-- ORDER BY total_sessions DESC




-- ANSWER: Which landing page has the highest bounce rate? _____________
-- ANSWER: Which landing page has the lowest bounce rate? _____________
-- ANSWER: What does a 50% bounce rate mean in plain English? _____________


-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO CHERYL                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- PART 3: CONFIRM THE CONNECTION — The Full Conversion Funnel
-- ============================================================================
-- ============================================================================
-- CHERYL EMAIL 2
-- ============================================================================
-- From:    Cheryl, E-commerce Manager
-- To:      You, Data Analyst
-- Date:    Wednesday, February 25, 2026, 10:30 AM
-- Subject: Landing page A/B test results — need conversion funnel
--
-- "We ran an A/B test from June 19 to July 28 — half of traffic landed
-- on /home (the original), and half on /lp-1 (the new design). The bounce
-- rates were almost identical, so bounce rate alone won't tell me which
-- page is better. I need the FULL conversion funnel: how many sessions
-- made it to /products, /cart, /billing, and placed an order? Show me
-- both pages side by side."
-- ============================================================================

-- 3.1 Identify Test Sessions and Landing Pages
-- CTE: Use ROW_NUMBER to find the first page per session during the test.
-- Filter to:
--   - Sessions created between June 19, 2023 and July 28, 2023 (inclusive)
--   - Landing page is /home or /lp-1 only
--
-- Build this CTE and run it ALONE first to verify your session counts.
--
-- HINT: You need TWO tables — JOIN website_pageviews to website_sessions
-- to filter by the session date range.
--
-- WITH ranked_pageviews AS (
--     SELECT
--         wp.website_session_id,
--         wp.pageview_url,
--         ROW_NUMBER() OVER (
--             PARTITION BY wp.website_session_id
--             ORDER BY wp.website_pageview_id
--         ) AS page_num
--     FROM website_pageviews wp
--     INNER JOIN website_sessions ws
--         ON wp.website_session_id = ws.website_session_id
--     WHERE ws.created_at >= '2023-06-19'
--         AND ws.created_at < '2023-07-29'
-- ),
-- test_sessions AS (
--     SELECT
--         website_session_id,
--         pageview_url AS landing_page
--     FROM ranked_pageviews
--     WHERE page_num = 1
--         AND pageview_url IN ('/home', '/lp-1')
-- )
-- SELECT landing_page, COUNT(website_session_id) AS total_sessions
-- FROM test_sessions
-- GROUP BY landing_page
--
-- ANSWER: How many /home sessions? _____________
-- ANSWER: How many /lp-1 sessions? _____________




-- 3.2 Explore a Single Session's Journey
-- Pick one session_id from the test period and look at ALL its pageviews.
-- This grounds the abstract "funnel" concept in concrete data.
--
-- HINT: Try session_id 1059 — it's a full conversion.
-- SELECT website_session_id, pageview_url
-- FROM website_pageviews
-- WHERE website_session_id = 1059
-- ORDER BY website_pageview_id




-- ANSWER: What pages did this visitor see, in order? _____________
-- ANSWER: How many pages did they view total? _____________
-- ANSWER: Did they place an order? (look for /thank-you) _____________


-- 3.3 Flag Funnel Steps with CASE WHEN
-- Add a second CTE that JOINs test sessions to ALL their pageviews,
-- then flags whether each session reached each funnel step.
--
-- ┌──────────────────────────────────────────────────────────┐
-- │  WHY MAX() AND NOT COUNT()?                              │
-- │                                                          │
-- │  A visitor might view /products twice (browsed, went     │
-- │  back, browsed again). COUNT would say 2, but we only    │
-- │  care: did they GET there? Yes or no. MAX(1) = 1.        │
-- │  MAX() collapses to "did it happen at least once?"       │
-- └──────────────────────────────────────────────────────────┘
--
-- Add this CTE after your test_sessions CTE from 3.1:
--
-- session_funnel_flags AS (
--     SELECT
--         ts.website_session_id,
--         ts.landing_page,
--         MAX(CASE WHEN wp.pageview_url = '/products' THEN 1 ELSE 0 END) AS to_products,
--         MAX(CASE WHEN wp.pageview_url = '/cart' THEN 1 ELSE 0 END) AS to_cart,
--         MAX(CASE WHEN wp.pageview_url IN ('/billing', '/billing-2') THEN 1 ELSE 0 END) AS to_billing,
--         MAX(CASE WHEN wp.pageview_url = '/thank-you' THEN 1 ELSE 0 END) AS placed_order
--     FROM test_sessions ts
--     INNER JOIN website_pageviews wp
--         ON ts.website_session_id = wp.website_session_id
--     GROUP BY
--         ts.website_session_id,
--         ts.landing_page
-- )
--
-- Run: SELECT * FROM session_funnel_flags LIMIT 20
-- You should see 1s and 0s showing how far each session progressed.
--
-- ANSWER: What does a row with 1,1,1,1 mean? _____________
-- ANSWER: What does a row with 1,0,0,0 mean? _____________




-- 3.4 Aggregate the Funnel — The Full Picture
-- SUM the flags and GROUP BY landing_page to compare
-- /home vs /lp-1 side by side.
--
-- Final SELECT (add after your session_funnel_flags CTE):
-- SELECT
--     landing_page,
--     COUNT(website_session_id) AS total_sessions,
--     SUM(to_products) AS to_products,
--     SUM(to_cart) AS to_cart,
--     SUM(to_billing) AS to_billing,
--     SUM(placed_order) AS placed_order,
--     ROUND(SUM(to_products) * 100.0 / COUNT(website_session_id), 2) AS lander_click_rate,
--     ROUND(SUM(placed_order) * 100.0 / COUNT(website_session_id), 2) AS overall_conversion_rate
-- FROM session_funnel_flags
-- GROUP BY landing_page
--
-- Write the COMPLETE query: 3 CTEs + final SELECT.




-- ANSWER: Which landing page had more total sessions? _____________
-- ANSWER: Which landing page had a higher overall conversion rate? _____________
-- ANSWER: At which funnel step is the biggest drop-off? _____________


-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO CHERYL                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- PART 4: QUANTIFY THE IMPACT — Show Me the Money
-- ============================================================================
-- ============================================================================
-- CHERYL EMAIL 3
-- ============================================================================
-- From:    Cheryl, E-commerce Manager
-- To:      You, Data Analyst
-- Date:    Wednesday, February 25, 2026, 11:45 AM
-- Subject: Billing page test — need revenue numbers
--
-- "We also tested a new billing page! From September 10 to November 10,
-- we split traffic between /billing (original) and /billing-2 (new design).
-- I don't just want conversion rates this time — I want REVENUE. Which
-- billing page generated more revenue per session? And can you estimate
-- how much extra revenue the new page brought in during October?"
-- ============================================================================

-- 4.1 Revenue per Billing Page Session (Part A)
-- This query does NOT need a CTE. It's a single step. CTEs are a tool,
-- not a requirement. Use them when they help readability.
--
-- Join website_pageviews to orders using website_session_id.
-- Filter to billing pages during the test period (Sept 10 to Nov 10).
-- Use LEFT JOIN because not every billing session placed an order.
-- Use COUNT(DISTINCT) to avoid duplicate sessions.
--
-- HINT:
-- SELECT
--     wp.pageview_url AS billing_version,
--     COUNT(DISTINCT wp.website_session_id) AS total_sessions,
--     COUNT(DISTINCT o.order_id) AS total_orders,
--     ROUND(SUM(o.price_usd) / COUNT(DISTINCT wp.website_session_id), 2) AS revenue_per_session
-- FROM website_pageviews wp
-- LEFT JOIN orders o
--     ON wp.website_session_id = o.website_session_id
-- WHERE wp.pageview_url IN ('/billing', '/billing-2')
--     AND wp.created_at >= '2023-09-10'
--     AND wp.created_at < '2023-11-10'
-- GROUP BY wp.pageview_url




-- ANSWER: Revenue per session for /billing: $____________
-- ANSWER: Revenue per session for /billing-2: $____________
-- ANSWER: What is the lift (difference)? $____________


-- 4.2 Incremental Revenue Estimate (Part B)
-- How much extra revenue did /billing-2 generate in October?
-- Count /billing-2 sessions in October, multiply by the lift from 4.1.
-- You can hardcode the lift value from Part A.
--
-- HINT:
-- SELECT
--     COUNT(DISTINCT website_session_id) AS october_billing2_sessions,
--     COUNT(DISTINCT website_session_id) * ____ AS estimated_incremental_revenue
-- FROM website_pageviews
-- WHERE pageview_url = '/billing-2'
--     AND created_at >= '2023-10-01'
--     AND created_at < '2023-11-01'




-- ANSWER: /billing-2 sessions in October: _____________
-- ANSWER: Estimated incremental revenue: $_____________


-- ┌─────────────────────────────────────────────────────────────────────┐
-- │ REPLY TO CHERYL                                                    │
-- │                                                                    │
-- │ WHAT:    ________________________________________________________ │
-- │                                                                    │
-- │ SO WHAT: ________________________________________________________ │
-- └─────────────────────────────────────────────────────────────────────┘


-- ============================================================================
-- PART 5: YOUR ANALYSIS
-- ============================================================================

-- THE COMPLETE STORY:
-- 1. What is the average number of pages per session? (Part 1)
--    ANSWER: _______________________________________________________________
--
-- 2. Which landing pages have the highest and lowest bounce rates? (Part 2)
--    ANSWER: Highest: __________________ Lowest: __________________
--
-- 3. In the A/B test, which landing page drove more orders? (Part 3)
--    ANSWER: _______________________________________________________________
--
-- 4. How much incremental revenue did the new billing page generate? (Part 4)
--    ANSWER: _______________________________________________________________

-- WHAT DID EACH LESSON TEACH YOU?
-- | Lesson | Scenario      | Key SQL Technique          | Business Output        |
-- |--------|---------------|----------------------------|------------------------|
-- | 01     | Campus Bites  | CASE WHEN, LAG()           | ________________________|
-- | 02     | Campus Bites  | Pivot, % of total          | ________________________|
-- | 03     | Basket Craft  | JOINs, Subqueries, NTILE   | ________________________|
-- | 04     | Basket Craft  | CTEs, ROW_NUMBER, Funnels   | ________________________|

-- YOUR INSIGHT STATEMENT:
-- Write a single sentence summarizing your most important finding for Cheryl.
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________

-- YOUR RECOMMENDATION:
-- What is the single most impactful action Cheryl should take next?
--
-- ANSWER: __________________________________________________________________
--
-- __________________________________________________________________________


-- ============================================================================
-- ON YOUR OWN: Assignment 01 Warm-Up Challenges
-- ============================================================================
-- These two challenges use the EXACT patterns you'll need for
-- Assignment 01 Tasks 1 and 2. Completing them here = a head start.
-- ============================================================================

-- CHALLENGE 1: Monthly Sessions, Orders, and Conversion Rate
-- (Warm-up for Assignment 01 Task 1)
--
-- Show monthly sessions, orders, and conversion rate for all traffic
-- before November 27, 2023 (the CEO's email date).
--
-- Tables: website_sessions LEFT JOIN orders ON website_session_id
-- GROUP BY: YEAR and MONTH of ws.created_at
-- Columns: order_year, order_month, month_name, total_sessions,
--          total_orders, conversion_rate_pct
-- Filter: ws.created_at < '2023-11-27'
--
-- HINT: COUNT(o.order_id) counts only sessions with orders (skips NULLs).
--       COUNT(ws.website_session_id) counts ALL sessions.




-- ANSWER: How many months of data appear? _____________
-- ANSWER: Which month had the highest conversion rate? _____________
-- ANSWER: Did the business grow over these 9 months? _____________


-- CHALLENGE 2: Google Brand vs Nonbrand Monthly Trend
-- (Warm-up for Assignment 01 Task 2)
--
-- Show monthly sessions for Google nonbrand vs brand campaigns.
-- Filter to Google traffic only (utm_source = 'google').
-- Use CASE WHEN inside COUNT to create separate columns.
--
-- Columns: order_year, order_month, month_name,
--          nonbrand_sessions, brand_sessions
-- Filter: ws.utm_source = 'google' AND ws.created_at < '2023-11-27'
--
-- HINT:
--   COUNT(CASE WHEN ws.utm_campaign = 'nonbrand'
--         THEN ws.website_session_id END) AS nonbrand_sessions




-- ANSWER: Which campaign type has more sessions? _____________
-- ANSWER: Are brand sessions growing over time? _____________




-- ============================================================================
-- SQL CONCEPTS COVERED
-- ============================================================================
-- Review:    SELECT, FROM, WHERE, COUNT, SUM, ROUND, GROUP BY, ORDER BY
-- Reinforce: LEFT JOIN, COUNT(col) skips NULL, CASE WHEN, Subqueries, NTILE
-- NEW:       WITH ... AS (CTE syntax): named, reusable query blocks
-- NEW:       Multi-CTE chaining: comma-separated CTEs that build on each other
-- NEW:       ROW_NUMBER() OVER (PARTITION BY): numbering rows within groups
-- NEW:       MAX(CASE WHEN) flag aggregation: "did this happen at least once?"
-- NEW:       Conversion funnel pattern: flag → collapse → count → rate
-- NEW:       Revenue per session: A/B test impact measurement
--
-- KEY PATTERNS LEARNED:
-- * Landing Page:  ROW_NUMBER() → filter page_num = 1 → that's the landing page
-- * Bounce Rate:   COUNT single-page sessions / COUNT all sessions
-- * Funnel:        Flag steps with CASE WHEN → MAX() per session → SUM to count
-- * A/B Revenue:   LEFT JOIN to orders → SUM(revenue) / COUNT(DISTINCT sessions)
-- ============================================================================
--
-- NEXT: Assignment 01 uses ALL of these patterns on the same basket_craft data.
-- The On Your Own challenges above are literal warm-ups for Tasks 1-2.
-- Parts 3-4 of this lesson ARE the patterns for Tasks 4-5.
-- ============================================================================
