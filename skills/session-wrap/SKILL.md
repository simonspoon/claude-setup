---
name: session-wrap
description: End-of-session skill that commits dirty repos and optionally improves skills. Memory capture is handled automatically by hooks — this skill focuses on clean handoff.
---

# Session Wrap

End-of-session cleanup. Commits outstanding work and optionally improves skills if requested. Memory capture (reflection, learnings, feedback) is handled automatically by the suda-observer hook — this skill does not duplicate that work.

## When to Invoke

- User signals end of session ("that's all", "wrap up", "goodbye", etc.)
- User explicitly asks to wrap or reflect
- Significant milestone and session is winding down

## Phase 1: Uncommitted Changes

Check every repo touched this session for dirty state.

```bash
for repo in <repos-touched>; do
  echo "=== $repo ==="
  git -C "$repo" status --porcelain
done
```

For each dirty repo: commit and push using `/swe-team:git-commit`.

## Phase 2: Skill Improvements (only if requested)

Only run this phase if the user explicitly asks for skill improvements. For each issue:

1. Read the skill's SKILL.md
2. Categorize: structure, clarity, guardrails, templates, or critical requirements
3. Apply the fix directly — keep SKILL.md focused (~100 lines)
4. Validate links and frontmatter

Skip this phase entirely if no skill issues were found. Don't force it.

## Phase 3: Confirm

Tell the user:
- Repos committed/pushed (if any)
- Skill improvements applied (if any)

Keep it brief.

## Rules

1. **Don't store memories.** The suda-observer hook handles memory capture automatically.
2. **Skill improvements are opt-in.** Only run Phase 2 if the user explicitly requests it.
