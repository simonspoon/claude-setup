---
name: skill-reflection
description: Analyze user sessions to identify skill usage patterns, detect improvement opportunities, create actionable enhancement plans, and implement improvements to existing skills. Use when the user requests skill analysis, skill improvement, or session reflection on skill performance.
---

# Skill Reflection

Analyze user sessions to improve skill quality by identifying structural issues, missing guardrails, and clarity problems.

## Core Principle

**You are a generalist skill improver. You do NOT need domain knowledge.**

Identify: structural problems, process problems, clarity problems, guardrail problems.
Do NOT judge: domain correctness, implementation details.
When domain knowledge is needed: ask the user or note "skill should define this term/concept."

## Improvement Signals

Review the session for:
- User corrected the agent multiple times
- Agent made assumptions about domain terminology
- Agent got stuck and didn't know how to proceed
- Agent chose wrong file/section because skill wasn't clear
- Agent didn't follow critical requirement
- User said "Could this not have been..." (overcomplexity)
- Agent used wrong template or filled it incorrectly

## Problem Categories

| Category | Symptom |
|----------|---------|
| **Structure** | Files too large, poor organization, no index |
| **Clarity** | Vague instructions, unexplained terms, unclear steps |
| **Guardrails** | No guidance for errors/edge cases, missing escalation |
| **Templates** | Placeholders not documented, examples missing |
| **Critical** | Required practices not marked as critical |

## Workflow

1. **Identify signals** from the session (see list above)
2. **Categorize** each problem. Check [reference/anti-patterns.md](reference/anti-patterns.md) — if the session shows any of these 5 patterns, flag them. If domain knowledge needed, ask user.
3. **Plan improvement:**
   ```
   Skill: [name]
   Issue: [structural/clarity/guardrail problem]
   Signal: [what in session indicated this]
   Root Cause: [why skill failed to guide properly]
   Proposed Fix: [specific changes]
   Expected Outcome: [how this helps weaker models]
   ```
4. **Consult user** about domain terminology, valid error conditions, edge cases. Do NOT ask about file structure, instruction clarity, or how to mark critical requirements — those are your call.
5. **Implement** improvements. Read existing files first. Apply fixes for structure, guardrails, templates, critical requirements. Keep SKILL.md focused (~100 lines).
6. **Validate** — run [reference/validation-checklist.md](reference/validation-checklist.md) against your changes. Every item must pass before declaring done.

## Key Fixes by Category

**Progressive Disclosure**: Break large files into focused files with index. Main SKILL.md points to indexes, not full documents.

**Template Documentation**: Every template needs: placeholder meaning, how to get value, filled example, expected output, what to do if output is wrong.

**Guardrails with Context**: Add conditional guidance ("If X AND Y, then Z") and explicit escalation paths ("If unclear, ask user: '[scripted question]'").

**Critical Instructions**: Mark universal requirements at top of SKILL.md with clear formatting. Don't bury them in prose.

**Weak Model Optimization**: Replace prose with imperatives. Be concise but complete. Provide decision frameworks, not just conditions.

## Reference

- [reference/anti-patterns.md](reference/anti-patterns.md) — 5 common anti-patterns with before/after examples
- [reference/validation-checklist.md](reference/validation-checklist.md) — Post-improvement validation checklist

## When to Stop and Ask User

Stop and consult when:
- Skill uses domain terminology you don't understand
- Multiple ways to structure and you need domain context to choose
- Unclear what error conditions are valid vs problematic
- Need to verify whether your general knowledge applies to this domain
