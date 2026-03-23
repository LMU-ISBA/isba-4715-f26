# Mini-Project 1: Local Data Pipeline Tutorial

This tutorial walks through the full mini-project in 10 steps. Steps 1-6 correspond to Session 1 (install tools, build the pipeline). Steps 7-10 correspond to Session 2 (version control, querying, review).

If you fall behind during class, use this tutorial to catch up. Every command and prompt is written out so you can follow along on your own.

## Table of Contents

**Part 1: Setup and Load (Session 1)**

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 1 | [Install Cursor](#step-1-install-cursor) | Set up the code editor |
| 2 | [Install Claude Code](#step-2-install-claude-code) | Install the AI development tool and set explanatory output style |
| 3 | [Install Docker](#step-3-install-docker) | Install Docker Desktop to run databases locally |
| 4 | [Create project folder](#step-4-create-your-project-folder-and-start-claude-code) | Set up the project directory and start Claude Code |
| 5 | [Create a local database](#step-5-create-a-local-database-let-the-ai-ask-you-questions) | Let Claude Code ask you questions to set up Docker PostgreSQL |
| 6 | [Load CSV into PostgreSQL](#step-6-load-the-csv-into-postgresql-direct-prompt) | Use a direct prompt with @ references to load the data |

**Part 2: Version Control and Querying (Session 2)**

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 7 | [Initialize git and push to GitHub](#step-7-initialize-git-and-push-to-github) | Version-control your pipeline and push to GitHub |
| 8 | [Query your data using psql](#step-8-query-your-data-using-psql) | Connect to the database manually with psql, then let Claude Code query for you |
| 9 | [Review what Claude Code built](#step-9-review-what-claude-code-built) | Read and understand every file the AI generated |
| 10 | [Create CLAUDE.md and practice prompting](#step-10-create-a-claudemd-and-practice-prompting) | Add project context for Claude Code and review prompting techniques |

---

## Part 1: Setup and Load (Session 1)

### Step 1: Install Cursor

Cursor is a code editor built on VS Code with AI features built in. It is where you will write and manage all your project files.

**What to do:**

1. Go to [cursor.com](https://www.cursor.com/) and download the installer for your operating system.
2. Run the installer.
3. Open Cursor and sign in with your GitHub account.

**Checkpoint:** Cursor opens and you see a welcome screen or an empty editor window.

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

Think about how you set up your database in Lessons 01-05. Your instructor gave you connection details to a remote server that was already configured. If you wanted to run that same database on your laptop, you would need to install MySQL, configure it, create the right users and permissions, and hope it works the same way on your machine as it does on the server. If a classmate has a different operating system, they might need different steps entirely.

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

1. Open a terminal in Cursor. Create a folder to keep all your work for this course organized in one place, then create the project folder inside it:

   ```bash
   mkdir -p ~/isba-4715 && cd ~/isba-4715
   mkdir campus-bites-pipeline && cd campus-bites-pipeline
   ```

   The `~/isba-4715` folder is your home base for the rest of the semester. Every mini-project and your independent project will get its own subfolder here. By the end of the course it will look something like this:

   ```
   ~/isba-4715/
   ├── campus-bites-pipeline/     <-- MP1 (this tutorial)
   ├── cloud-pipeline/            <-- MP2
   ├── api-pipeline/              <-- MP3
   ├── ai-chatbot/                <-- MP4
   └── your-project-name/         <-- Independent project
   ```

2. Create a `data` subfolder and copy the CSV file into it:
   ```bash
   mkdir data
   ```
   Copy the `campus_bites_orders.csv` file from the course materials into the `data/` folder. You can drag and drop it in Cursor's file explorer, or use `cp` on the command line.

3. Start Claude Code:
   ```bash
   claude
   ```

From this point forward, you will tell Claude Code what you want and it will build it for you. Each step below gives you the exact prompt to use.

**Checkpoint:** Claude Code is running in the terminal and waiting for your input. The `data/campus_bites_orders.csv` file is in your project folder.

---

### Step 5: Create a Local Database (Let the AI Ask You Questions)

You need a database to load the CSV data into. But unlike Lessons 01-05 where someone else set up the database for you, this time you are starting from scratch. You might not know what tools to use or how to set them up — and that's fine. This is where you learn a powerful prompting technique: **let the AI ask you questions first.**

**What to do:**

1. In your Claude Code session, type this prompt:

   ```
   I have a CSV file with restaurant orders data. I need to set up a local database on my laptop so I can load the data and run SQL queries against it. I also want it to be easy for someone else to clone my repo and get the same database running on their machine. Ask me questions one at a time before you start building anything.
   ```

2. Claude Code will start asking you questions — things like what database you prefer, what operating system you're on, whether you have Docker installed. Answer honestly based on what you know. If you don't know the answer, say so — Claude Code will explain and recommend an option.

3. Through this conversation, you and Claude Code will arrive at a plan together. It will likely recommend Docker with PostgreSQL, and ask you for details like the database name and credentials. Use these when asked:
   - Database name: `campus_bites`
   - Username: `student`
   - Password: `student123`

4. Once Claude Code has enough information, it will generate a `docker-compose.yml` file. Review it, then accept the changes.

5. Tell Claude Code to start the database:

   ```
   Start the Docker container.
   ```

   Docker will download the PostgreSQL image (this may take a minute the first time) and start the database in the background.

**Why this technique matters:** In the real world, you often know the problem but not the solution. Instead of guessing at tools and configurations, you describe what you need and let the AI guide you to the right approach. You just arrived at Docker and PostgreSQL without needing to know those terms upfront.

**MySQL vs. PostgreSQL:** In Lessons 01-05 you used MySQL. Now you are using PostgreSQL. Both are relational databases and your SQL knowledge transfers directly — SELECT, FROM, WHERE, GROUP BY, JOINs, CTEs, and window functions all work the same way. The syntax differences are minor (e.g., PostgreSQL uses `||` to concatenate strings instead of MySQL's `CONCAT()`, and uses `TRUE`/`FALSE` instead of `1`/`0` for booleans). Most of the queries you wrote in Lessons 01-05 will run without changes.

So why switch? PostgreSQL is the standard in data engineering and analytics. It has better support for complex queries, JSON data, and advanced data types. Snowflake (which you will use starting in MP2), Amazon Redshift, and most modern data warehouses are all based on PostgreSQL's SQL dialect. dbt also works best with PostgreSQL-family databases. Learning PostgreSQL now means the SQL you write will carry directly into the data warehouse and production tools you will use for the rest of the course and in industry.

**A note on credentials:** The username and password in this docker-compose.yml are for a local development database. This is fine because the database only runs on your laptop. When you work with cloud databases later in the course, you will use environment variables to keep credentials out of your code.

**Checkpoint:** Ask Claude Code to verify the database is running. You should see a running PostgreSQL container.

---

### Step 6: Load the CSV into PostgreSQL (Direct Prompt)

In Step 5, you let Claude Code ask you questions because you didn't know the solution yet. Now you know exactly what you want: load a CSV file into the database you just created. When you know the details, give a direct and specific prompt.

**What to do:**

1. Start Claude Code again:
   ```bash
   claude
   ```

2. Type this prompt, using the `@` symbol to reference the CSV file:

   ```
   Write a Python script that reads @data/campus_bites_orders.csv and loads it into a table called orders in the campus_bites database running in Docker. The connection details are: host localhost, port 5432, database campus_bites, username student, password student123. The script should create the table if it doesn't exist.
   ```

   **About `@` references:** When you type `@` followed by a file path in Claude Code, it reads that file and includes its contents in your prompt. This means Claude Code can see the actual column names, data types, and sample rows in the CSV, instead of guessing. The result is a more accurate script on the first try -- it will know the exact columns (`order_id`, `order_date`, `customer_segment`, etc.) without you having to list them out. Use `@` whenever you want Claude Code to look at a specific file as part of your request.

3. Claude Code will generate a Python script. Review the code and accept it.

4. Claude Code may need to install Python dependencies (like `psycopg2` or `pandas`). Let it do so when it asks.

5. Run the script when Claude Code prompts you, or exit and run it manually:
   ```bash
   python load_data.py
   ```
   (The filename may differ depending on what Claude Code named it.)

6. Verify the data loaded. Start Claude Code again and type:

   ```
   Use psql inside the Docker container to count the rows in the orders table.
   ```

**Why this matters:** This is the core of a data pipeline -- getting data from a source file into a database where it can be queried. The script Claude Code wrote is something you could run again whenever the CSV is updated.

**Checkpoint:** The row count query returns the number of rows in the CSV file. The data is now in your local PostgreSQL database.

---

## Part 2: Version Control and Querying (Session 2)

### Step 7: Initialize Git and Push to GitHub

Your pipeline works locally. Now you will version-control it so you can share it and track changes.

**What to do:**

1. Start Claude Code in your project folder:
   ```bash
   claude
   ```

2. First, initialize a git repository:

   ```
   Initialize a git repository in this project folder.
   ```

   Git tracks every change you make to your files. This is how professional developers keep a history of their work and collaborate with others. Initializing a repo is always the first step.

3. Next, create a .gitignore file:

   ```
   Create a .gitignore file for a Python project. Make sure it ignores virtual environments, __pycache__, .env files, and OS files like .DS_Store.
   ```

   A .gitignore tells git which files to skip. You don't want to push temporary files, cached bytecode, or files with passwords to GitHub.

4. Now make your first commit:

   ```
   Stage all the project files and create an initial commit.
   ```

   A commit is a snapshot of your project at a point in time. Think of it as a save point you can always go back to.

5. Go to [github.com/new](https://github.com/new) and create a new repository:
   - Name it `campus-bites-pipeline`
   - Set it to **Public**
   - Do NOT initialize with a README (you already have files locally)

6. Back in Claude Code, connect your local repo to GitHub:

   ```
   Add a git remote for my GitHub repo at https://github.com/YOUR-USERNAME/campus-bites-pipeline.git
   ```

   Replace `YOUR-USERNAME` with your actual GitHub username. A remote is a link between your local repo and the one on GitHub. This tells git where to send your code when you push.

7. Push your code to GitHub:

   ```
   Push the main branch to GitHub.
   ```

   This uploads your committed files to the remote repository. Anyone with the link can now see your project.

Notice that you did not need to memorize any git commands. You described what you wanted in plain English and Claude Code handled the syntax. This is one of the main benefits of working with Claude Code.

**Checkpoint:** Go to your repository on GitHub and verify that your files (docker-compose.yml, the Python script, the data file, and .gitignore) are all there.

---

### Step 8: Query Your Data Using psql

The same data you analyzed in Lessons 01-02 is now in a database you built yourself. In the first half you used DBeaver to run queries. Now you will use `psql`, the official PostgreSQL command-line client. It runs directly inside your Docker container — no extra installation needed.

**What to do:**

First, connect to the database yourself from the terminal to see how psql works.

1. Make sure you are not inside Claude Code. You should see your normal terminal prompt. Run:

   ```bash
   docker exec -it campus-bites-pipeline-db-1 psql -U student -d campus_bites
   ```

   Here is what each part does:
   - `docker exec` — run a command inside a running container (your PostgreSQL database is running in a container)
   - `-it` — interactive mode with a terminal, so you can type commands and see output
   - `campus-bites-pipeline-db-1` — the name of your container (if this is different, run `docker ps` to find it in the NAME column)
   - `psql` — the PostgreSQL command-line client
   - `-U student` — connect as the user `student`
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

Now let Claude Code handle the querying for you.

5. Start Claude Code:
   ```bash
   claude
   ```

6. Ask Claude Code to run a query:

   ```
   Connect to the campus_bites database using psql in the Docker container and show me which customer segment has the highest average order value.
   ```

   Claude Code will write and run the `docker exec` command and the SQL query for you. Compare this to typing everything manually in steps 1-3. Both approaches work — knowing the manual way helps you understand what Claude Code is doing under the hood.

7. Try one more:

   ```
   Using psql, show me the top 3 cuisine types by total revenue.
   ```

8. When you are done exploring, exit Claude Code:

   ```
   /exit
   ```

**psql vs. Python scripts:** Use psql when you want to explore data and ask quick questions — the same way you used DBeaver in the first half. Use Python scripts when you need to automate something repeatable, like the data loading script you built in Step 6. Real data engineers use both: psql for exploration, Python for pipelines.

**Why this matters:** Same analytical questions you tackled before, but now you own the entire stack. The database, the data loading process, and the queries are all in your repository. And you now know two ways to query it: manually with psql and through Claude Code.

**Checkpoint:** You have connected to the database both manually and through Claude Code. The query results should look familiar from your earlier Campus Bites analysis.

---

### Step 9: Review What Claude Code Built

AI-generated code is only useful if you understand it. In the final interview for this course, you will need to explain every component of your projects. Start that habit now.

**What to do:**

1. Open Cursor's file explorer (the sidebar) and look at the files Claude Code created.

2. Open `docker-compose.yml`. Read through it. You should be able to identify:
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

### Step 10: Create a CLAUDE.md and Practice Prompting

Every Claude Code project benefits from a `CLAUDE.md` file. This is a markdown file in your project root that Claude Code reads at the start of every session. It gives Claude Code context about your project so it makes better decisions.

**What to do:**

1. In Claude Code, type this prompt:

   ```
   Create a CLAUDE.md file for this project. It should describe that this is a Campus Bites data pipeline that loads orders data from CSV into a local PostgreSQL database running in Docker. Include the database connection details (host localhost, port 5432, database campus_bites, username student, password student123).
   ```

2. Review the file Claude Code creates. This is the project context that Claude Code will read every time you start a new session.

3. Commit the new file:

   ```
   Commit the CLAUDE.md file.
   ```

**Prompting techniques from this tutorial:**

You used two different prompting approaches today. Knowing when to use each one is a skill you will build throughout the course.

| When to use | Technique | Example from today |
|---|---|---|
| You don't know the solution | Let the AI ask you questions | Step 5: "I need a local database... ask me questions before you start building" |
| You know exactly what you want | Give a direct, specific prompt | Step 6: "Write a Python script that reads @data/campus_bites_orders.csv and loads it into the orders table" |

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
