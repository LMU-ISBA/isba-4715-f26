/*
=====================================================================================================================
Assignment 01: Board Meeting Presentation
Due: Monday, March 16, 11:59 PM
Individual Assignment
Overall Grade %: 10 (Total: 100 Points)
=====================================================================================================================

DATATHON ALTERNATIVE
If you participate in the LMU Datathon, you may submit your datathon deliverables instead of
this SQL assignment. Submit your datathon presentation slides to the same Brightspace assignment folder by the due date.

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

Database: Use the basket_craft schema on the class database server.

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

Each task follows the 5-Step Analytics Framework (DC ACT):
1. Define the business problem
2. Collect and prepare the data
3. Analyze the data and generate insights
4. Communicate the insights, recommendations, and predictions
5. Act and track the change

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
- Prepare one slide per task (5 slides total). Be ready to explain the supporting SQL (include in an appendix).
- On presentation day, you will be assigned a random task to present in 90 seconds.
- Rubric: https://r.isba.co/aacu-oral-communication-rubric

SLIDE DESIGN CHECKLIST (for each slide)
[ ] WHAT (insight): Slide title is a finding, not a topic. Complete sentence with a number.
    Bad:  "Revenue Analysis"
    Good: "Email campaign drove 40% more conversions than display ads last quarter"
[ ] DATA: Table, chart, or screenshot that backs up your title. Only show relevant data.
[ ] CALLOUT: Circle, arrow, or bold the key number(s) that connect to your title.
[ ] SO WHAT (recommendation + prediction): What should we do, and what happens if we do?
    Format: "[Action] → [Expected outcome]"
    Example: "Shift 40% of display budget to email → projected 200+ additional conversions next quarter"
[ ] SELF-TEST: Read only your title and SO WHAT. Does someone know the finding AND what to do?

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
HINT:
- Organic: utm_source IS NULL AND http_referer IS NOT NULL (came from a search engine, but not a paid ad)
- Direct: utm_source IS NULL AND http_referer IS NULL (typed the URL directly)

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

This task has two parts. Write a separate query for each.

Part A: Calculate the revenue per billing page session for /billing and /billing-2 during the test period
        (September 10 to November 10). Then calculate the lift (difference in revenue per session between
        the two versions).

Part B: Pull the number of /billing-2 sessions from October 2023. Multiply that count by the revenue lift
        from Part A to estimate the incremental revenue gained last month. You can hardcode the lift value
        from Part A directly into your Part B query.
*/

/*
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

If you had 30 seconds to summarize Basket Craft's first 8 months to the board, what would you say?

ANSWER: __________________________________________________________________

________________________________________________________________________

________________________________________________________________________
*/
