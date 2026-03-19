---
name: cmux-control
description: Control terminals and browsers via the cmux CLI. Use when you need to spawn interactive terminals, start Claude Code sessions, run REPLs/TUIs, open web browsers for research or testing, read terminal output, send commands, navigate web pages, click elements, or interact with any cmux-managed surface. Triggers on cmux, terminal control, browser automation, open browser, spawn terminal, interactive shell, screen reading, web testing.
---

# cmux Control — Terminal & Browser Automation

Control cmux terminals and embedded browsers from Claude Code. Use this skill to spin up shells, run commands in other terminals, start Claude Code sessions, open and interact with web browsers, and read results back.

## Prerequisites

- cmux must be running (verify with `cmux ping` — expect `PONG`)
- You are likely already inside a cmux terminal (check `cmux identify`)

## Key Concepts

**Hierarchy:** Window > Workspace > Pane > Surface (tab)

- **Workspace** = a named tab group (like a project). You work inside one.
- **Pane** = a split region within a workspace (left/right/up/down).
- **Surface** = a single terminal or browser tab inside a pane.
- **Refs** = short identifiers like `workspace:1`, `pane:3`, `surface:5`.

**Environment variables** (auto-set in cmux terminals):
- `CMUX_WORKSPACE_ID` — default `--workspace` for all commands
- `CMUX_SURFACE_ID` — default `--surface` for all commands

**Parsing output refs:** Creation commands return refs you must save:
- `cmux new-workspace` returns `OK workspace:N` (no surface ref — use `cmux tree --workspace workspace:N` to find the surface)
- `cmux new-pane` returns `OK surface:N pane:N workspace:N`
- `cmux new-surface` returns `OK surface:N pane:N workspace:N`

## Quick Reference

### Orientation — Where Am I?

```bash
cmux identify              # Show caller's workspace/pane/surface
cmux tree                  # Show current workspace layout
cmux tree --all            # Show ALL workspaces
cmux list-workspaces       # List all workspace names and refs
cmux find-window "query"   # Search workspaces by name
cmux find-window --content "query"  # Search by terminal content
```

### Terminal Operations

Read reference/terminal-operations.md for full details.

```bash
# Create a new workspace with a shell
cmux new-workspace --cwd /path/to/project
# Returns: OK workspace:N  (use tree to find surface ref)

# Create a workspace and run a command immediately
cmux new-workspace --cwd /path --command "npm run dev"

# Split current pane to add a terminal beside it
cmux new-pane --type terminal --direction right
# Returns: OK surface:N pane:N workspace:N

# Send a command to a terminal (does NOT press Enter)
cmux send --workspace workspace:N "ls -la"
# Press Enter to execute it
cmux send-key --workspace workspace:N Enter

# Read what's on screen (ALWAYS use --workspace, not --surface)
cmux read-screen --workspace workspace:N --lines 30

# Read with scrollback history
cmux read-screen --workspace workspace:N --scrollback --lines 100
```

### Browser Operations

Read reference/browser-operations.md for full details. Read reference/browser-troubleshooting.md when things go wrong.

```bash
# Open a browser pane
cmux new-pane --type browser --url "https://example.com"

# Navigate an existing browser surface
cmux browser navigate "https://url" --surface surface:N

# Wait for page to load
cmux browser wait --surface surface:N --load-state complete

# Read page content (BEST method — use eval for reliable text extraction)
cmux browser eval "document.body.innerText.substring(0, 3000)" --surface surface:N

# Get structured view with clickable refs (for interaction, not reading)
cmux browser snapshot --surface surface:N --interactive

# Click by CSS selector (preferred) or by ref from snapshot
cmux browser click "button.submit" --surface surface:N
cmux browser click "[ref=e42]" --surface surface:N

# Type into an input field
cmux browser fill "input[name=search]" "query text" --surface surface:N

# Get page title / URL
cmux browser get title --surface surface:N
cmux browser url --surface surface:N
```

### Other Tools

```bash
# Open a markdown file in a formatted viewer panel (live-reloading)
cmux markdown open /path/to/file.md --workspace workspace:N
```

### Cleanup

```bash
cmux close-surface --surface surface:N    # Close one tab
cmux close-workspace --workspace workspace:N  # Close entire workspace
```

## Common Workflows

Read reference/common-workflows.md for step-by-step patterns including:
- Starting a dev server and testing it in a browser
- Running Claude Code in a new terminal
- Interactive REPL testing
- Web research

## Important Rules

1. **Always save refs** from creation commands. `new-workspace` only returns `workspace:N` — use `cmux tree --workspace workspace:N` to find the surface ref.
2. **`send` does NOT press Enter.** Always follow `cmux send` with `cmux send-key ... Enter`.
3. **Use `--workspace` for `read-screen` and `send`/`send-key`.** Using `--surface` for `read-screen` often fails with "Surface is not a terminal" even on terminal surfaces. Always prefer `--workspace`.
4. **Prefer direct URL navigation** over interacting with search UIs. If you know the site supports URL params (e.g., `weather.com/weather/today/l/27310`), navigate directly — it's faster and more reliable than filling forms on JS-heavy sites.
5. **Use `browser eval` to read page content.** `browser snapshot` is for finding interactive elements, NOT for reading text. Use `cmux browser eval "document.body.innerText.substring(0, 3000)"` or target specific selectors.
6. **Click by CSS selector first, refs second.** CSS selectors (e.g., `button.submit`) are stable across page updates. Refs (`[ref=eN]`) are ephemeral — they change on every DOM update. Only use refs when no good CSS selector exists, and always get a fresh `snapshot --interactive` immediately before clicking.
7. **Wait for pages to load** before interacting: `cmux browser wait --load-state complete`.
8. **Clean up** workspaces you create when done — don't leave orphaned terminals/browsers.
9. **If ref clicks fail**, read reference/browser-troubleshooting.md for recovery strategies.

## Known Issues & Gotchas

Read reference/known-issues.md for details. Quick summary:

- **`read-screen --surface` fails** — always use `--workspace` instead
- **`new-workspace` doesn't return surface ref** — use `tree` to find it
- **`send-key` has limited key names** — only `Enter`, `Tab`, `Escape`, `Backspace`, `Ctrl-*` work. For single characters (`q`, `j`, etc.) and arrow keys, use `cmux send` instead
- **`\n` in `send` text is interpreted as a newline** — cmux will split the input into multiple lines
- **Browser `tab new`/`tab list`/`tab switch` are unreliable** — use separate surfaces (`new-surface --type browser`) instead of browser-level tabs
- **`--compact` snapshot is useless for reading** — use `browser eval` to read page content
