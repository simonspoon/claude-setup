#!/bin/bash
# SessionStart hook: clear stale skill flags from prior sessions.
# Input comes via stdin as JSON.

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id','unknown'))" 2>/dev/null)
STATE_DIR="/tmp/claude-skill-state"

# Clean up any flags older than 24 hours (stale sessions)
if [ -d "$STATE_DIR" ]; then
  find "$STATE_DIR" -type f -mmin +1440 -delete 2>/dev/null
fi

# Clear current session flags so we start fresh
rm -f "${STATE_DIR}/${SESSION_ID}-"* 2>/dev/null

exit 0
