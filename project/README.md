# Portfolio Project: Analytics Engineering

You find a real job posting for a junior analytics engineer, data engineer, or data analyst role — something you'd actually apply to. Then you build an end-to-end data pipeline and analytics project that demonstrates you can do what the job requires. The project is worth 30% of your course grade and lives in a public GitHub repo you can show to employers.

## Timeline & Milestones

| Milestone | Due | What's Due |
|---|---|---|
| Proposal | Apr 8 | Proposal PDF, job posting PDF, GitHub repo, Snowflake account |
| M1: Extract & Load | Apr 22 | Both sources extracted and loaded to Snowflake, pipeline diagram |
| M2: Transform & Present | May 4 | dbt models, Streamlit dashboard, RAG chatbot, slides, README, ERD |
| Final Interview | May 11 | Whiteboard walkthrough, project demo |

Your public GitHub repo is your submission. Submit the repo URL to Brightspace by each due date.

## What You're Building

You'll build a pipeline that moves data from two sources into Snowflake, transforms it through raw, staging, and mart layers using dbt, and surfaces it through a Streamlit dashboard and a RAG chatbot — all automated via GitHub Actions.

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

## Proposal (10 pts) — Due Apr 8

## M1: Extract & Load (25 pts) — Due Apr 22

## M2: Transform & Present (65 pts) — Due May 4

## Grading

## Quality Rubric

## Getting Started

## Policies
