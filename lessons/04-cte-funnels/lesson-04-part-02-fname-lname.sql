-- ============================================================================
-- LESSON 04, PART 2: A/B Test Analysis with Conversion Funnels
-- ============================================================================
--
-- SCENARIO: Cheryl, the E-commerce Manager at Basket Craft, ran two A/B
-- tests on the website — one on the landing page and one on the billing
-- page. She needs you to build conversion funnels and calculate the
-- revenue impact. Did the new designs actually work?
--
-- YOUR MISSION: Use CTEs and CASE WHEN to build conversion funnels,
-- compare A/B test variants side by side, and estimate revenue lift.
--
-- DATABASE: basket_craft (same as Part 1)
-- TABLES:   website_pageviews, website_sessions, orders
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                           | Status     | Used In        |
-- |-----------------------------------|------------|----------------|
-- | SELECT, FROM, WHERE               | Review     | All Parts      |
-- | COUNT, SUM, ROUND                 | Review     | Parts 3-4      |
-- | GROUP BY, ORDER BY                | Review     | Parts 3-4      |
-- | LEFT JOIN, COUNT(col) skips NULL  | Reinforce  | Part 4         |
-- | CASE WHEN                         | Reinforce  | Parts 3-4      |
-- | WITH ... AS (CTE syntax)          | Reinforce  | Part 3         |
-- | ROW_NUMBER() OVER (PARTITION BY)  | Reinforce  | Part 3         |
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
-- "We ran an A/B test from June 19, 2023 to July 28, 2023. Half of traffic landed
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
-- ANSWER: How many /home sessions? _____________
-- ANSWER: How many /lp-1 sessions? _____________




-- 3.2 Explore a Single Session's Journey
-- Pick one session_id from the test period and look at ALL its pageviews.
-- This grounds the abstract "funnel" concept in concrete data.
--
-- HINT: Try session_id 11729 — it's a full conversion from the A/B test period.
-- SELECT website_session_id, pageview_url
-- FROM website_pageviews
-- WHERE website_session_id = 11729
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
--
-- ANSWER: What does a row with 1,1,1,1 mean? _____________
-- ANSWER: What does a row with 1,0,0,0 mean? _____________




-- 3.4 Aggregate the Funnel — The Full Picture
-- SUM the flags and GROUP BY landing_page to compare
-- /home vs /lp-1 side by side.
--




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
-- "We also tested a new billing page. From September 10, 2023 to November 10, 2023,
-- we split traffic between /billing (original) and /billing-2 (new design).
-- I don't just want conversion rates this time — I want REVENUE. Which
-- billing page generated more revenue per session? And can you estimate
-- how much extra revenue the new page brought in during October?"
-- ============================================================================

-- 4.1 Revenue per Billing Page Session (Part A)
-- This query does NOT need a CTE. It's a single step. CTEs are a tool,
-- not a requirement. Use them when they help readability.
--




-- ANSWER: Revenue per session for /billing: $____________
-- ANSWER: Revenue per session for /billing-2: $____________
-- ANSWER: What is the lift (difference)? $____________


-- 4.2 Incremental Revenue Estimate (Part B)
-- How much extra revenue did /billing-2 generate in October?
-- Count /billing-2 sessions in October, multiply by the lift from 4.1.
-- You can hardcode the lift value from Part A.
--




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
-- ON YOUR OWN: Assignment 01 Warm-Up Challenges
-- ============================================================================
-- These two challenges use the EXACT patterns you'll need for
-- Assignment 01 Tasks 1 and 2. Completing them here = a head start.
-- ============================================================================

-- ============================================================================
-- From:    Kara, CEO
-- To:      You, Data Analyst
-- Date:    November 27, 2023, 7:00 AM
-- Subject: Board meeting prep — monthly growth numbers
--
-- "I'm preparing a presentation for the board meeting next week. Can you
-- pull monthly sessions, orders, and the session-to-order conversion rate?
-- I want to show how we've grown over our first 8 months. Use data before
-- today's date."
-- ============================================================================




-- ANSWER: How many months of data appear? _____________
-- ANSWER: Which month had the highest conversion rate? _____________
-- ANSWER: Did the business grow over these 9 months? _____________


-- ============================================================================
-- From:    Kara, CEO
-- To:      You, Data Analyst
-- Date:    November 27, 2023, 7:15 AM
-- Subject: RE: Board meeting prep — Google brand vs nonbrand
--
-- "One more thing. Can you pull a similar monthly trend for Google, but
-- split out nonbrand and brand campaigns? I'm curious whether brand
-- awareness is picking up. If brand is growing, that's a good story to
-- tell about our marketing strategy."
-- ============================================================================




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
-- NEW:       Conversion funnel pattern: flag -> collapse -> count -> rate
-- NEW:       Revenue per session: A/B test impact measurement
--
-- KEY PATTERNS LEARNED:
-- * CTE:          WITH name AS (query) — named reusable blocks
-- * Landing Page:  ROW_NUMBER() -> filter page_num = 1 -> that's the landing page
-- * Bounce Rate:   COUNT single-page sessions / COUNT all sessions
-- * Funnel:        Flag steps with CASE WHEN -> MAX() per session -> SUM to count
-- * A/B Revenue:   LEFT JOIN to orders -> SUM(revenue) / COUNT(DISTINCT sessions)
-- ============================================================================
--
-- NEXT: Assignment 01 uses ALL of these patterns on the same basket_craft data.
-- The On Your Own challenges above are literal warm-ups for Tasks 1-2.
-- Parts 3-4 of this lesson ARE the patterns for Tasks 4-5.
-- ============================================================================
