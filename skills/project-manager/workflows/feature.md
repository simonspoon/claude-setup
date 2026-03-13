# Feature Implementation Workflow

For adding a single feature to an existing codebase.

> **Note:** All `limbo add` calls require `--action`, `--verify`, `--result` flags. All `limbo status <id> done` calls require `--outcome`. Examples below use abbreviated form for readability — fill in the structured fields for each task when creating.

## Task Hierarchy Pattern

```
Feature: <name>
├── Design
│   ├── Analyze requirements
│   └── Define approach
├── Implementation
│   ├── Core logic
│   └── Integration points
├── Testing
│   ├── Unit tests
│   └── Integration tests
└── Documentation (if needed)
```

## Step-by-Step

### 1. Create Feature Root

```bash
limbo add "Feature: <name>" \
  --action "Complete all child tasks for <name>" \
  --verify "All children done, integration test passes" \
  --result "Summary of feature implementation"              # → abcd
```

### 2. Add Phases

```bash
# Design phase
limbo add "Design: <feature>" --parent abcd              # → efgh
limbo add "Analyze requirements" --parent efgh            # → ijkl
limbo add "Define implementation approach" --parent efgh  # → mnop

# Implementation
limbo add "Implement: <feature>" --parent abcd            # → qrst
limbo add "Core logic" --parent qrst                      # → uvwx
limbo add "Integration with existing code" --parent qrst  # → yzab

# Testing
limbo add "Test: <feature>" --parent abcd                 # → cdef
limbo add "Unit tests" --parent cdef                      # → ghij
limbo add "Integration tests" --parent cdef               # → klmn
```

### 3. Set Dependencies

```bash
# Implementation depends on design
limbo block efgh qrst

# Testing depends on implementation
limbo block qrst cdef
```

### 4. Dispatch Design Phase

Start with design tasks (can run in parallel if independent):

```bash
limbo claim ijkl design-analyst
limbo status ijkl in-progress
```

### 5. Progress Through Phases

As each phase completes, next phase unblocks automatically.

## Example: Add Search Feature

```bash
limbo add "Feature: Full-text search"                         # → abcd

limbo add "Design search" --parent abcd                       # → efgh
limbo add "Research search libraries" --parent efgh           # → ijkl
limbo add "Design search index schema" --parent efgh          # → mnop

limbo add "Implement search" --parent abcd                    # → qrst
limbo add "Set up search engine" --parent qrst                # → uvwx
limbo add "Index existing content" --parent qrst              # → yzab
limbo add "Search API endpoint" --parent qrst                 # → cdef

limbo add "Test search" --parent abcd                         # → ghij
limbo add "Unit tests for search logic" --parent ghij         # → klmn
limbo add "E2E search tests" --parent ghij                    # → opqr

# Dependencies
limbo block efgh qrst   # Implement after design
limbo block qrst ghij   # Test after implement
limbo block uvwx yzab   # Index after engine setup
```

Parallel opportunities:
- ijkl & mnop (research + schema design)
- uvwx & cdef (engine setup + API can start together)
- klmn & opqr (unit + E2E tests)

## iOS Features

If the feature involves iOS UI changes, add a verification task using `/qorvex-test-ios`:

```bash
limbo add "Verify iOS UI changes" --parent ghij \
  --action "Run qorvex screenshot + screen-info to verify UI" \
  --verify "Screenshots show expected layout, elements are tappable" \
  --result "Before/after screenshots confirming feature works"
```

This task should depend on the implementation phase and run as part of (or alongside) testing.

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
