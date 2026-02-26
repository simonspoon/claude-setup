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
  clipm status <id> done --outcome "Manual fix: <what was done and verified>"
  ```

- **Skip**: If task is non-critical
  ```bash
  clipm note <id> "Skipped: <reason>"
  clipm status <id> done --outcome "Skipped: <reason>"
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

## Subagent marked done but code has runtime bugs

**Symptom**: Task is `[DONE]`, code compiles, but crashes or hangs at runtime. Discovered during integration checkpoint.

**This is the most common subagent failure mode.** Subagents verify compilation but rarely test runtime behavior.

**Action**:
1. Diagnose the bug yourself (run the binary, check logs, add debug output)
2. Fix the bug directly — do NOT re-dispatch to a subagent for small fixes
3. Add note: `clipm note <id> "Post-fix: <what was wrong and how it was fixed>"`

**Prevention**: Always include runtime verification steps in the subagent prompt. See [parallel.md](../orchestration/parallel.md#-critical-always-include-verification-steps).

**Common patterns**:
- Code hangs silently → deadlock, blocking call on wrong thread, missing init
- Code crashes on first real input → missing error handling, wrong assumptions about data format
- Code works in isolation but fails in context → missing env setup, wrong paths, stdio conflicts

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
