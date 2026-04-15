# Mini-Project 04: Scrape Pipeline Tutorial

This is the written companion to Lesson 09. The class opens with a 20-minute concepts block (see the slides, not this file) — the rest is hands-on. Use this if you fall behind, or to work through it on your own.

## Table of Contents

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 00 | [Create repo and start Claude Code](#step-00-create-github-repo-and-start-claude-code) | Set up the project repo, sign up for Firecrawl and Tavily, create .env |
| 01 | [Search with Tavily](#step-01-search-with-tavily) | Make your first Tavily call to find Chipotle IR content |
| 02 | [Scrape one URL with Firecrawl](#step-02-scrape-one-url-with-firecrawl) | Get clean markdown from a single URL |
| 03 | [Loop and save to knowledge/raw/](#step-03-loop-and-save-to-knowledgeraw) | Combine search + scrape + file write into one pipeline |
| 04 | [Install Firecrawl MCP and Tavily MCP](#step-04-install-firecrawl-mcp-and-tavily-mcp) | Add both MCP servers to Claude Code |
| 05 | [Replicate the pipeline via one MCP prompt](#step-05-replicate-the-pipeline-via-one-mcp-prompt) | Issue a single directive that replaces 35 lines of Python |
| 06 | [Find sources for your portfolio project](#step-06-find-sources-for-your-portfolio-project) | Open your project repo in a new Cursor window |
| 07 | [Scrape at least one source into your project](#step-07-scrape-at-least-one-source-into-your-project) | Apply the pattern to your own domain |
| 08 | [Commit and push](#step-08-commit-and-push) | Push both repos to GitHub |

---

## Part 01: Setup

### Step 00: Create GitHub Repo and Start Claude Code

Same workflow as MP02 and MP03: create the repo on GitHub first, clone it into Cursor, then start building. This time you also sign up for two hosted scraping services before you touch any code.

**What to do:**

1. Go to [github.com/new](https://github.com/new) and create a new repository:
   - Name it `scrape-pipeline`
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
   └── scrape-pipeline/           <-- MP04
   ```

4. Open a terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal**) and start Claude Code:
   ```bash
   claude
   ```

5. Ask Claude Code to set up the environment:

   ```
   Set up a Python venv and install requests, python-dotenv, tavily-python, firecrawl-py. Activate it.
   ```

   The install takes 30-60s. **While it runs, sign up in your browser (steps 6-7).** To run Python outside Claude Code later: `source venv/bin/activate` (Mac) or `venv\Scripts\activate` (Windows).

6. **Sign up for Firecrawl** at [firecrawl.dev](https://firecrawl.dev) (GitHub sign-in). Dashboard → **API Keys** → copy the `fc-...` key.

7. **Sign up for Tavily** at [tavily.com](https://tavily.com) (GitHub sign-in). Dashboard → copy the `tvly-...` key.

8. Create `.env` in your project root. Replace the placeholders with your actual keys:

   ```
   FIRECRAWL_API_KEY=fc-your_firecrawl_key_here
   TAVILY_API_KEY=tvly-your_tavily_key_here
   ```

9. Verify `.env` is in your `.gitignore` — **before your first commit**. The Python template already includes it; if not, add `.env` on its own line.

**Why `.env` instead of pasting keys into code?** MP03 hardcoded the WeatherAPI key into `weather.py` — fine for a demo, but any commit would leak the key to a public repo. From MP04 forward, keys live in `.env` (gitignored), loaded at runtime with `os.getenv()`. Same pattern as the async Spotify tutorial.

**Why two services:** [Tavily](https://tavily.com) searches the web (**discover**) and [Firecrawl](https://firecrawl.dev) turns URLs into markdown (**extract**). Together they are the two halves of scraping.

**Free tiers:** 500 Firecrawl scrapes/month, 1,000 Tavily searches/month — plenty for the semester.

**Checkpoint:** Your `scrape-pipeline` repo is cloned, Claude Code confirms the virtual environment has `requests`, `python-dotenv`, `tavily-python`, and `firecrawl-py` installed, your `.env` file contains both API keys, and `.env` is listed in your `.gitignore`.

---

## Part 02: Python Pipeline — Tavily + Firecrawl

### Step 01: Search with Tavily

Find URLs worth scraping. You call Tavily (an AI-native search service) with its Python SDK and get back ranked URLs with content previews.

Demo target: **Chipotle Investor Relations (IR)** content. IR pages are public, accessible by design, and full of press releases, bios, and earnings content — a reliable knowledge-base source.

**What is an SDK?** A Software Development Kit wraps an API in your language. In MP03 you wrote `requests.get(url)` with a URL string. Tavily's `tavily-python` and Firecrawl's `firecrawl-py` hide the URL and HTTP details behind a client object you call methods on. Under the hood it is still an HTTP call — the SDK just handles the plumbing.

**What to do:**

1. In Cursor, create a new file: `scrape_pipeline.py`. Save it immediately (`Cmd+S` / `Ctrl+S`).

2. **Copy** these imports into the file:

   ```python
   import os
   import re
   import time
   from pathlib import Path
   from dotenv import load_dotenv
   from tavily import TavilyClient
   from firecrawl import Firecrawl
   ```

   You do not use them all yet (`re`, `time`, `Path` appear in Step 03; `Firecrawl` in Step 02). Importing upfront keeps the file tidy.

**Heads-up about the Firecrawl class name:** The current SDK import is `from firecrawl import Firecrawl`. Older tutorials and Stack Overflow answers may show `from firecrawl import FirecrawlApp` — that was the previous class name. If you see `FirecrawlApp` anywhere, replace it with `Firecrawl`.

3. **Type** these lines by hand to load your keys and create both clients:

   ```python
   load_dotenv()

   tavily_client = TavilyClient(api_key=os.getenv("TAVILY_API_KEY"))
   firecrawl = Firecrawl(api_key=os.getenv("FIRECRAWL_API_KEY"))
   ```

   `load_dotenv()` reads `.env` into the environment so `os.getenv("KEY")` can retrieve values. Your keys never appear in the source. Both clients are created together (Firecrawl is used in Step 02) to keep setup in one place.

4. **Copy** this code below the client setup:

   ```python
   # --- Step 01: Search with Tavily ---

   response = tavily_client.search(
       query="Chipotle investor relations press releases",
       max_results=5,
   )

   results = response["results"]
   print(f"Tavily returned {len(results)} results")

   for result in results:
       print(f"  - {result['title']}")
       print(f"    {result['url']}")
   ```

5. **Save** and run:

   ```bash
   python scrape_pipeline.py
   ```

   You should see five results, all from `ir.chipotle.com` or `chipotle.com` domains. Titles will look like "News Releases", "Chipotle InvestorRoom - Home", or specific press release headlines.

**Why `max_results=5`:** Keeps the demo fast and your Firecrawl budget low. In your project you might ask for 20 or 50.

**What the response looks like:** `response` is a dictionary. The interesting part is `response["results"]`, a list of dictionaries, each with `url`, `title`, `content`, `score`, and `raw_content`. If you want to see the full shape, add `print(response)` or `import json; print(json.dumps(response, indent=2))` to inspect it.

**Heads-up about the docs:** Tavily's docs ([docs.tavily.com](https://docs.tavily.com/documentation/quickstart)) show the same SDK pattern you have here. Older tutorials using `requests.post` against `api.tavily.com/search` make the same HTTP call under the hood — use the SDK.

**Troubleshooting:** If `response["results"]` raises `KeyError`, add `print(response)` after the `search(...)` call and rerun — you will see an auth error, rate-limit message, or query typo.

**Checkpoint:** Your script prints five Chipotle IR URLs with titles. Tavily results vary from run to run — any five URLs from `chipotle.com` or `ir.chipotle.com` domains means you succeeded.

### Step 02: Scrape One URL with Firecrawl

Now turn one of those URLs into markdown. Firecrawl handles the HTML parsing — you send a URL, you get back clean markdown.

**What to do:**

1. Pick one URL from the Step 01 output (you will scrape all of them in Step 03). For now, just scrape the first result. **Copy** this code below your Step 01 loop:

   ```python
   # --- Step 02: Scrape one URL with Firecrawl ---

   sample_url = results[0]["url"]

   doc = firecrawl.scrape(sample_url, formats=["markdown"])

   print("Title:", doc.metadata.get("title"))
   print("Markdown length:", len(doc.markdown), "chars")
   print()
   print("--- first 400 chars ---")
   print(doc.markdown[:400])
   ```

2. **Save** and run:

   ```bash
   python scrape_pipeline.py
   ```

   You should see a title, a markdown length in the thousands of characters, and a preview starting with the page's actual content (something like `# News Releases` or a press release headline).

**Two SDK shapes:** Tavily returns a `dict` (bracket access: `response["results"]`). Firecrawl returns a `Document` object (dot access: `doc.markdown`). One quirk: `doc.metadata` is itself a dict, so `doc.metadata.get("title")` mixes both patterns.

**Why `formats=["markdown"]`:** Firecrawl can return HTML, markdown, summaries, screenshots, or links. Markdown preserves headings/lists/tables without HTML noise — right for a knowledge base. The `formats` parameter is a list, so you can request multiple formats in one call.

**Boilerplate is normal:** Some scraped pages include cookie banners or footers. Claude Code synthesizes across many sources and ignores repeated boilerplate — collect sources, do not polish extractions.

**Troubleshooting:** Empty `doc.markdown` or an exception? Add `print(doc)` after `scrape()`. An `AttributeError: 'NoneType'` means the scrape returned `None` — try a different URL. Persistent failures: check [Firecrawl's status page](https://status.firecrawl.dev/).

**Checkpoint:** Your script prints a page title, a multi-thousand-character markdown length, and a preview of the scraped content. If the title shows `None`, that is not a failure — some pages do not expose a title in their metadata. The markdown length being non-zero is the real success signal.

### Step 03: Loop and Save to `knowledge/raw/`

You have one URL scraped. The loop below does all five. Same shape as MP03's `request → parse → loop → save`.

**What to do:**

1. **Comment out or delete** your Step 02 code (everything below `# --- Step 02 ---`, including `sample_url` and `doc = firecrawl.scrape(...)`). The loop supersedes it. Your `firecrawl` client from Step 01 stays.

2. **Copy** this code below your Step 02 code (or in place of it):

   ```python
   # --- Step 03: Loop and save to knowledge/raw/ ---

   out_dir = Path("knowledge/raw")
   out_dir.mkdir(parents=True, exist_ok=True)

   def slugify(title: str) -> str:
       s = re.sub(r"[^a-zA-Z0-9]+", "-", title.lower()).strip("-")
       return s[:60] or "untitled"

   for i, result in enumerate(results, start=1):
       url = result["url"]
       title = result["title"]
       print(f"[{i}/{len(results)}] {title}")

       doc = firecrawl.scrape(url, formats=["markdown"])
       md = doc.markdown or ""

       if not md:
           print("  skipped (empty markdown)")
           continue

       fname = f"{i:02d}-{slugify(title)}.md"
       out_path = out_dir / fname
       header = f"# {title}\n\nSource: {url}\n\n---\n\n"
       out_path.write_text(header + md)
       print(f"  saved: {out_path} ({len(md)} chars)")

       time.sleep(1)

   print("\nDone. Files in knowledge/raw/:")
   for f in sorted(out_dir.iterdir()):
       print(f"  {f.name}")
   ```

3. **Save** and run:

   ```bash
   python scrape_pipeline.py
   ```

   You should see five files being written. Open `knowledge/raw/` in Cursor's file explorer and inspect one or two — they are real press release and IR page content, formatted as markdown.

**What `slugify()` does:** The helper turns a page title into a filename-safe string. For example, `"News Releases — Q1 2025"` becomes `"news-releases-q1-2025"`. The regex `[^a-zA-Z0-9]+` replaces any run of non-alphanumeric characters with a single hyphen, `.strip("-")` trims hyphens at the ends, and `[:60]` caps length so long titles do not produce unwieldy filenames.

**Why the index prefix in filenames (`01-`, `02-`):** Tavily can return multiple URLs with the same title — when I tested this query, three of the five results all had the title "News Releases". A slug alone would cause filename collisions and overwrite files you already saved. The index prefix guarantees unique, ordered filenames. Your knowledge base cares about coverage, not file naming, but naming that sorts cleanly is a nice-to-have.

**Why the 1-second sleep:** Rate-limit etiquette. Zero-delay API calls get your key banned.

**Why the source URL header:** Lets Claude Code cite where each fact came from when it reads `knowledge/raw/`. Preserve provenance.

**Why `doc.markdown or ""` and the `if not md: continue` guard:** If Firecrawl cannot render the page, `doc.markdown` may be `None`. The `or ""` converts `None` to an empty string so the next line does not crash trying to check its length. The `if not md: continue` guard then skips the file write when the string is empty (Python treats both `None` and `""` as falsy), so you do not create a zero-byte file for a failed scrape.

**Checkpoint:** You have up to five markdown files in `knowledge/raw/` (one per Tavily result that Firecrawl successfully scraped), each with a title header, source URL, and scraped content. If a result returned empty markdown, the script skipped it and you will see fewer files — that is normal. This is the full Python pipeline: **search → extract → loop → save**.

---

## Part 03: MCP Upgrade

### Step 04: Install Firecrawl MCP and Tavily MCP

Install two MCP servers so Claude Code can call Tavily and Firecrawl directly, no Python needed.

**What is MCP?** MCP stands for **Model Context Protocol** — a way to plug external tools into an AI agent. Anthropic published the spec; Tavily, Firecrawl, GitHub, and many others publish MCP servers that expose their services to Claude Code. When you install an MCP server, its tools show up alongside Claude Code's built-in tools, and you can invoke them in plain prompts. Think of MCPs as "apps for Claude Code."

**What to do:**

1. **Install the Firecrawl MCP server.** First, return to your regular shell prompt: inside Claude Code, type `exit` (or press `Ctrl+D`) to leave the Claude Code session. You should now see your shell prompt (`$` on Mac, `>` on Windows). Cursor's built-in terminal panel is fine — you do not need a new window.

   **Before running the next command, replace `YOUR_FIRECRAWL_KEY` in the URL with your actual `fc-...` key from `.env`.** Copy-paste, then edit the URL in your terminal before pressing Enter:

   ```bash
   claude mcp add firecrawl --scope user --url https://mcp.firecrawl.dev/YOUR_FIRECRAWL_KEY/v2/mcp
   ```

   You should see a confirmation message that the server was added.

2. **Install the Tavily MCP server:**

   ```bash
   claude mcp add tavily-remote-mcp --scope user --transport http https://mcp.tavily.com/mcp/
   ```

   The `--transport http` flag tells Claude Code that this server communicates over HTTP rather than running as a local process. Firecrawl's command did not need it because the URL's scheme (`https://`) already implied HTTP transport for that style of install.

   **Heads-up about the OAuth pop-up:** Tavily uses OAuth instead of an API key in the URL. The first time Claude Code calls a Tavily tool (which happens in Step 05, not right now), a browser window will open asking you to authorize. Click through to approve. This is the same OAuth pattern you saw in the async Spotify tutorial. Do not be surprised when your browser opens during the MCP demo — that is expected.

3. **Restart Claude Code** in your `scrape-pipeline` repo terminal:

   ```bash
   claude
   ```

4. **Verify both MCPs are connected.** Inside Claude Code, type:

   ```
   /mcp
   ```

   You should see both `firecrawl` and `tavily-remote-mcp` listed as `✔ connected`. If either shows an error, check the command you used (typos in the URL or key are the most common cause).

**Why `--scope user`?** Firecrawl's MCP install embeds your key in the server URL. Project scope would write that URL (and key) into `.claude/settings.json` inside your public repo. User scope writes to `~/.claude/` instead — keys stay off GitHub. Same principle as Step 00's `.env`.

**Heads-up:** The MCP install is a one-time thing per machine. You do not need to reinstall these MCPs for future projects — they will be available in any Cursor window where you run Claude Code.

**Checkpoint:** `/mcp` inside Claude Code shows both `firecrawl` and `tavily-remote-mcp` as connected. If either fails, exit Claude Code, check the install command you ran, and re-run it.

### Step 05: Replicate the Pipeline via One MCP Prompt

The Python pipeline is ~35 lines. This step collapses it into one prompt via the MCPs you installed in Step 04. Same result, zero code.

**What to do:**

1. Make sure you are in the `scrape-pipeline` repo directory with Claude Code running. If you left Claude Code earlier for the MCP install, start it again:

   ```bash
   claude
   ```

2. Paste this prompt into Claude Code exactly as written:

   ```
   Use the tavily-search tool to find 5 URLs about Chipotle's recent
   earnings announcements. Then use the firecrawl_scrape tool to fetch
   each URL as markdown and save each to knowledge/raw/ with filenames
   like earnings-NN-slug.md (zero-padded index, title-based slug).
   Include the source URL at the top of each file.
   ```

   The first time Claude Code calls the Tavily tool, your browser will open for OAuth authorization (the browser window Step 04 warned you about). Click through to approve.

   **Tool names to expect:** The prompt references `tavily-search` (Tavily's web search tool, uses hyphens) and `firecrawl_scrape` (Firecrawl's URL-to-markdown tool, uses underscores). If Claude Code mentions invoking different names or asks which tool you meant, type `/mcp` to list what is actually connected and correct the prompt.

3. Watch what Claude Code does:
   - It calls the Tavily MCP tool to search for URLs
   - It loops over the results
   - It calls the Firecrawl MCP tool for each URL
   - It writes markdown files to `knowledge/raw/`

   No Python. No SDK calls. No `os.getenv`. Claude Code is the executor.

4. Check `knowledge/raw/` in Cursor's file explorer. You should see the `earnings-NN-slug.md` files that Claude Code created, alongside the files your Python script already saved in Step 03. Your knowledge base just grew by five entries, and you only wrote one sentence of instruction.

**Why the filename format in the prompt:** Precise naming prevents Claude Code from inventing its own. The `earnings-` prefix also keeps MCP-created files separate from the `NN-slug.md` files Step 03 saved.

**Why this matters for your project:** Milestone 02 needs ≥15 sources in `knowledge/raw/` from 3+ sites, automated via GitHub Actions. Use MCP to explore your domain, then formalize the best sources into a Python pipeline. MCP for exploration, Python for production.

**When to use Python vs MCP:**

| Situation | Use | Why |
|---|---|---|
| Scheduled, automated production pipeline | Python | Fixed response schema, deterministic parameters, easy to version and test |
| Exploring an unfamiliar domain before committing to a pipeline | MCP | One prompt beats 35 lines of code when you do not yet know what to collect |
| Adding known sources you found manually | MCP | Fast, no code to maintain for a handful of URLs |
| Reproducible collection that must run the same way every day | Python | Deterministic, version-controlled, testable |

**If something goes wrong:**

- **The Tavily tool is not listed as available:** Check `/mcp` inside Claude Code. If `tavily-remote-mcp` is not `✔ connected`, revisit Step 04's install command. You may also need to restart Claude Code (`exit`, then `claude` again).
- **Claude Code writes the files to the wrong place:** Claude Code interprets paths relative to the current directory. Confirm you ran `claude` from inside your `scrape-pipeline` repo (not your portfolio project, not your home directory). If files landed in the wrong folder, run `pwd` to see where Claude Code is, then tell it: `Move the earnings-NN-slug.md files you just created into knowledge/raw/ under the current directory.`
- **The OAuth browser window did not open:** Some browsers block pop-ups from terminal-launched processes. Watch the Claude Code output for a URL — copy it into your browser manually.

**Checkpoint:** You see up to 5 new `earnings-NN-slug.md` files in `knowledge/raw/` that Claude Code created via the MCP tools, without you writing any Python. If a scrape returned empty content, Claude Code may have skipped that result — fewer than 5 files is normal for the same reasons Step 03 noted. This is the same pipeline you wrote in Part 02, issued as one sentence instead of 35 lines of code.

---

## Part 04: Project Connection

Part 04 has 20 minutes. If you are running short on time, skip Step 06's brainstorming prompt and jump directly to Step 07 Option B using a domain topic you already know. Step 08 (commit and push) is required regardless — leave time for it.

### Step 06: Find Sources for Your Portfolio Project

You are done with the `scrape-pipeline` demo repo. For the rest of class, you will work inside [your portfolio project](https://github.com/LMU-ISBA/isba-4715-f26/tree/main/project) repo — applying the same pattern to your own domain.

Your project's knowledge base needs at least 15 sources from 3+ different sites by Milestone 02. Today you are aiming for at least one. The goal is to prove the pattern transfers — the rest is volume, which you can add async throughout the week.

**What to do:**

1. Open a **new Cursor window** (**File > New Window**). Clone your portfolio project repo into it the same way you did for `scrape-pipeline` in Step 00. Start Claude Code in the terminal.

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
   give me a Tavily search query I could use.
   ```

4. Pick one source to scrape right now. You can scrape more async this week.

**If your target site blocks scraping:** Some sites (LinkedIn full profiles, many SaaS dashboards, sites behind aggressive Cloudflare) return 403 errors or empty content through Firecrawl. Public fallbacks that almost always work:

- Company investor relations pages (`ir.<company>.com`)
- SEC filings ([sec.gov/cgi-bin/browse-edgar](https://www.sec.gov/cgi-bin/browse-edgar))
- Press release archives (PR Newswire, Business Wire, GlobeNewswire)
- Wikipedia
- Seeking Alpha earnings call transcripts (free tier previews only — full transcripts require an account)
- Company blog posts and newsroom pages

**Checkpoint:** You have identified at least one specific URL or site pattern relevant to your portfolio project. Write it down in a scratch note or terminal comment — you will use it in Step 07.

---

### Step 07: Scrape at Least One Source into Your Project

**What to do:**

1. You have two ways to scrape into your portfolio repo's `knowledge/raw/`. **For the remaining class time, use Option B — it is faster and you already have Claude Code running with both MCPs connected.** Option A is the approach you will formalize for GitHub Actions later in your project, so you may prefer it async this week.

   **Option B — use the MCP prompt.** In your portfolio repo's Claude Code session, paste a prompt similar to Step 05's, but with your own query. Example:

   ```
   Use the tavily-search tool to find 3 URLs about [your industry
   topic]. Then use the firecrawl_scrape tool to save each URL as
   markdown in knowledge/raw/ with filenames like NN-slug.md. Include
   the source URL at the top of each file.
   ```

   **Option A — reuse your Python script.** Follow this sequence exactly — the ordering matters so your key never reaches git:

   1. Open your portfolio repo's `.gitignore` and confirm `.env` is listed. If it is not, add `.env` on its own line and save the file.
   2. Only then copy `scrape_pipeline.py` and `.env` from your `scrape-pipeline` repo into your portfolio repo.
   3. Run `git status` in your portfolio repo. If `.env` appears as an untracked file in the output, your gitignore is wrong — stop and fix it before continuing.
   4. Change the Tavily query in the script to something relevant to your project, then run it.

2. Confirm at least one new `.md` file appears in your portfolio repo's `knowledge/raw/`. Open it and verify the content is relevant to your domain — not every scrape is useful, and this is the moment to catch sources that will not help your knowledge base.

**Why source quality matters:** Milestone 02's wiki grade comes from what Claude Code synthesizes from `knowledge/raw/`. Cookie banners produce bad wikis; real press releases and earnings content produce wikis you can defend in your final interview.

**Checkpoint:** Your portfolio project repo has one or more markdown files in `knowledge/raw/` scraped from a real source relevant to your job posting.

---

### Step 08: Commit and Push

**What to do:**

You have two Cursor windows open (one per repo). Run each step in its respective window.

1. In the `scrape-pipeline` Claude Code session, first run `git status` yourself in the terminal and look at the staged-and-untracked file list. If you see `.env` listed anywhere, STOP — your gitignore is missing `.env` and you need to fix it before continuing.

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

Push your finished `scrape-pipeline` repository to GitHub and submit the repo URL as your Lesson Exercises 09.

Your `scrape-pipeline` repo should contain:
- `scrape_pipeline.py` — your Tavily + Firecrawl pipeline
- `knowledge/raw/` — at least 5 `NN-slug.md` files from the Python pipeline (Step 03) AND at least 1 `earnings-NN-slug.md` file from the MCP prompt (Step 05). Both naming patterns are expected.
- `requirements.txt` — Python dependencies
- `.gitignore` — Python gitignore (must exclude `.env`)

Your `scrape-pipeline` repo must NOT contain:
- `.env` — must be gitignored, no keys in git history

**Optional but encouraged:** at least one new markdown file in your portfolio project repo's `knowledge/raw/`. This does not affect your Lesson 09 grade, but it is concrete progress toward Milestone 02's 15-source requirement.

You built a full scraping pipeline, upgraded it to an MCP workflow, and seeded your portfolio project's knowledge base.
