# Workflow Index

```mermaid
flowchart TD
    A[User Request] --> B{Full cycle needed?}
    B -->|Yes: plan+implement+test+review+deliver| C[swe-full-cycle.md]
    B -->|No| D{New system/project?}
    D -->|Yes| E[new-project.md]
    D -->|No| F{Adding new functionality?}
    F -->|Yes| G[feature.md]
    F -->|No| H{Fixing broken behavior?}
    H -->|Yes| I[bug-fix.md]
    H -->|No| J[change-request.md]
```

| Workflow | Use When | Link |
|----------|----------|------|
| **SWE Full Cycle** | End-to-end: plan → implement → test → review → deliver | [swe-full-cycle.md](swe-full-cycle.md) |
| **New Project** | Building new system or major feature set | [new-project.md](new-project.md) |
| **Feature** | Adding single feature to existing code | [feature.md](feature.md) |
| **Bug Fix** | Investigating and fixing a bug | [bug-fix.md](bug-fix.md) |
| **Change Request** | Modifying existing functionality | [change-request.md](change-request.md) |

Back to [SKILL.md](../SKILL.md)
