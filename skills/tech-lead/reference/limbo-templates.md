# limbo Templates

limbo ships built-in templates that scaffold entire task hierarchies with one command. Use these instead of manually creating task trees for common workflows.

## Commands

```bash
limbo template list                    # List available templates (JSON)
limbo template list --pretty           # Human-readable list
limbo template show <name>             # Show template's task hierarchy (JSON)
limbo template show <name> --pretty    # Human-readable hierarchy
limbo template apply <name>            # Create all tasks from template
limbo template apply <name> --parent <id>  # Nest under existing task
```

`apply` creates all tasks with parent/child relationships and block dependencies pre-wired.

## Available Templates

### bug-fix

Investigate and fix a bug systematically.

```
Investigate
├── Reproduce issue          (approach: Create reproduction steps)
└── Identify root cause      (approach: Trace the bug to source, blocked by: Reproduce issue)
Fix                          (blocked by: Investigate)
Test                         (blocked by: Fix)
├── Verify fix               (approach: Confirm original issue is resolved)
└── Regression tests         (approach: Ensure no regressions)
```

### feature

Design, implement, test, and review a new feature.

```
Design     (approach: Research requirements and design the approach)
Implement  (blocked by: Design)
Test       (blocked by: Implement)
Review     (blocked by: Test)
```

### swe-full-cycle

Full software engineering cycle with test plan, review, gate, and retrospective.

```
Plan
├── Research requirements
├── Explore codebase
├── Design approach          (blocked by: Research + Explore)
└── Define test plan         (blocked by: Design)
Implement                    (blocked by: Plan)
Test                         (blocked by: Implement)
Review                       (blocked by: Test)
├── Code review
└── Address feedback         (blocked by: Code review)
Completion gate              (blocked by: Review)
Retrospective                (blocked by: Completion gate)
Deliver                      (blocked by: Retrospective)
```

## When to Use Templates vs Manual Creation

| Scenario | Approach |
|----------|----------|
| Standard bug fix, feature, or full-cycle work | `limbo template apply <name>` |
| Template fits but needs extra tasks | Apply template, then `limbo add` extras |
| Custom/unique task structure | Manual `limbo add` |
| Template tasks nested under a larger project | `limbo template apply <name> --parent <id>` |

## Tips

- Templates create tasks with generic approach/verify/result text. Update them with `limbo note` to add project-specific context.
- The `--parent` flag is useful when a template represents one phase of a larger project.
- Templates respect the same structured fields as manual tasks (approach, verify, result).

Back to [SKILL.md](../SKILL.md) | [limbo Commands](limbo-commands.md)
