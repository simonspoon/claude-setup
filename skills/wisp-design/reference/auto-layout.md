# Auto-Layout (Flexbox)

Frames and groups can use flexbox auto-layout to position children automatically instead of manual absolute positioning.

## Create a Flex Container

```bash
# Vertical stack with 16px gap and 20px padding
CARD=$(wisp node add "Card" -t frame --width 300 --height 400 --fill "#ffffff" \
  --layout-mode flex --direction column --gap 16 --padding 20 --json | jq -r .id)

# Add children -- they stack automatically, no x/y needed
wisp node add "Title" -t text --parent $CARD --text "Revenue" --font-size 18
wisp node add "Value" -t text --parent $CARD --text "$12,400" --font-size 32
wisp node add "Chart" -t rectangle --parent $CARD --width 260 --height 120 --fill "#e2e8f0"
```

## Convert an Existing Node to Flex

```bash
wisp node edit $CONTAINER --layout-mode flex --direction row --gap 12 --align center
```

## Flex Properties

| Property | Flag | Values | Default |
|----------|------|--------|---------|
| Mode | `--layout-mode` | `none`, `flex` | `none` |
| Direction | `--direction` | `row`, `column` | `column` |
| Align items | `--align` | `start`, `center`, `end`, `stretch` | `start` |
| Justify content | `--justify` | `start`, `center`, `end`, `stretch`, `space_between` | `start` |
| Gap | `--gap` | pixels (float) | none |
| Padding | `--padding` | pixels (float) | none |

## How Flex Children Behave

- Children of a flex container are positioned automatically -- their `x` and `y` are ignored
- Children still use their `width` and `height` for sizing
- The flex container's `width` and `height` define the container bounds
- Use `--align stretch` to make children fill the cross-axis

## When to Use Flex vs Manual Positioning

- **Use flex** for lists, stacks, cards with vertical content, toolbars, nav bars, button rows
- **Use manual** for overlapping elements, precise pixel placement, scattered elements on a canvas

## Common Patterns

### Sidebar with nav items
```bash
wisp node edit $SIDEBAR --layout-mode flex --direction column --gap 4 --padding 8
wisp components use nav-item --parent $SIDEBAR --label "Dashboard"
wisp components use nav-item --parent $SIDEBAR --label "Analytics"
wisp components use nav-item --parent $SIDEBAR --label "Settings"
```

### Horizontal button row
```bash
ROW=$(wisp node add "Actions" -t frame --width 400 --height 48 \
  --layout-mode flex --direction row --gap 12 --align center --json | jq -r .id)
wisp components use button --parent $ROW --label "Cancel"
wisp components use button --parent $ROW --label "Save"
```

### Card with stacked content
```bash
CARD=$(wisp node add "Card" -t frame --width 280 --height 200 --fill "#ffffff" --radius 8 \
  --layout-mode flex --direction column --gap 8 --padding 16 --json | jq -r .id)
wisp node add "Title" -t text --parent $CARD --text "Monthly Revenue" --font-size 14
wisp node add "Amount" -t text --parent $CARD --text "$12,400" --font-size 28
wisp node add "Change" -t text --parent $CARD --text "+12% from last month" --font-size 12
```
