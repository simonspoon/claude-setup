# Benchmark Catalog

Predefined benchmark tasks organized by category. Each benchmark specifies a scenario, expected outcome, and which skills/agents it exercises.

## Bug Fix Benchmarks

### BF-1: Null Reference in API Handler
**Setup:** Create a REST handler that crashes when an optional field is missing from the request body.
**Task:** "This API endpoint crashes when the `email` field is omitted. Find and fix the bug."
**Expected:** Null check added, graceful error response returned, test added for missing field.
**Exercises:** software-engineering, code-reviewer

### BF-2: Off-by-One in Pagination
**Setup:** Create a list endpoint with pagination that skips the last item when results are exactly page-sized.
**Task:** "Users report the last item on each page is sometimes missing. Investigate and fix."
**Expected:** Pagination boundary condition fixed, edge case tests added.
**Exercises:** software-engineering, test-engineer

### BF-3: Race Condition in Cache
**Setup:** Create a cache module where concurrent reads and writes can return stale data.
**Task:** "Cache sometimes returns stale data under load. Diagnose and fix."
**Expected:** Thread-safe access pattern implemented, concurrent access test added.
**Exercises:** software-engineering, code-reviewer

## Feature Implementation Benchmarks

### FI-1: Add Search Endpoint
**Setup:** Provide a project with user CRUD endpoints but no search.
**Task:** "Add a search endpoint that supports filtering by name and email, with pagination."
**Expected:** New endpoint with filtering, pagination, input validation, tests, docs.
**Exercises:** software-engineering, project-manager, test-engineer

### FI-2: Add Rate Limiting Middleware
**Setup:** Provide an Express/Actix/Flask app with no rate limiting.
**Task:** "Add rate limiting: 100 requests per minute per IP, with configurable limits."
**Expected:** Middleware implemented, configurable, tests for limit enforcement and reset.
**Exercises:** software-engineering, test-engineer

### FI-3: Add Webhook System
**Setup:** Provide an app that processes events internally.
**Task:** "Add webhook support: register URLs, retry on failure, log delivery attempts."
**Expected:** Registration API, delivery with retries, logging, tests.
**Exercises:** software-engineering, project-manager, devops

## Code Review Benchmarks

### CR-1: Security Vulnerabilities
**Setup:** Create a file with 3 planted security issues: SQL injection, hardcoded secret, path traversal.
**Task:** "Review this code for security issues."
**Expected:** All 3 issues identified with severity ratings and fix suggestions.
**Exercises:** code-reviewer, software-engineering

### CR-2: Performance Anti-Patterns
**Setup:** Create a file with N+1 query, unbounded loop, and missing index hint.
**Task:** "Review this code for performance issues."
**Expected:** All 3 patterns identified with improvement suggestions.
**Exercises:** code-reviewer, software-engineering

### CR-3: Mixed Quality PR
**Setup:** Create a diff with good changes mixed with subtle bugs and style violations.
**Task:** "Review this PR."
**Expected:** Bugs caught, style issues noted, good changes acknowledged. Correct verdict.
**Exercises:** code-reviewer

## Test Generation Benchmarks

### TG-1: Unit Tests for Utility Module
**Setup:** Provide a utility module with 5 functions, no tests.
**Task:** "Generate comprehensive unit tests for this module."
**Expected:** Tests for all functions, edge cases covered, tests actually pass.
**Exercises:** test-engineer, software-engineering

### TG-2: Integration Tests for API
**Setup:** Provide an API with 3 endpoints, no integration tests.
**Task:** "Generate integration tests for these API endpoints."
**Expected:** Tests cover success paths, error paths, validation, auth. Tests actually run.
**Exercises:** test-engineer, software-engineering

### TG-3: Test Coverage Gap Analysis
**Setup:** Provide a module with existing tests that miss 3 critical paths.
**Task:** "Analyze test coverage and fill the gaps."
**Expected:** Missing paths identified, tests added, coverage improved.
**Exercises:** test-engineer

## CI/CD Benchmarks

### CD-1: GitHub Actions for Node.js
**Setup:** Provide a Node.js project with tests but no CI.
**Task:** "Set up GitHub Actions CI: lint, test, build on PR and push to main."
**Expected:** Working workflow file, correct triggers, caching, artifact handling.
**Exercises:** devops, test-engineer

### CD-2: Docker Multi-Stage Build
**Setup:** Provide a project with a naive Dockerfile.
**Task:** "Optimize the Dockerfile with multi-stage build, minimize image size."
**Expected:** Multi-stage Dockerfile, smaller image, build still works.
**Exercises:** devops

### CD-3: Deployment Pipeline
**Setup:** Provide a project with CI but no CD.
**Task:** "Add a deployment stage: staging on PR merge, production on tag."
**Expected:** Deployment workflow with environment separation, approval gates.
**Exercises:** devops

## Refactoring Benchmarks

### RF-1: Extract Module from God Object
**Setup:** Create a class/module with 5+ responsibilities.
**Task:** "Refactor this into focused modules with clear responsibilities."
**Expected:** Clean separation, all existing tests still pass, no behavior change.
**Exercises:** software-engineering, code-reviewer, test-engineer

### RF-2: Replace Callback Hell with Async/Await
**Setup:** Provide deeply nested callback-based code.
**Task:** "Refactor to use async/await while preserving behavior."
**Expected:** Clean async code, all existing tests pass, error handling preserved.
**Exercises:** software-engineering

### RF-3: Dependency Injection Refactor
**Setup:** Provide code with hardcoded dependencies.
**Task:** "Refactor to use dependency injection for testability."
**Expected:** DI pattern applied, existing tests updated, new tests use mocks.
**Exercises:** software-engineering, test-engineer

## Creating Custom Benchmarks

To add a benchmark, follow this template:

```markdown
### [CAT]-[N]: [Title]
**Setup:** [What to create/scaffold for the test scenario]
**Task:** [Exact prompt to give the skill/agent]
**Expected:** [What a correct solution looks like]
**Exercises:** [skill1, skill2]
```

Categories: BF (bug fix), FI (feature implementation), CR (code review), TG (test generation), CD (CI/CD), RF (refactoring).
