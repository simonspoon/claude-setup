# Stuck Tasks

## Task remains in-progress

**Diagnosis**:
```bash
clipm show <id>
```

Check:
- `owner`: Who claimed it?
- `notes`: Any progress logged?

## Recovery Steps

### Option 1: Force complete (if work was done)

Verify the work is actually complete, then:
```bash
clipm note <id> "Force completed: verified work done"
clipm status <id> done --outcome "Force completed: <what was verified>"
```

### Option 2: Reset and re-dispatch

```bash
clipm unclaim <id>
clipm status <id> todo
```

Then dispatch new subagent.

### Option 3: Abandon and create replacement

If task is corrupted or unclear:
```bash
clipm note <id> "Abandoned: <reason>"
clipm status <id> done --outcome "Abandoned: <reason>"

clipm add "Replacement: <clearer description>" --parent <parent-id> \
  --action "..." --verify "..." --result "..."
```

## Preventing Stuck Tasks

Include in subagent prompt:
```
If you cannot complete this task:
1. clipm note <ID> "Blocked: <reason>"
2. Report the blocker in your response
```

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
