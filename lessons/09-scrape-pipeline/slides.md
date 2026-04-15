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
  section.dark table th {
    border-color: rgba(255,255,255,0.3) !important;
    color: #fff !important;
    background: rgba(255,255,255,0.15) !important;
  }
  section.dark table td {
    border-color: rgba(255,255,255,0.2) !important;
    color: #fff !important;
    background: transparent !important;
  }
  section.dark table tr:nth-child(even) td {
    background: rgba(255,255,255,0.08) !important;
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
  section.accent table th {
    border-color: rgba(255,255,255,0.3) !important;
    color: #fff !important;
    background: rgba(255,255,255,0.15) !important;
  }
  section.accent table td {
    border-color: rgba(255,255,255,0.2) !important;
    color: #fff !important;
    background: transparent !important;
  }
  section.accent table tr:nth-child(even) td {
    background: rgba(255,255,255,0.08) !important;
  }
  .pattern-box {
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
---

<!-- _class: accent -->

# Scrape Pipeline

**Lesson 09** · ISBA 4715

---

# Agenda

| | Part | What |
|---|------|------|
| 1 | **Scraping Concepts** | What it is, etiquette, the tools we'll use *(slides)* |
| 2 | **Python Pipeline** | Tavily + Firecrawl, saving to `knowledge/raw/` *(live code)* |
| 3 | **MCP Upgrade** | Claude Code as the pipeline *(demo)* |
| 4 | **Your Project** | Scrape at least one source into your repo |

---

![bg right:40%](https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=800)

<!-- _paginate: false -->

# How did Google build its first index?

Before anyone wrote an API for the web...

---

![bg right:40%](https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=800)

# How did Google build its first index?

Before anyone wrote an API for the web...

**Web scraping** — reading pages programmatically.

---

<!-- _class: dark -->

# Web Scraping

> Gathering data from websites **without an API** and **without a human clicking around in a browser**

---

<!-- _class: dark -->

# Why Scrape?

- No API exists for this data
- The API is paywalled
- The data is a constantly-changing list (press releases, bios, news)
- You want to automate something a human would otherwise do

---

# Etiquette and Caveats

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

# Where does scraped data go in THIS project?

**MP03 (API):** CSV file → later, a SQL warehouse

**MP04 (Scrape):** Markdown files in `knowledge/raw/`

---

<!-- _class: accent -->

# Where does scraped data go in THIS project?

**MP03 (API):** CSV file → later, a SQL warehouse

**MP04 (Scrape):** Markdown files in `knowledge/raw/`

These feed your **knowledge base** — the unstructured side of your portfolio project.

---

# The Two-Step Pattern

<div class="pattern-box">

**discover** &nbsp; → &nbsp; **extract** &nbsp; → &nbsp; loop &nbsp; → &nbsp; save

</div>

**Discover:** find URLs worth scraping → **Tavily**
**Extract:** turn each URL into clean markdown → **Firecrawl**

---

<!-- _class: dark _paginate: false -->

# Tavily — AI-Native Search API

You send: a query

You get back: JSON with ranked URLs, titles, and content previews

```json
{"results": [
  {"url": "...", "title": "...", "content": "...", "score": 0.87},
  ...
]}
```

---

<!-- _class: dark -->

# Tavily vs. Claude Code's WebSearch

| Tavily (API) | WebSearch (chat) |
|---|---|
| Returns **JSON** | Returns a **paragraph** |
| For your **pipeline** | For **you** |
| Runs in **GitHub Actions** | Requires interactive Claude Code |
| **Reproducible** | Each answer is different |

> If a cron job needs the answer, use the API.
> If a human needs the answer, use the chat tool.

---

![bg right:35%](https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800)

# Firecrawl — URL → Clean Markdown

You send: a URL

You get back: JSON with the page rendered as markdown

No BeautifulSoup. No `select` or `find`. No DOM inspection.

---

<!-- _paginate: false -->

# Last Year We Taught BeautifulSoup

- Parse HTML tag-by-tag
- Hunt for the right CSS selector
- Break every time the site redesigns

---

# Last Year We Taught BeautifulSoup

- Parse HTML tag-by-tag
- Hunt for the right CSS selector
- Break every time the site redesigns

**This year we don't.** Firecrawl does all three in one call, and handles JavaScript rendering too. If you want BeautifulSoup for interview prep, read the docs — you do not need it for this project.

---

# Build vs. Buy — Scraping Edition

| Problem | Don't | Do |
|---|---|---|
| Find relevant URLs | Write a crawler | **Tavily** |
| Turn URL into text | Write a parser | **Firecrawl** |
| Click through a login | Write a bot | Playwright *(advanced)* |

---

<!-- _class: dark -->

# The Pipeline

<div class="pattern-box">

Tavily &nbsp; → &nbsp; URLs &nbsp; → &nbsp; Firecrawl &nbsp; → &nbsp; markdown &nbsp; → &nbsp; `knowledge/raw/`

</div>

One tool finds the pages. Another tool extracts the content. Your script glues them together.

---

<!-- _class: accent -->

# Now the Upgrade: MCP

What if Claude Code could call Tavily and Firecrawl **directly**, without you writing Python?

---

<!-- _class: accent -->

# Now the Upgrade: MCP

What if Claude Code could call Tavily and Firecrawl **directly**, without you writing Python?

**MCP servers** (Model Context Protocol) extend Claude Code with new tools. Install one, and Claude Code can use it inside any prompt.

---

<!-- _class: dark -->

# Python vs. MCP

**Python (what you'll write in Part 02):**

~35 lines of SDK calls, loops, file writes

**MCP (what you'll see in Part 03):**

> "Find 5 URLs about Chipotle's recent earnings and save each one as markdown in `knowledge/raw/`."

Same result. No code.

---

![bg right:40%](https://images.unsplash.com/photo-1552566626-52f8b828add9?w=800)

# Today's Demo Domain: Chipotle IR

- **IR = Investor Relations** — the shareholder-facing section of a public company's website
- Press releases, leadership bios, earnings, regulatory filings
- Legally required to be accessible — no bot blocking
- Structured, accessible — good fit for a knowledge base

---

# Accounts You Need

| Service | URL | Free Tier |
|---|---|---|
| Firecrawl | [firecrawl.dev](https://firecrawl.dev) | 500 scrapes/month |
| Tavily | [tavily.com](https://tavily.com) | 1,000 searches/month |

Both: GitHub sign-in, no card. Under 2 minutes each.

---

![bg right:40%](https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=800)

# Your Project Needs This

- Milestone 02 requires **≥15 sources in `knowledge/raw/`** from 3+ different sites
- Today's pattern works for any URL you can put in a browser
- Your job posting tells you what content matters

---

# The Pattern Transfers

**MP03 (APIs):** request → parse → loop → save (CSV)

**MP04 (Scraping):** search → extract → loop → save (markdown)

Different tools. Same shape. If you learned MP03, you already know MP04.

**Next up:** code it together.
