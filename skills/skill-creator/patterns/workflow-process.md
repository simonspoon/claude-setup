# Workflow/Process Pattern

For skills that encode organizational processes, procedures, or multi-step workflows.

## Structure

```
skill-name/
├── SKILL.md (frontmatter + process overview + checklists)
├── standards/
│   ├── INDEX.md
│   ├── security.md
│   ├── style.md
│   └── testing.md
└── workflows/
    ├── INDEX.md
    ├── basic-workflow.md
    └── advanced-workflow.md
```

## When to Use

- Encoding organizational processes or procedures
- Multi-step workflows with quality gates
- References to standards and guidelines
- Checklists and validation steps
- Process requires different paths based on context

## Template

```markdown
---
name: process-name
description: [What process it encodes]. Use when [user activity that triggers this process].
---

# Process Name

[Brief description of the process and its purpose]

## ⚠️ CRITICAL REQUIREMENTS

[List any universal requirements that apply to ALL steps]

## Process Overview

[High-level summary of the process steps]

## What Are You Trying To Do?

**[Scenario 1]:**
→ Read workflows/[workflow-file].md

**[Scenario 2]:**
→ Read workflows/[workflow-file].md

**[Scenario 3]:**
→ Read workflows/[workflow-file].md

## Quick Checklist

For simple cases, verify:
1. [Requirement 1]
2. [Requirement 2]
3. [Requirement 3]
4. [Requirement 4]

For complete process, read workflows/INDEX.md

## Standards and Guidelines

- [Standard 1] - Read standards/[file].md
- [Standard 2] - Read standards/[file].md
- [Standard 3] - Read standards/[file].md

## Resources

[Links to workflow and standard documentation]
```

## Complete Example: Code Review Process

**SKILL.md:**
```markdown
---
name: code-review
description: Review code changes following company security, performance, and style standards. Use when reviewing pull requests, code changes, or when user asks for code review.
---

# Code Review Process

Systematic process for reviewing code changes to ensure quality, security, and maintainability.

## ⚠️ CRITICAL REQUIREMENTS

Every code review MUST check:
- Security vulnerabilities (SQL injection, XSS, auth bypasses)
- Test coverage meets 80% threshold
- No secrets or credentials in code
- Breaking changes are documented

## Process Overview

1. **Security Review** - Check for vulnerabilities and exploits
2. **Performance Analysis** - Identify inefficient code patterns
3. **Style Compliance** - Verify adherence to coding standards
4. **Test Coverage** - Ensure adequate testing
5. **Documentation** - Verify changes are documented

## What Are You Trying To Do?

**Quick review of small change (<50 lines):**
→ Use Quick Checklist below

**Standard review of feature/bugfix:**
→ Read workflows/standard-review.md

**Major refactoring or architecture change:**
→ Read workflows/major-change-review.md

**Urgent hotfix review:**
→ Read workflows/hotfix-review.md

## Quick Checklist

For small changes (<50 lines), verify:
1. ✅ No obvious security issues
2. ✅ Tests exist and pass
3. ✅ Code follows style guide (run linter)
4. ✅ No hardcoded secrets or credentials
5. ✅ Changes are logical and focused

If any ❌, read relevant standard for details.

## Standards and Guidelines

Review standards organized by concern:

- **Security** - Read standards/security.md
  - SQL injection prevention
  - Authentication/authorization
  - Input validation
  - Secret management

- **Performance** - Read standards/performance.md
  - Query optimization
  - N+1 query detection
  - Caching strategies
  - Resource usage

- **Code Style** - Read standards/style.md
  - Naming conventions
  - Code organization
  - Comment requirements
  - Formatting rules

- **Testing** - Read standards/testing.md
  - Coverage requirements
  - Test patterns
  - Edge case testing
  - Integration tests

## Resources

- [workflows/INDEX.md](workflows/INDEX.md) - All review workflows
- [standards/INDEX.md](standards/INDEX.md) - All standards and guidelines
```

**workflows/standard-review.md:**
```markdown
# Standard Code Review Workflow

Complete workflow for reviewing typical features and bug fixes.

## Step 1: Security Review

Read [standards/security.md](../standards/security.md) for complete checklist.

**Quick checks:**
1. Look for SQL queries - are they parameterized?
2. Check authentication on new endpoints
3. Verify user input is validated
4. Check for sensitive data exposure
5. Search for hardcoded secrets

**If security concerns found:**
→ Request changes before proceeding

## Step 2: Run Automated Checks

```bash
# Run linter
npm run lint

# Run tests
npm run test

# Check coverage
npm run test:coverage
```

**If any fail:**
→ Request fixes before proceeding

## Step 3: Review Code Logic

**Check for:**
- Correct implementation of requirements
- Edge cases handled
- Error handling present
- Code is readable and maintainable
- No unnecessary complexity

**If logic issues found:**
→ Leave inline comments and request changes

## Step 4: Performance Review

Read [standards/performance.md](../standards/performance.md) for complete checklist.

**Quick checks:**
1. Database queries are efficient
2. No N+1 query patterns
3. Appropriate use of caching
4. No memory leaks in loops
5. Async operations handled properly

**If performance issues found:**
→ Leave comments with suggestions

## Step 5: Test Coverage Review

**Verify:**
- New code has tests (unit + integration)
- Coverage meets 80% threshold
- Tests cover edge cases
- Tests are meaningful (not just for coverage)

**Run:**
```bash
npm run test:coverage -- --changedFiles
```

**If coverage insufficient:**
→ Request additional tests

## Step 6: Documentation Check

**Verify:**
- Complex logic has comments
- API changes are documented
- README updated if needed
- Breaking changes clearly noted

**If documentation missing:**
→ Request updates

## Step 7: Final Approval

**If all checks pass:**
- Leave approval comment
- Merge PR (or request merge)

**If any issues remain:**
- Summarize required changes
- Request revisions
- Offer to pair program if complex
```

**standards/security.md:**
```markdown
# Security Standards

Security requirements for all code changes.

## ⚠️ CRITICAL: SQL Injection Prevention

**Required:**
- Use parameterized queries ALWAYS
- Never concatenate user input into SQL strings
- Use ORM query builders when possible

**Good:**
```python
# Parameterized query
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

**Bad:**
```python
# SQL injection vulnerable
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")
```

## Authentication & Authorization

**Every endpoint must:**
1. Verify user is authenticated
2. Check user has permission for action
3. Validate user owns the resource being accessed

**Pattern:**
```python
@require_auth
@require_permission("resource.edit")
def update_resource(resource_id):
    resource = get_resource(resource_id)
    if resource.owner_id != current_user.id:
        raise Forbidden("Not authorized")
    # proceed with update
```

## Input Validation

**Validate ALL user input:**
- Type checking
- Range/length limits
- Format validation (email, URL, etc.)
- Whitelist allowed values when possible

**Pattern:**
```python
from pydantic import BaseModel, validator

class UserInput(BaseModel):
    email: EmailStr
    age: int
    
    @validator("age")
    def age_must_be_reasonable(cls, v):
        if v < 0 or v > 150:
            raise ValueError("Invalid age")
        return v
```

## Secret Management

**Never commit:**
- API keys
- Database passwords
- Private keys
- Service credentials

**Always use:**
- Environment variables
- Secret management service (AWS Secrets Manager, etc.)
- Encrypted configuration

**If secrets found in code:**
→ Immediately request removal and rotation of exposed secrets

## Common Vulnerabilities Checklist

- [ ] No SQL injection (parameterized queries)
- [ ] No XSS (sanitize output)
- [ ] No CSRF (use tokens)
- [ ] No insecure deserialization
- [ ] No path traversal (validate file paths)
- [ ] No command injection (avoid shell=True)
- [ ] Authentication required on protected endpoints
- [ ] Authorization checked for resources
- [ ] Secrets not hardcoded
- [ ] User input validated
```

## Key Characteristics

- **Process-oriented**: Focuses on steps and procedures
- **Checklist-driven**: Clear verification points
- **Standards-based**: References detailed guidelines
- **Conditional paths**: Different workflows for different scenarios
- **Quality gates**: Stop points for validation

## Validation Checklist

Before finalizing:
- [ ] Critical requirements clearly marked
- [ ] Process steps are sequential and clear
- [ ] Decision tree for different scenarios
- [ ] Quick checklist for simple cases
- [ ] Complete workflows in separate files
- [ ] Standards documented with examples
- [ ] Quality gates clearly defined
