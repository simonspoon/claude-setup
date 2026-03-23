## Training Report: loki-test-desktop

**Date:** 2026-03-23
**Tool version:** loki (installed at ~/.cargo/bin/loki)
**System:** macOS, accessibility permission granted

### Phase 1: Test Scenarios

| # | Test Name | Category | What It Tests |
|---|-----------|----------|---------------|
| 1 | Permission check | core | `loki check-permission` returns granted/denied |
| 2 | Window discovery | core | `loki windows` and filtered variants list windows |
| 3 | UI tree inspection | core | `loki tree` and `loki find` locate elements |
| 4 | Click element by query | core | `loki click-element` clicks a UI element |
| 5 | Type and key commands | core | `loki type` and `loki key` send input |
| 6 | Screenshot capture | core | `loki screenshot --window` saves a PNG |
| 7 | App lifecycle | workflow | Launch, find window, interact, verify, kill |
| 8 | Wait for element | core | `loki wait-for` and `loki wait-gone` polling |
| 9 | Scripting pattern end-to-end | workflow | Full Quick Start / Scripting Pattern from docs |
| 10 | Error: no window found | error | Behavior when bundle-id has no open windows |
| 11 | Error: permission denied | error | Behavior when accessibility is not granted |
| 12 | Cleanup after kill | cleanup | `loki kill` terminates app cleanly |

### Phase 2: Self-Test Results

| # | Test | R1 Result | Issue Found | Fix Applied | R2 Result |
|---|------|-----------|-------------|-------------|-----------|
| 1 | Permission check | PASS | Text output: "granted". JSON output: `{"granted": true}`. Exit code 0. | -- | -- |
| 2 | Window discovery | PASS | `loki windows` lists all windows. `--bundle-id`, `--title` filters work. Returns JSON array with window_id, pid, title, bundle_id, frame, is_on_screen. Multiple windows returned per app (main + auxiliary). | -- | -- |
| 3 | UI tree inspection | PASS | `loki tree` shows hierarchy with roles, titles, sizes. `loki find` locates elements by role+title and returns JSON with role, description, identifier, frame, enabled, focused, path. | -- | -- |
| 4 | Click element by query | PASS | `loki click-element <WID> --role AXButton --title "5"` outputs the matched element and exits 0. Calculator responded to the click. | -- | -- |
| 5 | Type and key commands | PASS | `loki type "text" --window <WID>` types into targeted app. `loki key cmd+a --window <WID>` selects all. `loki key delete --window <WID>` deletes. Verified via `loki find --role AXTextArea` showing value changed. | -- | -- |
| 6 | Screenshot capture | PASS | `loki screenshot --window <WID> --output /tmp/screenshot.png` saves PNG (~100KB). File created, correct size. | -- | -- |
| 7 | App lifecycle | PASS | `loki launch com.apple.Calculator` returns PID, name, bundle ID. `loki wait-window` confirms window appeared. `loki windows` finds it. `loki kill` terminates. Post-kill `loki windows` returns empty array. | -- | -- |
| 8 | Wait for element | PASS | `loki wait-for <WID> --role AXButton --title "5"` returns immediately when element exists (exit 0). `loki wait-gone <WID> --title "5" --timeout 2000` times out with exit code 3 when element still present. | -- | -- |
| 9 | Scripting pattern E2E | FAIL (doc) | Quick Start omitted `loki launch` and `loki kill` steps, assuming app was already running. Scripting Pattern was correct. | Added `loki launch`, `loki wait-window`, and `loki kill` to Quick Start. | PASS |
| 10 | Error: no window found | PASS | `loki windows --bundle-id com.fake.nonexistent` returns `[]` (empty array), exit code 0. Not an error -- just empty results. | Added "Empty Results" gotcha to docs noting array may be empty. | PASS |
| 11 | Error: permission denied | SKIP | Cannot safely test without revoking accessibility permission. `loki check-permission` confirms "granted" status. The positive path is verified. | -- | -- |
| 12 | Cleanup after kill | PASS | `loki kill com.apple.Calculator` prints "Killed: com.apple.Calculator", exit 0. `loki kill com.apple.TextEdit` same. Post-kill `loki windows --bundle-id ...` returns `[]`. Clean termination confirmed. | -- | -- |

**Summary:** 10 PASS, 1 FAIL-then-fixed, 1 SKIP (permission denied requires revoking access)

### Phase 3: Haiku Validation

Skipped per user instruction.

### Doc Changes Made

1. **SKILL.md Quick Start**: Added `loki launch com.apple.Calculator`, `loki wait-window`, and `loki kill` steps. The original Quick Start assumed the app was already running, which would confuse a model following the pattern literally.

2. **SKILL.md Gotchas -- Empty Results**: Added section explaining that `loki windows` and `loki find` return empty JSON arrays (not errors) when no matches are found. Models should check array length before extracting `.[0].window_id`.

3. **SKILL.md Gotchas -- Timeouts**: Added section documenting that wait commands exit with code 3 on timeout. Models should check exit codes or use `set -e`.

4. **SKILL.md Gotchas -- jq dependency**: Added note that `jq` is required for the JSON parsing patterns in Quick Start and Scripting Pattern.

5. **SKILL.md Gotchas -- Button Titles**: Added section warning that accessibility titles may differ from visible labels (e.g., Calculator shows "+" but accessibility title is "Add"). Models should always use `loki find` or `loki tree --flat` to discover actual titles before writing click commands.

### Findings

1. **Quick Start was incomplete** -- missing launch/kill lifecycle. A model following it literally would fail if the target app wasn't already open. Fixed.

2. **Empty results are silent** -- `loki windows` and `loki find` return `[]` with exit code 0, not an error. A weak model might try to extract `.[0].window_id` from an empty array and get `null`, then pass `null` to subsequent commands. Documented.

3. **Timeout exit code is 3** -- not 1. This is a specific exit code that models should know about for error handling in scripts. Documented.

4. **Accessibility titles differ from visual labels** -- this is a fundamental gotcha for any model trying to click Calculator buttons by their visual symbols. The docs didn't warn about this. Documented.

5. **Multiple windows per app** -- Calculator returns 6 windows (1 main + 5 auxiliary). The `.[0]` pattern works because the titled main window comes first, but this is fragile. The Scripting Pattern correctly uses `.[0]` but doesn't explain why.

6. **Bundle ID case insensitivity** -- `com.apple.Calculator` (uppercase C) works as a query filter even though the actual bundle ID is `com.apple.calculator` (lowercase). This is convenient but undocumented.

7. **jq is an implicit dependency** -- all JSON extraction patterns rely on `jq` but it was never listed as a prerequisite. Documented.

### Remaining Issues

- **Test 11 (permission denied) was skipped** -- cannot test without revoking accessibility access, which would break the testing session. The positive path (granted) is verified.
- **No example command output in docs** -- the docs show commands but not what they return. A weak model may not know how to interpret the output. This is a P2 improvement.
- **Multiple-window ambiguity** -- docs use `.[0].window_id` but don't explain that apps can have multiple windows. Filtering by title (e.g., `select(.title != "")`) would be more robust but adds complexity.

### Training Phases Completed

- Phase 1: Test Generation (12 scenarios)
- Phase 2: Self-Test Execution (10 passed, 1 fixed, 1 skipped)
- Phase 3: Haiku Validation (skipped per user instruction)

### Final Assessment: PASS

The loki-test-desktop skill is functional and well-documented. All core commands work as described. Five doc gaps were found and fixed: missing launch/kill in Quick Start, empty result behavior, timeout exit codes, jq dependency, and accessibility title mismatch. The skill is ready for use by Opus and Sonnet models. Haiku validation was deferred.
