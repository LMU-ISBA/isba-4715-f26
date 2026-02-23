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
-- CTEs chain with a comma. No second WITH keyword.
--
-- ┌──────────────────────────────────────────────────────────┐
-- │  CHAINING CTEs                                           │
-- │                                                          │
-- │  WITH cte1 AS (                                          │
-- │      ...                                                 │
-- │  ),                    ← comma, NOT semicolon            │
-- │  cte2 AS (                                               │
-- │      SELECT ... FROM cte1   ← cte2 can use cte1         │
-- │      JOIN other_table ...                                │
-- │  )                                                       │
-- │  SELECT ... FROM cte2;                                   │
-- └──────────────────────────────────────────────────────────┘
--
-- CTE 1: rfm (same as B.2)
-- CTE 2: rfm_with_names — JOIN rfm to users to get their name
-- Final SELECT: Add NTILE(5) scores from rfm_with_names





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
-- "Hi, I manage our website at Basket Craft. I've heard you've been doing
-- great work with the marketing and customer data. Now I need help
-- understanding what visitors DO on our site. Can you start by showing me
-- what the website_pageviews table looks like?"
-- ============================================================================

-- 1.1 First Look at website_pageviews
-- Write a query to see the first 50 rows of the website_pageviews table.
-- This is a NEW table you haven't used before.
--
-- ANSWER: What columns do you see? _____________
-- ANSWER: What do you think website_session_id means? _____________
-- ANSWER: Can one session have multiple pageviews? _____________




-- 1.2 What Pages Do Visitors See?
-- Count the total pageviews for each pageview_url.
-- GROUP BY pageview_url and ORDER BY the count descending.
-- Add WHERE created_at <= '2026-02-23'.
--
-- ANSWER: What is the most-viewed page? _____________
-- ANSWER: What page has the fewest views? _____________
-- ANSWER: How many distinct page URLs exist? _____________




-- 1.3 How Many Pages Per Session?
-- Use a CTE to first count pages per session, then calculate the average along with
-- the minimum and maximum number of pages viewed in a session.
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
-- "Good start. Now I need to know: where do visitors START their journey?
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
-- │  at 1. So page_num = 1 is always the FIRST pageview.     │
-- │                                                          │
-- │  Session 1: /home (1), /products (2), /cart (3)          │
-- │  Session 2: /lp-1 (1), /products (2)  ← restarts         │
-- │  Session 3: /home (1)                  ← restarts        │
-- └──────────────────────────────────────────────────────────┘
--
-- Write a CTE named ranked_pageviews that adds a page_num column
-- 



-- ANSWER: What page_num does the first pageview in each session get? _____________
-- ANSWER: When does the numbering restart? _____________
-- ANSWER: If a session has 5 pageviews, what numbers do they get? _____________


-- 2.2 Find the Landing Pages
-- Using your ranked_pageviews CTE from 2.1, filter to only page_num = 1.
-- These are the landing pages. Count how many sessions started on each URL.
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
-- SQL CONCEPTS COVERED (Part 1)
-- ============================================================================
-- Review:    SELECT, FROM, WHERE, COUNT, GROUP BY, ORDER BY
-- Reinforce: Subqueries, NTILE
-- NEW:       WITH ... AS (CTE syntax): named, reusable query blocks
-- NEW:       Multi-CTE chaining: comma-separated CTEs that build on each other
-- NEW:       ROW_NUMBER() OVER (PARTITION BY): numbering rows within groups
--
-- KEY PATTERNS LEARNED:
-- * CTE:          WITH name AS (query) — named reusable blocks
-- * Landing Page:  ROW_NUMBER() → filter page_num = 1 → that's the landing page
-- * Bounce Rate:   COUNT single-page sessions / COUNT all sessions
-- ============================================================================
