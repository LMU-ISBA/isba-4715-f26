# Mini-Project 04: Scrape Pipeline Tutorial

This is the written companion to Lesson 09. The class opens with a 20-minute concepts block (see the slides, not this file) — the rest is hands-on. Use this if you fall behind, or to work through it on your own.

## Table of Contents

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 00 | [Create repo and start Claude Code](#step-00-create-github-repo-and-start-claude-code) | Set up the project repo, sign up for Firecrawl, create .env |
| 01 | [Search + Scrape Chipotle IR](#step-01-search--scrape-chipotle-ir) | Find pages and get their markdown in a single Firecrawl call |
| 02 | [Loop and save to knowledge/raw/](#step-02-loop-and-save-to-knowledgeraw) | Write one markdown file per result |
| 03 | [Install Firecrawl MCP](#step-03-install-firecrawl-mcp) | Add the Firecrawl MCP server to Claude Code |
| 04 | [Replicate the pipeline via one MCP prompt](#step-04-replicate-the-pipeline-via-one-mcp-prompt) | Issue a single directive that replaces ~30 lines of Python |
| 05 | [Find sources for your portfolio project](#step-05-find-sources-for-your-portfolio-project) | Open your project repo in a new Cursor window |
| 06 | [Scrape at least one source into your project](#step-06-scrape-at-least-one-source-into-your-project) | Apply the pattern to your own domain |
| 07 | [Commit and push](#step-07-commit-and-push) | Push both repos to GitHub |

---

## Part 01: Setup

### Step 00: Create GitHub Repo and Start Claude Code

Same workflow as MP02 and MP03: create the repo on GitHub first, clone it into Cursor, then start building. This time you also sign up for Firecrawl first.

**What to do:**

1. Go to [github.com/new](https://github.com/new) and create a new repository:
   - Name it `chipotle-scrape-pipeline`
   - Set visibility to **Public**
   - Under **Add .gitignore**, select **Python** from the dropdown
   - Leave everything else as default
   - Click **Create repository**

2. On your new repository's GitHub page, click the green **Code** button, make sure **HTTPS** is selected, and copy the URL.

3. Clone the repo into Cursor: new window → **Clone repo** → paste the URL → save under your `isba-4715` folder.

   ```
   ~/isba-4715/
   ├── campus-bites-pipeline/     <-- MP01
   ├── basket-craft-pipeline/     <-- MP02
   ├── weather-api-pipeline/      <-- MP03
   └── chipotle-scrape-pipeline/   <-- MP04
   ```

4. Open a terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal**) and start Claude Code:
   ```bash
   claude
   ```

5. Ask Claude Code to set up the environment:

   ```
   Set up a Python venv and install requests, python-dotenv.
   ```

   `requests` makes HTTP calls to Firecrawl (same library as MP03's Weather API), `python-dotenv` loads your `.env` keys.

   The install takes 30-60s. **While it runs, sign up in your browser (step 6).** To run Python outside Claude Code later: `source venv/bin/activate` (Mac) or `venv\Scripts\activate` (Windows).

6. **Sign up for Firecrawl** at [firecrawl.dev](https://firecrawl.dev). **Use your LMU `.edu` email** (not GitHub OAuth) so the student-program coupon can verify your school email in the next step. Create a password, confirm via email, then open **Dashboard → API Keys** and copy the `fc-...` key.

7. Create `.env` in your project root. Replace the placeholder with your actual key:

   ```
   FIRECRAWL_API_KEY=fc-your_firecrawl_key_here
   ```

8. Verify `.env` is in your `.gitignore` — **before your first commit**. The Python template already includes it; if not, add `.env` on its own line.

**Why `.env` instead of pasting keys into code?** MP03 hardcoded the WeatherAPI key into `weather.py` — fine for a demo, but any commit would leak the key to a public repo. From MP04 forward, keys live in `.env` (gitignored), loaded at runtime with `os.getenv()`. Same pattern as the async Spotify tutorial.

**Why Firecrawl:** Firecrawl is a single API that combines web search with automatic markdown extraction. One call gives you a ranked list of URLs and the cleaned markdown content of each page. Older tutorials use two services (one for search, one for scraping), but Firecrawl's [`search` endpoint](https://docs.firecrawl.dev/features/search) does both in one round-trip.

**Free tier:** 500 Firecrawl credits on signup — plenty for this lesson. If you applied the student coupon (see below) you have 20,000 instead.

**Student credits:** Firecrawl's [Student Program](https://www.firecrawl.dev/student-program) gives students 20,000 free credits (40× the default). **Two steps to redeem:** (1) sign up with your `.edu` email in step 6, not GitHub OAuth; (2) in the Firecrawl dashboard, open **Settings → Billing** and enter the coupon `STUDENTEDU`. The default 500 credits cover this lesson, but 20k carries you through Milestone 02's scheduled runs.

**Checkpoint:** Your `chipotle-scrape-pipeline` repo is cloned, Claude Code confirms the virtual environment has `requests` and `python-dotenv` installed, your `.env` file contains your Firecrawl API key, and `.env` is listed in your `.gitignore`.

---

## Part 02: Python Pipeline — Firecrawl

### Step 01: Search + Scrape Chipotle IR

Find pages worth scraping and get their markdown in a single call. Firecrawl's `search` endpoint runs a web query, then automatically scrapes each result page. You send a query, you get back a list of URLs with titles, descriptions, and cleaned markdown content.

Demo target: **Chipotle Investor Relations (IR)** content. IR pages are public by legal requirement and include press releases, leadership bios, and earnings material — the kind of content a knowledge base needs.

**SDK or raw HTTP?** Firecrawl publishes a Python SDK called `firecrawl-py`, and most of their docs use it. This tutorial uses raw `requests` instead — the same pattern MP03 used for WeatherAPI. Two reasons: you already know `requests` from MP03, and HTTP endpoints are more stable than SDK versions (we hit an SDK import-path break while writing this tutorial). Under the hood the SDK is doing `requests.post()` too. If you later want the SDK for a project, `pip install firecrawl-py` and swap it in — the request body we build below matches what the SDK sends.

**What to do:**

1. In Cursor, create `scrape_pipeline.py`. Save it (`Cmd+S` / `Ctrl+S`).

2. **Copy** these imports:

   ```python
   import os
   import re
   import time
   from pathlib import Path
   from dotenv import load_dotenv
   import requests
   ```

   `re`, `time`, and `Path` are used in Step 02.

3. **Type** these lines to load your key and create the client:

   ```python
   load_dotenv()

   api_key = os.getenv("FIRECRAWL_API_KEY")
   ```

   `load_dotenv()` reads `.env` into the environment so `os.getenv("KEY")` can retrieve values. Your key never appears in the source.

4. **Copy** this code below the client setup. It builds the request, sends it, and prints the raw response so you can see exactly what Firecrawl sent back:

   ```python
   # --- Step 01: Search + scrape with Firecrawl ---

   api_url = "https://api.firecrawl.dev/v2/search"

   headers = {
       "Authorization": f"Bearer {api_key}"
   }

   payload = {
       "query": "Chipotle investor relations press releases",
       "limit": 5,
       "scrapeOptions": {"formats": ["markdown"]}
   }

   response = requests.post(api_url, headers=headers, json=payload)

   print(response)
   print(response.text)
   ```

   Each line has a specific job, same shape as MP03's Weather API call:
   - `api_url` — the endpoint you are hitting.
   - `headers` — a dict of HTTP headers. Firecrawl authenticates via `Authorization: Bearer <your-key>` instead of a `?key=...` URL parameter like WeatherAPI used.
   - `payload` — the request body. Goes as JSON because this is a `POST`, not a `GET`.
   - `requests.post()` — sends the HTTP POST request and returns the response.

5. **Save** and run. Two ways to do this:

   - **Ask Claude Code to run it.** Type something like `run scrape_pipeline.py`. Claude Code uses the venv automatically.
   - **Run it yourself in the terminal.** First activate the venv: `source venv/bin/activate` (Mac) or `venv\Scripts\activate` (Windows). Then:

     ```bash
     python scrape_pipeline.py
     ```

     If you skip the activate step, you will hit `ModuleNotFoundError: No module named 'dotenv'` because the system Python cannot see the venv's packages.

   You should see `<Response [200]>` (the Response object's repr — the `200` inside means the call succeeded) followed by a wall of JSON — the raw search results with titles, URLs, and scraped markdown for each page. It is dense and hard to read, which is exactly why the next step parses it.

6. **Replace** `print(response)` and `print(response.text)` with parsing logic that turns the JSON into usable data and prints a clean summary:

   ```python
   data = response.json()
   results = data["data"]["web"]
   print(f"Firecrawl returned {len(results)} results")

   for r in results:
       print(f"  - {r['title']}")
       print(f"    {r['url']}")
       print(f"    markdown length: {len(r.get('markdown') or '')} chars")
   ```

   - `response.json()` — converts the JSON string from the previous step into a Python dictionary.
   - `data["data"]["web"]` — drills into the nested structure to get the list of search results. The outer `data` key holds the payload; `web` holds the list you iterate.
   - Each `r` in the loop is a dict with keys like `title`, `url`, `description`, and `markdown`.

7. **Save** and run the script again. You should now see five results, each with a title, a URL from `chipotle.com` or `ir.chipotle.com`, and a non-zero markdown length. The search found the pages and scraped them in a single call.

**Why `limit=5`:** Keeps the demo fast and your credit budget low. In your project you might ask for 20 or 50.

**What the response looks like:** Firecrawl returns JSON with `{"success": true, "data": {...}, "creditsUsed": N}`. The results you want live at `data["data"]["web"]` — a list of dicts, each with `url`, `title`, `description`, and `markdown` keys. To see the full shape, add `print(data)` after the `response.json()` line.

**Why `"scrapeOptions": {"formats": ["markdown"]}`:** Firecrawl can return HTML, markdown, summaries, screenshots, or links. Markdown preserves headings/lists/tables without HTML noise — right for a knowledge base. Note the JSON uses `scrapeOptions` in camelCase (Firecrawl's API convention), not `scrape_options`.

**Boilerplate is normal:** Some scraped pages include cookie banners or footers. Claude Code synthesizes across many sources and ignores repeated boilerplate — collect sources, do not polish extractions.

**Troubleshooting:** Check `response.status_code` before trusting the body — `200` means success, `401` means bad API key, `402` means out of credits, `429` means rate-limited. If it is anything other than `200`, print `response.json()` and read the error. If a specific result has `markdown == None`, that page failed to scrape (move on — next step handles this case).

**Checkpoint:** Your script prints five Chipotle IR results with titles, URLs, and non-zero markdown lengths. Results vary from run to run — any five entries from `chipotle.com` or `ir.chipotle.com` domains means you succeeded.

### Step 02: Loop and Save to `knowledge/raw/`

You have five results with markdown already attached — search and scrape happened in Step 01's single call. This step loops over them and writes one markdown file per result.

You wrote the API call by hand in Step 01 so you understand what is happening. For this step, you hand the loop-and-save work to Claude Code. This is the real workflow: you build the parts that require judgment, the AI writes the boilerplate around them — and in this case, you also practice letting the AI help you *design* the boilerplate before it writes any code.

**What to do:**

1. **Start a brainstorming session.** Paste this into Claude Code:

   ```
   I want to extend scrape_pipeline.py so it saves each Firecrawl
   search result as a markdown file in knowledge/raw/. Help me
   decide how.
   ```

   This deliberately gives Claude Code almost nothing to go on. If the `superpowers:brainstorming` skill is installed, Claude Code should recognize the open-ended phrasing, refuse to start writing code, and ask clarifying questions one at a time — things like: *How should filenames be named? What goes at the top of each file? What happens if a result has no markdown?* Answer each question as it comes.

   If you do not have Superpowers installed, this step still works — Claude Code will just ask fewer questions up front. Either way, the goal is the same: talk through the design, then let Claude Code implement it.

2. **Open `scrape_pipeline.py` in Cursor and read the new Step 02 block Claude Code wrote.** Do not accept it blindly. Walk through the code line by line and ask yourself:

   - Does it create `knowledge/raw/` if the folder does not exist yet?
   - Does it loop over the `results` list from your Step 01 code?
   - How does it turn each result's title into a filename?
   - What happens if a result has no markdown content?
   - Does it include the source URL somewhere so you can trace each file back to its origin?

   If the answer to any of these is unclear or unsatisfying, go back to Claude Code and ask it to explain or change it. Reading AI-generated code and deciding whether it does what you asked is the skill you are practicing here — it matters more than the writing.

3. **Save** and run (same two ways as Step 01 — ask Claude Code, or activate the venv first, then `python scrape_pipeline.py`).

   You should see up to five files being written. Open `knowledge/raw/` in Cursor to inspect them.

**Why brainstorm instead of copy-paste?** A well-specified prompt is itself an engineering skill. If your initial request is vague ("save the results to files"), a good AI collaborator should not jump straight to code — it should surface the decisions hiding in your request (filenames? headers? empty-result handling?) and let you answer them. That is the whole point of the `superpowers:brainstorming` skill: turn an idea into a design through dialogue, *then* implement. You practiced that here. In your portfolio project, you will use the same move for every non-trivial feature.

**When the brainstorm asks about filenames:** Search results can share titles — Firecrawl sometimes returns multiple pages titled "News Releases." A title-based slug alone causes filename collisions. Tell Claude Code to prefix filenames with a zero-padded index (`01-`, `02-`) so each file is unique and sorts in order.

**When the brainstorm asks about the file header:** Ask for the source URL at the top of each file. That provenance is what lets Claude Code cite where each fact came from when it later reads `knowledge/raw/` to write your wiki pages.

**When the brainstorm asks about empty results:** Firecrawl may return `None` for the markdown field if a specific page could not be rendered. Tell Claude Code to skip those instead of writing empty files — a zero-byte file is worse than no file.

**Checkpoint:** You have up to five markdown files in `knowledge/raw/`, each with a title header, source URL, and scraped content. If a result's markdown was empty, the script skipped it. This is the full Python pipeline: **search + scrape → loop → save**.

---

## Part 03: MCP Upgrade

### Step 03: Install Firecrawl MCP

Install the Firecrawl MCP server so Claude Code can call Firecrawl directly, no Python needed.

**What is MCP?** MCP stands for **Model Context Protocol** — a way to plug external tools into an AI agent. Anthropic published the spec; Firecrawl, GitHub, and many others publish MCP servers that expose their services to Claude Code. When you install an MCP server, its tools show up alongside Claude Code's built-in tools, and you can invoke them in plain prompts. Think of MCPs as "apps for Claude Code."

**What to do:**

1. **Install the Firecrawl MCP server.** First, return to your regular shell prompt: inside Claude Code, type `exit` (or press `Ctrl+D`) to leave the Claude Code session. You should now see your shell prompt (`$` on Mac, `>` on Windows). Cursor's built-in terminal panel is fine — you do not need a new window.

   **Before running the next command, replace `YOUR_FIRECRAWL_KEY` in the URL with your actual `fc-...` key from `.env`.** Copy-paste, then edit the URL in your terminal before pressing Enter:

   ```bash
   claude mcp add --transport http --scope user firecrawl https://mcp.firecrawl.dev/YOUR_FIRECRAWL_KEY/v2/mcp
   ```

   You should see a confirmation message that the server was added.

2. **Restart Claude Code** in your `chipotle-scrape-pipeline` repo terminal:

   ```bash
   claude
   ```

3. **Verify the MCP is connected.** Inside Claude Code, type:

   ```
   /mcp
   ```

   You should see `firecrawl` listed as `✔ connected`. If it shows an error, check the command you used (typos in the URL or key are the most common cause).

**Why `--scope user`?** The Firecrawl MCP install embeds your key in the server URL. Project scope would write that URL (and key) into `.claude/settings.json` inside your public repo. User scope writes to `~/.claude/` instead — keys stay off GitHub. Same principle as Step 00's `.env`.

**Heads-up:** The MCP install is a one-time thing per machine. You do not need to reinstall this MCP for future projects — it will be available in any Cursor window where you run Claude Code.

**Checkpoint:** `/mcp` inside Claude Code shows `firecrawl` as `✔ connected`. If it fails, exit Claude Code, check the install command you ran, and re-run it.

### Step 04: Replicate the Pipeline via One MCP Prompt

The Python pipeline is ~30 lines. This step collapses it into one prompt via the Firecrawl MCP you installed in Step 03. Same result, zero code.

**What to do:**

1. Make sure you are in the `chipotle-scrape-pipeline` repo directory with Claude Code running.

2. Paste this prompt:

   ```
   Use the firecrawl search tool to find 5 URLs about Chipotle's
   executive leadership team and senior hires, scraping each as
   markdown. Save each result to knowledge/raw/ with filenames like
   leadership-NN-slug.md (zero-padded index, title-based slug).
   Include the source URL at the top of each file.
   ```

3. Watch:
   - Claude Code picks the right Firecrawl MCP tool
   - Loops over the returned results
   - Writes markdown files to `knowledge/raw/`

   No Python. No `requests.post`. No `os.getenv`. Claude Code is the executor.

4. Check `knowledge/raw/` in Cursor's file explorer. You should see the `leadership-NN-slug.md` files that Claude Code created, alongside the `NN-slug.md` files your Python script already saved in Step 02. Your knowledge base just grew by five entries covering a different content type (leadership, not press releases), and you only wrote one sentence of instruction.

**Which tool will Claude Code actually call?** The Firecrawl MCP server exposes several tools — the one that combines search and scraping has a name you do not need to memorize. Claude Code will pick the right one from your natural-language prompt. If you want to see what is available, type `/mcp` inside Claude Code to list every connected tool.

**Why the filename format in the prompt:** Precise naming prevents Claude Code from inventing its own. The `leadership-` prefix also keeps MCP-created files separate from the `NN-slug.md` press-release files Step 02 saved. Different query, different prefix, different content — same knowledge base.

**Why this matters for your project:** Milestone 02 needs ≥15 sources in `knowledge/raw/` from 3+ sites, automated via GitHub Actions. Use MCP to explore your domain, then formalize the best sources into a Python pipeline. MCP for exploration, Python for production.

**When to use Python vs MCP:**

| Situation | Use | Why |
|---|---|---|
| Scheduled, automated production pipeline | Python | Fixed response schema, deterministic parameters, easy to version and test |
| Exploring an unfamiliar domain before committing to a pipeline | MCP | One prompt beats 30 lines of code when you do not yet know what to collect |
| Adding known sources you found manually | MCP | Fast, no code to maintain for a handful of URLs |
| Reproducible collection that must run the same way every day | Python | Deterministic, version-controlled, testable |

**If something goes wrong:**

- **The Firecrawl tool is not listed:** Check `/mcp` inside Claude Code. If `firecrawl` is not `✔ connected`, revisit Step 03's install command. You may need to restart Claude Code (`exit`, then `claude` again).
- **Claude Code writes files to the wrong place:** Claude Code interprets paths relative to the current directory. Confirm you ran `claude` from inside your `chipotle-scrape-pipeline` repo (not your portfolio project, not your home directory). If files landed in the wrong folder, run `pwd` to see where Claude Code is, then tell it: `Move the leadership-NN-slug.md files you just created into knowledge/raw/ under the current directory.`

**Checkpoint:** You see up to 5 new `leadership-NN-slug.md` files in `knowledge/raw/` that Claude Code created via the MCP tool, without you writing any Python. If a scrape returned empty content, Claude Code may have skipped that result — fewer than 5 files is normal for the same reasons Step 02 noted. This is the same pipeline you wrote in Part 02, issued as one sentence instead of ~30 lines of code.

---

## Part 04: Project Connection

Part 04 has 20 minutes. If you are running short on time, skip Step 05's brainstorming prompt and jump directly to Step 06 Option B using a domain topic you already know. Step 07 (commit and push) is required regardless — leave time for it.

### Step 05: Find Sources for Your Portfolio Project

You are done with the `chipotle-scrape-pipeline` demo repo. For the rest of class, you will work inside [your portfolio project](https://github.com/LMU-ISBA/isba-4715-f26/tree/main/project) repo — applying the same pattern to your own domain.

Your project's knowledge base needs at least 15 sources from 3+ different sites by Milestone 02. Today you are getting at least one. The pattern is the same as what you just did with Chipotle; only the query changes. You can add more throughout the week.

**What to do:**

1. Open a **new Cursor window** (**File > New Window**). Clone your portfolio project repo into it the same way you did for `chipotle-scrape-pipeline` in Step 00. Start Claude Code in the terminal.

2. You are now working in your portfolio project repo, not the scrape pipeline. If your portfolio repo does not have a `knowledge/raw/` folder yet, create one:

   ```bash
   mkdir -p knowledge/raw
   ```

3. Brainstorm source candidates with Claude Code. The prompt below references `docs/job-posting.pdf` and `docs/proposal.md` — if your portfolio repo does not yet have those files, either add them now or remove those references from the prompt before pasting:

   ```
   I'm building a portfolio project targeting a [job title] role in
   [industry]. Based on my job posting (in docs/job-posting.pdf) and
   my proposal (in docs/proposal.md), suggest 5 unstructured web
   sources I should scrape into my knowledge base. For each source,
   give me a Firecrawl search query I could use.
   ```

4. Pick one source to scrape right now. You can scrape more async this week.

**If your target site blocks scraping:** Some sites (LinkedIn full profiles, many SaaS dashboards, sites behind aggressive Cloudflare) return 403 errors or empty content through Firecrawl. Public fallbacks that almost always work:

- Company investor relations pages (`ir.<company>.com`)
- SEC filings ([sec.gov/cgi-bin/browse-edgar](https://www.sec.gov/cgi-bin/browse-edgar))
- Press release archives (PR Newswire, Business Wire, GlobeNewswire)
- Wikipedia
- Seeking Alpha earnings call transcripts (free tier previews only — full transcripts require an account)
- Company blog posts and newsroom pages

**Checkpoint:** You have identified at least one specific URL or site pattern relevant to your portfolio project. Write it down in a scratch note or terminal comment — you will use it in Step 06.

---

### Step 06: Scrape at Least One Source into Your Project

**What to do:**

1. You have two ways to scrape into your portfolio repo's `knowledge/raw/`. **For the remaining class time, use Option B — it is faster and you already have Claude Code running with the Firecrawl MCP connected.** Option A is the approach you will formalize for GitHub Actions later in your project, so you may prefer it async this week.

   **Option B — use the MCP prompt.** In your portfolio repo's Claude Code session, paste a prompt similar to Step 04's, but with your own query. Example:

   ```
   Use the firecrawl search tool to find 3 URLs about [your industry
   topic] and scrape each as markdown. Save each result to knowledge/raw/
   with filenames like NN-slug.md. Include the source URL at the top
   of each file.
   ```

   **Option A — reuse your Python script.** Follow this sequence exactly — the ordering matters so your key never reaches git:

   1. Open your portfolio repo's `.gitignore` and confirm `.env` is listed. If it is not, add `.env` on its own line and save the file.
   2. Only then copy `scrape_pipeline.py` and `.env` from your `chipotle-scrape-pipeline` repo into your portfolio repo.
   3. Run `git status` in your portfolio repo. If `.env` appears as an untracked file in the output, your gitignore is wrong — stop and fix it before continuing.
   4. Change the Firecrawl query in the script to something relevant to your project, then run it.

2. Confirm at least one new `.md` file appears in your portfolio repo's `knowledge/raw/`. Open it and verify the content is relevant to your domain — not every scrape is useful, and this is the moment to catch sources that will not help your knowledge base.

**Why source quality matters:** Milestone 02's wiki grade comes from what Claude Code synthesizes from `knowledge/raw/`. Cookie banners produce bad wikis; real press releases and earnings content produce wikis you can defend in your final interview.

**Checkpoint:** Your portfolio project repo has one or more markdown files in `knowledge/raw/` scraped from a real source relevant to your job posting.

---

### Step 07: Commit and Push

**What to do:**

You have two Cursor windows open (one per repo). Run each step in its respective window.

1. In the `chipotle-scrape-pipeline` Claude Code session, first run `git status` yourself in the terminal and look at the staged-and-untracked file list. If you see `.env` listed anywhere, STOP — your gitignore is missing `.env` and you need to fix it before continuing.

2. Once `git status` is clean, use Claude Code to finish the commit:

   ```
   Save pip freeze to requirements.txt, then commit all files and
   push to GitHub. Before staging, run `git status` and abort if .env
   appears in the output.
   ```

3. In the portfolio repo's Claude Code session, run `git status` yourself first. Again, confirm no `.env` entry. Then use Claude Code:

   ```
   Commit the new files in knowledge/raw/ and push to GitHub. Before
   staging, run `git status` and abort if .env appears in the output.
   ```

4. Verify both repos on GitHub. Open each repo's root directory in the GitHub file browser and confirm:
   - `knowledge/raw/` is visible and contains your markdown files
   - `.env` does NOT appear in the root file listing

**Checkpoint:** Both repos are pushed, and the GitHub root file listing for each shows no `.env` file.

---

## Submission

Push your finished `chipotle-scrape-pipeline` repository to GitHub and submit the repo URL as your Lesson Exercises 09.

Your `chipotle-scrape-pipeline` repo should contain:
- `scrape_pipeline.py` — your Firecrawl pipeline
- `knowledge/raw/` — at least 5 `NN-slug.md` files from the Python pipeline (Step 02) AND at least 1 `leadership-NN-slug.md` file from the MCP prompt (Step 04). Both naming patterns are expected.
- `requirements.txt` — Python dependencies
- `.gitignore` — Python gitignore (must exclude `.env`)

Your `chipotle-scrape-pipeline` repo must NOT contain:
- `.env` — must be gitignored, no keys in git history

**Optional but encouraged:** at least one new markdown file in your portfolio project repo's `knowledge/raw/`. This does not affect your Lesson 09 grade, but it is concrete progress toward Milestone 02's 15-source requirement.

You built a full scraping pipeline and seeded your portfolio knowledge base with real content.
