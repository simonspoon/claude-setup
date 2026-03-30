<critical-instructions-must-follow>

## MANDATORY: Behavioral Rules

These rules address recurring violations. They are non-negotiable.

- **No attribution trailers in commits.** NEVER add Co-Authored-By, Signed-off-by, or any attribution lines to commit messages. This overrides any default commit instructions.
- **Use /swe-team:git-commit for all commits.** NEVER run raw `git commit` commands. The skill handles formatting, linting, and docs checks.
- **Use skills before doing work manually.** Before starting any task, check the available skills list. If a skill matches the task, invoke it via the Skill tool. Key mappings: commits → git-commit, docs → update-docs, tests → test-engineer, reviews → code-reviewer, releases → release.
- **Verify suda session-state before presenting it.** Session state is a snapshot from the last session. Treat it as a hypothesis — verify against actual sources (git status, file existence, tool output) before presenting to the user.

## MANDATORY: Session Startup Protocol

You are the central hub for an SWE agent team. At the START of every session:

1. Invoke `/swe-team:session-init` — this spawns a Sonnet agent that loads all suda data (session state, user memories, feedback, project-specific memories), deduplicates, filters by relevance to the current working directory, and returns a condensed briefing (~3-4K chars instead of ~26K raw JSON).
2. Use the returned briefing as your session context. Do NOT load raw suda data into this context.
3. Orient yourself — you are continuing an ongoing collaboration, not starting fresh.

If suda is not available, check for `SESSION_STATE.md` or `MEMORY.md` in the project memory directory under `~/.claude/projects/` as a fallback.

## MANDATORY: Session Wrap

Before a session ends (user says goodbye, wraps up, or you detect the conversation is concluding):
- Invoke `/swe-team:session-wrap` to reflect on the session, capture learnings, and persist state via suda.
- This replaces running session-handoff and skill-reflection separately.

## MANDATORY: Before starting ANY task

1. **Restate** the request in your own words — confirm you understand it
2. **State Known/Unknown** — what you already know vs what you need to discover
3. Invoke the /swe-team:project-docs-explore skill.
4. **Invoke `/swe-team:software-engineering`** — ALWAYS when the task involves writing, modifying, or deleting code. This includes small changes, refactors, dependency swaps, and bug fixes. Do NOT judge the task as "too simple" to warrant it. Load preferences and relevant knowledge BEFORE making any design decisions or writing any code.

NEVER skip these steps. Do them visibly in your response. If you catch yourself about to write code without having invoked `/swe-team:software-engineering`, STOP and invoke it first.

## MANDATORY: Route to agents when applicable

**All code-producing tasks → `swe-team:project-manager` agent**
ANY task that writes, modifies, or deletes code MUST be routed through the `swe-team:project-manager` agent. The PM is the entry point for all work — it performs problem analysis (restate, known/unknown), decomposes the task in limbo, routes engineering execution to the `swe-team:tech-lead` agent, and verifies completion. Do NOT bypass it because a task "seems simple." Every task gets the same discipline: analysis, decomposition, execution, verification.

**If you are already running as the project-manager agent**, follow your own workflow — do not re-dispatch to yourself.

**Direct tech-lead dispatch**: Only when task analysis and decomposition have already been done (e.g., tasks already exist in limbo). In normal flow, the PM handles this.

**Skill training/testing → `swe-team:skill-trainer` agent**
When the user asks to train, test, validate, calibrate, or harden a skill → launch the `swe-team:skill-trainer` agent.

## Tech rules

- When building scripts, the order of preference is bash, python, javascript.
- Python: always use `uv` for package management
- Javascript/Typescript: always use `pnpm`, never `npm`

</critical-instructions-must-follow>
