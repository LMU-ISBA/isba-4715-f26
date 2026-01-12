# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a course syllabus template for **ISBA 4715 - Developing Business Applications Using SQL** at Loyola Marymount University. It generates a responsive, print-optimized syllabus website deployed via GitHub Pages.

## Commands

### Setup
```bash
./scripts/setup-course.sh    # Interactive script to replace placeholders with course info
```

### Deployment
The site auto-deploys to GitHub Pages on push to `main` via `.github/workflows/pages.yml`. No build step required - static HTML is deployed directly.

### Local Preview
Open `index.html` directly in a browser - no server needed.

## Architecture

### Content Structure
- `index.html` - Main syllabus website (standalone, no framework dependencies)
- `frameworks.md` - Course frameworks/models reference
- `interviews/` - Study guides for midterm and final interviews
- `project/` - Project requirements and milestone documentation
- `gpts/` - Custom GPT configurations (instructions.md + ui-config.md + knowledge/)

### Template System
Files use `{{PLACEHOLDER}}` syntax for course-specific values. The setup script replaces:
- Course identifiers: `{{COURSE_CODE}}`, `{{COURSE_NAME}}`, `{{SEMESTER}}`
- Instructor info: `{{INSTRUCTOR_NAME}}`, `{{INSTRUCTOR_EMAIL}}`
- Logistics: `{{DAYS_TIMES}}`, `{{LOCATION}}`, `{{OFFICE_HOURS}}`

After setup, remaining `{{PLACEHOLDER}}` values require manual editing.

### Custom GPTs
Two GPT templates for student support:
- `dataset-generator/` - Creates practice datasets for projects
- `interview-coach/` - Interview practice based on study guides

Each GPT folder contains:
- `instructions.md` - System prompt (copy to OpenAI GPT builder)
- `ui-config.md` - Recommended OpenAI UI settings
- `knowledge/` - Files to upload to GPT

## Key Patterns

### Editing the Syllabus
The `index.html` is a self-contained file with embedded CSS. Key sections:
- Header: Course title, subtitle, info badges
- Navigation: Sticky nav with smooth scroll
- Sections: Overview, Instructor, Schedule, Grading, Tips, Policies

CSS variables in `:root` control theming (colors, radius, shadows).

### Study Guide Templates
Both `midterm-study-guide.md` and `final-study-guide.md` follow the same structure:
- Interview logistics (date, duration, format)
- Key concepts with terms tables
- Frameworks with components
- Sample questions with evaluation guidance
- Rubric criteria
