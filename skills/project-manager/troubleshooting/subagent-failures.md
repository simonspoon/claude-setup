# Subagent Failures

## Subagent reported failure

**Action**:
1. Check task status: `clipm show <id>`
2. Read agent notes: Look for error details in notes array
3. If task still `in-progress`, it may need manual resolution

**Recovery options**:
- **Retry**: Unclaim and re-dispatch
  ```bash
  clipm unclaim <id>
  clipm status <id> todo
  ```
  Then dispatch new subagent with same task.

- **Manual fix**: Complete the work yourself, then mark done
  ```bash
  clipm note <id> "Manual fix: <description>"
  clipm status <id> done
  ```

- **Skip**: If task is non-critical
  ```bash
  clipm note <id> "Skipped: <reason>"
  clipm status <id> done
  ```

## Subagent timeout

**Symptom**: No response from dispatched agent.

**Check**:
```bash
clipm show <id>  # Is status still in-progress?
```

**If stuck**: See [stuck-tasks.md](stuck-tasks.md).

## Subagent completed wrong work

**Action**:
1. Add note documenting issue: `clipm note <id> "Issue: did X instead of Y"`
2. Keep task in-progress or reset to todo
3. Re-dispatch with clearer instructions

**Prevention**: Include specific acceptance criteria in subagent prompt.

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
