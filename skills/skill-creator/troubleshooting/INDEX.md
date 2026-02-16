# Troubleshooting Index

Common issues when creating skills and how to fix them.

## Quick Links

**Skill doesn't trigger when expected:**
→ Read [trigger-problems.md](trigger-problems.md)

**YAML validation errors:**
→ Read [yaml-errors.md](yaml-errors.md)

**SKILL.md file is too long:**
→ Read [file-too-long.md](file-too-long.md)

**Examples aren't clear enough:**
→ Read [unclear-examples.md](unclear-examples.md)

**Unsure about file structure:**
→ Read [structure-problems.md](structure-problems.md)

## All Issues

### Trigger and Discovery Issues
- [trigger-problems.md](trigger-problems.md) - Skill not loading when it should
- [trigger-too-broad.md](trigger-too-broad.md) - Skill loads when it shouldn't

### Validation Errors
- [yaml-errors.md](yaml-errors.md) - YAML frontmatter problems
- [name-validation-errors.md](name-validation-errors.md) - Invalid skill names
- [description-errors.md](description-errors.md) - Description validation failures

### Content Issues
- [unclear-examples.md](unclear-examples.md) - Examples missing details
- [file-too-long.md](file-too-long.md) - SKILL.md exceeds 200 lines
- [missing-documentation.md](missing-documentation.md) - Templates without docs

### Structure Issues
- [structure-problems.md](structure-problems.md) - Unclear how to organize files
- [broken-links.md](broken-links.md) - File references don't work
- [missing-files.md](missing-files.md) - Referenced files don't exist

## Problem Categories

### Can't Create Skill
Issues preventing skill creation:
1. Missing user requirements → Read [../workflow/gather-requirements.md](../workflow/gather-requirements.md)
2. Unclear skill scope → Ask user clarifying questions
3. Don't know which pattern → Read [../patterns/INDEX.md](../patterns/INDEX.md)

### Skill Created But Broken
Issues with completed skills:
1. YAML validation fails → Read [yaml-errors.md](yaml-errors.md)
2. Examples don't work → Read [unclear-examples.md](unclear-examples.md)
3. File references broken → Read [broken-links.md](broken-links.md)

### Skill Works But Poor Quality
Quality improvements needed:
1. Too verbose → Read [file-too-long.md](file-too-long.md)
2. Vague instructions → Make them imperative and specific
3. Missing edge cases → Add troubleshooting section
4. No trigger keywords → Read [trigger-problems.md](trigger-problems.md)

## Getting Help

If issue not listed here:
1. Check [../validation/CHECKLIST.md](../validation/CHECKLIST.md) for requirements
2. Review [../patterns/INDEX.md](../patterns/INDEX.md) for examples
3. Ask user for clarification if domain-specific issue
