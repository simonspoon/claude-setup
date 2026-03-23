# Design Workflow

Follow this sequence when building a UI design.

## 1. Plan the Layout Structure

Sketch out the major sections before creating nodes. Think in containers:
- Header bar (full-width frame at top)
- Sidebar (tall frame on the left)
- Main content area (frame filling the remaining space)
- Cards, panels, sections within the content area

## 2. Build Top-Down

Create containers first, then fill them with content:

```bash
# Main structure
HEADER=$(wisp node add "Header" -t frame --width 1200 --height 64 --fill "#1e40af" --json | jq -r .id)
SIDEBAR=$(wisp node add "Sidebar" -t frame -y 64 --width 260 --height 800 --fill "#1e3a5f" --json | jq -r .id)
MAIN=$(wisp node add "Main" -t frame -x 260 -y 64 --width 940 --height 800 --fill "#f1f5f9" --json | jq -r .id)

# Content inside containers
wisp node add "Title" -t text --parent $HEADER -x 20 -y 18 --text "My App" --font-size 24
```

## 3. Use Auto-Layout Where Appropriate

For vertical stacks (sidebars, card contents) or horizontal rows (toolbars, stat rows), use flex:

```bash
# Make sidebar a vertical flex container
wisp node edit $SIDEBAR --layout-mode flex --direction column --gap 4 --padding 8

# Nav items stack automatically -- no y positioning needed
wisp components use nav-item --parent $SIDEBAR --label "Dashboard"
wisp components use nav-item --parent $SIDEBAR --label "Analytics"
wisp components use nav-item --parent $SIDEBAR --label "Settings"
```

See [auto-layout.md](auto-layout.md) for full flexbox reference.

## 4. Use Components for Repeated Patterns

Instead of manually building stat cards or buttons, use templates:

```bash
wisp components use stat-card --parent $MAIN -x 20 -y 20 --label "Revenue" --value "$12,400"
wisp components use stat-card --parent $MAIN -x 320 -y 20 --label "Users" --value "1,247"
wisp components use button --parent $MAIN -x 20 -y 180 --label "View Report"
```

## 5. Screenshot and Inspect

```bash
wisp screenshot --out /tmp/design-v1.png
```

Read the screenshot to see what the design looks like. Use `wisp tree` to see the node hierarchy.

## 6. Iterate

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

## 7. Save Your Work

```bash
wisp save /tmp/my-design.json
```
