# Examples Index

Complete skill examples showing different patterns in action.

## Available Examples

All examples are in the [patterns/](../patterns/) directory, which contains both pattern documentation AND complete working examples.

### By Complexity

**Simple Skills (Single File):**
- [Minimal Pattern](../patterns/minimal-skill.md#complete-example-simple-formatter) - JSON/XML formatter example

**Medium Skills (2-3 Files):**
- [Tool Wrapper Pattern](../patterns/tool-wrapper.md#complete-example-data-analysis-skill) - Pandas data analysis
- [Knowledge Base Pattern](../patterns/knowledge-base.md#complete-example-company-api-documentation) - API documentation

**Complex Skills (Multiple Files + Scripts):**
- [Workflow Pattern](../patterns/workflow-process.md#complete-example-code-review-process) - Code review process
- [Comprehensive Pattern](../patterns/comprehensive-skill.md#complete-example-database-query-system) - Database query system

### By Purpose

**Wrapping Tools/Libraries:**
→ [Tool Wrapper Pattern](../patterns/tool-wrapper.md)

**Encoding Processes:**
→ [Workflow Pattern](../patterns/workflow-process.md)

**Providing Documentation:**
→ [Knowledge Base Pattern](../patterns/knowledge-base.md)

**Complex Systems:**
→ [Comprehensive Pattern](../patterns/comprehensive-skill.md)

## How to Use Examples

1. **Identify your skill type** - What are you building?
2. **Read matching pattern** - Go to patterns/ directory
3. **Study complete example** - Each pattern has full example
4. **Adapt to your needs** - Use as template

## Example Structure Reference

### Minimal Skill Structure
```
skill-name/
└── SKILL.md
```

See: [minimal-skill.md](../patterns/minimal-skill.md)

### Tool Wrapper Structure
```
skill-name/
├── SKILL.md
├── REFERENCE.md
└── ADVANCED.md
```

See: [tool-wrapper.md](../patterns/tool-wrapper.md)

### Workflow Structure
```
skill-name/
├── SKILL.md
├── workflows/
│   └── INDEX.md
└── standards/
    └── INDEX.md
```

See: [workflow-process.md](../patterns/workflow-process.md)

### Knowledge Base Structure
```
skill-name/
├── SKILL.md
├── topics/
│   └── INDEX.md
└── schemas/
```

See: [knowledge-base.md](../patterns/knowledge-base.md)

### Comprehensive Structure
```
skill-name/
├── SKILL.md
├── guides/
├── operations/
├── scripts/
├── templates/
└── schemas/
```

See: [comprehensive-skill.md](../patterns/comprehensive-skill.md)

## Quick Selection Guide

**I need to create a skill that...**

**...does simple operations (formatting, calculation, etc.)**
→ Use [Minimal Pattern](../patterns/minimal-skill.md)

**...wraps a library or tool (pandas, requests, etc.)**
→ Use [Tool Wrapper Pattern](../patterns/tool-wrapper.md)

**...encodes a process (code review, deployment, etc.)**
→ Use [Workflow Pattern](../patterns/workflow-process.md)

**...provides reference docs (API, schema, etc.)**
→ Use [Knowledge Base Pattern](../patterns/knowledge-base.md)

**...needs scripts and complex structure**
→ Use [Comprehensive Pattern](../patterns/comprehensive-skill.md)

## Related Resources

- [../patterns/INDEX.md](../patterns/INDEX.md) - All patterns with complete examples
- [../workflow/create-from-requirements.md](../workflow/create-from-requirements.md) - Step-by-step creation guide
- [../validation/CHECKLIST.md](../validation/CHECKLIST.md) - Validation requirements
