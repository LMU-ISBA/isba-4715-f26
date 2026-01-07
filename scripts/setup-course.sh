#!/bin/bash

# Course Template Setup Script
# Phase 1: Replace core placeholders with course-specific information

set -e

echo "================================================"
echo "  Course Template Setup"
echo "  Phase 1: Core Information"
echo "================================================"
echo ""

# Function to prompt with default value
prompt_with_default() {
    local prompt="$1"
    local default="$2"
    local result

    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " result
        echo "${result:-$default}"
    else
        read -p "$prompt: " result
        echo "$result"
    fi
}

# Collect course information
echo "Enter your course information (press Enter to accept defaults):"
echo ""

COURSE_CODE=$(prompt_with_default "Course code (e.g., BCOR 3750)" "")
COURSE_NAME=$(prompt_with_default "Course name (e.g., Analytics in Operations)" "")
SEMESTER=$(prompt_with_default "Semester (e.g., Fall 2025)" "")
YEAR=$(prompt_with_default "Year" "$(date +%Y)")
INSTRUCTOR_NAME=$(prompt_with_default "Instructor name" "Greg Lontok")
INSTRUCTOR_EMAIL=$(prompt_with_default "Instructor email" "gregory.lontok@lmu.edu")
INSTITUTION_NAME=$(prompt_with_default "Institution name" "Loyola Marymount University")
DAYS_TIMES=$(prompt_with_default "Class days/times (e.g., MW 2:30-3:45pm)" "")
LOCATION=$(prompt_with_default "Classroom location" "")
OFFICE_LOCATION=$(prompt_with_default "Office location" "Hilton 114")
OFFICE_HOURS=$(prompt_with_default "Office hours" "")

echo ""
echo "================================================"
echo "  Applying replacements..."
echo "================================================"
echo ""

# Get the script's directory and navigate to repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

# Function to replace placeholder in files (macOS compatible)
replace_placeholder() {
    local placeholder="$1"
    local value="$2"
    local files_changed=0

    # Escape special characters for sed
    local escaped_value=$(echo "$value" | sed 's/[&/\]/\\&/g')

    # Find and replace in all template files
    for file in index.html frameworks.md README.md \
                interviews/*.md \
                project/*.md \
                gpts/*.md gpts/**/*.md; do
        if [ -f "$file" ] && grep -q "{{$placeholder}}" "$file" 2>/dev/null; then
            sed -i '' "s/{{$placeholder}}/$escaped_value/g" "$file"
            files_changed=$((files_changed + 1))
        fi
    done

    if [ $files_changed -gt 0 ]; then
        echo "  ✓ {{$placeholder}} → $value ($files_changed files)"
    fi
}

# Apply replacements
replace_placeholder "COURSE_CODE" "$COURSE_CODE"
replace_placeholder "COURSE_NAME" "$COURSE_NAME"
replace_placeholder "SEMESTER" "$SEMESTER"
replace_placeholder "YEAR" "$YEAR"
replace_placeholder "INSTRUCTOR_NAME" "$INSTRUCTOR_NAME"
replace_placeholder "INSTRUCTOR_EMAIL" "$INSTRUCTOR_EMAIL"
replace_placeholder "INSTITUTION_NAME" "$INSTITUTION_NAME"
replace_placeholder "DAYS_TIMES" "$DAYS_TIMES"
replace_placeholder "LOCATION" "$LOCATION"
replace_placeholder "OFFICE_LOCATION" "$OFFICE_LOCATION"
replace_placeholder "OFFICE_HOURS" "$OFFICE_HOURS"

echo ""
echo "================================================"
echo "  Enabling GitHub Pages..."
echo "================================================"
echo ""

# Get repo info from git remote
REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [[ "$REPO_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    REPO_OWNER="${BASH_REMATCH[1]}"
    REPO_NAME="${BASH_REMATCH[2]}"

    # Check if gh CLI is available
    if command -v gh &> /dev/null; then
        # Enable GitHub Pages with Actions workflow
        if gh api "repos/$REPO_OWNER/$REPO_NAME/pages" -X POST -f build_type=workflow 2>/dev/null; then
            echo "  ✓ GitHub Pages enabled"
            echo "  ✓ Website will be at: https://${REPO_OWNER,,}.github.io/$REPO_NAME/"
        else
            # Pages might already be enabled
            PAGES_URL=$(gh api "repos/$REPO_OWNER/$REPO_NAME/pages" --jq '.html_url' 2>/dev/null || echo "")
            if [ -n "$PAGES_URL" ]; then
                echo "  ✓ GitHub Pages already enabled"
                echo "  ✓ Website: $PAGES_URL"
            else
                echo "  ⚠ Could not enable GitHub Pages automatically"
                echo "    Enable manually: Settings → Pages → Source: GitHub Actions"
            fi
        fi
    else
        echo "  ⚠ GitHub CLI (gh) not found"
        echo "    Enable Pages manually: Settings → Pages → Source: GitHub Actions"
    fi
else
    echo "  ⚠ Could not detect GitHub repository"
    echo "    Enable Pages manually after pushing to GitHub"
fi

echo ""
echo "================================================"
echo "  Phase 1 Complete!"
echo "================================================"
echo ""
echo "Core placeholders have been replaced."
echo ""
echo "Phase 2: Manual edits needed"
echo "----------------------------"
echo ""
echo "index.html:"
echo "  - Course description and learning objectives"
echo "  - Weekly schedule (topics, readings, assignments)"
echo "  - Grading weights and scale"
echo "  - Policies (attendance, late work, AI usage)"
echo "  - Campus resources"
echo "  - TA information (if applicable)"
echo ""
echo "interviews/*.md:"
echo "  - Study guide content (topics, concepts, frameworks)"
echo "  - Sample questions and evaluation criteria"
echo "  - Interview dates and format"
echo ""
echo "project/*.md:"
echo "  - Project description and objectives"
echo "  - Milestone details and rubrics"
echo "  - Deliverable specifications"
echo ""
echo "gpts/**/*.md:"
echo "  - Domain-specific customizations"
echo "  - Knowledge files to upload"
echo ""
echo "images/:"
echo "  - Add header.jpg for syllabus header image"
echo ""
echo "----------------------------"
echo "When ready, commit your changes:"
echo "  git add -A"
echo "  git commit -m \"Configure: $COURSE_CODE $SEMESTER\""
echo "  git push"
echo ""
