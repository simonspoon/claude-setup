---
name: wisp-design
description: Design and build visual UI layouts using the Wisp desktop design tool and its CLI. Use when the user mentions wisp, designing UI, building layouts, creating mockups, visual design, placing components, arranging elements on a canvas, or iterating on a design visually.
---

# Designing UI with Wisp

Build, inspect, and iterate on visual UI layouts using the `wisp` CLI to control a live desktop canvas.

## How It Works

Wisp is a desktop design canvas controlled via CLI. The Wisp desktop app runs a WebSocket server on `ws://127.0.0.1:9847/ws`. The `wisp` CLI sends JSON-RPC commands to create, edit, and arrange design nodes. Changes appear on the canvas instantly.

```
wisp CLI  ──WebSocket/JSON-RPC──>  Wisp App (desktop canvas)
```

The CLI binary is at `wisp` (if installed via Homebrew) or at the project's `target/release/wisp` if built from source.

## Quick Start

```bash
# 1. Ensure the Wisp desktop app is running (it provides the WebSocket server)

# 2. Create a frame and capture its ID
HEADER_ID=$(wisp node add "Header" -t frame --width 800 --height 60 --fill "#1e40af" --json | jq -r .id)

# 3. Add text inside it
wisp node add "Title" -t text --parent $HEADER_ID -x 16 -y 16 --text "Dashboard" --font-size 24

# 4. See the tree
wisp tree

# 5. Screenshot the canvas
wisp screenshot --out design.png
```

## Setup Checklist

1. The Wisp desktop app must be running (it starts the WebSocket server on port 9847)
2. The `wisp` CLI must be available (`wisp` or path to `target/release/wisp`)
3. Test connectivity: `wisp tree` should return an empty or existing tree without errors
4. If the CLI says "Failed to connect... Is the Wisp app running?" -- launch the desktop app first

## Node Types

| Type | Flag | Use for |
|------|------|---------|
| `frame` | `-t frame` | Containers, panels, cards, sections (default type) |
| `text` | `-t text` | Labels, headings, body text |
| `rectangle` | `-t rectangle` | Decorative shapes, bars, dividers |
| `ellipse` | `-t ellipse` | Circles, avatars, indicators |
| `group` | `-t group` | Logical grouping without visual style |

## Core Operations

### Create a Node

```bash
wisp node add "<name>" -t <type> [options]
```

Options:
- `-t, --node-type <type>` -- frame, text, rectangle, ellipse, group (default: frame)
- `-p, --parent <id>` -- parent node UUID (defaults to root)
- `-x <float>` -- X position relative to parent
- `-y <float>` -- Y position relative to parent
- `--width <float>` -- width in pixels
- `--height <float>` -- height in pixels
- `--fill <hex>` -- fill color (e.g. "#3b82f6")
- `--text <string>` -- text content (for text nodes)
- `--font-size <float>` -- font size in pixels
- `--radius <float>` -- corner radius in pixels
- `--opacity <float>` -- opacity from 0.0 to 1.0

Capture the created node's ID:
```bash
ID=$(wisp node add "Panel" -t frame --width 400 --height 300 --json | jq -r .id)
```

### Edit a Node (Partial Update)

```bash
wisp node edit <id> [options]
```

Only the fields you specify are changed -- everything else is preserved. Same options as `add` except `--name <string>` replaces the positional name argument, and there is no `--node-type` or `--parent`.

```bash
# Change only the fill color (position, size preserved)
wisp node edit $ID --fill "#ef4444"

# Move without changing size or style
wisp node edit $ID -x 100 -y 200
```

### Delete a Node

```bash
wisp node delete <id>
```

Removes the node and all its children.

### Inspect a Node

```bash
wisp node show <id>
```

Returns the full node JSON including layout, style, typography, children.

### View the Document Tree

```bash
wisp tree
```

Prints the hierarchical tree of all nodes with names and types.

## Component Templates

Pre-built multi-node components you can stamp down and customize.

### List Available Templates

```bash
wisp components list
```

Built-in templates:
| Template | Description | Nodes created |
|----------|-------------|---------------|
| `stat-card` | Statistics card with label, value, and change indicator | 4 (frame + 3 text) |
| `nav-item` | Navigation menu item with icon placeholder and label | 3 (frame + rect + text) |
| `button` | Rounded button with label text | 2 (frame + text) |
| `chart-bar` | Single bar chart element with label | 3 (group + rect + text) |

### Use a Template

```bash
wisp components use <template-name> [options]
```

Options:
- `-p, --parent <id>` -- parent node UUID
- `-x <float>` -- X position
- `-y <float>` -- Y position
- `--label <string>` -- label text (for components that have one)
- `--value <string>` -- value text (for stat-card, etc.)

Capture the root node ID of the created component:
```bash
CARD=$(wisp components use stat-card --parent $MAIN -x 32 -y 32 2>&1 | grep "root:" | awk '{print $2}')
```

After placing a component, use `node edit` to adjust position and styling:
```bash
wisp node edit $CARD -x 100 -y 50
```

## Undo / Redo

```bash
wisp undo    # Undo the last operation (100 levels available)
wisp redo    # Redo the last undone operation
```

Both report remaining undo/redo counts.

## Save and Load

```bash
wisp save /path/to/design.json      # Persist the current canvas
wisp load /path/to/design.json      # Restore a saved design
```

Save paths are resolved to absolute paths automatically. The saved format is JSON containing the full node tree.

## Screenshot

```bash
wisp screenshot --out design.png
```

Captures the canvas as a 2x resolution PNG. Default output: `wisp-screenshot.png`.

After capturing, read the PNG with the Read tool to visually inspect the design and decide what to adjust.

## Watch for Changes

```bash
wisp watch    # Stream real-time change notifications (Ctrl+C to stop)
```

Prints notifications like `[created] <id>`, `[edited] <id>`, `[deleted] <id>`.

## Interactive Session

```bash
wisp session
```

Opens a REPL that keeps the WebSocket connection open. Type commands without the `wisp` prefix:

```
wisp> tree
wisp> node add "Box" -t rectangle --width 100 --height 100 --fill "#ff0000"
wisp> quit
```

Useful for batch operations -- avoids reconnecting for each command. Session mode is efficient when creating many nodes (e.g., building a chart with 12+ bars).

## Global Flags

- `--json` -- output raw JSON instead of formatted text (works on all commands)
- `--url <ws-url>` -- override the WebSocket URL (default: `ws://127.0.0.1:9847/ws`)

## Design Workflow

Follow this sequence when building a UI design:

### 1. Plan the Layout Structure
Sketch out the major sections before creating nodes. Think in containers:
- Header bar (full-width frame at top)
- Sidebar (tall frame on the left)
- Main content area (frame filling the remaining space)
- Cards, panels, sections within the content area

### 2. Build Top-Down
Create containers first, then fill them with content:

```bash
# Main structure
HEADER=$(wisp node add "Header" -t frame --width 1200 --height 64 --fill "#1e40af" --json | jq -r .id)
SIDEBAR=$(wisp node add "Sidebar" -t frame -y 64 --width 260 --height 800 --fill "#1e3a5f" --json | jq -r .id)
MAIN=$(wisp node add "Main" -t frame -x 260 -y 64 --width 940 --height 800 --fill "#f1f5f9" --json | jq -r .id)

# Content inside containers
wisp node add "Title" -t text --parent $HEADER -x 20 -y 18 --text "My App" --font-size 24
```

### 3. Use Components for Repeated Patterns
Instead of manually building stat cards or buttons, use templates:

```bash
wisp components use stat-card --parent $MAIN -x 20 -y 20 --label "Revenue" --value "$12,400"
wisp components use stat-card --parent $MAIN -x 320 -y 20 --label "Users" --value "1,247"
wisp components use button --parent $MAIN -x 20 -y 180 --label "View Report"
```

### 4. Screenshot and Inspect

```bash
wisp screenshot --out /tmp/design-v1.png
```

Read the screenshot to see what the design looks like. Use `wisp tree` to see the node hierarchy.

### 5. Iterate
Based on what you see, adjust:

```bash
# Move a misplaced element
wisp node edit $CARD_ID -x 340 -y 32

# Change a color
wisp node edit $HEADER --fill "#0f172a"

# Remove something that doesn't work
wisp node delete $BAD_NODE

# Undo a mistake
wisp undo
```

### 6. Save Your Work

```bash
wisp save /tmp/my-design.json
```

## Positioning Reference

- All coordinates are in pixels, relative to the parent node
- `x: 0, y: 0` is the top-left corner of the parent
- Width and height define the node's bounding box
- There is no auto-layout -- you position everything manually
- Common spacing: 16px-32px padding, 16px-24px gaps between elements

## Color Reference

Common hex colors for UI design:
- Backgrounds: `#f1f5f9` (light gray), `#ffffff` (white), `#0f172a` (dark navy)
- Primary: `#3b82f6` (blue), `#2563eb` (darker blue), `#1e40af` (navy)
- Text: `#0f172a` (dark), `#64748b` (muted), `#ffffff` (white on dark)
- Accents: `#10b981` (green), `#ef4444` (red), `#f59e0b` (amber)
- Borders/dividers: `#e2e8f0` (light), `#94a3b8` (medium)

## Gotchas

- **App must be running first.** The CLI connects to the desktop app's WebSocket server. If you get "Failed to connect," launch the app.
- **IDs are UUIDs.** Always capture IDs from `--json` output or from the formatted "Created node <id>" response. The root canvas node ID is `00000000-0000-0000-0000-000000000000`.
- **No auto-layout.** You must manually calculate x, y, width, height for every node. Plan positions before creating.
- **Partial edits are safe.** `node edit` only changes the fields you specify -- layout, style, and typography you omit are preserved.
- **Component position.** Templates are placed at (0,0) within the parent by default. Use `-x` and `-y` flags on `components use` to set initial position, or `node edit` to reposition afterward.
- **Session mode for bulk work.** When creating many nodes (charts, lists, grids), pipe commands through `wisp session` to avoid per-command WebSocket reconnection.
- **Screenshot for verification.** The canvas is visual -- always screenshot after significant changes to verify the result matches your intent.
- **Save often.** Use `wisp save` after completing major sections. You can `wisp load` to restore if something goes wrong.

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| "Failed to connect" | Wisp app not running | Launch the Wisp desktop app |
| "node not found" | Invalid UUID | Use `wisp tree` or `--json` output to get correct IDs |
| Node appears at wrong position | Coordinates relative to parent, not canvas | Check parent node's position; child coords are offsets from parent |
| Screenshot is empty/blank | No nodes on canvas, or app not rendering | Add nodes first; check `wisp tree` for content |
| Edit seems to reset other properties | Should not happen with partial edits | Only specify fields you want to change; verify with `wisp node show <id>` |
