---
name: release
description: Cut a versioned release for a Rust CLI or Tauri app. Bumps version, commits, tags, pushes, and verifies CI release + Homebrew tap update. Use when releasing a tool, cutting a release, bumping version, tagging a release, or publishing to Homebrew.
---

# Release

Cut a versioned release for a project with CI-driven binary builds and Homebrew distribution.

## When to Use

- User says "release", "cut a release", "bump version", "tag and push"
- A tool is ready for a new version

## Prerequisites

- Project has `.github/workflows/release.yml` triggered by `v*` tags
- Project has a Homebrew formula in `simonspoon/homebrew-tap`
- `gh` CLI authenticated

## Activation Protocol

### Step 1: Determine Version

Ask if not provided. Use semver: patch for fixes, minor for features, major for breaking changes.

### Step 2: Find All Version Files

Detect and list every file that contains a version string to bump:

```bash
# Always present for Rust projects
grep -rn 'version = "' Cargo.toml | head -5

# Tauri projects (wisp)
find . -name "tauri.conf.json" -maxdepth 4 2>/dev/null
find . -name "package.json" -maxdepth 3 2>/dev/null | grep -v node_modules
```

Common version file patterns:
| Project type | Files to bump |
|---|---|
| Single-crate Rust | `Cargo.toml` |
| Workspace Rust | Root `Cargo.toml` + member `Cargo.toml` files (check `[workspace.package]`) |
| Tauri app | `Cargo.toml`(s) + `tauri.conf.json` + `package.json` |

### Step 3: Bump Versions

Update ALL version files found in Step 2. Verify each change with a diff.

### Step 4: Run Checks

```bash
# Rust projects
cargo fmt --check && cargo clippy --workspace --all-targets -- -D warnings
cargo test --workspace
```

If checks fail, fix before proceeding.

### Step 5: Commit and Tag

Use `/swe-team:git-commit` for the commit. Message format: `bump version to X.Y.Z for release`

Then tag:
```bash
git tag vX.Y.Z
```

### Step 6: Push

```bash
git push && git push --tags
```

This triggers the release workflow.

### Step 7: Verify Release

1. Wait for CI to complete:
   ```bash
   gh run list --limit 3
   ```
2. Check all jobs passed:
   ```bash
   gh run view <RUN_ID> --json jobs -q '.jobs[] | "\(.name): \(.conclusion)"'
   ```
3. Verify release assets exist:
   ```bash
   gh release view vX.Y.Z --json assets -q '.assets[].name'
   ```

### Step 8: Verify Homebrew Tap

The release workflow dispatches an auto-update to `simonspoon/homebrew-tap`. Verify it succeeded:

```bash
gh run list --repo simonspoon/homebrew-tap --limit 3
```

If the tap update failed, run the update manually:
```bash
cd ~/claudehub/homebrew-tap
bash scripts/update-formula.sh <FORMULA_NAME> <VERSION> <OWNER/REPO>
# Then commit and push
```

## Gotchas

- **Formula name may differ from tool name.** wisp uses `wisp-cli` as the formula name. Check `~/claudehub/homebrew-tap/Formula/` for the actual filename.
- **Workspace versions.** If `Cargo.toml` uses `[workspace.package] version = "X"`, member crates may use `version.workspace = true`. Only bump the workspace root.
- **Tag format.** Always `vX.Y.Z` with the `v` prefix. Release workflows trigger on `v*` tags.
- **Don't skip tests.** A failed release wastes CI minutes and creates a broken tag. Always run tests locally first.
