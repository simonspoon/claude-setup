# Create Skill from Requirements

Create a skill when requirements are clear.

## Prerequisites

You should have:
- Clear description of what skill does
- List of trigger keywords
- Chosen pattern (minimal, tool wrapper, workflow, knowledge base, comprehensive)
- At least one example of usage
- Any critical requirements identified

If you don't have these → Read [gather-requirements.md](gather-requirements.md)

## Workflow Steps

### Step 1: Choose Pattern

Select appropriate pattern based on skill purpose:

**Simple operations, one file:**
→ [../patterns/minimal-skill.md](../patterns/minimal-skill.md)

**Wrapping tool/library:**
→ [../patterns/tool-wrapper.md](../patterns/tool-wrapper.md)

**Encoding process:**
→ [../patterns/workflow-process.md](../patterns/workflow-process.md)

**Reference documentation:**
→ [../patterns/knowledge-base.md](../patterns/knowledge-base.md)

**Complex with scripts:**
→ [../patterns/comprehensive-skill.md](../patterns/comprehensive-skill.md)

### Step 2: Create Directory

```bash
mkdir -p skill-name
cd skill-name
```

### Step 3: Write SKILL.md

Create SKILL.md with valid frontmatter and structure.

#### 3a. Write YAML Frontmatter

```yaml
---
name: skill-name
description: What it does. Use when [trigger keywords and scenarios].
---
```

**Validate frontmatter:**
- [ ] Name is lowercase-with-hyphens
- [ ] Name is under 64 characters
- [ ] Name doesn't contain "anthropic" or "claude"
- [ ] Description under 1024 characters
- [ ] Description includes WHAT skill does
- [ ] Description includes WHEN to use (triggers)
- [ ] No XML tags in either field

#### 3b. Add Core Content

Follow pattern template for chosen pattern. Every SKILL.md should have:

1. **Title** - Clear heading
2. **Critical requirements** (if any) - Marked with ⚠️
3. **Quick start** - Simplest example
4. **Main sections** - Based on pattern
5. **Examples** - At least one complete example
6. **Resources/Links** - Navigation to additional files

**Example minimal skill structure:**
```markdown
---
name: skill-name
description: Description with triggers
---

# Skill Title

Brief intro.

## Quick Start

[Simplest example]

## Common Operations

### Operation 1
[Instructions + example]

### Operation 2
[Instructions + example]

## Examples

### Example 1: [Title]
[Complete example with input and output]

## Troubleshooting

[Common issues]
```

### Step 4: Create Additional Files (if needed)

Based on pattern, create additional files:

**For tool wrapper:**
- REFERENCE.md (API documentation)
- ADVANCED.md (optional, for advanced usage)

**For workflow/process:**
- workflows/ directory with INDEX.md
- standards/ directory with INDEX.md
- Individual workflow files

**For knowledge base:**
- topics/ directory with INDEX.md
- Individual topic files
- schemas/ directory (if needed)

**For comprehensive:**
- guides/, operations/, scripts/, templates/
- Each directory gets INDEX.md
- Individual files for each item

**Always create INDEX.md for directories with multiple files.**

### Step 5: Write Complete Examples

Every skill needs at least one complete example showing:

1. **Input** - What you start with
2. **Code/Instructions** - What to do
3. **Output** - What you get

**Example:**
```markdown
## Example: Format JSON String

**Input:**
```python
json_string = '{"name":"John","age":30}'
```

**Code:**
```python
import json
data = json.loads(json_string)
formatted = json.dumps(data, indent=2)
print(formatted)
```

**Output:**
```json
{
  "name": "John",
  "age": 30
}
```
```

### Step 6: Add Troubleshooting (if relevant)

Include common issues and solutions:

```markdown
## Troubleshooting

**Error: "X happened"**
→ Solution: Do Y

**Problem: Z doesn't work**
→ Check: Condition A and B
```

### Step 7: Validate

Before finalizing, run through validation checklist:

Read [../validation/CHECKLIST.md](../validation/CHECKLIST.md) and verify:

**Critical items:**
- [ ] Valid YAML frontmatter
- [ ] Name follows all rules
- [ ] Description includes triggers
- [ ] At least one complete example
- [ ] Instructions are imperative
- [ ] SKILL.md under 200 lines (or properly split)

**Important items:**
- [ ] Examples show input and output
- [ ] File links work
- [ ] Clear section structure
- [ ] Troubleshooting section exists

### Step 8: Test Triggers

Verify skill will trigger appropriately:

1. **Read description** - What keywords are included?
2. **Think like user** - What would I say to trigger this?
3. **Check coverage** - Are main trigger words included?
4. **Test phrases** - Write 3-5 phrases that should trigger skill
5. **Verify** - Description includes keywords from test phrases

**Example test phrases for JSON formatter:**
- "Can you format this JSON?"
- "I need to prettify a JSON file"
- "Help me with JSON formatting"

All should match keywords in description.

## Complete Example Walkthrough

### User Requirements:
- Format JSON files
- Trigger on: JSON, format, prettify
- Simple skill, basic operations

### Step-by-Step:

**1. Choose pattern:** Minimal (simple operations)

**2. Create directory:**
```bash
mkdir -p json-formatter
cd json-formatter
```

**3. Write SKILL.md:**

```markdown
---
name: json-formatter
description: Format and prettify JSON data. Use when user mentions JSON, formatting, prettifying, or needs to clean up JSON strings.
---

# JSON Formatter

Quick formatting for JSON data.

## Quick Start

```python
import json
data = json.loads('{"name":"John"}')
print(json.dumps(data, indent=2))
```

## Common Operations

### Format JSON String

```python
import json
data = json.loads(json_string)
formatted = json.dumps(data, indent=2, sort_keys=True)
print(formatted)
```

### Format JSON File

```python
import json

with open('input.json') as f:
    data = json.load(f)

with open('output.json', 'w') as f:
    json.dump(data, f, indent=2, sort_keys=True)
```

## Examples

### Example: Format Compact JSON

**Input:**
```python
json_string = '{"name":"John","age":30,"city":"NYC"}'
```

**Code:**
```python
import json
data = json.loads(json_string)
formatted = json.dumps(data, indent=2, sort_keys=True)
print(formatted)
```

**Output:**
```json
{
  "age": 30,
  "city": "NYC",
  "name": "John"
}
```

## Troubleshooting

**JSONDecodeError:**
→ Check for trailing commas (not valid in JSON)
→ Ensure proper quote usage (double quotes only)
→ Validate at jsonlint.com
```

**4. Validate:**
- ✅ YAML frontmatter valid
- ✅ Name is "json-formatter" (valid)
- ✅ Description includes triggers (JSON, formatting, prettifying)
- ✅ Has complete example with input/output
- ✅ Under 200 lines
- ✅ Instructions are clear

**5. Test triggers:**
- "Format this JSON" → ✅ contains "JSON"
- "Prettify JSON data" → ✅ contains "prettify" and "JSON"
- "Clean up JSON string" → ❌ missing "clean up" → Add to description

**6. Update description:**
```yaml
description: Format and prettify JSON data. Use when user mentions JSON, formatting, prettifying, cleaning up JSON, or needs to beautify JSON strings.
```

**7. Done!** Skill is ready.

## Common Mistakes to Avoid

### Mistake 1: Vague Examples
❌ Bad: "Use json.dumps to format"
✅ Good: Show complete example with input and output

### Mistake 2: Missing Triggers
❌ Bad: `description: Format JSON`
✅ Good: `description: Format JSON. Use when user mentions JSON, formatting, or prettifying`

### Mistake 3: Too Verbose
❌ Bad: Long paragraphs explaining JSON
✅ Good: Concise instructions + examples

### Mistake 4: No Validation
❌ Bad: Skip validation checklist
✅ Good: Run through checklist before marking done

### Mistake 5: Unclear Structure
❌ Bad: Wall of text with no sections
✅ Good: Clear sections with headings

## After Creation

Once skill is created:

1. **Save all files**
2. **Test that skill can be loaded**
3. **Verify triggers work**
4. **User can test with example request**

## Related Workflows

- [gather-requirements.md](gather-requirements.md) - When requirements unclear
- [../validation/CHECKLIST.md](../validation/CHECKLIST.md) - Validation requirements
- [../patterns/INDEX.md](../patterns/INDEX.md) - Available patterns
