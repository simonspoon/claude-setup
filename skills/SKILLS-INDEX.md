# Skills Index

Quick reference for all active skills — when to use each and how they compose.

| Skill | Purpose | When to invoke | Composes with |
|-------|---------|----------------|---------------|
| **project-manager** | Orchestrate multi-file tasks with limbo + parallel subagents | Task creates/modifies 3+ files, spans 2+ concerns, has independent parts | project-docs-explore (Phase 0), qorvex-test-ios (verification) |
| **project-docs-explore** | Orient via progressive-disclosure docs before coding | Starting work on unfamiliar subsystem or onboarding to project | project-manager (Phase 0 research) |
| **qorvex-test-ios** | Automate and verify iOS app UI on simulator or physical device | Testing iOS apps, verifying UI behavior, taking screenshots | project-manager (verification phase) |
| **setup-docs** | Create docs/ structure with INDEX.md for progressive disclosure | New project needs documentation scaffolding | project-docs-explore (consumer of its output) |
| **update-docs** | Update existing docs to reflect code changes | After code changes that affect documented behavior | project-docs-explore (reads what update-docs writes) |
| **skill-creator** | Create new skills with proper structure and frontmatter | User wants a new custom skill | skill-reflection (improve after creation) |
| **skill-reflection** | Analyze skill quality and implement improvements | After sessions where skills underperformed | All skills (meta-improvement) |
| **software-engineering** | Self-evolving SE knowledge base with personal preferences | Architecture, debugging, code review, patterns, testing, performance, security, or when user shares preferences | skill-reflection (meta-improvement) |

## Composition Patterns

### Multi-file feature work
1. `/project-docs-explore` → read relevant docs
2. `/project-manager` → decompose into tasks, dispatch subagents
3. `/qorvex-test-ios` → verify iOS UI changes in verification phase

### iOS bug fix
1. `/project-docs-explore` → understand subsystem
2. `/project-manager` → investigate → fix → test
3. `/qorvex-test-ios` → reproduce bug, verify fix on device

### New project setup
1. `/setup-docs` → create docs/ structure
2. `/project-manager` → orchestrate implementation
3. `/update-docs` → keep docs current as code evolves
