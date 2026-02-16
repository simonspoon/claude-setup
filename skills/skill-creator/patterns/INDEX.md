# Skill Patterns Index

Available skill patterns organized by use case.

## Pattern Selection Guide

**Choose pattern based on skill purpose:**

### 1. Minimal Skill Pattern
**File:** [minimal-skill.md](minimal-skill.md)

**Use when:**
- Simple, focused functionality
- All content fits in one file (<200 lines)
- No scripts or additional resources needed
- Straightforward examples demonstrate usage

**Example skills:** Simple formatter, calculator, basic file operations

---

### 2. Tool Wrapper Pattern
**File:** [tool-wrapper.md](tool-wrapper.md)

**Use when:**
- Wrapping a library, API, or command-line tool
- Need API reference documentation
- Multiple related operations on same tool
- Common patterns can be demonstrated

**Example skills:** Pandas data analysis, Git operations, Docker commands

---

### 3. Workflow/Process Pattern
**File:** [workflow-process.md](workflow-process.md)

**Use when:**
- Encoding organizational processes
- Multi-step procedures or checklists
- References to standards and guidelines
- Quality gates and validation steps

**Example skills:** Code review process, deployment workflow, testing procedures

---

### 4. Knowledge Base Pattern
**File:** [knowledge-base.md](knowledge-base.md)

**Use when:**
- Providing reference information
- Multiple related topics or domains
- Schema, spec, or API documentation
- Need for detailed technical references

**Example skills:** Company API docs, database schema reference, internal tool documentation

---

### 5. Comprehensive Pattern
**File:** [comprehensive-skill.md](comprehensive-skill.md)

**Use when:**
- Complex functionality requiring multiple files
- Need automation scripts for validation/generation
- Large amounts of reference data or templates
- Multiple workflows and use cases

**Example skills:** Database query system, configuration manager, code generator

---

## Quick Decision Tree

**Is the skill simple and fits in one file?**
→ Use [minimal-skill.md](minimal-skill.md)

**Does it wrap a specific tool or library?**
→ Use [tool-wrapper.md](tool-wrapper.md)

**Does it encode a process or workflow?**
→ Use [workflow-process.md](workflow-process.md)

**Is it primarily reference documentation?**
→ Use [knowledge-base.md](knowledge-base.md)

**Is it complex with scripts and multiple components?**
→ Use [comprehensive-skill.md](comprehensive-skill.md)

---

## Pattern Comparison

| Pattern | File Count | Script Support | Best For |
|---------|-----------|----------------|----------|
| Minimal | 1 | No | Simple operations |
| Tool Wrapper | 2-3 | Optional | Library/API wrapping |
| Workflow | 3-5 | Rare | Process encoding |
| Knowledge Base | 3-6 | No | Reference docs |
| Comprehensive | 5+ | Yes | Complex systems |

---

## Next Steps

1. Select pattern that matches your skill's purpose
2. Read the pattern file for complete structure and examples
3. Follow the pattern's template and guidelines
4. Validate using [validation/CHECKLIST.md](../validation/CHECKLIST.md)
