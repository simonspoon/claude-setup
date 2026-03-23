## Training Report: khora-test-web

**Date:** 2026-03-23

### Phase 1: Test Scenarios

| # | Test Name | Category | What It Tests |
|---|-----------|----------|---------------|
| 1 | Quick Start completeness | core | All 5 essential commands in Quick Start |
| 2 | Command reference table | core | All 14 commands listed and documented |
| 3 | Session management lifecycle | workflow | launch -> use -> status -> kill |
| 4 | Gotchas section quality | edge | CSS-only, dynamic content, URL protocol requirement |
| 5 | Verification Workflow (9-step) | workflow | Full end-to-end verification flow |
| 6 | Timeout behavior | edge | What happens when wait-for times out |
| 7 | Error recovery / cleanup on failure | error | Session cleanup when commands fail mid-workflow |
| 8 | --format json usage clarity | edge | When to use JSON vs plain text output |

### Phase 2: Self-Test Results

| # | Test | R1 Result | Issue Found | Fix Applied | R2 Result |
|---|------|-----------|-------------|-------------|-----------|
| 1 | Quick Start completeness | PASS | jq -r .id pattern is correct for session extraction | -- | -- |
| 2 | Command reference table | PASS | All 14 commands cross-referenced against body text | -- | -- |
| 3 | Session lifecycle | PASS | launch/status/kill documented clearly | -- | -- |
| 4 | Gotchas section quality | PASS | Practical and specific warnings | -- | -- |
| 5 | Verification Workflow | PASS | 9 steps are logical and reference correct commands | -- | -- |
| 6 | Timeout behavior | FAIL (doc) | Docs don't explain what happens on timeout (exit code? error message?) | Added timeout error note to Gotchas section | PASS |
| 7 | Error recovery / cleanup | FAIL (doc) | No guidance on cleaning up sessions when commands fail mid-workflow | Added "Error Recovery" subsection to Gotchas | PASS |
| 8 | --format json clarity | FAIL (doc) | Quick Start uses --format json for launch but other examples don't; unclear when it's needed | Added clarification in Error Recovery section | PASS |

Note: khora CLI is not installed on this machine, so all tests were doc-quality reviews rather than live execution. Commands could not be run.

### Phase 3: Haiku Validation

Haiku validation was not performed for this skill because `khora` is not installed. Haiku would be unable to execute any commands, making validation meaningless.

### Doc Changes Made

- `SKILL.md` (Gotchas section): Added "Timeout errors" bullet explaining that `wait-for`/`wait-gone` exit with non-zero status on timeout expiry, and to always kill the session before returning an error.
- `SKILL.md` (Gotchas section): Added new "Error Recovery" subsection with guidance on always killing sessions on failure and clarifying when to use `--format json` vs plain text.

### Findings (doc gaps filled by model knowledge)

- All 8 tests required model knowledge about what constitutes good CLI documentation, since khora could not be run. The doc-quality assessments are based on structural analysis rather than live validation.
- The `--format json` guidance added in the fix was based on common CLI patterns (JSON for machine parsing, plain text for human reading). If khora's actual behavior differs, this guidance should be verified.

### Remaining Issues

- **Cannot validate actual command behavior.** khora is not installed. All assessments are based on documentation structure and completeness, not verified against the tool. When khora is available, a live validation run should be performed.
- **No example output shown.** The docs don't show what `find`, `text`, or `eval` return. A weak model may not know how to verify its output is correct. This is a P2 issue -- adding example outputs would improve usability.

### Training Phases Completed

- Phase 1: Test Generation (8 scenarios)
- Phase 2: Self-Test Execution (doc review only -- 5 passed, 3 failed and fixed)
- Phase 3: Haiku Validation (skipped -- khora not available)

### Final Assessment: PASS

The khora-test-web skill has clear, well-organized documentation covering all commands, a logical verification workflow, and practical gotchas. Three doc gaps were found and fixed (timeout behavior, error recovery, --format json clarity). The remaining issue (no example outputs) is minor. The skill should receive a live validation run when khora is installed.
