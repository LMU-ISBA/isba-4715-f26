---
marp: true
theme: default
paginate: true
size: 16:9
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

# Web Scraping

> Gathering data from websites **without an API** and **without a human clicking around in a browser**

![bg right:35%](https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=900)

---

<!-- _class: dark -->

# Why Scrape?

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">🚫</div><div>No API exists for this data</div></div>
  <div class="icon-item"><div class="icon-circle">💳</div><div>The API is paywalled</div></div>
  <div class="icon-item"><div class="icon-circle">📰</div><div>Constantly-changing list (press releases, bios, news)</div></div>
  <div class="icon-item"><div class="icon-circle">🤖</div><div>You want to automate something a human would do</div></div>
</div>

---

# Etiquette and Caveats

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

# Where does scraped data go in THIS project?

---

<!-- _class: accent -->

# Where does scraped data go?

<div class="flow">
  <div class="flow-box">MP03 (API)<small>request → CSV → SQL warehouse</small></div>
</div>

---

<!-- _class: accent -->

# Where does scraped data go?

<div class="flow">
  <div class="flow-box">MP03 (API)<small>request → CSV → SQL warehouse</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">MP04 (Scrape)<small>extract → markdown → knowledge/raw/</small></div>
</div>

---

<!-- _class: accent -->

# Where does scraped data go?

<div class="flow">
  <div class="flow-box">MP03 (API)<small>request → CSV → SQL warehouse</small></div>
  <div class="flow-arrow">→</div>
  <div class="flow-box">MP04 (Scrape)<small>extract → markdown → knowledge/raw/</small></div>
</div>

These feed your **knowledge base** — the unstructured side of your portfolio project.

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

# Firecrawl vs. Claude Code's WebSearch

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

# Firecrawl — Search + Scrape API

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

# Last Year We Taught BeautifulSoup

![bg right:35%](https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=900)

- Parse HTML tag-by-tag
- Hunt for the right CSS selector
- Break every time the site redesigns

---

# Last Year We Taught BeautifulSoup

![bg right:35%](https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=900)

- Parse HTML tag-by-tag
- Hunt for the right CSS selector
- Break every time the site redesigns

**This year we don't.** Firecrawl does all three in one call, and handles JavaScript rendering too. If you want BeautifulSoup for interview prep, read the docs — you do not need it for this project.

---

# Build vs. Buy — Scraping Edition

| Problem | Don't | Do |
|---|---|---|
| 🔍 Find + scrape URLs | Write a crawler + parser | **Firecrawl** |
| 🖱️ Click through a login | Write a bot | Playwright |

---

<!-- _class: dark -->

# The Pipeline

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

# Now the Upgrade: MCP

What if Claude Code could call Firecrawl **directly**, without you writing Python?

![bg right:35%](https://images.unsplash.com/photo-1518770660439-4636190af475?w=900)

---

<!-- _class: accent -->

# Now the Upgrade: MCP

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

# Python vs. MCP

<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-top: 24px;">
<div class="compare-col">

### 🐍 Python (Part 02)

- ~30 lines of SDK calls
- Loops, file writes
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

# Today's Demo Domain: Chipotle IR

<div class="logo-row">
  <img src="images/chipotle.png" alt="Chipotle" />
</div>

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">📈</div><div><strong>IR = Investor Relations</strong> — shareholder-facing content</div></div>
  <div class="icon-item"><div class="icon-circle">📰</div><div>Press releases, bios, earnings, filings</div></div>
  <div class="icon-item"><div class="icon-circle">🔓</div><div>Legally required to be accessible</div></div>
  <div class="icon-item"><div class="icon-circle">✨</div><div>Great fit for a knowledge base</div></div>
</div>

---

# Accounts You Need

<div class="logo-row">
  <img src="images/firecrawl.png" alt="Firecrawl" />
</div>

| Service | URL | Free Tier |
|---|---|---|
| Firecrawl | [firecrawl.dev](https://firecrawl.dev) | 500 credits/month |
| **Student Program** | [firecrawl.dev/student-program](https://www.firecrawl.dev/student-program) | **20,000 credits** with `.edu` email |

GitHub sign-in, no card. Apply to the student program after you sign up — it is approved in under a day.

---

# Your Project Needs This

![bg right:40%](https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=900)

<div class="icon-grid">
  <div class="icon-item"><div class="icon-circle">🎯</div><div>Milestone 02: <strong>≥15 sources</strong> from 3+ sites</div></div>
  <div class="icon-item"><div class="icon-circle">🔗</div><div>Pattern works for any URL in a browser</div></div>
  <div class="icon-item"><div class="icon-circle">💼</div><div>Your job posting says what content matters</div></div>
  <div class="icon-item"><div class="icon-circle">📚</div><div>Feeds your knowledge base wiki</div></div>
</div>

---

# The Pattern Transfers

<div class="flow">
  <div class="flow-box">MP03 (APIs)<small>request → parse → loop → save (CSV)</small></div>
  <div class="flow-arrow">↔</div>
  <div class="flow-box">MP04 (Scraping)<small>search → extract → loop → save (markdown)</small></div>
</div>

Different tools. Same shape. If you learned MP03, you already know MP04.

**Next up:** code it together.
