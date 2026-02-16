# Command Errors

## clipm not found

**Symptom**: `command not found: clipm`

**Fix**:
1. Check if clipm is installed: `which clipm`
2. If not installed, inform user: "clipm CLI is required. Install it or use alternative task tracking."

## clipm init failed

**Symptom**: Error when running `clipm init`

**Check**:
```bash
ls -la .clipm 2>/dev/null || echo "Not initialized"
```

**If already exists**: Skip init, proceed with existing project.

**If permission error**: Check directory write permissions.

## Invalid task ID

**Symptom**: `Task not found` or `Invalid ID`

**Fix**:
```bash
clipm list | jq '.[].id'  # List all valid IDs
```

Use correct ID from list.

## Block/dependency errors

**Symptom**: `Cannot block: would create cycle`

**Fix**: Review dependency graph with `clipm tree`. Remove conflicting block or restructure tasks.

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
