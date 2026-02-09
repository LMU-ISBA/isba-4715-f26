# Quiz 01: LMS Grades

**Quiz:** Descriptive & Diagnostic Analytics
**Weight:** 50 points
**Students:** 25
**Class Mean (Post-Calibration):** 90.8 / 100 (45.4 / 50)

> **Note:** All students received a class-wide +2 calibration adjustment on the prediction criterion (t4-prediction), which had a dramatically lower mean (40%) compared to other criteria (80%+). Two students (Lauren de los Reyes, Victor Sofelkanik) received additional individual adjustments. Scores are capped at 100/100 maximum.

### Class Statistics

| Statistic | Score (/100) | Weighted (/50) |
|-----------|-------------|----------------|
| Mean | 90.8 | 45.4 |
| Median | 94 | 47.0 |
| Std Dev | 9.1 | 4.6 |
| Min | 68 | 34.0 |
| Q1 (25th) | 83 | 41.5 |
| Q3 (75th) | 98 | 49.0 |
| Max | 100 | 50.0 |

**Grade Distribution (Post-Calibration)**

| Range | Count | % | |
|-------|------:|----:|---|
| A (90-100) | 17 | 68% | ================= |
| B (80-89) | 3 | 12% | === |
| C (70-79) | 4 | 16% | ==== |
| D (60-69) | 1 | 4% | = |
| F (Below 60) | 0 | 0% | |

---

| Student | Raw (Post-Calibration) | Weighted (/50) |
|---------|----------------------|----------------|
| Che Andrade | 91/100 | 45.5 |
| Alessia Berry | 94/100 | 47.0 |
| Nicholas Chabot | 100/100 | 50.0 |
| Leo Chan | 95/100 | 47.5 |
| Matthew D'Addio | 78/100 | 39.0 |
| Lauren de los Reyes | 68/100 | 34.0 |
| Daniel Lianric Distor | 100/100 | 50.0 |
| Brandon Dong | 98/100 | 49.0 |
| Chelsea Huang | 93/100 | 46.5 |
| Dhwani Jain | 100/100 | 50.0 |
| Yubin Joe | 93/100 | 46.5 |
| Lillian Labra | 81/100 | 40.5 |
| Anders Lodin | 89/100 | 44.5 |
| Rachel McDonald | 83/100 | 41.5 |
| Quinnlan Medak | 100/100 | 50.0 |
| Eliza Okome | 77/100 | 38.5 |
| Jaden Path | 97/100 | 48.5 |
| Nadia Quek | 94/100 | 47.0 |
| Sydney Ransel | 99/100 | 49.5 |
| Aaron Schoolcraft | 97/100 | 48.5 |
| Victor Sofelkanik | 77/100 | 38.5 |
| Emma Sprankle | 94/100 | 47.0 |
| Eric Timberlake | 94/100 | 47.0 |
| Justin Wang | 78/100 | 39.0 |
| Beckett Yee | 100/100 | 50.0 |

---

## Student Feedback

### Che Andrade — 45.5 / 50
You did well on the SQL throughout. Your CASE WHEN and window function work was correct in the WHO and WHEN sections, and you correctly identified Dorm students and the Afternoon time period as the key drivers. Two areas to work on: in Part 1, include the actual monthly counts and percentage change alongside the raw difference, and calculate the 83.3% attribution figure when identifying Dorm students as the driver (20 out of 24 = 83.3%). Your synthesis recommendation about afternoon promotions was on the right track. For the prediction, put a specific number on it next time (e.g., "recovering half of the 26 lost afternoon orders = ~13 orders/month").

---

### Alessia Berry — 47.0 / 50
You did well here. Your CASE WHEN and window function work was correct throughout, and your synthesis was one of the stronger ones I read. You pulled all three findings together into a clear story. Two things to tighten up: double-check your segment counts against the actual query output, and when you identify Dorm students as the driver, calculate their share of the total decline (20 out of 24 = 83.3%). That number makes your argument land harder.

---

### Nicholas Chabot — 50.0 / 50
Highest raw score in the class (99/100 before calibration). Your SQL was clean across the board, and your synthesis tied together the what/who/when with actual numbers and the 83.3% calculation. The one small thing: your prediction could use a specific numeric target (e.g., "recovering X orders would mean Y% improvement"). But that's a minor note on an otherwise very well-done quiz.

---

### Leo Chan — 47.5 / 50
I liked that you went beyond the requirements and pulled in the promo code data to connect declining promotions with the afternoon order drop. That kind of curiosity is exactly what diagnostic analytics is about. Two things to work on: include the actual order counts (137, 113) when you write up your insights, and make sure the numbers you reference in your write-up match what your query actually returns.

---

### Matthew D'Addio — 39.0 / 50
The big issue was Part 1, where you calculated order value (revenue) instead of order count. That cost you points on descriptive analytics. Your WHO and WHEN diagnostic queries were much better and earned near-full marks. In the synthesis, your recommendation was too vague ("we need more analysis" isn't actionable), and the numbers you cited didn't match your earlier results. When you write the final story, go back to your actual query output and pull the numbers directly.

---

### Lauren de los Reyes — 34.0 / 50
The main thing that hurt your score was missing SQL queries in the descriptive and WHO sections. You wrote good insights, but without the supporting queries, there's no way to verify the work or award full credit. Your WHEN query was solid, and you correctly identified Dorm students as the driver with the 83.3% math. Going forward, always include your SQL, even if you're not 100% confident it's right. The query itself earns points for approach and logic. Your score also received a calibration review for some scoring inconsistencies; the net effect was the class-wide prediction adjustment only.

---

### Daniel Lianric Distor — 50.0 / 50
Really well done. Your SQL was clean, and I appreciated that you included revenue alongside order counts to give a fuller picture. The synthesis connected all three findings, and your recommendation about investigating class schedules and campus events showed you were thinking about the "why" behind the data, not just the "what." The only small note: put a number on your prediction next time (e.g., "recovering half of the 26 lost afternoon orders = ~13 orders/month").

---

### Brandon Dong — 49.0 / 50
Your SQL was on point across the board. Full marks on descriptive analytics and both diagnostic sections. Where you lost a point was the synthesis: your recommendation suggested promo codes for all segments, but your own data showed Dorm students in the Afternoon were the specific problem. Let the data drive the recommendation. If your analysis narrows to a specific group and time period, your recommendation should too.

---

### Chelsea Huang — 46.5 / 50
You identified all the right findings and your synthesis pulled them together well with a targeted afternoon promotion recommendation. One recurring SQL issue: in several queries, your YEAR(order_date) conditions were incomplete (missing the `= 2026` comparison). Your WHERE clause date range filtering saved you, but that's the kind of bug that could break a query in a different context. Worth being careful about.

---

### Dhwani Jain — 50.0 / 50
Your LAG and CASE WHEN work was clean throughout, and you nailed the diagnostic sections. Two small things that didn't cost you much here but are worth noting: calculate the 83.3% attribution when you identify Dorm students as the driver (20 out of 24 orders), and put actual numbers on your prediction so it's testable. Both are habits that make your analysis more useful to decision-makers.

---

### Yubin Joe — 46.5 / 50
You earned full marks on descriptive analytics and the WHEN diagnostic. Your LAG setup and time period bucketing were both correct. Where you lost points: the synthesis needed the 83.3% calculation (Dorm students accounted for 20 of the 24 lost orders), and your prediction needed specific numbers. Something like "recovering half of the 26 lost afternoon orders = ~13 extra orders/month" gives the business team a concrete target. Also, small thing: your ORDER BY referenced month 4 instead of month 5.

---

### Lillian Labra — 40.5 / 50
Your descriptive analytics and WHEN queries were well done. The WHO diagnostic is where things got off track. You interpreted negative order changes as segments "improving," which flipped the analysis. In the synthesis, you didn't mention the WHEN finding (Afternoon), and the recommendation didn't connect back to what your data actually showed. The fix for next time: after running each query, pause and ask "what does this tell me about the business question?" before writing your insight.

---

### Anders Lodin — 44.5 / 50
Your SQL skills are clearly there. The descriptive and WHO diagnostic sections were well done, and you used LAG and window functions correctly. The WHEN section is where you lost points: you ran the query but didn't explicitly state which time period had the biggest decline. In the synthesis, the percentage calculation was incomplete and you didn't mention the timing dimension at all. Make sure your written analysis covers every dimension the question asks about, even when your SQL already has the answer.

---

### Rachel McDonald — 41.5 / 50
Your LAG and conditional aggregation work was correct. In the WHO section, you needed total and percentage columns to compare segments properly, and the key calculation was what share of the total 24-order decline each segment represented. In your synthesis, you confused a segment's internal percentage decline with its share of the overall decline. Those are different things, and the question was asking for the latter. Your recommendation about Off-Campus students was a creative angle, though.

---

### Quinnlan Medak — 50.0 / 50
Well done. You connected all three findings in the synthesis with clear reasoning and the 83.3% calculation. Your SQL was correct throughout. Two small notes for future work: watch for spelling typos in your write-ups (I noticed a couple), and try to put specific numbers on your predictions so they're testable. Neither cost you much here, but they matter in professional deliverables.

---

### Eliza Okome — 38.5 / 50
Your descriptive and WHO sections were in good shape. The issue was in the WHEN diagnostic: your query combined May and June totals together instead of separating them by month, which led you to identify Morning as the biggest decline when it was actually Afternoon. That error carried into the synthesis, where the WHEN finding was missing. For queries that compare two time periods, make sure you have separate columns (or rows) for each period so you can see the change clearly.

---

### Jaden Path — 48.5 / 50
Your CASE WHEN work was clean across the board, and you correctly identified Dorm students and the Afternoon time period. Two things to add next time: in Part 1, include the actual monthly counts (137 and 113) and the percentage change (-17.5%) in your write-up, not just the direction of the trend. And put a number on your prediction. The summer food pass idea was a smart recommendation, though.

---

### Nadia Quek — 47.0 / 50
Full marks on descriptive and WHO. In the WHEN section, your BETWEEN boundaries in the CASE statement may have missed the 5pm hour (BETWEEN 12 AND 16 caps at 4pm, so orders at hour 17 could fall into the wrong bucket). Check your boundary conditions on CASE WHEN with BETWEEN. Your synthesis was well organized and the afternoon promotion recommendation was on target.

---

### Sydney Ransel — 49.5 / 50
Nearly flawless. Your SQL was clean, both diagnostic sections earned full marks, and the synthesis showed good analytical thinking. I liked that you suggested both a quick fix and a deeper root cause investigation. The half-point deductions were for the descriptive insight (include the raw order counts, not just the trend direction) and the prediction (add a specific number). Minor stuff on a very well-done quiz.

---

### Aaron Schoolcraft — 48.5 / 50
Your SUM(CASE WHEN) approach worked well throughout, and the WHEN diagnostic earned full marks. The "Happy Hour" recommendation was specific and tied directly to your findings. Three things to sharpen: in Part 1, state the actual counts (137 and 113) and percentage change (-17.5%); in Part 2, calculate 83.3% when attributing the decline to Dorm students; and in the prediction, give a specific number (e.g., "recovering half of the 26 lost orders = ~13/month").

---

### Victor Sofelkanik — 38.5 / 50
You started well. The descriptive analytics section earned full marks, and your three-month LAG context was a nice touch. The WHO diagnostic was also solid. The problem came in the WHEN query: a misplaced parenthesis in your MONTH() function caused a syntax error, which meant no results. That cascaded into the synthesis, which was mostly left blank. Your score includes individual calibration adjustments (+3 on results, +3 on synthesis) since the syntax error created a domino effect on sections that depend on WHEN output. For next time: always run your query before submitting to catch syntax issues.

---

### Emma Sprankle — 47.0 / 50
Full marks on descriptive analytics, and your synthesis correctly calculated the 83.3% attribution. You used both LAG and CASE WHEN approaches across different sections, which was good to see. Two things: double-check your segment counts (Off-Campus and Greek Life changes were slightly off from the expected values), and narrow your recommendation to the Afternoon time period specifically, since that's where your data showed the problem.

---

### Eric Timberlake — 47.0 / 50
Your CASE WHEN work was correct and your results were accurate across the descriptive and WHEN sections. In the WHO section, you needed to calculate what share of the total decline Dorm students represented (20/24 = 83.3%). Your synthesis had the right math and was well organized. One thing to watch: you wrote "form students" instead of "dorm students" in one spot. Small typos like that can undercut an otherwise good analysis.

---

### Justin Wang — 39.0 / 50
Your descriptive analytics and WHEN queries were well done, with correct LAG usage and time period bucketing. The big issue was the WHO section: you wrote insights about the segments but didn't include the SQL query that produced those numbers. Without the query, we can't award credit for approach or results. In the synthesis, try connecting your findings into a narrative rather than listing them as separate bullet points. The scenario-based recommendation was a good idea.

---

### Beckett Yee — 50.0 / 50
Your LAG and CASE WHEN work was correct throughout. The synthesis was one of the better ones I read. You connected all three dimensions into a clear story and made a specific prediction about returning to May performance levels. Two small notes for future reference: include raw order counts (not just percentages) in Part 1, and calculate the 83.3% attribution in Part 2. Neither cost you here after calibration, but both are good habits for professional analytics work.
