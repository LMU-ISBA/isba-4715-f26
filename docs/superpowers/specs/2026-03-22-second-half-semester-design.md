# Second Half Semester Design: AI-Augmented Analytics Engineering

## Overview

The second half of ISBA 4715 shifts from SQL analysis to end-to-end data engineering and AI, preparing students to work as analytics engineers who can build the infrastructure and deliver the insights. Students use Claude Code as their primary development tool, learning to direct an AI agent through progressively complex engineering workflows.

The second half consists of four guided mini-projects (which count as lesson exercises), an independent portfolio project, and a final interview.

## Course Goal

To become an AI-augmented analytics engineer: someone who can build a data pipeline, transform raw data into a usable model, deliver insights through a dashboard, and build AI applications on top of it all, using Claude Code as their engineering partner.

## Schedule

12 teaching sessions + 1 finals session. Easter (Apr 1) and Reading Day (May 6) are off.

| Session | Date | Activity | Due |
|---|---|---|---|
| 1 | Mar 23 (Mon) | **MP1 Day 1:** Cursor + Claude Code setup, Docker install + Postgres, load CSV, basic prompting | |
| 2 | Mar 25 (Wed) | **MP1 Day 2:** Git/GitHub workflow, dimensional modeling concepts, query local DB | |
| 3 | Mar 30 (Mon) | **MP2 Day 1:** Install Superpowers, AWS Console + CLI via Claude Code, create own RDS, connect to source RDS | MP1 Tutorial |
| | ~~Apr 1~~ | ~~Easter — No Class~~ | |
| 4 | Apr 6 (Mon) | **MP2 Day 2:** Extract from source RDS, load to Snowflake raw, intro to dbt | |
| 5 | Apr 8 (Wed) | **MP2 Day 3:** dbt staging + mart models in Snowflake, star schema | Project Proposal |
| 6 | Apr 13 (Mon) | **MP3 Day 1:** API extraction with Python, load to Snowflake | MP2 Tutorial |
| 7 | Apr 15 (Wed) | **MP3 Day 2:** GitHub Actions pipeline, Streamlit dashboard basics | |
| 8 | Apr 20 (Mon) | **MP3 Day 3:** Streamlit polish, advanced prompting, deploy to Streamlit Community Cloud | |
| 9 | Apr 22 (Wed) | **MP4 Day 1:** Install spec-kit, web scraping with Python, data cleaning | MP3 Tutorial, Project M1 |
| 10 | Apr 27 (Mon) | **MP4 Day 2:** Vector DB + embeddings, intro to RAG architecture | |
| 11 | Apr 29 (Wed) | **MP4 Day 3:** LangChain + Claude API, build RAG chatbot in Streamlit | |
| 12 | May 4 (Mon) | **Interview Prep:** Whiteboard pipeline practice, mock interviews | MP4 Tutorial, Project M2 |
| 13 | May 11 (Mon) | **Final Interview** (25% of grade) | |

## Grade Breakdown

Assignment 02 has been removed from the syllabus. The 10% is redistributed to the project (+5%) and final interview (+5%).

| Component | Weight |
|---|---|
| 1 Group Assignment | 10% |
| 2 Quizzes (5% each) | 10% |
| 10 Lesson Exercises (1% each) | 10% |
| Midterm Interview | 15% |
| Project | 30% |
| Final Interview | 25% |
| **Total** | **100%** |

## Mini-Projects

### Design Philosophy

Each mini-project is a complete end-to-end cycle that teaches a set of skills through a guided build. The classroom format is instructor-led live coding where students follow along. Each mini-project has an accompanying structured tutorial that students complete on their own if they fall behind or don't finish in class. Tutorial completion is the lesson exercise submission.

Mini-project tutorials count as lesson exercises (1% each). The first half used 5 of the 10 lesson exercises (Lessons 01-05), leaving 5 for the second half. Four come from mini-project tutorials (MP1-MP4) and the 5th is the interview prep session (May 4), where students submit their whiteboard pipeline diagram as practice for the final interview. This totals 10 lesson exercises at 1% each.

### Progression

| MP | Sessions | Source | Destination | Prompting Toolkit | Key Skills |
|---|---|---|---|---|---|
| 1 | 2 | CSV | Docker Postgres | Claude Code basics | Cursor, Claude Code, Docker, Postgres, git, prompting fundamentals |
| 2 | 3 | AWS RDS (instructor's, read-only) | Snowflake | Superpowers | AWS Console + CLI, SQL extraction, dbt, dimensional modeling |
| 3 | 3 | Public API | Snowflake | Superpowers (advanced) | API extraction, GitHub Actions, Streamlit, deployment |
| 4 | 3 | Web scrape | Vector DB | spec-kit | Web scraping, embeddings, RAG chatbot, LangChain, Claude API |

### MP1: Local Pipeline (2 sessions)

Students set up their development environment and build a local data pipeline from CSV to a Dockerized PostgreSQL database. This is the foundation for everything that follows.

**Session 1 covers:**
- Install Cursor (IDE for the rest of the course)
- Install Claude Code (inside Cursor's terminal)
- Install Docker and pull PostgreSQL image
- Enable Claude Code explanatory output style
- Load a CSV file into local Postgres using Claude Code
- Learn basic prompting: one question at a time, reading output, reviewing generated files

**Session 2 covers:**
- Initialize a git repository and push to GitHub
- Understand dimensional modeling concepts (fact vs. dimension tables)
- Query the local database
- Practice the review workflow: read diffs in Cursor, understand what Claude Code built

### MP2: Cloud Pipeline (3 sessions)

Students move from local to cloud infrastructure, connecting to a real database and loading into a data warehouse.

**Session 1 covers:**
- Install Superpowers plugin for Claude Code
- Use /brainstorm before building
- AWS Management Console walkthrough: create own RDS PostgreSQL instance
- AWS CLI setup and usage through Claude Code
- Connect to instructor's read-only RDS (simulating a production source system)

**Session 2 covers:**
- Write extraction scripts to pull from the source RDS
- Set up Snowflake account and create raw schema
- Load extracted data into Snowflake raw layer
- Introduction to dbt: project structure, models, sources

**Session 3 covers:**
- Build dbt staging models (cleaning, renaming, type casting)
- Build dbt mart models (star schema: fact + dimension tables)
- Use /plan for multi-step dbt work
- Run dbt tests for data quality

### MP3: API Pipeline (3 sessions)

Students build a production-grade pipeline from an API to a Streamlit dashboard.

**Session 1 covers:**
- API concepts: endpoints, authentication, pagination, rate limits
- Write Python extraction script for a public API
- Load API data to Snowflake raw layer
- Practice architectural prompting: describe what you want before how

**Session 2 covers:**
- GitHub Actions: workflow files, triggers (manual + cron), secrets management
- Automate the API extraction pipeline
- Streamlit basics: connect to Snowflake, display data, build charts

**Session 3 covers:**
- Streamlit interactive features: filters, selectors, tabs
- Deploy to Streamlit Community Cloud (public URL)
- Advanced Superpowers: code review workflows, verification before completion

### MP4: AI Application (3 sessions)

Students build a RAG chatbot, the capstone that ties data engineering to AI.

**Session 1 covers:**
- Install spec-kit
- Use spec-kit to plan the chatbot system (constitution, spec, plan, tasks)
- Web scraping with Python: requests + BeautifulSoup or similar
- Data cleaning and preparation

**Session 2 covers:**
- Vector database concepts: embeddings, similarity search
- Generate embeddings from project data
- Store in a vector database
- Understand RAG architecture: retrieval + generation

**Session 3 covers:**
- LangChain for orchestrating RAG pipeline
- Claude API integration for generation
- Build chatbot UI in Streamlit (st.chat_input, st.chat_message)
- Deploy updated Streamlit app with chatbot tab

## Prompting Progression

Prompting is a core learning objective, taught progressively across the mini-projects.

| MP | Toolkit | Focus |
|---|---|---|
| MP1 | Claude Code basics | One question at a time, reading output, reviewing files, explanatory output style, CLAUDE.md for project context |
| MP2 | Superpowers | /brainstorm before building, /plan for multi-step work, structured debugging when things break |
| MP3 | Superpowers (advanced) | Code review workflows, dispatching parallel agents, verification before claiming done |
| MP4 | spec-kit | Constitution, specification, plan, tasks, then implement. Full spec-driven development for a complex system |

Students use the explanatory output style throughout so Claude Code teaches as it builds. Students are expected to read Claude Code's output, review generated files in Cursor, and be able to explain every component.

## Independent Project

### Framing

Students find a real job posting for a junior analytics engineer, data engineer, or data analyst role. They build an end-to-end portfolio project that demonstrates they can do the full loop: build the pipeline and deliver the insights. The project is framed as proof of competency for that specific role.

Claude Code is the primary development tool. Students are expected to use it for scaffolding, debugging, and building, but must be able to explain every component in their final interview.

### Deliverables

**Proposal (10 pts) — Due Apr 8**

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 1 | Project proposal + job posting PDF | 5 | 1-page proposal: name, project name, GitHub link, job description, problem, data sources, solution. Job posting saved as PDF. |
| 2 | GitHub repo initialized with Claude Code | 3 | Proper .gitignore, directory structure, CLAUDE.md with project context |
| 3 | Snowflake account + AWS RDS credentials | 2 | Credentials stored securely, NOT committed to repo |

**M1: Extract & Load (20 pts) — Due Apr 22**

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 4 | Source 1 extraction + load to Snowflake raw | 10 | Python script, loads to Snowflake raw schema, environment variables for credentials, code comments |
| 5 | Docker development environment | 5 | docker-compose.yml with local Postgres for development |
| 6 | Data pipeline diagram | 5 | Source, Raw, Staging, Mart, Dashboard flow with tool logos |

**M2: Transform & Present (70 pts) — Due May 4**

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 7 | Source 2 extraction + load to Snowflake raw | 10 | Second data source, different type from source 1 |
| 8 | dbt project (staging + mart models) | 10 | Star schema in Snowflake, staging models with tests, mart models for analysis |
| 9 | GitHub Actions pipeline | 5 | Automated extraction, at least one source on schedule or manual trigger |
| 10 | Streamlit dashboard (deployed, public URL) | 10 | Connected to Snowflake, descriptive + diagnostic analytics, interactive |
| 11 | Presentation slides | 10 | Descriptive analytics insights + diagnostic analytics insights, recommendations, follows DC ACT framework |
| 12 | RAG chatbot in Streamlit (deployed, public URL) | 10 | Chatbot over project data using LangChain + Claude API + vector DB, demoed on phone |
| 13 | README.md | 8 | Project overview, tech stack, setup instructions, ERD, pipeline diagram, insights summary |
| 14 | ERD (star schema) | 5 | Fact + dimension tables, from dbt models or manually created |
| 15 | Commit history + repo structure | 2 | Frequent meaningful commits, clean directory structure |

**Total: 100 points (worth 30% of course grade)**

### Data Sources

Students choose 2+ data sources of different types. Source types learned in mini-projects:
- CSV files (MP1)
- SQL database extraction (MP2)
- API (MP3)
- Web scrape (MP4)

### Project Timeline

| Milestone | Due | Follows MP | What's Due |
|---|---|---|---|
| Proposal | Apr 8 | MP1 complete, MP2 in progress | Proposal, repo, credentials |
| M1: Extract & Load | Apr 22 | MP3 complete | First source loaded, Docker env, pipeline diagram |
| M2: Transform & Present | May 4 | MP4 complete | Second source, dbt, GitHub Actions, Streamlit, slides, chatbot, README, ERD, repo quality |
| Final Interview | May 11 | Interview prep | Whiteboard walkthrough, project demo |

## Final Interview

20 minutes per student, 25% of course grade. Students whiteboard their pipeline, walk through their project, demo the chatbot on their phone, and field follow-up questions.

### Rubric (100 points)

| Section | Points | What's Assessed |
|---|---|---|
| Personal Introduction | 10 | Education, experience, initiative, human connection, smooth transition to project |
| Elevator Pitch | 5 | One sentence: who benefits, problem, solution |
| Job Description Alignment | 5 | Connect project to specific skills in the posting |
| Pipeline Walkthrough | 20 | Whiteboard diagram with all tools labeled (Docker, AWS RDS, Snowflake, dbt, GitHub Actions, Streamlit). Explain data flow end-to-end. |
| dbt & Data Modeling | 10 | Explain star schema decisions, staging vs. mart, why dimensions were chosen |
| Descriptive Analytics Insight | 10 | Business question, SQL, finding, recommendation |
| Diagnostic Analytics Insight | 10 | Anomaly, segmentation, root cause, action |
| RAG Chatbot Demo | 10 | Explain architecture (embeddings, vector DB, retrieval, generation), demo a query on phone via public URL |
| Challenge & Resolution | 5 | One significant obstacle and how they solved it |
| Follow-up Questions | 15 | Decision justification, alternative approaches, trade-offs, production thinking |

### Follow-up Question Categories

- **Design decisions:** "Why Snowflake instead of Postgres for your warehouse?" "Why did you model X as a dimension vs. a fact?"
- **AI workflow:** "How did you use Claude Code to build this? Show me a commit where AI helped. What did you have to fix?"
- **Trade-offs:** "If you had to drop one data source, which and why?" "What would break if your API changed its schema?"
- **Production thinking:** "How would you monitor this pipeline?" "What happens if the GitHub Action fails at 3am?"

## Tech Stack

| Layer | Tool |
|---|---|
| AI Development | Claude Code + Superpowers + spec-kit |
| IDE | Cursor |
| Version Control | Git + GitHub |
| Local Dev | Docker + PostgreSQL |
| Source System (instructor) | AWS RDS PostgreSQL (read-only, pre-loaded dataset) |
| Source System (student) | AWS RDS PostgreSQL (created via Console + CLI) |
| Data Warehouse | Snowflake |
| Transformation | dbt |
| Orchestration | GitHub Actions |
| Visualization + Chatbot | Streamlit (deployed to Streamlit Community Cloud) |
| AI Application | LangChain + Claude API + Vector DB |

## Classroom Format

Each mini-project session follows the same pattern:

1. **Instructor-led live coding** — instructor drives from the front, students follow along on their machines
2. **Structured tutorial** — accompanies each mini-project as a take-home safety net
3. **Tutorial completion** — if students fall behind or don't finish in class, they complete the tutorial on their own before the next session
4. **Tutorial submission** — counts as a lesson exercise (1% of grade)

This design ensures the class always moves forward on schedule. No session spills over into the next because students have the tutorial to catch up independently.

## Pre-Class Setup

Before the first session (Mar 23), students need an email with instructions to:
- Sign up for Claude Code (requires Claude Pro subscription)
- Install Cursor
- Install Docker
- Install MySQL Client (for first-half continuity if needed)

Some students overlap with the capstone course and may have completed parts of this setup already. The email should acknowledge this and direct them to verify their installations rather than reinstall.

Reference: setup instructions from https://github.com/LMU-ISBA/ai-dev-workflow-tutorial/blob/main/v2/pre-work-setup.md

## Changes from Last Year

| Area | Last Year | This Year |
|---|---|---|
| Primary tool | Python notebooks (Jupyter, pandas) | Claude Code + Cursor |
| Database | AWS RDS PostgreSQL only | Docker Postgres (local) + AWS RDS (source) + Snowflake (warehouse) |
| Transformation | Optional, manual SQL | dbt required (staging + marts) |
| Visualization | Student choice (Tableau, Looker, Power BI, etc.) | Streamlit standardized |
| AI application | None | RAG chatbot (LangChain + Claude API + Vector DB) |
| Deliverables | 16 (many redundant per-source) | 15 (consolidated) |
| Presentation | Slide deck PDF (17 pts) | Slides for analytics + Streamlit as live demo + final interview as walkthrough |
| Prompting | Not taught | Core learning objective with progressive toolkit |
| Assignment 02 | 10% of grade | Removed, redistributed to project and final interview |
| Project weight | 27% | 30% |
| Final interview weight | 14% | 25% |
