# Mini-Project 01: Local Data Pipeline Tutorial

This tutorial walks through the full mini-project in 12 steps. Steps 1-7 correspond to Session 1 (install tools, build the pipeline). Steps 8-12 correspond to Session 2 (version control, querying, review).

If you fall behind during class, use this tutorial to catch up. Every command and prompt is written out so you can follow along on your own.

## Table of Contents

**Part 1: Setup and Load (Session 1)**

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 1 | [Install Cursor](#step-1-install-cursor) | Set up the code editor |
| 2 | [Install Claude Code](#step-2-install-claude-code) | Install the AI development tool and set explanatory output style |
| 3 | [Install Docker](#step-3-install-docker) | Install Docker Desktop to run databases locally |
| 4 | [Create project folder](#step-4-create-your-project-folder-and-start-claude-code) | Set up the project directory and start Claude Code |
| 5 | [Explore with AI questions](#step-5-create-a-local-database-let-the-ai-ask-you-questions) | Let Claude Code ask you questions to explore how to set up a database |
| 6 | [Build the database](#step-6-build-the-database-with-a-direct-prompt) | Use a direct prompt to create Docker PostgreSQL with init.sql |
| 7 | [Load data with Python](#step-7-load-data-with-a-python-script) | Write a Python script as a second way to load data |

**Part 2: Version Control and Querying (Session 2)**

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 8 | [Initialize git and push to GitHub](#step-8-initialize-git-and-push-to-github) | Version-control your pipeline and push to GitHub |
| 9 | [Query with psql](#step-9-query-your-data-using-psql) | Connect to the database manually and write SQL by hand |
| 10 | [Query with natural language](#step-10-query-with-natural-language) | Ask questions in English and let Claude Code write the SQL |
| 11 | [Review what Claude Code built](#step-11-review-what-claude-code-built) | Read and understand every file the AI generated |
| 12 | [Create CLAUDE.md and practice prompting](#step-12-create-a-claudemd-and-practice-prompting) | Add project context for Claude Code and review prompting techniques |

---

## Part 1: Setup and Load (Session 1)

### Step 1: Install Cursor

Cursor is a code editor built on VS Code with AI features built in. It is where you will write and manage all your project files.

**If you already have Cursor installed:** Open it. You should see the welcome screen with "Open project," "Clone repo," and your recent projects. You are ready for Step 2. Just make sure you have a GitHub account (see item 5 below).

**If you need to install Cursor:**

1. Go to [cursor.com](https://www.cursor.com/) and download the installer for your operating system.
2. Run the installer.
   - **Mac:** Open the .dmg file and drag Cursor to your Applications folder.
   - **Windows:** Run the .exe installer and follow the prompts.
3. Open Cursor. It will ask you to create a Cursor account. You can sign in with GitHub, Google, or email — any option works.
4. Cursor may ask a few setup questions (how you plan to use it, etc.). Answer however you like — these do not affect functionality.

**Everyone:**

5. Make sure you have a GitHub account. If you don't have one, create one at [github.com](https://github.com). Pick a professional username — recruiters will see this. You will need it in Step 7 when you push your project to GitHub.

**Checkpoint:** Cursor is open. You see either the welcome screen or an editor window.

---

### Step 2: Install Claude Code

Claude Code is a command-line tool that lets you talk to Claude directly in the terminal. You describe what you want in plain English and it generates code, runs commands, and edits files for you.

**What to do:**

1. You need a Claude Pro subscription ($20/month). Go to [claude.ai](https://claude.ai/) and subscribe if you have not already.

2. Open the terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal** from the menu bar).

3. Run the install command for your operating system:

   **Mac:**
   ```bash
   curl -fsSL https://claude.ai/install.sh | bash
   ```

   **Windows:**

   First, install Git for Windows if you do not have it already. Download it from [git-scm.com/downloads/win](https://git-scm.com/downloads/win) and run the installer with default settings.

   Then open a new terminal in Cursor and run:
   ```powershell
   irm https://claude.ai/install.ps1 | iex
   ```

4. Close the terminal and open a new one (so the install takes effect).

5. Run `claude` to start the authentication flow. Follow the prompts to sign in.

6. Once authenticated, change the output style to explanatory mode. Type:
   ```
   /config
   ```
   A settings menu will appear. Use the arrow keys to select **Output style**, press Enter, then select **Explanatory** and press Enter again. This tells Claude Code to explain what it is doing as it works, so you learn the tools instead of just watching code appear. You only need to set this once -- it persists across sessions.

**Checkpoint:** Running `claude` in the terminal opens an interactive session where you can type prompts. The output style is set to explanatory.

---

### Step 3: Install Docker

Think about how you set up your database in Lessons 01-05. You were given connection details to a remote server that was already configured. If you wanted to run that same database on your laptop, you would need to install MySQL, configure it, create the right users and permissions, and hope it works the same way on your machine as it does on the server. If a classmate has a different operating system, they might need different steps entirely.

Docker solves this problem. It lets you run applications inside **containers** — lightweight, self-contained packages that include everything the application needs to run. A PostgreSQL container comes with PostgreSQL already installed and configured. You describe what you want in a simple file (`docker-compose.yml`), run one command, and the database starts. It works the same on every machine — Mac, Windows, or Linux.

In this tutorial, you will use Docker to run a PostgreSQL database on your laptop. Later in the course, you will use Docker for other services too. In industry, Docker is how most data engineering teams package and deploy their tools.

**What to do:**

1. Go to [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/) and download Docker Desktop.

   **Mac users:** Check whether you have Apple Silicon or Intel. Click the Apple menu > **About This Mac**. If it says "Apple M1" (or M2, M3, etc.), download the Apple Silicon version. If it says "Intel," download the Intel version.

   **Windows users:** Docker Desktop requires WSL 2 (Windows Subsystem for Linux). The Docker installer will prompt you to enable it if it is not already set up. Follow those prompts.

2. Run the installer and open Docker Desktop. You will see a dashboard — this is where you can monitor your running containers. Leave it open in the background.

3. Verify the installation by opening a terminal in Cursor and running:
   ```bash
   docker --version
   ```

**Checkpoint:** The `docker --version` command prints a version number (e.g., `Docker version 27.x.x`). Docker Desktop is running in the background.

---

### Step 4: Create Your Project Folder and Start Claude Code

Now you will set up your project directory and start working with Claude Code.

**What to do:**

1. Open a terminal in Cursor. If you don't see a terminal panel at the bottom of the window, go to **Terminal > New Terminal** from the menu bar at the top (or press `` Ctrl+` ``).

   If you are still inside a Claude Code session from Step 2, type `/exit` first to get back to your normal terminal prompt (you should see a `$` or `%` sign).

2. Create a folder to keep all your work for this course organized in one place, then create the project folder inside it:

   ```bash
   mkdir -p ~/isba-4715
   ```
   ```bash
   cd ~/isba-4715
   ```
   ```bash
   mkdir campus-bites-pipeline
   ```
   ```bash
   cd campus-bites-pipeline
   ```

   The `~/isba-4715` folder is your home base for the rest of the semester. Every mini-project and your independent project will get its own subfolder here. By the end of the course it will look something like this:

   ```
   ~/isba-4715/
   ├── campus-bites-pipeline/     <-- MP01 (this tutorial)
   ├── cloud-pipeline/            <-- MP02
   ├── api-pipeline/              <-- MP03
   ├── ai-chatbot/                <-- MP04
   └── your-project-name/         <-- Independent project
   ```

3. Create a `data` subfolder and copy the CSV file into it:
   ```bash
   mkdir data
   ```
   Download [`campus_bites_orders.csv`](https://lmu-isba.github.io/isba-4715-f26/lessons/06-local-pipeline/data/campus_bites_orders.csv) and save it into the `data/` folder. You can also drag and drop it in Cursor's file explorer.

4. Now open the `campus-bites-pipeline` folder in Cursor so you can see the files in the sidebar. Go to **File > Open Folder**, navigate to your home folder, then open `isba-4715`, then select `campus-bites-pipeline`. (The full path is `~/isba-4715/campus-bites-pipeline`.) You should see your `data/` folder in the file explorer on the left.

5. Open a new terminal in this project (`` Ctrl+` `` or **Terminal > New Terminal**). The terminal should now show `campus-bites-pipeline` in the prompt, meaning you are inside your project folder.

6. Start Claude Code:
   ```bash
   claude
   ```

From this point forward, you will tell Claude Code what you want and it will build it for you. Each step below gives you the exact prompt to use.

**Checkpoint:** Claude Code is running in the terminal and waiting for your input. The `data/campus_bites_orders.csv` file is in your project folder.

---

### Step 5: Create a Local Database (Let the AI Ask You Questions)

You need a database to load the CSV data into. But unlike Lessons 01-05 where someone else set up the database for you, this time you are starting from scratch. You might not know what tools to use or how to set them up, and that's fine. This is where you learn an important prompting technique: **let the AI ask you questions first.**

**What to do:**

1. In your Claude Code session, type this prompt:

   ```
   I need to set up a local database to store CSV data and run SQL queries. Ask me one question at a time before you start building anything.
   ```

2. Claude Code will start asking you questions — what database you prefer, what operating system you're on, whether you have Docker installed. Answer honestly. If you don't know, say so. Claude Code will explain the options and recommend one.

3. After about five questions, ask Claude Code to summarize what it has gathered so far. This is your chance to catch any misunderstandings before it puts a plan together.

4. Keep going until you feel Claude Code has enough context. Then tell it you're done answering questions and ask it to propose a plan. Don't let it start building anything until you've reviewed and approved the plan.

**Why this technique matters:** You often know the problem but not the solution. Instead of guessing at tools and configurations, you describe what you need and let the AI guide you to the right approach.

**MySQL vs. PostgreSQL:** In Lessons 01-05 you used MySQL. Now you are using PostgreSQL. Both are relational databases and your SQL knowledge transfers directly. SELECT, FROM, WHERE, GROUP BY, JOINs, CTEs, and window functions all work the same way. The syntax differences are minor (e.g., PostgreSQL uses `||` to concatenate strings instead of MySQL's `CONCAT()`, and uses `TRUE`/`FALSE` instead of `1`/`0` for booleans). Most of the queries you wrote in Lessons 01-05 will run without changes.

So why switch? PostgreSQL is the standard in data engineering and analytics. Snowflake (which you will use starting in MP02), Amazon Redshift, and most modern data warehouses are all based on PostgreSQL's SQL dialect. dbt also works best with PostgreSQL-family databases. Learning PostgreSQL now means the SQL you write will carry directly into the tools you use for the rest of the course and in industry.

---

### Step 6: Build the Database with a Direct Prompt

In Step 5, everyone's conversation went a different direction depending on how they answered the questions. Now we converge. Copy and paste this prompt into Claude Code to make sure everyone ends up with the same setup:

**What to do:**

1. Type this prompt:

   ```
   I need to set up a local Postgres database using Docker. I have a single CSV file at data/campus_bites_orders.csv.

   Requirements:
   - Postgres on Docker
   - An init.sql script that creates the table and loads the CSV on first startup
   - The setup should be easy for others to clone and run
   - Primary use case is running SQL queries interactively using SQL and natural language
   - Database name: campus_bites
   - Include a README with setup instructions

   I have Docker installed. Don't start building until I confirm the plan.
   ```

2. Claude Code will present a plan. Review it, then confirm to let it build.

3. Once the files are generated, start the database:

   ```
   Start the database.
   ```

   Docker will download the PostgreSQL image (this may take a minute the first time) and start the database. The `init.sql` script runs automatically on first startup, creating the table and loading all 1,132 rows from the CSV.

4. Verify the data loaded:

   ```
   Verify the data loaded correctly.
   ```

**About this prompt:** Notice how different it is from Step 5. In Step 5, you described a problem and let the AI ask questions. Here, you gave specific requirements upfront because you now know what you want. Both approaches are useful. The key difference: Step 5 is for exploring when you're unsure, this prompt is for executing when you're clear.

**A note on credentials:** Claude Code generated a username and password for your local database. To find them, open the file explorer in Cursor and look for a file called `docker-compose.yml` (or similar) in your project root. The database name, username, and password are defined there as environment variables. These credentials only matter on your laptop — the database is not accessible from the internet. When you work with cloud databases later in the course, you will use environment variables to keep credentials out of your code.

5. Now connect to your new database using DBeaver, the same tool you used in Lessons 01-05. Open DBeaver and create a new connection:
   - Click the **New Database Connection** button (or **Database > New Database Connection**)
   - Select **PostgreSQL** (not MySQL this time)
   - Fill in the connection details using the credentials from your Docker configuration file. The host is `localhost` since the database is running on your machine.
   - Click **Test Connection** to make sure it works, then click **Finish**

   You should see the `orders` table under **campus_bites > Schemas > public > Tables**.

6. Open a new SQL script in DBeaver (right-click your connection > **SQL Editor > New SQL Script**) and run a quick query to confirm everything works:

   ```sql
   SELECT COUNT(order_id) FROM orders;
   ```

   You should get 1,132 rows. Same workflow as Lessons 01-05, just PostgreSQL instead of MySQL.

7. Now go back to Claude Code and ask a question about the data in plain English:

   ```
   What are the top 3 cuisine types by number of orders?
   ```

   Claude Code will write the SQL, run it against your database, and return the results.

8. Now ask Claude Code to show you the SQL it used:

   ```
   Show me the SQL query you just ran.
   ```

   Copy that query, switch to DBeaver, paste it into your SQL editor, and run it. The results should match. Get in the habit of doing this — when AI generates a query, run the SQL yourself to verify. You'll catch mistakes faster and pick up SQL patterns as you go.

**Checkpoint:** The row count returns 1,132 in DBeaver, Claude Code can answer questions in plain English, and you verified the generated SQL by running it yourself in DBeaver.

---

### Step 7: Reload Data with a Python Script

The `init.sql` approach from Step 6 loads data automatically when Docker starts. That works well for a static CSV that ships with the repo. But in data engineering, you often need to load data programmatically, on a schedule, or from sources that aren't files sitting in your repo. A Python script lets you do all of that.

You're going to replace `init.sql` with a Python script as the way data gets into your database. Before writing the script, you need to clean up the old approach so there's only one way data gets loaded.

**What to do:**

1. First, drop the existing data. Tell Claude Code:

   ```
   Drop the orders table from the database.
   ```

2. Switch to DBeaver and refresh your connection (right-click the connection > **Refresh**). The `orders` table should be gone from **campus_bites > Schemas > public > Tables**. This confirms the drop worked.

3. Now remove `init.sql` and update the Docker configuration so it no longer references it. Tell Claude Code:

   ```
   Remove @init.sql and update the Docker configuration so it no longer references that file. The Python script will handle data loading from now on.
   ```

   When you replace one approach with another, clean up the old one. If you leave `init.sql` mounted in Docker, restarting the container would load the data twice — once from `init.sql` and again from your Python script.

4. Restart the database so it comes up empty. Tell Claude Code:

   ```
   Restart the database.
   ```

5. Switch to DBeaver, refresh, and confirm the database has no tables. The container is running but the database is empty — exactly what you want before loading data with Python.

6. Before writing any Python code, set up a virtual environment. Tell Claude Code:

   ```
   Create a Python virtual environment for this project.
   ```

   A virtual environment is an isolated space for your project's Python dependencies. Without one, installing a package like `psycopg2` goes into your system-wide Python, which can cause conflicts between projects. Every Python project should have its own virtual environment. You'll do this for every mini-project and your independent project.

   You don't need to activate the environment yourself. Claude Code will use it automatically when it runs Python scripts or installs packages.

7. Now type this prompt, using the `@` symbol to reference the CSV file:

   ```
   Write a Python script that loads @data/campus_bites_orders.csv into the orders table in the database.
   ```

   **About `@` references:** When you type `@` followed by a file path in Claude Code, it reads that file and includes its contents in your prompt. This means Claude Code can see the actual column names, data types, and sample rows in the CSV instead of guessing, so it writes a more accurate script on the first try. It will know the exact columns (`order_id`, `order_date`, `customer_segment`, etc.) without you listing them out. Use `@` whenever you want Claude Code to look at a specific file as part of your request.

8. Claude Code will generate a Python script. Review the code and accept it.

9. Open the script in Cursor's file explorer so you can see the full code. Read through it — you should be able to spot where it connects to the database, reads the CSV, creates the table, and inserts the rows.

10. If the code doesn't have comments, ask Claude Code to add them:

    ```
    Add comments to the Python script explaining what each section does.
    ```

    Reading commented code is one of the fastest ways to learn what generated code is doing. You don't need to understand every line yet, but you should be able to follow the overall flow.

11. Claude Code may need to install Python dependencies (like `psycopg2` or `pandas`). Let it do so when it asks. These will install inside your virtual environment, not system-wide.

12. Tell Claude Code to run the script:

    ```
    Run the script.
    ```

    Running scripts through Claude Code is better than running them manually because if something fails, Claude Code sees the error immediately and can fix the code and retry without you having to copy and paste error messages.

13. Verify the data is back:

    ```
    Verify the data loaded correctly.
    ```

14. Switch to DBeaver one last time, refresh, and confirm the `orders` table is back with 1,132 rows.

**Why replace `init.sql`?** In later mini-projects, you will use Python scripts to extract data from APIs and web pages. Those data sources can't be loaded with a SQL file because the data doesn't come from a local CSV. Getting comfortable with Python-based loading now prepares you for those projects.

**Checkpoint:** The `init.sql` file is gone, the Docker configuration no longer references it, and the Python script is the only thing loading data into the database. The row count is 1,132 in both Claude Code and DBeaver.

---

## Part 2: Version Control and Querying (Session 2)

### Step 8: Initialize Git and Push to GitHub

Your pipeline works locally. Now you will version-control it so you can share it and track changes.

**What to do:**

1. Make sure Claude Code is running in your project folder. If it's not already open, start it:
   ```bash
   claude
   ```

2. First, initialize a git repository:

   ```
   Initialize a git repository in this project folder.
   ```

   Git tracks every change you make to your files. If you break something, you can go back. If you want to see what changed last week, you can look it up. Initializing a repo is always the first step.

3. Next, create a .gitignore file:

   ```
   Create a .gitignore file for a Python project.
   ```

   A .gitignore tells git which files to skip. You don't want to push temporary files or files with passwords to GitHub. Claude Code knows what to include for a Python project.

4. Now make your first commit:

   ```
   Stage all the project files and create an initial commit.
   ```

   Staging is how you tell git which files to include in the next commit. Think of it as putting files in a box before sealing it. A commit is a snapshot of everything in that box at a point in time — a save point you can always go back to.

5. Before you can push code to GitHub, you need to authenticate your computer with your GitHub account. Open a new terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal**) and keep Claude Code running in the other one. Install the GitHub CLI:

   **Mac:**
   ```bash
   brew install gh
   ```
   If you don't have Homebrew, install it first by following the instructions at [brew.sh](https://brew.sh).

   **Windows:**
   ```bash
   winget install --id GitHub.cli
   ```

   Then log in:
   ```bash
   gh auth login
   ```
   - Select **GitHub.com**
   - Select **HTTPS**
   - When asked to authenticate, select **Login with a web browser**
   - Copy the one-time code shown in the terminal, press Enter, and complete the sign-in in your browser

   This saves your GitHub credentials so git commands (push, pull, clone) work without asking for a password every time. The GitHub CLI is also a tool you will use throughout the course for creating GitHub Actions pipelines and managing repositories from the terminal. You will use CLIs for many services this semester (AWS, Snowflake, dbt) because they work well with Claude Code and automation.

6. Go to [github.com/new](https://github.com/new) and create a new repository:
   - Name it `campus-bites-pipeline`
   - Set it to **Public**
   - Do NOT initialize with a README (you already have files locally)

7. Switch back to your Claude Code terminal and connect your local repo to GitHub:

   ```
   Add a git remote for my GitHub repo at https://github.com/YOUR-USERNAME/campus-bites-pipeline.git
   ```

   Replace `YOUR-USERNAME` with your actual GitHub username. A remote is a link between your local repo and the one on GitHub. This tells git where to send your code when you push.

8. Push your code to GitHub:

   ```
   Push the main branch to GitHub.
   ```

   This uploads your committed files to the remote repository. Anyone with the link can now see your project.

Notice that you did not need to memorize any git commands. You described what you wanted in plain English and Claude Code handled the syntax.

**Checkpoint:** Go to your repository on GitHub and verify that your files (docker-compose.yml, the Python script, the data file, and .gitignore) are all there.

---

### Step 9: Query Your Data Using psql

The same data you analyzed in Lessons 01-02 is now in a database you built yourself. In the first half you used DBeaver to run queries. Now you will use `psql`, the official PostgreSQL command-line client. It runs directly inside your Docker container, no extra installation needed.

**What to do:**

1. Make sure you are not inside Claude Code. You should see your normal terminal prompt. Run:

   ```bash
   docker exec -it campus_bites_db psql -U postgres -d campus_bites
   ```

   Here is what each part does:
   - `docker exec` — run a command inside a running container (your PostgreSQL database is running in a container)
   - `-it` — interactive mode with a terminal, so you can type commands and see output
   - `campus_bites_db` — the name of your container (if this is different, run `docker ps` to find it in the NAME column)
   - `psql` — the PostgreSQL command-line client
   - `-U postgres` — connect as the user `postgres`
   - `-d campus_bites` — connect to the `campus_bites` database

   You should see a `campus_bites=#` prompt, which means you are connected. This is the PostgreSQL equivalent of opening a connection in DBeaver.

2. Try a quick query to make sure the data is there:

   ```sql
   SELECT COUNT(*) FROM orders;
   ```

3. Run one of the queries you wrote in Lesson 01:

   ```sql
   SELECT
       EXTRACT(YEAR FROM order_date) AS order_year,
       EXTRACT(MONTH FROM order_date) AS order_month,
       COUNT(order_id) AS total_orders,
       ROUND(SUM(order_value)::numeric, 2) AS total_revenue
   FROM orders
   GROUP BY
       EXTRACT(YEAR FROM order_date),
       EXTRACT(MONTH FROM order_date)
   ORDER BY
       order_year,
       order_month;
   ```

   Notice two small PostgreSQL differences from MySQL: `EXTRACT(MONTH FROM ...)` instead of `MONTH(...)`, and `::numeric` for casting before rounding. The logic is the same.

4. Type `\q` to exit psql.

**psql vs. Python scripts:** Use psql when you want to explore data and ask quick questions, the same way you used DBeaver in the first half. Use Python scripts when you need to automate something repeatable, like the data loading script you built in Step 7. Real data engineers use both: psql for exploration, Python for pipelines.

**Checkpoint:** You connected to the database manually, ran SQL queries, and saw familiar Campus Bites data in a database you built yourself.

---

### Step 10: Query with Natural Language

In Step 9, you typed SQL by hand. Now ask questions in plain English and let Claude Code write and run the SQL for you.

**What to do:**

1. Start Claude Code:
   ```bash
   claude
   ```

2. Ask a question about the data:

   ```
   Which customer segment has the highest average order value?
   ```

3. Claude Code will write the SQL, connect to the database via psql, and show you the results. Compare this to Step 9 where you typed everything manually.

4. Try another question:

   ```
   Show me the top 3 cuisine types by total revenue.
   ```

5. Try asking a question that requires more complex SQL — something like the window functions and percentage calculations you wrote in Lessons 02-04:

   ```
   Show me month-over-month revenue growth as a percentage, and flag any months where revenue dropped.
   ```

   Look at the SQL Claude Code generates. You should recognize patterns from your earlier lessons: `LAG()` for comparing to the previous month, `CASE WHEN` for flagging drops, and date functions for grouping by month.

6. When you are done exploring, exit Claude Code:

   ```
   /exit
   ```

**The progression:** In Lessons 01-05, you wrote SQL in DBeaver. In Step 9, you wrote SQL in psql. Now you asked questions in English and Claude Code wrote the SQL. All three are useful. Knowing SQL helps you verify what the AI generates. Using natural language helps you explore data faster.

**Checkpoint:** You asked questions in plain English and Claude Code returned query results. You can compare its SQL to what you would have written yourself.

---

### Step 11: Review What Claude Code Built

AI-generated code is only useful if you understand it. In the final interview for this course, you will need to explain every component of your projects. Start that habit now.

**What to do:**

1. Open Cursor's file explorer (the sidebar) and look at the files Claude Code created.

2. Open `docker-compose.yml` (or your Docker configuration file). Read through it. You should be able to identify:
   - Which Docker image it uses
   - The database name, username, and password
   - Which port is mapped

3. Open the Python load script. Read through it. You should be able to identify:
   - How it connects to the database
   - How it reads the CSV
   - How it creates the table
   - How it inserts the data

4. If anything is unclear, ask Claude Code to explain it:

   ```
   Explain what each section of the docker-compose.yml does.
   ```

   Read the explanation carefully. If you let the AI generate code but never read the explanation, the code stays a black box.

**Checkpoint:** You can describe in your own words what each file does and why it is needed. If someone asked "what does `docker compose up -d` do?" you could answer confidently.

---

### Step 12: Create a CLAUDE.md and Practice Prompting

Every Claude Code project benefits from a `CLAUDE.md` file. This is a markdown file in your project root that Claude Code reads at the start of every session. It gives Claude Code context about your project so it makes better decisions.

**What to do:**

1. In Claude Code, type:

   ```
   /init
   ```

   This command tells Claude Code to scan your project and generate a `CLAUDE.md` file automatically. It will look at your files, your Docker setup, and your Python script to build a summary of the project.

2. Review the file Claude Code creates. This is the project context that Claude Code will read every time you start a new session. Make sure it includes the database connection details — if not, ask Claude Code to add them.

3. Commit the new file:

   ```
   Commit the CLAUDE.md file.
   ```

**Prompting techniques from this tutorial:**

You used two different prompting approaches today. Knowing when to use each one is a skill you will build throughout the course.

| When to use | Technique | Example from today |
|---|---|---|
| You don't know the solution | Let the AI ask you questions | Step 5: "I need to set up a local database... Ask me one question at a time" |
| You know exactly what you want | Give a direct, specific prompt | Step 6: Requirements list with "Don't start building until I confirm the plan" |

Both approaches follow the same rule: one request at a time. Read what comes back before moving on.

**Checkpoint:** Your project has a CLAUDE.md file, and you can explain when to let the AI ask questions vs. when to give a direct prompt.

---

## Submission

1. Make sure all your files are committed and pushed to GitHub.
2. Submit your GitHub repository link as **Lesson Exercise 06**.

Your repository should contain at minimum:
- `CLAUDE.md`
- `docker-compose.yml`
- A Python script that loads the CSV data
- `data/campus_bites_orders.csv`
- `.gitignore`
