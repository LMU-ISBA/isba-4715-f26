# Lesson 11: Final Interview Prep

In-class clinic for your final interview on Mon May 11, Tue May 12, or Wed May 13. We rehearse the two questions you'll be asked: "Tell me about yourself" and "Tell me about your project."

- **Schedule:** book your 20-min interview slot at [calendly.com/greg-lontok/sql-final-interview](https://calendly.com/greg-lontok/sql-final-interview) (Mon May 11, Tue May 12, or Wed May 13)
- **Walk in with:** your portfolio repo open in Claude Code (Cursor), `docs/job-posting.pdf` open, and your M02 pipeline diagram pulled up.
- **Read first:** the [final interview study guide](../../study-guides/final-interview-study-guide.md). Practice prompts live in section 05.
- **Walk out with:** a "Tell me about yourself" delivered out loud and a pipeline narrated to a peer.

## Today's flow (100 min)

| # | Part (time) | What you do |
|---|---|---|
| 01 | Frame the interview (5 min) | Listen as instructor reviews format, rubric, and JD anchoring |
| 02 | Solo "Tell me about yourself" draft (10 min) | Run Practice Prompt 05.a in Claude Code; answer all five questions to get an initial 60-second draft |
| 03 | Pair "Tell me about yourself" rehearsal (15 min) | Deliver "Tell me about yourself" out loud to a partner, twice. One piece of feedback per round |
| 04 | Solo whiteboard recall (5 min) | Laptop closed, draw both pipelines from memory; compare to your M02 diagram |
| 05 | Pair whiteboard walkthrough (20 min) | Walk your pipeline at the whiteboard; partner asks at least 3 follow-ups using Practice Prompt 05.d |
| 06 | Pair full mock (20 min) | 7-minute hot seat each: "Tell me about yourself" + project + follow-ups (one of which probes the knowledge base) using Practice Prompt 05.e |
| 07 | Self-directed close (15 min) | Use the time however helps your prep — note-taking, diagram refinement, wiki verification, instructor questions |
| 08 | Volunteer demos and closeout (10 min) | Two students walk their pipeline in front of the class; instructor names patterns to imitate |

## Practice prompts (paste into Claude Code)

All prompts live in the [study guide](../../study-guides/final-interview-study-guide.md) section 05:

- **05.a** "Tell me about yourself" content draft — Part 02
- **05.b** "Tell me about yourself" rehearsal — fallback if no partner in Part 03
- **05.c** Whiteboard walkthrough — fallback if no partner in Part 05
- **05.d** Project follow-ups — Part 05
- **05.e** Full mock interview — Part 06 (and your post-class fallback)
- **05.f** KB readiness check — run before your interview slot
- **05.g** Defensibility cheat sheet — Part 07

## Note-taking (optional)

Many students keep a `docs/interview-prep-notes.md` in their portfolio repo to track what they're prepared to defend. Study guide section 06 has the format. Not required for class; useful for prep.

## After class: between May 5 and your interview slot

1. Read the full study guide cover to cover.
2. **Practice on humans, not just AI.** Walk a roommate, parent, or friend through your project. The parent test is your bar — a non-technical person who cares about you should be able to follow your walkthrough end-to-end.
3. Run Practice Prompt 05.e (full mock interview) against Claude Code at least once.
4. **(Optional) Refine `docs/interview-prep-notes.md`** if you started one in class. Drop anything you can't defend; add anything you can. Study guide section 06 has the format.
5. Refine your pipeline diagram if needed. Aim for:
   - **Single page or single screen scroll.** A diagram that requires panning has too much detail.
   - **Every layer labeled with the tool that produced it.** Not "extract layer" but `extract.py`. Not "scheduling" but GitHub Actions on cron.
   - **Data flow direction unambiguous.** Use arrows, not lines.
   - **No mystery boxes.** If a non-engineer can't tell what something is from the label, label it more specifically.
   - **Both data paths drawn.** Structured (API → GitHub Actions → Snowflake → dbt → Streamlit) and knowledge base (web scrape → GitHub Actions → `knowledge/raw/` → Claude Code → `knowledge/wiki/`).
6. **Record and submit your practice run.** Zoom cloud recording of both interview questions, submitted in Brightspace by 11:59pm the day before your Calendly slot. Worth 10 pts of the interview score (see study guide section 07).
7. Commit `docs/resume.pdf` before your interview slot. Deadline is May 11.
