# Lesson 11: Final Interview Prep Tutorial

This is the in-class clinic for the final interview. We'll spend the next 100 minutes rehearsing the two questions you'll be asked in your interview — "Tell me about yourself" and "Tell me about your project" — using paired practice, the whiteboard, and Claude Code as a rehearsal partner. Both questions are anchored to your portfolio JD (`docs/job-posting.pdf`), the role you've been targeting all semester. The interview itself is in your booked Calendly slot on Mon May 11, Tue May 12, or Wed May 13. You'll leave today with a TMAY you've delivered out loud, a pipeline you've walked through with a peer, a verified knowledge base wiki, and a committed cheat sheet that contracts what you're prepared to defend.

If you're absent, follow this tutorial solo against Claude Code. Every paired part has a no-partner fallback. **Between now and your interview slot, the best rehearsal is with humans — a roommate, a parent, a friend in another major. Aim to clear the parent test: a non-technical person who loves you can follow your project walkthrough end-to-end. AI rehearsal is the fallback when no human is around, not the headline.**

> **Pacing note for the instructor:** The 100-minute budget has zero buffer. If we run long earlier, cut Part 04 (solo whiteboard recall) first — drop it from 10 min to 5 min. Parts 03 (pair TMAY), 05 (pair whiteboard), and 07 (KB live-fire + commit) are non-negotiable. Part 06 can spill into Part 07's KB live-fire by ≤5 min, but the commit step always happens before students leave.

Read the [Final Interview Study Guide](../../study-guides/final-interview-study-guide.md) before class. The Practice Prompts in 05 are referenced throughout this tutorial.

## Table of Contents

### Session 01: In-class prep clinic (Mon May 4)

| Part | Topic | What You Will Do |
|---|---|---|
| [Part 01](#part-01-frame-the-interview-5-min) | Frame the interview | Review format, rubric, portfolio JD as the only JD |
| [Part 02](#part-02-solo-tmay-draft-10-min) | Solo TMAY draft | Use Practice Prompt 05.a to draft a 60-second TMAY |
| [Part 03](#part-03-pair-tmay-rehearsal-15-min) | Pair TMAY rehearsal | Deliver TMAY out loud to a peer, twice |
| [Part 04](#part-04-solo-whiteboard-recall-10-min) | Solo whiteboard recall | Draw your pipeline from memory; compare to L10 diagram |
| [Part 05](#part-05-pair-whiteboard-walkthrough-20-min) | Pair whiteboard walkthrough | Walk your pipeline at the whiteboard with a peer asking follow-ups |
| [Part 06](#part-06-pair-full-mock-25-min) | Pair full mock | 10-minute hot seat each: TMAY + project + KB demo + follow-ups |
| [Part 07](#part-07-kb-live-fire-and-cheat-sheet-contract-15-min) | KB live-fire and cheat sheet contract | Verify wiki end-to-end; commit `docs/interview-prep-notes.md` |

---

## Part 01: Frame the interview (5 min)

Five minutes. Instructor-led. Goal: every student in the room knows the format, the rubric, and which JD drives the conversation before we start practicing.

### Step 01: Review the format

The interview has three segments in fixed order: TMAY, project deep-dive, follow-ups and wrap. Knowing the shape lets you rehearse the timing instead of spending mental energy guessing it on your interview day.

**What to do:**

1. Confirm: the interview is in person, Hilton 114, 20 minutes per student, scheduled via Calendly on Mon May 11, Tue May 12, or Wed May 13.
2. Confirm: TMAY is 60 seconds (15 pts), the project deep-dive is 14 minutes (85 pts), follow-ups and wrap is 4 minutes.
3. Confirm: you'll be at the whiteboard for the project section.

**Checkpoint:** You can repeat the structure (TMAY → project → follow-ups) and the timing without looking.

---

### Step 02: Read the rubric

The rubric is published and we're reading it in class now. Rubrics that stay hidden until grading lead to surprise; this one won't.

**What to do:**

1. Open the study guide section 02. Read the descriptor table (A/B/C/D/F).
2. Note the 15/85 point split.
3. Note the hint-penalty rule: **one free hint total across the project section; each additional hint −3 pts within the 85**.
4. Note the AI ownership rule: any component you can't distinguish from AI scaffolding scores at most 50% of its weight.

**Checkpoint:** You can name the hint rule and the AI ownership rule without looking.

---

### Step 03: Open your portfolio JD

Both questions in the interview are anchored to the role you've been targeting all semester — the JD you placed in your portfolio repo. Real interviewers don't share a generic JD across candidates; they read the role you applied to and ask you about that role. We're rehearsing that exact dynamic.

**What to do:**

1. Open `docs/job-posting.pdf` in your portfolio repo. This is the only JD in the room.
2. Both questions are anchored to this JD: TMAY tailors who you are to this role; the project section tailors what you built to this role.
3. If you've pivoted to a different target role since selecting your portfolio JD, swap the file before continuing.

**Checkpoint:** Your portfolio JD is open on your laptop. You can name the role title in one sentence.

---

## Part 02: Solo TMAY draft (10 min)

Ten minutes. Solo work with Claude Code. Goal: a 60-second TMAY tailored to your portfolio JD, drafted and saved.

### Step 01: Open Claude Code in your portfolio repo

Before pasting any prompts, having your resume content reachable in the session means Claude Code can give you feedback anchored to your actual background, not a generic one.

**What to do:**

1. Open Cursor with your portfolio repo.
2. Start a Claude Code session (or open an existing one).
3. Make sure your resume content is reachable — either as `@docs/resume.pdf` or pasted into a scratch file (`docs/scratch/resume.md`).

**Checkpoint:** Claude Code is open and you can `@`-reference at least one file from the repo.

---

### Step 02: Run Practice Prompt 05.a

The prompt encodes the assessment criteria; iterating against it is the closest thing to iterating against the rubric.

**What to do:**

1. Open `study-guides/final-interview-study-guide.md` to section 05.a (TMAY rehearsal).
2. Copy the prompt verbatim.
3. Paste into Claude Code. Adjust the file refs if your resume is in a different format.
4. Let Claude Code interview you. Type your TMAY into the chat.

**Checkpoint:** Claude Code has scored your first attempt against the five TMAY targets and the JD's stack words.

---

### Step 03: Iterate at least twice

A first draft is rarely a 60-second answer; iteration is the practice.

**What to do:**

1. Take Claude Code's feedback. Rewrite your TMAY.
2. Deliver again. Score again. Adjust.
3. Stop when the score lands on all five targets, the answer is ≤60 seconds, and you've landed on at least two stack words from your JD.

**Checkpoint:** Your TMAY hits all five targets in one delivery, and lands on at least two stack words from your JD.

---

### Step 04: Save the draft

You'll deliver this out loud in Part 03; keep it open.

**What to do:**

1. Save the final TMAY to `docs/scratch/tmay.md` (or any scratch path you'll remember).
2. Keep it open for Part 03.

**Checkpoint:** The TMAY is saved and reachable in 5 seconds.

---

## Part 03: Pair TMAY rehearsal (15 min)

Fifteen minutes. Paired. Goal: every student delivers TMAY out loud at least twice. This part is non-negotiable — if the room is running tight, we cut Part 04 first.

### Step 01: Pair up

Even random pairing beats sitting alone. You need a human ear to catch the things Claude Code can't: eye contact, pace, whether you sound like you mean it.

**What to do:**

1. Find a partner. Roll-of-the-dice random is fine; matched stack is fine; just don't sit with no one.
2. If the room has odd numbers and you don't have a partner, follow the **no-partner fallback** at the bottom of this Part.

**Checkpoint:** You're sitting with a partner.

---

### Step 02: Round 01 — Partner A delivers, Partner B times and gives feedback

The trap with peer feedback is that everyone says "great job." Forcing exactly one piece of feedback prevents that — it makes your partner identify the single highest-leverage thing instead of softening the critique into noise.

**What to do:**

1. Partner B starts a 60-second timer.
2. Partner A delivers TMAY out loud. Phone in pocket; no reading from the laptop.
3. Partner B notes: did it hit education + initiative + relevant work + human + segue? Was it ≤60 seconds? Did it land on stack words from Partner A's portfolio JD?
4. Partner B gives **one** piece of feedback (the highest-leverage thing). Not five.

**Checkpoint:** Partner A has heard exactly one piece of feedback.

---

### Step 03: Round 01 — Swap

Same protocol, different direction.

**What to do:** Partner B delivers, Partner A times and gives one piece of feedback. Same rules.

**Checkpoint:** Both partners have delivered TMAY out loud once.

---

### Step 04: Round 02 — Both partners refine and deliver again

The first delivery is the warm-up; the second is the rep. Skipping Round 02 leaves you with one delivery — not enough to internalize the adjustment your partner gave you.

**What to do:**

1. 90 seconds: take your one piece of feedback. Adjust your TMAY.
2. Repeat Steps 02–03 with the refined version.

**Checkpoint:** Both partners have delivered TMAY out loud twice.

---

### No-partner fallback

If the room has odd numbers and no one is free, run Practice Prompt 05.a in Claude Code three times. Each iteration counts as one rep. This is genuinely the second-best option — Claude Code can score the words but not the eye contact, the pace, or whether you sound like you mean it. Find a roommate, parent, or friend tonight and run TMAY by them too.
