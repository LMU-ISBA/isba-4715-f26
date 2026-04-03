# Portfolio Project: Analytics Engineering

You find a real job posting for a junior analytics engineer, data engineer, or data analyst role, something you'd actually apply to. Then you build an end-to-end data pipeline and analytics project that demonstrates you can do what the job requires. The project is worth 30% of your course grade and lives in a public GitHub repo you can show to employers.

## Timeline & Milestones

| Milestone | Due | What's Due |
|---|---|---|
| Proposal | Apr 8 | Proposal PDF, job posting PDF, GitHub repo, Snowflake account |
| M1: Extract & Load | Apr 22 | Both sources extracted and loaded to Snowflake, pipeline diagram |
| M2: Transform & Present | May 4 | dbt models, Streamlit dashboard, RAG chatbot, slides, README, ERD |
| Final Interview | May 11 | Whiteboard walkthrough, project demo |

Your public GitHub repo is your submission. Submit the repo URL to Brightspace by each due date.

## What You're Building

You'll build a pipeline that moves data from two sources into Snowflake, transforms it through raw, staging, and mart layers using dbt, and surfaces it through a Streamlit dashboard and a RAG chatbot, all automated via GitHub Actions.

```
Structured data path:
  API Source → GitHub Actions → Snowflake Raw → dbt Staging → dbt Mart (star schema) → Streamlit Dashboard

Text data path:
  Web Scrape / Documents → GitHub Actions → Snowflake Raw → Cortex Search → Streamlit Chatbot (via Cortex Complete)
```

The dashboard answers "how much" and "what happened" using structured data. The chatbot answers "what does this mean" and "tell me about X" using text data.

## Tech Stack

| Layer | Tool |
|---|---|
| IDE | Cursor |
| AI Development | Claude Code + Superpowers |
| Version Control | Git + GitHub (public repo) |
| Data Warehouse | Snowflake (trial account, AWS US West 2 or US East 1) |
| Transformation | dbt |
| Orchestration | GitHub Actions (scheduled) |
| Dashboard | Streamlit (deployed to Streamlit Community Cloud) |
| RAG Chatbot | Snowflake Cortex Search + Cortex Complete |

These are the same tools from the mini-projects. No new setup required.

## Project Inputs

### Job Posting

Find a real job posting for a junior analytics engineer, data engineer, or data analyst role. Your project must target the skills that posting lists.

Save the posting as a PDF. You'll submit it with your proposal and reference it in your final interview to connect what you built to what the role requires.

### Data Sources

Your pipeline must pull from **2 or more data sources of different types**:

- At least one **API** (REST, GraphQL, or a Python client wrapping one)
- At least one **web scrape or document scrape** (Firecrawl, web scraping APIs, MCP servers, PDFs, and other documents all count)

All sources must be automated via **GitHub Actions on a schedule**. No manual data downloads.

The sources you propose are tentative. You can change them as the project evolves. The proposal just shows you've thought through plausible sources, not that you're committed to them.

## Proposal (10 pts) - Due Apr 8

Submit a structured 1-page proposal (PDF) to Brightspace with these sections: your name, project name, GitHub repo link, job posting summary, problem statement, proposed data sources (tentative), and solution overview. Submit the job posting as a separate PDF.

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 1 | Project proposal + job posting PDF | 5 | Structured 1-page proposal PDF + job posting PDF. Both submitted to Brightspace. |
| 2 | GitHub repo initialized | 3 | Public repo, proper `.gitignore`, directory structure, `CLAUDE.md` with project context |
| 3 | Snowflake account | 2 | Trial account in AWS US West 2 or US East 1 (required for Cortex Search). Credentials stored securely, NOT in repo. Screenshot of account region submitted to Brightspace. |

## M1: Extract & Load (25 pts) - Due Apr 22

Both data sources extracted and loaded to Snowflake. Submit your repo URL to Brightspace.

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 4 | Source 1 extraction + load to Snowflake raw | 10 | Python script, loads to Snowflake raw schema, env vars for credentials, scheduled via GitHub Actions |
| 5 | Source 2 extraction + load to Snowflake raw | 10 | Different source type from source 1. Scheduled via GitHub Actions |
| 6 | Data pipeline diagram | 5 | All layers (sources → raw → staging → mart → dashboard/chatbot), every tool labeled. Open format (Mermaid, draw.io, Excalidraw, etc.). Included in README |

## M2: Transform & Present (65 pts) - Due May 4

Transform your raw data, build the dashboard and chatbot, and polish everything for your portfolio. Submit your repo URL and slides PDF to Brightspace.

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 7 | dbt project (staging + mart models) | 15 | Star schema in Snowflake: staging models with tests, fact table(s) + dimension table(s) for analysis |
| 8 | GitHub Actions pipeline | 5 | All sources automated on a schedule or manual trigger. Graded on pipeline completeness and secrets management. |
| 9 | Streamlit dashboard (deployed) | 15 | Connected to Snowflake mart tables, descriptive + diagnostic analytics, interactive. Public URL |
| 10 | Presentation slides (PDF) | 10 | Descriptive + diagnostic insights, recommendations. Graded on data storytelling principles (see below). Portfolio artifact, not presented in final interview. Submitted as PDF to Brightspace. |
| 11 | RAG chatbot in Streamlit (deployed) | 10 | Cortex Search + Cortex Complete. Answers domain questions from your web-scraped/document corpus. Same Streamlit app, separate tab. Public URL |
| 12 | README.md | 5 | Template provided. Project overview, tech stack, pipeline setup, ERD, pipeline diagram, insights summary |
| 13 | ERD (star schema) | 3 | Generated by Claude Code from dbt models. Fact + dimension tables. Included in README |
| 14 | Commit history + repo structure | 2 | Frequent meaningful commits, clean directory structure |

**Total: 100 points (30% of course grade)**

## Grading

Meeting all minimum requirements earns a B-range grade. An A requires going beyond the minimums with depth, polish, and analytical insight.

| Grade | Description |
|---|---|
| A | Exceeds minimums with depth, polish, and insight. An employer would be impressed by this repo. |
| B | Meets all minimums solidly. Functional and complete but doesn't go beyond. |
| C | Meets most minimums but has gaps: missing tests, shallow analysis, broken deployment. |
| D | Significant gaps: incomplete pipeline, no deployment, minimal effort. |
| F | Not submitted or fundamentally incomplete. |

### Minimum Requirements

Full checklists for the four highest-stakes deliverables. Other deliverables are graded against the descriptions in the milestone tables above.

#### dbt Project (15 pts)

- At least one staging model per source (cleaning, renaming, type casting)
- At least one fact table and at least one dimension table
- Star schema design with relationships between fact and dimension tables
- At least one dbt test passing
- `dbt run` and `dbt test` execute without errors
- Models materialized in Snowflake

#### Streamlit Dashboard (15 pts)

- Connected to Snowflake mart tables
- At least one descriptive analytics view (what happened?)
- At least one diagnostic analytics view (why did it happen?)
- At least one interactive element (filter, selector, or tab)
- Deployed to Streamlit Community Cloud with public URL

#### RAG Chatbot (10 pts)

- Cortex Search service created on web-scraped/document text data
- Cortex Complete used for answer generation
- Working chat UI in Streamlit (`st.chat_input`, `st.chat_message`)
- Returns relevant answers based on the scraped corpus
- Deployed as a tab in the same Streamlit app (public URL)

#### Presentation Slides (10 pts)

- At least one descriptive analytics insight with Takeaway Title and supporting visual
- At least one diagnostic analytics insight with Takeaway Title and supporting visual
- Callout on each visual that highlights the key evidence
- Actionable recommendation: [Action] → [Expected outcome]
- Designed as a portfolio artifact, ready to use in a real job interview

## Quality Rubric

Beyond the minimums, grading rewards quality across these themes:

**Analytical depth:** Are the business questions interesting and relevant to the job posting? Does the diagnostic analysis dig into root causes, or just show another chart? Are the recommendations actionable and specific?

**Technical quality:** Is the star schema well-designed? Are dbt models clean and tested? Does the pipeline handle errors gracefully? Is the code organized and documented?

**Polish and UX:** Is the dashboard layout thoughtful (labels, color, flow)? Is the chatbot responsive and helpful? Are the slides visually clear and story-driven? Would you demo this confidently in a job interview?

**Documentation:** Does the README explain the project clearly to someone seeing it for the first time? Is the pipeline diagram accurate and complete? Does the ERD match the actual dbt models?

## Getting Started

No example projects are provided. Use Claude Code to brainstorm your project idea.

1. Find a real job posting for a junior analytics engineer, data engineer, or data analyst role.
2. Save the job posting as a PDF.
3. Open Claude Code and ask it to help you brainstorm project ideas. Reference the job posting by file path, screenshot, or copy-paste to give it context.
4. Explore: what skills does the role require? What data would demonstrate those skills? What questions would you want to answer?

Your proposal locks in the job posting and project framing, but data sources are tentative and can evolve as you learn more in MPs 2–4.

### Data Storytelling Principles

A refresher from Lesson 05 for the slides deliverable.

- **Takeaway Titles:** State the insight, not the category. "Email delivers 9x more conversions per dollar" not "Marketing Channel Performance." If someone reads only the title, they should know what happened.
- **Callouts:** Circle, arrow, or highlight that draws the eye to the key evidence in the visual.
- **Recommendation format:** [Action] → [Expected outcome]. Specific and actionable. "Shift 40% of display budget to email → projected 200+ additional conversions" not "improve marketing."

## Policies

- **Individual project.** All work must be your own.
- **Late penalty.** 10% deduction per day late.
- **AI usage.** Claude Code is your primary development tool. You are expected and encouraged to use it for scaffolding, debugging, and building. But you must be able to explain every component in your final interview. If you can't explain it, you don't get credit for it.
- **Public repo.** Required. This is a portfolio piece. Employers will see it.
- **No credentials in the repo.** Use `.env` files and `.gitignore`. Environment variables for all secrets. No database passwords, API keys, or Snowflake credentials committed to git.
