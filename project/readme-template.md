# [Your Project Name]

<!-- Replace this paragraph with your own. Explain: what business problem does this project address, what data sources does it pull from, and what insights or outputs does it deliver? Aim for 3-5 sentences. -->

[One paragraph: what problem does this project solve, what data sources does it use, and what insights does it deliver?]

## Job Posting

**Role:** [Job title]  
**Company:** [Company name]  
**Link:** [URL to original posting]

<!-- In 1-2 sentences, explain why you picked this role and how your project demonstrates the skills listed in the posting. -->

[1-2 sentences on why you chose this role and how your project demonstrates the required skills.]

## Tech Stack

| Layer | Tool |
|---|---|
| Data Warehouse | Snowflake |
| Transformation | dbt |
| Orchestration | GitHub Actions |
| Dashboard | Streamlit |
| RAG Chatbot | Snowflake Cortex Search + Cortex Complete |

## Pipeline Diagram

<!-- Insert your pipeline diagram here (image or Mermaid). Show all layers: sources → raw → staging → mart → dashboard/chatbot. Label every tool. -->

## ERD (Star Schema)

<!-- Insert your ERD here (image or Mermaid). Show fact and dimension tables with relationships. -->

## Key Insights

### Descriptive Analytics

<!-- What happened? Summarize your main finding with a Takeaway Title. -->

### Diagnostic Analytics

<!-- Why did it happen? Summarize your root cause analysis. -->

### Recommendation

<!-- [Action] → [Expected outcome] -->

## Setup & Reproduction

### Prerequisites

<!-- List what someone needs to run your pipeline: Python version, Snowflake account type, required CLI tools, etc. -->

### Environment Variables

<!-- List all required environment variables below. DO NOT include actual values. Those stay in your local .env file, which is gitignored. -->

Copy `.env.example` to `.env` and fill in your credentials:

    SNOWFLAKE_ACCOUNT=
    SNOWFLAKE_USER=
    SNOWFLAKE_PASSWORD=
    SNOWFLAKE_DATABASE=
    SNOWFLAKE_SCHEMA=
    SNOWFLAKE_WAREHOUSE=

### Running the Pipeline

<!-- Step-by-step instructions to reproduce your extraction and loading pipeline. Number each step. -->

## Dashboard

**Live URL:** [Streamlit Community Cloud URL]

## Repository Structure

<!-- Update this tree if your structure differs from the template. -->

    .
    ├── .github/workflows/    # GitHub Actions pipeline
    ├── extract/              # Extraction scripts
    ├── dbt_project/          # dbt models and tests
    ├── streamlit_app/        # Dashboard + chatbot
    ├── data/                 # Sample data (if applicable)
    ├── docs/                 # Proposal, job posting, pipeline diagram, ERD, slides
    ├── .env.example          # Required environment variables
    ├── .gitignore
    ├── CLAUDE.md             # Project context for Claude Code
    └── README.md             # This file
