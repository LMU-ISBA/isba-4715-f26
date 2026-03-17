# Midterm Interview Study Guide
**Data Analyst Interview | Lessons 01-04 + Assignment 01 | 20 Minutes | Closed Book**

## Premise

The Data Analyst Interview mirrors the technical interview process for an entry-level data analyst role.

Examples of related data analyst roles:
- Business Analyst
- Data Analyst
- Business Intelligence Analyst
- Analytics Consultant
- Quantitative Analyst
- Market Research Analyst
- Operations Analyst
- Financial Analyst
- Customer Insights Analyst

Examples of real-life roles:
- Data Analyst - Disney Direct to Consumer
- Reporting Analyst - Lamps Plus
- Gaming Product Data Analyst - TapBlaze

Your objective is to secure the job, which equals earning an "A" grade.

| Grade | Description |
|-------|-------------|
| A | Demonstrated exceptional qualifications and skills, making you an outstanding candidate for the position. |
| B | Performed well and has strong potential for the role, though there may be some areas for improvement. |
| C | Met the basic requirements for the position, but there may be significant room for growth and development in certain aspects. |
| D, F | Fell significantly short of expectations, and substantial improvements are necessary to be considered for the role. |

**Overall Grade %:** 14%
**Total Points:** 100 (Make every effort to attempt all questions for partial credit)

**Scheduling:** https://calendly.com/greg-lontok/sql-midterm-interview
Schedule the interview for a 25-minute slot. There is a 5-minute buffer between interviews.

---

## Environment

The interview will be conducted over **Zoom** at https://lmula.zoom.us/my/lontok. You will use **DBeaver** (the same desktop SQL client from class) connected to the `basket_craft` database.

**Before your interview:**
1. Open DBeaver and verify you can connect to the `basket_craft` database
2. Join the Zoom meeting 2-3 minutes early: https://lmula.zoom.us/my/lontok
3. Have your screen ready to share (DBeaver open, connected)
4. Enable your video and microphone

**During the interview:**
- I will send you a `.sql` template file via **Microsoft Teams** at the start
- Open the file in DBeaver and work from it
- My video will be off, but my microphone will be on
- To familiarize yourself with the template format, [preview it here](midterm-interview-template.sql)

**After the interview:**
- Submit your `.sql` file to **Brightspace** within **5 minutes** after the call ends

---

## What to Expect

You will receive a single business scenario and take it end-to-end, just like a real technical interview. Here is exactly what will happen:

| Phase | Time | What Happens |
|-------|------|-------------|
| **Setup** | 0:00-1:00 | Share your screen in DBeaver. Quick mic check. I send you the template file via Teams. |
| **Scenario** | 1:00-3:00 | I present a business problem. It will be deliberately open-ended. Part of the assessment is what questions you ask to scope it. |
| **Approach** | 3:00-5:00 | Talk me through how you would tackle this *before* writing any SQL. You can jot notes as SQL comments. |
| **Write & Execute** | 5:00-14:00 | Write your SQL from scratch and run it. Think out loud as you work. The problem has two steps: a foundational query and an advanced layer. |
| **Interpret** | 14:00-18:00 | Look at your results and tell me: What is the insight? What would you recommend? What do you predict will happen? |
| **Wrap Up** | 18:00-20:00 | I give you feedback, ask a reflection question, and share what to focus on for the final interview. |

**Key differences from the quizzes:**
- No fill-in-the-blank. You write everything from scratch.
- The business problem is intentionally vague. You need to ask clarifying questions.
- You must think out loud the entire time. Silence counts against you.
- This is a conversation, not a test. Ask questions, explain your reasoning.

---

## Rubric

You are being assessed on six categories:

| Category | Points | When |
|----------|--------|------|
| Clarifying Questions | 10 | Scenario phase. Did you ask smart questions to scope the problem? Did you identify assumptions? |
| Approach | 15 | Approach phase. Could you articulate a logical plan before writing code? Did you identify the right tables, joins, and aggregations? |
| SQL Query | 40 | Write & Execute phase. Correct syntax, logic, and results. Step 1 (foundational query) is worth 25 points. Step 2 (advanced layer) is worth 15 points. |
| Style & Formatting | 5 | Write & Execute phase. SQL best practices from class (indentation, naming, `COUNT(column)` not `COUNT(*)`). |
| Interpretation | 15 | Interpret phase. Insight is a takeaway title (not a topic). Recommendation is actionable. Prediction is logical. All three connect. |
| Communication | 15 | Throughout. Did you think out loud? Use correct SQL terminology? Stay organized and concise? |
| **Total** | **100** | |

**What is the interviewer assessing?**
1. Problem-Solving
2. Business Acumen
3. Technical Skills (SQL)
4. Communication
5. Attention to Detail

### Hints

If you get stuck, I will help, just like a real interviewer would.

- Your first hint is free
- Each additional hint costs 5 points (from your SQL score)
- If you are completely stuck, I can give you a result set to interpret (max 20/40 on SQL, but you can still earn full points on Interpretation and Communication)

**What counts as a hint:** A hint is when I give you SQL direction (e.g., "Have you considered using a LEFT JOIN?" or "Think about how you'd group this"). If you ask me a business question ("What do you mean by value?" or "Which time period?"), that is normal interview dialogue. Free and encouraged.

---

## Concept Map — When and Why

Focus on *when* you would reach for each tool and *why*, not just memorizing syntax.

### Foundation (Lessons 01-02: Campus Bites)

| When You Need To... | Use This | Example |
|---------------------|----------|---------|
| Count, total, or average something | `COUNT(col)`, `SUM(col)`, `AVG(col)` | "How many orders did we get?" |
| Group results by category | `GROUP BY` | "Orders per customer segment" |
| Sort results | `ORDER BY` (+ `DESC`) | "Biggest to smallest" |
| Filter rows before grouping | `WHERE` | "Only May 2026 orders" |
| Filter groups after aggregation | `HAVING` | "Segments with 100+ orders" |
| Create categories from values | `CASE WHEN ... THEN ... END` | "Morning / Afternoon / Evening" |
| Compare to previous period | `LAG() OVER (ORDER BY)` | "This month vs. last month" |
| Calculate percentage change | `(new - old) * 100.0 / old` | "Orders dropped 20%" |
| Round a number | `ROUND(value, decimals)` | "68.3% not 68.33333%" |
| Extract parts of a date | `YEAR()`, `MONTH()`, `MONTHNAME()`, `HOUR()` | "Which month? Which hour?" |
| Create a side-by-side comparison | `SUM(CASE WHEN ... THEN 1 ELSE 0 END)` | "April orders vs. May orders in columns" |

### Connecting Data (Lesson 03: Basket Craft — RFM & JOINs)

| When You Need To... | Use This | Example |
|---------------------|----------|---------|
| Combine data from two related tables | `INNER JOIN ... ON` | "Match orders to users" |
| Keep all rows from one table even without matches | `LEFT JOIN ... ON` | "All users, even those with 0 orders" |
| Find rows with no match | `LEFT JOIN` + `WHERE col IS NULL` | "Users who never ordered" |
| Reuse a result set as a table | Subquery in `FROM` | "Average of averages" |
| Score into equal-sized tiers | `NTILE(n) OVER (ORDER BY)` | "Top 25% of spenders" |
| Calculate days between dates | `DATEDIFF(date1, date2)` | "Days since last order" |

### Advanced Patterns (Lesson 04: Basket Craft — CTEs & Funnels)

| When You Need To... | Use This | Example |
|---------------------|----------|---------|
| Break a complex query into readable steps | `WITH ... AS` (CTE) | "First calculate totals, then rank them" |
| Chain multiple steps together | Multi-CTE: `WITH cte1 AS (...), cte2 AS (...)` | "Sessions, then landing pages, then bounce rates" |
| Find the first/last occurrence per group | `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` | "Each user's first website session" |
| Rank items within a group | `RANK() OVER (ORDER BY ...)` | "Which product ranks highest by margin?" |
| Create a binary flag from grouped data | `MAX(CASE WHEN ... THEN 1 ELSE 0 END)` | "Did this session reach the billing page?" |
| Build a conversion funnel | Count flags across stages | "Sessions to Product to Cart to Purchase" |
| Compare A/B test results | Group by test variant + measure metric | "Revenue per session: old page vs. new page" |

### Common Pitfalls

1. **`COUNT(*)` vs `COUNT(column)`** — Always use `COUNT(column_name)`. Use the primary key when counting rows.
2. **Semicolon between CTE and SELECT** — No semicolon between `WITH ... AS (...)` and the `SELECT`. The query will fail.
3. **`WITH` twice in chained CTEs** — Use a comma between CTEs, not another `WITH`.
4. **`COUNT` instead of `MAX` for flags** — `MAX(CASE WHEN ...)` gives 0 or 1. `COUNT` gives the actual count, which is not a flag.
5. **Forgetting `PARTITION BY`** — Without it, `ROW_NUMBER()` numbers all rows together instead of resetting per group.
6. **Integer division** — `100` not `100.0` truncates decimals. Always use `100.0` for percentages.
7. **Using reserved words as aliases** — Avoid `year`, `month`, `date`, `order`. Use `order_year`, `order_month`, etc.

---

## How to Think Out Loud

Going silent while coding costs you Communication points (15 points) and makes it harder to earn partial credit on your SQL.

### Why It Matters

In a real analyst interview, your thought process matters as much as the final answer. If I can follow your reasoning, I can give you credit for the right approach even when you make a syntax error. I can also redirect you early if you are heading the wrong way.

### What to Say at Each Phase

**During Scenario (asking clarifying questions):**
> "So the marketing team wants to know about customer value — before I start, can I ask a few questions? When you say 'value,' are we talking about revenue, order count, or something else? And is there a specific time period we should focus on?"

**During Approach (before coding):**
> "OK, so I need to find total revenue by customer segment for Q1. I'll need the orders table for revenue and I'll JOIN to users to get the segment. I'll GROUP BY segment and use SUM for revenue. Then for the second part, I think I can wrap that in a CTE and add a window function to rank the segments."

**During Write & Execute (while coding):**
> "I'm starting with my SELECT — I need the segment column from users, so I'll need a JOIN... let me write the FROM and JOIN first, then come back to SELECT."
>
> "This isn't giving me what I expected — let me check my JOIN condition... ah, I think I need to use the order_id from orders, not from order_items."

**During Interpret (reading results):**
> "Looking at these results, the top segment by revenue is [X] with $[Y]. That's interesting because it's not the segment with the most orders — they just have a higher average order value. So my takeaway title would be: '[Segment] Drives [X]% of Revenue Despite Fewer Orders, Fueled by High-Value Purchases.'"

### Practice This

Before the interview, practice narrating your thought process while writing SQL. Open any lesson exercise, turn on a voice recorder (or just talk to yourself), and work through a problem while explaining every decision out loud. It will feel awkward at first. That is normal. Do it anyway.

---

## Practice Scenarios

These are *not* the actual interview problems, but they follow the same format. Practice scoping the problem, planning your approach, and writing the query from scratch. Try each one on your own first, then check the walkthrough.

### Scenario A: Product Performance

> The Head of Product says: "I want to know which products are actually making us money. Some of our best-sellers might not be the most profitable."

**Think about:**
- What clarifying questions would you ask? (Time period? "Profitable" means revenue or margin? Which products — all or a subset?)
- Which tables do you need? (orders, order_items, products)
- What JOIN pattern? (INNER JOIN to connect order_items to products)
- What aggregation? (SUM revenue, COUNT orders, GROUP BY product)
- How could you layer on a CTE or window function? (Rank products by profit margin, or compare to the average)

[Scenario A Walkthrough](practice-scenario-a-walkthrough.md)

### Scenario B: Customer Retention

> The VP of Marketing asks: "We're spending a lot on acquiring new customers. Are they coming back, or are we losing them after the first purchase?"

**Think about:**
- What clarifying questions would you ask? (Define "coming back" — second order within what timeframe? What acquisition period?)
- Which tables do you need? (orders, users)
- What's the approach? (COUNT orders per user, flag repeat vs. one-time buyers)
- What concepts apply? (GROUP BY user_id, HAVING, CASE WHEN for flagging, possibly ROW_NUMBER for first order date)
- How could Step 2 build on this? (CTE to calculate repeat purchase rate by cohort, or NTILE to segment by purchase frequency)

[Scenario B Walkthrough](practice-scenario-b-walkthrough.md)

### Scenario C: Channel Effectiveness

> The Digital Marketing Manager says: "I need to know which channels are actually converting visitors into paying customers. We might be wasting budget."

**Think about:**
- What clarifying questions would you ask? (What does "converting" mean — any order, or first-time order? Which channels? Time period?)
- Which tables do you need? (website_sessions, orders)
- What JOIN pattern? (LEFT JOIN — not every session results in an order)
- What's the key metric? (Conversion rate: COUNT(order_id) / COUNT(website_session_id) * 100.0)
- How could Step 2 extend this? (CTE + window function to show conversion rate trend over time, or CASE WHEN to compare desktop vs. mobile)

[Scenario C Walkthrough](practice-scenario-c-walkthrough.md)

---

## Study Tips

- **Form study groups.** Quiz each other with business scenarios and practice thinking out loud.
- **Do SQL reps.** Write the same query patterns from scratch until they feel automatic.
- **Whiteboard your approach.** Before touching the keyboard, sketch out which tables, joins, and aggregations you need.
- **Focus on your weak spots.** If JOINs trip you up, spend extra time there. If CTEs confuse you, drill those.
- **Use practice platforms:**
  - [InterviewQuery](https://www.interviewquery.com/)
  - [StrataScratch](https://www.stratascratch.com/)
  - [DataLemur](https://datalemur.com/)
  - [SQLPad](https://sqlpad.io/)
- **Review all lesson exercises.** The interview draws from Lessons 01-04 and Assignment 01.
- **Review Zoom recordings and slides.** Revisit concepts you found difficult.
- **Practice with AI.** Ask ChatGPT or Claude to give you a business scenario and evaluate your approach. But make sure you can do it *without* AI too — the interview is closed book.

---

## Interview Tips

- **Take your time.** Rushing leads to mistakes. A few seconds of silence to gather your thoughts is fine, but then start narrating what you are thinking.
- **Ask clarifying questions.** They are worth 10 points and show you think like an analyst, not a code monkey.
- **If you are unsure, say what you know.** "I know I need a JOIN here, but I'm not sure about the ON condition. Let me think through the relationship between these tables." That earns partial credit.
- **Structure your approach.** Before coding, say what you need: "I'll start with the orders table, JOIN to users for the segment, then GROUP BY with a SUM."
- **Start big, then go small.** Get the basic query working first, then refine. Do not try to write the perfect query on the first attempt.
- **Write notes as comments.** Use `--` comments in your SQL file to jot down your approach, assumptions, and observations.
- **Do not panic if your query errors.** Read the error message, talk through what might be wrong, and fix it. Debugging is part of the job.
- **Keep your interpretation concise.** Insight + Recommendation + Prediction, each one sentence. All three should connect to each other.

---

## Last Tips

- Get a good night's sleep.
- Take a deep breath if you get nervous.
- Do not be afraid to ask for clarification.
- Carpe diem! This is your chance to show me everything you have learned.
