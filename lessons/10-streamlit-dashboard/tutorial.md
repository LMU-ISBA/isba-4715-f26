# Lesson 10: Streamlit Dashboard Tutorial

This is the written companion to Lesson 10. The lesson runs in one class session plus two take-home Parts that feed into Milestone 02:

- **In-class (Wed Apr 29):** Build and deploy a Streamlit dashboard against your basket_craft Snowflake mart. Steps 00–07. Goal: leave class with a public Streamlit Community Cloud URL.
- **Take-home (Apr 29 → May 6):** Extend the same dashboard for Maya (Head of Merchandising, the stakeholder you designed the mart for in MP02). Then produce your portfolio pipeline diagram. Steps 08–10.

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
| 08 | [Design Maya's dashboard](#step-08-design-mayas-dashboard) | Brainstorm a merchandising dashboard with Superpowers |
| 09 | [Build and deploy Maya's dashboard](#step-09-build-and-deploy-mayas-dashboard) | Extend the in-class app, redeploy |
| 10 | [Whiteboard your pipeline](#step-10-whiteboard-your-pipeline) | M02 #9 portfolio pipeline diagram |

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

## Part 04: Build Maya's Dashboard

> Stay in the same `basket-craft-dashboard` repo. The take-home extends the in-class work for a different stakeholder.
>
> **What changed since class:** the in-class dashboard targeted a marketing-style stakeholder — KPIs, customer segments, the kind of view a CMO or growth lead would want. Maya, the Head of Merchandising you designed the dbt mart for in MP02 Step 25, has different questions. Same data, different stakeholder, different chart choices. That switch is the design moment.

### Step 08: Design Maya's Dashboard

In MP02 Step 25, the dbt mart you built was designed around Maya's questions:

- Which products drove the most revenue each month last quarter?
- Which products get bought together most often? Should we create bundles?
- Which products have the highest refund rates? Are we pricing or describing anything wrong?
- Do new customers buy different products than customers who've been with us for a while?

The mart was built to answer those. Now you build the dashboard.

**What to do:**

1. In Claude Code, trigger the brainstorming skill:

   ```
   I want to extend my basket-craft-dashboard for Maya, the Head of Merchandising at Basket Craft. In MP02 we designed the dbt mart around her questions about product revenue, product bundles, refund rates, and new vs. returning buying patterns. Help me design a dashboard that answers her questions.
   ```

2. Let the chain drive. A good brainstorm should help you decide:

   - Which 3–4 KPIs fit Maya's job (likely product- and revenue-mix focused, not customer-count focused)
   - A descriptive view of product performance over time
   - A diagnostic view explaining the descriptive trend (product mix shifts? refund spikes? cohort buying differences?)
   - What Maya can *do* with the dashboard (export a list of high-refund products to investigate? flag products to bundle?)

3. When the brainstorm settles, the chain transitions into `writing-plans`. Follow the prompts. Commit the resulting plan to your repo (`docs/maya-dashboard-plan.md` is a reasonable home).

**Common scope traps to avoid:**

- **Treating Maya like a marketing stakeholder.** She's not asking about RFM segments or customer churn — she's asking about product performance. Different questions, different charts.
- **Kitchen-sink dashboard.** Eight charts, five filters. Three to four well-chosen sections beat eight scattered ones.
- **"I'll figure out the diagnostic later."** Decide the diagnostic cut *during* the brainstorm. It's the part students underspecify.

**Checkpoint:** Plan committed naming each chart, the Maya question it answers, and the data it pulls from.

---

### Step 09: Build and Deploy Maya's Dashboard

Execute the plan from Step 08. Same Streamlit patterns from in-class; new charts focused on Maya's questions.

**What to do:**

1. Stay in the same Claude Code session. After `writing-plans`, the chain transitions into `executing-plans`. Follow the prompts.

2. Decide whether you're replacing the in-class marketing dashboard or adding Maya's view alongside it. The simplest path: add a stakeholder selector at the top (`Marketing` / `Maya`) that switches what the page shows. Either way is fine for the take-home.

3. At each `executing-plans` checkpoint, spot-check two things:
   - Does the chart match what your mart actually contains? (Column-name mismatches are the most common bug. `dim_products` and `fct_order_items` come into play more here than they did in-class.)
   - Does the chart answer Maya's question, or did it drift toward a marketing-style cut during implementation?

4. Push to GitHub. Streamlit Cloud auto-redeploys on every push, so your existing public URL now serves Maya's dashboard.

**Iterative use evidence.** Like the wiki rubric in Lesson 09, your dashboard's quality benefits from visible iteration. A dashboard pushed once and never touched looks like an afterthought. Five commits over a week (adding a chart, fixing a column, refining a segment) looks like real work. Plan to revisit at least once between class and the May 6 deadline.

**Checkpoint:** Same Streamlit Cloud URL now serves Maya's dashboard (or both), README documents what the dashboard answers, commit history shows iterative refinement.

---

## Part 05: Whiteboard Your Pipeline

> Switch to your portfolio repo. This Step is the M02 #9 pipeline diagram, which lives in your portfolio README.

### Step 10: Whiteboard Your Pipeline

The diagram you draw here is the M02 #9 pipeline diagram for your portfolio project. The "whiteboard" framing means: draw it as if from memory, in front of an interviewer. Your final interview on May 11 includes a whiteboard walkthrough — this is your practice.

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

LE10 produces deliverables in two repos. Submit your `basket-craft-dashboard` repo URL and your Streamlit Cloud URL on Brightspace.

### `basket-craft-dashboard` repo (in-class Steps 00–07 plus take-home Steps 08–09)

Should contain:
- The Streamlit app with both the in-class marketing dashboard and Maya's merchandising dashboard
- `requirements.txt` with pinned package versions
- `.gitignore` excluding the secrets file
- `README.md` with the live Streamlit Cloud URL pinned at the top
- `docs/maya-dashboard-plan.md` — the brainstorm-and-plan output from Step 08

Must NOT contain:
- The Streamlit secrets file — must be gitignored, no Snowflake credentials in git history. If you accidentally committed it, rotate the Snowflake password immediately and scrub history.

### Portfolio project repo (Step 10)

Step 10's pipeline diagram lives in your portfolio repo `README.md`. It satisfies the M02 #9 deliverable (due Mon May 4), so you're already submitting your portfolio repo URL for M02 — no separate Brightspace submission for Step 10.
