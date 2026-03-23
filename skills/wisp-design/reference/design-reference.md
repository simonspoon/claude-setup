# Design Reference

## Positioning

- All coordinates are in pixels, relative to the parent node
- `x: 0, y: 0` is the top-left corner of the parent
- Width and height define the node's bounding box
- Use `--layout-mode flex` on containers for automatic child positioning (see [auto-layout.md](auto-layout.md))
- For manual positioning, common spacing: 16px-32px padding, 16px-24px gaps between elements
- Children inside a flex container ignore x/y -- they are positioned by the flex layout

## Color Palette

Common hex colors for UI design:

| Category | Colors |
|----------|--------|
| Backgrounds | `#f1f5f9` (light gray), `#ffffff` (white), `#0f172a` (dark navy) |
| Primary | `#3b82f6` (blue), `#2563eb` (darker blue), `#1e40af` (navy) |
| Text | `#0f172a` (dark), `#64748b` (muted), `#ffffff` (white on dark) |
| Accents | `#10b981` (green), `#ef4444` (red), `#f59e0b` (amber) |
| Borders | `#e2e8f0` (light), `#94a3b8` (medium) |

## Z-Index (Stacking Order)

Control which nodes render on top when they overlap:

```bash
# Background layer
wisp node add "BG" -t rectangle --width 400 --height 300 --fill "#e2e8f0" --z-index 0

# Foreground element (renders on top)
wisp node add "Badge" -t ellipse --width 24 --height 24 --fill "#ef4444" -x 380 --z-index 10
```

Higher `z_index` = renders on top. Nodes without a z-index default to 0.

## Text Wrapping

Text nodes can wrap within their width and auto-size their height:

```bash
# Fixed-width text that wraps and grows vertically
wisp node add "Description" -t text --width 280 \
  --text "This is a longer paragraph that will wrap within the 280px width" \
  --font-size 14 --text-wrap
```

Without `--text-wrap`, text renders on a single line. With it, text wraps at the node's width and height adjusts automatically.

## Human Interactive Editing

The Wisp desktop app supports direct manipulation on the canvas:

- **Click** a node to select it (shows blue outline)
- **Drag** a selected node to move it
- **Resize handle** appears at bottom-right of selected node -- drag to resize

Changes made interactively are persisted to the same document the CLI operates on. Use `wisp tree` or `wisp node show <id>` to see updated positions after manual edits.
