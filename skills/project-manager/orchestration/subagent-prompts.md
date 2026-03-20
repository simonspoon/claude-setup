# Subagent Dispatch Templates

## Standard Code Task Prompt

```
Execute limbo task <ID>: "<description>"

## Context
<relevant function signatures, types, and surrounding code — extracted via Explore agent>

## Files you MUST modify
- path/to/file1.rs (function_name)
- path/to/file2.rs (struct_name)

## Files you MUST NOT touch
- path/to/shared.rs (owned by another agent)
- path/to/tests/shared_test.rs

## Task
<specific work to do>

## Edge Cases
- <edge case 1 — spelled out explicitly>
- <edge case 2>

## Preserved Behaviors (if rewriting existing code)
- <behavior 1 the old code had>
- <behavior 2 that must not regress>

## Test Initializers (if adding/removing struct fields)
Update these test constructors to include the new fields:
- path/to/tests.rs:line (add `new_field: default_value`)

## Callers (if changing function signatures)
These call sites use the old signature and must be updated:
- path/to/caller.rs:line (`old_call()` → `new_call()`)

## Verification
Choose by code type:
- Runnable (CLI, API, script): build + run end-to-end with sample input
- Interactive (TUI, GUI): verify imports + signatures exist, unit-test pure logic
- Library: import and call key functions with sample data + assert results

Always run the project formatter before declaring done (e.g., `cargo fmt`, `prettier --write .`, `black .`).

Minimum: Level 3 (static analysis). Prefer Level 4+ (runtime test).
```

## Verification Depth Ladder

| Level | Name | What it checks | When sufficient |
|-------|------|----------------|-----------------|
| 1 | Import check | Code imports correctly | Never — too shallow |
| 2 | Compile/build | No syntax or type errors | Only for trivial config changes |
| 3 | Static analysis | Types match, signatures correct | Non-runnable code (TUI, GUI) |
| 4 | Runtime test | Executes with sample input | Most code tasks |
| 5 | Full integration | End-to-end with real dependencies | Critical paths, APIs |

## Research Before Dispatch

Before writing any subagent prompt:

1. Use an Explore agent to extract relevant function signatures and types from files the subagent will modify
2. Also extract signatures from files the modified code calls into (callees)
3. **Find callers of any function whose signature changes** (async→sync, new params, new return type). If the function is called from files outside the subagent's scope, either expand the scope or create a follow-up task for the cascade
4. **Find test constructors** for any struct/type that gains or loses fields. Grep for direct struct-literal initializers (e.g., `MyStruct {`) in test files and include those locations in the subagent prompt with instructions to add the new fields
5. Include this context in the prompt — subagents succeed when prompts have precise code context
6. Do NOT read entire files into the orchestrator's context window

Back to [SKILL.md](../SKILL.md) | [Orchestration Index](INDEX.md)
