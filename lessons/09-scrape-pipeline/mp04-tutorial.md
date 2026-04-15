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

7. **Sign up for Firecrawl.** Go to [firecrawl.dev](https://firecrawl.dev) and sign in with GitHub. From the dashboard, open **API Keys** and copy the default key (it starts with `fc-`).

8. **Sign up for Tavily.** Go to [tavily.com](https://tavily.com) and sign in with GitHub. From the dashboard, copy your API key (it starts with `tvly-`).

9. Create a `.env` file in your project root. **Type** the variable names (not the values — paste those):

   ```
   FIRECRAWL_API_KEY=fc-...
   TAVILY_API_KEY=tvly-...
   ```

10. Verify `.env` is listed in your `.gitignore`. Open `.gitignore` and search for `.env`. The Python template already includes it. If it does not, add `.env` on its own line.

**Why two services:** Tavily searches the web and returns structured URLs. Firecrawl takes a URL and returns clean markdown. Together they cover the two halves of web scraping: **discover** and **extract**. You will use both in your pipeline, and both in the MCP demo later.

**Free tier limits:** Firecrawl gives you 500 scrapes per month. Tavily gives you 1,000 searches per month. Both are far more than you need for this lesson and the rest of the semester.

**Checkpoint:** Your `scrape-pipeline` repo is cloned, Claude Code confirms the virtual environment has `requests`, `python-dotenv`, `tavily-python`, and `firecrawl-py` installed, and your `.env` file contains both API keys.

---

## Part 02: Python Pipeline — Tavily + Firecrawl

<!-- Steps 01-03 fill in here -->

---

## Part 03: MCP Upgrade

<!-- Steps 04-05 fill in here -->

---

## Part 04: Project Connection

<!-- Steps 06-07 fill in here -->

---

## Submission

<!-- Filled in at the end -->
