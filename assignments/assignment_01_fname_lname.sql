/*
=====================================================================================================================
Assignment 01: Board Meeting Presentation
Due: Monday, March 16, 9:55 AM
Individual Assignment
Overall Grade %: 10 (Total: 100 Points)
=====================================================================================================================

DATATHON ALTERNATIVE
If you participate in the LMU Datathon on Friday, March 14, you may submit your datathon deliverables instead of
this SQL assignment. Submit your presentation slides and a one-page reflection to the same Brightspace assignment
folder by the due date.

SUBMISSION INSTRUCTIONS
- SQL file:          assignment_01_fname_lname.sql
- Presentation file: assignment_01_fname_lname.pdf
- Publicly accessible link to presentation slides

SUBMISSION CHECKLIST (deductions apply if not followed)
[ ] SQL file uses correct filename format (-2 if incorrect)
[ ] Presentation file uses correct filename format (-2 if incorrect)
[ ] Slides are publicly accessible. Test from an incognito/private browser window (-2 if not accessible)
[ ] SQL follows formatting standards: https://www.sqlstyle.guide (-2 if not followed)

=====================================================================================================================

Database Connection Details:
hostname: db.isba.co
username: analyst
password: go_lions
database: basket_craft
port: 3306

=====================================================================================================================

SITUATION

Basket Craft has been operating for about eight months, and the CEO is preparing for a board meeting. Your job
is to analyze website traffic and sales data to measure how the company has grown and whether its marketing
experiments are working.

You'll also need to tell the story behind the numbers. The board doesn't just want a data dump. They want to
understand what happened, why it matters, and what to do next.

Analyze only data from before November 27, 2023. That's the date of the CEO's email.

=====================================================================================================================

DELIVERABLES (per task)

Each task follows the Analytics Framework (Define, Collect, Analyze, Interpret, Act):

| Component          | Weight | What to Do                                                       |
|--------------------|--------|------------------------------------------------------------------|
| Business Question  |  10%   | Rephrase the CEO's request in your own words                     |
| Expected Output    |   5%   | List the column names your query will return                     |
| Query              |  35%   | Write SQL that answers the business question                     |
| Insights           |  10%   | Explain what the results mean. Reference specific values         |
| Recommendation     |   5%   | What action should the CEO take?                                 |
| Prediction         |   5%   | What will happen if they follow your recommendation?             |
| Presentation       |  30%   | One slide per task. 90 seconds. Random task on presentation day  |

Presentation details:
- Prepare one slide per task (5 slides total) with concise takeaways.
- Be ready to explain the supporting SQL (include in an appendix).
- Rubric: https://r.isba.co/aacu-oral-communication-rubric

TIPS
- Consider the A/B tests conducted and business changes leading up to this point.
- Use COUNT(column_name) instead of COUNT(*) to make your intent explicit.
- Each task builds on concepts from the previous one. If you get stuck, review the earlier tasks.
- You can include notes and pseudocode above the SQL to map out your approach.

=====================================================================================================================
*/

-- =====================================================================================================================

/*
From: Kara (CEO)
Subject: Board Meeting Next Week
Date: November 27, 2023

Hey team,

I need help preparing a presentation for the board meeting next week. The board wants to understand our growth
story over our first 8 months. I've broken down what I need below.

Let me know if you have any questions.

Thanks,
Kara
*/

-- =====================================================================================================================

/*
TASK 1 - Monthly Growth Story (15 points)

I'd like to tell the board the story of our sales performance over our first 8 months. Can you pull monthly
sessions, orders, and the session-to-order conversion rate? This will give the board a clear picture of how
we've grown month over month.
*/

/*
GUIDANCE:
- You need data from two tables: website_sessions and orders. They share website_session_id.
- Think about which JOIN type keeps ALL sessions, even those that didn't result in an order.
- Conversion rate is the fraction of sessions that became orders, expressed as a percentage.
- Data cutoff: WHERE ws.created_at < '2023-11-27'

Business Question:
???

Expected Output:
???
*/

-- Query
-- ???

/*
Insights:
???

Recommendation:
???

Prediction:
???
*/

-- =====================================================================================================================

/*
TASK 2 - Google Brand vs Nonbrand (18 points)

Next, I'd like a similar monthly trend for Google, but this time splitting out nonbrand and brand campaigns.
I'm curious to know if brand awareness is picking up at all. If brand is growing, that's a great story to
tell about our marketing strategy.
*/

/*
GUIDANCE:
- Filter to Google traffic only (check the utm_source column).
- Use CASE WHEN to pivot sessions and orders into separate columns for each campaign type.
  Example: COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN ws.website_session_id END) AS nonbrand_sessions

Business Question:
???

Expected Output:
???
*/

-- Query
-- ???

/*
Insights:
???

Recommendation:
???

Prediction:
???
*/

-- =====================================================================================================================

/*
TASK 3 - Channel Diversification (20 points)

I have a concern that a board member might question how much of our traffic comes from Google. Could you pull
monthly session trends for each of our traffic channels side by side? I want to see Google, Bing, organic
search, and direct traffic all in one report so I can show we're diversifying.
*/

/*
GUIDANCE:
- Run SELECT DISTINCT utm_source, http_referer FROM website_sessions to explore what values exist.
- Use CASE WHEN to create a column for each channel. Some channels require multiple conditions (AND).
- Think about what distinguishes paid traffic from organic, and organic from direct.

Business Question:
???

Expected Output:
???
*/

-- Query
-- ???

/*
Insights:
???

Recommendation:
???

Prediction:
???
*/

-- =====================================================================================================================

/*
TASK 4 - Landing Page A/B Test Funnel (25 points)

We ran an A/B test on our landing page from June 19 to July 28 to see if a new design (/lp-1) would outperform
the original (/home). I need a full conversion funnel for each landing page showing how many sessions made it
to each step: products page, cart, billing, and placed an order.
*/

/*
GUIDANCE:
This is the most complex analysis. You'll need to use CTEs (Common Table Expressions) to break it into steps.

CTE SYNTAX:
    WITH step_name AS (
        SELECT ...
    )
    SELECT ... FROM step_name;

    Multiple CTEs are separated by commas:
    WITH step_one AS ( ... ),
         step_two AS ( ... )
    SELECT ... FROM step_two;

APPROACH:
  Step 1 (CTE): Find each session's landing page during the test period.
                The landing page is the FIRST pageview in a session (MIN of website_pageview_id).
                Join website_sessions to website_pageviews and GROUP BY website_session_id.
                Filter: ws.created_at >= '2023-06-19' AND ws.created_at < '2023-07-29'

  Step 2 (CTE): Join back to website_pageviews to get the landing page URL, then flag whether
                each session reached each funnel step using:
                MAX(CASE WHEN pages.pageview_url = '/products' THEN 1 ELSE 0 END) AS to_products
                Only keep sessions where the landing page is '/home' or '/lp-1'.

  Step 3 (SELECT): Group by landing page and SUM the flags to get totals at each step.

Business Question:
???

Expected Output:
???
*/

-- Query
-- ???

/*
Insights:
???

Recommendation:
???

Prediction:
???
*/

-- =====================================================================================================================

/*
TASK 5 - Billing Page Revenue Impact (22 points)

We also ran an A/B test on our billing page from September 10 to November 10 to compare our new billing page
(/billing-2) against the original (/billing). I want to show the board how the new design increased revenue.

This task has two parts:

Part A: Calculate the revenue per billing page session for /billing and /billing-2 during the test period
        (September 10 to November 10). Then calculate the lift (difference in revenue per session between
        the two versions).

Part B: Pull the number of /billing-2 sessions from October 2023. Multiply that count by the revenue lift
        from Part A to estimate the incremental revenue gained last month. You can hardcode the lift value
        from Part A directly into your Part B query.
*/

/*
GUIDANCE:
- For Part A, you need to connect website_pageviews to orders through website_session_id.
- Filter to the test period and billing page URLs ('/billing', '/billing-2').
- Revenue per billing session = total revenue / number of distinct billing sessions.
- For Part B, the lift is the dollar difference between the two revenue-per-session values.

Business Question:
???

Expected Output:
???
*/

-- Part A Query
-- ???

-- Part B Query
-- ???

/*
Insights:
???

Recommendation:
???

Prediction:
???
*/

-- =====================================================================================================================

/*
BOARD MEETING SUMMARY

You've completed five analyses. Now tie them together into a single story for the board.

1. Growth trajectory: What does our 8-month performance look like? (Task 1)
   ANSWER: _______________________________________________________________

   ______________________________________________________________________

2. Marketing strategy: Is our Google investment paying off beyond paid clicks? (Tasks 2-3)
   ANSWER: _______________________________________________________________

   ______________________________________________________________________

3. Experimentation: Are our A/B tests generating measurable results? (Tasks 4-5)
   ANSWER: _______________________________________________________________

   ______________________________________________________________________

YOUR OPENING STATEMENT:
If you had 30 seconds to summarize Basket Craft's first 8 months to the board, what would you say?

ANSWER: __________________________________________________________________

________________________________________________________________________

________________________________________________________________________
*/
