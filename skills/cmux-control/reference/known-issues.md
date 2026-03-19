# Known Issues & Gotchas

## Terminal Issues

### `read-screen --surface` fails with "Surface is not a terminal"

**Problem:** `cmux read-screen --surface surface:N` returns `Error: invalid_params: Surface is not a terminal` even when the surface IS a terminal (confirmed via `surface-health`).

**Workaround:** Always use `--workspace` instead of `--surface` for `read-screen`:
```bash
# BAD — often fails
cmux read-screen --surface surface:N --lines 30

# GOOD — always works
cmux read-screen --workspace workspace:N --lines 30
```

This also applies to `capture-pane` (which is an alias for `read-screen`).

Note: `send` and `send-key` work fine with either `--surface` or `--workspace`.

### `new-workspace` doesn't return the surface ref

**Problem:** `cmux new-workspace` only returns `OK workspace:N`. You need the surface ref to send commands or read the screen.

**Workaround:** Use `tree` to find the surface:
```bash
cmux new-workspace --cwd /path
# Returns: OK workspace:N

cmux tree --workspace workspace:N
# Shows: surface:M [terminal] ...
# Now use workspace:N for read-screen/send, or surface:M for browser commands
```

Or just use `--workspace` for `send`/`send-key`/`read-screen`, which resolves to the focused surface automatically.

### `send-key` only supports a limited set of key names

**Supported keys:**
- `Enter` (or `return`)
- `Tab`
- `Escape`
- `Backspace`
- `Ctrl-a` through `Ctrl-z` (e.g., `Ctrl-c`, `Ctrl-d`, `Ctrl-l`)
- `Ctrl+a` through `Ctrl+z` (plus sign also works)

**NOT supported** (will error "Unknown key"):
- Arrow keys: `Up`, `Down`, `Left`, `Right`, `ArrowUp`, etc.
- Function keys: `F1`-`F12`
- `Home`, `End`, `PageUp`, `PageDown`, `Delete`, `Space`
- Single characters: `q`, `j`, `k`, etc.
- Modified keys: `Shift-Tab`, `Alt-f`, etc.

**Workaround for unsupported keys:**

For single characters (useful in TUIs like vim, htop, etc.):
```bash
# Use send instead of send-key
cmux send --workspace workspace:N "q"
cmux send --workspace workspace:N "j"
```

For arrow key equivalents, use Ctrl key combos:
```bash
cmux send-key --workspace workspace:N Ctrl-p  # Up (in many shells/TUIs)
cmux send-key --workspace workspace:N Ctrl-n  # Down
cmux send-key --workspace workspace:N Ctrl-b  # Left
cmux send-key --workspace workspace:N Ctrl-f  # Right
cmux send-key --workspace workspace:N Ctrl-a  # Home (beginning of line)
cmux send-key --workspace workspace:N Ctrl-e  # End (end of line)
```

### `\n` in send text is interpreted as a literal newline

**Problem:** `cmux send --workspace workspace:N "echo line1\nline2"` will type `echo line1`, press Enter (executing the partial command), then type `line2`.

**Workaround:** If you need literal `\n` in your text, escape it:
```bash
cmux send --workspace workspace:N 'echo "line1\\nline2"'
```

### Shell expansion in send text

**Problem:** If you call `cmux send` with double quotes from your shell, variables like `$HOME` get expanded by YOUR shell before cmux receives the text.

**Workaround:** Use single quotes in your shell to pass text literally:
```bash
# BAD — $HOME is expanded by your shell
cmux send --workspace workspace:N "echo $HOME"

# GOOD — $HOME is passed literally to the remote terminal
cmux send --workspace workspace:N 'echo $HOME'
```

## Browser Issues

### Browser `tab` commands are unreliable

**Problem:** `browser tab new`, `browser tab list`, and `browser tab switch` accept commands without error but don't work as expected — `tab list` returns no data, `tab switch` doesn't change the active URL.

**Workaround:** Use separate cmux surfaces instead of browser-level tabs:
```bash
# Instead of browser tabs, create separate browser surfaces in the same pane
cmux new-surface --type browser --pane pane:N --url "https://site1.com"
# Returns surface:A
cmux new-surface --type browser --pane pane:N --url "https://site2.com"
# Returns surface:B

# Switch between them by focusing
cmux close-surface --surface surface:A  # close when done
```

Or just navigate the same surface:
```bash
cmux browser navigate "https://different-url.com" --surface surface:N
```

### `--compact` snapshot returns unusable text

**Problem:** `browser snapshot --compact` strips refs and often produces a truncated, garbled text blob on content-heavy pages.

**Workaround:**
- To **read content**: use `browser eval "document.body.innerText.substring(0, 3000)"`
- To **find interactive elements**: use `browser snapshot --interactive`
- Never use `--compact` for either purpose

### Refs are ephemeral

**Problem:** Element refs like `[ref=e42]` from `browser snapshot --interactive` change on every DOM update. JS-heavy sites (React, SPAs, sites with ads) may re-render between your snapshot and your click, invalidating the ref.

**Workaround:** See reference/browser-troubleshooting.md for the full escalation ladder. Quick version:
1. Use CSS selectors when possible
2. If you must use refs, snapshot + click immediately (no sleep between)
3. If still failing, use `browser eval "document.querySelector(...).click()"`
