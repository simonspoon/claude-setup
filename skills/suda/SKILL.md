---
name: suda
description: Manage structured memories and project registry using the suda CLI. Use for storing user preferences, feedback, project context, and reference material. Triggers on remember this, store memory, recall, what do you know about me, project registry, memory management.
---

# suda — Structured Memory Management

Store and recall structured memories in a SQLite database via the `suda` CLI. Memories are typed (user, feedback, project, reference) and searchable via FTS5.

## Prerequisites

- `suda` must be installed and on PATH
- Database lives at `~/.suda/suda.db` (override with `SUDA_HOME` env var)

## Setup

Suda context is loaded automatically at session start by the `suda-context.sh` UserPromptSubmit hook, which injects relevant memories per-prompt. No manual skill invocation is needed.

## When to Use

Memory capture is **automatic** — the suda-observer hook analyzes each conversation exchange and stores worthy items without manual intervention. You do not need to store memories during normal conversation. The system uses an **append-only model**: new memories are always appended, never deduplicated inline. A separate consolidation agent handles dedup/merging offline.

Use this skill for **manual operations only**:

### Recall and search
```bash
suda recall "commit preferences"              # FTS5 search
suda recall --project myapp --json             # all memories for a project
```

### Forget / clean up
```bash
suda forget 42                                # remove a specific memory
```

### Project registry management
```bash
suda projects                                  # list all projects
suda project add myapp /path/to/myapp --description "Main web app"
```

### Export / Import
```bash
suda export --project myapp --format json
suda import memories.json
```

## Commands

### Store a memory
```bash
suda store --type feedback --name "prefers-small-commits" "User wants atomic commits, one concern per commit"
suda store --type project --name "api-redesign-deadline" --project myapp --description "Hard deadline" "API v2 must ship by March 30"
echo "long content" | suda store --type reference --name "deploy-runbook" --stdin
```

### Recall memories
```bash
suda recall "commit preferences"              # FTS5 search
suda recall --project myapp --json             # all memories for a project
suda recall --type user --limit 5 --json       # recent user memories
suda recall                                    # list recent (no query)
```

### Update a memory
```bash
suda update 42 --content "Updated preference: user now prefers conventional commits"
suda update 42 --name "new-name" --description "new desc"
```

### Forget a memory
```bash
suda forget 42
```

### Project registry
```bash
suda projects                                  # list all projects
suda project add myapp /path/to/myapp --description "Main web app"
suda project show myapp
suda project remove myapp
```

### Export / Import
```bash
suda export --project myapp --format json      # export as JSON
suda export --type feedback --format md         # export as Markdown
suda import memories.json                      # import from JSON
```

## Key Rules

1. **Do not manually store memories.** The suda-observer hook handles memory capture automatically. Only use `suda store` if the user explicitly asks you to remember something.
2. **Append-only model.** New memories are appended, not deduplicated inline. A future consolidation agent merges and cleans up offline. Do not call `suda update` or check for duplicates before storing.
3. **Use `--json` for programmatic reads.** Parse JSON output when you need to act on results. Use human-readable output when displaying to the user.
4. **Scope to projects.** Use `--project` when recalling project-specific memories to keep context clean.
5. **Keep memory names descriptive and kebab-case.** Names like `prefers-rust-over-python` or `api-v2-architecture-decision` are searchable and self-documenting.
