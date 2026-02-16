# New Project Workflow

For building new systems or major feature sets from scratch.

## Task Hierarchy Pattern

```
Project Root
├── Infrastructure
│   ├── Project setup
│   ├── Dependencies
│   └── CI/CD config
├── Core Features
│   ├── Feature A
│   │   ├── Design
│   │   ├── Implement
│   │   └── Test
│   └── Feature B
│       ├── Design
│       ├── Implement
│       └── Test
├── Integration
│   ├── API contracts
│   └── Integration tests
└── Documentation
    ├── README
    └── API docs
```

## External Tool Discovery

Before creating implementation tasks that use external CLI tools:

1. **Check if installed:** `which <tool>` or `<tool> --version`
2. **Get command help:** `<tool> --help` and `<tool> <subcommand> --help`
3. **Test actual output:** Run a real command and inspect output format
4. **Document in task:** Include exact command syntax in task description

Example for CLI tool:
```bash
# Discover axe CLI
axe --help                    # List subcommands
axe describe-ui --help        # Get actual flags
axe describe-ui --udid $UDID | head -50  # See real output format
```

**Do NOT assume API shape from documentation or memory - verify first.**

## Step-by-Step

### 1. Create Root Task

```bash
clipm add "Project: <name>"              # → abcd
```

### 2. Add Infrastructure Tasks

```bash
clipm add "Infrastructure setup" --parent abcd              # → efgh
clipm add "Initialize project structure" --parent efgh       # → ijkl
clipm add "Configure dependencies" --parent efgh             # → mnop
clipm add "Set up CI/CD" --parent efgh                       # → qrst
```

### 3. Add Feature Tasks

For each major feature:

```bash
clipm add "Feature: User Authentication" --parent abcd      # → uvwx

clipm add "Design auth flow" --parent uvwx                   # → yzab
clipm add "Implement auth logic" --parent uvwx               # → cdef
clipm add "Write auth tests" --parent uvwx                   # → ghij

# Set dependencies
clipm block yzab cdef   # Implement blocked by Design
clipm block cdef ghij   # Tests blocked by Implement
```

### 4. Add Integration & Docs

```bash
clipm add "Integration" --parent abcd                        # → klmn
clipm add "Documentation" --parent abcd                      # → opqr
```

### 5. Identify Parallel Work

Initial parallel tasks (no dependencies):
- Project structure setup
- Design tasks for independent features

```bash
clipm list --status todo
```

### 6. Dispatch

Spawn subagents for independent tasks. See [parallel.md](../orchestration/parallel.md).

## Example: REST API Project

```bash
clipm add "REST API for User Management"                  # → abcd

# Infrastructure
clipm add "Infrastructure" --parent abcd                   # → efgh
clipm add "Init Node.js project" --parent efgh             # → ijkl
clipm add "Configure TypeScript" --parent efgh             # → mnop
clipm add "Set up Express" --parent efgh                   # → qrst

# Features
clipm add "User CRUD endpoints" --parent abcd              # → uvwx
clipm add "Design user schema" --parent uvwx               # → yzab
clipm add "Implement endpoints" --parent uvwx              # → cdef
clipm add "Write endpoint tests" --parent uvwx             # → ghij

# Dependencies
clipm block ijkl mnop   # TS after Node init
clipm block mnop qrst   # Express after TS
clipm block yzab cdef   # Impl after design
clipm block cdef ghij   # Tests after impl
```

Parallel execution waves:
1. Wave 1: ijkl, yzab (init + design)
2. Wave 2: mnop, cdef (after wave 1)
3. Wave 3: qrst, ghij (after wave 2)

Back to [INDEX.md](INDEX.md) | [SKILL.md](../SKILL.md)
