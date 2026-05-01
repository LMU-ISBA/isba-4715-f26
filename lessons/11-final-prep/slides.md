---
marp: true
theme: default
paginate: true
size: 16:9
transition: fade
style: |
  section {
    font-family: 'Inter', 'Helvetica Neue', Arial, sans-serif;
    color: #222;
  }
  section h1 {
    color: #111;
  }
  section strong {
    color: #1a1a2e;
  }
  section lead h1 {
    font-size: 2.8em;
    font-weight: 700;
  }
  section.dark {
    background-color: #1a1a2e;
    color: #f0f0f0;
  }
  section.dark h1 {
    color: #fff;
  }
  section.dark strong {
    color: #7eb8ff;
  }
  section.dark a {
    color: #7eb8ff;
  }
  section.dark code {
    background: rgba(255,255,255,0.15);
    color: #fff;
  }
  section.dark blockquote {
    color: #ccc;
    border-left-color: #7eb8ff;
  }
  section.dark table,
  section.dark table th,
  section.dark table td {
    border-color: rgba(0,0,0,0.15) !important;
    color: #222 !important;
  }
  section.dark table th {
    background: #e8eef7 !important;
    color: #1a1a2e !important;
  }
  section.dark table td {
    background: #ffffff !important;
  }
  section.dark table tr:nth-child(even) td {
    background: #f5f7fa !important;
  }
  section.accent {
    background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
    color: #f0f0f0;
  }
  section.accent h1 {
    color: #fff;
    font-size: 2.4em;
  }
  section.accent strong {
    color: #64ffda;
  }
  section.accent code {
    background: rgba(255,255,255,0.15);
    color: #fff;
  }
  section.accent blockquote {
    color: #ccc;
    border-left-color: #64ffda;
  }
  .flow {
    display: flex;
    justify-content: center;
    align-items: stretch;
    gap: 16px;
    margin-top: 32px;
    margin-bottom: 32px;
    flex-wrap: wrap;
  }
  .flow-box {
    background: #f0f4ff;
    border: 2px solid #3a5ba0;
    border-radius: 10px;
    padding: 14px 18px;
    min-width: 140px;
    text-align: center;
    font-weight: 600;
    color: #1a1a2e;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .flow-box small {
    font-weight: 400;
    font-size: 0.65em;
    color: #555;
    margin-top: 4px;
  }
  section.dark .flow-box {
    background: rgba(255,255,255,0.08);
    border-color: #7eb8ff;
    color: #f0f0f0;
  }
  section.dark .flow-box small {
    color: #b0c4e0;
  }
  section.accent .flow-box {
    background: rgba(255,255,255,0.08);
    border-color: #64ffda;
    color: #f0f0f0;
  }
  section.accent .flow-box small {
    color: #a0e0d0;
  }
  .flow-arrow {
    display: flex;
    align-items: center;
    font-size: 2em;
    color: #3a5ba0;
    font-weight: 700;
  }
  section.dark .flow-arrow {
    color: #7eb8ff;
  }
  section.accent .flow-arrow {
    color: #64ffda;
  }
  .icon-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 18px;
    margin-top: 24px;
  }
  .icon-item {
    display: flex;
    align-items: flex-start;
    gap: 14px;
  }
  .icon-circle {
    flex-shrink: 0;
    width: 44px;
    height: 44px;
    border-radius: 50%;
    background: #f0f4ff;
    border: 2px solid #3a5ba0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.4em;
  }
  section.dark .icon-circle {
    background: rgba(255,255,255,0.1);
    border-color: #7eb8ff;
  }
  .bad-label {
    color: #c0392b;
    font-weight: 600;
  }
  .good-label {
    color: #27ae60;
    font-weight: 600;
  }
---

<!-- _class: accent -->

# Pipeline Whiteboard

**Lesson 11** · ISBA 4715 · Final Prep

![bg right:40%](https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=900)

---

# Today's class is the practice run

| | When | What |
|---|------|------|
| 1 | **Today (May 4)** | Draw your pipeline. Walk a classmate through it. |
| 2 | **May 11, 12, or 13** | Same exercise, with the interviewer. |

The diagram you draw today is the same diagram you'll draw in your final interview. The version that lives in your README is the artifact. Today is the rehearsal.

---

<!-- _class: dark -->

# The interview starts with a blank whiteboard

> "Walk me through the pipeline you built."

You stand up. You draw it from memory. You explain what each box does and why you chose that tool.

That's the first 10 minutes of your final interview.

![bg right:35%](https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=900)

---

# Why "from memory" matters

Anything you can't recall isn't load-bearing in your understanding of the pipeline.

Which means it probably shouldn't be in the diagram either.

**The discipline of drawing it from memory forces simplification.**

---

# Polished version vs. from-memory version

<div class="flow">
  <div class="flow-box">🎨 Polished<small>Mermaid in your README</small></div>
  <div class="flow-arrow">↔</div>
  <div class="flow-box">✏️ From memory<small>Whiteboard, no notes</small></div>
</div>

The polished version is the **artifact** — what an employer sees in your repo.

The from-memory version is the **rehearsal** — what proves you actually built it.

Both matter. Today we work on both.

---

# Pick a format

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">📝</div><div><strong>Mermaid</strong> — lives inline in your README, version-controlled</div></div>
  <div class="icon-item"><div class="icon-circle">🎨</div><div><strong>draw.io</strong> — more visual control, export PNG</div></div>
  <div class="icon-item"><div class="icon-circle">✏️</div><div><strong>Excalidraw</strong> — hand-drawn aesthetic, also free</div></div>
  <div class="icon-item"><div class="icon-circle">📷</div><div><strong>Hand-drawn photo</strong> — literal whiteboard or paper, photographed</div></div>
</div>

All four satisfy the M02 rubric. Pick the one that matches how you think.

---

<!-- _class: accent -->

# Your portfolio is **two pipelines, one repo**

You built a structured-data path and a knowledge-base path. Both need to show up on your whiteboard.

---

# Path 1: Structured data → dashboard

<div class="flow">
  <div class="flow-box">🌐 API source<small>e.g. Yelp, Google Places</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">⚙️ GitHub Actions<small>scheduled cron</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">❄️ Snowflake raw<small>landing table</small></div>
</div>

<div class="flow">
  <div class="flow-box">🔧 dbt staging<small>cleaned</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📊 dbt mart<small>analytics-ready</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📈 Streamlit<small>dashboard</small></div>
</div>

Six labeled boxes. Each one is a tool you actually used.

---

# Path 2: Web scrape → knowledge base

<div class="flow">
  <div class="flow-box">🕷️ Web scrape<small>Firecrawl</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">⚙️ GitHub Actions<small>scheduled cron</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📁 knowledge/raw/<small>markdown files</small></div>
</div>

<div class="flow">
  <div class="flow-box">🤖 Claude Code<small>synthesis</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📚 knowledge/wiki/<small>indexed notes</small></div>
</div>

Five labeled boxes. Notice GitHub Actions appears in both paths — same orchestrator, different destinations.

---

<!-- _class: dark -->

# Label every tool. No mystery boxes.

| <span class="bad-label">❌ Don't</span> | <span class="good-label">✅ Do</span> |
|---|---|
| "Cloud database" | **Snowflake** |
| "Code" | **Python + `requests`** |
| "Scheduling" | **GitHub Actions on cron** |
| "Extract layer" | **`extract.py`** |
| "Some AI thing" | **Claude Code** |

The labels are the test of whether you actually built it — or copy-pasted a generic architecture diagram.

---

# What makes a good diagram

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">📄</div><div><strong>Single page</strong> — if it requires panning, simplify</div></div>
  <div class="icon-item"><div class="icon-circle">🏷️</div><div><strong>Every layer named</strong> with the actual tool</div></div>
  <div class="icon-item"><div class="icon-circle">➡️</div><div><strong>Arrows, not lines</strong> — direction must be unambiguous</div></div>
  <div class="icon-item"><div class="icon-circle">👀</div><div><strong>Readable cold</strong> — non-engineer should grasp it without you</div></div>
</div>

A diagram a stranger can read is a diagram an interviewer will respect.

---

<!-- _class: accent -->

# Pair exercise: 20 minutes

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">1</div><div>Draw your two paths from memory. No notes.</div></div>
  <div class="icon-item"><div class="icon-circle">2</div><div>Walk a classmate through it out loud.</div></div>
  <div class="icon-item"><div class="icon-circle">3</div><div>Swap. Read theirs cold. Ask about anything unclear.</div></div>
  <div class="icon-item"><div class="icon-circle">4</div><div>The questions a classmate asks are the questions a hiring manager will ask.</div></div>
</div>

---

# Checkpoint — what "ready" looks like

- Diagram lives in your portfolio repo's `README.md`
- Every layer is labeled with a specific tool
- Data flow direction is unambiguous
- A classmate read it cold and understood the pipeline without you explaining

If you can walk through it without notes, you're ready for May 11–13.

---

<!-- _class: dark -->

# Nothing to submit on Brightspace

The diagram lives in your repo. The walkthrough happens in your interview.

**Pick your slot:** Mon May 11, Tue May 12, or Wed May 13 via Calendly.

See you there.
