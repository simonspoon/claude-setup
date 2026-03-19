# Phase 1: Test Generation

## Goal

Analyze a skill's documentation and produce a comprehensive but focused set of test scenarios that exercise its real capabilities.

## Step-by-Step

### 1. Read Everything

Read the target skill's full documentation:
```
~/.claude/skills/[skill-name]/SKILL.md
~/.claude/skills/[skill-name]/reference/*.md   (all files)
```

As you read, note:
- Every command or tool the skill documents
- Every workflow or multi-step pattern
- Every "important rule" or gotcha mentioned
- Every example provided
- Any claims about what works or doesn't work

### 2. Categorize What to Test

Organize what you found into these categories:

**Core operations** (must test — these are the skill's reason for existing):
- The 3-5 most fundamental commands/actions
- The most common workflow end-to-end

**Input handling** (test if documented):
- Special characters, edge-case inputs
- Empty/missing/malformed inputs
- Boundary conditions mentioned in docs

**Multi-step workflows** (test 2-3):
- The documented step-by-step patterns
- Focus on ones where steps depend on each other (e.g., "save the ref from step 1, use it in step 3")

**Error recovery** (test if documented):
- What the skill says to do when things fail
- Escalation ladders (try A, if fail try B, etc.)

**Cleanup** (always test):
- The skill's documented cleanup procedures
- Verify nothing is left behind

### 3. Generate 8-12 Test Scenarios

For each scenario, write:

```
Test N: [Short name]
Category: [core / input / workflow / error / cleanup]
What it tests: [1-sentence description]
Steps:
  1. [Concrete action]
  2. [Concrete action]
  ...
Expected result: [What success looks like]
```

**Rules for good test scenarios:**
- Each test should be independent (can run in any order)
- Each test should clean up after itself
- Tests should cover breadth first, depth second
- At least 1 test should exercise the "most common workflow" end-to-end
- At least 1 test should exercise an error/recovery path
- At least 1 test should verify cleanup works

### 4. Score Coverage

After generating tests, check:
- [ ] Every documented command is exercised by at least one test
- [ ] Every documented workflow has a test
- [ ] At least one test exercises error recovery
- [ ] At least one test verifies cleanup
- [ ] No test requires more than ~10 steps (split if longer)

### 5. Present to User

Show the test list and ask:
- "Are there scenarios I should add?"
- "Are there any I should skip?"
- "Any specific edge cases you've seen fail?"

Wait for approval before moving to Phase 2.

## Example Test Scenarios (for a hypothetical database skill)

```
Test 1: Basic query
Category: core
What it tests: Simple SELECT with documented template
Steps:
  1. Run documented query template with a known user
  2. Verify output format matches documentation
Expected result: Results returned in documented format

Test 2: No results handling
Category: error
What it tests: Behavior when query returns 0 rows
Steps:
  1. Run query with a user that doesn't exist
  2. Check that skill's documented "no results" guidance is followable
Expected result: Clear message, no error

Test 3: Multi-step lookup
Category: workflow
What it tests: The "find user, then get their orders" workflow
Steps:
  1. Follow documented workflow step 1 (user lookup)
  2. Extract ID from step 1 output
  3. Use ID in step 2 (order lookup)
Expected result: Both steps succeed, refs chain correctly
```

## What NOT to Test

- Things outside the skill's documented scope
- The underlying tool's correctness (you're testing the DOCS, not the tool)
- Performance or timing (unless the skill makes timing claims)
- Combinations the skill doesn't document
