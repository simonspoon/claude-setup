# SKILL.md File Too Long

SKILL.md exceeds 200 lines and is difficult to navigate.

## Symptoms

- SKILL.md is over 200 lines
- Contains many examples or detailed documentation
- Has long explanations or multiple sections
- Difficult to find specific information quickly

## Why This Matters

- **Context limitations**: Weak models can't process huge files effectively
- **Poor navigation**: Users can't quickly find what they need
- **Maintenance burden**: Large files are hard to update
- **Progressive disclosure**: Should reveal info only when needed

## Solution: Progressive Disclosure

Break large SKILL.md into indexed, focused files.

## Step-by-Step Fix

### 1. Identify Content Categories

Review your SKILL.md and categorize content:

- **Core instructions** - Must stay in SKILL.md
  - Critical requirements
  - Quick start
  - Decision tree / navigation
  
- **Examples** - Move to `examples/`
  - Multiple detailed examples
  - Each example → separate file
  
- **Reference docs** - Move to appropriate directory
  - API documentation
  - Schema definitions
  - Command references
  
- **Guides** - Move to `guides/`
  - Advanced usage
  - Troubleshooting
  - Best practices

### 2. Create Directory Structure

Create directories for different content types:

```bash
mkdir -p examples
mkdir -p guides
mkdir -p reference
```

### 3. Create INDEX Files

For each directory, create an INDEX.md that lists contents:

**examples/INDEX.md:**
```markdown
# Examples Index

Available examples:

- [basic-usage.md](basic-usage.md) - Simple example showing basic functionality
- [advanced-workflow.md](advanced-workflow.md) - Complex multi-step workflow
- [error-handling.md](error-handling.md) - How to handle errors properly
```

### 4. Move Content to Separate Files

Extract sections from SKILL.md into focused files:

**Before (in SKILL.md):**
```markdown
## Example 1: Basic Usage
[50 lines of example code and explanation]

## Example 2: Advanced Workflow
[60 lines of example code and explanation]

## Example 3: Error Handling
[40 lines of example code and explanation]
```

**After (in SKILL.md):**
```markdown
## Examples

See [examples/INDEX.md](examples/INDEX.md) for complete examples:
- Basic usage
- Advanced workflows
- Error handling
```

**examples/basic-usage.md:**
```markdown
# Basic Usage Example

[50 lines of example code and explanation]
```

### 5. Update SKILL.md Navigation

Replace detailed content with navigation:

**Before:**
```markdown
## API Reference

### Function 1
[Detailed docs]

### Function 2
[Detailed docs]

### Function 3
[Detailed docs]
```

**After:**
```markdown
## API Reference

See [reference/API.md](reference/API.md) for complete API documentation.

Quick reference:
- Function 1: Does X
- Function 2: Does Y
- Function 3: Does Z
```

### 6. Keep Core Content in SKILL.md

SKILL.md should contain (~100-150 lines):

```markdown
---
name: skill-name
description: Description
---

# Skill Title

## ⚠️ CRITICAL REQUIREMENTS
[Universal must-dos]

## Quick Start
[Simplest example]

## What Are You Trying To Do?

**Scenario 1:**
→ Read appropriate-file.md

**Scenario 2:**
→ Read appropriate-file.md

## Resources

- [examples/INDEX.md](examples/INDEX.md)
- [guides/INDEX.md](guides/INDEX.md)
- [reference/](reference/)
```

## Examples of Good Restructuring

### Example 1: Data Analysis Skill

**Before: Single 300-line SKILL.md**

**After:**
```
data-analysis/
├── SKILL.md (100 lines: critical requirements, quick start, navigation)
├── examples/
│   ├── INDEX.md
│   ├── load-data.md
│   ├── clean-data.md
│   ├── analyze-data.md
│   └── visualize-data.md
├── guides/
│   ├── INDEX.md
│   ├── advanced-analytics.md
│   └── performance-tips.md
└── reference/
    ├── pandas-api.md
    └── matplotlib-api.md
```

### Example 2: Code Review Skill

**Before: Single 400-line SKILL.md with all standards embedded**

**After:**
```
code-review/
├── SKILL.md (120 lines: critical requirements, process overview, navigation)
├── workflows/
│   ├── INDEX.md
│   ├── standard-review.md
│   ├── hotfix-review.md
│   └── major-change-review.md
└── standards/
    ├── INDEX.md
    ├── security.md
    ├── performance.md
    ├── style.md
    └── testing.md
```

## SKILL.md Template for Restructured Skills

Use this template after restructuring:

```markdown
---
name: skill-name
description: Description with triggers
---

# Skill Title

Brief overview of what skill does.

## ⚠️ CRITICAL REQUIREMENTS

- [Requirement 1]
- [Requirement 2]
- [Requirement 3]

## Quick Start

[Simplest possible example - usually <10 lines]

## What Are You Trying To Do?

**[Common task 1]:**
→ Read [path/to/file.md]

**[Common task 2]:**
→ Read [path/to/file.md]

**[Common task 3]:**
→ Read [path/to/file.md]

## Quick Reference

[Most commonly needed info - cheat sheet style]

## Resources

- [Category 1](category1/INDEX.md)
- [Category 2](category2/INDEX.md)
- [Category 3](category3/INDEX.md)
```

## File Granularity Guidelines

**How granular should files be?**

### Split into separate files if:
- Section is >50 lines
- Content is optional/advanced
- Multiple distinct examples
- Could be useful independently
- Adds to main file length unnecessarily

### Keep in SKILL.md if:
- Universal requirement (applies to everything)
- Part of core workflow
- Needed for decision-making
- Quick reference info
- Under 20 lines and essential

## Common Mistakes

### Mistake 1: Splitting Too Much
**Problem:** Every paragraph in its own file
**Solution:** Combine related content. Each file should be self-contained and purposeful.

### Mistake 2: No INDEX Files
**Problem:** Directory with 10 files but no index
**Solution:** Always create INDEX.md to list and describe contents.

### Mistake 3: Broken Navigation
**Problem:** SKILL.md doesn't tell you where to go
**Solution:** Add clear "What Are You Trying To Do?" decision tree.

### Mistake 4: Duplicate Content
**Problem:** Same info repeated in multiple files
**Solution:** Keep info in one place, link to it from elsewhere.

## Validation

After restructuring, verify:

- [ ] SKILL.md is under 200 lines
- [ ] SKILL.md has clear navigation to other files
- [ ] All directories have INDEX.md files
- [ ] Each file is focused on one topic
- [ ] No broken links (all references work)
- [ ] Critical requirements still in SKILL.md
- [ ] Quick start still in SKILL.md
- [ ] Files are self-contained (can be read independently)

## Related Issues

- [structure-problems.md](structure-problems.md) - Unclear how to organize files
- [broken-links.md](broken-links.md) - File references don't work
