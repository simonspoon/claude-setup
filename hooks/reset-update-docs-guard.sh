#!/usr/bin/env bash
# Clear the update-docs guard so it can trigger again after this new prompt
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
GUARD_FILE="/tmp/claude-update-docs-guard-$(echo "$REPO_ROOT" | md5 -q)"
rm -f "$GUARD_FILE"
