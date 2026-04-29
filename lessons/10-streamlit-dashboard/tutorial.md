# Lesson 10: Streamlit Dashboard Tutorial

This is the written companion to Lesson 10. The lesson runs in one class session plus two take-home Parts that feed into Milestone 02:

- **In-class (Wed Apr 29):** Build and deploy a Streamlit dashboard against your basket_craft Snowflake mart. Steps 00–07. Goal: leave class with a public Streamlit Community Cloud URL.
- **Take-home (Apr 29 → May 6):** Apply the pattern to your portfolio repo, then produce your pipeline diagram. Steps 08–10.

**Before class.** Confirm your MP02 Snowflake account is still active and your basket_craft star schema is still in the `analytics` schema. Log into Snowsight the night before and run a quick `SELECT` on your customer dimension to verify.

**If you run short.** Step 02 (working Snowflake connection) is non-negotiable in class. The chart Steps and the deploy Step can finish at home; the tutorial is written to be self-paceable.

**You don't run terminal commands yourself.** Throughout this tutorial, you'll ask Claude Code to do things. Claude Code handles the venv, the install, the git commits, the `streamlit run` — everything. You describe what you want; the agent runs it.

## Table of Contents

### In-class (Wed Apr 29)

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 00 | [Create repo and start Claude Code](#step-00-create-repo-and-start-claude-code) | Repo, environment, sign up for Streamlit Community Cloud |
| 01 | [Configure Snowflake secrets](#step-01-configure-snowflake-secrets) | Set up where the app reads your credentials |
| 02 | [Connect to Snowflake](#step-02-connect-to-snowflake) | Prove the connection works |
| 03 | [Descriptive: KPI scorecards](#step-03-descriptive-kpi-scorecards) | Headline metrics with month-over-month change |
| 04 | [Descriptive: Revenue trend](#step-04-descriptive-revenue-trend) | Trend over time with a date filter |
| 05 | [Diagnostic: RFM composition](#step-05-diagnostic-rfm-composition) | Revenue by customer segment |
| 06 | [Diagnostic and Act: Customer drill-down](#step-06-diagnostic-and-act-customer-drill-down) | Pick a segment, see the customers, export |
| 07 | [Deploy to Streamlit Community Cloud](#step-07-deploy-to-streamlit-community-cloud) | Public URL |

### Take-home (Apr 29 → May 6)

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 08 | [Design your portfolio dashboard](#step-08-design-your-portfolio-dashboard) | Brainstorm with Superpowers |
| 09 | [Build and deploy your portfolio dashboard](#step-09-build-and-deploy-your-portfolio-dashboard) | Satisfy M02 #7 minimums |
| 10 | [Whiteboard the pipeline](#step-10-whiteboard-the-pipeline) | M02 #9 pipeline diagram |

---

## Part 01: Setup

### Step 00: Create Repo and Start Claude Code

Same opening move as MP02 through MP04. New repo on GitHub, clone in Cursor, start Claude Code.

**What to do:**

1. Create a new public GitHub repo named `basket-craft-dashboard` with the Python `.gitignore` template.

2. Clone it into Cursor next to your other ISBA repos:

   ```
   ~/isba-4715/
   ├── basket-craft-pipeline/    <-- MP02
   ├── weather-api-pipeline/     <-- MP03
   ├── chipotle-scrape-pipeline/ <-- MP04
   └── basket-craft-dashboard/   <-- LE10
   ```

3. Open a terminal in Cursor and start Claude Code:

   ```bash
   claude
   ```

4. Get your environment ready. Paste this:

   ```
   Help me set up to build a Streamlit dashboard against my Snowflake mart. Get my Python environment ready and make sure I can connect to Snowflake from a Streamlit app.
   ```

   Claude Code handles the venv, the right Python version, package installs, and `requirements.txt` pinning. While it works, **sign up for Streamlit Community Cloud** at [streamlit.io/cloud](https://streamlit.io/cloud) using GitHub OAuth. Free tier is fine — unlimited public apps.

5. Lock down your secrets before any commit. Paste:

   ```
   Make sure my Snowflake credentials won't accidentally get committed to GitHub.
   ```

**Heads-up.** Streamlit's Snowflake helper does not yet support Python 3.12 or 3.13. If your machine is on a newer Python, Claude Code will install Python 3.11 with pyenv as part of the setup.

**Checkpoint:** Repo cloned, environment ready (Claude Code confirms it can run Python and has the right packages installed), signed in to Streamlit Community Cloud.

---

### Step 01: Configure Snowflake Secrets

The same Snowflake credentials from MP02 now live in a Streamlit-flavored secrets file.

**What to do:**

1. Paste this:

   ```
   Help me set up where Streamlit reads my Snowflake credentials. Use the same seven values from MP02 (account, user, password, role, warehouse, database, schema). I'll fill in the values.
   ```

2. Fill in the values from your MP02 `.env`. The keys map 1-to-1 with what your MP02 Python loader used.

3. Confirm nothing sensitive is staged:

   ```
   Check git status and stop me if my Snowflake credentials are anywhere in the output.
   ```

**Account format gotcha.** Your account identifier must use hyphens (`xy12345-abc6789`), not underscores. Same form your MP02 loader needed.

**Looking ahead.** Snowflake is rolling out mandatory MFA for password users in phases through August 2026. Password auth from Streamlit Cloud still works for the rest of the semester. After August, migrate to key-pair auth for any production use.

**Checkpoint:** Credentials file populated with all seven values, gitignored, not staged.

---

### Step 02: Connect to Snowflake

Prove the connection works before adding any charts.

**What to do:**

1. Paste this:

   ```
   Make a Streamlit app that connects to my Snowflake mart and shows a row count from my customer dimension as a smoke test. Cache the query so reruns are fast.
   ```

2. Ask Claude Code to run it:

   ```
   Run the dashboard.
   ```

   A browser tab opens at `localhost:8501` showing one number — your customer-dimension row count.

3. Click **Rerun** in the Streamlit menu (top-right). The first run took 2–5 seconds (Snowflake round-trip); the rerun is instant. That's caching.

**Why caching matters.** Every Streamlit interaction (slider, button, dropdown) re-runs your script top to bottom. Without caching, every interaction re-queries Snowflake. With caching, results are reused until inputs change. For a dashboard with four charts plus a filter, caching is the difference between snappy and sluggish.

**Troubleshooting.** If the app errors instead of showing the row count:
- Connection error → check the secrets file, account format must use hyphens
- Object doesn't exist → wrong database/schema/role, or the customer-dim table name Claude Code guessed doesn't match yours. Tell Claude Code your actual table name.

**Checkpoint:** `localhost:8501` shows your row count; rerun is instant.

---

## Part 02: Build the Dashboard

The dashboard has four sections, walking the analytical arc top to bottom: KPIs (what we're tracking) → trend (what happened) → composition (which segments explain it) → drill-down (who to act on). Same descriptive-then-diagnostic split the M02 rubric grades on.

### Step 03: Descriptive — KPI Scorecards

KPIs answer "where are we now?" in thirty seconds.

**What to do:**

1. Paste this:

   ```
   Add headline metrics to my dashboard: total revenue, total orders, average order value, and active customers. Each should show how it changed versus the prior month.
   ```

2. Ask Claude Code to rerun the dashboard. You should see four metric cards across the top, each with a number and a green or red delta percentage.

3. **If you hit errors,** the most common cause is column-name mismatch. MP02 had each student name their own mart. When Claude Code's first attempt errors, paste the error back and tell it the actual column or table name. Or have it run `dbt docs serve` against your MP02 project to see your canonical names.

**Why these four?** Every aggregate here is a function you've used since Lesson 01: `SUM`, `COUNT`, `COUNT(DISTINCT)`. Lesson 02 introduced the period-over-period framing — month-over-month deltas are the visual analog.

**Checkpoint:** Four metric cards visible with current values and MoM deltas.

---

### Step 04: Descriptive — Revenue Trend

The KPIs answered "where are we now?" The trend chart answers "how did we get here?"

**What to do:**

1. Paste this:

   ```
   Add a revenue trend over time to my dashboard, and let me filter the chart by date range.
   ```

2. Ask Claude Code to rerun. You should see a date filter in the sidebar and a line chart that responds when you change the dates.

3. Try it. Drag the start date forward by six months — the line chart updates. Drag it back. The KPIs above don't change; that's intentional.

**Why the date filter doesn't affect the KPIs.** KPIs answer "current state" (always the latest two months). The trend chart is for *exploring* time windows. Stable KPIs at the top, explorable charts below them, is a real production pattern.

**Checkpoint:** Sidebar date filter visible, line chart responds, KPIs unchanged.

---

### Step 05: Diagnostic — RFM Composition

Steps 03 and 04 showed *what*. Step 05 starts answering *why*.

**What to do:**

1. Paste this:

   ```
   Add an RFM composition view to my dashboard. Score customers using the same RFM approach from Lesson 03, group them into named segments (Champions, Loyal, At Risk, etc.), and show revenue by segment as a bar chart. Have it respect the date filter from the sidebar.
   ```

2. Ask Claude Code to rerun. You should see a bar chart with five segments along the x-axis, each bar's height representing total revenue from that segment.

3. Change the sidebar date range to a single year. The composition shifts — that's the diagnostic story. A revenue dip in Step 04 might come from losing Champions, or from a drop in the Promising tier; the bar chart shows which.

**Why compute RFM in the dashboard query, not in dbt?** A production team would pre-compute RFM in a dbt mart so multiple dashboards could reuse it. We compute it inline here for two reasons: your MP02 mart doesn't have an RFM model, and seeing the RFM logic appear in the dashboard SQL reinforces what you learned in L03.

**Checkpoint:** Bar chart renders, segments sort in priority order, date filter changes the bars.

---

### Step 06: Diagnostic and Act — Customer Drill-Down

The bar chart answered "which segment?" This Step answers "which *customers* in that segment?" That progression — aggregate first, drill into specifics second — is the Act step from DC ACT.

**What to do:**

1. Paste this:

   ```
   Add a customer drill-down to my dashboard. Let me pick an RFM segment and see the customers in it with their names and emails. Make the list downloadable.
   ```

2. Ask Claude Code to rerun. You should see a segment dropdown, a table of customers in the selected segment, and a way to download the list.

3. Try the act flow. Pick a segment — the table re-renders. Hover over the table, click the download icon (top-right), and you get a CSV. That CSV is what a marketer would hand to email-campaign tooling.

**Recognize the pattern?** L03 ended at the same place: rank customers by RFM, JOIN to the user table for names and emails so marketing could actually run a campaign. The dashboard reproduces that arc — bar chart for the analytical view, table for the actionable one.

**Checkpoint:** Segment dropdown changes the table, sorted by monetary descending, CSV download works.

---

## Part 03: Ship It

### Step 07: Deploy to Streamlit Community Cloud

The dashboard runs locally. Now you push it to a public URL.

**What to do:**

1. Lock in your package versions and push to GitHub. Paste this:

   ```
   Lock in my package versions, then commit and push my dashboard to GitHub. Stop me if my Snowflake credentials are about to be committed.
   ```

2. Open [streamlit.io/cloud](https://streamlit.io/cloud) → **New app** → select your `basket-craft-dashboard` repo, branch `main`. Streamlit Cloud will detect the main app file automatically.

3. Click **Advanced settings** and paste the entire contents of your local Streamlit secrets file into the **Secrets** box (including the `[connections.snowflake]` header). The local file stays gitignored; the cloud-side text box stores the same values in Streamlit's encrypted backend.

4. Click **Deploy**. The first build takes 60–90 seconds. Watch the log; failures show up there.

5. Once live, test every interactive element: date filter, segment dropdown, CSV download. Then ask Claude Code to pin the URL to your README:

   ```
   Add my live Streamlit Cloud URL to the top of README.md, then commit and push.
   ```

**Common failures:**

| Symptom | Fix |
|---|---|
| `ModuleNotFoundError` on build | Missing or mispinned package in `requirements.txt` |
| `Could not find connection` | `[connections.snowflake]` header missing in Cloud Secrets |
| Snowflake auth error | Account format (hyphens, not underscores), wrong password, or wrong role |
| Object doesn't exist | Wrong database, schema, or role in Cloud Secrets |
| Build hangs > 3 min on first deploy | Normal; click "Manage app" to watch the live log |

**Checkpoint:** Public Streamlit URL renders all four sections, every interactive element works, README links to the live URL.

---

## Part 04: Replicate the Pattern in Your Portfolio Repo

> Switch to your portfolio repo (open it in a new Cursor window if you don't already have one).
>
> **What changed since class:** in-class, we picked the chart types for you. In Part 04, you pick yours. The question your stakeholder is actually asking should drive what charts you build, not the other way around.

### Step 08: Design Your Portfolio Dashboard

You just built a dashboard from a recipe. Now you design one from a question. Same Superpowers chain you used in Lesson 09 Session 02 for your knowledge-base wiki.

**What to do:**

Make sure `docs/job-posting.pdf` is in your portfolio repo before you start.

1. Open Claude Code in your portfolio repo and trigger the brainstorming skill:

   ```
   I want to build a Streamlit dashboard against my Snowflake mart. The dashboard should answer the analytics-related questions implied by the role in @docs/job-posting.pdf. Help me design it.
   ```

2. Let the chain drive. A good brainstorm should help you decide:

   - The headline question your stakeholder is asking
   - 3–4 KPIs that fit that question
   - One descriptive view (what's happening over time)
   - One diagnostic view (why)
   - What the user can *do* with the dashboard (the Act step)

3. When the brainstorm settles, the chain transitions into `writing-plans`. Follow the prompts. Commit the resulting plan to your repo (`docs/dashboard-plan.md` is a reasonable home).

**Common scope traps to avoid:**

- **Kitchen-sink dashboard.** Eight charts, five filters. Three to four well-chosen sections beat eight scattered ones.
- **Descriptive-only.** All trend charts, no diagnostic cut. Fails the M02 #7 rubric and leaves the obvious "why" question unanswered.
- **"I'll figure out the diagnostic later."** Decide the diagnostic cut *during* the brainstorm. It's the part students underspecify.

**Checkpoint:** Plan committed to your portfolio repo, names each chart and the question it answers, addresses the M02 #7 minimums.

---

### Step 09: Build and Deploy Your Portfolio Dashboard

Execute the plan from Step 08 against your own mart.

**What to do:**

1. Stay in the same Claude Code session. After `writing-plans`, the chain transitions into `executing-plans`. Follow the prompts.

2. At the start, ask Claude Code to set up your portfolio repo for Streamlit:

   ```
   Set up this portfolio repo to build a Streamlit dashboard against my Snowflake mart. Use the same secrets pattern from the basket_craft demo. Make sure my Snowflake credentials won't be committed.
   ```

3. At each `executing-plans` checkpoint, spot-check two things:
   - Does the chart match what your mart actually contains? (Column-name mismatches are the most common bug.)
   - Does the chart answer the question the plan said it would? (Easy to drift during implementation.)

4. Deploy to Streamlit Community Cloud using the Step 07 flow. Add the live URL to your portfolio README.

**M02 #7 minimums to satisfy:**

- [ ] Connected to Snowflake mart tables
- [ ] At least one descriptive analytics view
- [ ] At least one diagnostic analytics view
- [ ] At least one interactive element
- [ ] Deployed to Streamlit Community Cloud with public URL

**Iterative use evidence.** Like the wiki rubric in Lesson 09, your dashboard's quality benefits from visible iteration. A dashboard pushed once and never touched looks like an afterthought. Five commits over a week (adding a chart, fixing a column, refining a segment) looks like real work. Plan to revisit at least once between class and the M02 deadline.

**Checkpoint:** Portfolio dashboard URL is live, README links to it, all five M02 #7 minimums satisfied, commit history shows iterative refinement.

---

## Part 05: Whiteboard the Pipeline

### Step 10: Whiteboard the Pipeline

The diagram you draw here is the M02 #9 pipeline diagram. The "whiteboard" framing means: draw it as if from memory, in front of an interviewer. Your final interview on May 11 includes a whiteboard walkthrough — this is your practice.

**What to do:**

1. Pick a format: Mermaid (lives in your README), draw.io, Excalidraw, or hand-drawn photo. Any open format works for the rubric.

2. Draw both data paths your portfolio repo supports:

   - **Structured path:** API source → GitHub Actions → Snowflake raw → dbt staging → dbt mart → Streamlit dashboard
   - **Knowledge base path:** Web scrape → GitHub Actions → `knowledge/raw/` → Claude Code → `knowledge/wiki/`

3. Label every tool. No unnamed boxes. "Cloud database" is not a label; "Snowflake" is.

4. Embed the diagram in your portfolio `README.md`.

5. Pair with a classmate. Walk each other through your pipeline out loud, no notes. Then read each other's diagrams cold and identify what's missing. The questions a classmate asks are the ones a hiring manager will ask.

**What makes a good pipeline diagram:**

- Single page or single screen scroll
- Every layer labeled with the tool that produced it
- Arrows, not lines (data flow direction unambiguous)
- No mystery boxes; if a non-engineer can't tell what something is, label it more specifically

**Checkpoint:** Pipeline diagram in your portfolio README, every layer labeled with a specific tool, at least one classmate has reviewed it.

---

## Submission

LE10 produces deliverables in two repos. Submit your `basket-craft-dashboard` repo URL and your Streamlit Cloud URL on Brightspace. Portfolio repo work counts toward Milestone 02 (May 4) and Final Submission (May 11), not toward LE10 directly.

### `basket-craft-dashboard` repo (in-class, Steps 00–07)

Should contain:
- The Streamlit app with all four dashboard sections
- `requirements.txt` with pinned package versions
- `.gitignore` excluding the secrets file
- `README.md` with the live Streamlit Cloud URL pinned at the top

Must NOT contain:
- The Streamlit secrets file — must be gitignored, no Snowflake credentials in git history. If you accidentally committed it, rotate the Snowflake password immediately and scrub history.

### Portfolio project repo (take-home, Steps 08–10)

Take-home work feeds Milestone 02 (due Mon May 4):
- Streamlit dashboard against your portfolio mart, deployed to Community Cloud (M02 #7)
- Pipeline diagram in your `README.md` (M02 #9)
- Plan from Step 08 committed somewhere in the repo (e.g., `docs/dashboard-plan.md`)

You're already submitting your portfolio repo URL for M02 on May 4; no separate Brightspace submission for the take-home portion of LE10.
