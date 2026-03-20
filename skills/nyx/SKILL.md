---
name: nyx
description: Search past Claude Code conversation history using the nyx CLI. Use when recalling what was discussed, finding prior decisions, locating code patterns from past sessions, or answering "did we already..." questions. Triggers on conversation history, past sessions, what did we discuss, search conversations, recall, find in history, previous session.
---

# nyx — Conversation History Search

Search and browse past Claude Code conversations indexed by the `nyx` CLI.

## Prerequisites

- `nyx` must be installed and on PATH (`cargo install --path ~/Documents/Development/opensource/nyx`)
- Index must be built: run `nyx index` if status shows stale data

## When to Use

- User asks "did we discuss X?", "when did we decide Y?", "find where we talked about Z"
- You need to recall prior decisions, code patterns, or context from past sessions
- User references a past conversation by topic or timeframe
- Exploring what work has been done on a project

## Commands

### Search conversations
```bash
nyx search "query"                        # full-text search
nyx search "query" --project claudehub    # scope to project
nyx search "query" --last 7d              # last 7 days only
nyx search "query" --project X --last 30d # combine filters
```

Results are grouped by conversation with highlighted matches.

### List all conversations
```bash
nyx list                  # human-readable table (slug, date, project)
nyx list --json           # JSON array with timestamps and session IDs
```

### Show a conversation transcript
```bash
nyx show luminous-toasting-ember    # by slug
nyx show abc123                     # by session ID prefix
nyx show luminous-toasting-ember --json  # full transcript as JSON
```

Use `--json` to get structured message data (role, content, timestamp) for programmatic extraction.

### Check index status
```bash
nyx status                # human-readable summary
nyx status --json         # JSON with counts, project list, sizes
```

Shows record count, conversation count, date range, and top projects. Run `nyx index` if data looks stale.

### Update the index
```bash
nyx index
```

Incremental — only re-indexes changed files.

## Workflow

1. **Always check status first** if unsure whether the index is current: `nyx status`
2. **If index is stale** (last updated > 1 day ago or missing recent conversations): run `nyx index`
3. **Search** with the most specific query possible. Use `--project` and `--last` filters to narrow results.
4. **Show** specific conversations to read the full transcript when search results indicate a relevant conversation.
5. **Use `--json`** when you need to parse output programmatically or extract specific fields. All commands support `--json`.

## Tips

- Search queries use SQLite FTS5 — supports AND, OR, NOT, and phrase matching ("exact phrase")
- Project names come from the directory path and may be truncated for hyphenated names
- Slugs are the unique identifiers shown in search results and list output; some sessions only have ID prefixes (no slug)
- Search results are capped at 100 — use `--project` and `--last` filters to narrow large result sets
- `--json` flag works on all commands: `search`, `list`, `show`, `status`

## Error Behavior

- **Nonexistent slug/ID**: `nyx show bad-slug` exits with error "Conversation not found"
- **Nonexistent project**: `nyx search "q" --project missing` returns "No results found" (exit 0, not an error)
- **Invalid time format**: `nyx search "q" --last bad` exits with error showing expected format (e.g., 7d, 24h, 30d)
- **Empty query**: `nyx search ""` produces an FTS5 syntax error — always provide a non-empty query
