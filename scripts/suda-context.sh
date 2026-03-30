#!/usr/bin/env bash
# suda-context.sh — inject relevant suda memories as context
# Multi-query strategy: raw prompt, keyword OR, project-filtered, deduped
payload="$(cat)"
prompt="$(echo "$payload" | jq -r '.prompt // empty')"
[ -z "$prompt" ] && exit 0

# --- Stop words to strip for keyword extraction ---
STOP_WORDS="i me my we our you your he she it its they them their this that these those a an the is am are was were be been being have has had do does did will would shall should can could may might must need ought dare of in to for on with at by from as into about between through during before after above below up down out off over under again further then once here there when where why how what which who whom all each every both few more most other some such no not only own same so than too very just"

# --- Extract content keywords ---
extract_keywords() {
  local text="$1"
  # Lowercase, strip punctuation, split to words
  local words
  words=$(echo "$text" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]' ' ')

  local result=""
  for word in $words; do
    # Skip stop words and very short words
    [ ${#word} -lt 3 ] && continue
    case " $STOP_WORDS " in
      *" $word "*) continue ;;
    esac
    if [ -n "$result" ]; then
      result="$result OR $word"
    else
      result="$word"
    fi
  done
  echo "$result"
}

# --- Detect project from cwd ---
detect_project() {
  local cwd
  cwd=$(pwd 2>/dev/null)
  [ -z "$cwd" ] && return

  # Try to match cwd against registered project paths
  local projects
  projects=$(suda projects --json 2>/dev/null) || return
  echo "$projects" | python3 -c "
import json, sys, os
cwd = '$cwd'
projects = json.load(sys.stdin)
# Find the project whose path is a prefix of cwd (longest match)
best = None
for p in projects:
    path = os.path.expanduser(p['path'])
    if cwd.startswith(path) and (best is None or len(path) > len(best[1])):
        best = (p['name'], path)
if best:
    print(best[0])
" 2>/dev/null
}

# --- Collect results, dedup by memory name ---
SEEN_FILE=$(mktemp)
trap "rm -f $SEEN_FILE" EXIT

collect() {
  local query="$1"
  local extra_args="$2"
  [ -z "$query" ] && [ -z "$extra_args" ] && return

  local results
  if [ -n "$query" ]; then
    results=$(suda recall "$query" --limit 5 $extra_args --json 2>/dev/null) || return
  else
    results=$(suda recall --limit 5 $extra_args --json 2>/dev/null) || return
  fi

  echo "$results" | python3 -c "
import json, sys
seen_file = '$SEEN_FILE'
# Read already-seen names
try:
    with open(seen_file) as f:
        seen = set(f.read().strip().split('\n'))
except:
    seen = set()

data = json.load(sys.stdin)
new_names = []
for m in data:
    if m['name'] not in seen and m['name']:
        seen.add(m['name'])
        new_names.append(m['name'])
        proj = m.get('project') or '-'
        strength = m.get('strength', 1)
        desc = m['description']
        if len(desc) > 60:
            desc = desc[:57] + '...'
        print(f'{m[\"id\"]:<7} {m[\"type\"]:<12} {m[\"name\"]:<35} {desc:<62} {strength:<6} {proj}')

# Write updated seen set
with open(seen_file, 'w') as f:
    f.write('\n'.join(seen))
" 2>/dev/null
}

# --- Strategy 1: Raw prompt ---
raw_results=$(collect "$prompt" "")

# --- Strategy 2: Keyword OR query ---
keywords=$(extract_keywords "$prompt")
kw_results=""
if [ -n "$keywords" ] && [ "$keywords" != "$prompt" ]; then
  kw_results=$(collect "$keywords" "")
fi

# --- Strategy 3: Project-filtered recall ---
project=$(detect_project)
proj_results=""
if [ -n "$project" ]; then
  proj_results=$(collect "" "--project $project")
fi

# --- Combine and output ---
all_results=""
[ -n "$raw_results" ] && all_results="$raw_results"
if [ -n "$kw_results" ]; then
  [ -n "$all_results" ] && all_results="$all_results
$kw_results" || all_results="$kw_results"
fi
if [ -n "$proj_results" ]; then
  [ -n "$all_results" ] && all_results="$all_results
$proj_results" || all_results="$proj_results"
fi

[ -z "$all_results" ] && exit 0

# Format with header
echo "ID      TYPE         NAME                                DESCRIPTION                                                    STR   PROJECT     "
echo "-------------------------------------------------------------------------------------------------------------------------------------"
echo "$all_results"
