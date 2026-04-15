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

3. **Type** this line by hand to load your keys and create the Tavily client:

   ```python
   load_dotenv()

   tavily_client = TavilyClient(api_key=os.getenv("TAVILY_API_KEY"))
   ```

   `load_dotenv()` reads your `.env` file at runtime and loads each `KEY=value` line into the environment, where `os.getenv("KEY")` can retrieve it. This is safer than hardcoding keys in your script (which you did in MP03's `weather.py`) because anything not in the script itself cannot leak when you commit the code. If you worked through the async Spotify tutorial, you saw this pattern there first. `TavilyClient` wraps the Tavily API in a Python object so you can call methods on it instead of building HTTP requests by hand.

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

---

## Part 03: MCP Upgrade

<!-- Steps 04-05 fill in here -->

---

## Part 04: Project Connection

<!-- Steps 06-07 fill in here -->

---

## Submission

<!-- Filled in at the end -->
