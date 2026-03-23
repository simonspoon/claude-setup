# Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| "Failed to connect" | Wisp app not running | Launch the Wisp desktop app |
| "node not found" | Invalid UUID | Use `wisp tree` or `--json` output to get correct IDs |
| Node appears at wrong position | Coordinates relative to parent, not canvas | Check parent node's position; child coords are offsets from parent |
| Screenshot is empty/blank | No nodes on canvas, or app not rendering | Add nodes first; check `wisp tree` for content |
| Edit seems to reset other properties | Should not happen with partial edits | Only specify fields you want to change; verify with `wisp node show <id>` |
| Flex children still at (0,0) | Parent not set to flex mode | Use `wisp node edit $PARENT --layout-mode flex` |
| Child ignoring x/y position | Parent is a flex container | Flex children are auto-positioned; x/y are ignored. Remove flex or use a non-flex parent |
| Text overflows its width | Text wrapping not enabled | Add `--text-wrap` flag when creating or editing the text node |
