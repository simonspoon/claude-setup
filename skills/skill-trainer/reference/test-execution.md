# Phase 2: Self-Test Execution

## Goal

Run each test scenario yourself, discover where the skill's documentation is wrong or misleading, and fix it.

## Step-by-Step

### 1. Pre-flight

Before running tests:
- Verify any prerequisites the skill requires (services running, tools installed, etc.)
- Create a scratch workspace/directory if needed for test artifacts
- Note the current state of the skill docs (so you can track what you change)

### 2. Run Each Test

For each test scenario from Phase 1:

**Execute the documented steps exactly as written.** Do NOT improvise or use your own knowledge — you are testing whether the DOCS lead to success, not whether YOU can make it work.

For each step, record:
- The exact command you ran
- The exact output you got
- Whether it matched the documented expectation
- If it failed: what went wrong and why

**Important:** When a step fails, try to follow the skill's documented recovery/troubleshooting guidance FIRST. Only use your own knowledge if the skill provides no guidance for the failure.

### 3. Record Results

For each test, assign a result:

- **PASS** — all steps worked as documented, output matched expectations
- **PASS (with notes)** — worked, but documentation was slightly misleading or could be clearer
- **FAIL (doc issue)** — failed because the documentation was wrong, incomplete, or misleading
- **FAIL (tool issue)** — failed because the underlying tool has a bug/limitation. Docs should warn about this.
- **FAIL (unclear)** — failed and it's not obvious why. Needs investigation.

### 4. Categorize Failures

For each failure, determine the root cause. Read reference/failure-analysis.md for the full taxonomy. Quick version:

| Failure Type | Example | Fix |
|---|---|---|
| Wrong command/flag | Docs say `--flag` but tool expects `--other-flag` | Fix the command in docs |
| Wrong key/value | Docs say `C-c` but tool expects `Ctrl-c` | Fix the value in docs |
| Missing step | Docs skip a necessary step (e.g., "wait for load") | Add the missing step |
| Missing warning | Docs don't mention a gotcha that causes failure | Add to known-issues or gotchas section |
| Wrong claim | Docs say "X works" but it doesn't | Remove claim, document the real behavior |
| Unclear instruction | Docs are ambiguous, leading to wrong action | Rewrite for clarity |
| Missing recovery | Something fails and docs don't say what to do | Add troubleshooting guidance |

### 5. Apply Fixes

For each doc issue found:
1. Read the relevant file
2. Make the minimal fix needed
3. Note what you changed (for the training report)

**Fix rules:**
- Fix the docs, not the underlying tool
- Prefer adding warnings/caveats over removing documentation
- If a feature is unreliable, say so explicitly (don't just remove it)
- Keep fixes minimal — don't refactor the whole file while you're in there

### 6. Re-run Failed Tests (Round 2)

After applying fixes:
1. Re-run ONLY the tests that failed in Round 1
2. Record results again
3. If still failing, apply one more round of fixes

**Stop after Round 2.** If a test still fails after 2 fix-and-retest cycles:
- Note it as a remaining issue
- Explain why it's still failing
- Suggest whether it's fixable (doc issue) or a limitation (tool issue)

### 7. Check for False Passes

**If all tests pass Round 1, be suspicious.** Ask yourself for each test:
- Did I follow ONLY what the docs said, or did I fill in gaps with my own knowledge?
- Was there any step where the docs were ambiguous and I chose the right interpretation because I already knew the tool?
- Would a weaker model (Haiku) have made the same choices?

For each test where you filled a doc gap with your own knowledge, mark it as **PASS (doc gap)** and note what the docs should have said. These gaps are real findings — a weaker model will fail where you silently succeeded.

### 8. Summary

Produce a results table listing EVERY test (do NOT summarize as "all passed"):

```
| # | Test | Round 1 | Issue | Fix Applied | Round 2 |
|---|------|---------|-------|-------------|---------|
| 1 | Basic query | PASS | — | — | — |
| 2 | No results | FAIL (doc) | Wrong flag name | Fixed --flag to --other | PASS |
| 3 | Multi-step | FAIL (tool) | Tool crashes on empty input | Added warning | N/A (tool issue) |
| 4 | Filtered list | PASS (doc gap) | Docs don't specify JSON output format | Added example output | — |
```

## Common Pitfalls

### Testing your knowledge, not the docs
❌ "I know this command needs `--workspace`, so I'll use that even though the docs say `--surface`"
✅ "The docs say `--surface`, so I'll use `--surface`. If it fails, that's a doc bug to fix."

### Over-fixing
❌ Rewriting the entire reference file because one example was wrong
✅ Fixing the one wrong example and moving on

### Infinite loops
❌ Running 5 rounds of fix-and-retest on the same test
✅ 2 rounds max. If it's still broken, note it and move on.

### Not cleaning up
❌ Leaving 10 test workspaces/browsers open
✅ Each test cleans up after itself. Verify with `cmux tree --all` at the end.
