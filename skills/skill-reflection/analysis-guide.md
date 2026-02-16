# Detailed Analysis Guide

This guide provides comprehensive methodology for analyzing sessions and identifying skill improvement opportunities.

## Session Review Techniques

### Systematic Review Process

1. **Read chronologically**: Start from the beginning of the session
2. **Note skill invocations**: Mark each time a skill is loaded
3. **Track user responses**: Observe reactions to skill guidance
4. **Identify friction points**: Where did things slow down or go wrong?
5. **Look for workarounds**: Did the user have to find alternative solutions?

### Signal Classification

Classify signals by severity and type:

#### Critical Signals (High Priority)
- **Errors**: Skill guidance led to errors or failures
- **Complete confusion**: User completely misunderstood skill purpose
- **Blocking issues**: User couldn't proceed without external help
- **Repeated failures**: Same issue occurred multiple times

#### Important Signals (Medium Priority)
- **Clarification requests**: User asked follow-up questions
- **Partial understanding**: User got the concept but needed refinement
- **Missing examples**: User had to extrapolate from incomplete examples
- **Workflow inefficiency**: Skill guidance was correct but inefficient

#### Minor Signals (Low Priority)
- **Style preferences**: User preferred different formatting
- **Optional enhancements**: Nice-to-have additions
- **Edge cases**: Unusual scenarios not covered
- **Documentation polish**: Minor wording improvements

### Root Cause Analysis

For each signal, ask:

1. **What went wrong?** (Symptom)
2. **Why did it happen?** (Immediate cause)
3. **What's the underlying issue?** (Root cause)
4. **How can we prevent it?** (Solution)

**Example:**
```
Symptom: User got syntax error in SQL query
Immediate cause: Forgot to quote string literal
Root cause: Skill example didn't show string quoting
Solution: Add example with string literals and explain quoting rules
```

## Improvement Prioritization

### Priority Matrix

Use this matrix to prioritize improvements:

| Impact | Frequency | Priority |
|--------|-----------|----------|
| High   | High      | Critical |
| High   | Low       | Important|
| Low    | High      | Consider |
| Low    | Low       | Defer    |

**Impact**: How much does this affect user success?
- High: Blocks progress or causes errors
- Low: Minor inconvenience or enhancement

**Frequency**: How often will users encounter this?
- High: Common use case or repeated issue
- Low: Edge case or rare scenario

### Quick Wins vs. Strategic Improvements

**Quick Wins** (Do first):
- Add missing examples to existing sections
- Fix broken links or references
- Correct outdated information
- Clarify confusing wording
- Add trigger keywords to description

**Strategic Improvements** (Plan carefully):
- Restructure entire skill organization
- Split skill into multiple skills
- Add new major sections or capabilities
- Create additional resource files
- Develop supporting scripts

## Deep Analysis Techniques

### Pattern Recognition

Look for recurring patterns across the session:

**Temporal patterns**: 
- Issues early vs. late in skill usage
- Problems after specific types of requests

**Behavioral patterns**:
- User always asks "X" after seeing skill guidance
- Certain skill sections are consistently skipped
- User modifies suggested approaches in predictable ways

**Cross-skill patterns**:
- Multiple skills have similar gaps
- Skills conflict or contradict each other
- Skills don't integrate well together

### Comparative Analysis

Compare the session against:

1. **Skill guidelines**: Does skill meet creator standards?
2. **Similar skills**: How do other skills handle this better?
3. **Best practices**: What do exemplary skills do differently?
4. **User expectations**: What did the user expect vs. what they got?

### Evidence Gathering

Document specific evidence for each finding:

```markdown
Finding: Skill lacks error handling examples
Evidence:
  - Line 45: User asked "what if the file doesn't exist?"
  - Line 67: User got FileNotFoundError following skill guidance
  - Line 89: User had to search online for error handling pattern
Impact: Users can't handle common failure scenarios
```

## Improvement Planning Framework

### SMART Improvements

Make improvements:
- **Specific**: Target exact section/line
- **Measurable**: Clear before/after state
- **Achievable**: Can be done with available tools
- **Relevant**: Addresses actual user needs
- **Time-bound**: Complete in this session

### Change Impact Assessment

Before implementing, consider:

**Positive impacts**:
- Improves clarity
- Adds missing information
- Makes examples more complete
- Better trigger conditions

**Potential risks**:
- Could make skill too long
- Might contradict other sections
- Could reduce generality
- May need additional resources

**Mitigation strategies**:
- Move advanced content to separate files
- Review for consistency across skill
- Provide options for different scenarios
- Link to additional resources instead of including everything

## Implementation Strategy

### Surgical vs. Comprehensive Changes

**Surgical Changes** (Preferred):
- Target specific sections
- Preserve existing structure
- Minimal disruption to working content
- Use Edit tool for precise replacements

**Comprehensive Changes** (When necessary):
- Major restructuring needed
- Multiple interrelated changes
- Rewrite large sections
- May require Write tool for complete rewrite

### Change Validation

After each change, verify:

1. **Syntax**: YAML frontmatter is valid
2. **Structure**: Follows skill format requirements
3. **Completeness**: All referenced files exist
4. **Consistency**: Changes align with rest of skill
5. **Standards**: Meets skill creator guidelines

### Testing Strategy

Test improvements against:

1. **Original issue**: Does this fix the problem?
2. **Similar scenarios**: Does it help related cases?
3. **Edge cases**: Are there unintended consequences?
4. **Readability**: Is it clearer than before?
5. **Completeness**: Can users actually use this?

## Advanced Techniques

### Skill Decomposition

When a skill tries to do too much:

1. Identify distinct functional areas
2. Determine if they're independently useful
3. Consider splitting into separate skills
4. Plan how skills should reference each other
5. Implement split with proper cross-references

### Progressive Disclosure Optimization

Organize content by user journey:

**Level 1** (YAML description): 
- What and when (50-200 chars)

**Level 2** (Quick Start):
- Most common use case (200-500 words)

**Level 3** (Main Instructions):
- Common workflows and patterns (1-3k words)

**Level 4** (Additional Resources):
- Advanced topics, edge cases, deep dives (unlimited)

### Cross-Skill Harmonization

When multiple skills overlap or interact:

1. **Identify relationships**: Which skills work together?
2. **Define boundaries**: Where does each skill's responsibility end?
3. **Add cross-references**: Link skills appropriately
4. **Resolve conflicts**: Ensure consistent guidance
5. **Create integration examples**: Show how skills work together

## Analysis Checklist

Before completing analysis, verify:

- [ ] Reviewed entire session chronologically
- [ ] Identified all skill invocations
- [ ] Cataloged user friction points
- [ ] Classified signals by severity
- [ ] Performed root cause analysis for key issues
- [ ] Prioritized improvements by impact and frequency
- [ ] Created specific, actionable improvement plans
- [ ] Considered both quick wins and strategic improvements
- [ ] Documented evidence for each finding
- [ ] Assessed potential impacts of changes

## Common Analysis Pitfalls

**Pitfall**: Focusing only on explicit feedback
**Solution**: Look for implicit signals in user behavior

**Pitfall**: Over-prioritizing minor polish
**Solution**: Focus on blocking issues and high-impact improvements first

**Pitfall**: Assuming user error vs. skill gap
**Solution**: If multiple users struggle, it's likely a skill issue

**Pitfall**: Making changes without understanding root cause
**Solution**: Always perform root cause analysis before implementing

**Pitfall**: Implementing contradictory improvements
**Solution**: Review all changes together for consistency

**Pitfall**: Analysis paralysis with too many findings
**Solution**: Start with critical issues, iterate on others later

## Output Quality Standards

A good analysis should include:

1. **Clear findings**: Specific issues identified with evidence
2. **Root causes**: Understanding of why issues occurred
3. **Actionable plans**: Specific changes that can be implemented
4. **Prioritization**: Clear order of importance
5. **Expected outcomes**: How improvements will help users
6. **Implementation notes**: Any special considerations

## Examples of Complete Analyses

### Example 1: Database Skill Missing Query Examples

```markdown
## Analysis

Skill: local-amplitude-db
Session segment: Lines 23-45

### Findings
1. User asked "how do I query for specific fields?" after reading skill
2. User tried query syntax that resulted in MongoDB error
3. User had to reference external MongoDB docs to get correct syntax

### Root Cause
Skill provides conceptual overview but lacks concrete query examples showing:
- Field selection
- Filtering conditions  
- Query result handling

### Evidence
- Line 23: "Can you show me an example?"
- Line 31: MongoError: unknown field 'select'
- Line 38: User switched to MongoDB docs website

### Impact
- High impact: Blocks common use case
- High frequency: Field queries are fundamental operation
- Priority: Critical

### Improvement Plan
Add "Common Query Examples" section with:
1. Basic find query with field projection
2. Query with filter conditions
3. Complex query with multiple conditions
4. Result iteration and handling

### Expected Outcome
Users can copy/adapt working examples instead of trial-and-error or external research
```

### Example 2: Skill Trigger Confusion

```markdown
## Analysis

Skill: serilog-kql
Session segment: Lines 10-15

### Findings
1. User mentioned "API logs" but skill wasn't triggered
2. User explicitly asked "should I use the serilog skill?"
3. Skill eventually worked well once invoked

### Root Cause
Description doesn't include common trigger keywords like:
- "API logs"
- "log analysis"
- "Serilog data"

Current description only mentions "KQL queries" which is too specific

### Evidence
- Line 10: "I need to analyze API logs"
- Line 12: Skill not loaded by agent
- Line 14: "should I use the serilog skill?"
- Lines 16+: Skill guidance worked perfectly

### Impact
- Medium impact: Skill works but isn't discovered
- Medium frequency: "API logs" is common phrasing
- Priority: Important

### Improvement Plan
Update description to include trigger keywords:
- Add "API logs" explicitly
- Add "log analysis" as trigger phrase
- Mention "Serilog" data source
- Keep existing KQL emphasis

Before: "Generate KQL queries for Serilog logs..."
After: "Generate KQL queries for Serilog API logs and log analysis..."

### Expected Outcome
Skill triggers automatically when users mention API logs or log analysis
```

## Continuous Improvement

Skill reflection should be:
- **Iterative**: Each session reveals new insights
- **Evidence-based**: Always grounded in actual usage
- **User-centric**: Focused on user needs, not theoretical perfection
- **Practical**: Prioritize implementable improvements
- **Ongoing**: Skills should evolve with user needs

The goal is continuous refinement based on real-world usage patterns.