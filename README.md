# ISBA 4715: Developing Business Applications Using SQL

**Spring 2026 | Loyola Marymount University**

Welcome to ISBA 4715! The first half of the course teaches SQL for data exploration and analysis. The second half builds end-to-end data pipelines with Claude Code, Snowflake, dbt, GitHub Actions, and Streamlit.

## Quick Links

- [Course Syllabus](https://lmu-isba.github.io/isba-4715-f26/) - Schedule, grading, policies
- [Lessons](lessons/) - Hands-on SQL exercises

## Getting Started

### 1. Install Required Software

| Tool | Purpose | Link |
|------|---------|------|
| DBeaver | Database client for writing SQL | [Download](https://dbeaver.io/download/) |
| Cursor | AI-powered code editor | [Download](https://cursor.sh/) |
| Microsoft Teams | Course communication | [Access](https://www.microsoft.com/microsoft-teams/) |

### 2. Connect to the Database

Connection details will be provided in class. See the [setup guide](lessons/01-introduction/setup-guide.md) for step-by-step instructions.

## Lessons

The first half (Lessons 01–05) teaches SQL through two case studies: **Campus Bites**, a campus food delivery service, and **Basket Craft**, an e-commerce gift basket company. The second half (Lessons 06–11) builds end-to-end data pipelines and a portfolio project.

| Lesson | Topic | Business Question |
|--------|-------|-------------------|
| [01](lessons/01-introduction/) | Problem Analysis | "Orders dropped 20% — what happened?" |
| [02](lessons/02-success-analysis/) | Success Analysis | "Revenue up 33% — what's working?" |
| [03](lessons/03-rfm-joins/) | Customer Intelligence | "Who are our best customers and why?" |
| [04](lessons/04-cte-funnels/) | Conversion Funnels | "Where are we losing visitors in the funnel?" |
| [05](lessons/05-data-storytelling/) | Data Storytelling | "What should the executive team actually do?" |
| [06](lessons/06-local-pipeline/) | MP01: Local Data Pipeline | "Can we build a working pipeline from scratch?" |
| [07](lessons/07-cloud-pipeline/) | MP02: Cloud Pipeline (Snowflake + dbt) | "What if the data lives in a remote database?" |
| [08](lessons/08-api-pipeline/) | MP03: API Data Collection | "What if the data lives behind an API?" |
| [09](lessons/09-scrape-pipeline/) | MP04: Scrape Pipeline + GitHub Actions + Knowledge Base Wiki | "What if the source is a website that changes weekly?" |
| [10](lessons/10-streamlit-dashboard/) | Streamlit Dashboard + Whiteboard Diagram | "How do we share findings with stakeholders?" |
| [11](lessons/11-final-prep/) | Final Interview Prep | "Can you tell the story of your work in an interview?" |

## What You'll Learn

- **SQL for analysis**: Joins, CTEs, window functions, RFM segmentation, conversion funnels, A/B test reads
- **Data engineering**: Local Postgres → cloud (Snowflake + dbt) → API extraction → web scraping, with GitHub Actions for scheduling
- **Working with AI agents**: Cursor, Claude Code, and the Superpowers `brainstorming → writing-plans → executing-plans` loop
- **Data communication**: DC ACT framework, Streamlit dashboards, whiteboard pipeline diagrams, and a portfolio you can walk through in an interview

## Optional References

Available free through the [LMU Library O'Reilly subscription](https://go.oreilly.com/loyola-marymount):

- [Learning SQL, 3rd Edition](https://learning.oreilly.com/library/view/learning-sql-3rd/9781492057604/) by Beaulieu
- [Fundamentals of Data Engineering](https://learning.oreilly.com/library/view/fundamentals-of-data/9781098108298/) by Reis & Housley

## Need Help?

- **Office Hours**: See syllabus for times and location
- **Teams**: Post questions in the class channel
- **Email**: gregory.lontok@lmu.edu
