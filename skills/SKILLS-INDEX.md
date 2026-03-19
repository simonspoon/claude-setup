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
| **code-reviewer** | Review code diffs, PRs, and files for quality, bugs, and security | Reviewing code, PRs, diffs, checking code quality, security review | software-engineering (conventions), test-engineer (coverage check) |
| **test-engineer** | Generate tests, run suites, analyze coverage, report results | Writing tests, running tests, analyzing coverage, test quality audit | software-engineering (conventions), code-reviewer (coverage verification) |
| **devops** | CI/CD pipelines, Docker, deployment scripts, infrastructure | GitHub Actions, CI/CD, Docker, deployment, infrastructure, pipelines | test-engineer (CI test step), code-reviewer (PR checks) |
| **agent-composer** | Generate agent .md definitions from role descriptions and skills | Creating a new agent, composing an agent from skills, generating agent definitions | skill-creator (skill structure), SKILLS-INDEX.md (skill discovery) |
| **team-evaluator** | Benchmark and score team capabilities, identify gaps | Evaluating team performance, running benchmarks, auditing capabilities, gap analysis | All skills (benchmarks exercise them), skill-reflection (improvement loop) |

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

### Code review workflow
1. `/software-engineering` → load project conventions and preferences
2. `/code-reviewer` → review diff/PR against security, bugs, style, conventions
3. `/test-engineer` → verify test coverage for changed code

### CI/CD setup
1. `/devops` → create GitHub Actions workflow, Docker config
2. `/test-engineer` → ensure test commands match CI pipeline
3. `/code-reviewer` → review the pipeline config itself

### Test-driven development
1. `/software-engineering` → load project conventions
2. `/test-engineer` → generate tests for new feature
3. `/code-reviewer` → review implementation against tests

### SWE Full Cycle (issue → merge)
1. `/software-engineering` → load conventions and architecture knowledge
2. `/project-docs-explore` → understand existing codebase
3. `/project-manager` → decompose work, dispatch subagents (uses `swe-full-cycle` workflow)
4. `/test-engineer` → generate tests, run suites, analyze coverage
5. `/code-reviewer` → review all changes for bugs, security, conventions
6. `/devops` → update CI pipeline if needed
7. Deliver: commit + create PR

This is the primary workflow for the SWE agent team. The project-manager orchestrates all other skills via its `workflows/swe-full-cycle.md` template.

### New agent creation
1. `/agent-composer` → generate agent definition from requirements
2. `/skill-creator` → create any new skills the agent needs
3. `/team-evaluator` → benchmark the new agent's capabilities

### Team improvement cycle
1. `/team-evaluator` → run benchmarks, identify gaps
2. `/skill-reflection` → improve weak skills based on evaluation findings
3. `/team-evaluator` → re-run benchmarks to verify improvement
