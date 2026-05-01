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

60 seconds, anchored to `docs/job-posting.pdf`. Hit five targets:

- **Education** — degree, major, relevant coursework
- **Extracurricular or side project showing initiative** — signals you build things on your own
- **Relevant work or internship** — experience that maps to the JD's expectations
- **One personal tidbit** — a human detail that makes you memorable
- **Segue into the project** — one-sentence bridge into your portfolio project

### Project

14 minutes, 85 points. You lead. Cover eight elements in order:

1. **Elevator pitch** — one sentence: who you're helping, what problem, how you're solving it
2. **Connection to your portfolio JD** — why this project, why this role, what skills overlap
3. **Pipeline whiteboard walk** — draw and narrate both pipelines: API → Snowflake → dbt staging → mart, plus scrape → `knowledge/raw/` → wiki. Label tools, schema, and table names.
4. **Technical deep dive** — four sub-segments:
   - **Data ingestion and automation:** API + Firecrawl scrape, GitHub Actions schedule + manual trigger, secrets handling
   - **Modeling and warehouse setup:** Snowflake raw → dbt staging → mart, star schema, one dbt test
   - **Knowledge base demo (required):** Run Claude Code live against `knowledge/wiki/`. Query something only in `knowledge/raw/`. Defend the source citation. Skipping it costs points.
   - **Streamlit dashboard sketch (optional):** Sketch panes on the whiteboard — descriptive, diagnostic, interactive. No live demo expected.
5. **Insights** — 1–2 specific insights and the business decisions they inform
6. **One significant challenge** and how you overcame it
7. **One future improvement** and why it matters
8. **One lesson learned** that transfers to future projects

### Follow-ups + Wrap

- **Common follow-up patterns:** "why X over Y?" (defend a technical decision); scale hypothetical ("what breaks at 100× volume?"); prioritization logic ("what slipped first when time got tight?")
- **Wrap:** Closes with confirmation that `docs/resume.pdf` is committed to your portfolio repo by May 11.

## §05 Practice Prompts (rehearse with Claude Code)

These prompts turn Claude Code into a rehearsal partner against your actual repo and your portfolio JD. Paste them into a Claude Code session opened in your portfolio repo. The `@` references load files into context — they only work if the file exists at the path shown.

Note: the prompts below reference `@docs/job-posting.pdf`. If your JD is saved as a different format (`.md`, `.txt`), update the path before pasting.

---

### §05.a — TMAY rehearsal

Use this when: you need to draft or tighten your 60-second intro before you practice it out loud.

```text
Load @docs/job-posting.pdf and @docs/resume.pdf (or @docs/scratch/resume.md if you're
working from a draft). You are a hiring manager interviewing me for the role in the JD.

Start the interview now: ask me "Tell me about yourself."

After I type my response, score me on three things:
1. Did it hit all five targets — education, extracurricular/initiative, relevant work or
   internship, one personal tidbit (human connection), and a segue into my project?
2. Is it 60 seconds or under when spoken aloud at a natural pace?
3. Does it use at least two stack words or phrases that appear in the JD?

Give me one specific sentence to cut or rewrite, then ask me to try again.
```

---

### §05.b — Whiteboard pipeline rehearsal

Use this when: you want to practice narrating your pipeline with realistic follow-up interruptions, before you're standing at the whiteboard in Hilton 114.

```text
Load @README.md, @knowledge/wiki/, and @docs/job-posting.pdf.
Also load @dbt/ or @models/ if either directory exists in this repo.
(If neither directory exists in your repo — e.g., your dbt models live somewhere else like @transform/ or @analytics/ — replace this line with the actual path before pasting, or remove it.)

You are a technical interviewer. I'm going to narrate my pipeline as if I'm at
the whiteboard. After each segment I describe — API → Snowflake, dbt staging →
mart, scrape → wiki — interrupt me with one realistic follow-up question tied to
a responsibility or skill listed in the JD.

After I finish the full walkthrough, give me three questions you'd expect a real
interviewer to ask for this specific role, based on what's in the JD and what
gaps you noticed in my narration.

Start by saying "Go ahead — walk me through your pipeline from the beginning."
```

---

### §05.c — Component drill on any pipeline layer

Use this when: you want to pressure-test your understanding of one specific piece of the repo before the interview.

```text
Find the files in this repo related to <COMPONENT>.
(Replace <COMPONENT> with the piece you want to drill — for example:
"GitHub Actions schedule," "dbt staging model," "Firecrawl scrape script,"
"Snowflake raw table schema," or "knowledge base wiki structure.")

Ask me five questions a senior data engineer would ask about that component:
1. What does it do?
2. Why did I choose this approach over an obvious alternative?
3. What's a realistic failure mode?
4. What would I change with more time?
5. What does the output flow into downstream?

After each answer, point to the specific file or section where my answer can
be verified — or flag if my answer doesn't match what's actually in the repo.
```

---

### §05.d — Full mock interview (the take-home rehearsal)

Use this when: you want to run the complete 20-minute interview structure before your Calendly slot. Run this at least once between May 5 and May 10.

```text
Load @docs/job-posting.pdf, @README.md, @knowledge/wiki/, and @CLAUDE.md.

You are a hiring manager conducting a 20-minute data engineer interview.
Run the full structure in sequence:

1. Open with "Tell me about yourself." After I answer, score my TMAY on the
   five targets (education, initiative, relevant work, personal tidbit, segue)
   and tell me one thing to improve before moving on.

2. Transition to "Tell me about your project." Anchor your follow-up questions
   to the responsibilities and skills listed in the JD. Probe my pipeline with
   at least three follow-up questions during the 14-minute project section.

3. Ask me to demo the knowledge base: give me a question whose answer should
   only appear in knowledge/raw/ (not just the wiki summary). I'll run Claude
   Code against the wiki and report back what it returns.

4. Close with three follow-up questions — one on prioritization logic, one on
   an alternative approach I considered and rejected, one on what breaks first
   at 10× data volume.

5. After I answer all three, score me using the A/B/C/D/F descriptor rubric:
   A = ready to hire, B = strong with minor gaps, C = adequate but uneven,
   D/F = substantial gaps. Give one sentence of justification for each phase
   (TMAY, pipeline walkthrough, KB demo, follow-ups).

Start now with TMAY.
```

---

### §05.e — Knowledge base demo dry run

Use this when: you want to verify that your wiki is queryable end-to-end before the interview — ideally by May 4 so any issues surface while help is still available.

```text
Load @knowledge/wiki/ and @knowledge/raw/.

Run a five-step diagnostic on my knowledge base:

1. List every file in knowledge/wiki/ and every file in knowledge/raw/.
2. Identify three facts that appear in knowledge/raw/ source files but are not
   yet reflected in any knowledge/wiki/ page.
3. Pick one of those facts and query the wiki for it as if you were the
   interviewer asking a live question. Report exactly what the wiki returns
   and whether the answer cites a knowledge/raw/ source.
4. If the wiki can't answer the question, identify what's missing — is it a
   gap in the wiki page, a missing schema entry in CLAUDE.md, or a raw source
   that was never ingested?
5. Output a 5-line troubleshooting checklist I can run on the morning of my
   interview to confirm the KB is ready.
```

Note: if this prompt fails on May 4, that's why class Part 07 exists — bring it to the live-fire session.

---

### §05.f — Resume polish

Use this when: you want targeted edits before committing `docs/resume.pdf` by May 11.

```text
Load @docs/job-posting.pdf and @docs/resume.pdf
(or @docs/scratch/resume.md if you're working from a draft).

Review my resume against the JD and give me:
1. Three specific edits — quote the exact phrase in my current resume and the
   replacement wording. Focus on bullets that undersell a relevant skill or
   use vague language where the JD is specific.
2. One bullet to add, with proposed wording, that surfaces work my resume
   currently understates relative to the JD's requirements.
3. Three stack words or phrases from the JD that should appear at least once
   in my resume but currently don't.
```
