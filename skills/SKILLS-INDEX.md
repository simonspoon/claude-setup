# Skills Index

Quick reference for all active skills — when to use each and how they compose.

| Skill | Purpose | When to invoke | Composes with |
|-------|---------|----------------|---------------|
| **tech-lead** | Engineering gateway for all code tasks — plans, dispatches, reviews, tests, verifies | ANY task that writes, modifies, or deletes code | project-docs-explore (Phase 0), code-reviewer, test-engineer, qorvex-test-ios (verification) |
| **project-docs-explore** | Orient via progressive-disclosure docs before coding | Starting work on unfamiliar subsystem or onboarding to project | tech-lead (Phase 0 research) |
| **qorvex-test-ios** | Automate and verify iOS app UI on simulator or physical device | Testing iOS apps, verifying UI behavior, taking screenshots | tech-lead (verification phase) |
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
| **simplify** | Analyze code for unnecessary complexity and apply focused refactorings | Simplifying code, refactoring, cleanup, reducing complexity, extracting modules, removing duplication | software-engineering (conventions), test-engineer (verify tests), code-reviewer (review result) |
| **code-index** | Generate structural index of codebase (files + exported symbols) | Indexing a project, generating code map, understanding project structure | project-docs-explore (complements docs with code structure) |
| **session-wrap** | End-of-session cleanup — commits dirty repos and optionally improves skills | End of session, wrapping up, user says goodbye, significant milestone | software-engineering (lessons), skill-reflection (skill issues) |
| **nyx** | Search past Claude Code conversation history | Recalling prior decisions, finding past discussions, "did we already…" questions, locating context from previous sessions | software-engineering (find past architecture decisions) |
| **loki-test-desktop** | Automate and verify macOS desktop application UI via the loki CLI | Testing desktop apps, verifying UI behavior, macOS app testing, accessibility testing, taking screenshots, clicking buttons, inspecting UI trees | tech-lead (verification phase), qorvex-test-ios (sibling pattern) |
| **khora-test-web** | Automate and verify web application UI via the khora CLI and Chrome DevTools Protocol | Testing web apps, browser testing, Chrome automation, verifying web pages, clicking buttons, taking screenshots, checking page content | tech-lead (verification phase), loki-test-desktop (sibling pattern) |
| **xaku-control** | Control terminals via the xaku headless terminal multiplexer | Spawning interactive terminals, starting Claude Code sessions, running REPLs/TUIs, reading terminal output, sending commands | tech-lead (interactive tasks), khora-test-web (browser complement) |
| **qorvex-app-explorer** | Systematically explore and map an iOS app's UI via qorvex | Mapping app screens, exploring app functionality, discovering UI flows, building screen maps, generating automation scripts | qorvex-test-ios (uses same tool), project-docs-explore (produces documentation) |
| **skill-trainer** | Validate and harden skills through automated testing and weak-model calibration | Training skills, testing skills, validating skill instructions, calibrating for weaker models, stress-testing before deployment | skill-reflection (improvement loop), all skills (target of training) |
| **verification-orchestrator** | Auto-detects project type (iOS, desktop, web) and routes to the appropriate QA tool (qorvex, loki, khora) | verify, test, QA, auto-detect platform, check your work | qorvex-test-ios, loki-test-desktop, khora-test-web, tech-lead |
| **wisp-design** | Design and build visual UI layouts using the Wisp desktop canvas and CLI | Designing UI, building layouts, creating mockups, visual design, placing components, arranging elements, iterating on designs | tech-lead (design tasks), loki-test-desktop (verify desktop app showing design) |
| **release** | Cut a versioned release with CI builds and Homebrew distribution | Releasing a tool, cutting a release, bumping version, tagging, publishing to Homebrew | devops (CI pipeline), git-commit (version bump commit) |
| **global-backlog** | Cross-project task management via `limbo -g` | Global backlog, cross-project tasks, "add to backlog", "what's on the backlog", triage work across projects | tech-lead (can pick up backlog items) |
| **status** | Force-refresh all project state — live git, suda, limbo data | "status", "where are we", "catch me up", start of session, verifying state | global-backlog (reads backlog) |
| **dream** | Offline memory consolidation — deduplicates, prunes, and synthesizes suda memories | Manually via `/dream`, on schedule, when suda recall output is noisy or redundant | suda (operates on suda memories), skill-reflection (produces skill improvement recommendations) |

## Composition Patterns

### Multi-file feature work
1. `/swe-team:project-docs-explore` → read relevant docs
2. `/swe-team:tech-lead` → decompose into tasks, dispatch subagents
3. `/swe-team:qorvex-test-ios` → verify iOS UI changes in verification phase

### iOS bug fix
1. `/swe-team:project-docs-explore` → understand subsystem
2. `/swe-team:tech-lead` → investigate → fix → test
3. `/swe-team:qorvex-test-ios` → reproduce bug, verify fix on device

### Desktop app verification
1. `/swe-team:project-docs-explore` → understand the desktop app's subsystem
2. `/swe-team:tech-lead` → decompose into tasks, dispatch subagents
3. `/swe-team:loki-test-desktop` → verify macOS desktop UI changes (screenshot, inspect tree, interact, verify)

### Desktop bug fix
1. `/swe-team:project-docs-explore` → understand subsystem
2. `/swe-team:tech-lead` → investigate → fix → test
3. `/swe-team:loki-test-desktop` → reproduce bug, verify fix on desktop app

### Web app verification
1. `/swe-team:project-docs-explore` → understand the web app's subsystem
2. `/swe-team:tech-lead` → decompose into tasks, dispatch subagents
3. `/swe-team:khora-test-web` → verify web UI changes (launch Chrome, navigate, screenshot, inspect, verify)

### Web bug fix
1. `/swe-team:project-docs-explore` → understand subsystem
2. `/swe-team:tech-lead` → investigate → fix → test
3. `/swe-team:khora-test-web` → reproduce bug in browser, verify fix on web app

### New project setup
1. `/swe-team:setup-docs` → create docs/ structure
2. `/swe-team:tech-lead` → orchestrate implementation
3. `/swe-team:update-docs` → keep docs current as code evolves

### Code review workflow
1. `/swe-team:software-engineering` → load project conventions and preferences
2. `/swe-team:code-reviewer` → review diff/PR against security, bugs, style, conventions
3. `/swe-team:test-engineer` → verify test coverage for changed code

### CI/CD setup
1. `/swe-team:devops` → create GitHub Actions workflow, Docker config
2. `/swe-team:test-engineer` → ensure test commands match CI pipeline
3. `/swe-team:code-reviewer` → review the pipeline config itself

### Test-driven development
1. `/swe-team:software-engineering` → load project conventions
2. `/swe-team:test-engineer` → generate tests for new feature
3. `/swe-team:code-reviewer` → review implementation against tests

### SWE Full Cycle (issue → merge)
1. `/swe-team:software-engineering` → load conventions and architecture knowledge
2. `/swe-team:project-docs-explore` → understand existing codebase
3. `/swe-team:tech-lead` → decompose work, dispatch subagents (uses `swe-full-cycle` workflow)
4. `/swe-team:test-engineer` → generate tests, run suites, analyze coverage
5. `/swe-team:code-reviewer` → review all changes for bugs, security, conventions
6. `/swe-team:devops` → update CI pipeline if needed
7. Deliver: commit + create PR

This is the primary workflow for the SWE agent team. The tech-lead orchestrates all other skills via its `workflows/swe-full-cycle.md` template.

### New agent creation
1. `/swe-team:agent-composer` → generate agent definition from requirements
2. `/swe-team:skill-creator` → create any new skills the agent needs
3. `/swe-team:team-evaluator` → benchmark the new agent's capabilities

### Simplify/Refactor workflow
1. `/swe-team:software-engineering` → load project conventions and preferences
2. `/swe-team:simplify` → analyze code, identify opportunities, present findings
3. User approves specific refactorings
4. `/swe-team:simplify` → apply refactorings one at a time, verify tests after each
5. `/swe-team:test-engineer` → run full test suite, confirm no regressions
6. `/swe-team:code-reviewer` → review the refactored code for quality

### Recall prior context
1. `/swe-team:nyx` → search conversation history for past decisions, discussions, or patterns
2. Combine findings to inform current task

### End of session
1. `/swe-team:session-wrap` → reflects on session, captures learnings to suda, improves skills if needed, persists state

### UI design workflow
1. `/swe-team:wisp-design` → build the visual layout on the Wisp canvas using CLI commands
2. `/swe-team:wisp-design` → screenshot and inspect, iterate on positioning and styling
3. `/swe-team:wisp-design` → save the final design to a JSON file
4. `/swe-team:tech-lead` → if the design informs code generation, orchestrate implementation from the saved design

### Release a tool
1. `/swe-team:release` → bump version, commit, tag, push, verify CI + Homebrew tap update
2. `/swe-team:devops` → if release workflow needs changes

### Memory maintenance
1. `/swe-team:dream` → inventory, consolidate duplicates, prune stale entries, synthesize recommendations
2. `/swe-team:skill-reflection` → act on skill improvement recommendations from dream report

### Team improvement cycle
1. `/swe-team:team-evaluator` → run benchmarks, identify gaps
2. `/swe-team:skill-reflection` → improve weak skills based on evaluation findings
3. `/swe-team:team-evaluator` → re-run benchmarks to verify improvement
