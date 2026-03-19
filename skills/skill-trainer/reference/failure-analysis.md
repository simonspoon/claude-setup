# Failure Analysis

## Goal

When a test fails, determine WHY it failed so you can apply the right fix. The root cause determines the fix — misdiagnosing wastes time.

## Failure Taxonomy

### 1. Wrong Command Syntax

**Signal:** Tool returns an error like "unknown command", "invalid option", "missing argument".

**Examples:**
- Docs say `cmux send-key ... C-c` but tool expects `Ctrl-c`
- Docs say `--flag value` but tool expects `--flag=value`
- Docs show a subcommand that doesn't exist

**Fix:** Correct the command in the docs. Test the corrected command to confirm.

**Prevention:** Always test commands before documenting them.

### 2. Wrong Expected Behavior

**Signal:** Command succeeds but output doesn't match what docs describe.

**Examples:**
- Docs say "returns `OK surface:N pane:N workspace:N`" but it only returns `OK workspace:N`
- Docs say "`tab list` shows all tabs" but it returns empty output
- Docs say "click by ref is preferred" but refs are unreliable on JS-heavy sites

**Fix:** Update the docs to describe the REAL behavior. If the documented approach is unreliable, document it as such and provide a reliable alternative.

### 3. Missing Step

**Signal:** Following the docs leads to a state where the next step can't work.

**Examples:**
- Docs say "send command to surface:N" but never explain how to get the surface ref
- Docs say "click the element" but don't say to wait for page load first
- Docs say "read the output" but command hasn't had time to produce output yet

**Fix:** Add the missing step. Include enough context that the reader knows WHY it's needed.

### 4. Missing Warning / Gotcha

**Signal:** Something fails in a way the docs don't mention or prepare for.

**Examples:**
- `read-screen --surface` fails silently but `--workspace` works
- `\n` in send text is interpreted as a literal newline
- Browser refs change between snapshot and click on dynamic pages

**Fix:** Add to the skill's known-issues or gotchas section. If the gotcha is critical (will trip up every user), add it to the Important Rules section of SKILL.md.

### 5. Misleading Instruction

**Signal:** The docs are technically correct but lead the reader to the wrong action.

**Examples:**
- "Use snapshot to see the page" — technically true but eval is more reliable for reading content
- "Click by ref (preferred)" — technically works but CSS selectors are more stable
- Listing an unreliable feature without caveats

**Fix:** Rewrite to guide toward the BEST approach, not just a working approach. Add context about when each approach is appropriate.

### 6. Ambiguous Instruction

**Signal:** You (or a weaker model) could interpret the instruction multiple ways, and one interpretation leads to failure.

**Examples:**
- "Send the command" — does this mean type it? Press Enter? Both?
- "Use the surface ref" — which one? The one from new-workspace? From tree?
- "Wait for the page" — how long? What condition?

**Fix:** Make it unambiguous. Be explicit about every detail a reader needs. Assume the reader will take the LEAST helpful interpretation of anything vague.

### 7. Tool Limitation (not a doc bug)

**Signal:** The underlying tool genuinely can't do what you're trying to do.

**Examples:**
- Browser screenshot command crashes
- Tab management commands don't work
- Certain key names aren't supported

**Fix:** Document the limitation clearly. Add it to known-issues. Provide a workaround if one exists. Do NOT remove the feature from docs entirely — someone may want to know it exists even if it's limited.

## Decision Tree

When a test fails, ask:

```
Did the command error out?
├─ YES → Is the syntax wrong in the docs?
│        ├─ YES → Type 1: Wrong Command Syntax
│        └─ NO  → Type 7: Tool Limitation
└─ NO (command succeeded) → Did the output match docs?
   ├─ YES → Did the NEXT step work?
   │        ├─ YES → Not a failure (check your test)
   │        └─ NO  → Type 3: Missing Step
   └─ NO  → Are the docs describing the wrong behavior?
            ├─ YES → Type 2: Wrong Expected Behavior
            └─ NO  → Could you have avoided this with a warning?
                     ├─ YES → Type 4: Missing Warning
                     └─ NO  → Type 5 or 6: Misleading/Ambiguous
```

## Severity Levels

Not all failures are equal. Prioritize fixes by impact:

**P0 — Blocks usage:** Wrong commands that error out, missing critical steps. Fix immediately.

**P1 — Causes confusion:** Misleading instructions that lead to wrong actions. Fix in this round.

**P2 — Suboptimal guidance:** Works but there's a better way. Fix if time permits.

**P3 — Cosmetic:** Unclear wording that doesn't cause failures. Note for later.

Focus Phase 2 effort on P0 and P1. Save P2/P3 for polish.
