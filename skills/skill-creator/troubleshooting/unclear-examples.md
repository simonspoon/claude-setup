# Examples Aren't Clear Enough

Skill examples are vague, incomplete, or don't show realistic usage.

## Symptoms

- Agent produces wrong output because examples were ambiguous
- Users confused about what the skill actually does
- Examples show trivial cases but not real-world usage

## Root Cause

Examples use placeholder content instead of realistic scenarios, or omit critical details like expected output format.

## Fix

Replace vague examples with concrete, copy-paste-ready demonstrations.

## Step-by-Step Solution

### 1. Make Examples Concrete

**Bad:**
```markdown
## Example

Create a config file for the project.
```

**Good:**
```markdown
## Example

**User says:** "Set up ESLint for my TypeScript project"

**Agent does:**
1. Read project's tsconfig.json to understand TS settings
2. Create .eslintrc.json with TypeScript-compatible rules
3. Add lint script to package.json

**Output:** `.eslintrc.json` with extends: @typescript-eslint/recommended
```

### 2. Show Input AND Output

Every example should demonstrate:
- What the user asks for (input)
- What the agent produces (output)
- Why specific choices were made (reasoning)

### 3. Cover Edge Cases

Include at least one example showing:
- A common variation of the task
- An edge case or unusual request
- What NOT to do (anti-pattern)

### 4. Use Realistic Data

Replace placeholders like "foo", "bar", "example" with realistic names that reflect actual usage:
- Use real library names, file types, and tool names
- Show realistic file paths and directory structures
- Include realistic error messages when showing error handling

## Validation

After updating examples, verify:

- [ ] Each example has clear input (what user says)
- [ ] Each example has clear output (what agent produces)
- [ ] At least 2 distinct examples showing different scenarios
- [ ] No placeholder names — all examples use realistic content
- [ ] Examples are self-contained (reader doesn't need external context)

## Related Issues

- [file-too-long.md](file-too-long.md) - If adding examples makes SKILL.md too long, split into examples/ directory
