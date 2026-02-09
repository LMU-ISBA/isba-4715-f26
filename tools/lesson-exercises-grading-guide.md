# Lesson exercises grading guide

Credit/no credit grading for lesson exercise submissions. The bar is **earnest effort**, not correctness.

## What to evaluate

For each student submission, check the following:

### 1. SQL queries written

Did the student write actual SQL queries for each part of the worksheet? Look for:

- **Parts 1 through the final numbered part**: Every section should have at least an attempted query
- Syntax errors and wrong answers are fine — the point is that they tried
- Blank sections (no query at all) are the red flag

### 2. Answer blanks filled in

Did the student fill in the `ANSWER: _____________` lines with values from their query results?

- Many students run queries in their IDE and see results visually but skip copying values back into the comment blanks. This is a common formatting habit, not a content gap.
- Unfilled blanks alone are **not** grounds for no credit, as long as the corresponding queries are present
- Filled blanks with reasonable values show extra diligence

### 3. Written analysis section (YOUR ANALYSIS)

Did the student complete the narrative section at the end? Check for:

- "What happened?" — some description of the trend
- "Who drove it?" — identifies the relevant segment
- "Why?" — it's acceptable (and actually good thinking) if they write "???" or "we don't know" when the data doesn't definitively explain root cause
- Insight statement — a sentence summarizing findings
- Recommendation — some actionable suggestion

A blank written analysis section is a stronger signal of incomplete effort than blank answer lines.

### 4. On Your Own challenges

Did the student attempt the challenge problems?

- These are labeled as independent practice but are part of the assignment
- At least 2 out of 3 challenges attempted shows solid effort
- Skipping all challenges combined with other gaps is a concern

## Grading decision

### Credit

The student attempted all (or nearly all) sections with SQL queries **and** completed the written analysis. Errors, incorrect answers, and syntax mistakes are all fine. The question is: did they sit down and work through the material?

### No credit

The student left large portions of the assignment blank. Specifically:

- Multiple entire parts with no queries written
- No written analysis section
- Missing both queries and challenges across several sections

A student who attempted Parts 1–3 but left Parts 4+ and the written analysis completely blank has not demonstrated earnest effort across the full assignment.

## Progress reporting

Show progress as each student is evaluated so the instructor can follow along:

- After each student is assessed, report their name and credit/no credit result immediately
- Show a running count (e.g., "8/25 complete")
- Flag any no-credit students as soon as they're identified — don't wait until the end

## Output format

Write a `grading-summary.md` file in the submission download directory with:

1. A table of all students with credit/no credit designation
2. Brief standout notes per student (what they did well, notable errors worth mentioning)
3. Any students flagged as no credit with a specific reason
4. A "patterns worth noting" section with common errors or trends useful for class feedback
5. An "LMS feedback to post" section with ready-to-paste messages for two groups:
   - **Exceptional students**: A short, specific message recognizing what they did well. Call out the particular thing that stood out (e.g., an advanced technique, thorough analysis, creative challenge question). Each student gets their own personalized message.
   - **Weakest students (still credited)**: A short, specific warning message noting what was missing and that future submissions with similar gaps may not receive credit. Each student gets their own personalized message.
   - **No credit students**: A short message explaining why they did not receive credit and what to do differently next time.
   - All feedback messages must be run through /humanizer before inclusion in the summary

## Common patterns from Lesson 01 (for reference)

- Many students answered "Why?" with "???" — this is correct analytical thinking, not laziness
- Common logic error: using `AND` instead of `OR` for compound conditions spanning both ends of a range (e.g., `hour < 6 AND hour >= 22` is impossible)
- About half the class left answer blanks unfilled despite having correct queries
- Students who submitted multiple times generally improved between submissions
