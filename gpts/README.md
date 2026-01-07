# Custom GPT Configurations

This directory contains configurations for custom GPTs that support course delivery.

## Overview

| GPT | Purpose | Directory |
|-----|---------|-----------|
| Dataset Generator | Creates practice datasets for student projects | `dataset-generator/` |
| Interview Coach | Provides interview practice based on study guides | `interview-coach/` |

## Structure

```
gpts/
├── README.md                    # This file
├── dataset-generator/
│   ├── instructions.md          # GPT system instructions
│   ├── ui-config.md            # OpenAI UI settings
│   └── knowledge/              # Knowledge files to upload
│       └── .gitkeep
└── interview-coach/
    ├── instructions.md          # GPT system instructions
    ├── ui-config.md            # OpenAI UI settings
    └── knowledge/              # Knowledge files to upload
        └── .gitkeep
```

## Creating a Custom GPT

### Step 1: Prepare Instructions
Edit the `instructions.md` file in the appropriate GPT directory. This becomes the "Instructions" field in OpenAI's GPT builder.

### Step 2: Configure UI Settings
Review `ui-config.md` for recommended settings:
- Name and description
- Conversation starters
- Capabilities (web browsing, DALL-E, code interpreter)

### Step 3: Upload Knowledge Files
Place course-specific files in the `knowledge/` subdirectory:
- Study guides
- Project requirements
- Framework references
- Rubrics

### Step 4: Create in OpenAI
1. Go to https://chat.openai.com/gpts/editor
2. Copy instructions from `instructions.md`
3. Configure settings per `ui-config.md`
4. Upload files from `knowledge/`
5. Test and iterate

## Best Practices

### Instructions
- Keep under 8,000 characters (OpenAI limit)
- Be specific about behavior and constraints
- Include example interactions
- Define clear boundaries

### Knowledge Files
- Use markdown for text content
- Keep files focused and well-organized
- Include only what the GPT needs
- Update when course content changes

### Testing
- Test with various student scenarios
- Verify responses match expectations
- Check edge cases
- Get student feedback

## Maintenance

Update GPT configurations when:
- Course content changes
- Study guides are updated
- Project requirements change
- Issues are identified from usage

## Privacy Considerations

- Don't include student data in knowledge files
- Review files for sensitive information
- Consider what data students might share
- Follow institutional data policies
