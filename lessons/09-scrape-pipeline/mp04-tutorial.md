# Mini-Project 04: Scrape Pipeline Tutorial

This tutorial covers the in-class session for Mini-Project 04. Part 01 uses the slides. Parts 02–04 are hands-on. If you fall behind during class, use this tutorial to catch up. Every command and prompt is written out so you can follow along on your own.

## Table of Contents

| Step | Topic | What You Will Do |
|------|-------|-----------------|
| 00 | [Create repo and start Claude Code](#step-00-create-github-repo-and-start-claude-code) | Set up the project repo, sign up for Firecrawl and Tavily, create .env |
| 01 | [Search with Tavily](#step-01-search-with-tavily) | Make your first Tavily call to find Chipotle IR content |
| 02 | [Scrape one URL with Firecrawl](#step-02-scrape-one-url-with-firecrawl) | Get clean markdown from a single URL |
| 03 | [Loop and save to knowledge/raw/](#step-03-loop-and-save-to-knowledgeraw) | Combine search + scrape + file write into one pipeline |
| 04 | [Install Firecrawl MCP and Tavily MCP](#step-04-install-firecrawl-mcp-and-tavily-mcp) | Add both MCP servers to Claude Code |
| 05 | [Replicate the pipeline via one MCP prompt](#step-05-replicate-the-pipeline-via-one-mcp-prompt) | Issue a single directive that replaces 30 lines of Python |
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

3. Clone the repo into Cursor. Open a new Cursor window and click **Clone repo** on the welcome screen. Paste the URL you copied.

   When Cursor asks where to save it, navigate to your `isba-4715` folder. Open the cloned folder when prompted.

   Your folder structure should now look like:
   ```
   ~/isba-4715/
   ├── campus-bites-pipeline/     <-- MP01
   ├── basket-craft-pipeline/     <-- MP02
   ├── weather-api-pipeline/      <-- MP03
   └── scrape-pipeline/           <-- MP04 (this project)
   ```

4. Open a terminal in Cursor (`` Ctrl+` `` or **Terminal > New Terminal**).

5. Start Claude Code:
   ```bash
   claude
   ```

6. Ask Claude Code to set up the environment:

   ```
   Set up a Python virtual environment for this project and install
   requests, python-dotenv, tavily-python, and firecrawl-py. Activate
   the virtual environment.
   ```

   The install takes 30-60 seconds. **While Claude Code runs the install, move ahead to steps 7-8 and sign up for the two services in your browser.** You will come back to the terminal once the install finishes.

   Claude Code runs commands in its own shell, so it can use the venv for running your scripts. If you ever need to run Python directly in your own terminal (outside Claude Code), activate the venv first:
   - **Mac:** `source venv/bin/activate`
   - **Windows:** `venv\Scripts\activate`

7. **Sign up for Firecrawl.** Go to [firecrawl.dev](https://firecrawl.dev) and sign in with GitHub. From the dashboard, open **API Keys** and copy the default key (it starts with `fc-`).

8. **Sign up for Tavily.** Go to [tavily.com](https://tavily.com) and sign in with GitHub. From the dashboard, copy your API key (it starts with `tvly-`).

9. Create a `.env` file in your project root. Paste your two keys, replacing the placeholders on the right side of each `=`:

   ```
   FIRECRAWL_API_KEY=fc-your_firecrawl_key_here
   TAVILY_API_KEY=tvly-your_tavily_key_here
   ```

10. Verify `.env` is listed in your `.gitignore` — do this **before your first commit**. Open `.gitignore` and search for `.env`. The Python template already includes it. If it does not, add `.env` on its own line.

**Why `.env` instead of pasting keys into your code?** In MP03 you typed the WeatherAPI key directly into `weather.py`. That was fine for a quick demo, but it means the key ends up in your git history the moment you commit — and if your repo is public (which yours is), anyone can read it and use your quota. From MP04 forward, keys live in `.env`, `.env` is gitignored, and your Python code reads them with `os.getenv()` at runtime. Your scripts become safe to publish; your keys stay on your machine. This is the pattern every professional Python project uses (if you completed the async Spotify tutorial, you saw it there too).

**Why two services:** Tavily searches the web and returns structured URLs. Firecrawl takes a URL and returns clean markdown. Together they cover the two halves of web scraping: **discover** and **extract**. You will use both in your pipeline, and both in the MCP demo later.

**Free tier limits:** Firecrawl gives you 500 scrapes per month. Tavily gives you 1,000 searches per month. Both are far more than you need for this lesson and the rest of the semester.

**Checkpoint:** Your `scrape-pipeline` repo is cloned, Claude Code confirms the virtual environment has `requests`, `python-dotenv`, `tavily-python`, and `firecrawl-py` installed, your `.env` file contains both API keys, and `.env` is listed in your `.gitignore`.

---

## Part 02: Python Pipeline — Tavily + Firecrawl

### Step 01: Search with Tavily

Your first job is to find things worth scraping. Instead of hand-picking URLs, you will use Tavily — an AI-native search service that returns a ranked list of URLs plus short content previews for any query. You call it with the Python SDK you installed in Step 00.

The demo target is **Chipotle Investor Relations (IR)** content. IR pages are the public-facing section of a company's website aimed at shareholders and analysts. Public companies are required to make them accessible, so no auth walls, no aggressive bot blocking, and abundant unstructured content: press releases, leadership bios, earnings highlights. That is exactly the shape your knowledge base needs, which makes it the right demo target.

**What is an SDK?** SDK stands for **Software Development Kit** — a library that wraps an API in your language of choice. In MP03 you called the Weather API with raw `requests.get(...)` and a URL. Tavily and Firecrawl both publish Python SDKs (`tavily-python` and `firecrawl-py`, which you installed in Step 00) that do the same thing but hide the URL and HTTP details. Instead of building a request, you call a method on a client object and get back a Python data structure. Less boilerplate, easier to read, and the provider's docs are written around it — so when you paste sample code from Tavily or Firecrawl, it matches what you have here. Under the hood, the SDK is still making HTTP calls.

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

   You do not use all of these yet — `re`, `time`, and `Path` show up in Step 03, and `Firecrawl` shows up in Step 02. Importing them all now keeps the file from growing messier as you add each piece.

**Heads-up about the Firecrawl class name:** The current SDK import is `from firecrawl import Firecrawl`. Older tutorials and Stack Overflow answers may show `from firecrawl import FirecrawlApp` — that was the previous class name. If you see `FirecrawlApp` anywhere, replace it with `Firecrawl`.

3. **Type** these lines by hand to load your keys and create both clients:

   ```python
   load_dotenv()

   tavily_client = TavilyClient(api_key=os.getenv("TAVILY_API_KEY"))
   firecrawl = Firecrawl(api_key=os.getenv("FIRECRAWL_API_KEY"))
   ```

   `load_dotenv()` reads your `.env` file at runtime and loads each `KEY=value` line into the environment. `os.getenv("TAVILY_API_KEY")` then retrieves the value you stored. This is the `.env` pattern Step 00 introduced — your key never appears in the source code, so committing `scrape_pipeline.py` to GitHub is safe. `TavilyClient` wraps the Tavily API in a Python object so you can call methods on it instead of building HTTP requests by hand. You create the `firecrawl` client now as well, even though Step 01 only uses Tavily — keeping all client setup in one place makes the file easier to read as it grows.

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

**Heads-up about the docs:** Tavily's official docs ([docs.tavily.com](https://docs.tavily.com/documentation/quickstart)) show the same SDK pattern. If you paste their sample code into Claude Code, it will match what you have here. If you look at an older tutorial that uses `requests.post` against `https://api.tavily.com/search`, that still works — both approaches send the same HTTP request to Tavily's servers — but the SDK is the current recommended approach.

**If something goes wrong:** The SDK does not expose an HTTP status code the way `requests.get` did in MP03. If you see a `KeyError` on `response["results"]` or any other exception, add `print(response)` right after the `search(...)` call and rerun. That usually reveals an auth error, a rate-limit message, or a typo in the query.

**Checkpoint:** Your script prints five Chipotle IR URLs with titles. Tavily results vary from run to run — any five URLs from `chipotle.com` or `ir.chipotle.com` domains means you succeeded.

### Step 02: Scrape One URL with Firecrawl

Tavily gave you URLs. Firecrawl turns each URL into clean markdown — no BeautifulSoup selectors, no DOM inspection, no HTML parsing. You send the URL, you get back markdown ready for your knowledge base.

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

**Tavily returned dicts, Firecrawl returns an object:** In Step 01 you accessed `response["results"]` — bracket notation, because Tavily's SDK returns a plain Python `dict`. In Step 02 you access `doc.markdown` — dot notation, because Firecrawl's SDK returns a `Document` object. Same idea (getting fields out of a response), different shapes, different access patterns. One quirk: `doc.metadata` is itself a dict, so you use `doc.metadata.get("title")` — dot notation to get to `metadata`, then bracket/`.get()` inside it.

**Why `formats=["markdown"]`:** Firecrawl can return HTML, markdown, summaries, screenshots, or links. Markdown is the right choice for a knowledge base because it preserves structure (headings, lists, tables) without the noise of raw HTML. The `formats` parameter takes a list, so you can request multiple formats in one call if you need them.

**Heads-up about extracted content:** The first few hundred characters are usually the main page content — Firecrawl is good at finding the body and skipping navigation. But some pages include cookie banners or footer text that leaks into the markdown. That is normal. Your knowledge base is read by Claude Code, which synthesizes across many sources and ignores boilerplate naturally. Focus on collecting sources, not on perfect extraction.

**If something goes wrong:** If the scrape fails with an exception or returns an empty `doc.markdown`, try `print(doc)` right after the `scrape()` call to see the full Document. If you see an `AttributeError: 'NoneType' object has no attribute 'markdown'`, the scrape returned `None` for that URL — pick a different URL from your Step 01 results and try again. You can also check [Firecrawl's status page](https://status.firecrawl.dev/) if calls consistently fail — occasionally the service has a degraded window.

**Checkpoint:** Your script prints a page title, a multi-thousand-character markdown length, and a preview of the scraped content. If the title shows `None`, that is not a failure — some pages do not expose a title in their metadata. The markdown length being non-zero is the real success signal.

### Step 03: Loop and Save to `knowledge/raw/`

You have one URL scraped. Your knowledge base needs many. The pattern is: loop over Tavily's results, scrape each with Firecrawl, save each as a markdown file. This is the same shape as MP03's `request → parse → loop → save`, adapted for scraping.

**What to do:**

1. **Comment out or delete** all of your Step 02 code (everything below the `# --- Step 02 ---` comment, including `sample_url`, `doc = firecrawl.scrape(...)`, and the print statements). The loop below supersedes all of it and will make those calls itself. The `firecrawl` client from Step 01 stays; you will reuse it inside the loop.

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

**Why the 1-second sleep:** Rate limit etiquette. Firecrawl's free tier is generous, but hammering any API with zero delay is rude and gets your key banned eventually. Same pattern you used in MP03.

**Why the header with source URL:** When Claude Code reads `knowledge/raw/` for your knowledge base, the source URL lets it cite where each fact came from. Always preserve provenance — it is the difference between a knowledge base you can trust and one you cannot.

**Why `doc.markdown or ""` and the `if not md: continue` guard:** If Firecrawl cannot render the page, `doc.markdown` may be `None`. The `or ""` converts `None` to an empty string so the next line does not crash trying to check its length. The `if not md: continue` guard then skips the file write when the string is empty (Python treats both `None` and `""` as falsy), so you do not create a zero-byte file for a failed scrape.

**Checkpoint:** You have up to five markdown files in `knowledge/raw/` (one per Tavily result that Firecrawl successfully scraped), each with a title header, source URL, and scraped content. If a result returned empty markdown, the script skipped it and you will see fewer files — that is normal. This is the full Python pipeline: **search → extract → loop → save**.

---

## Part 03: MCP Upgrade

<!-- Steps 04-05 fill in here -->

---

## Part 04: Project Connection

<!-- Steps 06-07 fill in here -->

---

## Submission

<!-- Filled in at the end -->
