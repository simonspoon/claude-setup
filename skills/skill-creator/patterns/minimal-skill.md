# Minimal Skill Pattern

For simple, single-file skills with focused functionality.

## Structure

```
skill-name/
└── SKILL.md (frontmatter + instructions + examples)
```

## When to Use

- Simple, focused functionality
- All content fits comfortably in one file (<200 lines)
- No need for additional references or resources
- No scripts or automation needed
- Examples can fully demonstrate usage

## Template

```markdown
---
name: skill-name
description: Brief description of what this skill does and when to use it. Include trigger keywords.
---

# Skill Title

Brief introduction explaining the skill's purpose.

## Quick Start

[Simplest possible example showing basic usage]

## Common Operations

### Operation 1
[Clear instructions + code example]

### Operation 2
[Clear instructions + code example]

### Operation 3
[Clear instructions + code example]

## Examples

### Example 1: [Descriptive Title]
[Complete, runnable example with input and expected output]

### Example 2: [Descriptive Title]
[Complete, runnable example with input and expected output]

## Troubleshooting

[Common issues and how to resolve them]
```

## Complete Example: Simple Formatter

```markdown
---
name: simple-formatter
description: Format JSON, XML, and YAML data for readability. Use when user asks to format, prettify, or clean up JSON, XML, or YAML.
---

# Simple Formatter

Quick formatting for common data formats.

## Quick Start

```python
import json

# Parse and format JSON
data = json.loads(input_string)
formatted = json.dumps(data, indent=2, sort_keys=True)
print(formatted)
```

## Common Operations

### Format JSON

```python
import json

# Parse and format
data = json.loads(input_string)
formatted = json.dumps(data, indent=2, sort_keys=True)
print(formatted)
```

**Options:**
- `indent=2`: Use 2-space indentation
- `sort_keys=True`: Alphabetize keys
- `ensure_ascii=False`: Preserve Unicode characters

### Format XML

```python
import xml.dom.minidom as minidom

# Parse and format
dom = minidom.parseString(xml_string)
formatted = dom.toprettyxml(indent="  ")
print(formatted)
```

### Format YAML

```python
import yaml

# Parse and format
data = yaml.safe_load(yaml_string)
formatted = yaml.dump(data, default_flow_style=False, sort_keys=True)
print(formatted)
```

## Examples

### Example 1: Format Compact JSON

**Input:**
```python
input_string = '{"name":"John","age":30,"city":"New York"}'
```

**Code:**
```python
import json
data = json.loads(input_string)
formatted = json.dumps(data, indent=2, sort_keys=True)
print(formatted)
```

**Output:**
```json
{
  "age": 30,
  "city": "New York",
  "name": "John"
}
```

### Example 2: Format XML from String

**Input:**
```python
xml_string = '<root><item id="1"><name>Test</name></item></root>'
```

**Code:**
```python
import xml.dom.minidom as minidom
dom = minidom.parseString(xml_string)
formatted = dom.toprettyxml(indent="  ")
print(formatted)
```

**Output:**
```xml
<?xml version="1.0" ?>
<root>
  <item id="1">
    <name>Test</name>
  </item>
</root>
```

## Troubleshooting

**JSON parse error:**
- Check for trailing commas (not valid in JSON)
- Ensure proper quote usage (double quotes only)
- Validate at jsonlint.com

**XML parse error:**
- Verify all tags are properly closed
- Check for unescaped special characters (&, <, >)
- Ensure proper nesting

**YAML parse error:**
- Check indentation (spaces only, no tabs)
- Verify list syntax (dash + space)
- Quote strings containing special characters
```

## Key Characteristics

- **Single file**: Everything in SKILL.md
- **Focused**: Does one thing well
- **Complete examples**: Users can copy and run
- **Self-contained**: No external file references needed
- **Concise**: Under 200 lines total

## Validation Checklist

Before finalizing:
- [ ] SKILL.md < 200 lines
- [ ] At least 2 complete examples
- [ ] Each example shows input and output
- [ ] Troubleshooting section included
- [ ] Description includes trigger keywords
- [ ] All code examples are runnable
