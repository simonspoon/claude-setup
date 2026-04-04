---
name: version
description: >
  Print the current swe-team plugin version. Reads the version dynamically
  from .claude-plugin/plugin.json.
---

## Steps

1. **Read plugin.json** — read the file `.claude-plugin/plugin.json` from the plugin root directory.
2. **Extract the version** — parse the `version` field from the JSON.
3. **Print** — output the version in this exact format: `swe-team v{version}` (e.g., `swe-team v1.23.0`).

Do not hardcode the version. Always read it from plugin.json at invocation time.
