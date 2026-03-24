# Common Anti-Patterns to Fix

### Anti-Pattern 1: "Figure it out" Instructions
- Bad: "Query the appropriate table based on what you're looking for"
- Good: "If looking for user info, read common-queries/user-lookup.md. If looking for patient info, read common-queries/patient-lookup.md"

### Anti-Pattern 2: Undocumented Templates
- Bad: Just showing `SELECT * FROM table WHERE name = '[Name]'`
- Good: Template + "Replace [Name] with the user's full name from their request. Example: If user says 'find John Doe', use 'John Doe'"

### Anti-Pattern 3: Missing Escalation
- Bad: No guidance when query returns unexpected results
- Good: "If 0 results and user expects data -> read troubleshooting/no-results.md. If unclear whether 0 is valid -> ask user: 'No records found for [criteria]. Is this expected?'"

### Anti-Pattern 4: Dumping Information
- Bad: Single file with 20 examples
- Good: Index listing 20 examples by purpose -> agent reads index -> picks one -> reads only that file

### Anti-Pattern 5: Buried Critical Requirements
- Bad: "Remember to use WITH (NOLOCK)" buried in paragraph
- Good: "CRITICAL: Always use `WITH (NOLOCK)`" at top of SKILL.md
