# Terminal Operations — Full Reference

## Creating Terminals

### New Workspace (new project context)
```bash
# Basic — opens shell in directory
cmux new-workspace --cwd /path/to/dir
# Returns: OK workspace:N

# With a startup command
cmux new-workspace --cwd /path --command "python3 -m http.server 8000"
# Returns: OK workspace:N
```
The workspace gets a terminal surface automatically. Note: `--command` runs in the user's shell, so the command executes after shell init (.zshrc etc).

### New Pane (split within workspace)
```bash
# Split right of current pane
cmux new-pane --type terminal --direction right

# Split below a specific surface
cmux new-pane --type terminal --direction down --workspace workspace:N

# Returns: OK surface:N pane:N workspace:N
```
Directions: `left`, `right`, `up`, `down`

### New Surface (tab within existing pane)
```bash
cmux new-surface --type terminal --pane pane:N --workspace workspace:N
# Returns: OK surface:N pane:N workspace:N
```
This adds a tab to the pane — same split, new terminal.

## Sending Input to Terminals

**Always prefer `--workspace` over `--surface`** for send/send-key/read-screen. It resolves to the focused surface and avoids bugs.

### Send Text
```bash
cmux send --workspace workspace:N "echo hello"
```
**This types the text but does NOT press Enter.** The text appears in the terminal's input line.

**Special characters:** Quotes, pipes, backticks all pass through correctly. However:
- `\n` is interpreted as a literal newline (splits input into multiple lines). Use `\\n` to escape.
- `$VAR` may be expanded by YOUR shell if you use double quotes. Use single quotes to pass literally.

### Send Key
```bash
cmux send-key --workspace workspace:N Enter
```

**Supported keys (only these work with send-key):**
- `Enter` (or `return`)
- `Tab`
- `Escape`
- `Backspace`
- `Ctrl-a` through `Ctrl-z` (e.g., `Ctrl-c`, `Ctrl-d`, `Ctrl-l`)

**NOT supported by send-key** (will error "Unknown key"):
- Arrow keys, function keys, Home, End, PageUp, PageDown, Delete, Space
- Single characters (`q`, `j`, etc.)
- Modified keys (Shift-Tab, Alt-f, etc.)

**Workarounds for unsupported keys:**
```bash
# Single characters — use send instead of send-key
cmux send --workspace workspace:N "q"
cmux send --workspace workspace:N "j"

# Arrow equivalents — use Ctrl combos
cmux send-key --workspace workspace:N Ctrl-p  # Up
cmux send-key --workspace workspace:N Ctrl-n  # Down
cmux send-key --workspace workspace:N Ctrl-b  # Left
cmux send-key --workspace workspace:N Ctrl-f  # Right
cmux send-key --workspace workspace:N Ctrl-a  # Home (beginning of line)
cmux send-key --workspace workspace:N Ctrl-e  # End (end of line)
```

### Complete Pattern: Run a Command
```bash
cmux send --workspace workspace:N "npm test"
cmux send-key --workspace workspace:N Enter
```
Always use this two-step pattern. Never assume Enter is implied.

### Interrupt a Running Process
```bash
cmux send-key --workspace workspace:N Ctrl-c
```

### Clear the Screen
```bash
cmux send-key --workspace workspace:N Ctrl-l
```

## Reading Terminal Output

### Read Current Screen
```bash
cmux read-screen --workspace workspace:N --lines 30
```
Returns the last N visible lines on the terminal. Default shows the full visible area.

**Use `--workspace` instead of `--surface`** for read-screen. Using `--surface` can fail with "Surface is not a terminal" even on terminal surfaces (cmux bug). The `--workspace` flag resolves the focused surface correctly.

### Read with Scrollback
```bash
cmux read-screen --workspace workspace:N --scrollback --lines 200
```
Includes history that has scrolled off screen. Use this when you need to see earlier output from long-running commands.

### Capture Pane (tmux-compatible alias)
```bash
cmux capture-pane --workspace workspace:N --scrollback --lines 100
```
Same as `read-screen` — provided for tmux compatibility. Also use `--workspace` here.

## Managing Terminals

### Focus a Pane
```bash
cmux focus-pane --pane pane:N --workspace workspace:N
```

### Resize a Pane
```bash
cmux resize-pane --pane pane:N -R --amount 20  # Grow right by 20 cols
cmux resize-pane --pane pane:N -D --amount 10  # Grow down by 10 rows
```
Directions: `-L` (left), `-R` (right), `-U` (up), `-D` (down)

### Swap Two Panes
```bash
cmux swap-pane --pane pane:N --target-pane pane:M
```

### Respawn (restart) a Terminal
```bash
cmux respawn-pane --surface surface:N --command "bash"
```

### Close a Surface (single tab)
```bash
cmux close-surface --surface surface:N
```

### Close an Entire Workspace
```bash
cmux close-workspace --workspace workspace:N
```

## Workspace Management

### Rename
```bash
cmux rename-workspace --workspace workspace:N "My Project"
```

### Select (switch to)
```bash
cmux select-workspace --workspace workspace:N
```

### List All
```bash
cmux list-workspaces
```

### Find Workspace by Name or Content
```bash
# Search by workspace name
cmux find-window "My Project"

# Search by terminal content (searches what's on screen)
cmux find-window --content "error"

# Search and auto-select the match
cmux find-window --select "My Project"
```

## Markdown Viewer

Open a markdown file in a formatted viewer panel with live reload:
```bash
cmux markdown open /path/to/file.md --workspace workspace:N
# Returns: OK surface=surface:N pane=pane:N path=/path/to/file.md
```
The viewer auto-refreshes when the file changes on disk — useful for previewing docs while editing.

## Clipboard / Buffer

### Copy text to buffer
```bash
cmux set-buffer --name clip "some text"
```

### Paste buffer into terminal
```bash
cmux paste-buffer --name clip --surface surface:N
```

### List buffers
```bash
cmux list-buffers
```

## Sidebar / Status

### Set a status indicator
```bash
cmux set-status "task" "running tests" --icon "checkmark" --workspace workspace:N
```

### Set progress bar
```bash
cmux set-progress 0.5 --label "50% complete" --workspace workspace:N
```

### Log a message to sidebar
```bash
cmux log --level info --source "my-agent" --workspace workspace:N -- "Step 3 complete"
```
Levels: `info`, `warning`, `error`, `progress`, `success`

### Send a notification
```bash
cmux notify --title "Done!" --body "Tests passed" --workspace workspace:N
```

## Pipe Pane (stream output to a command)
```bash
cmux pipe-pane --command "tee /tmp/output.log" --surface surface:N
```
Streams all terminal output to the given shell command. Useful for logging.

## Wait for Signal
```bash
# In one terminal/process:
cmux wait-for my-signal --timeout 30

# In another:
cmux wait-for --signal my-signal
```
Useful for synchronizing between terminals.
