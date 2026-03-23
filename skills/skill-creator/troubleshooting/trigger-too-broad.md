# Skill Triggers Too Often

Skill loads for requests it shouldn't handle.

## Symptoms

- Skill activates on unrelated user requests
- Multiple skills compete because descriptions overlap
- Skill triggers on common words that aren't specific to its purpose

## Root Cause

Description contains overly generic keywords that match too many requests.

## Fix

Make description more specific by adding qualifying context to generic terms.

## Step-by-Step Solution

### 1. Identify Overly Generic Terms

Common offenders:
- "code" (matches almost everything)
- "create" / "generate" (too broad)
- "help" / "assist" (meaningless)
- "file" / "data" (too common)

### 2. Add Qualifying Context

**Too broad:**
```yaml
description: Help with code and data files
```

**Specific:**
```yaml
description: Generate SQL migration scripts for PostgreSQL schema changes. Use when user needs database migrations, mentions ALTER TABLE, or asks about schema versioning.
```

### 3. Use "Use when" Clause

Structure descriptions as: `[What it does]. Use when [specific triggers].`

This pattern naturally limits scope:
```yaml
description: Format and lint Python code using Black and Ruff. Use when user mentions Python formatting, Black, Ruff, PEP 8, or asks to fix code style in .py files.
```

### 4. Avoid Overlapping With Other Skills

If you have multiple skills, check their descriptions don't share trigger words. Each skill should own its specific domain.

## Validation

After updating description, verify:

- [ ] No single-word generic triggers without qualifying context
- [ ] "Use when" clause specifies concrete scenarios
- [ ] Description wouldn't match a random coding question
- [ ] No overlap with other skills in the same project

## Related Issues

- [trigger-problems.md](trigger-problems.md) - Opposite problem: skill doesn't trigger when it should
