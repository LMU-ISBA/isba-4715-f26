# Lesson 11: Pipeline Whiteboard Tutorial

This lesson is interview prep. Your final interview on Sun May 11 includes a whiteboard walkthrough where you draw your portfolio pipeline from memory and explain it to the interviewer. Today is the practice run.

The diagram you produce also lives in your portfolio repo's `README.md` as the Milestone 02 #9 deliverable. If you already shipped M02 on May 4 with a placeholder, this is the chance to upgrade it. If your M02 diagram already looks great, treat today as rehearsal — the act of drawing it from memory is what makes the May 11 walkthrough easy.

There is nothing to submit on Brightspace for Lesson 11. The diagram lives in your portfolio repo; you walk through it during your final interview.

## Why "whiteboard" framing

A polished diagram in your README is one thing. Drawing the same diagram from scratch in front of an interviewer is harder. Anything you can't recall isn't load-bearing in your understanding of the pipeline, which means it probably shouldn't be in the diagram either. The discipline of "draw it from memory" forces simplification.

The polished version (Mermaid, draw.io, Excalidraw) is the artifact. The from-memory version is the rehearsal.

## What to do

1. Pick a format. Any of these work for the M02 rubric:

   - **Mermaid** (lives in your README, version-controlled, no separate file)
   - **draw.io** (free, more visual control, export PNG to your repo)
   - **Excalidraw** (hand-drawn aesthetic, also free, also exportable)
   - **Hand-drawn photo** (literal whiteboard or paper, photographed, committed as JPG)

2. Draw both data paths your portfolio repo supports:

   - **Structured path:** API source → GitHub Actions → Snowflake raw → dbt staging → dbt mart → Streamlit dashboard
   - **Knowledge base path:** Web scrape → GitHub Actions → `knowledge/raw/` → Claude Code → `knowledge/wiki/`

3. Label every tool. No unnamed boxes. "Cloud database" is not a label; "Snowflake" is. "Code" is not a label; "Python + `requests`" is. The labels are the test of whether you actually built it or just copy-pasted a generic architecture diagram.

4. Embed the diagram in your portfolio repo's `README.md`. For Mermaid, paste it inline as a fenced code block with the language tag `mermaid`. For draw.io / Excalidraw / hand-drawn, save the export as `docs/pipeline-diagram.png` (or `.svg`) and reference it in the README with `![Pipeline diagram](docs/pipeline-diagram.png)`.

5. Pair with a classmate. Walk each other through your own pipeline out loud, no notes. Then read each other's diagrams cold and identify what's unclear or missing. The questions a classmate asks are the questions a hiring manager will ask.

## What makes a good pipeline diagram

- **Single page or single screen scroll.** A diagram that requires panning has too much detail. Simplify — pick the most important layer to keep, fold the rest into a single label.
- **Every layer labeled with the tool that produced it.** Not "extract layer" but `extract.py` (Python). Not "scheduling" but GitHub Actions on cron.
- **Data flow direction unambiguous.** Use arrows, not lines. The reader should never have to guess which direction the data moves.
- **No mystery boxes.** If a non-engineer can't tell what something is from the label, label it more specifically.

## Checkpoint

Your pipeline diagram is in your portfolio repo's `README.md`. Every layer is labeled with a specific tool. The data flow direction is unambiguous. At least one classmate has reviewed it and confirmed they could understand the pipeline without you explaining it.

The May 11 final interview will start with you walking the interviewer through this diagram. If you can do that without notes, you're ready.
