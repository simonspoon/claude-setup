# Workflow Index

```mermaid
flowchart TD
    A[User Request] --> B{New system/project?}
    B -->|Yes| C[new-project.md]
    B -->|No| D{Adding new functionality?}
    D -->|Yes| E[feature.md]
    D -->|No| F{Fixing broken behavior?}
    F -->|Yes| G[bug-fix.md]
    F -->|No| H[change-request.md]
```

| Workflow | Use When | Link |
|----------|----------|------|
| **New Project** | Building new system or major feature set | [new-project.md](new-project.md) |
| **Feature** | Adding single feature to existing code | [feature.md](feature.md) |
| **Bug Fix** | Investigating and fixing a bug | [bug-fix.md](bug-fix.md) |
| **Change Request** | Modifying existing functionality | [change-request.md](change-request.md) |

Back to [SKILL.md](../SKILL.md)
