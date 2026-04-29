# Lesson 10: Streamlit Dashboard Tutorial

In-class today (Wed Apr 29): build and deploy a public Streamlit dashboard against your basket_craft Snowflake mart. Steps 00–06. Take-home by May 6: your portfolio pipeline diagram (Step 07).

**Before class:** confirm your MP02 Snowflake account is still active and you can query the basket_craft `analytics` schema. Throughout this tutorial you ask Claude Code to do things — it handles the venv, the installs, `git`, `streamlit run` — you describe what you want and the agent runs it.

## What is Streamlit?

[Streamlit](https://streamlit.io) is an open-source Python framework that turns a Python script into an interactive web app — no JavaScript, no separate front end, no templates. You write Python; Streamlit handles the HTML, widgets, and rendering. For data dashboards on top of a warehouse, it's the fastest path from a SQL query to something a stakeholder can click. Today you'll end up with a public URL anyone can visit, hosted on Streamlit Community Cloud (free tier), backed by your basket_craft mart in Snowflake.

## Table of Contents

### In-class (Wed Apr 29)

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 00 | [Set up the project](#step-00-set-up-the-project) | Repo, `.env` with Snowflake credentials, sign up for Streamlit Community Cloud |
| 01 | [Connect to Snowflake](#step-01-connect-to-snowflake) | Ask Claude Code to build the dashboard; verify the connection works |
| 02 | [Descriptive: KPI scorecards](#step-02-descriptive-kpi-scorecards) | Headline metrics with month-over-month change |
| 03 | [Descriptive: Revenue trend](#step-03-descriptive-revenue-trend) | Trend over time with a date filter |
| 04 | [Diagnostic: Top products by revenue](#step-04-diagnostic-top-products-by-revenue) | Which products are driving the numbers |
| 05 | [Diagnostic and Act: Bundle finder](#step-05-diagnostic-and-act-bundle-finder) | Pick a product, see what's bought with it |
| 06 | [Deploy to Streamlit Community Cloud](#step-06-deploy-to-streamlit-community-cloud) | Public URL |

### Take-home (Apr 29 → May 6)

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 07 | [Whiteboard your pipeline](#step-07-whiteboard-your-pipeline) | M02 #9 portfolio pipeline diagram |

---

## Part 01: Setup

### Step 00: Set Up the Project

Same opening move as MP02 through MP04. New repo on GitHub, clone in Cursor, drop your Snowflake credentials in `.env`, sign up for Streamlit Cloud. No Claude Code yet — that comes in Step 01.

**What to do:**

1. Go to [github.com/new](https://github.com/new) and create a new repository:

   - Name it `basket-craft-dashboard`
   - Set visibility to **Public**
   - Under **Add .gitignore**, select **Python** from the dropdown
   - Leave everything else as default
   - Click **Create repository**

2. Clone it into Cursor next to your other ISBA repos:

   ```
   ~/isba-4715/
   ├── basket-craft-pipeline/    <-- MP02
   ├── weather-api-pipeline/     <-- MP03
   ├── chipotle-scrape-pipeline/ <-- MP04
   └── basket-craft-dashboard/   <-- LE10
   ```

3. **Sign up for Streamlit Community Cloud** at [streamlit.io/cloud](https://streamlit.io/cloud) using GitHub OAuth. Free tier is fine — unlimited public apps. We deploy here in Step 06.

4. **Create a `.env` file** at the repo root with your Snowflake credentials. These are the same seven values from your MP02 `.env`. Open `~/isba-4715/basket-craft-pipeline/.env` for reference, or recreate from your MP02 setup:

   ```
   SNOWFLAKE_ACCOUNT=xy12345-abc6789
   SNOWFLAKE_USER=your_user
   SNOWFLAKE_PASSWORD=your_password
   SNOWFLAKE_ROLE=LOADER
   SNOWFLAKE_WAREHOUSE=BASKET_CRAFT_WH
   SNOWFLAKE_DATABASE=BASKET_CRAFT
   SNOWFLAKE_SCHEMA=ANALYTICS
   ```

   The Python `.gitignore` template you picked already excludes `.env`, so this file won't be committed. Verify with the file explorer in Cursor — `.env` should appear greyed out.

**Account format gotcha.** Your account identifier must use hyphens (`xy12345-abc6789`), not underscores. Same form your MP02 loader needed.

**Looking ahead.** Snowflake is rolling out mandatory MFA for password users in phases through August 2026. Password auth still works for the rest of the semester. After August, migrate to key-pair auth for any production use.

**Checkpoint:** Repo cloned, `.env` populated with all seven Snowflake values, signed in to Streamlit Community Cloud.

---

### Step 01: Connect to Snowflake

Now you start Claude Code and ask it to build the dashboard. The credentials in `.env` mean the agent has everything it needs to wire up the connection without asking.

**What to do:**

1. Open a terminal in Cursor and start Claude Code:

   ```bash
   claude
   ```

2. Paste this:

   ```
   Help me build a Streamlit dashboard against my Snowflake data warehouse. My credentials are in .env.
   ```

   That's the entire kickoff. Claude Code sets up the venv, installs Streamlit and the Snowflake packages, pins `requirements.txt`, writes the initial app file with a smoke-test query, and uses your `.env` values to connect.

3. When it's done, ask it to run the dashboard:

   ```
   Run the dashboard.
   ```

   Claude Code will print a local URL in the terminal output. Click it to open the dashboard. You should see one number — a row count from one of your dimension tables (Claude Code picks; the smoke test just proves the connection works).

4. Click **Rerun** in the Streamlit menu (top-right of the page). The first run took 2–5 seconds (Snowflake round-trip); the rerun is instant. That's caching kicking in.

**Why caching matters.** Every Streamlit interaction (slider, button, dropdown) re-runs your script top to bottom. Without caching, every interaction re-queries Snowflake. With caching, results are reused until inputs change. For a dashboard with four charts plus a filter, caching is the difference between snappy and sluggish.

**Heads-up on Python version.** `snowflake-snowpark-python` doesn't yet support Python 3.12 or 3.13. If your machine is on a newer Python, Claude Code will install Python 3.11 with pyenv as part of the setup.

**Troubleshooting.** If the app errors instead of showing a row count:
- Connection error → check `.env`, account format must use hyphens, no quotes around values
- Object doesn't exist → wrong database/schema/role in `.env`, or the table name Claude Code guessed doesn't match yours. Tell Claude Code your actual table name.

**Checkpoint:** the local Streamlit URL shows a row count; rerun is instant.

---

## Part 02: Build the Dashboard for Maya

Maya, the Head of Merchandising at Basket Craft, is your stakeholder. The dbt mart you built in MP02 Step 25 was designed around her questions:

- Which products drove the most revenue each month last quarter?
- Which products get bought together most often? Should we create bundles?
- Which products have the highest refund rates?
- Do new customers buy different products than customers who've been with us for a while?

The dashboard answers her first two questions directly. KPIs and trend chart give her the headline; the product bar chart shows what's selling; the bundle finder surfaces co-purchase patterns she can use to design bundles.

```
┌──────────────────────────────────────────────────────────────────────┐
│ Basket Craft — Merchandising Dashboard                               │
├──────────────┬───────────────────────────────────────────────────────┤
│              │ ┌──────────┬──────────┬──────────┬──────────┐         │
│  Date range  │ │ Revenue  │  Orders  │   AOV    │  Items   │ Step 02 │
│              │ │ $129K ▼2%│ 2,064 ▼2%│ $62  ▼1% │ 2,701 ▼5%│         │
│  ┌────────┐  │ └──────────┴──────────┴──────────┴──────────┘         │
│  │ start  │  │                                                       │
│  │ end    │  │ Revenue Trend                                  Step 03│
│  └────────┘  │     ╱╲    ╱╲╱╲                                        │
│              │    ╱  ╲  ╱    ╲      ╱╲                               │
│              │   ╱    ╲╱      ╲    ╱  ╲                              │
│              │  ╱                ╲╱    ╲                             │
│              │  2024              2025          2026                 │
│              │                                                       │
│              │ Top Products by Revenue                        Step 04│
│              │ ████████████████  The Original Gift Basket            │
│              │ █████             The Valentine's Gift Basket         │
│              │ ███               The Birthday Gift Basket            │
│              │ ██                The Holiday Gift Basket             │
│              │                                                       │
│              │ Bundle Finder: Bought With…                    Step 05│
│              │ Pick a product: ▾  The Original Gift Basket           │
│              │ ┌────────────────────────────┬──────────────┐         │
│              │ │ Also bought                │ # of orders  │         │
│              │ │ The Holiday Gift Basket    │ 3,142        │ ⬇ CSV   │
│              │ │ The Birthday Gift Basket   │ 2,036        │         │
│              │ │ The Valentine's Gift Basket│ 944          │         │
│              │ └────────────────────────────┴──────────────┘         │
└──────────────┴───────────────────────────────────────────────────────┘
```

**Reading top to bottom:** what's happening overall (KPIs) → how revenue moved over time (trend) → which products are driving it (top products) → which products go together (bundle finder). Descriptive at top, diagnostic in the middle, actionable at the bottom. The bundle finder is downloadable CSV; that's what Maya hands to a buyer to design promotions.

### Step 02: Descriptive — KPI Scorecards

KPIs answer "where are we now?" in thirty seconds — the headline numbers a Head of Merchandising scans before drilling into the rest.

**What to do:**

1. Paste this:

   ```
   Add headline metrics to my dashboard: total revenue, total orders, average order value, and total items sold. Each should show how it changed versus the prior month.
   ```

2. Ask Claude Code to rerun the dashboard. You should see four metric cards across the top, each with a number and a green or red delta percentage.

3. **If you hit errors,** the most common cause is column-name mismatch. MP02 had each student name their own mart. When Claude Code's first attempt errors, paste the error back and tell it the actual column or table name. Or have it run `dbt docs serve` against your MP02 project to see your canonical names.

**Why these four?** Revenue, orders, AOV, and items sold are the volume-and-value pair Maya scans first. Items Sold is line-item level (`fct_order_items`), distinct from order count — a customer who orders once with five items contributes one order but five items. Both numbers matter to a merchandising lead.

**Checkpoint:** Four metric cards visible with current values and MoM deltas.

---

### Step 03: Descriptive — Revenue Trend

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

### Step 04: Diagnostic — Top Products by Revenue

Steps 02 and 03 showed *what's happening*. Step 04 starts answering *which products are driving it* — Maya's first MP02 question.

**What to do:**

1. Paste this:

   ```
   Add a bar chart to my dashboard showing the top products by revenue. Have it respect the date filter from the sidebar.
   ```

2. Ask Claude Code to rerun. You should see a bar chart with product names along one axis and revenue along the other, sorted from highest to lowest.

3. Change the sidebar date range to a single quarter or year. The chart re-renders for that window. The relative ranking can shift meaningfully — that's the diagnostic story. A revenue dip in Step 03 might come from one product falling off; the bar chart shows which.

**About "top products."** Basket Craft's catalog has only four products, so "top products" effectively means all four sorted. If you applied this dashboard to a portfolio mart with hundreds of SKUs, you'd want to limit to the top 10 or 20 to keep the chart readable. Tell Claude Code the cut-off if your catalog is large.

**Checkpoint:** Bar chart of top 10 products by revenue renders below the line chart, sorted descending, the date filter changes the bars.

---

### Step 05: Diagnostic and Act — Bundle Finder

Maya's second MP02 question: "Which products get bought together most often? Should we create bundles?" The bundle finder answers it directly. Pick a product, see what shows up in the same orders.

**What to do:**

1. Paste this:

   ```
   Add a bundle finder to my dashboard. Let me pick any product, and show me the products that get bought together with it most often, ranked by how many orders contained both. Make the result downloadable.
   ```

2. Ask Claude Code to rerun. You should see a product dropdown, a table showing other products that appear in the same orders, and a way to download the list.

3. Try the act flow. Pick a product from the dropdown — the table re-renders showing what's bought with it. Hover over the table, click the download icon (top-right), and you get a CSV. That CSV is what Maya hands to a buyer to design a bundle promotion.

**The query underneath.** A product co-purchase view is a self-join: same fact table appears twice in the FROM, once for "the product I picked" and once for "everything else in the same order." Claude Code writes the self-join; you describe the question. If it errors on column names, paste the error back and tell it the right ones.

**Why a table instead of a chart?** Bundles are about specific product pairings, not a rank-ordered visual. Maya wants to see the names — "Gourmet Cheese Basket sells with Wine & Cheese Trio 412 times" is the actionable insight. A bar chart of co-purchase counts hides the names.

**Checkpoint:** Product dropdown changes the table, ranked by co-occurrence count, CSV download works.

---

## Part 03: Ship It

### Step 06: Deploy to Streamlit Community Cloud

The dashboard runs locally. Now you push it to a public URL.

**What to do:**

1. Lock in your package versions and push to GitHub. Paste this:

   ```
   Lock in my package versions, then commit and push my dashboard to GitHub. Stop me if .env is about to be committed.
   ```

2. Open [streamlit.io/cloud](https://streamlit.io/cloud) → **New app** → select your `basket-craft-dashboard` repo, branch `main`. Streamlit Cloud will detect the main app file automatically.

3. Click **Advanced settings**. The Secrets box wants TOML format — same seven values from your `.env`, but with quotes and an `=` with spaces. Paste:

   ```
   SNOWFLAKE_ACCOUNT = "xy12345-abc6789"
   SNOWFLAKE_USER = "your_user"
   SNOWFLAKE_PASSWORD = "your_password"
   SNOWFLAKE_ROLE = "LOADER"
   SNOWFLAKE_WAREHOUSE = "BASKET_CRAFT_WH"
   SNOWFLAKE_DATABASE = "BASKET_CRAFT"
   SNOWFLAKE_SCHEMA = "ANALYTICS"
   ```

   Or ask Claude Code to convert your `.env` for you:

   ```
   Convert my .env values to the TOML format Streamlit Cloud's Secrets box expects.
   ```

   Your local `.env` stays gitignored; the Cloud-side text box stores the same values in Streamlit's encrypted backend.

4. Click **Deploy**. The first build takes 60–90 seconds. Watch the log; failures show up there.

5. Once live, test every interactive element: date filter, product dropdown, CSV download. Then ask Claude Code to pin the URL to your README:

   ```
   Add my live Streamlit Cloud URL to the top of README.md, then commit and push.
   ```

**Common failures:**

| Symptom | Fix |
|---|---|
| `ModuleNotFoundError` on build | Missing or mispinned package in `requirements.txt` |
| Snowflake auth error | Account format (hyphens, not underscores), wrong password, or wrong role |
| Object doesn't exist | Wrong database, schema, or role in Cloud Secrets |
| Build hangs > 3 min on first deploy | Normal; click "Manage app" to watch the live log |

**Checkpoint:** Public Streamlit URL renders all four sections, every interactive element works, README links to the live URL.

---

## Part 04: Whiteboard Your Pipeline

> Switch to your portfolio repo. This Step is the M02 #9 pipeline diagram, which lives in your portfolio README.

### Step 07: Whiteboard Your Pipeline

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

Submit your `basket-craft-dashboard` repo URL and your Streamlit Cloud URL on Brightspace.

### `basket-craft-dashboard` repo (in-class, Steps 00–06)

Should contain:
- The Streamlit app with all four dashboard sections
- `requirements.txt` with pinned package versions
- `.gitignore` excluding `.env`
- `README.md` with the live Streamlit Cloud URL pinned at the top

Must NOT contain:
- `.env` — must be gitignored, no Snowflake credentials in git history. If you accidentally committed it, rotate the Snowflake password immediately and scrub history.

### Portfolio project repo (Step 07)

Step 07's pipeline diagram lives in your portfolio repo `README.md`. It satisfies the M02 #9 deliverable (due Mon May 4), so you're already submitting your portfolio repo URL for M02 — no separate Brightspace submission for Step 07.
