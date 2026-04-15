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
  section.dark table td strong,
  section.dark table th strong {
    color: #1a1a2e !important;
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
  section.accent table,
  section.accent table th,
  section.accent table td {
    border-color: rgba(0,0,0,0.15) !important;
    color: #222 !important;
  }
  section.accent table th {
    background: #e8eef7 !important;
    color: #1a1a2e !important;
  }
  section.accent table td {
    background: #ffffff !important;
  }
  section.accent table tr:nth-child(even) td {
    background: #f5f7fa !important;
  }
  .pattern-box-light {
    background: #f0f4ff;
    border: 2px solid #3a5ba0;
    border-radius: 12px;
    padding: 24px 32px;
    font-size: 1.3em;
    text-align: center;
    margin-top: 20px;
    margin-bottom: 40px;
    letter-spacing: 2px;
    color: #1a1a2e;
  }
  .pattern-box-dark {
    background: rgba(255,255,255,0.1);
    border: 2px solid #7eb8ff;
    border-radius: 12px;
    padding: 24px 32px;
    font-size: 1.3em;
    text-align: center;
    margin-top: 20px;
    margin-bottom: 40px;
    letter-spacing: 2px;
    color: #fff;
  }
  .big-question {
    font-size: 2em;
    font-weight: 700;
    text-align: center;
    margin-top: 60px;
    color: #fff;
  }
  .logo-row {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 48px;
    margin-top: 24px;
    margin-bottom: 24px;
  }
  .logo-row img {
    height: 72px;
    object-fit: contain;
  }
  .logo-row-small img {
    height: 48px;
  }
  .arrow {
    font-size: 2em;
    font-weight: 700;
    color: #3a5ba0;
  }
  section.dark .arrow, section.accent .arrow {
    color: #7eb8ff;
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
  .flow-box img {
    height: 40px;
    margin-bottom: 8px;
  }
  .flow-box small {
    font-weight: 400;
    font-size: 0.65em;
    color: #555;
    margin-top: 4px;
    letter-spacing: 0;
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
  .compare-col {
    background: rgba(255,255,255,0.08);
    border-radius: 10px;
    padding: 16px;
    min-height: 220px;
  }
  .compare-col h3 {
    margin: 0 0 10px 0;
    color: #7eb8ff;
  }
---

<!-- _class: accent -->

# Scrape Pipeline

**Lesson 09** · ISBA 4715

![bg right:40%](https://images.unsplash.com/photo-1518770660439-4636190af475?w=900)

---

# Agenda

| | Part | What |
|---|------|------|
| 1 | **Scraping Concepts** | What it is, etiquette, the tools we'll use *(slides)* |
| 2 | **Python Pipeline** | Firecrawl search + scrape, saving to `knowledge/raw/` *(live code)* |
| 3 | **MCP Upgrade** | Claude Code as the pipeline *(demo)* |
| 4 | **Your Project** | Scrape at least one source into your repo |

---

<!-- _paginate: false -->

# How did Google build its first index?

<div class="logo-row">
  <img src="images/google.png" alt="Google" />
</div>

Before anyone wrote an API for the web...

![bg right:40%](https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=900)

---

# How did Google build its first index?

<div class="logo-row">
  <img src="images/google.png" alt="Google" />
</div>

Before anyone wrote an API for the web...

**Web scraping** — reading pages programmatically.

![bg right:40%](https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=900)

---

<!-- _class: dark -->

# Scraping is what you do when there is no API

> Gathering data from websites **without an API** and **without a human clicking around in a browser**

![bg right:35%](https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=900)

---

<!-- _class: dark -->

# Scrape when the data has no other door

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">🚫</div><div>No API exists</div></div>
  <div class="icon-item"><div class="icon-circle">💳</div><div>The API is paywalled</div></div>
  <div class="icon-item"><div class="icon-circle">📰</div><div>Content changes constantly</div></div>
  <div class="icon-item"><div class="icon-circle">🤖</div><div>Automate a human task</div></div>
</div>

---

# Scrape like a guest, not a thief

![bg right:30%](https://images.unsplash.com/photo-1450101499163-c8848c66ca85?w=900)

| Rule | Why |
|---|---|
| Check `robots.txt` | Sites declare what bots can crawl |
| Rate limit — `time.sleep()` | Don't hammer the server |
| Respect Terms of Service | Legal + ethical obligation |
| Expect layout changes | HTML is not a stable contract |
| Be mindful of PII | Don't scrape what people did not consent to share |

---

<!-- _class: accent -->

# Scraped markdown feeds your knowledge base

---

<!-- _class: accent -->

# Scraped markdown feeds your knowledge base

<div class="flow">
  <div class="flow-box">MP03 (API)<small>request → CSV → SQL warehouse</small></div>
</div>

---

<!-- _class: accent -->

# Scraped markdown feeds your knowledge base

<div class="flow">
  <div class="flow-box">MP03 (API)<small>request → CSV → SQL warehouse</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">MP04 (Scrape)<small>extract → markdown → knowledge/raw/</small></div>
</div>

---

<!-- _class: accent -->

# Scraped markdown feeds your knowledge base

<div class="flow">
  <div class="flow-box">MP03 (API)<small>request → CSV → SQL warehouse</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">MP04 (Scrape)<small>extract → markdown → knowledge/raw/</small></div>
</div>

These feed your **knowledge base** — the unstructured side of your portfolio project.

---

<!-- _class: accent -->

# You are building a **RAG system**

**R**etrieval-**A**ugmented **G**eneration — the standard pattern for AI systems that answer questions using your own content rather than just what a model memorized during training.

Every knowledge-base chatbot, internal-docs search, and "chat with your data" product you have seen is RAG.

---

<!-- _class: dark -->

# LLMs made stuff up. RAG fixed that.

<div class="flow">
  <div class="flow-box">📚<small>Search engines<br/>(Google, 1998)</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">🤖<small>LLMs alone<br/>(ChatGPT, 2022)<br/>hallucinates facts</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📄+🤖<small>RAG<br/>(2023–now)<br/>LLM cites sources</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">🔌<small>Agentic RAG<br/>(today)<br/>agent picks sources</small></div>
</div>

LLMs on their own confabulate. RAG grounds answers in documents you supply. Your project is the agentic flavor — Claude Code chooses which files in `knowledge/raw/` to read for each question.

---

# You already have the four RAG parts

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">🔍</div><div><strong>Retrieval</strong> — Firecrawl searches the web and pulls back markdown</div></div>
  <div class="icon-item"><div class="icon-circle">📁</div><div><strong>Document store</strong> — <code>knowledge/raw/</code> holds the scraped markdown</div></div>
  <div class="icon-item"><div class="icon-circle">📝</div><div><strong>Indexed notes</strong> — <code>knowledge/wiki/</code> (you build this in Milestone 02)</div></div>
  <div class="icon-item"><div class="icon-circle">🤖</div><div><strong>Generation</strong> — Claude Code reads the notes and answers grounded in them</div></div>
</div>

No vector database, no embeddings — Claude Code uses grep, file reads, and its own reasoning. Simple RAG beats complex RAG until you have a reason otherwise.

---

# One API, Search + Extract

<div class="flow">
  <div class="flow-box">🔍 query<small>"Chipotle earnings"</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box"><img src="images/firecrawl.png" alt="Firecrawl" /><small>Firecrawl</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📄 URLs + markdown<small>5 results, each scraped</small></div>
</div>

**Older tools split this into two calls** — one service for search, another for scraping. Firecrawl's `search` endpoint does both in one round-trip.

---

<!-- _class: dark -->

# JSON for scripts. Prose for humans.

<div class="logo-row logo-row-small">
  <img src="images/firecrawl.png" alt="Firecrawl" />
  <span style="font-size: 1.2em; color: #7eb8ff;">vs.</span>
  <img src="images/google.png" alt="Claude Code WebSearch" />
</div>

| Firecrawl (API) | WebSearch (Claude Code tool) |
|---|---|
| Returns structured data (URLs, titles, markdown) | Returns prose for the agent to read |
| Designed for programmatic pipelines | Built into Claude Code conversations |
| Same response schema every call | Different synthesized text each call |
| Full control: filters, domains, depth | Whatever the tool decides |

> Cron jobs need structured data to parse. Humans need readable prose. Pick the right tool for the reader.

---

# One Firecrawl call = URLs + markdown

<div class="logo-row">
  <img src="images/firecrawl.png" alt="Firecrawl" />
</div>

<div class="flow">
  <div class="flow-box">🔍 query<small>"Chipotle earnings"</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box"><img src="images/firecrawl.png" alt="Firecrawl" /><small>Firecrawl</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📄 List of results<small>each with url + markdown</small></div>
</div>

No BeautifulSoup. No `select` or `find`. No DOM inspection.

---

<!-- _paginate: false -->

# BeautifulSoup still works. You do not need it.

![bg right:35%](https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=900)

- Parse HTML tag-by-tag
- Hunt for the right CSS selector
- Break every time the site redesigns

---

# BeautifulSoup still works. You do not need it.

![bg right:35%](https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=900)

- Parse HTML tag-by-tag
- Hunt for the right CSS selector
- Break every time the site redesigns

**This year we don't.** Firecrawl does all three in one call, and handles JavaScript rendering too. If you want BeautifulSoup for interview prep, read the docs — you do not need it for this project.

---

# Buy the API. Build the pipeline.

| Problem | Don't | Do |
|---|---|---|
| 🔍 Find + scrape URLs | Write a crawler + parser | **Firecrawl** |
| 🖱️ Click through a login | Write a bot | Playwright |

---

<!-- _class: dark -->

# Firecrawl finds. Firecrawl extracts. You save.

<div class="flow">
  <div class="flow-box"><img src="images/firecrawl.png" alt="Firecrawl" /><small>Firecrawl<br/>search</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📄<small>URLs +<br/>markdown</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📁<small>knowledge/raw/</small></div>
</div>

One API does the finding and the extracting. Your script saves the output.

---

<!-- _class: accent -->

# MCP turns your prompt into the pipeline

What if Claude Code could call Firecrawl **directly**, without you writing Python?

![bg right:35%](https://images.unsplash.com/photo-1518770660439-4636190af475?w=900)

---

<!-- _class: accent -->

# MCP turns your prompt into the pipeline

<div class="flow">
  <div class="flow-box">💬<small>your prompt</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">🤖 Claude Code<small>reads the prompt</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">🔌 Firecrawl MCP<small>search + scrape</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">📁<small>files written</small></div>
</div>

**MCP servers** (Model Context Protocol) extend Claude Code with new tools. Install one, and Claude Code can use it inside any prompt.

---

<!-- _class: dark -->

# Python for production. MCP for exploration.

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 24px;">
<div class="compare-col">

### 🐍 Python (Part 02)

- ~30 lines of requests.post, loops, file writes
- Version-controlled
- Runs in GitHub Actions

</div>
<div class="compare-col">

### 💬 MCP (Part 03)

> "Find 5 URLs about Chipotle's recent earnings and save each as markdown in `knowledge/raw/`."

**Same result. No code.**

</div>
</div>

---

# Chipotle IR: public, rich, scrape-friendly

<div class="logo-row">
  <img src="images/chipotle.png" alt="Chipotle" />
</div>

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">📈</div><div><strong>IR</strong> = Investor Relations</div></div>
  <div class="icon-item"><div class="icon-circle">📰</div><div>Press releases, bios, earnings</div></div>
  <div class="icon-item"><div class="icon-circle">🔓</div><div>Legally required to be public</div></div>
  <div class="icon-item"><div class="icon-circle">✨</div><div>Great knowledge-base fodder</div></div>
</div>

---

# One account, 20,000 credits with STUDENTEDU

<div class="logo-row">
  <img src="images/firecrawl.png" alt="Firecrawl" />
</div>

| Service | URL | Free Tier |
|---|---|---|
| Firecrawl | [firecrawl.dev](https://firecrawl.dev) | 500 credits |
| **Student Program** | [firecrawl.dev/student-program](https://www.firecrawl.dev/student-program) | **20,000 credits** with `.edu` email |

**To redeem student credits:** Dashboard → **Settings → Billing** → apply coupon code `STUDENTEDU`.

**Sign up with your `.edu` email** (not GitHub OAuth) so the coupon can verify your school. No card required.

---

# Milestone 02 needs 15 sources. Start today.

![bg right:40%](https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=900)

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">🎯</div><div><strong>15 sources</strong>, 3+ sites</div></div>
  <div class="icon-item"><div class="icon-circle">🔗</div><div>Same pattern, any URL</div></div>
  <div class="icon-item"><div class="icon-circle">💼</div><div>Job posting shapes content</div></div>
  <div class="icon-item"><div class="icon-circle">📚</div><div>Feeds your wiki pages</div></div>
</div>

---

# Same pattern as MP03, different tool

<div class="flow">
  <div class="flow-box">MP03 (APIs)<small>request → parse → loop → save (CSV)</small></div>
  <div class="flow-arrow">↔</div>
  <div class="flow-box">MP04 (Scraping)<small>search → extract → loop → save (markdown)</small></div>
</div>

Different tools. Same shape. If you learned MP03, you already know MP04.

**Next up:** code it together.
