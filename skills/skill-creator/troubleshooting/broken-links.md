# Broken File References

Links between skill files point to files that don't exist.

## Symptoms

- Agent told to "Read file.md" but file doesn't exist
- INDEX.md references files that were renamed or removed
- Relative paths resolve to wrong locations

## Root Cause

Files were renamed, moved, or deleted without updating references. Or references were written speculatively before files were created.

## Fix

Audit all file references and ensure every link target exists.

## Step-by-Step Solution

### 1. List All References

Search for markdown links in all skill files:
```bash
grep -rn '\[.*\](.*\.md)' /path/to/skill/
```

### 2. Verify Each Target Exists

For each reference found, check the target file exists at the expected path. Remember that paths are relative to the file containing the link.

### 3. Fix Broken References

For each broken link, either:
- **Create the missing file** if the content is needed
- **Remove the reference** if the content isn't necessary
- **Update the path** if the file was moved/renamed

### 4. Check INDEX Files

INDEX.md files are the most common source of broken links. After any file rename, move, or delete, immediately update all INDEX files.

## Prevention

- When renaming or deleting a file, grep for its name across all skill files first
- When adding a reference to a new file, create the file immediately
- Keep INDEX files as the single source of truth for directory contents

## Validation

After fixing, verify:

- [ ] Every markdown link target exists
- [ ] Every INDEX.md only lists files that exist
- [ ] Relative paths resolve correctly from their source file
- [ ] No orphaned files (files that exist but aren't referenced anywhere)

## Related Issues

- [structure-problems.md](structure-problems.md) - How to organize files to minimize broken links
