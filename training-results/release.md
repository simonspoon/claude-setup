## Training Report: release

### Phase 1: Test Scenarios
| # | Test Name | Category | What It Tests |
|---|-----------|----------|---------------|
| 1 | Single-crate version discovery | Core op | grep/find commands identify Cargo.toml version in helios/nyx |
| 2 | Workspace version discovery | Core op | Detects workspace.package pattern and member inheritance in wisp |
| 3 | Tauri version discovery | Core op | Finds tauri.conf.json and package.json alongside Cargo.toml |
| 4 | Version bump dry-run (single crate) | Workflow | Edit Cargo.toml version, verify diff, revert |
| 5 | Version bump dry-run (Tauri workspace) | Workflow | Bump all 3 file types for wisp, verify diffs, revert |
| 6 | Run checks command | Core op | cargo fmt --check, clippy, and test commands work |
| 7 | Tag format validation | Edge case | vX.Y.Z format matches release.yml v* trigger |
| 8 | Release verification commands | Core op | gh run list, gh run view, gh release view work with documented flags |
| 9 | Homebrew formula name gotcha | Edge case | wisp-cli.rb vs wisp naming confirmed in Formula/ |
| 10 | Manual tap update fallback | Error recovery | update-formula.sh usage and argument format |

### Phase 2: Self-Test Results
| # | Test | R1 Result | Issue Found | Fix Applied | R2 Result |
|---|------|-----------|-------------|-------------|-----------|
| 1 | Single-crate version discovery | PASS | -- | -- | -- |
| 2 | Workspace version discovery | PASS (doc gap) | No command to check version.workspace = true in members | Added grep command for workspace inheritance check in Step 2; clarified table to say "Root Cargo.toml only" | PASS |
| 3 | Tauri version discovery | PASS | -- | -- | -- |
| 4 | Version bump dry-run (single) | PASS | -- | -- | -- |
| 5 | Version bump dry-run (Tauri) | PASS | -- | -- | -- |
| 6 | Run checks command | PASS | -- | -- | -- |
| 7 | Tag format validation | PASS | -- | -- | -- |
| 8 | Release verification commands | PASS | -- | -- | -- |
| 9 | Homebrew formula name gotcha | PASS | -- | -- | -- |
| 10 | Manual tap update fallback | PASS (doc gap) | Docs missing: VERSION must not have v prefix; no commit/push commands after script | Added VERSION_WITHOUT_V placeholder, example, warning, and git commit+push commands | PASS |

### Phase 3: Haiku Validation
| # | Task Sent to Haiku | What Haiku Did | Result | Doc Fix |
|---|-------------------|----------------|--------|---------|
| 1 | Find all version files for wisp project | Loaded skill, found all 8 Cargo.toml + tauri.conf.json + package.json files, correctly identified 3 files to bump and 5 workspace-inherited members | PASS | None needed |
| 2 | Run pre-release checks on helios (Step 4) | Ran cargo fmt --check, cargo clippy, cargo test with exact documented flags; reported 32 tests passing | PASS | None needed |
| 3 | Verify helios v0.1.0 release (Steps 7-8) | Ran gh run list, gh run view with jq query, gh release view, and homebrew tap check; correctly identified update-tap failure and subsequent recovery | PASS | None needed |

### Doc Changes Made
- `skills/release/SKILL.md` Step 2: Added `grep -rn 'version.workspace = true' **/Cargo.toml` command to discover workspace version inheritance. Clarified table: "Workspace Rust" row now says "Root Cargo.toml only (if members use version.workspace = true)" and "Tauri app" row says "Root Cargo.toml + tauri.conf.json + package.json".
- `skills/release/SKILL.md` Step 8: Changed `<VERSION>` to `<VERSION_WITHOUT_V>` in update-formula.sh usage. Added concrete example (`bash scripts/update-formula.sh limbo 0.2.0 simonspoon/limbo`). Added explicit warning that version must NOT have v prefix. Added `git add -A && git commit && git push` command after script invocation.

### Findings (doc gaps filled by model knowledge)
- Test 2: I knew to check member crate Cargo.toml files for `version.workspace = true` from Rust workspace knowledge, not from the docs. The docs mentioned this in Gotchas but didn't provide a discovery command. Fixed.
- Test 4: The docs say "Update ALL version files" but don't specify a mechanism (sed, editor, etc.). This worked fine for both Opus and Haiku since both are capable of editing files. Not a real gap.
- Test 10: I knew the update-formula.sh script expects version without v prefix because I read the script header, but a user following only the SKILL.md would not know this. Fixed.

### Remaining Issues
- None. All tests pass after Round 2 fixes.

### Verdict: READY
