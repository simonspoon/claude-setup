#!/usr/bin/env bash
# test-suda-hooks.sh — Evaluate recall quality of suda-context.sh
#
# Usage: bash test-suda-hooks.sh [--verbose]
#
# Each test case: a realistic user prompt + the memory IDs it SHOULD surface.
# Measures recall rate: did the expected memories appear in the top results?

set -euo pipefail

VERBOSE=0
[ "${1:-}" = "--verbose" ] && VERBOSE=1

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONTEXT_HOOK="${CONTEXT_HOOK:-$SCRIPT_DIR/../scripts/suda-context.sh}"
LIMIT=5  # how many results we expect the hook to return at most

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Test case format ---
# test_case "PROMPT" "EXPECTED_ID1,EXPECTED_ID2,..." "description"
#
# A test PASSES if at least one expected ID appears in the output.
# We track both hit/miss and which IDs were found.

declare -a TEST_PROMPTS=()
declare -a TEST_EXPECTED=()
declare -a TEST_DESCS=()

add_test() {
  TEST_PROMPTS+=("$1")
  TEST_EXPECTED+=("$2")
  TEST_DESCS+=("$3")
}

# --- Test Cases ---
# Format: prompt | expected memory IDs (comma-sep) | description

# 1. Natural language about git commits — should find commit preferences
add_test "how should I commit" \
  "28,20" \
  "Commit conventions: should surface no-co-authored-by and git-workflow"

# 2. Co-authored-by specifically — should find the feedback
add_test "should I use co-authored-by" \
  "28" \
  "Exact topic match: co-authored-by preference"

# 3. Git conventions
add_test "what are the git conventions" \
  "20,28" \
  "Git workflow and commit conventions"

# 4. User background
add_test "what do you know about the user" \
  "17,18,19,22" \
  "User profile: background, communication, preferences"

# 5. Release process
add_test "how to release a new version" \
  "53,41,54" \
  "Release: cargo lock, brew install, lint before push"

# 6. Ordis description
add_test "what is ordis" \
  "58,46,39" \
  "Ordis project: status, layout, approvals"

# 7. Agent dispatching
add_test "how should agents be dispatched" \
  "44,51,50" \
  "Agent patterns: sonnet for lightweight, PM/tech-lead split, no inline tier"

# 8. loki click issues
add_test "loki clicking problems" \
  "48,52,47" \
  "Loki clicks: CGEvent activation, screen coords, webview resolved"

# 9. Installing tools
add_test "I need to install a tool" \
  "41,29" \
  "Tool installation: brew preference, homebrew cask support"

# 10. Verification habits
add_test "remember to verify changes" \
  "9,11,36,30" \
  "Verification practices: always-verify, e2e launch, proactive loki, session state"

# 11. Formatting Rust code
add_test "formatting rust code" \
  "40" \
  "Rust formatting: cargo fmt before commit"

# 12. Claude Code hooks
add_test "how do hooks work in claude code" \
  "35,33,25" \
  "Hook mechanics: stdin JSON input, enforcement system, speak hook"

# 13. SolidJS reactivity
add_test "solidjs reactivity issues" \
  "38" \
  "SolidJS store deep-clone gotcha"

# 14. Homebrew
add_test "homebrew formula" \
  "29,41,32" \
  "Homebrew: cask support, brew installs, runtime vs install-time"

# 15. Team philosophy
add_test "what is the team philosophy" \
  "8,23" \
  "Team principles: unix philosophy, mission"

# 16. Plugin cache
add_test "plugin cache is stale" \
  "26,24" \
  "Plugin management: cache sync, plugin workflow"

# 17. Tauri PTY terminal
add_test "tauri pty terminal" \
  "43,58" \
  "Tauri: PTY gotchas, ordis status"

# 18. Working on the ordis project
add_test "I'm working on ordis" \
  "58,46,37,39" \
  "Ordis project memories: status, layout, user events, approvals"

# 19. Process and discipline
add_test "what are the process rules" \
  "22,50,9" \
  "Process: discipline, no inline tier, always verify"

# 20. iOS testing
add_test "how to test ios apps" \
  "31" \
  "iOS testing: qorvex agent must build locally"

# --- Build ID-to-name cache (bash 3 compatible) ---
NAME_CACHE=$(mktemp)
trap "rm -f $NAME_CACHE" EXIT
suda recall --limit 100 --json 2>/dev/null | python3 -c "
import json,sys
data=json.load(sys.stdin)
for m in data:
    print(f'{m[\"id\"]}|{m[\"name\"]}')
" > "$NAME_CACHE" 2>/dev/null

lookup_name() {
  local eid="$1"
  grep "^${eid}|" "$NAME_CACHE" | head -1 | cut -d'|' -f2
}

# --- Runner ---

run_test() {
  local idx=$1
  local prompt="${TEST_PROMPTS[$idx]}"
  local expected="${TEST_EXPECTED[$idx]}"
  local desc="${TEST_DESCS[$idx]}"

  # Feed the hook a simulated UserPromptSubmit payload
  local payload
  payload=$(printf '{"prompt":"%s"}' "$prompt")

  local output
  output=$(echo "$payload" | bash "$CONTEXT_HOOK" 2>/dev/null) || true

  # Check which expected IDs appear in the output
  local found=()
  local missed=()
  IFS=',' read -ra exp_ids <<< "$expected"

  for eid in "${exp_ids[@]}"; do
    eid=$(echo "$eid" | tr -d ' ')
    local mname
    mname=$(lookup_name "$eid")

    if [ -n "$mname" ] && echo "$output" | grep -qi "$mname"; then
      found+=("$eid:$mname")
    else
      missed+=("$eid:${mname:-unknown}")
    fi
  done

  local hit=0
  [ ${#found[@]} -gt 0 ] && hit=1

  if [ $VERBOSE -eq 1 ]; then
    if [ $hit -eq 1 ]; then
      echo -e "${GREEN}PASS${NC} [$((idx+1))] $desc" >&2
    else
      echo -e "${RED}FAIL${NC} [$((idx+1))] $desc" >&2
    fi
    echo -e "  ${CYAN}Prompt:${NC} $prompt" >&2
    if [ ${#found[@]} -gt 0 ]; then
      echo -e "  ${GREEN}Found:${NC} ${found[*]}" >&2
    fi
    if [ ${#missed[@]} -gt 0 ]; then
      echo -e "  ${RED}Missed:${NC} ${missed[*]}" >&2
    fi
    if [ -n "$output" ]; then
      echo -e "  ${YELLOW}Output:${NC}" >&2
      echo "$output" | head -5 | sed 's/^/    /' >&2
    else
      echo -e "  ${YELLOW}Output:${NC} (empty)" >&2
    fi
    echo "" >&2
  fi

  echo "$hit"
}

# --- Main ---

echo -e "${BOLD}=== Suda Hook Recall Test Harness ===${NC}"
echo -e "Testing: $CONTEXT_HOOK"
echo -e "Cases: ${#TEST_PROMPTS[@]}"
echo ""

total=${#TEST_PROMPTS[@]}
passes=0
fails=0

for ((i=0; i<total; i++)); do
  # run_test sends verbose output to stderr, hit value (0/1) to stdout
  hit=$(run_test $i)

  if [ "$hit" = "1" ]; then
    ((passes++))
  else
    ((fails++))
    if [ $VERBOSE -eq 0 ]; then
      echo -e "${RED}FAIL${NC} [$((i+1))] ${TEST_DESCS[$i]} — prompt: \"${TEST_PROMPTS[$i]}\""
    fi
  fi
done

echo ""
echo -e "${BOLD}=== Scorecard ===${NC}"
echo -e "Total:  $total"
echo -e "${GREEN}Pass:   $passes${NC}"
echo -e "${RED}Fail:   $fails${NC}"
pct=$((passes * 100 / total))
echo -e "Rate:   ${pct}%"
echo ""

if [ $pct -ge 80 ]; then
  echo -e "${GREEN}${BOLD}GOOD${NC} — recall rate is strong"
elif [ $pct -ge 50 ]; then
  echo -e "${YELLOW}${BOLD}FAIR${NC} — recall rate needs improvement"
else
  echo -e "${RED}${BOLD}POOR${NC} — recall rate is unacceptable"
fi
