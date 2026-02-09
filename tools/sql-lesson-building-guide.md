# SQL Lesson Building Guide

How to create student worksheets and instructor answer keys for ISBA 4715 SQL lessons. This guide was extracted from the patterns established in Lessons 01, 02, and 03.

---

## Table of Contents

1. [Lesson Design Philosophy](#1-lesson-design-philosophy)
2. [The Narrative Arc](#2-the-narrative-arc)
3. [Student Worksheet Template](#3-student-worksheet-template)
4. [Instructor Answer Key Template](#4-instructor-answer-key-template)
5. [Progressive Query Scaffolding](#5-progressive-query-scaffolding)
6. [Exercise Design Patterns](#6-exercise-design-patterns)
7. [SQL Style Guide](#7-sql-style-guide)
8. [Concept Progression Across Lessons](#8-concept-progression-across-lessons)
9. [Supporting Files](#9-supporting-files)
10. [Checklist](#10-checklist)

---

## 1. Lesson Design Philosophy

Each lesson follows a **business case investigation**. Students are data analysts solving a real business problem or opportunity. The SQL concepts are tools they need to answer the question, not abstract skills to practice.

### Core Principles

- **Story first, SQL second.** Every query answers a business question. Students should know *why* they're writing a query before *how*.
- **Spiral curriculum.** Concepts appear as Review → Reinforce → NEW. Students see familiar patterns in new contexts before encountering unfamiliar ones.
- **Progressive scaffolding.** Complex queries are built up step-by-step in the answer key so the instructor can walk students through the reasoning, not just show the final answer.
- **The analytical framework is constant.** Every lesson follows the same diagnostic structure: What happened? → Who drove it? → Why? → Confirm the connection. The SQL tools change; the thinking doesn't.
- **Natural motivation for new concepts.** New SQL features should be introduced at the moment students *need* them, not before. Example: JOINs are introduced in Lesson 03 only after students hit "The Wall" — they have user_ids but need names and emails.

### Lesson Structure at a Glance

```
Part 1:  Explore / Establish baselines (Review concepts)
Part 2:  First analytical question (Review + Reinforce)
Part 3:  Second analytical question (Reinforce + NEW)
Part 4:  Third analytical question (NEW concepts)
Part 5:  Confirm the connection (Apply NEW concepts)
Part 6:  Student synthesis — insight statement + recommendation
On Your Own: Challenge problems for independent practice
```

---

## 2. The Narrative Arc

Every lesson tells a story with a satisfying conclusion. The instructor should know this story before class.

### Answer Key Header: THE HIDDEN STORY

At the top of every answer key, include a block that tells the instructor the full story arc:

```sql
-- THE HIDDEN STORY:
-- [One paragraph describing the setup, turning point, and resolution]
--
-- KEY DISCOVERY PATH:
-- 1. Descriptive: [What the data shows on the surface]
-- 2. Diagnostic - WHO: [Which segment/group drove it]
-- 3. Diagnostic - WHY: [The root cause]
-- 4. Confirm: [The smoking gun query that ties it all together]
```

**Examples from existing lessons:**

| Lesson | Business Question | Hidden Story |
|--------|------------------|--------------|
| 01 | "Why did orders DROP?" | Late-night delivery was cut; Grad Students (the primary late-night customers) stopped ordering |
| 02 | "Why did revenue GROW?" | A promo code "STUDYGRIND" went viral among Dorm students during finals, driving afternoon orders |
| 03 | "Who are our BEST customers?" | RFM reveals 339 high-value customers, but you can't email them without JOINs; 98% are one-time buyers (retention opportunity) |

### The Analytical Framework

Each lesson follows the same pattern, reinforcing the diagnostic thinking process:

```
DESCRIPTIVE:  What happened?      → Trends, baselines, anomalies
DIAGNOSTIC:   WHO drove it?       → Segment comparison
DIAGNOSTIC:   WHY did it happen?  → Behavioral analysis
CONFIRM:      Is our story right? → Intersection query (the smoking gun)
SYNTHESIZE:   So what?            → Insight statement + recommendation
```

The categories in Part headers should use these labels when applicable:
- `DESCRIPTIVE ANALYTICS` (what happened?)
- `DIAGNOSTIC ANALYTICS` (who/why/when?)
- `CONFIRM THE CONNECTION` (the proof)
- `YOUR ANALYSIS` (student synthesis)

---

## 3. Student Worksheet Template

### File Naming

```
lesson-XX-fname-lname.sql
```

Students download this file, rename it with their name, and open it in DBeaver.

### Required Sections (in order)

#### 1. Header Block

```sql
-- ============================================================================
-- LESSON XX: [Title]
-- ============================================================================
--
-- SCENARIO: [Business context. Who are you? What's the situation?]
--
-- YOUR MISSION: [One sentence: what students will accomplish]
--
-- NOTE: [Database connection details if different from previous lessons]
--
-- ============================================================================
-- WHAT WE'LL COVER
-- ============================================================================
-- | Concept                  | Status     | Used In    |
-- |--------------------------|------------|------------|
-- | [Concept 1]              | Review     | Parts X-Y  |
-- | [Concept 2]              | Reinforce  | Part Z     |
-- | [Concept 3]              | NEW        | Part W     |
-- ============================================================================
```

**Status values and what they mean:**
- `Review` — Students have used this concept in a previous lesson and should be comfortable with it.
- `Reinforce` — Students have seen this concept before but will use it in a new context or at a higher level.
- `NEW` — First time encountering this concept. Requires instructor walkthrough.

#### 2. Syntax Box (for NEW concepts only)

Place a syntax box immediately before the first exercise that uses a NEW concept. This gives students a reference to consult while writing their query.

```sql
-- ============================================================================
-- [SECTION TITLE]
-- ============================================================================
-- [Plain-English explanation of the concept]
--
-- Syntax:
--   [The pattern students will use, with placeholders]
--
-- [Additional notes, gotchas, or examples if needed]
-- ============================================================================
```

**Rules for syntax boxes:**
- Only include for NEW concepts, not Review or Reinforce.
- Show the *pattern*, not a complete solution. Students should adapt it.
- If the concept has a "gotcha" (e.g., Recency is inverted in RFM), include a note.

#### 3. Exercise Blocks

```sql
-- X.Y [Exercise Title]
-- [Instructions — what to calculate or explore]
-- [Context — why this matters for the business question]
-- HINT: [One-line SQL hint if needed]
--
-- ANSWER: [Blank for student] _____________
-- ANSWER: [Additional blank] _____________
```

**Exercise numbering:** `Part.Exercise` (e.g., 2.1, 2.2, 3.1)

**Hint philosophy:**
- Part 1 exercises: More hints (students are warming up, possibly new database).
- Parts 2-3: Moderate hints. Reference syntax boxes or previous exercises.
- Parts 4-5: Minimal hints. Students should be applying patterns they've learned.
- "On Your Own" challenges: No hints or only a HINT line.

**Hint reduction across exercises:**
- First time using a pattern: Show the full pattern in a syntax box + hint.
- Second time: Reference the previous exercise ("Use the same pattern from 2.1b").
- Third time: No hint. Students should be able to do it.

#### 4. Transition Blocks (between Parts)

Use decorative comment blocks to signal major transitions. Students should see why they're moving to the next section.

```sql
-- ============================================================================
-- THE PROBLEM
-- ============================================================================
-- [Why the current approach isn't enough]
-- [What new tool/concept will solve it]
-- ============================================================================
```

This is especially important when introducing NEW concepts. The transition should make students *want* the new tool.

#### 5. YOUR ANALYSIS Section

```sql
-- ============================================================================
-- PART 6: YOUR ANALYSIS
-- ============================================================================

-- THE COMPLETE STORY:
-- 1. [First analytical question from the lesson]
--    ANSWER: _______________________________________________________________
--
-- [Repeat for each major finding]

-- YOUR INSIGHT STATEMENT:
-- [Instruction for format, e.g., "Write a single sentence using:
--  [WHO] + [DID WHAT] + [BY HOW MUCH] + [WHY]"]
--
-- ANSWER: __________________________________________________________________

-- YOUR RECOMMENDATION:
-- [Prompt for business action]
--
-- ANSWER: __________________________________________________________________
```

#### 6. COMPARING LESSONS Section (Lesson 02+)

```sql
-- ============================================================================
-- COMPARING THE [N] LESSONS
-- ============================================================================
-- | Lesson    | Question                      | Key Tool      |
-- |-----------|-------------------------------|---------------|
-- | Lesson 01 | "Why did orders DROP?"        | CASE WHEN     |
-- | Lesson 02 | "Why did revenue GROW?"       | Pivot + %     |
-- | Lesson XX | "[New question]"              | [New tools]   |
--
-- What's the SAME analytical approach across all lessons?
-- ANSWER: __________________________________________________________________
--
-- What's NEW about this lesson's approach?
-- ANSWER: __________________________________________________________________
```

#### 7. ON YOUR OWN Section

```sql
-- ============================================================================
-- ON YOUR OWN
-- ============================================================================

-- Challenge 1: [Descriptive Title]
-- [Instructions]
--
-- ANSWER: _____________

-- Challenge 2: [Descriptive Title]
-- [Instructions, possibly with HINT]
--
-- ANSWER: _____________

-- Challenge 3: Your Own Analysis
-- Write one or more queries that answer a business question you're curious about.
-- YOUR QUESTION: ___________________________________________________________

-- INSIGHT STATEMENT: _______________________________________________________
```

Always include a "Your Own Analysis" challenge as the last one.

#### 8. SQL CONCEPTS COVERED Footer

```sql
-- ============================================================================
-- SQL CONCEPTS COVERED
-- ============================================================================
-- Review: [list]
-- Reinforced: [concept] for [context]
-- NEW: [concept] — [one-line description]
--
-- KEY PATTERNS LEARNED:
-- * [Pattern Name]: [Brief description of the pattern]
-- ============================================================================
--
-- KEY TAKEAWAY: [One sentence connecting the SQL to the business insight]
-- ============================================================================
```

---

## 4. Instructor Answer Key Template

### File Naming

```
lesson-XX-key.sql
```

This file is gitignored (`lesson-*-key.*`). It contains everything the instructor needs to teach the lesson.

### What the Answer Key Must Include

1. **Everything from the student worksheet** — all instructional text, syntax boxes, exercise instructions, answer blanks, and hints. The instructor should see exactly what students see.

2. **Correct SQL queries** — runnable solutions for every exercise.

3. **Expected results** — formatted as markdown tables in comments.

4. **Instructor guidance markers** — teaching notes throughout, using these markers:
   - `🎓 KEY POINT:` — Important teaching moment to highlight aloud.
   - `🎓 TRANSITION:` — Narrative bridge to the next exercise or section.
   - `🎓 COMMON ISSUE:` — Anticipated student error and how to address it.
   - `🎓 ASK:` — Discussion prompt to pose to the class.
   - `🎓 INSTRUCTOR:` — Setup note (e.g., "Remind students to use the new database").
   - `🎓 NOTE:` — Additional context the instructor should know.
   - `🎓 HAVE STUDENTS WRITE DOWN` — Information students will need later.

5. **Progressive build-up steps** — For any exercise where the final query is not a trivial extension of a previous exercise, include STEP 1 → STEP 2 → ... → Complete solution queries. See [Section 5](#5-progressive-query-scaffolding) below.

### Answer Key Header

```sql
-- ============================================================================
-- INSTRUCTOR ANSWER KEY — Lesson XX
-- [Full lesson title]
-- ============================================================================
--
-- [Same intro text as student worksheet]
--
-- THE HIDDEN STORY:
-- [Full story arc for the instructor]
--
-- KEY DISCOVERY PATH:
-- 1. [Step 1]
-- 2. [Step 2]
-- 3. [Step 3]
-- 4. [Step 4]
--
-- ============================================================================
```

### Date-Dependent Values

If queries use `CURDATE()` or other time-dependent functions, add a note at the top:

```sql
-- NOTE: Values marked with ~ are approximate and depend on CURDATE().
--       These answers are based on CURDATE() = 'YYYY-MM-DD'.
--       [Describe what changes over time and what stays stable.]
```

---

## 5. Progressive Query Scaffolding

This is the most important instructional technique in the answer key. Complex queries should never appear as "one-shot" solutions. Instead, build up to them step by step.

### When to Use Build-Up Steps

Add STEP-by-STEP scaffolding when an exercise involves:

- A **NEW concept** being used for the first time (e.g., DATEDIFF, CASE WHEN, JOIN, subquery).
- A **combination of two patterns** students haven't combined before.
- A query with **3+ new elements** (new function + GROUP BY + new WHERE logic).
- Any query where students are likely to get **stuck or overwhelmed**.

Do NOT add build-up steps for:
- Simple extensions of the previous exercise (e.g., "add GROUP BY customer_segment").
- Review queries students have written before.
- Exercises where the hint already provides enough guidance.

### The Build-Up Pattern

```sql
-- STEP 1: [Understand the new function/concept in isolation]
-- [One-sentence explanation of what this step demonstrates]
SELECT
    [new_function_or_concept],
    [supporting columns for context]
FROM [table]
[optional WHERE/LIMIT];

-- Expected: [What students should see and verify]


-- STEP 2: [Add one more element — combine with something familiar]
-- [One-sentence explanation]
SELECT
    [previous columns],
    [new element added]
FROM [table]
[WHERE/LIMIT];

-- Expected: [What changes from STEP 1]


-- STEP 3: [Complete solution OR add final element]
-- [One-sentence explanation]
SELECT
    [full query]
FROM [table]
[full WHERE/GROUP BY/ORDER BY];

-- Expected: [Full result set with answer]
```

### Step Design Principles

1. **Each step should be independently runnable.** Students can execute any STEP query and see meaningful output.

2. **Each step adds exactly one new thing.** Don't jump from raw data to the final aggregated query. Add one clause, one function, or one column at a time.

3. **Each step has an "Expected" comment.** Tell the instructor (and students) what they should see, so they can verify they're on track.

4. **Step comments explain the *why*, not just the *what*.** "Add GROUP BY to see the breakdown by segment" is better than "Add GROUP BY customer_segment."

5. **The transition between steps should be narrated.** Use comments like "Now that we can see the raw hours, let's classify them into time periods."

### Real Examples from Existing Lessons

**Lesson 01, Exercise 4.1 — Time of Day (4 steps, introducing CASE WHEN):**
```
STEP 1: Understand HOUR() → see raw hour values from order_time
STEP 2: Simple binary classification → just 'Daytime' / 'Nighttime' with CASE WHEN
STEP 3: Full 4-category classification → all time periods, WITHOUT aggregation
STEP 4: Complete solution → add GROUP BY and COUNT to answer the question
```

**Lesson 02, Exercise 4.2 — Promo by Segment (4 steps, combining patterns + window function):**
```
STEP 1: Count orders and promo orders by segment → basic SUM(CASE WHEN)
STEP 2: Add within-segment promo percentage → the percentage pattern
STEP 3: Introduce SUM() OVER() → see the grand total on every row
STEP 4: Complete solution → divide segment count by grand total for share
```

**Lesson 02, Exercise 5.1 — Confirm the Connection (4 steps, combining filter + classify + aggregate):**
```
STEP 1: Filter to Dorm students in May → confirm WHERE clause works
STEP 2: Add time period classification → see CASE WHEN labels on filtered data
STEP 3: Count orders by time period → aggregate without promo column
STEP 4: Complete solution → add promo_orders column to see the full picture
```

### How Many Steps?

- **2 steps:** When combining two familiar patterns for the first time.
- **3 steps:** When introducing one new concept that requires setup.
- **4 steps:** When introducing a new concept AND combining it with existing patterns.
- **5+ steps:** Rarely needed. If you need 5+ steps, consider splitting into two exercises.

---

## 6. Exercise Design Patterns

### Pattern: Explore → Aggregate → Compare → Confirm

This is the macro pattern across Parts. Each Part answers one layer of the diagnostic question.

```
Part 1: EXPLORE (What data do we have? What are the baselines?)
Part 2: AGGREGATE (What happened? Summarize by time/category.)
Part 3: COMPARE (WHO/WHEN — pivot or filter to isolate the driver.)
Part 4: DIAGNOSE (WHY — introduce the new concept that reveals the cause.)
Part 5: CONFIRM (Intersect the findings. The smoking gun.)
```

### Pattern: Build on Previous Query

Many exercises explicitly build on the previous one. Signal this in the instructions:

```sql
-- This builds on X.Y — [what to add/change]
-- HINT: [specific modification]
```

**Examples:**
- "This builds on 2.1b — add GROUP BY customer_segment to see each segment's pivot."
- "This builds on 4.0b — add GROUP BY month to see the trend over time."
- "This builds on 3.1b — add the order_change column to quantify growth."

### Pattern: Introduce Pattern First, Then Apply

When teaching a new SQL pattern:

1. **Intro exercise** — Teach the pattern in isolation with a simple query (no GROUP BY, no subquery). Number it with a letter suffix (e.g., 2.1b, 4.0b).
2. **Application exercise** — Apply the pattern to answer the actual business question (add GROUP BY, add filters, etc.).

This prevents students from learning a new pattern AND applying it simultaneously.

### Pattern: "The Wall" (Motivating a New Concept)

Before introducing a major new concept, create a moment where students feel the limitation of their current tools:

```
Exercise N: Get the answer using only what you know → works, but missing something
THE PROBLEM: [Why the answer isn't actionable without the new concept]
Exercise N+1: Solve it with the new concept → satisfying resolution
```

**Example from Lesson 03:** Students calculate RFM segments and find 339 best customers — but only have user_ids. "Can you email user_id 24741?" → No! → JOINs solve this.

### Pattern: Teaching Notes and Pattern Annotations

In the answer key, annotate where students are combining or extending patterns:

```sql
-- Teaching Note:
-- Pattern breakdown:
-- 1. [First pattern being used] — from [where they learned it]
-- 2. [Second pattern being used] — from [where they learned it]
-- 3. [What's new in this combination]
-- Next step: [How this query will be extended in the next exercise]
```

### Answer Format in Student Worksheet

Use answer blanks appropriate to the question type:

```sql
-- ANSWER: _________ orders                    -- (specific number)
-- ANSWER: Which month? _____________          -- (fill in the blank)
-- ANSWER: _________%                          -- (percentage)
-- ANSWER: $____________                       -- (dollar amount)

-- For markdown table answers:
-- ANSWER:
-- | Metric              | Value |
-- |---------------------|-------|
-- | Total Orders        |       |
-- | Total Revenue       | $     |

-- For yes/no with explanation:
-- ANSWER: Can you email them? _____________
```

### Expected Results in Answer Key

Always format expected results as markdown tables in SQL comments:

```sql
-- Expected:
-- | column_1 | column_2 | column_3 |
-- |----------|----------|----------|
-- | value    | value    | value    |
-- | value    | value    | value    |  <-- ANNOTATION if notable
```

Use `<--` arrows to draw attention to the key finding in the result set.

---

## 7. SQL Style Guide

These conventions ensure consistency across all lessons and match what students will see in industry.

### Formatting Rules

```sql
-- Major keywords on their own line:
SELECT
    column_1,
    column_2,
    column_3
FROM table_name
WHERE condition
GROUP BY
    column_1,
    column_2
ORDER BY
    column_1;
```

- 4-space indentation for columns, conditions, and expressions.
- Each column on its own line in multi-column SELECTs.
- Each expression on its own line in multi-expression GROUP BY and ORDER BY.
- CASE WHEN blocks indented with WHEN/THEN/ELSE/END aligned.

### Naming Rules

| Do | Don't |
|----|-------|
| `order_year` | `year` (reserved word) |
| `order_month` | `month` (reserved word) |
| `month_name` | `date` (reserved word) |
| `total_orders` | `count` (reserved word) |
| `avg_order_value` | `avg_value` (ambiguous) |

- Use descriptive prefixes to avoid reserved words.
- Use consistent naming: `total_X`, `avg_X`, `pct_X`, `num_X`.
- Table aliases: short, lowercase, obvious (e.g., `o` for orders, `u` for users, `p` for products, `oi` for order_items, `r` for refunds).

### Aggregate Functions

- Use `COUNT(column_name)` instead of `COUNT(*)` when counting a specific thing. This makes the intent clearer and avoids counting NULLs unexpectedly.
- Use `COUNT(DISTINCT column_name)` — note: DISTINCT is a keyword, not a function. No inner parentheses.
- Always `ROUND()` monetary values to 2 decimal places and percentages to 1-2.
- Use `100.0` (not `100`) when calculating percentages to force decimal division.

### Date Handling

- Use `CURDATE()` for "as of today" filters when the database extends into the future.
- Include `YEAR()` in GROUP BY when grouping by month, to avoid combining data across years.
- Use `BETWEEN` for date ranges: `WHERE order_date BETWEEN '2026-03-01' AND '2026-05-31'`
- Use `>=` and `<` (not BETWEEN) for time boundaries: `HOUR(order_time) >= 6 AND HOUR(order_time) < 12`

---

## 8. Concept Progression Across Lessons

Track the status of every SQL concept across lessons to maintain the spiral curriculum.

### Current Concept Map

| Concept | L01 | L02 | L03 | L04+ |
|---------|-----|-----|-----|------|
| SELECT, FROM, WHERE | Review | Review | Review | Review |
| COUNT, SUM, AVG, ROUND | Review | Review | Review | Review |
| GROUP BY, ORDER BY | Review | Review | Review | Review |
| LIMIT | Review | Review | Review | Review |
| COUNT(DISTINCT) | — | — | Review | Review |
| CASE WHEN | **NEW** | Reinforce | Reinforce | Review |
| LAG() window function | **NEW** | Reinforce | — | Review |
| SUM() OVER() window function | — | **NEW** | — | Reinforce |
| Date functions (MONTH, YEAR, MONTHNAME, HOUR) | **NEW** | Reinforce | Reinforce | Review |
| CURDATE(), DATEDIFF() | — | — | **NEW** | Reinforce |
| Subqueries (FROM subquery) | — | — | **NEW** | Reinforce |
| INNER JOIN ... ON | — | — | **NEW** | Reinforce |
| LEFT JOIN ... ON | — | — | **NEW** | Reinforce |
| IS NULL | — | — | **NEW** | Reinforce |
| Table aliases | — | — | **NEW** | Review |
| HAVING | — | — | — | ? |
| CTEs (WITH ... AS) | — | — | — | ? |
| Multiple JOINs in one query | — | — | **NEW** | Reinforce |

### Rules for Concept Progression

1. **NEW concepts get a syntax box** in the student worksheet, build-up steps in the answer key, and at least one exercise dedicated to them.
2. **Reinforced concepts get a reference** back to where they were introduced: "Use the same CASE WHEN pattern from Lesson 01."
3. **Review concepts get no special treatment.** Students are expected to use them fluently.
4. A concept should be **NEW in at most one lesson**. After that, it's Reinforce or Review.
5. **Introduce at most 3-4 NEW concepts per lesson.** More than that and students won't retain them.
6. When planning a new lesson, update this table to ensure concepts flow naturally.

---

## 9. Supporting Files

Each lesson folder should contain:

| File | Purpose | Audience |
|------|---------|----------|
| `README.md` | Lesson overview, learning objectives, database connection info, table descriptions | Students |
| `lesson-XX-fname-lname.sql` | Student worksheet (download link on README) | Students |
| `lesson-XX-key.sql` | Instructor answer key (gitignored) | Instructor |
| `INSTRUCTOR-answer-key.md` | Additional instructor notes if needed (gitignored) | Instructor |

### README.md Structure

```markdown
# Lesson XX: [Title]

## Learning Objectives
- [Objective 1]
- [Objective 2]

## The Scenario
[Business context paragraph]

## Files in This Lesson
| File | Description |
|------|-------------|
| [link] | SQL worksheet template |

## Prerequisites
- [What students need to know]

## Database Connection
| Field | Value |
|-------|-------|
| Host | db.isba.co |
| Port | 3306 |
| Database | **[database_name]** |
| Username | student |
| Password | learn_sql |

### Tables You'll Use
[Table descriptions with key columns]

## Key Concepts
[Concept explanations with tables/diagrams]

### The Lesson Flow
[ASCII flow diagram showing the lesson progression]
```

### .gitignore Patterns

These patterns protect instructor materials and student submissions:

```
lesson-*-key.*
INSTRUCTOR-*
submissions/
```

---

## 10. Checklist

Use this checklist when creating a new lesson.

### Planning Phase

- [ ] Identify the business question and "hidden story"
- [ ] Map the diagnostic path: What → Who → Why → Confirm
- [ ] List NEW concepts (max 3-4) and where they appear
- [ ] Update the concept progression table
- [ ] Identify which concepts are Review vs Reinforce
- [ ] Plan "The Wall" moment if introducing a major concept

### Student Worksheet

- [ ] Header: scenario, mission, WHAT WE'LL COVER table
- [ ] Syntax boxes for each NEW concept (placed before first use)
- [ ] Exercise numbering: Part.Exercise (1.1, 1.2, 2.1...)
- [ ] Hint reduction: more hints early, fewer late
- [ ] Answer blanks with appropriate format (___, $, %)
- [ ] PART headers with category labels
- [ ] Transition blocks between major sections
- [ ] YOUR ANALYSIS section with insight statement + recommendation
- [ ] COMPARING LESSONS table (Lesson 02+)
- [ ] ON YOUR OWN with at least one "Your Own Analysis" challenge
- [ ] SQL CONCEPTS COVERED footer with KEY PATTERNS and KEY TAKEAWAY
- [ ] All SQL follows the style guide (formatting, naming, aggregates)

### Instructor Answer Key

- [ ] THE HIDDEN STORY + KEY DISCOVERY PATH at top
- [ ] All student worksheet text included verbatim
- [ ] Correct SQL queries for every exercise
- [ ] Expected results as markdown tables
- [ ] Build-up steps for exercises with NEW concepts
- [ ] Build-up steps for exercises combining multiple patterns
- [ ] Each build-up step is independently runnable
- [ ] Each build-up step has an "Expected" comment
- [ ] `🎓 KEY POINT` markers for important teaching moments
- [ ] `🎓 TRANSITION` markers between sections
- [ ] `🎓 COMMON ISSUE` markers for anticipated errors
- [ ] `🎓 ASK` markers for discussion prompts
- [ ] `🎓 INSTRUCTOR` markers for setup notes
- [ ] Date-dependent value note at top if using CURDATE()

### Supporting Files

- [ ] README.md with objectives, scenario, database connection, tables
- [ ] Lesson flow diagram in README
- [ ] Files listed in README with download links
- [ ] Answer key is gitignored
- [ ] Database has been prepared (dates shifted if needed, data loaded)
