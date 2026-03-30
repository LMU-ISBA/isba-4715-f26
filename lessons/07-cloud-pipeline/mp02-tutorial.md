# Mini-Project 02: Cloud Extraction Pipeline Tutorial

This tutorial covers all three sessions of Mini-Project 02. If you fall behind during class, use this tutorial to catch up. Every command and prompt is written out so you can follow along on your own.

## Table of Contents

**Part 1: Extract and Load (Session 01)**

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 1 | [Create repo and start Claude Code](#step-1-create-github-repo-and-clone-into-cursor) | Set up the project repo, ensure Docker is running, start Claude Code |
| 2 | [Install Superpowers](#step-2-install-superpowers) | Add the Superpowers plugin to Claude Code |
| 3 | [Brainstorm the pipeline](#step-3-brainstorm-the-pipeline) | Design the pipeline with Superpowers brainstorming and an ASCII diagram |
| 4 | [Extract data from MySQL](#step-4-extract-data-from-mysql-rds) | Write a Python script to pull data from the cloud database |
| 5 | [Transform and load](#step-5-transform-and-load-into-local-postgresql) | Aggregate the data and load it into your local PostgreSQL |
| 6 | [Verify the data](#step-6-verify-the-loaded-data) | Check the results with psql, DBeaver, and Claude Code |

**Part 2: Cloud Data Warehouse (Session 02)** *(coming soon)*

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 7 | Set up AWS account and CLI | Configure AWS credentials through Claude Code |
| 8 | Extract from source RDS | Pull data from instructor's RDS using AWS tools |
| 9 | Load to Snowflake | Set up Snowflake account and load raw data |
| 10 | Introduction to dbt | Create a dbt project and understand project structure |

**Part 3: Dimensional Modeling (Session 03)** *(coming soon)*

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 11 | Build dbt staging models | Clean, rename, and type-cast raw data |
| 12 | Build dbt mart models | Create star schema with fact and dimension tables |
| 13 | Run dbt tests | Validate data quality |
| 14 | Review and submit | Review the full pipeline and push to GitHub |

---

## Part 1: Extract and Load (Session 01)

### Step 1: Create GitHub Repo and Clone into Cursor

In MP01, you built a project folder from scratch and added git later. This time you start the professional way: create the GitHub repository first, clone it to your machine, and then start building inside it.

**Why repo-first:** In professional work, you create the repository before writing any code so every change is tracked from the start. This is the workflow you will use for every project from now on.

You also need Docker running, since you will create a new local PostgreSQL container for this project.

**What to do:**

1. Go to [github.com/new](https://github.com/new) and create a new repository:
   - Name it `basket-craft-pipeline`
   - Set visibility to **Public**
   - Under **Add .gitignore**, select **Python** from the dropdown
   - Leave everything else as default (no README, no license)
   - Click **Create repository**

2. On your new repository's GitHub page, click the green **Code** button, make sure **HTTPS** is selected, and click the copy icon to copy the URL.

3. Clone the repo into Cursor. Open a new Cursor window and click **Clone repo** on the welcome screen. Paste the URL you just copied.

   If you do not see the welcome screen, you can also clone from the menu: **File > New Window**, then click **Clone repo**. Or use the command palette (Mac: `Cmd+Shift+P`, Windows: `Ctrl+Shift+P`) and search for "Git: Clone".

   When Cursor asks where to save it, navigate to your `isba-4715` folder inside your home directory (the same parent folder from MP01). Open the cloned folder when prompted.

   Your folder structure should now look like:
   ```
   ~/isba-4715/
   ├── campus-bites-pipeline/     <-- MP01
   └── basket-craft-pipeline/     <-- MP02 (this project)
   ```

4. Open a terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal** from the menu bar).

5. Make sure Docker Desktop is running. If you do not have Docker Desktop installed (maybe you skipped MP01 or uninstalled it), follow the installation instructions in [MP01 Step 3](../06-local-pipeline/mp01-tutorial.md#step-3-install-docker) before continuing. It takes about 5 minutes.

   Open Docker Desktop and check that it shows the green "running" indicator. You do not need your MP01 container for this project — this project will get its own fresh PostgreSQL container as part of the pipeline design in Step 3. If your MP01 container is currently running, stop it first (click Stop in Docker Desktop or run `docker stop campus_bites_db` in your terminal). Two PostgreSQL containers cannot use the same port at the same time, and both default to port 5432.

6. Start Claude Code:
   ```bash
   claude
   ```

**Checkpoint:** Your repo is cloned and open in Cursor. Docker Desktop is running. Claude Code is active in the terminal and waiting for input.

---

### Step 2: Install Superpowers

In MP01, you used Claude Code with basic prompts: "do this," "build that." You described what you wanted and it generated the code. That works well for straightforward tasks.

But when you are building a pipeline with multiple moving parts (a source database, extraction scripts, transformations, a destination database), it helps to think through the design before writing code. Superpowers is a plugin for Claude Code that adds structured workflows for exactly this. The main one you will use today is brainstorming, which walks you through a design conversation and produces a blueprint before any code gets written.

**What to do:**

1. In your Claude Code session, install the Superpowers plugin. Type:

   ```
   /plugin install superpowers@claude-plugins-official
   ```

   Follow the prompts to complete the installation.

2. Once installed, verify that it worked by typing `/super` in the Claude Code prompt. You should see autocomplete suggestions that include Superpowers commands like `/using-superpowers`. If you see them, the install worked.

**Why this matters:** Superpowers adds structured skills to Claude Code that activate automatically. When you describe something you want to build, Superpowers will recognize the situation and start a **brainstorming** conversation before jumping to code. You do not need to type a special command — just describe what you need and Claude Code will announce which skill it is using. The two main skills are:
- **Brainstorming** — Design before you build. Have a conversation about what you are trying to accomplish, and end up with a pipeline diagram and a plan. You will use this today.
- **Writing plans** — Break complex work into steps. You will learn this one in Sessions 02-03.

In MP01, you told Claude Code *what* to build. With Superpowers, it first discusses *what and why* with you, then builds. Over the next few sessions, you will learn progressively more structured ways to work with Claude Code. Each one builds on the last.

**Checkpoint:** Superpowers is installed. You see Superpowers commands in the autocomplete when you type `/super`.

---

### Step 3: Brainstorm the Pipeline

Before writing any code, you are going to design the pipeline. In MP01 Step 5, you let Claude Code ask you questions to explore the problem. That was freeform. This time, Superpowers will automatically activate its brainstorming skill when it sees you describing something you want to build. Instead of jumping to code, Claude Code will start a structured design conversation that produces a blueprint: a pipeline diagram and a plan for what to extract and how to transform it.

Here is the important part: **your design will probably look different from the instructor's and from your classmates'.** That is how real engineering works. Two people given the same business question will make different decisions about which tables to pull, how to aggregate, and how to structure the scripts. As long as your pipeline answers the business question, your design is valid.

**What to do:**

1. In Claude Code, type:

   ```
   I need to build a data pipeline. The Basket Craft team wants a
   monthly sales dashboard with revenue, order counts, and average
   order value by product category and month.

   Source: Basket Craft MySQL database.
   Destination: local PostgreSQL in Docker.

   Create an ASCII diagram of the pipeline, then help me plan
   the extraction and transformation.
   ```

   Claude Code will announce that it is using the brainstorming skill. This is Superpowers at work — it recognized that you are describing something you want to build and activated the right workflow automatically.

2. Claude Code will start a design conversation and ask about your setup. The brainstorm is a back-and-forth conversation, not a single prompt. Claude Code will ask you questions one at a time. Answer each one, and if it suggests something you do not understand, ask it to explain. A typical brainstorm takes 4-8 exchanges before producing the final diagram and plan.

   Be honest about your setup. If something from MP01 is broken or missing, tell the brainstorm. It will include fix-it steps in the pipeline design. That is one of the advantages of designing before building.

   Here is how to respond to common questions:

   - **When it asks about the source database:** Tell it the connection details you have been using all semester for the Basket Craft MySQL database. The credentials are the same ones from Lessons 01-05. The instructor will confirm these at the start of class.

   - **When it asks about the destination:** Tell it you need a local PostgreSQL database running in Docker for this project. The brainstorm will include a `docker-compose.yml` and container setup as part of the pipeline design. This is a new container separate from your MP01 project.

   - **When it asks about the transformation:** Explain that you need aggregated summary tables for a sales dashboard. Revenue, order counts, and average order value grouped by product category and month.

   - **When it asks about anything else:** Answer based on what you know. If you are unsure about something, say so. That is what the brainstorm is for.

3. At the end of the brainstorm, you should have:
   - An **ASCII diagram** of your pipeline (source -> extract -> transform -> load -> destination)
   - A **list of tables** you need to extract from the MySQL database
   - A **plan for aggregation** (what to group by, what to calculate)

   Review the brainstorm output critically. If the plan misses something (for example, it only extracts one table when you need data from both orders and products to get category information), push back: "I think we also need the products table to get category names. Can you update the plan?" The brainstorm is a conversation, and you can steer it.

4. If the brainstorm has not yet produced an ASCII pipeline diagram, ask for one:

   ```
   Create an ASCII diagram of the pipeline we just designed.
   ```

**Your design vs. the instructor's:** The instructor will show their pipeline design during class. Your design may extract different tables, aggregate in a different order, or structure the scripts differently. The grading criteria is not "does it match the instructor's approach" but "does it answer the business question: monthly revenue, order counts, and average order value by product category?"

**Why this matters:** In MP01, the tutorial told you exactly what to build. That was appropriate for learning the tools. Now you are learning a harder skill: deciding what to build. The brainstorming conversation is practice for the design thinking you will need for your independent project and for real engineering work after graduation.

**Checkpoint:** You have an ASCII pipeline diagram showing the flow from MySQL to local PostgreSQL. You have a plan for which tables to extract and how to aggregate them. You are ready to start building.

---

### Step 4: Extract Data from MySQL RDS

Your brainstorm produced a plan. Now you execute it. You can continue prompting Claude Code directly — the brainstorm context carries into the conversation, so it remembers the design you agreed on.

The first part of any ETL pipeline is extraction: pulling data from the source system. The source is the same Basket Craft MySQL database you queried in Lessons 01-05. The difference is that instead of writing SELECT queries in DBeaver, you are writing a Python script that connects to the remote database, runs queries, and saves the results.

**What to do:**

1. Set up a Python virtual environment for this project. Tell Claude Code:

   ```
   Create a Python virtual environment for this project.
   ```

   This isolates your project's Python packages so they do not conflict with other projects (same reason as MP01 Step 7). Claude Code will activate and use the virtual environment automatically when it runs scripts or installs packages. If Claude Code reports that Python is not installed, follow the installation prompts it provides. You need Python 3.9 or later.

2. Create a `.env` file in your project root. In Cursor, right-click the file explorer and select **New File**, name it `.env`, and paste the credentials block the instructor shares in Zoom chat / Teams. It should look something like:

   ```
   MYSQL_HOST=...
   MYSQL_PORT=3306
   MYSQL_USER=...
   MYSQL_PASSWORD=...
   MYSQL_DATABASE=basket_craft
   ```

   Confirm that `.env` is listed in your `.gitignore` (the Python template you selected when creating the repo should already include it). This keeps credentials out of GitHub.

3. Now tell Claude Code to write the extraction script:

   ```
   Write an extraction script based on our brainstorm plan. Pull the
   needed tables from the Basket Craft MySQL database. Read credentials
   from the .env file, not hard-coded in the script.
   ```

4. **Verify credentials stayed out of the code.** Open the generated Python script in Cursor and look for the database password. It should not appear anywhere in the `.py` file. If it does:

   ```
   Move the credentials out of the script and read from the .env file.
   ```

5. Review the generated script in Cursor. You should be able to identify:
   - How it connects to the MySQL database
   - Which tables and columns it queries
   - How it stores the extracted data

6. Run the extraction:

   ```
   Run the extraction script.
   ```

7. Claude Code may need to install Python packages (like `mysql-connector-python` or `pymysql`). Let it install them when it asks. These install inside your virtual environment, not system-wide.

**If the script fails:** Let Claude Code see the error and fix it. Connection errors are common the first time (wrong host, wrong port, firewall issues). If you are on campus WiFi, the connection should work, since it is the same database you have been using all semester. If you are finishing this tutorial from home and cannot connect, check with the instructor about remote access — it is the same network setup as Lessons 01-05.

**Checkpoint:** The extraction script runs successfully and pulls data from the Basket Craft MySQL database. You can see confirmation of the extracted data (either as local files or logged output from the script).

---

### Step 5: Transform and Load into Local PostgreSQL

You have the raw data from MySQL. Now you transform it, aggregating into the summary tables your dashboard needs, and load it into your local PostgreSQL. This is the "T" and "L" of ETL.

The aggregations you write here (SUM, COUNT, AVG, GROUP BY) are the same SQL patterns you practiced in Lessons 02-04. The difference is that now they are part of a pipeline script instead of standalone queries in DBeaver.

**What to do:**

1. Tell Claude Code to build the transformation and loading step based on your brainstorm plan:

   ```
   Write the transformation and loading step from our brainstorm plan.
   Aggregate the extracted data into summary tables (revenue, order
   counts, avg order value by product category and month) and load
   into my local PostgreSQL.
   ```

   Claude Code will use the PostgreSQL credentials from the `docker-compose.yml` that the brainstorm created. If it asks for connection details, check that file. If the script hard-codes the PostgreSQL password, ask Claude Code to move those credentials into the `.env` file alongside the MySQL ones.

2. Review the generated code in Cursor. Look for:
   - The aggregation logic: do you see GROUP BY, SUM, COUNT, AVG?
   - How it connects to your local PostgreSQL
   - How it creates the target tables and inserts the data

3. Run the transformation and load:

   ```
   Run the transformation and loading script.
   ```

4. If there are errors, let Claude Code see them and fix. Scripts that connect to two different databases (MySQL for source, PostgreSQL for destination) often need a few iterations to get the connection details right. This is normal.

**One script or two?** Your brainstorm might have produced a single script that does extract-transform-load in one pass, or separate scripts for each stage. Both approaches are valid. A single script is simpler for a small pipeline. Separate scripts are more modular and easier to debug. In MP03 (GitHub Actions), you will see why separating stages can be helpful for automation. For now, either approach works.

**What you are really building:** The summary tables you produce have measures (revenue, order count, average order value) grouped by dimensions (product category, month). If that sounds like it has a formal name, it does. These are the building blocks of a star schema, the standard structure for data warehouses. You will learn the vocabulary (fact tables, dimension tables, staging, marts) in Sessions 02-03 with dbt. For now, just notice the pattern: measures grouped by dimensions.

**Checkpoint:** Aggregated data is loaded into your local PostgreSQL database. Claude Code confirms the load succeeded with row counts or a summary.

---

### Step 6: Verify the Loaded Data

The pipeline ran. But did it work correctly? You will check the loaded data three different ways. Each catches different kinds of problems.

**What to do:**

**Method 1: psql via Claude Code**

1. Ask Claude Code to connect to your local PostgreSQL and check the data:

   ```
   Connect to my local PostgreSQL using psql. Show me the tables,
   row counts, and a sample of rows from each table.
   ```

2. Review the output. Do the table names match what your brainstorm planned? Do the row counts seem reasonable for monthly aggregations?

**CLI through Claude Code:** This demonstrates an important pattern. Claude Code can run CLI tools like `psql` on your behalf — you ask a question, and it handles the connection, the SQL, and the output formatting. You do not need to memorize psql commands. In later mini-projects you will use this same pattern with the AWS CLI, dbt, and Snowflake CLI. You will use this same "ask Claude Code to run a CLI tool" pattern with every tool this semester.

**Method 2: DBeaver**

1. Open DBeaver and create a new PostgreSQL connection. Click **New Database Connection** (or **Database > New Database Connection**), select **PostgreSQL**, and fill in the connection details from the `docker-compose.yml` that the brainstorm created in your project folder:
   - Host: `localhost`
   - Port, database name, username, and password: check your `docker-compose.yml`
   - Click **Test Connection** to verify, then **Finish**

   This is a different connection from MP01 — this project has its own container with its own credentials.

2. Navigate to your database > **Schemas > public > Tables**. You should see the summary tables that your pipeline created.

3. Double-click a table to browse the data. Do the numbers look reasonable? If you see monthly revenue in the hundreds of thousands, does that match your intuition about Basket Craft's order volume?

**Method 3: Claude Code natural language queries**

1. Back in Claude Code, ask analytical questions about the loaded data:

   ```
   What product category had the highest total revenue? Which month had the most orders?
   ```

2. Compare the answers to what you see in DBeaver. They should match.

3. Try a question that directly tests the business requirement:

   ```
   Show me the average order value by product category for each month, sorted by month.
   ```

   This is the core of what the Basket Craft team asked for. If this query returns sensible results, your pipeline works. Notice the structure of what you built: numerical measures (revenue, order count, average order value) organized by descriptive categories (product category, month). This pattern has a name you will learn in Sessions 02-03.

**Three tools, three purposes:**

| Tool | Best for | When to use |
|------|----------|-------------|
| psql via Claude Code | Quick checks, row counts, schema inspection | First pass — did the tables get created with the right structure? |
| DBeaver | Browsing data visually, spotting obvious issues | Second pass — does the data look right when you eyeball it? |
| Claude Code natural language | Analytical questions, testing the business logic | Final pass — does the pipeline actually answer the business question? |

You used all three of these in MP01. The workflow is the same here, just with different data. Get comfortable switching between them. In your independent project, you will use this same three-layer verification to validate your own pipelines.

**Commit your work.** Now that the pipeline is verified, commit everything. Ask Claude Code:

```
Commit all project files with the message: complete Basket Craft ETL pipeline.
```

**Checkpoint:** The aggregated data is verified through all three methods. You can see monthly revenue, order counts, and average order value by product category. The pipeline answers the business question the Basket Craft team asked for. Your work is committed to git.

---

## Homework: Prepare for Session 02

Before the next class, complete these two setup tasks. You will need both for Session 02, where you set up your own AWS infrastructure.

1. **Create an AWS account.** Go to [aws.amazon.com](https://aws.amazon.com/) and create a free-tier account. You will need a credit card on file, but we will only use free-tier resources in this course. If you already have an AWS account from another class, you are set.

2. **Install the AWS CLI.** Follow the instructions for your operating system:

   **Mac:**
   ```bash
   brew install awscli
   ```

   **Windows:** Download and run the installer from [aws.amazon.com/cli](https://aws.amazon.com/cli/)

   Verify the installation by running:
   ```bash
   aws --version
   ```

   You should see a version number like `aws-cli/2.x.x`.

These tools are prerequisites for Session 02. We cannot proceed without them, so do not wait until the day of class.

---

## Part 2: Cloud Data Warehouse (Session 02)

*Coming soon.* This session covers AWS account setup, extracting from the instructor's RDS, loading into Snowflake, and an introduction to dbt.

**Before this session:** Complete the [homework from Session 01](#homework-prepare-for-session-02) (AWS account + CLI install).

---

## Part 3: Dimensional Modeling (Session 03)

*Coming soon.* This session covers dbt staging models, mart models (star schema), and data quality tests.

---

## Submission

Submission details will be added when Sessions 02-03 are complete. MP02 is one lesson exercise covering all three sessions — you will submit your GitHub repository link as **Lesson Exercises 07** after finishing the full tutorial.
