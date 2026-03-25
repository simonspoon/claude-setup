#!/bin/bash
# PostToolUse hook for Skill: sets a flag when a routable skill is invoked.
# Input comes via stdin as JSON.

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id','unknown'))" 2>/dev/null)
STATE_DIR="/tmp/claude-skill-state"
mkdir -p "$STATE_DIR"

# Extract the skill name from tool_input
SKILL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('skill',''))" 2>/dev/null)

# Map skill names to flag names (handle both short and namespaced forms)
case "$SKILL_NAME" in
  update-docs|swe-team:update-docs)
    touch "${STATE_DIR}/${SESSION_ID}-update-docs"
    ;;
  test-engineer|swe-team:test-engineer)
    touch "${STATE_DIR}/${SESSION_ID}-test-engineer"
    ;;
  code-reviewer|swe-team:code-reviewer)
    touch "${STATE_DIR}/${SESSION_ID}-code-reviewer"
    ;;
  software-engineering|swe-team:software-engineering)
    touch "${STATE_DIR}/${SESSION_ID}-software-engineering"
    ;;
  git-commit|swe-team:git-commit)
    touch "${STATE_DIR}/${SESSION_ID}-git-commit"
    ;;
esac

exit 0
