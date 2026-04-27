# Lessons

## First Half: SQL Analysis

Hands-on SQL lessons using two case studies: **Campus Bites** (a campus food delivery service) and **Basket Craft** (an e-commerce gift basket company).

| Lesson | Topic | Scenario |
|--------|-------|----------|
| [01-introduction](01-introduction/) | Problem Analysis | "Orders dropped 20%" |
| [02-success-analysis](02-success-analysis/) | Success Analysis | "Revenue up 33%" |
| [03-rfm-joins](03-rfm-joins/) | RFM Analysis with JOINs | "Who are our best customers?" |
| [04-cte-funnels](04-cte-funnels/) | Website Conversion with CTEs | "Did our A/B tests work?" |
| [05-data-storytelling](05-data-storytelling/) | Data Storytelling | "Allocate $100K across 4 channels" |

## Second Half: Data Engineering Mini-Projects

End-to-end data engineering projects built with Claude Code. Each mini-project is instructor-led in class with a take-home tutorial as a safety net.

| Lesson | Sessions | Topic | Source | Destination |
|-------------|----------|-------|--------|-------------|
| [MP01: 06-local-pipeline](06-local-pipeline/) | 2 | Local Data Pipeline | CSV | Docker PostgreSQL |
| [MP02: 07-cloud-pipeline](07-cloud-pipeline/) | 4 | Cloud Pipeline | AWS RDS | Snowflake + dbt |
| [MP03: 08-api-pipeline](08-api-pipeline/) | 1 | API Data Collection | Public API | CSV (portfolio repo extends to Snowflake raw) |
| [MP04: 09-scrape-pipeline](09-scrape-pipeline/) | 2 | Scrape Pipeline + GitHub Actions + Knowledge Base Wiki | Web Scrape | knowledge/raw/ + knowledge/wiki/ |
| Lesson 10: 10-streamlit-dashboard *(Wed Apr 29)* | 1 | Streamlit Dashboard | Snowflake mart | Streamlit Community Cloud |

## The Campus Bites Story (Lessons 01-02)

Campus Bites is a food delivery service for college students. You'll use SQL to analyze real business problems:

### Lesson 01: Problem Analysis
The CEO says orders dropped 20% in October. Your mission: find out what happened and recommend a fix.

### Lesson 02: Success Analysis
Revenue jumped 33% in May. Your mission: find out what's working and how to replicate it.

## The Basket Craft Story (Lessons 03-04)

Basket Craft is an e-commerce company selling gift baskets online. You'll use JOINs, window functions, and CTEs to answer stakeholder questions:

### Lesson 03: RFM Analysis with JOINs
Robert (VP of Marketing) needs a targeted marketing list. Your mission: score customers by Recency, Frequency, and Monetary value using multi-table JOINs and NTILE.

### Lesson 04: Website Conversion Analysis with CTEs
Cheryl (E-commerce Manager) needs to understand visitor behavior. Your mission: build conversion funnels and measure A/B test results using CTEs and ROW_NUMBER.

## Getting Started

**First half (Lessons 01-05):**
1. Install [DBeaver Community Edition](https://dbeaver.io/download/)
2. Follow the [setup guide](01-introduction/setup-guide.md)
3. Start with [Lesson 01](01-introduction/)

**Second half (Mini-Projects 06+):**
1. Install Cursor, Claude Code, and Docker (covered in class)
2. Start with [Mini-Project 01](06-local-pipeline/)

## File Structure

**First half** lessons contain:

| File | Description |
|------|-------------|
| `README.md` | Lesson overview and objectives |
| `lesson-XX-fname-lname.sql` | Student worksheet (rename with your name) |
| `setup-guide.md` | Setup instructions (Lesson 01 only) |

**Second half** mini-projects contain:

| File | Description |
|------|-------------|
| `README.md` | Mini-project overview, scenario, and pipeline diagram |
| `mpX-tutorial.md` | Step-by-step tutorial (the lesson exercise) |
| `data/` | Any data files needed for the mini-project |

## Concepts Covered

### First Half: SQL Analysis

| Lesson | Concepts |
|--------|----------|
| 01 | SELECT, FROM, WHERE, COUNT, SUM, AVG, GROUP BY, ORDER BY, CASE WHEN, LAG() |
| 02 | Same concepts applied to growth analysis, multi-level segmentation |
| 03 | INNER JOIN, LEFT JOIN, subqueries, NTILE(), RFM customer segmentation |
| 04 | CTEs (WITH...AS), ROW_NUMBER(), MAX(CASE WHEN), conversion funnels, A/B testing |
| 05 | Data storytelling, DC ACT communication, takeaway titles |

### Second Half: Data Engineering + AI

| Lesson | Concepts |
|--------|----------|
| MP01 | Cursor, Claude Code, Docker, PostgreSQL, git, psql, AI prompting |
| MP02 | Superpowers brainstorming, AWS RDS, AWS CLI, Snowflake, dbt (staging + marts), dimensional modeling |
| MP03 | REST APIs, JSON parsing, `requests` + pandas, `.env` secrets pattern |
| MP04 | Web scraping (Firecrawl + MCP), GitHub Actions (`workflow_dispatch` + `schedule`), Superpowers loop (brainstorming → writing-plans → executing-plans), CLAUDE.md schema (ingest / query / lint), iterative wiki maintenance |
| Lesson 10 | Streamlit (descriptive + diagnostic views, deployment to Community Cloud), whiteboard pipeline diagrams |

## The Analytics Framework

All lessons use the DC ACT framework:

1. **Define** the business problem
2. **Collect** and prepare the data
3. **Analyze** the data and generate insights
4. **Communicate** insights, recommendations, and predictions
5. **Act** and track the change
