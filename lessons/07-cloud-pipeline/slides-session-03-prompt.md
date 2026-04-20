# Session 03 MARP Slides — Reusable Context Prompt

Paste the block between the `===BEGIN===` and `===END===` markers into a fresh Claude Code session as your opening message. That gives the new session everything it needs to help iterate on the Session 03 slide deck without re-explaining.

---

===BEGIN===

I'm updating MARP slides for **Session 03 of Mini-Project 02** in ISBA 4715 (SQL / Data Engineering course I teach at Loyola Marymount University). You are helping me edit them.

## Source files

- **Slides source (MARP markdown):** `lessons/07-cloud-pipeline/slides-session-03.md`
- **Slides rendered HTML:** `lessons/07-cloud-pipeline/slides-session-03.html` (regenerate from source, do not edit directly)
- **Companion tutorial:** `lessons/07-cloud-pipeline/mp02-tutorial.md` — Session 03 content lives in Part 3 (Steps 13 through 19)

The slides currently mirror the tutorial's "What Snowflake Is (Before You Touch It)" primer plus a handoff slide. Eventually, the tutorial's primer text will be replaced with a link to these slides, so the slides become the canonical conceptual intro.

## What Session 03 teaches

The L in ELT: move Basket Craft raw tables from AWS RDS into Snowflake's `raw` schema via a Python loader using `write_pandas`. Dimensional modeling and dbt transformations are Session 04, not Session 03.

Current slide sequence (12 slides):

1. Title (accent class) — "Snowflake Load · Session 03 · MP02"
2. What is Snowflake? (OLTP vs. OLAP comparison table)
3. Storage and compute are separate (dark class, big-idea center)
4. Storage (bytes, always on, cheap)
5. Compute = virtual warehouse (per-second pricing, resizable)
6. Why storage/compute separation matters (four bullets: independent layers, auto-suspend, resize on demand, free-tier dbt speed)
7. Today is the "L" in ELT (warehouse + database + raw schema, no transforms)
8. How it actually works in real jobs (managed ELT tools: Fivetran, Airbyte, Stitch, Hevo, Matillion)
9. So why write it yourself? (3-reason table)
10. The pipeline diagram (flow boxes: RDS → Python → warehouse → raw schema)
11. Today's steps 13-19 (step table)
12. Handoff (accent class) — "Now open the tutorial and jump to Step 13"

## MARP theme conventions

- Theme `default`, size `16:9`, fade transition.
- The full `style: |` block at the top of `slides-session-03.md` is adapted from `lessons/09-scrape-pipeline/slides.md`. Reusable classes: `accent`, `dark`, `flow`, `flow-box`, `flow-arrow`.
- Title slide and handoff slide use `<!-- _class: accent -->`.
- "Storage and compute are separate" slide uses `<!-- _class: dark -->`.

## How to render

From the `lessons/07-cloud-pipeline/` directory:

```bash
# HTML (default for review iterations)
npx --yes @marp-team/marp-cli slides-session-03.md --html --allow-local-files

# PDF (for handouts)
npx --yes @marp-team/marp-cli slides-session-03.md --pdf --allow-local-files

# Live dev server (auto-reloads on save)
npx --yes @marp-team/marp-cli slides-session-03.md --server
```

## Writing voice and standing preferences

- **Voice:** blunt, honest, student-first. The author is a university instructor. No marketing-speak, no "in this lesson we will explore..." openings, no AI-bloat.
- **Always run `/humanizer` on public-facing text during writing**, not as an afterthought. This is a standing preference for anything students will read.
- **Leading zeros** on all numbered identifiers: `MP02`, `Session 03`, `Step 13`, `Lesson 07`.
- **Never include Claude Code attribution lines** in git commit messages.
- **Preserve technical facts verbatim** — dates, product names, identifier formats, dollar amounts. Never paraphrase a technical claim.

## Repo conventions

- Commits to `main` auto-deploy to GitHub Pages via `.github/workflows/pages.yml`.
- Tutorial content lives in `lessons/<NN>-<slug>/`. Mini-projects 02 and later use `mpX-tutorial.md` format inside the lesson folder.
- `docs/` is gitignored — specs, plans, and internal working docs live locally and are never committed.
- A design spec for the Session 03 polish pass exists at `docs/superpowers/specs/2026-04-19-mp02-session-03-polish-design.md` (local only, gitignored).

## What you can help me do

Typical requests I will make in this session:
- Reword a specific slide for clarity or voice
- Reorder slides or split/merge content
- Add or remove a slide to match new tutorial content
- Swap a table for a visual or vice versa
- Tighten the deck for a specific time budget

After changes, always offer to re-render the HTML so I can review visually before committing.

## Key constraints for this deck

- Total duration target: about 5 to 7 minutes as an in-class opener before students start hands-on work at Step 13.
- Do not include any hands-on / code / SQL steps in the slides. Those live only in the tutorial.
- The pipeline diagram (slide 10) is intentionally a simplified flow, not the full mermaid diagram from the tutorial. MARP does not render mermaid without a plugin, and the tutorial mermaid is the authoritative reference.

===END===

---

## Notes for my future self (not part of the pasteable block)

- This prompt file itself is tracked in git so anyone cloning the repo sees the same context. Rename or move it if the slides location changes.
- If Session 04 or other sessions get their own decks later, duplicate this prompt file alongside (e.g., `slides-session-04-prompt.md`) and update the paths and content list.
- Related memory entries that already persist across Claude sessions:
  - `feedback_humanizer_public_docs.md` — humanizer during writing
  - `feedback_leading_zeros.md` — MP02 / Session 03 / Step 13
  - `feedback_no_brainstorm_timebox.md` — no arbitrary timeboxes on design/brainstorm steps
