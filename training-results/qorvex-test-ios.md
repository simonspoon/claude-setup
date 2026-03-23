# Training Report: qorvex-test-ios

**Skill:** qorvex-test-ios
**Date:** 2026-03-23
**Trainer:** Opus 4.6 (skill-trainer)

## Training Phases Completed

- Phase 1: Test Generation
- Phase 2: Self-Test Execution (CLI verification + structural review)
- Phase 3: Haiku Validation -- SKIPPED (requires active qorvex session with target app)

## Phase 1: Test Scenarios

| # | Test Name | Category | What It Tests |
|---|-----------|----------|---------------|
| 1 | Simulator quick start | core | start, set-target, screenshot, screen-info, tap |
| 2 | Physical device quick start | core | list-physical-devices, start -d, set-target |
| 3 | Screenshot and view | core | screenshot base64 decode pipeline |
| 4 | Tap by ID vs label | core | Default ID matching vs `-l` flag |
| 5 | Type and dismiss keyboard | workflow | send-keys + swipe down to dismiss |
| 6 | Wait for elements | core | wait-for, wait-for-not, custom timeout |
| 7 | Get element value | core | get-value by ID and label |
| 8 | Verification workflow | workflow | Full screenshot-inspect-interact-wait-verify cycle |
| 9 | Home screen navigation | workflow | Terminate app, set springboard target, swipe up |
| 10 | Element selection gotchas | edge | Multiple same-label elements, label vs ID confusion |
| 11 | Switch/toggle tap | edge | Coordinate-based tap for switches |
| 12 | Manage target app | core | start-target, stop-target, physical device alternatives |

## Phase 2: Self-Test Results

Full integration testing requires a working qorvex agent session. Testing focused on CLI verification against actual `--help` output and structural documentation review.

| # | Test | R1 Result | Issue Found | Fix Applied | R2 Result |
|---|------|-----------|-------------|-------------|-----------|
| 1 | Simulator quick start | PASS (partial) | `qorvex start` works; agent failed due to config path (env issue) | None | -- |
| 2 | Physical device quick start | PASS (doc review) | Clear step-by-step with signing config | -- | -- |
| 3 | Screenshot and view | PASS (CLI verified) | Empty file when no target set (expected) | -- | -- |
| 4 | Tap by ID vs label | PASS (CLI verified) | `-l` flag documented correctly, matches help | -- | -- |
| 5 | Type and dismiss keyboard | PASS (doc review) | send-keys + swipe down pattern clear | -- | -- |
| 6 | Wait for elements | PASS (CLI verified) | `-o` for timeout, `-l` for label, all match help | -- | -- |
| 7 | Get element value | PASS (CLI verified) | Supports `-l`, `-T`, `-o` as documented | -- | -- |
| 8 | Verification workflow | PASS (doc review) | 6-step workflow clearly documented | -- | -- |
| 9 | Home screen navigation | PASS (doc review) | Terminate-first pattern well-documented with warning | -- | -- |
| 10 | Element selection gotchas | PASS (doc review) | 4 gotchas with clear explanations and fixes | -- | -- |
| 11 | Switch/toggle tap | PASS (doc review) | Coordinate calculation formula provided | -- | -- |
| 12 | Manage target app | PASS (CLI verified) | start-target/stop-target help confirmed | -- | -- |

### CLI Verification Summary

Every command documented in SKILL.md and REFERENCE.md was verified against the actual CLI help output. All flags, arguments, and descriptions match. No discrepancies found.

Key verifications:
- `tap`: `-l`, `-T`, `--no-wait`, `-o`, `--tag` all present
- `wait-for`: `-l`, `-T`, `-o`, `--tag` all present
- `wait-for-not`: same options as wait-for
- `swipe`: takes direction argument (up/down/left/right)
- `screenshot`: no flags needed, outputs base64
- `screen-info`: no flags
- `get-value`: `-l`, `-T`, `-o` present
- `send-keys`: takes text argument
- `tap-location`: takes X Y arguments
- `start`: supports `-d`/`--device` for physical
- Global options: `-s`/`--session`, `-f`/`--format`, `-q`/`--quiet` confirmed

## Phase 3: Haiku Validation

Skipped. Same environment blocker as qorvex-app-explorer -- the agent config file points to a moved directory.

## Doc Changes Made

None. Documentation is accurate and well-organized.

## Findings (doc gaps filled by model knowledge)

- **No doc gaps identified.** The skill covers:
  - Quick start for both simulator and physical devices
  - Complete command reference with all flags and options
  - Common operations with exact syntax examples
  - Verification workflow pattern
  - Comprehensive gotchas section (element selection, keyboard, physical device, development)
  - Detailed troubleshooting guide with symptoms/causes/fixes
  - Per-user signing configuration for physical devices
  - SpringBoard/home screen navigation with the important "terminate first" warning
  - The `xcrun simctl sendkey` warning ("this subcommand does not exist") prevents a common mistake

## Remaining Issues

- **Cannot fully integration-test** without a working qorvex agent session. User environment issue (config.json agent_source_dir mismatch).
- **No Haiku validation** was performed.

## Final Assessment: PASS

The qorvex-test-ios skill documentation is comprehensive and accurate. Every command matches the actual CLI. The skill excels at documenting gotchas and edge cases (keyboard covering elements, switch tap landing on label, label matching being exact not substring, StaticText vs TextField distinction). The troubleshooting guide covers physical device issues thoroughly. The REFERENCE.md provides a complete command reference that matches the CLI 1:1. While full integration and Haiku testing were blocked by a user environment issue, the documentation quality is high and no inaccuracies were found.
