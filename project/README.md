# Portfolio Project: Analytics Engineering

You find a real job posting for a role you'd actually apply to, then build an end-to-end data pipeline and analytics project that demonstrates you can do what the job requires. The project is worth 30% of your course grade and lives in a public GitHub repo you can show to employers.

## Timeline & Milestones

| Milestone | Due | What's Due |
|---|---|---|
| Proposal | Apr 13 at 9:55 AM | Proposal PDF, job posting PDF, GitHub repo, Snowflake account |
| Milestone 01: Extract, Load & Transform | Apr 27 at 9:55 AM | API source loaded, dbt models, GitHub Actions pipeline, pipeline diagram |
| Milestone 02: Present & Polish | May 4 at 9:55 AM | Web scrape source loaded, Streamlit dashboard, knowledge base, slides, README, ERD |
| Final Interview | May 11 | Whiteboard walkthrough, project demo |

Your public GitHub repo is your submission. Submit the repo URL to Brightspace by each due date.

## What You're Building

You'll build a pipeline that moves data from two sources into Snowflake, transforms it through raw, staging, and mart layers using dbt, and surfaces it through a Streamlit dashboard, all automated via GitHub Actions. You'll also scrape domain content and use Claude Code to build a knowledge base of synthesized insights.

```mermaid
flowchart TB
    subgraph s1 [Structured Data Path]
        direction LR
        A[API Source] --> B[GitHub Actions] --> C[Snowflake Raw] --> D[dbt Staging] --> E[dbt Mart\nstar schema] --> F[Streamlit Dashboard]
    end

    subgraph s2 [Knowledge Base Path]
        direction LR
        G[Web Scrape / Documents] --> H[GitHub Actions] --> I[Raw Sources\nin repo] --> J[Claude Code] --> K[Knowledge Base\nwiki pages]
    end

    s1 ~~~ s2
```

The **dashboard** answers "how much" and "what happened" using structured data from your star schema.

The **knowledge base** has two layers that work together:

1. **The artifact:** A set of Claude Code-generated wiki pages in your repo that synthesize insights from your scraped sources. The wiki compounds knowledge over time as you add more sources.
2. **The interface:** Claude Code itself. You ask questions like "what does my knowledge base say about X?" and Claude Code reads the wiki pages and raw sources to answer. No deployed chatbot needed. You demo this in your final interview by running Claude Code live against your repo.

Think of the wiki as your database and Claude Code as your query engine. The wiki is portable: you could later plug it into NotebookLM, ChatGPT projects, or any other LLM and it would still work.

## Tech Stack

| Layer | Tool |
|---|---|
| IDE | [Cursor](https://www.cursor.com) |
| AI Development | [Claude Code](https://code.claude.com/docs/en/overview) + [Superpowers](https://github.com/obra/superpowers) |
| Version Control | [Git](https://git-scm.com) + [GitHub](https://github.com) (public repo) |
| Data Warehouse | [Snowflake](https://www.snowflake.com) (trial account, AWS US East 1) |
| Transformation | [dbt](https://www.getdbt.com) |
| Orchestration | [GitHub Actions](https://docs.github.com/en/actions) (scheduled) |
| Dashboard | [Streamlit](https://streamlit.io) (deployed to Streamlit Community Cloud) |
| Knowledge Base | [Claude Code](https://code.claude.com/docs/en/overview) (scrape → summarize → query) |

These are the same tools from the mini-projects. No new setup required.

## Your Job Posting & Data Sources

### Job Posting

Find a real job posting for a junior analytics engineer, data engineer, or data analyst role. Your project must target the skills that posting lists.

Save the posting as a PDF. You'll submit it with your proposal and reference it in your final interview to connect what you built to what the role requires.

### Data Sources

Your pipeline must pull from **2 or more data sources of different types**:

- At least one **API** (REST, GraphQL, or a Python client wrapping one)
- At least one **web scrape or document scrape** (Firecrawl, web scraping APIs, MCP servers, PDFs, and other documents all count)

All sources must be automated via **GitHub Actions on a schedule**.

The sources you propose are tentative. You can change them as the project evolves. The proposal just shows you've thought through plausible sources, not that you're committed to them.

## Proposal (10 pts) - Due Mon, Apr 13 at 9:55 AM

Use the [proposal template](proposal-template.md) to create your 1-page proposal. Export it as a PDF. Save the job posting as a separate PDF. Commit both to `docs/` in your repo. Submit your repo URL to Brightspace.

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 1 | Project proposal + job posting PDF | 5 | Structured 1-page proposal PDF (`docs/proposal.pdf`) + job posting PDF (`docs/job-posting.pdf`). Both committed to your repo. |
| 2 | GitHub repo initialized | 3 | Public repo, proper `.gitignore`, directory structure, `CLAUDE.md` with project context |
| 3 | Snowflake account | 2 | Trial account in AWS US East 1. Credentials stored securely, NOT in repo. Screenshot of account region in `docs/`. |

## Milestone 01: Extract, Load & Transform (35 pts) - Due Apr 27 at 9:55 AM

API source extracted, loaded to Snowflake, and transformed through dbt. Submit your repo URL to Brightspace.

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 4 | Source 1 (API) extraction + load to Snowflake raw | 10 | Python script, loads to Snowflake raw schema, env vars for credentials, scheduled via GitHub Actions |
| 5 | dbt project (staging + mart models) | 15 | Star schema in Snowflake: staging models with tests, fact table(s) + dimension table(s) for analysis |
| 6 | GitHub Actions pipeline | 5 | Source 1 automated on a schedule or manual trigger. Graded on pipeline completeness and secrets management. |
| 7 | Data pipeline diagram | 5 | All layers (sources → raw → staging → mart → dashboard + knowledge base), every tool labeled. Open format (Mermaid, draw.io, Excalidraw, etc.). Included in README |

## Milestone 02: Present & Polish (55 pts) - Due May 4 at 9:55 AM

Add your second data source, build the dashboard and knowledge base, and polish everything for your portfolio. Submit your repo URL and slides PDF to Brightspace.

| # | Deliverable | Pts | Details |
|---|---|---|---|
| 8 | Source 2 (web scrape/docs) extraction + load to Snowflake raw | 10 | Different source type from source 1. Scheduled via GitHub Actions. |
| 9 | Streamlit dashboard (deployed) | 15 | Connected to Snowflake mart tables, descriptive + diagnostic analytics, interactive. Public URL |
| 10 | Presentation slides (PDF) | 10 | Descriptive + diagnostic insights, recommendations. Graded on data storytelling principles (see Minimum Requirements). Portfolio artifact, not presented in final interview. Submitted as PDF to Brightspace. |
| 11 | Knowledge base | 10 | Use Claude Code to ingest scraped sources into a `knowledge/` folder. At least 15 raw sources from 3+ different sites/authors in `knowledge/raw/`. Claude Code-generated wiki pages in `knowledge/wiki/` (overview, key entities, themes), plus an `index.md`. Queryable via Claude Code in your final interview demo. |
| 12 | README.md | 5 | Use the [README template](readme-template.md). Project overview, tech stack, pipeline setup, ERD, pipeline diagram, insights summary |
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

#### Knowledge Base (10 pts)

- At least 15 scraped sources in `knowledge/raw/` from at least 3 different sites or authors
- Claude Code-generated wiki pages in `knowledge/wiki/` (at least 3 pages: overview, key entities or themes, and one synthesis page)
- `knowledge/index.md` listing all wiki pages with one-line summaries
- Wiki pages show synthesis across multiple sources, not just individual summaries
- Evidence of iterative use: sources were ingested and wiki pages were updated over time (visible in commit history)
- `CLAUDE.md` includes a section explaining how to query the knowledge base (the conventions Claude Code should follow when answering questions about it)
- Demoable: in your final interview, you can run Claude Code against your repo and ask it a question that pulls from your wiki pages

#### Presentation Slides (10 pts)

- At least one descriptive analytics insight with Takeaway Title and supporting visual
- At least one diagnostic analytics insight with Takeaway Title and supporting visual
- Callout on each visual that highlights the key evidence
- Actionable recommendation: [Action] → [Expected outcome]
- Designed as a portfolio artifact, ready to use in a real job interview

**Data Storytelling Principles (Lesson 05 refresher):**

- **Takeaway Titles:** State the insight, not the category. "Email delivers 9x more conversions per dollar" not "Marketing Channel Performance." If someone reads only the title, they should know what happened.
- **Callouts:** Circle, arrow, or highlight that draws the eye to the key evidence in the visual.
- **Recommendation format:** [Action] → [Expected outcome]. Specific and actionable. "Shift 40% of display budget to email → projected 200+ additional conversions" not "improve marketing."

### Quality Rubric

Beyond the minimums, grading rewards quality across these themes:

**Analytical depth:** Are the business questions interesting and relevant to the job posting? Does the diagnostic analysis dig into root causes, or just show another chart? Are the recommendations actionable and specific?

**Technical quality:** Is the star schema well-designed? Are dbt models clean and tested? Is the pipeline reliable and well-organized? Is the code documented?

**Polish and UX:** Is the dashboard layout thoughtful (labels, color, flow)? Does the knowledge base surface genuine insights from the scraped sources? Are the slides visually clear and story-driven? Would you demo this confidently in a job interview?

**Documentation:** Does the README explain the project clearly to someone seeing it for the first time? Is the pipeline diagram accurate and complete? Does the ERD match the actual dbt models?

## Getting Started

No example projects are provided. Use Claude Code with the Superpowers brainstorming skill to develop your project idea.

1. Find and save your job posting as a PDF.
2. Open Claude Code and ask it to help you brainstorm project ideas. The Superpowers brainstorming skill will guide you through a structured conversation. Reference the job posting by file path, screenshot, or copy-paste to give it context.
3. Explore: what skills does the role require? What data would demonstrate those skills? What questions would you want to answer?

Your proposal locks in the job posting and project framing, but data sources are tentative and can evolve as you learn more in Mini-Projects 02-04.

## Policies

- **Individual project.** All work must be your own.
- **Late penalty.** 10% deduction per day late.
- **AI usage.** Claude Code is your primary development tool. You are expected and encouraged to use it for scaffolding, debugging, and building. But you must be able to explain every component in your final interview. If you can't explain it, you don't get credit for it.
- **Public repo.** This is a portfolio piece. Employers will see it.
- **No credentials in the repo.** Use `.env` files and `.gitignore`. Environment variables for all secrets. No database passwords, API keys, or Snowflake credentials committed to git.
