# Terminal Operations — Full Reference

## Creating Terminals

### New Workspace (new project context)
```bash
# Basic — opens shell in directory
xaku new-workspace --cwd /path/to/dir
# Returns: workspace:N

# With a startup command
xaku new-workspace --cwd /path --command "python3 -m http.server 8000"
# Returns: workspace:N

# With a custom name
xaku new-workspace --cwd /path --name "dev-server"
# Returns: workspace:N
```
The workspace gets a terminal surface automatically. `--command` runs in the user's shell, so the command executes after shell init (.zshrc etc).

### New Surface (add terminal to existing workspace)
```bash
xaku new-surface --workspace workspace:N
# Returns: surface:N
```
Adds another terminal session to the workspace.

### New Pane (alias for new-surface)
```bash
xaku new-pane --workspace workspace:N
# Returns: surface:N
```
Note: xaku is headless — `--direction` is accepted for compatibility but has no visual effect.

## Sending Input to Terminals

### Send Text
```bash
xaku send --workspace workspace:N "echo hello"
```
**This types the text but does NOT press Enter.** The text appears in the terminal's input line.

**Special characters:** Quotes, pipes, backticks all pass through correctly. However:
- `$VAR` may be expanded by YOUR shell if you use double quotes. Use single quotes to pass text literally.

### Send Key
```bash
xaku send-key --workspace workspace:N Enter
```

**Supported keys:**
- `Enter` (or `Return`)
- `Tab`
- `Escape` (or `Esc`)
- `Backspace`
- `Space`
- `Up`, `Down`, `Left`, `Right` (arrow keys)
- `Ctrl-a` through `Ctrl-z` (e.g., `Ctrl-c`, `Ctrl-d`, `Ctrl-l`)

**For single characters** (useful in TUIs like vim, htop):
```bash
# Use send instead of send-key for single chars
xaku send --workspace workspace:N "q"
xaku send --workspace workspace:N "j"
```

### Complete Pattern: Run a Command
```bash
xaku send --workspace workspace:N "npm test"
xaku send-key --workspace workspace:N Enter
```
Always use this two-step pattern. Never assume Enter is implied.

### Interrupt a Running Process
```bash
xaku send-key --workspace workspace:N Ctrl-c
```

### Clear the Screen
```bash
xaku send-key --workspace workspace:N Ctrl-l
```

## Reading Terminal Output

### Read Current Screen
```bash
xaku read-screen --workspace workspace:N --lines 30
```
Returns the last N non-blank lines on the terminal.

### Read with Scrollback
```bash
xaku read-screen --workspace workspace:N --scrollback --lines 200
```
Includes history that has scrolled off screen.

### Capture Pane (tmux-compatible alias)
```bash
xaku capture-pane --workspace workspace:N --scrollback --lines 100
```
Same as `read-screen`.

### Reading by Surface
```bash
# Target a specific surface directly (works in xaku, unlike cmux)
xaku read-screen --surface surface:N --lines 30
```

## Managing Terminals

### Close a Surface (single terminal)
```bash
xaku close-surface --surface surface:N
```

### Close an Entire Workspace
```bash
xaku close-workspace --workspace workspace:N
```

## Workspace Management

### Rename
```bash
xaku rename-workspace --workspace workspace:N "My Project"
```

### Select (switch active workspace)
```bash
xaku select-workspace --workspace workspace:N
```

### List All
```bash
xaku list-workspaces
```

### Tree View
```bash
xaku tree                          # All workspaces
xaku tree --workspace workspace:N  # Specific workspace
```

### Current
```bash
xaku current-workspace
```

## Daemon Management

```bash
xaku ping           # Quick liveness check
xaku daemon status  # Check if running
xaku daemon stop    # Stop daemon (all sessions terminated)
```

The daemon auto-starts on first command — no manual startup needed.
