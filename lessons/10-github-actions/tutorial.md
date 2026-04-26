# Lesson 10: Schedule the Pipeline with GitHub Actions Tutorial

This tutorial takes the Basket Craft pipeline you built in MP02 and runs it on a GitHub Actions schedule. You will push your local secrets to GitHub, write one workflow file that runs the loader and then dbt, trigger it manually to confirm it works, and then add a weekly cron schedule. By the end you will have a green run in the **Actions** tab and a pattern you can lift directly into your portfolio project.

## Table of Contents

### Part 1: Wire MP02 to GitHub Actions (~50 min)

| Step | Topic | What You Will Do |
|------|-------|------------------|
| 01 | [Confirm starting state](#step-01-confirm-starting-state) | Verify MP02 runs locally and is pushed to GitHub |
| 02 | [Push secrets to GitHub](#step-02-push-secrets-to-github) | Use `gh secret set` to upload every value from `.env` |
| 03 | [Write the workflow file](#step-03-write-the-workflow-file) | Create `.github/workflows/pipeline.yml` with manual trigger only |
| 04 | [Trigger the manual run](#step-04-trigger-the-manual-run) | Click "Run workflow" and watch the logs |
| 05 | [Debug and verify in Snowflake](#step-05-debug-and-verify-in-snowflake) | Read failure logs, fix, and confirm new rows appear |
| 06 | [Add the cron schedule](#step-06-add-the-cron-schedule) | Switch from manual-only to weekly automation |

### Part 2: Apply to Your Portfolio (~10 min)

| Step | Topic | What You Will Do |
|------|-------|------------------|
| 07 | [Copy the pattern to your portfolio](#step-07-copy-the-pattern-to-your-portfolio) | Add a workflow file for your API or scrape pipeline |

## Part 1: Wire MP02 to GitHub Actions

### Step 01: Confirm starting state

Before you wrap your pipeline in a workflow, the pipeline has to work. The runner is just a fresh Ubuntu VM running the same commands you run locally — if they fail on your laptop, they will fail on the runner.

**What to do:**

1. Open your `basket-craft-pipeline` repo from MP02 in Cursor and open Claude Code.
2. Ask Claude Code to verify the starting state:

   ```
   Verify that this MP02 repo is ready to wrap in GitHub Actions:
   - Confirm `.env` exists locally with RDS_* and SNOWFLAKE_* values
   - Confirm `requirements.txt` includes snowflake-connector-python and dbt-snowflake
   - Run the loader script and report whether it succeeds
   - Run `dbt debug`, `dbt run`, and `dbt test` from the basket_craft/ folder and report whether they succeed
   - Confirm the repo is pushed to GitHub and `gh repo view --web` opens it
   Do not change anything yet. Just report.
   ```

3. Fix anything that fails before moving on.

**Why this matters:** The most common GitHub Actions failure is a workflow that runs commands that were already broken locally. A clean local run is your baseline.

**Checkpoint:** Claude Code reports loader, `dbt run`, and `dbt test` all succeed locally, and the repo exists on GitHub.

### Step 02: Push secrets to GitHub

GitHub Actions runners do not have your `.env` file. You need to upload every value from `.env` to the repo's encrypted secrets store. The `gh` CLI reads `.env` and uploads each line in one shot.

**What to do:**

1. Ask Claude Code to push every secret:

   ```
   Read my .env file in this repo and use `gh secret set` to upload every key/value
   pair as a GitHub Actions secret on this repo. Skip any blank lines and comments.
   When done, run `gh secret list` and show me the result so I can confirm all
   12 secrets (RDS_HOST, RDS_PORT, RDS_USER, RDS_PASSWORD, RDS_DATABASE,
   SNOWFLAKE_ACCOUNT, SNOWFLAKE_USER, SNOWFLAKE_PASSWORD, SNOWFLAKE_ROLE,
   SNOWFLAKE_WAREHOUSE, SNOWFLAKE_DATABASE, SNOWFLAKE_SCHEMA) are present.
   ```

2. Confirm the count matches what is in your `.env`.

**Why this matters:** Secrets are write-only after upload — GitHub will not show them to you again, and they are masked in workflow logs. This is the right place for credentials. Never paste them into the YAML file.

**Checkpoint:** `gh secret list` shows every variable from your `.env`. The names exactly match the keys in your `.env` file.

### Step 03: Write the workflow file

Now write the YAML that tells GitHub when to run the pipeline and what to run. Start with **manual trigger only** so you can test on demand. Add the schedule later, after the manual run is green.

**What to do:**

1. Ask Claude Code to scaffold the workflow:

   ```
   Create `.github/workflows/pipeline.yml` for this repo with:

   - Trigger: workflow_dispatch only (no schedule yet)
   - One job called `run-pipeline` on ubuntu-latest
   - Steps:
       1. actions/checkout@v4
       2. actions/setup-python@v5 with python-version 3.11
       3. pip install -r requirements.txt
       4. Run my loader script (the one that reads RDS and writes to Snowflake raw)
       5. Generate a minimal profiles.yml in the basket_craft/ folder using
          env_var() calls so DBT_PROFILES_DIR=. picks it up
       6. cd basket_craft/ && dbt deps (if packages.yml exists), dbt run, dbt test
   - Inject every secret from `gh secret list` into the job's env: block so both
     the loader script and dbt can read them via os.environ / env_var()
   - Set DBT_PROFILES_DIR: . at the job level

   Show me the full file before writing it.
   ```

2. Read the file Claude generated. Check that:
   - Every secret your loader and dbt need appears in the `env:` block as `${{ secrets.NAME }}`
   - The `profiles.yml` it generates uses `env_var('SNOWFLAKE_ACCOUNT')` etc., not hardcoded values
   - The dbt steps `cd` into the right folder
3. Commit and push:

   ```
   Stage `.github/workflows/pipeline.yml`, commit with message
   "Add GitHub Actions workflow for the Basket Craft pipeline", and push.
   ```

**Why this matters:** Manual-trigger-first is the discipline that saves you hours. Cron only fires on its schedule, so a broken cron-only workflow makes you wait an hour to see the next attempt. `workflow_dispatch` runs whenever you click the button.

**Checkpoint:** `.github/workflows/pipeline.yml` exists in your repo on GitHub. Open the **Actions** tab and you see your workflow listed in the left sidebar.

### Step 04: Trigger the manual run

The "Run workflow" button is the moment of truth — your pipeline runs on someone else's computer for the first time.

**What to do:**

1. Ask Claude Code to trigger the run from the terminal so you do not have to leave your editor:

   ```
   Run `gh workflow run pipeline.yml` to trigger a manual run, wait a few seconds,
   then run `gh run list --workflow=pipeline.yml --limit 1` to show the run id and status.
   Then run `gh run watch <id>` so I can see the output stream live.
   ```

2. Watch the steps execute. Each one prints to the log as it runs.

**Why this matters:** Watching the first run live teaches you the shape of a GitHub Actions log. Future failures will be easier to read because you have seen what success looks like.

**Checkpoint:** The run finishes with a green checkmark and `dbt test` reports passing tests. If anything is red, go to Step 05.

### Step 05: Debug and verify in Snowflake

Most first runs fail. The two common failures: a missing secret (the loader crashes with `KeyError`) or a wrong path (dbt cannot find `profiles.yml` or the project folder). Both show up clearly in the logs.

**What to do:**

1. If the run failed, ask Claude Code to read the logs and propose a fix:

   ```
   Run `gh run view --log-failed` to get the failed step's log. Identify the
   root cause. Propose the smallest fix to the workflow file or the loader and
   wait for me to approve before changing anything.
   ```

2. After applying the fix, push the change. Each push does not auto-trigger this workflow (we set it to manual only), so re-trigger with `gh workflow run pipeline.yml`.
3. Once green, verify the data actually landed:

   ```
   Connect to Snowflake via Claude Code (using my .env locally) and run:
   - SELECT MAX(loaded_at) FROM raw.<table_name> for each raw table
   - SELECT COUNT(*) FROM analytics.fct_order_items
   Confirm the timestamps are within the last few minutes (proof the runner wrote them, not me).
   ```

**Why this matters:** A green checkmark in the Actions tab tells you the script exited cleanly, not that the data is correct. Verifying in Snowflake closes the loop.

**Checkpoint:** Snowflake `raw` tables show fresh `loaded_at` timestamps from the runner, and the mart tables count matches your local `dbt run` from Step 01.

### Step 06: Add the cron schedule

Now that you trust the manual run, automate it. A weekly schedule is plenty for a portfolio project — daily would burn Snowflake credits without adding signal.

**What to do:**

1. Ask Claude Code to add the schedule:

   ```
   Edit `.github/workflows/pipeline.yml` to add a `schedule:` trigger alongside
   the existing workflow_dispatch. Run every Monday at 14:00 UTC (cron
   "0 14 * * 1"). Keep workflow_dispatch so I can still trigger manually for
   testing. Show me the diff, then commit and push with message
   "Schedule pipeline to run weekly on Mondays".
   ```

2. In the Actions tab, click your workflow on the left, then **... → View workflow runs** to see future scheduled runs queued.

**Why this matters:** The grader looks at the Actions tab to confirm the pipeline runs on its own. A `cron:` line plus visible scheduled runs is the evidence.

**Checkpoint:** Your workflow file has both `workflow_dispatch:` and `schedule:` under `on:`, and a fresh manual trigger is still green.

## Part 2: Apply to Your Portfolio

### Step 07: Copy the pattern to your portfolio

The same workflow shape works for your portfolio API pipeline and your scrape pipeline. Different `run:` line, same `env:`, `setup-python`, and trigger blocks.

**What to do:**

1. In your portfolio repo, ask Claude Code:

   ```
   I have a working `.github/workflows/pipeline.yml` in my MP02 repo at
   <path or URL>. Copy that pattern into this portfolio repo as
   `.github/workflows/api-extract.yml`. The differences:
   - The `run:` step calls my API extract script (the one that loads to
     Snowflake raw)
   - The env: block uses only the secrets the API extract needs (Snowflake
     credentials plus my API key)
   - Trigger: workflow_dispatch + cron "0 14 * * 1"
   - No dbt step in this workflow (we will add a separate transform workflow later)

   Then run `gh secret set` for any new secrets this script needs that are not
   already in `gh secret list` for this repo.
   ```

2. Trigger it manually with `gh workflow run api-extract.yml` and verify Snowflake updates.
3. Repeat for your scrape pipeline as `scrape-extract.yml`.

**Why this matters:** Milestone 02 requires both extraction pipelines automated on a schedule. Doing the MP02 workflow first means you lift a working pattern instead of writing from scratch under deadline pressure.

**Checkpoint:** Your portfolio repo has at least one workflow file with a green manual run that produced rows in Snowflake. You have a clear path to a second one for your other source.

## Submission

Push your updated `basket-craft-pipeline` repo to GitHub and submit the repo link. Your repo should contain:
- The same MP02 contents you submitted previously (loader script, `basket_craft/` dbt project, `requirements.txt`, `.gitignore`, `CLAUDE.md`)
- A new `.github/workflows/pipeline.yml` with both `workflow_dispatch:` and `schedule:` triggers
- At least one green run visible in the **Actions** tab, executed by the GitHub Actions bot (not by `workflow_dispatch` from you, ideally — wait for the cron to fire once, or trigger manually if you are tight on time)

You should also commit at least one workflow file to your portfolio repo before Milestone 02 closes. You will not be graded on that here, but you will be graded on it there.
