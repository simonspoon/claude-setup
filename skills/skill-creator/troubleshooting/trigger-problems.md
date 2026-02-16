# Skill Not Triggering

Skill exists but doesn't load when user requests it.

## Symptoms

- User mentions relevant keywords but skill doesn't load
- User explicitly asks for the skill and it doesn't trigger
- Skill works when manually invoked but not automatically

## Root Cause

Description doesn't include the keywords or phrases users actually use.

## Fix

Update the description field in YAML frontmatter to include trigger keywords.

## Step-by-Step Solution

### 1. Identify Missing Keywords

Ask yourself:
- What words would a user say when they need this skill?
- What related terms or synonyms exist?
- What file types, tools, or technologies are involved?

### 2. Update Description

Add trigger keywords to description while keeping it under 1024 chars.

**Before:**
```yaml
description: Generate SQL queries for databases
```

**After:**
```yaml
description: Generate SQL queries for PostgreSQL and MySQL databases. Use when user needs database queries, mentions SQL, data retrieval, or database operations.
```

### 3. Include Variations

Think about different ways users might refer to the same thing:

**Example: Presentation skill**
```yaml
description: Create PowerPoint presentations with slides, formatting, and images. Use when user asks to create presentations, mentions PowerPoint, slides, .pptx files, or needs to make a deck.
```

Keywords included:
- PowerPoint
- presentations
- slides
- .pptx
- deck (common slang)

### 4. Include Related Technologies

Mention specific tools, libraries, or file formats:

**Example: Data analysis skill**
```yaml
description: Analyze datasets using pandas and generate visualizations with matplotlib. Use when user needs data analysis, mentions CSV/Excel files, pandas, numpy, requests charts/statistics, or needs to visualize data.
```

Keywords included:
- pandas (library)
- matplotlib (library)
- numpy (related library)
- CSV/Excel (file types)
- data analysis (activity)
- charts/statistics (outputs)
- visualize (synonym)

## Examples of Good vs Bad Descriptions

### Example 1: Code Review

**❌ Bad:**
```yaml
description: Review code following standards
```

Why bad: No trigger keywords, too vague

**✅ Good:**
```yaml
description: Review code changes following security, performance, and style standards. Use when reviewing pull requests, PRs, code changes, diffs, or when user asks for code review.
```

Why good: Includes "pull requests", "PRs", "diffs", "code review"

### Example 2: API Integration

**❌ Bad:**
```yaml
description: API documentation
```

Why bad: Doesn't specify when to use

**✅ Good:**
```yaml
description: Access company API documentation, endpoints, authentication, and integration examples. Use when user needs to integrate with company APIs, mentions API endpoints, webhooks, REST API, or asks about API usage.
```

Why good: Includes "API endpoints", "webhooks", "REST API", "integrate"

### Example 3: Configuration

**❌ Bad:**
```yaml
description: Manage configs
```

Why bad: Too short, no triggers, unclear

**✅ Good:**
```yaml
description: Manage application configurations across environments (dev, staging, prod). Use when working with config files, environment variables, .env files, YAML configs, or deployment settings.
```

Why good: Includes file types (.env, YAML), concepts (environment variables), and activities (deployment)

## Testing Triggers

After updating description:

1. **Think like a user** - What would you say?
   - "Can you help me with my database query?" → Should trigger if description mentions "database", "query"
   - "I need to analyze this CSV file" → Should trigger if description mentions "CSV", "analyze"

2. **Test with phrases**
   - Create test phrases users might say
   - Verify description includes those keywords
   - Add missing keywords

3. **Check synonyms**
   - List 3-5 ways to describe the same thing
   - Ensure description includes main variations
   - "presentation" vs "slides" vs "deck"

## Common Mistakes

### Mistake 1: Only Technical Terms
**Problem:** Using only formal terminology
```yaml
description: Generate SQL queries using parameterized statements
```
**Fix:** Add common phrases
```yaml
description: Generate SQL queries using parameterized statements. Use when user needs database queries, mentions SQL, wants to query data, or asks about databases.
```

### Mistake 2: Missing File Extensions
**Problem:** Not mentioning specific file types
```yaml
description: Work with spreadsheets
```
**Fix:** Add file extensions
```yaml
description: Work with spreadsheet data. Use when user mentions Excel, CSV, .xlsx, .csv files, or needs to analyze tabular data.
```

### Mistake 3: No Action Verbs
**Problem:** Not including what users want to DO
```yaml
description: API documentation
```
**Fix:** Add action verbs
```yaml
description: API documentation and integration guide. Use when user wants to integrate, call, query, or connect to the API, or mentions endpoints or webhooks.
```

## Validation

After updating description, verify:

- [ ] Description includes 5+ relevant keywords
- [ ] Keywords match how users would actually phrase requests
- [ ] File types/extensions mentioned (if relevant)
- [ ] Tool/library names included
- [ ] Common synonyms covered
- [ ] Action verbs included (create, analyze, generate, etc.)
- [ ] Still under 1024 characters

## Related Issues

- [trigger-too-broad.md](trigger-too-broad.md) - Skill triggers too often
- [description-errors.md](description-errors.md) - Description validation failures
