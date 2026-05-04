# Lesson 11: Pipeline Diagram Reference

Your portfolio pipeline diagram is already in your repo — it shipped as the Milestone 02 #9 deliverable before today's class. This file is a reference, not an in-class build. Today on May 4 you'll pull the diagram up during the whiteboard parts of the [final interview tutorial](final-interview-tutorial.md) and use it as the source of truth for your rehearsal. Between May 5 and your interview slot on Mon May 11, Tue May 12, or Wed May 13, you're welcome to refine it.

## How to use your diagram in class

The final interview tutorial has two whiteboard parts:

- **Part 04: Solo whiteboard recall** — laptops closed, draw your pipeline from memory, then pull up your M02 diagram and list what you missed. The list goes on your cheat sheet.
- **Part 05: Pair whiteboard walkthrough** — narrate your pipeline at the whiteboard while a peer asks follow-ups. Your M02 diagram is open on your laptop as a backstop, but the walkthrough itself is from memory.

Pull up the diagram before Part 04 so it's ready when you need it. If your portfolio repo's `README.md` has the diagram embedded inline (Mermaid) or as a linked image, that's where you'll grab it.

## Why "whiteboard" framing matters

A polished diagram in your README is one thing. Drawing the same diagram from scratch in front of an interviewer is harder. Anything you can't recall isn't load-bearing in your understanding of the pipeline, which means it probably shouldn't be in the diagram either. The discipline of "draw it from memory" forces simplification.

The polished version (Mermaid, draw.io, Excalidraw, or hand-drawn photo) is the artifact. The from-memory version is the rehearsal.

## Refining your diagram before your interview

You're welcome to update the diagram after class — most students will. The whiteboard rehearsal in Parts 04 and 05 will surface gaps: arrows pointing the wrong way, a tool name you forgot, a layer that's vaguer in the diagram than in your head. Fixing those is fair game right up to your interview slot.

If you're doing a refinement pass, these are the criteria to hit:

- **Single page or single screen scroll.** A diagram that requires panning has too much detail. Simplify — pick the most important layer to keep, fold the rest into a single label.
- **Every layer labeled with the tool that produced it.** Not "extract layer" but `extract.py` (Python). Not "scheduling" but GitHub Actions on cron.
- **Data flow direction unambiguous.** Use arrows, not lines. The reader should never have to guess which direction the data moves.
- **No mystery boxes.** If a non-engineer can't tell what something is from the label, label it more specifically.
- **Both data paths drawn.** Structured path (API → GitHub Actions → Snowflake → dbt → Streamlit) and knowledge base path (web scrape → GitHub Actions → `knowledge/raw/` → Claude Code → `knowledge/wiki/`).

Commit each refinement to your portfolio repo. The diagram in `main` on the day of your interview is the one you walk through.

## Checkpoint

Your pipeline diagram is open on your laptop and ready to reference during Parts 04 and 05 of the final interview tutorial. On your interview day, the diagram in `main` is what you walk through.
