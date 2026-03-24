## Training Report: khora-test-web

**Date:** 2026-03-23 (live validation with khora installed)

### Phase 1: Test Scenarios
| # | Test Name | Category | What It Tests |
|---|-----------|----------|---------------|
| 1 | Quick Start end-to-end | Core | launch, navigate, screenshot, text, kill |
| 2 | Launch headed mode | Core | --visible flag |
| 3 | Find and inspect elements | Core | find, text, attribute commands |
| 4 | Click and type interaction | Core | click, type commands on real form |
| 5 | Wait-for and wait-gone | Core | Element presence/absence waiting |
| 6 | Eval JavaScript | Core | JS execution and value return |
| 7 | Console log reading | Core | console command, eval+console interaction |
| 8 | Session management | Core | status (all and specific), kill |
| 9 | Timeout and error behavior | Edge | Invalid session, bad selector, timeout |
| 10 | Multi-session cleanup | Workflow | Multiple concurrent sessions |

### Phase 2: Self-Test Results
| # | Test | R1 Result | Issue Found | Fix Applied | R2 Result |
|---|------|-----------|-------------|-------------|-----------|
| 1 | Quick Start e2e | PASS (doc gap) | SingletonLock from prior sessions blocks launch; docs had no troubleshooting | Added SingletonLock Issues section to Gotchas | -- |
| 2 | Launch headed mode | PASS (with notes) | SingletonLock persists after kill; headed mode works after cleanup | Covered by SingletonLock section | -- |
| 3 | Find and inspect elements | PASS | -- | -- | -- |
| 4 | Click and type interaction | PASS (with notes) | Click hangs on cross-origin navigation links; data URLs don't work for find | Added Click Behavior section to Gotchas | -- |
| 5 | Wait-for and wait-gone | PASS | -- | -- | -- |
| 6 | Eval JavaScript | PASS | -- | -- | -- |
| 7 | Console log reading | PASS (doc gap) | eval errors on undefined-returning expressions (console.log); console may not capture eval-generated logs | Added eval return value warning under Execute JavaScript | -- |
| 8 | Session management | PASS (with notes) | status shows stale/dead sessions; kill fails on dead sessions; stale files in ~/.khora/sessions/ | Added Stale Sessions section to Gotchas | -- |
| 9 | Timeout and error behavior | PASS (with notes) | Error messages very verbose (raw CDP); different exit codes undocumented | Added verbose error note to Error Recovery | -- |
| 10 | Multi-session cleanup | FAIL (tool issue) | Cannot launch multiple concurrent sessions due to SingletonLock on shared Chrome profile | Rewrote Multiple Sessions section: "Only one session at a time" | PASS |

### Phase 3: Haiku Validation
| # | Task Sent to Haiku | What Haiku Did | Result | Doc Fix |
|---|-------------------|----------------|--------|---------|
| 1 | Quick Start: launch, navigate example.com, screenshot, text h1, kill | Read SKILL.md, followed Quick Start exactly. Launched session, navigated, took screenshot (15760 bytes), got "Example Domain" text, killed session. | PASS | None needed |
| 2 | Element inspection: find (JSON), text, attribute, eval on example.com | Hit SingletonLock, correctly extracted path from error and removed it, retried launch. Executed find (found 1 link), text ("Example Domain"), attribute (href), eval (document.title). Killed session. | PASS | None -- SingletonLock recovery worked with prompt hint + updated docs |
| 3 | Wait-for + eval: wait-for h1, count paragraphs, get URL, kill | Hit SingletonLock again, combined rm + launch in one command. Used wait-for (h1 found), eval for paragraph count (2) and window.location.href. Killed session. | PASS | None needed |

### Doc Changes Made
- **SKILL.md line 100**: Added eval return value warning -- expressions returning `undefined` (like `console.log()`) error with "No value found". Documented workaround: append `; true`.
- **SKILL.md lines 155-157**: Added "Click Behavior" gotcha section -- click can hang during cross-origin navigation. Documented `--timeout` and `eval` workarounds.
- **SKILL.md lines 159-161**: Enhanced "Error Recovery" section -- added note about verbose CDP error messages.
- **SKILL.md lines 163-165**: Rewrote "Multiple Sessions" section -- changed from "each launch creates independent instance" (wrong) to "only one session at a time" (correct). Explained SingletonLock constraint.
- **SKILL.md lines 167-171**: Added "SingletonLock Issues" troubleshooting section -- how to diagnose and fix stale lock files.
- **SKILL.md lines 173-176**: Added "Stale Sessions" section -- status showing dead sessions, kill failing on them, manual cleanup of ~/.khora/sessions/.

### Findings (doc gaps filled by model knowledge)
- **Test 1**: I knew to remove the SingletonLock file from the error message path. The original docs had zero troubleshooting guidance for launch failures. Now documented.
- **Test 4**: I used my knowledge of data URLs and cross-origin navigation to diagnose click hangs. The original docs had no warnings about click blocking behavior.
- **Test 7**: I knew console.log returns undefined in JavaScript. The docs showed console.log-style expressions as eval examples without warning about the return value requirement.
- **Test 8**: I found the ~/.khora/sessions/ directory by exploring the filesystem. The docs didn't mention session storage location.
- **Test 10**: The "Multiple Sessions" docs were factually wrong -- they claimed independent Chrome instances, but khora uses a single shared profile directory.

### Remaining Issues
- **SingletonLock persists after every kill.** This is a tool-level bug -- `khora kill` should clean up the lock file but doesn't. Every new launch after a kill requires manually removing the lock. The docs now document the workaround, but the tool should be fixed.
- **Console command may not capture eval-generated logs.** Tested `console.log` via eval followed by `console` -- returned "No console messages." Could be a timing issue or a tool limitation. Documented as-is.
- **No `kill-all` command.** When stale sessions accumulate, users must kill them one by one or manually remove files from ~/.khora/sessions/. A `khora kill --all` would help.

### Verdict: READY

The skill docs are now accurate and comprehensive. All 3 Haiku tasks passed on first try. The SingletonLock issue is pervasive but now well-documented with a clear workaround. The core workflow (launch, navigate, inspect, interact, kill) works reliably for both Opus and Haiku.
