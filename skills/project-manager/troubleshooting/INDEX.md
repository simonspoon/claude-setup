# Troubleshooting Index

| Problem | Symptoms | Link |
|---------|----------|------|
| **Command Failures** | clipm returns error | [command-errors.md](command-errors.md) |
| **Subagent Failures** | Agent reports failure or times out | [subagent-failures.md](subagent-failures.md) |
| **Stuck Tasks** | Tasks remain in-progress indefinitely | [stuck-tasks.md](stuck-tasks.md) |
| **File Conflicts** | Parallel tasks overwrote each other | [file-conflicts.md](file-conflicts.md) |

## Quick Diagnosis

```mermaid
flowchart TD
    A[Problem detected] --> B{clipm command failed?}
    B -->|Yes| C[command-errors.md]
    B -->|No| D{Subagent returned failure?}
    D -->|Yes| E[subagent-failures.md]
    D -->|No| F{Task stuck in-progress?}
    F -->|Yes| G[stuck-tasks.md]
    F -->|No| H{Unexpected file state?}
    H -->|Yes| I[file-conflicts.md]
    H -->|No| J[Check clipm tree for status]
```

Back to [SKILL.md](../SKILL.md)
