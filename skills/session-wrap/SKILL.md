---
name: session-wrap
description: End-of-session skill that commits dirty repos, persists session state, and optionally improves skills. Memory capture is handled automatically by hooks — this skill focuses on clean handoff.
---

# Session Wrap

End-of-session cleanup. Commits outstanding work, persists session state for the next conversation, and optionally improves skills if requested. Memory capture (reflection, learnings, feedback) is handled automatically by the suda-observer hook — this skill does not duplicate that work.

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

## Phase 3: Session Handoff

Read existing session state, merge new context, and persist.

```bash
# Read current state
suda state get session-state 2>/dev/null

# Update with merged context
suda state set session-state --stdin <<'EOF'
<merged session state — keep last 3 sessions in Recent, update Priorities>
EOF
```

Session state must include:
- **What was accomplished** (specific, not vague)
- **Projects touched** and their current state (branch, commit status, version)
- **Key decisions** with reasoning
- **Current priorities** (updated if changed)
- **Open questions** (new or carried forward)

**Merge, don't replace.** Read existing state first. Carry forward active project info and priorities that haven't changed.

## Phase 4: Confirm

Tell the user:
- Repos committed/pushed (if any)
- Skill improvements applied (if any)
- Session state persisted

Keep it brief.

## Rules

1. **Be specific.** Session state should capture concrete accomplishments and decisions, not vague summaries.
2. **Merge, don't replace** session state.
3. **Don't store memories.** The suda-observer hook handles memory capture automatically. This skill only persists session state.
4. **Skill improvements are opt-in.** Only run Phase 2 if the user explicitly requests it.
