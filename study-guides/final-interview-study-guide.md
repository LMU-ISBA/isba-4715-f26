# Final Interview Study Guide

**Course:** ISBA 4715 — Developing Business Applications Using SQL
**Assessment:** Data Engineer Interview (25% of course grade, 100 points)
**Format:** In-person, Hilton 114 (instructor's office), 20-minute Calendly slot
**Window:** Finals week 2026 (Calendly link distributed in class)
**Companion deliverable:** `docs/resume.pdf` due May 11

---

<!-- SECTION INDEX (delete before publishing)
01 Premise
02 Rubric
03 Your Job Description
04 Structure and Questions
05 Practice Prompts (rehearse with Claude Code)
06 Cheat sheet as contract
07 Study Material
08 Study Tips
09 Interview Tips
10 Last Tips
-->

## §01 Premise

The Data Engineer Interview simulates the final stage of a real hiring process: you walk into the room, go to the whiteboard, and defend your portfolio project against a role you've been targeting all semester. This is not a quiz — it is a conversation about work you actually built, evaluated against the job description you will find in §03. The goal is the same as any technical interview: show that you understand what you built, why you built it that way, and what it means for the business.

## §02 Rubric

The project is the assessment; TMAY is a quick on-ramp that gets you into the room.

| Section | Points | What's assessed |
|---|---|---|
| TMAY | 15 | Tailored to the portfolio JD: education, initiative, relevant experience, human connection, segue into project. Concise (≤1 minute), confident, structured. |
| Project | 85 | Pipeline accuracy and completeness, technical defensibility, KB demo works, insights are specific and actionable, story arc is clean (beginning → middle → end), challenge/improvement/lesson all addressed. |
| **Total** | **100** | |

| Grade | Criteria |
|---|---|
| **A** | Exceptional — clear mastery of problem-solving, business insight, technical depth, and communication. Ready to lead without hand-holding. *"I'm impressed. Let's hire this candidate."* |
| **B** | Strong — meets all core requirements and shows growth potential. Only minor gaps. *"Good enough but I'd want them in for another interview."* |
| **C** | Adequate — satisfies basic criteria but skills are uneven. Would require mentoring. *"I have reservations, but they might be coachable."* |
| **D / F** | Underperforming — fell significantly short of expectations. Substantial improvement needed before being considered for the role. *"Hard pass."* |

### Hints

The instructor leading you through your own repo is dialogue, not a hint. A hint is when the instructor supplies the answer to a defensibility question.

- **One free hint** across the entire project section (not per sub-segment)
- Each additional hint after the first: **−3 pts within the project's 85**
- **AI ownership:** if you cannot distinguish what you wrote from what AI scaffolded, the relevant component scores at most 50% of its weight

## §03 Your Job Description

The single source of truth for both questions is the job posting at `docs/job-posting.pdf` in your portfolio repo — the role you've been targeting all semester. Both TMAY and the project deep-dive are anchored to this JD: TMAY tailors who you are to this role; the project section tailors what you built to this role. If you've pivoted to a different target role since selecting your portfolio JD, swap `docs/job-posting.pdf` to the new posting and re-run the Practice Prompts in §05 against the updated file before May 11.

## §04 Structure and Questions

| Phase | Time | What happens |
|---|---|---|
| **Setup** | 0:00–1:00 | Arrive at Hilton 114. Lay laptop on the desk, open repo in Cursor with Claude Code session ready, open `docs/job-posting.pdf`. This is the only JD in the room. |
| **TMAY** (15 pts) | 1:00–2:00 | "Tell me about yourself." 60 seconds tailored to your portfolio JD. |
| **Project** (85 pts) | 2:00–16:00 | "Tell me about your project." Go to the whiteboard. Draw and narrate the pipeline. Embed the KB demo. Tell the full story. |
| **Follow-ups + Wrap** | 16:00–20:00 | Instructor probes prioritization logic, alternative approaches, hypothetical scenarios. Closing feedback. Resume confirmation. |

### TMAY

TMAY is 60 seconds, anchored to the role in `docs/job-posting.pdf`. This is not a generic intro — every sentence should connect who you are to why you fit that specific role. Draft it against your portfolio JD, then practice it until you can deliver it without notes.

Your TMAY should hit five targets:

- **Education** — degree, major, relevant coursework
- **Extracurricular or side project showing initiative** — something that signals you build things on your own
- **Relevant work or internship** — direct experience that maps to the JD's expectations
- **One personal tidbit** — a human detail that makes you memorable
- **Segue into the project** — a one-sentence bridge that lands naturally on your portfolio project ("…which is exactly what led me to build…")

### Project

The project section is 14 minutes and 85 points. You lead. Cover the following eight elements in roughly this order:

1. **Elevator pitch** — one sentence: who you're helping, what problem you're solving, how you're solving it
2. **Connection to your portfolio JD** — why this project, why this role, what skills overlap
3. **Pipeline whiteboard walk** — draw and narrate both pipelines: API → Snowflake → dbt staging → mart, plus scrape → `knowledge/raw/` → wiki. Label tools. Label schema and table names. Both pipelines must be covered.
4. **Technical deep dive** — four sub-segments:
   - **Data ingestion and automation:** API extraction script, web scrape via Firecrawl, GitHub Actions schedule + manual triggers, secrets handling
   - **Modeling and warehouse setup:** AWS RDS (if used), Snowflake raw → dbt staging → mart, star schema (fact + dimension tables), one dbt test
   - **Knowledge base demo (required):** Run Claude Code live against `knowledge/wiki/`. Ask a question whose answer is only in `knowledge/raw/`. Defend the answer's source citation. Not demonstrating it costs points within the 85.
   - **Streamlit dashboard sketch (optional):** At your discretion, sketch the dashboard's panes on the whiteboard — descriptive view, diagnostic view, interactive element. No live demo is expected.
5. **Insights** — 1–2 specific insights from the dashboard with the stakeholder business decisions they inform
6. **One significant challenge** and how you overcame it
7. **One future improvement** and why it matters
8. **One lesson learned** that transfers to future projects

Follow-up questions can land anywhere across the 14 minutes. See the next subsection for common patterns.

### Follow-ups + Wrap

The final four minutes shift from your narration to the instructor probing the edges. Common patterns: "why did you choose X over Y?" presses you to defend a technical decision; scale hypotheticals ("if data volume grew 100×, what breaks?") test whether you understand the limits of your architecture; prioritization logic ("which milestone slipped first when time got tight?") surfaces honest project management judgment. Answer directly — hedge less, defend more. The wrap closes with confirmation that `docs/resume.pdf` is committed to your portfolio repo by May 11.
