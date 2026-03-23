# Unclear File Structure

Unsure how to organize skill files and directories.

## Symptoms

- All content crammed into a single SKILL.md
- Files scattered without clear organization
- No INDEX files, so agent doesn't know what's available
- Unclear what goes in SKILL.md vs supporting files

## Root Cause

No clear mental model for what belongs where in a skill's directory structure.

## Fix

Follow the standard skill structure, placing content by purpose.

## Standard Structure

### Minimal Skill (single file)
```
my-skill/
└── SKILL.md
```
Use when: Skill fits in under 150 lines total.

### Standard Skill (with supporting files)
```
my-skill/
├── SKILL.md           # Core instructions, navigation, critical requirements
├── examples/
│   ├── INDEX.md       # Lists all examples
│   └── *.md           # One file per example scenario
├── guides/
│   ├── INDEX.md       # Lists all guides
│   └── *.md           # One file per guide topic
└── troubleshooting/
    ├── INDEX.md       # Lists common issues
    └── *.md           # One file per issue
```

### Knowledge-Heavy Skill
```
my-skill/
├── SKILL.md           # Core instructions + decision tree
├── knowledge/
│   ├── INDEX.md       # Lists all reference docs
│   └── *.md           # Domain knowledge files
├── workflow/
│   ├── INDEX.md
│   └── *.md           # Step-by-step processes
└── patterns/
    ├── INDEX.md
    └── *.md           # Reusable patterns/templates
```

## What Goes Where

### SKILL.md (always required)
- YAML frontmatter (name + description)
- Critical requirements that apply to ALL usage
- Quick start / simplest example
- Decision tree: "What are you trying to do?" with links to supporting files
- Quick reference (cheat sheet)

### Supporting files
- Detailed examples (examples/)
- Step-by-step guides (guides/)
- Domain knowledge / reference docs (knowledge/)
- Troubleshooting guides (troubleshooting/)
- Reusable patterns or templates (patterns/)

## Rules

1. Every directory with multiple files MUST have an INDEX.md
2. SKILL.md should be under 200 lines
3. Each supporting file should be self-contained and focused on one topic
4. Use descriptive filenames: `setup-postgres.md` not `guide1.md`
5. Link from SKILL.md to supporting files — never leave content orphaned

## Validation

After organizing, verify:

- [ ] SKILL.md exists with YAML frontmatter
- [ ] SKILL.md is under 200 lines
- [ ] Every directory has an INDEX.md
- [ ] All files are reachable from SKILL.md (directly or via INDEX files)
- [ ] No broken links between files

## Related Issues

- [file-too-long.md](file-too-long.md) - How to split an oversized SKILL.md
- [broken-links.md](broken-links.md) - Fixing broken file references
