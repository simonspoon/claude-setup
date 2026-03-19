# Browser Troubleshooting

## Problem: "Element not found" when clicking by ref

**Cause:** Refs (`[ref=eN]`) are assigned per-snapshot and change whenever the DOM updates. JS-heavy sites (React, SPAs, sites with ads) re-render frequently, invalidating refs between your snapshot and your click.

**Fix — escalation ladder (try in order):**

1. **Get a fresh snapshot and click immediately** (no sleep between):
   ```bash
   cmux browser snapshot --surface surface:N --interactive
   # Use the ref from THIS output, click RIGHT AWAY
   cmux browser click "[ref=eNN]" --surface surface:N
   ```

2. **Use a CSS selector instead** (stable across re-renders):
   ```bash
   cmux browser click "button[type=submit]" --surface surface:N
   cmux browser click "a[href*='login']" --surface surface:N
   cmux browser click "nav li:nth-child(2) a" --surface surface:N
   ```

3. **Use `browser find` to locate by accessible name** then click:
   ```bash
   cmux browser find text "Sign In" --surface surface:N
   cmux browser click "text=Sign In" --surface surface:N
   ```

4. **Fall back to JavaScript click**:
   ```bash
   cmux browser eval "document.querySelector('button.submit').click()" --surface surface:N
   ```

## Problem: Snapshot returns useless/truncated text

**Cause:** `--compact` mode and default snapshot both produce accessibility tree output that can be garbled on content-heavy or JS-rendered pages.

**Fix:** Use `browser eval` to read content instead:
```bash
# Read visible text
cmux browser eval "document.body.innerText.substring(0, 3000)" --surface surface:N

# Read a specific section
cmux browser eval "document.querySelector('main')?.innerText || 'main not found'" --surface surface:N

# Read with fallback chain
cmux browser eval "document.querySelector('[data-testid=content]')?.innerText || document.querySelector('main')?.innerText || document.querySelector('article')?.innerText || document.body.innerText.substring(0, 3000)" --surface surface:N
```

## Problem: Form fill/search doesn't work on JS-heavy sites

**Cause:** Many modern sites use custom input components (React, autocomplete widgets) that don't respond to standard fill. The `fill` may succeed (OK response) but the site ignores it because it expects specific JS events.

**Fix — escalation ladder:**

1. **Try `fill` first** (works on standard HTML inputs):
   ```bash
   cmux browser fill "input[name=search]" "query" --surface surface:N
   ```

2. **If fill succeeds but nothing happens**, try `type` (simulates keystrokes):
   ```bash
   cmux browser click "input[name=search]" --surface surface:N
   cmux browser type "input[name=search]" "query" --surface surface:N
   ```

3. **If the site uses autocomplete**, wait for suggestions after typing:
   ```bash
   cmux browser fill "input[name=search]" "query" --surface surface:N
   sleep 2
   cmux browser snapshot --surface surface:N --interactive --selector "[class*=suggest], [class*=autocomplete], [class*=dropdown], [role=listbox]"
   # Click the suggestion
   cmux browser click "[ref=eNN]" --surface surface:N
   ```

4. **Skip the form entirely — navigate directly via URL**:
   ```bash
   # Most sites encode search/lookup in the URL
   cmux browser navigate "https://site.com/search?q=query" --surface surface:N
   ```
   This is often the most reliable approach. Check the site's URL patterns.

## Problem: Page loads but content is empty/loading

**Cause:** SPA content loads asynchronously after initial page load. `--load-state complete` fires when the HTML loads, but JS may still be fetching data.

**Fix:**
```bash
# Wait for a specific element that only appears after data loads
cmux browser wait --surface surface:N --selector ".results-container" --timeout-ms 10000

# Or wait for text that indicates loading is done
cmux browser wait --surface surface:N --text "Showing results"

# Or use a JS condition
cmux browser wait --surface surface:N --function "() => !document.querySelector('.loading-spinner')"
```

## Problem: Element is behind a popup/modal/cookie banner

**Fix:**
```bash
# Dismiss cookie banner
cmux browser click "button[id*=accept], button[class*=accept], button[class*=cookie]" --surface surface:N

# Close modal
cmux browser press "Escape" --surface surface:N
# or
cmux browser click "button[aria-label=Close], .modal-close, [class*=dismiss]" --surface surface:N

# If nothing works, remove it with JS
cmux browser eval "document.querySelector('[class*=modal], [class*=overlay], [class*=cookie]')?.remove()" --surface surface:N
```

## Problem: Content is inside an iframe

**Fix:**
```bash
# Switch to the iframe
cmux browser frame "iframe#widget" --surface surface:N

# Now interact with iframe content normally
cmux browser snapshot --surface surface:N --interactive

# When done, switch back to main page
cmux browser frame main --surface surface:N
```

## General Strategy: When in Doubt

1. **Navigate directly via URL** — skip UIs when possible
2. **Use `browser eval`** — JS is the most reliable way to read and interact
3. **Use CSS selectors** — more stable than refs
4. **Use refs as last resort** — snapshot + click immediately, no delay
5. **Check `browser errors list`** — JS errors may explain broken interactions
6. **Check `browser console list`** — may reveal useful debug info
