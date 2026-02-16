# Change Request Workflow

For modifying existing functionality.

## Task Hierarchy Pattern

```
Change: <description>
├── Analysis
│   ├── Understand current behavior
│   └── Define target behavior
├── Modify
│   ├── Update code
│   └── Update config/data
├── Test
│   ├── Test new behavior
│   └── Regression tests
└── Deploy (if applicable)
```

## Step-by-Step

### 1. Create Change Root

```bash
clipm add "Change: <description>"                  # → abcd
clipm note abcd "Reason: <why this change>"
```

### 2. Add Analysis Phase

```bash
clipm add "Analyze change impact" --parent abcd              # → efgh
clipm add "Document current behavior" --parent efgh          # → ijkl
clipm add "Define target behavior" --parent efgh             # → mnop
clipm add "Identify affected components" --parent efgh       # → qrst
```

### 3. Add Modification Phase

```bash
clipm add "Implement changes" --parent abcd                  # → uvwx
clipm add "Update <component 1>" --parent uvwx               # → yzab
clipm add "Update <component 2>" --parent uvwx               # → cdef

# Block on analysis
clipm block efgh uvwx
```

### 4. Add Testing

```bash
clipm add "Test changes" --parent abcd                       # → ghij
clipm add "Verify new behavior" --parent ghij                # → klmn
clipm add "Run regression suite" --parent ghij               # → opqr

clipm block uvwx ghij
```

### 5. Parallel Opportunities

- Analysis sub-tasks can often run in parallel
- Multiple component updates can run in parallel
- Different test types can run in parallel

## Example: Update API Response Format

```bash
clipm add "Change: Update user API to return camelCase"  # → abcd

# Analysis
clipm add "Analyze API change" --parent abcd             # → efgh
clipm add "List all affected endpoints" --parent efgh    # → ijkl
clipm add "Check client dependencies" --parent efgh      # → mnop
clipm add "Plan migration strategy" --parent efgh        # → qrst

# Modification
clipm add "Update API responses" --parent abcd           # → uvwx
clipm add "Update user endpoint" --parent uvwx           # → yzab
clipm add "Update profile endpoint" --parent uvwx        # → cdef
clipm add "Update settings endpoint" --parent uvwx       # → ghij

# Testing
clipm add "Test API changes" --parent abcd               # → klmn
clipm add "Test each endpoint response" --parent klmn    # → opqr
clipm add "Test client compatibility" --parent klmn      # → stuv

# Dependencies
clipm block ijkl qrst   # Migration plan needs endpoint list
clipm block mnop qrst   # Migration plan needs client info
clipm block efgh uvwx    # Modification after analysis
clipm block uvwx klmn    # Test after modification
```

Parallel execution:
- Wave 1: ijkl & mnop (endpoint list + client check)
- Wave 2: yzab, cdef, ghij (all endpoint updates)
- Wave 3: opqr & stuv (endpoint tests + client tests)

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
