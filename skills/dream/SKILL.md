---
name: dream
description: Offline memory consolidation — deduplicates, prunes, and synthesizes suda memories. Produces recommendations for skill/agent improvements. Run manually or on schedule.
---

# Dream — Memory Consolidation

Offline memory maintenance. Deduplicates, prunes stale entries, and synthesizes patterns into actionable recommendations. This is the complement to the append-only suda-observer hook — the observer accumulates freely, this skill cleans up.

## When to Invoke

- Manually via `/dream`
- On a scheduled cadence (daily or weekly)
- When `suda recall` output feels noisy or redundant

## Phase 1: Inventory

Load everything and get the lay of the land.

```bash
suda recall --json --limit 200
suda projects --json
```

Report:
- Total memory count by type (user, feedback, project, reference)
- Age distribution (last 7 days, last 30 days, older)
- Memories per project

## Phase 2: Consolidate

Group memories by semantic similarity (same topic, same rule, same preference).

For each group with multiple entries:
- **True duplicates** (same rule, different wording): Keep the one with the richest content. `suda forget <ID>` the others.
- **Complementary** (same topic, additive info): Create a merged memory via `suda store`, then `suda forget` the originals.
- **Contradictory** (same topic, conflicting advice): Keep the newer entry (higher ID = more recent). Forget the older. Note the contradiction in the report.

Log every action: what was merged/removed and why.

## Phase 3: Prune

Check each memory against reality:

1. **Stale references**: If a memory names a file path, check if the file exists. If not, forget it.
2. **Outdated project context**: If a project memory references a version, deadline, or status, verify against current state (git log, Cargo.toml, etc.). If outdated, forget it.
3. **Age without reinforcement**: Memories older than 90 days that haven't been reinforced by a similar newer entry — flag for review (don't auto-delete, just report).

## Phase 4: Synthesize

Read across all remaining memories and identify patterns:

1. **Recurring feedback themes**: If 3+ feedback entries cluster around the same topic (e.g., "testing practices", "commit conventions"), recommend consolidating into a skill instruction or CLAUDE.md rule.
2. **Emerging conventions**: If project memories show the same architectural decision repeated across projects, recommend documenting as a convention.
3. **Skill gaps**: If feedback entries describe problems that a skill should have prevented, recommend a skill improvement.
4. **Agent behavior gaps**: If user corrections suggest the agent should behave differently by default, recommend an agent definition update.

Do NOT auto-apply any recommendations. Output them for user review.

## Phase 5: Report

Output a structured report:

```
## Dream Report — <date>

### Inventory
- Total: X memories (Y user, Z feedback, ...)
- Age: X < 7d, Y < 30d, Z older

### Consolidation
- Merged: X groups (Y memories -> Z)
- Removed duplicates: [list IDs]

### Pruning
- Stale references removed: [list]
- Outdated project context removed: [list]
- Flagged for review (old, unreinforced): [list]

### Recommendations
1. [Skill/agent recommendation with reasoning]
2. [...]

### Summary
Before: X memories -> After: Y memories (Z removed, W merged)
```

## Rules

1. **Consolidation and pruning are executed.** The dream agent acts on memories directly.
2. **Recommendations are reported only.** Never auto-modify skills or agents.
3. **Log every destructive action.** Every `suda forget` must be logged with the reason.
4. **When in doubt, keep.** If you can't tell whether two memories are truly duplicates, leave them both.
5. **Verify before pruning.** Check file existence and git state before declaring something stale.
