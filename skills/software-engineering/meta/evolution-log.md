# Evolution Log

Tracks additions and changes to the knowledge base.

| Date | Action | File | Details |
|------|--------|------|---------|
| 2026-03-14 | created | (all) | Initial seed structure |
| 2026-03-14 | added | knowledge/architecture/rust-cli-patterns.md | Seeded from dante project session — blocking HTTP, untyped returns, module structure, error handling, crate stack |
| 2026-03-14 | modified | SKILL.md | Fixed activation protocol: skip empty preference files, clarified empty-state behavior, relaxed modification rule to allow /skill-reflection edits |
| 2026-03-15 | added | knowledge/tooling/rust-dependency-management.md | Current crate versions, semver guidance, upgrade workflow, breaking change patterns |
| 2026-03-15 | modified | knowledge/architecture/rust-cli-patterns.md | Updated crate stack table with versions, linked to dependency management file |
| 2026-03-15 | modified | SKILL.md | Added critical requirement: ask before upgrading deps. Added staleness tracking (Last researched date, 3-month threshold for tooling). Added tooling domain to activation protocol |
| 2026-03-15 | modified | knowledge/architecture/rust-cli-patterns.md | Added: feature-gated optional subsystems, transparent backend routing via constructors, mixing blocking reqwest with async axum |
| 2026-03-15 | modified | preferences/lessons.md | Added 2 lessons: prefer stdlib over heavyweight deps, mutex poison recovery in servers |
| 2026-03-16 | modified | knowledge/architecture/rust-cli-patterns.md | Added: background polling tasks in axum servers — lock/unlock/network/lock pattern, interval usage, batched API calls, early bail |
| 2026-03-19 | modified | SKILL.md | Fixed evolution mechanism: broadened research trigger to include implementation work, added post-work capture step, allowed experience-based knowledge capture |
| 2026-03-19 | added | knowledge/architecture/go-cli-patterns.md | Go/Cobra CLI patterns from limbo project — command structure, flag management, storage, testing |
| 2026-03-19 | modified | knowledge/architecture/go-cli-patterns.md | Added: portable data ID remapping pattern, import merge vs replace modes |
| 2026-03-19 | modified | SKILL.md | Structural fix: extracted post-work capture (step 8) into its own "Post-Task Protocol" section with forward reference from activation protocol. Folded evolution log check into post-task steps. Validated with Haiku. |
