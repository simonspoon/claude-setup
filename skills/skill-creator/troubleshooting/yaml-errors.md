# YAML Validation Errors

YAML frontmatter in SKILL.md has syntax or validation errors.

## Symptoms

- Error message about invalid YAML
- Skill won't load
- Frontmatter not recognized

## Common YAML Errors

### Error 1: Missing Opening/Closing Delimiters

**Problem:**
```markdown
name: my-skill
description: My skill description

# Skill Title
```

**Fix:** Add `---` delimiters
```markdown
---
name: my-skill
description: My skill description
---

# Skill Title
```

**Rule:** YAML frontmatter must start AND end with `---` on their own lines.

---

### Error 2: Incorrect Indentation

**Problem:**
```yaml
---
name: my-skill
  description: My skill description
---
```

**Fix:** Remove extra indentation
```yaml
---
name: my-skill
description: My skill description
---
```

**Rule:** Top-level fields (name, description) should have NO indentation.

---

### Error 3: Missing Quotes for Special Characters

**Problem:**
```yaml
---
name: my-skill
description: Skill with: colons and special chars
---
```

**Fix:** Add quotes
```yaml
---
name: my-skill
description: "Skill with: colons and special chars"
---
```

**Rule:** If description contains `:`, `#`, `>`, `|`, `[`, `{`, or starts with `!`, `&`, `*`, wrap in quotes.

---

### Error 4: Multi-line Description Wrong Format

**Problem:**
```yaml
---
name: my-skill
description: This is a very long description
that spans multiple lines
---
```

**Fix:** Use quotes or literal style
```yaml
---
name: my-skill
description: "This is a very long description that spans multiple lines"
---
```

Or use literal block:
```yaml
---
name: my-skill
description: |
  This is a very long description
  that spans multiple lines
---
```

**Rule:** Multi-line values need proper syntax (quotes or `|` literal blocks).

---

### Error 5: Missing Required Fields

**Problem:**
```yaml
---
name: my-skill
---
```

**Fix:** Add description field
```yaml
---
name: my-skill
description: Brief description of what this skill does and when to use it
---
```

**Rule:** Both `name` and `description` are REQUIRED.

---

### Error 6: Extra Fields

**Problem:**
```yaml
---
name: my-skill
description: My description
author: John Doe
version: 1.0
---
```

**Fix:** Remove extra fields (author, version not supported)
```yaml
---
name: my-skill
description: My description
---
```

**Rule:** Only `name` and `description` fields are recognized.

---

### Error 7: Invalid Characters in Name

**Problem:**
```yaml
---
name: My Skill!
description: My description
---
```

**Fix:** Use lowercase with hyphens
```yaml
---
name: my-skill
description: My description
---
```

**Rule:** Name must be lowercase letters, numbers, and hyphens only. No spaces, underscores, or special characters.

---

### Error 8: Name Too Long

**Problem:**
```yaml
---
name: this-is-a-very-long-skill-name-that-exceeds-the-maximum-allowed-length-of-sixty-four-characters
description: My description
---
```

**Fix:** Shorten name
```yaml
---
name: very-long-skill-name
description: My description
---
```

**Rule:** Name must be under 64 characters.

---

### Error 9: Description Too Long

**Problem:**
```yaml
---
name: my-skill
description: [Very long description over 1024 characters...]
---
```

**Fix:** Shorten to under 1024 characters
```yaml
---
name: my-skill
description: Concise description of what skill does and when to use it. Includes relevant keywords.
---
```

**Rule:** Description must be under 1024 characters.

---

### Error 10: XML Tags in Fields

**Problem:**
```yaml
---
name: my-skill
description: Process <input> and generate <output>
---
```

**Fix:** Remove or escape XML tags
```yaml
---
name: my-skill
description: Process input and generate output
---
```

**Rule:** No XML tags (< or >) allowed in name or description.

---

## Validation Checklist

Run through this checklist:

- [ ] Frontmatter starts with `---` on its own line
- [ ] Frontmatter ends with `---` on its own line
- [ ] `name` field is present
- [ ] `description` field is present
- [ ] Both fields have no indentation
- [ ] Name is lowercase-with-hyphens only
- [ ] Name is under 64 characters
- [ ] Name doesn't contain "anthropic" or "claude"
- [ ] Description is under 1024 characters
- [ ] No XML tags (< or >) in any field
- [ ] Special characters in description are quoted
- [ ] No extra/unsupported fields

## Testing YAML

Test YAML validity with Python:

```bash
python -c "
import yaml

with open('SKILL.md') as f:
    content = f.read()
    if not content.startswith('---'):
        print('❌ No YAML frontmatter')
        exit(1)
    
    parts = content.split('---', 2)
    if len(parts) < 3:
        print('❌ YAML not properly closed')
        exit(1)
    
    try:
        data = yaml.safe_load(parts[1])
        print('✅ Valid YAML')
        print(f'Name: {data.get(\"name\", \"MISSING\")}')
        print(f'Description: {data.get(\"description\", \"MISSING\")}')
    except Exception as e:
        print(f'❌ YAML error: {e}')
        exit(1)
"
```

## Quick Fixes

### Fix 1: Start Fresh
If YAML is completely broken, start with this template:

```yaml
---
name: skill-name
description: What the skill does and when to use it
---

# Skill Title

Content here...
```

### Fix 2: Validate Online
Copy YAML frontmatter to https://www.yamllint.com/ (without the `---` delimiters)

### Fix 3: Check Quotes
If description has special chars, wrap entire description in double quotes:

```yaml
description: "Description with: colons, #hashes, and other special chars!"
```

## Common Questions

**Q: Can I use emojis in description?**
A: Yes, but keep them minimal and wrap description in quotes.

**Q: Can I have comments in YAML?**
A: No, comments are not supported in skill frontmatter.

**Q: Can I use environment variables?**
A: No, YAML is static. No variable substitution.

**Q: What if my description needs to be longer than 1024 chars?**
A: Keep description concise (what + when). Put details in SKILL.md body.

## Related Issues

- [name-validation-errors.md](name-validation-errors.md) - Specific name validation problems
- [description-errors.md](description-errors.md) - Specific description problems
