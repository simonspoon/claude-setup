# Skill Reflection - Improvement Best Practices

## Meta-Principle: You Are Not a Domain Expert

When improving skills, your role is **structural architect**, not domain expert.

### What You Fix:
- ✅ How information is organized
- ✅ Whether instructions are clear and explicit
- ✅ If guardrails exist for edge cases
- ✅ Whether templates are fully documented
- ✅ If critical requirements are properly marked

### What You Don't Fix:
- ❌ Whether the query uses the right table (domain knowledge)
- ❌ Whether the API endpoint is correct (domain knowledge)
- ❌ Whether the logic is optimal (implementation detail)

### When Domain Knowledge Is Needed:
- **Ask the user**: "To improve this skill, I need to understand what 'user information' means in this domain. Should it query CadabraUser or Provider as primary source?"
- **Note in skill**: "Skill should define: What does 'user' mean in this context? Provider vs account vs both?"

## Progressive Disclosure Strategy

### The Problem
Weak models have small context windows. If you give them:
- 20 query examples at once → overwhelmed, can't find what they need
- Long prose explanations → lose track of instructions
- Complex reasoning required → make wrong decisions

### The Solution: File Granularity + Indexing

**High granularity** = Each query/example/guide in its own file
**Indexing** = List of what's available, organized by purpose

**Example Structure**:
```
database-skill/
  SKILL.md (50-100 lines: critical requirements + decision tree)
  
  common-queries/
    INDEX.md (lists 10 queries: "user-lookup: Get user account info")
    user-lookup.md (ONE query + full documentation)
    patient-search.md (ONE query + full documentation)
    provider-info.md (ONE query + full documentation)
    ...
  
  troubleshooting/
    INDEX.md (lists issues: "No results", "Connection error")
    no-results.md (specific guidance for 0 results)
    connection-error.md (specific guidance for connection issues)
    ...
```

**Model workflow**:
1. Read SKILL.md → see "For common queries, read common-queries/INDEX.md"
2. Read INDEX.md → scan list → "user-lookup: Get user account info" ✓
3. Read user-lookup.md only → get query + docs
4. Execute

**NOT**:
1. Read SKILL.md → see "For queries, read COMMON-QUERIES.md"
2. Read COMMON-QUERIES.md → 500 lines with 20 queries
3. Get lost finding the right one
4. Maybe use wrong query

### When to Split Files

**Split when**:
- File > 200 lines
- Multiple distinct topics/examples in one file
- User has to "find" the relevant section
- Adding new content will make file unwieldy

**Keep together when**:
- Tightly coupled information (template + its docs)
- Sequential steps that must be done together
- Critical requirements that apply universally

## Template Documentation Standard

Every template must include:

### 1. The Template Itself
```sql
SELECT name FROM users WHERE id = [UserId]
```

### 2. Placeholder Documentation
**[UserId]**: The numeric user identifier
- Get from: User's request, or query `users` table first by name
- Format: Integer (no quotes)
- Example: `123` not `'123'`

### 3. Filled Example
```sql
SELECT name FROM users WHERE id = 123
```

### 4. Expected Output
```
| name        |
|------------|
| John Doe    |
```

### 5. Success/Failure Conditions
- Success: Returns 1 row with user name
- Empty (0 rows): User ID doesn't exist → read troubleshooting/no-results.md
- Error "Invalid column": Schema mismatch → read troubleshooting/schema-errors.md

### Why This Matters
Weak models cannot infer:
- Whether `[UserId]` should have quotes or not
- Whether to get it from user or query for it
- What successful execution looks like
- What to do if output doesn't match expectation

**Don't assume reasoning capabilities.** Spell everything out.

## Guardrails: Conditional Logic + Escalation

### Poor Guardrail
"If the query returns 0 results, check troubleshooting."

### Good Guardrail
```
If query returns 0 results:
  - AND user said "I know user X exists" → read troubleshooting/no-results.md
  - AND user didn't indicate expectations → ask user: "No records found for [criteria]. Is this expected or should we troubleshoot?"
  - AND this is exploratory query → report to user: "No records match [criteria]"
```

### Components of Good Guardrails

1. **Condition**: What outcome/error occurred
2. **Context**: What matters about the situation
3. **Action**: Specific file to read, or specific question to ask user
4. **Escalation script**: Exact wording when asking user

### Where Guardrails Go

**In SKILL.md**: General framework
```
When queries return unexpected results:
- Read troubleshooting/INDEX.md to identify issue
- If issue not listed, ask user for clarification
```

**In specific files**: Specific cases
```
troubleshooting/no-results.md:

If 0 results returned:
1. Verify search criteria are correct
2. Check DeletedDate IS NULL is included (soft deletes)
3. If criteria correct → may indicate data doesn't exist
4. Ask user: "Query found no records matching [criteria]. Should we:
   a) Check if search terms are correct
   b) Verify data exists in system
   c) Try different search approach"
```

## Critical Requirements Marking

Weak models need visual/structural signals for "never skip this."

### Format Options

**Option 1: Emoji + Bold**
```markdown
## ⚠️ CRITICAL REQUIREMENTS

- Always use `WITH (NOLOCK)` in SELECT queries
- Always include `TOP 100` limit
```

**Option 2: Section Headers**
```markdown
## Required Practices (ALWAYS)

Every query must:
- Use `WITH (NOLOCK)`
- Include `TOP 100`
```

**Option 3: Callout Boxes**
```markdown
> **⚠️ CRITICAL**: Always use `WITH (NOLOCK)` in SELECT queries to prevent table locks
```

### What Qualifies as Critical

Mark as critical if:
- Skipping causes errors, data corruption, or safety issues
- Required for every operation in this skill (universal)
- Non-obvious requirement that model might forget

Don't mark as critical:
- Best practices that are flexible
- Domain-specific preferences
- Optional optimizations

## SKILL.md Size and Content

### Up to ~100 lines is fine IF it contains only:

1. **Critical requirements** (always needed, universal)
2. **Core workflow** (what to do first, decision tree)
3. **Quick reference** (most common tables/resources)
4. **Navigation** (where to go for specific needs)

### Should NOT contain:
- Multiple examples (→ separate files)
- Long troubleshooting (→ troubleshooting/)
- Detailed explanations (→ linked guides)
- Domain glossary >10 terms (→ GLOSSARY.md)

### Structure Template
```markdown
# Skill Name

## ⚠️ CRITICAL REQUIREMENTS
[Universal must-dos]

## Quick Start
[First steps for most common case]

## What Are You Trying To Do?
- User lookup → read common-queries/INDEX.md
- Schema exploration → read schemas/INDEX.md  
- Troubleshooting → read troubleshooting/INDEX.md

## Key Resources
[Quick reference table of most common items]

## Resources
- [Link to indexes and detailed docs]
```

## Concise But Complete

### Concise ✓
"Do X" not "You should probably consider doing X"
"Read file.md section 2" not "You might want to look at file.md if you need more info"

### Complete ✓
"Read common-queries/user-lookup.md, replace [Name] placeholder, execute query"
Not: "Use user lookup query"

### Balance
Remove filler words, keep essential information.

❌ "You'll probably want to make sure you read the INDEX.md file which should help you understand what queries are available"
✅ "Read common-queries/INDEX.md to see available queries"

## Session Analysis for Improvements

### Look for These Signals

**Signal**: User corrected agent 3+ times
**Problem**: Unclear instructions, missing decision point, or agent made domain assumptions
**Fix**: Add explicit decision points, or note "skill should define [term]"

**Signal**: User said "Could this not have been simpler?"
**Problem**: Poor progressive disclosure, dumping too much info
**Fix**: Split files, create indexes, streamline decision tree

**Signal**: Agent asked user basic questions skill should answer
**Problem**: Missing documentation
**Fix**: Add missing info to skill, or create FAQ section

**Signal**: Agent ignored critical requirement
**Problem**: Not marked clearly enough
**Fix**: Move to ⚠️ CRITICAL section at top of SKILL.md

**Signal**: Agent filled template wrong
**Problem**: Template placeholders not documented
**Fix**: Add full template documentation (placeholder meanings, examples, expected output)

**Signal**: Agent didn't know what to do with unexpected result
**Problem**: Missing guardrails
**Fix**: Add conditional logic and escalation paths

### Don't Confuse Signals

❌ "Agent used wrong SQL table" → Domain issue (ask user which table is correct)
✅ "Agent didn't know which table to use" → Skill should provide decision logic

❌ "Agent's query was inefficient" → Implementation detail (may or may not matter)
✅ "Agent didn't use required WITH (NOLOCK)" → Critical requirement not marked

❌ "Agent misunderstood domain term" → Skill needs glossary
✅ "Agent wrote wrong code" → Not your problem unless skill's example was wrong

## Improvement Process

1. **Identify structural/clarity issue** (not domain issue)
2. **If domain knowledge needed**: Ask user, don't assume
3. **Plan structural fix**: Files to create/split, indexes needed, guardrails to add
4. **Implement**: Focus on organization, clarity, guardrails
5. **Validate**: Check against weak model optimization criteria

## Examples from Session

### What Happened in Rounder-DB Session

**Signal 1**: Agent made 4-step user lookup, user said "could use clever joins"
- ❌ Wrong fix: Write better SQL query (domain implementation)
- ✅ Right fix: Note skill should include optimized query example

**Signal 2**: Agent used Provider as primary table, user said "actually user means CadabraUser"
- ❌ Wrong fix: Learn Rounder domain model
- ✅ Right fix: Note skill should define "user" in glossary, or ask user during improvement

**Signal 3**: Agent only tested with provider users
- ❌ Wrong fix: Learn about non-provider users
- ✅ Right fix: Skill should document edge cases or provide test checklist

### Correct Improvements

1. **Progressive disclosure**: Split COMMON-QUERIES.md into folder with index
2. **Template docs**: Add placeholder explanations to queries
3. **Glossary**: Add "What is a 'user' in Rounder?" section (after asking user)
4. **Guardrails**: Add "If query returns 0 for expected user → troubleshoot"
5. **Critical**: Ensure WITH (NOLOCK) is marked ⚠️ CRITICAL

### Not Your Job

1. Writing the correct SQL query (domain)
2. Understanding Provider vs CadabraUser relationship (domain)
3. Knowing which fields exist in tables (domain)
4. Deciding LEFT JOIN vs INNER JOIN (implementation detail unless it's a critical requirement)
