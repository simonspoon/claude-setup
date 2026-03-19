# Common Workflows

Step-by-step patterns for typical cmux tasks.

**Key conventions used in all workflows:**
- Use `--workspace` (not `--surface`) for `send`, `send-key`, and `read-screen`
- `new-workspace` only returns `workspace:N` — use `tree` if you need the surface ref
- `new-pane` returns `surface:N pane:N workspace:N` — save these refs

## 1. Start a Dev Server and Test It in a Browser

```bash
# Step 1: Create workspace for the project
cmux new-workspace --cwd /path/to/project
# Returns: OK workspace:N

# Step 2: Send the dev server command
cmux send --workspace workspace:N "npm run dev"
cmux send-key --workspace workspace:N Enter

# Step 3: Wait a moment for it to start, then read output to find the URL
sleep 3
cmux read-screen --workspace workspace:N --lines 20
# Look for something like "http://localhost:3000"

# Step 4: Open a browser pane next to it
cmux new-pane --type browser --url "http://localhost:3000" --workspace workspace:N
# Returns: OK surface:M pane:P workspace:N

# Step 5: Wait for page load and inspect
cmux browser wait --surface surface:M --load-state complete
cmux browser eval "document.body.innerText.substring(0, 2000)" --surface surface:M
```

## 2. Run Claude Code in a New Terminal

```bash
# Step 1: Create workspace pointed at the project
cmux new-workspace --cwd /path/to/project
# Returns: OK workspace:N

# Step 2: Run claude with a one-shot prompt (simplest approach)
cmux send --workspace workspace:N 'claude -p "explain the architecture of this project"'
cmux send-key --workspace workspace:N Enter

# Step 3: Wait for response (Claude can take a while)
sleep 15
cmux read-screen --workspace workspace:N --scrollback --lines 100

# OR: Start interactive Claude session
cmux send --workspace workspace:N "claude"
cmux send-key --workspace workspace:N Enter
sleep 5
# Then send prompts:
cmux send --workspace workspace:N "explain this codebase"
cmux send-key --workspace workspace:N Enter
```

## 3. Interactive REPL Testing

```bash
# Step 1: Create a terminal with REPL
cmux new-workspace --cwd /path/to/project --command "python3"
# OR for Node: --command "node"
# Returns: OK workspace:N

# Step 2: Wait for REPL to start
sleep 3
cmux read-screen --workspace workspace:N --lines 5

# Step 3: Send REPL commands
cmux send --workspace workspace:N "import json"
cmux send-key --workspace workspace:N Enter
sleep 1
cmux send --workspace workspace:N "json.dumps({'test': True})"
cmux send-key --workspace workspace:N Enter

# Step 4: Read output
sleep 1
cmux read-screen --workspace workspace:N --lines 10

# Step 5: Exit REPL when done
cmux send-key --workspace workspace:N Ctrl-d
```

## 4. Web Research

```bash
# PREFERRED: Navigate directly via URL (skip form interaction)
cmux new-pane --type browser --url "https://www.google.com/search?q=your+query+here"
# Returns: OK surface:N pane:P workspace:W

# Wait for results
sleep 3
cmux browser wait --surface surface:N --load-state complete

# Read results via JS (most reliable)
cmux browser eval "Array.from(document.querySelectorAll('h3')).slice(0,5).map(h => h.textContent).join('\n')" --surface surface:N

# Click a result by CSS selector
cmux browser click "h3" --surface surface:N

# Read the page
cmux browser wait --surface surface:N --load-state complete
cmux browser eval "document.body.innerText.substring(0, 3000)" --surface surface:N

# Clean up
cmux close-surface --surface surface:N
```

## 5. Run Tests and Monitor Output

```bash
# Step 1: Create workspace
cmux new-workspace --cwd /path/to/project
# Returns: OK workspace:N

# Step 2: Start test run
cmux send --workspace workspace:N "npm test"
cmux send-key --workspace workspace:N Enter

# Step 3: Set progress indicator
cmux set-status "task" "running tests" --icon "hourglass" --workspace workspace:N

# Step 4: Periodically read output
sleep 10
cmux read-screen --workspace workspace:N --scrollback --lines 100

# Step 5: Check if tests are done (look for summary line)
# If still running, wait more and read again

# Step 6: Update status when done
cmux set-status "task" "tests complete" --icon "checkmark" --workspace workspace:N
cmux notify --title "Tests Complete" --body "All tests passed" --workspace workspace:N
```

## 6. Multi-Terminal Setup (e.g., Frontend + Backend + Tests)

```bash
# Step 1: Create workspace
cmux new-workspace --cwd /path/to/project
# Returns: OK workspace:N
# Use tree to find the first surface
cmux tree --workspace workspace:N
# Note: first terminal is in pane:A

# Step 2: Split right for backend
cmux new-pane --type terminal --direction right --workspace workspace:N
# Returns: OK surface:B pane:B workspace:N

# Step 3: Split bottom-right for tests
cmux new-pane --type terminal --direction down --workspace workspace:N
# Returns: OK surface:C pane:C workspace:N

# Step 4-6: Send commands to each pane
# For panes created with new-pane, you can use --surface
cmux send --surface surface:B "cd backend && cargo run"
cmux send-key --surface surface:B Enter

cmux send --surface surface:C "npm test -- --watch"
cmux send-key --surface surface:C Enter

# For the first pane (from new-workspace), use --workspace
cmux send --workspace workspace:N "cd frontend && npm run dev"
cmux send-key --workspace workspace:N Enter

# Step 7: Rename workspace for clarity
cmux rename-workspace --workspace workspace:N "Full Stack Dev"
```

## 7. TUI Application Testing

```bash
# Step 1: Create workspace and launch TUI
cmux new-workspace --cwd /path/to/project --command "htop"
# OR: --command "vim file.txt"
# OR: --command "lazygit"
# Returns: OK workspace:N

# Step 2: Wait for TUI to start, then read screen
sleep 2
cmux read-screen --workspace workspace:N --lines 40

# Step 3: Send keys to interact with TUI
# Single characters — use send (send-key doesn't support them)
cmux send --workspace workspace:N "q"         # press 'q' (e.g., quit htop)
cmux send --workspace workspace:N "j"         # press 'j' (e.g., move down in vim)
cmux send-key --workspace workspace:N Enter   # press Enter
cmux send-key --workspace workspace:N Ctrl-c  # Ctrl+C

# Arrow equivalents via Ctrl combos
cmux send-key --workspace workspace:N Ctrl-n  # Down
cmux send-key --workspace workspace:N Ctrl-p  # Up

# Step 4: Read screen after interaction
cmux read-screen --workspace workspace:N --lines 40
```

## Tips for All Workflows

1. **`new-workspace` only returns `workspace:N`.** Use `cmux tree --workspace workspace:N` to find surface refs if needed. But for most operations, `--workspace` is sufficient and preferred.

2. **For multi-pane setups**, `new-pane` returns `surface:N pane:N workspace:N` — save these. Use `--surface` for browser commands and `--workspace` for terminal send/read.

3. **For long-running commands**, use `read-screen --scrollback --lines N` to see historical output that has scrolled off screen.

4. **Sleeping is often necessary** between sending a command and reading its output. Start with 2-3 seconds for fast commands, 5-10 for slower ones.

5. **Always clean up** when done:
   ```bash
   cmux close-workspace --workspace workspace:N
   ```
