# Dataset Generator GPT - UI Configuration

Settings for configuring your Custom GPT in OpenAI's interface.

---

## Basic Information

**Name**: {{COURSE_CODE}} Data Craft

**Description**:
Generate realistic practice datasets for {{COURSE_NAME}} projects. Creates custom datasets with configurable data quality issues for analysis practice.

**Instructions**: See `instructions.md`

---

## Conversation Starters

Suggested prompts to help students begin:

1. "Generate a dataset for Milestone 1 with 100 rows"
2. "Create a dataset with missing values and duplicates for data quality practice"
3. "What columns should my dataset have for {{PROJECT_TYPE}}?"
4. "Help me understand what data quality issues to include"

---

## Capabilities

| Capability | Recommended | Reason |
|------------|-------------|--------|
| Web Browsing | Off | Dataset generation doesn't need web access |
| DALL-E Image Generation | Off | Not needed for data work |
| Code Interpreter | **On** | Essential for generating and formatting datasets |

---

## Knowledge Files

Upload these files from your course:

### Required
- `project/requirements.md` - Project specifications
- `project/milestones.md` - Milestone details

### Recommended
- Framework reference documents
- Data quality guidelines
- Example datasets (if available)
- Domain-specific terminology guides

---

## Additional Settings

**Profile Picture**: Consider using a data/analytics themed icon

**Actions**: None required for basic dataset generation

**Privacy**: Review OpenAI's data usage policies for your institution

---

## Testing Checklist

Before sharing with students:

- [ ] Generate sample dataset - verify format is correct
- [ ] Test data quality issue generation
- [ ] Verify it stays within project scope
- [ ] Check that it doesn't answer project questions
- [ ] Test edge cases (very large requests, unclear prompts)
- [ ] Confirm knowledge files are accessible
