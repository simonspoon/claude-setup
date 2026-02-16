# Skill Validation Checklist

Complete validation checklist before finalizing any skill.

## ⚠️ CRITICAL Requirements

These MUST pass - skill cannot be finalized without them.

### YAML Frontmatter
- [ ] SKILL.md file exists
- [ ] Valid YAML frontmatter (starts/ends with `---`)
- [ ] `name` field present
- [ ] `description` field present

### Name Validation
- [ ] Lowercase letters, numbers, and hyphens only
- [ ] Under 64 characters
- [ ] Does NOT contain "anthropic"
- [ ] Does NOT contain "claude"
- [ ] No XML tags (< or >)
- [ ] Format: `skill-name` or `category-skill-name`

### Description Validation
- [ ] Non-empty
- [ ] Under 1024 characters
- [ ] No XML tags (< or >)
- [ ] Specifies WHAT the skill does
- [ ] Specifies WHEN to use it (trigger conditions/keywords)
- [ ] Includes relevant keywords users might mention

### Content Requirements
- [ ] At least one complete, runnable example
- [ ] Instructions are imperative ("Do X", not "You should X")
- [ ] No placeholder values without documentation
- [ ] SKILL.md is under 200 lines (or has good reason to be longer)

## Important Requirements

These should pass for high-quality skills.

### Structure and Organization
- [ ] SKILL.md has clear sections with headings
- [ ] Related content grouped logically
- [ ] Advanced/detailed content in separate files (not dumped in SKILL.md)
- [ ] File references use relative paths
- [ ] All linked files actually exist

### Examples and Documentation
- [ ] Examples show input and expected output
- [ ] Examples are complete (can be copy-pasted and run)
- [ ] Complex operations have step-by-step instructions
- [ ] Templates have placeholder documentation
- [ ] Edge cases or gotchas are mentioned

### Clarity and Usability
- [ ] Instructions are specific and actionable
- [ ] No vague guidance ("figure it out", "as needed")
- [ ] Decision points are explicit ("If X, then Y")
- [ ] Troubleshooting guidance exists
- [ ] Quick Start section for common case

## Nice-to-Have

These improve skill quality but aren't required.

### Progressive Disclosure
- [ ] Most common use case in Quick Start
- [ ] Common operations easily accessible
- [ ] Advanced topics in separate files
- [ ] INDEX files for directories with multiple files

### Guardrails and Error Handling
- [ ] Guidance for when things go wrong
- [ ] Conditional logic for different scenarios
- [ ] "Stop and ask user" conditions defined
- [ ] Clear escalation paths

### User Experience
- [ ] Critical requirements marked with ⚠️
- [ ] Related operations cross-referenced
- [ ] Consistent formatting and style
- [ ] No excessive prose or filler

## Validation by Skill Type

Different patterns have additional requirements:

### Minimal Skill
- [ ] Everything in SKILL.md (no separate files needed)
- [ ] Under 200 lines
- [ ] At least 2 complete examples
- [ ] Troubleshooting section present

### Tool Wrapper
- [ ] Common operations section exists
- [ ] REFERENCE.md for detailed API (if needed)
- [ ] Tool/library name in description
- [ ] Import statements shown in examples

### Workflow/Process
- [ ] Critical requirements clearly marked
- [ ] Process steps are sequential
- [ ] Decision tree for different scenarios
- [ ] Standards referenced or documented

### Knowledge Base
- [ ] Topics organized with INDEX files
- [ ] Each topic is self-contained
- [ ] Quick reference section exists
- [ ] Cross-references between topics work

### Comprehensive
- [ ] Scripts have usage examples
- [ ] Scripts handle errors properly
- [ ] Templates have placeholder docs
- [ ] INDEX files for all directories

## Automated Checks

Run these commands to validate:

### Check YAML frontmatter
```bash
# Check if file has valid YAML
python -c "
import yaml
with open('SKILL.md') as f:
    content = f.read()
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            yaml.safe_load(parts[1])
            print('✅ Valid YAML')
        else:
            print('❌ YAML not properly closed')
    else:
        print('❌ No YAML frontmatter')
"
```

### Check name and description
```bash
# Extract and validate name/description
python scripts/validate_skill.py SKILL.md
```

### Check file links
```bash
# Find all markdown links and verify files exist
grep -r '\[.*\]([^h].*\.md)' SKILL.md | while read line; do
    file=$(echo $line | sed -n 's/.*(\([^)]*\)).*/\1/p')
    if [ ! -f "$file" ]; then
        echo "❌ Broken link: $file"
    fi
done
```

## Common Validation Failures

### "Name contains invalid characters"
**Fix:** Use only lowercase letters, numbers, and hyphens
- ❌ `my_skill`, `MySkill`, `my skill`
- ✅ `my-skill`

### "Description doesn't specify when to use"
**Fix:** Add trigger conditions
- ❌ "Create presentations"
- ✅ "Create presentations. Use when user mentions PowerPoint, slides, or .pptx files"

### "Missing examples"
**Fix:** Add at least one complete example with input and output
```markdown
## Example: Format JSON

**Input:**
```python
data = '{"name":"John"}'
```

**Code:**
```python
import json
print(json.dumps(json.loads(data), indent=2))
```

**Output:**
```json
{
  "name": "John"
}
```
```

### "SKILL.md too long"
**Fix:** Move content to separate files
- Create INDEX.md files
- Split examples into examples/ directory
- Move advanced topics to guides/
- Keep SKILL.md focused on core workflow

## Final Check

Before marking skill as complete:

1. **Run validation script** (if available)
2. **Test trigger conditions** - Does skill load when expected?
3. **Test examples** - Can you actually run them?
4. **Check links** - Do all file references work?
5. **Read as first-time user** - Is it clear without prior knowledge?

If all critical items ✅, skill is valid.
If any critical items ❌, fix before finalizing.
