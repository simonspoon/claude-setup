# YAML Frontmatter Template

Complete guide for creating valid YAML frontmatter in SKILL.md.

## Template

```yaml
---
name: [skill-name]
description: [description]
---
```

## Field Documentation

### name Field

**Purpose:** Unique identifier for the skill

**How to create:**
1. Take skill's purpose
2. Convert to lowercase
3. Replace spaces with hyphens
4. Keep under 64 characters
5. Remove special characters

**Rules:**
- Lowercase letters only (a-z)
- Numbers allowed (0-9)
- Hyphens allowed (-)
- NO spaces
- NO underscores
- NO special characters (!, @, #, etc.)
- Under 64 characters
- Cannot contain "anthropic"
- Cannot contain "claude"
- No XML tags (< or >)

**Examples:**

| Purpose | ❌ Bad Name | ✅ Good Name |
|---------|-------------|--------------|
| JSON formatter | `JSON_Formatter` | `json-formatter` |
| Data analysis | `Data Analysis` | `data-analysis` |
| Code review | `codeReview` | `code-review` |
| Company API | `Company.API` | `company-api` |
| SQL queries | `sql-queries-v2.0` | `sql-queries` |

### description Field

**Purpose:** Tells what the skill does and when to use it

**How to create:**
1. Start with what skill does (1 sentence)
2. Add "Use when" phrase
3. List trigger keywords and scenarios
4. Keep under 1024 characters

**Rules:**
- Non-empty (must have content)
- Under 1024 characters
- No XML tags (< or >)
- Should include capabilities AND triggers
- Include relevant keywords users might mention
- Include file types, tools, or technologies

**Structure:**
```
[What it does]. Use when [trigger conditions, keywords, scenarios].
```

**Examples:**

**Example 1: Tool Wrapper**
```yaml
description: Analyze datasets using pandas and generate visualizations with matplotlib. Use when user needs data analysis, mentions CSV/Excel files, pandas, numpy, requests charts/statistics, or needs to visualize data.
```

**Breakdown:**
- What: "Analyze datasets using pandas and generate visualizations"
- When: "user needs data analysis, mentions CSV/Excel files..."
- Keywords: pandas, numpy, CSV, Excel, charts, statistics, visualize, data analysis

**Example 2: Process Skill**
```yaml
description: Review code changes following security, performance, and style standards. Use when reviewing pull requests, PRs, code changes, diffs, or when user asks for code review.
```

**Breakdown:**
- What: "Review code changes following standards"
- When: "reviewing pull requests, PRs..."
- Keywords: pull requests, PRs, code changes, diffs, code review

**Example 3: Simple Skill**
```yaml
description: Format JSON and XML data for readability. Use when user asks to format, prettify, or clean up JSON or XML files.
```

**Breakdown:**
- What: "Format JSON and XML data"
- When: "asks to format, prettify..."
- Keywords: format, prettify, clean up, JSON, XML

## Fill-in Guide

Use this process to fill the template:

### Step 1: Determine Name

Ask: What is the skill's main purpose?

**Answer:** [e.g., "Format JSON files"]

Convert to name:
- Lowercase: "format json files"
- Replace spaces with hyphens: "format-json-files"
- Simplify if needed: "json-formatter"

**Result:** `name: json-formatter`

### Step 2: Describe What It Does

Ask: What does this skill do? (1 sentence)

**Answer:** [e.g., "Format and prettify JSON data"]

**Result:** Start of description: "Format and prettify JSON data"

### Step 3: List Trigger Keywords

Ask: What keywords should trigger this skill?

**Brainstorm:**
- Main technology: JSON
- Actions: format, prettify, beautify, clean up
- File types: .json files
- Related: parse, validate

**Result:** Keywords: JSON, format, prettify, beautify, clean up, JSON files

### Step 4: Write Trigger Conditions

Combine keywords into "Use when" phrase:

**Result:** "Use when user mentions JSON, formatting, prettifying, beautifying, cleaning up JSON, or needs to parse JSON strings"

### Step 5: Combine Parts

**Full description:**
```yaml
description: Format and prettify JSON data. Use when user mentions JSON, formatting, prettifying, beautifying, cleaning up JSON, or needs to parse JSON strings.
```

### Step 6: Validate Length

Count characters (including spaces):
- Must be under 1024 characters
- If over, remove less important keywords

**Character count:** 145 ✅

## Complete Examples

### Example 1: Data Platform Skill

```yaml
---
name: data-platform
description: Generate and optimize SQL queries for company data platform following schema conventions and performance best practices. Use when working with company databases, data warehouse, SQL queries, mentions tables, or needs database queries.
---
```

**Validation:**
- ✅ Name: "data-platform" (lowercase, hyphens, <64 chars)
- ✅ Description: 208 chars (<1024)
- ✅ What: "Generate and optimize SQL queries..."
- ✅ When: "working with company databases..."
- ✅ Keywords: databases, data warehouse, SQL, queries, tables

### Example 2: Code Review Skill

```yaml
---
name: code-review
description: Review code changes following company security, performance, and style standards. Use when reviewing pull requests, PRs, code changes, diffs, or when user asks for code review.
---
```

**Validation:**
- ✅ Name: "code-review" (lowercase, hyphen, <64 chars)
- ✅ Description: 183 chars (<1024)
- ✅ What: "Review code changes following standards"
- ✅ When: "reviewing pull requests..."
- ✅ Keywords: pull requests, PRs, code changes, diffs, code review

### Example 3: API Documentation Skill

```yaml
---
name: company-api
description: Access company API documentation, endpoints, authentication, and integration examples. Use when user needs to integrate with company APIs, mentions API endpoints, webhooks, REST API, or asks about API usage.
---
```

**Validation:**
- ✅ Name: "company-api" (lowercase, hyphen, <64 chars)
- ✅ Description: 223 chars (<1024)
- ✅ What: "Access company API documentation..."
- ✅ When: "needs to integrate with company APIs..."
- ✅ Keywords: APIs, endpoints, webhooks, REST API, integrate

## Common Mistakes

### Mistake 1: Invalid Name Characters

❌ Wrong:
```yaml
name: My_Skill!
```

✅ Correct:
```yaml
name: my-skill
```

### Mistake 2: Missing Trigger Keywords

❌ Wrong:
```yaml
description: Format JSON
```

✅ Correct:
```yaml
description: Format JSON data. Use when user mentions JSON, formatting, or prettifying.
```

### Mistake 3: Too Long Name

❌ Wrong:
```yaml
name: this-is-a-very-long-skill-name-that-exceeds-sixty-four-characters-maximum
```

✅ Correct:
```yaml
name: long-skill-name
```

### Mistake 4: No "Use when" Clause

❌ Wrong:
```yaml
description: Analyze data using pandas and create visualizations.
```

✅ Correct:
```yaml
description: Analyze data using pandas and create visualizations. Use when user needs data analysis or mentions CSV files.
```

### Mistake 5: Special Characters in Name

❌ Wrong:
```yaml
name: sql-queries-v2.0
```

✅ Correct:
```yaml
name: sql-queries
```

## Validation Checklist

Before finalizing frontmatter:

**Name:**
- [ ] Lowercase only
- [ ] Hyphens for word separation
- [ ] Under 64 characters
- [ ] No spaces or underscores
- [ ] No "anthropic" or "claude"
- [ ] No special characters or XML tags

**Description:**
- [ ] Non-empty
- [ ] Under 1024 characters
- [ ] States what skill does
- [ ] Includes "Use when" or similar
- [ ] Lists trigger keywords
- [ ] No XML tags

**Both:**
- [ ] Wrapped in `---` delimiters
- [ ] No indentation on fields
- [ ] Valid YAML syntax

## Testing

Test your YAML with Python:

```python
import yaml

yaml_text = """
name: your-skill-name
description: Your description here
"""

try:
    data = yaml.safe_load(yaml_text)
    print(f"✅ Valid YAML")
    print(f"Name: {data['name']}")
    print(f"Description: {data['description']}")
    print(f"Name length: {len(data['name'])} chars")
    print(f"Description length: {len(data['description'])} chars")
except Exception as e:
    print(f"❌ Error: {e}")
```

## Related Documentation

- [../troubleshooting/yaml-errors.md](../troubleshooting/yaml-errors.md) - YAML validation issues
- [../troubleshooting/trigger-problems.md](../troubleshooting/trigger-problems.md) - Trigger keyword problems
- [../validation/CHECKLIST.md](../validation/CHECKLIST.md) - Complete validation checklist
