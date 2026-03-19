# Browser Operations — Full Reference

## Creating Browser Surfaces

### As a new pane (split)
```bash
cmux new-pane --type browser --url "https://example.com" --workspace workspace:N
# Returns: OK surface:N pane:N workspace:N
```

### As a tab in existing pane
```bash
cmux new-surface --type browser --pane pane:N --url "https://example.com"
# Returns: OK surface:N pane:N workspace:N
```

### Using the browser open shortcut
```bash
cmux browser open "https://example.com"
# Opens browser split in caller's workspace
```

**Always save the surface ref from the output.** You need it for all subsequent browser commands.

## Navigation

```bash
cmux browser navigate "https://url" --surface surface:N
cmux browser back --surface surface:N
cmux browser forward --surface surface:N
cmux browser reload --surface surface:N
```

### Get current URL
```bash
cmux browser url --surface surface:N
# or
cmux browser get-url --surface surface:N
```

## Waiting for Page State

**Always wait after navigation before interacting with the page.**

```bash
# Wait for full page load
cmux browser wait --surface surface:N --load-state complete

# Wait for a specific element to appear
cmux browser wait --surface surface:N --selector "button.submit"

# Wait for text to appear on page
cmux browser wait --surface surface:N --text "Results loaded"

# Wait for URL to contain a string (useful after redirects)
cmux browser wait --surface surface:N --url-contains "/dashboard"

# Custom JavaScript condition
cmux browser wait --surface surface:N --function "() => document.querySelectorAll('.item').length > 5"

# With timeout
cmux browser wait --surface surface:N --selector ".loaded" --timeout-ms 10000
```

## Reading Page Content

### Choosing the Right Tool

| Goal | Use | Why |
|---|---|---|
| **Read text content** | `browser eval` | Reliable, returns actual text, works on all sites |
| **Find elements to click** | `browser snapshot --interactive` | Returns refs and structure for interaction |
| **Check page structure** | `browser snapshot` (no flags) | Quick structural overview |
| **Get a specific value** | `browser get text/value/attr` | Targeted extraction by CSS selector |

### browser eval (BEST for reading content)

Use `browser eval` to extract text from pages. This is the most reliable method — it works on JS-heavy sites where snapshot may return truncated or garbled text.

```bash
# Get all visible text (truncated to avoid huge output)
cmux browser eval "document.body.innerText.substring(0, 3000)" --surface surface:N

# Get text from a specific section
cmux browser eval "document.querySelector('main')?.innerText || document.body.innerText.substring(0, 3000)" --surface surface:N

# Get structured data
cmux browser eval "document.title" --surface surface:N
cmux browser eval "JSON.stringify(window.performance.timing)" --surface surface:N

# Extract all links
cmux browser eval "Array.from(document.querySelectorAll('a')).map(a => a.href).join('\n')" --surface surface:N

# Extract table data
cmux browser eval "Array.from(document.querySelectorAll('table tr')).map(r => Array.from(r.cells).map(c => c.textContent).join(' | ')).join('\n')" --surface surface:N
```

### Accessibility Snapshot (for finding interactive elements)

Use snapshot when you need to **interact** with the page (click, fill, etc.), not just read it.

```bash
# Interactive snapshot — includes [ref=eN] handles for clicking
cmux browser snapshot --surface surface:N --interactive

# Focused on a section (reduces noise on large pages)
cmux browser snapshot --surface surface:N --interactive --selector "#main-content"

# Limit depth for very large pages
cmux browser snapshot --surface surface:N --interactive --max-depth 3
```

**Refs are ephemeral.** They change on every DOM update. Get a fresh snapshot immediately before clicking.

**Avoid `--compact` for content reading.** It strips refs and often returns a truncated text blob. Use `browser eval` instead.

### Get Specific Data
```bash
cmux browser get title --surface surface:N
cmux browser get text "h1" --surface surface:N
cmux browser get html "#content" --surface surface:N
cmux browser get value "input[name=email]" --surface surface:N
cmux browser get attr "a.link" "href" --surface surface:N
cmux browser get count ".list-item" --surface surface:N
cmux browser get box "#element" --surface surface:N  # bounding box
cmux browser get styles "#element" --surface surface:N
```

## Interacting with Page Elements

### Clicking

**Prefer CSS selectors over refs.** CSS selectors are stable; refs break on every DOM update.

```bash
# BEST: Click by CSS selector (stable across page updates)
cmux browser click "button.submit" --surface surface:N
cmux browser click "a[href='/login']" --surface surface:N
cmux browser click "#main-nav li:nth-child(3)" --surface surface:N

# FALLBACK: Click by ref from snapshot (when no good CSS selector exists)
# Step 1: Get fresh snapshot IMMEDIATELY before clicking
cmux browser snapshot --surface surface:N --interactive
# Step 2: Click the ref from THAT snapshot (do NOT reuse old refs)
cmux browser click "[ref=e42]" --surface surface:N

# Double-click
cmux browser dblclick ".item" --surface surface:N
```

**If a ref click fails with "not found":** The DOM changed between your snapshot and click. Get a new snapshot and use the new ref. If it keeps failing, the element may be behind a popup, inside an iframe, or dynamically rendered — try a CSS selector or `browser eval` + JS click instead. See reference/browser-troubleshooting.md.

### Typing and Filling Forms
```bash
# Fill an input (clears existing text first, then types)
cmux browser fill "input[name=search]" "search query" --surface surface:N

# Fill with empty string to clear
cmux browser fill "input[name=search]" "" --surface surface:N

# Type into focused element (does NOT clear first)
cmux browser type "input[name=search]" "additional text" --surface surface:N

# Press a key
cmux browser press "Enter" --surface surface:N

# Keyboard shortcuts
cmux browser press "Control+a" --surface surface:N
```

### Select Dropdowns
```bash
cmux browser select "select#country" "US" --surface surface:N
```

### Checkboxes
```bash
cmux browser check "input[type=checkbox]#agree" --surface surface:N
cmux browser uncheck "input[type=checkbox]#agree" --surface surface:N
```

### Hover
```bash
cmux browser hover ".menu-item" --surface surface:N
```

### Focus
```bash
cmux browser focus "input#email" --surface surface:N
```

### Scrolling
```bash
# Scroll the page down
cmux browser scroll --dy 500 --surface surface:N

# Scroll a specific container
cmux browser scroll --selector ".scroll-container" --dy 300 --surface surface:N

# Scroll element into view
cmux browser scroll-into-view ".target-element" --surface surface:N
```

## Browser Tabs (within a single browser surface)

**WARNING: Browser-level tab commands are unreliable.** `tab list` returns no data, `tab switch` doesn't change the active page. Use separate cmux surfaces instead:

```bash
# RECOMMENDED: Use separate surfaces as "tabs"
cmux new-surface --type browser --pane pane:N --url "https://site1.com"
cmux new-surface --type browser --pane pane:N --url "https://site2.com"

# Or just navigate the same surface to different URLs
cmux browser navigate "https://different-url.com" --surface surface:N
```

## Frames / Iframes

```bash
# Switch to an iframe
cmux browser frame "iframe#widget" --surface surface:N

# Return to main frame
cmux browser frame main --surface surface:N
```

## Dialogs (alerts, confirms, prompts)

```bash
cmux browser dialog accept --surface surface:N
cmux browser dialog accept "input text" --surface surface:N  # for prompt dialogs
cmux browser dialog dismiss --surface surface:N
```

## Element Queries

### Check element state
```bash
cmux browser is visible ".element" --surface surface:N
cmux browser is enabled "button.submit" --surface surface:N
cmux browser is checked "input[type=checkbox]" --surface surface:N
```

### Find elements by role/text
```bash
cmux browser find role "button" --surface surface:N
cmux browser find text "Sign In" --surface surface:N
cmux browser find label "Email" --surface surface:N
cmux browser find placeholder "Enter your name" --surface surface:N
cmux browser find testid "submit-btn" --surface surface:N
```

### Highlight element (visual debug)
```bash
cmux browser highlight ".target" --surface surface:N
```

## Console and Errors

```bash
cmux browser console list --surface surface:N
cmux browser console clear --surface surface:N
cmux browser errors list --surface surface:N
cmux browser errors clear --surface surface:N
```

## Cookies and Storage

```bash
# Cookies
cmux browser cookies get --surface surface:N
cmux browser cookies set --surface surface:N   # (check cmux docs for format)
cmux browser cookies clear --surface surface:N

# Local/session storage
cmux browser storage local get "key" --surface surface:N
cmux browser storage local set "key" "value" --surface surface:N
cmux browser storage session get "key" --surface surface:N
cmux browser storage local clear --surface surface:N
```

## Downloads

```bash
cmux browser download wait --surface surface:N --timeout-ms 30000
cmux browser download wait --path /tmp/file.pdf --surface surface:N
```

## Inject Scripts / Styles

```bash
# Run script on every page load (persists across navigations)
cmux browser addinitscript "window.__test = true" --surface surface:N

# Run script once on current page
cmux browser addscript "console.log('injected')" --surface surface:N

# Inject CSS
cmux browser addstyle "body { background: red !important; }" --surface surface:N
```

## State Save/Load

```bash
cmux browser state save /tmp/browser-state.json --surface surface:N
cmux browser state load /tmp/browser-state.json --surface surface:N
```

## Network

```bash
cmux browser network requests --surface surface:N  # list network requests
```

## Closing

```bash
cmux close-surface --surface surface:N
```
