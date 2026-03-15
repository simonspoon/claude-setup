#!/usr/bin/env bash
# Guard: only trigger update-docs once per user-prompt cycle
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
GUARD_FILE="/tmp/claude-update-docs-guard-$(echo "$REPO_ROOT" | md5 -q)"

# If guard flag exists, we already triggered for this cycle → skip
[ -f "$GUARD_FILE" ] && exit 0

# Check for uncommitted code changes (exclude doc files to avoid self-triggering)
CODE_CHANGES=$(git diff HEAD --name-only 2>/dev/null | grep -v -E '^(docs/|README\.md|.*\.md$)' | head -1)

# No code changes → nothing to document
[ -z "$CODE_CHANGES" ] && exit 0

# Set guard flag and trigger
touch "$GUARD_FILE"
echo "You just finished a task. Run /update-docs now to keep documentation in sync with the code changes you made."
