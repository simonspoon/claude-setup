---
name: project-manager
description: Orchestrate complex projects using clipm for hierarchical task management and parallel subagent execution
triggers:
  - manage this project
  - break down this feature
  - plan this work
  - decompose this task
  - orchestrate this
  - /pm
---

# Project Manager Skill

Decompose work into hierarchical tasks (clipm) and dispatch parallel subagents.

## ⚠️ CRITICAL REQUIREMENTS

- **Block order**: `clipm block <blocker> <blocked>` — first arg blocks the second
- **Parallel dispatch**: Use multiple Task tool calls in a SINGLE message
- **Concurrency limit**: Max 3-5 subagents at once
- **File conflicts**: NEVER parallelize tasks modifying the same files
- **Verify before dispatch**: Check `blockedBy` is empty before assigning
- **IDs are strings**: clipm IDs are 4-char strings (e.g., `unke`), not integers
- **Subagent prompts MUST include verification steps**: Every code-writing subagent must build AND runtime-test its output. "It compiles" is not done. See [orchestration/parallel.md](orchestration/parallel.md#-critical-always-include-verification-steps)
- **Integration checkpoint is MANDATORY**: After each wave completes, the orchestrator must build and smoke-test before dispatching the next wave

## Workflow Overview

```mermaid
flowchart TD
    A[User Request] --> B{clipm init?}
    B -->|No| C[clipm init]
    B -->|Yes| D{Task Type}
    C --> D

    D -->|New system| E[workflows/new-project.md]
    D -->|Add feature| F[workflows/feature.md]
    D -->|Fix bug| G[workflows/bug-fix.md]
    D -->|Modify existing| H[workflows/change-request.md]

    E --> I[Create task hierarchy]
    F --> I
    G --> I
    H --> I

    I --> J[Set dependencies]
    J --> K[Find unblocked tasks]
    K --> L{Parallel tasks?}

    L -->|Yes| M[Dispatch subagents]
    L -->|No| N{All done?}

    M --> O[Monitor: clipm tree + fix stale status]
    O --> P[Check newly unblocked]
    P --> K

    N -->|No| K
    N -->|Yes| Q[Report results]
```

## Plan Mode Interop

If you already created a plan file (via plan mode) before invoking this skill, **use the plan as your task source** — don't re-research. Convert the plan's steps directly into clipm tasks with dependencies. The plan file is your Phase 0 output; skip to task creation.

## Phase 0: Research (Before Task Creation)

When the project involves external tools, APIs, or libraries:

1. **Identify unknowns** - List external dependencies that need verification
2. **Verify APIs** - Check actual command syntax, available endpoints, field names
3. **Document findings** - Note exact commands/APIs to use in task descriptions

Do NOT proceed to task creation until external dependencies are verified.

See [workflows/new-project.md](workflows/new-project.md#external-tool-discovery) for discovery patterns.

## Quick Reference

### Initialize
```bash
[ ! -d ".clipm" ] && clipm init
```

### Create Hierarchy
```bash
clipm add "Root task"              # Outputs just the task ID, e.g. "abcd"
clipm add "Child" --parent abcd    # Child of task abcd
clipm parent efgh abcd             # Set abcd as parent of efgh (positional, no flags)
clipm block abcd efgh              # efgh waits for abcd
```

### Find Parallel Work
```bash
clipm list --status todo --unblocked
```

### Monitor
```bash
clipm tree                         # Visual hierarchy
clipm show <id>                    # Task details
```

## Subagent Dispatch

Dispatch using Task tool. **All independent tasks in ONE message.**

```
Execute clipm task <ID>: "<description>"

1. clipm claim <ID> <agent-name>
2. clipm status <ID> in-progress
3. <do the work>
4. <verify: build + runtime smoke test>
5. clipm note <ID> "Done: <summary>"
6. clipm status <ID> done
```

See [orchestration/parallel.md](orchestration/parallel.md) for checklist and examples.

### After Subagent Completion

Run `clipm tree` after each dispatch wave returns.

**Fix stale leaf tasks:** If a completed subagent's task still shows `[TODO]`, manually run `clipm status <id> done`. Subagents occasionally fail to update clipm.

**Roll up parent tasks:** After all children of a parent task are `[DONE]`, mark the parent done too: `clipm status <parent-id> done`. This unblocks any tasks that depend on the parent (e.g., INDEX.md blocked by a "Write developer docs" parent).

**Avoid unnecessary grouping tasks.** Only create parent grouping tasks (e.g., "Write developer docs") when other tasks explicitly need to block on the whole group. If tasks only block on individual leaves, skip the grouping layer — it just adds status management overhead.

## When Things Go Wrong

See [troubleshooting/INDEX.md](troubleshooting/INDEX.md) for:
- Command failures
- Subagent failures
- Stuck tasks
- File conflicts

## Resuming Work

See [orchestration/recovery.md](orchestration/recovery.md) for mid-project re-entry.

## References

- [Workflow Index](workflows/INDEX.md)
- [Orchestration Patterns](orchestration/INDEX.md)
- [clipm Commands](reference/clipm-commands.md)
