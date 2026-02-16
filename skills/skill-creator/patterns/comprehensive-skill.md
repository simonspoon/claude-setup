# Comprehensive Pattern

For complex skills requiring multiple files, scripts, and extensive documentation.

## Structure

```
skill-name/
├── SKILL.md (frontmatter + core requirements + navigation)
├── guides/
│   ├── INDEX.md
│   ├── getting-started.md
│   ├── advanced-usage.md
│   └── troubleshooting.md
├── operations/
│   ├── INDEX.md
│   ├── operation1.md
│   └── operation2.md
├── scripts/
│   ├── validate.py
│   ├── generate.py
│   └── optimize.py
├── schemas/
│   └── schema.json
├── templates/
│   └── template.yaml
└── resources/
    └── reference.md
```

## When to Use

- Complex functionality requiring multiple components
- Need automation scripts for validation/generation
- Large amounts of reference data or templates
- Multiple workflows and use cases
- Scripts reduce context consumption or ensure determinism

## Template

```markdown
---
name: skill-name
description: [What it does]. Use when [comprehensive list of trigger conditions].
---

# Skill Title

[Brief overview of capabilities]

## ⚠️ CRITICAL REQUIREMENTS

[Universal requirements that apply to ALL operations]

## Quick Start

[Simplest possible example - often using a script]

```bash
python scripts/operation.py --input data.txt
```

## What Are You Trying To Do?

**[Common task 1]:**
→ Read operations/[task1].md

**[Common task 2]:**
→ Read operations/[task2].md

**[Advanced usage]:**
→ Read guides/advanced-usage.md

**[Something broken]:**
→ Read guides/troubleshooting.md

## Available Scripts

Scripts for deterministic operations:

- `scripts/validate.py` - Validate inputs
- `scripts/generate.py` - Generate outputs
- `scripts/optimize.py` - Optimize configurations

## Key Resources

- Operations: operations/INDEX.md
- Guides: guides/INDEX.md
- Schemas: schemas/
- Templates: templates/

## Resources

[Links to all documentation]
```

## Complete Example: Database Query System

**SKILL.md:**
```markdown
---
name: data-platform
description: Generate and optimize SQL queries for company data platform following schema conventions and performance best practices. Use when working with company databases, data warehouse, SQL queries, mentions tables, or needs database queries.
---

# Data Platform Query System

Generate, validate, and optimize SQL queries for the company data platform.

## ⚠️ CRITICAL REQUIREMENTS

Every query MUST:
- Use `WITH (NOLOCK)` on all SELECT statements
- Include `TOP 100` limit unless user specifies otherwise
- Check `DeletedDate IS NULL` for soft-deleted records
- Be validated before execution (use `scripts/validate_query.py`)

## Quick Start

```bash
# Validate a query
python scripts/validate_query.py "SELECT TOP 100 * FROM users WITH (NOLOCK) WHERE DeletedDate IS NULL"

# Generate optimized query from template
python scripts/generate_query.py --template user-lookup --params "name=John Doe"

# Optimize existing query
python scripts/optimize_query.py --input query.sql --output optimized.sql
```

## What Are You Trying To Do?

**Look up user information:**
→ Read operations/user-lookup.md

**Search patient records:**
→ Read operations/patient-search.md

**Query provider data:**
→ Read operations/provider-queries.md

**Join multiple tables:**
→ Read operations/complex-joins.md

**Optimize slow query:**
→ Use `scripts/optimize_query.py` or read guides/query-optimization.md

**Something not working:**
→ Read guides/troubleshooting.md

## Available Scripts

Use scripts for deterministic operations:

### validate_query.py
Validates SQL syntax and checks for common issues.

```bash
python scripts/validate_query.py "SELECT * FROM users"
```

**Checks:**
- Valid SQL syntax
- Includes `WITH (NOLOCK)`
- Has `TOP` limit
- Checks `DeletedDate IS NULL`
- No SQL injection patterns

### generate_query.py
Generates queries from templates with placeholders.

```bash
python scripts/generate_query.py --template user-lookup --params "user_id=123"
```

### optimize_query.py
Analyzes and optimizes query performance.

```bash
python scripts/optimize_query.py --input query.sql
```

**Optimizations:**
- Index suggestions
- Join order improvements
- Subquery to JOIN conversions
- Unnecessary column removal

## Database Schemas

Complete table definitions: Read schemas/database-schema.md

**Quick reference:**
- Users: `CadabraUser` table
- Patients: `Patient` table  
- Providers: `Provider` table
- Appointments: `Appointment` table

## Query Templates

Pre-built queries: templates/

- `user-lookup.sql` - Find user by ID or name
- `patient-search.sql` - Search patient records
- `provider-query.sql` - Query provider information
- `appointment-list.sql` - List appointments

## Resources

- [operations/INDEX.md](operations/INDEX.md) - All query operations
- [guides/INDEX.md](guides/INDEX.md) - Comprehensive guides
- [schemas/](schemas/) - Database schema documentation
- [templates/](templates/) - Query templates
```

**scripts/validate_query.py:**
```python
#!/usr/bin/env python3
"""
Validate SQL queries for company data platform.

Checks:
- SQL syntax validity
- Required WITH (NOLOCK) clause
- TOP limit present
- DeletedDate IS NULL check
- No SQL injection patterns
"""

import sys
import re
import sqlparse
from typing import Tuple, List


def validate_query(query: str) -> Tuple[bool, List[str]]:
    """
    Validate a SQL query.
    
    Returns:
        Tuple of (is_valid, list_of_errors)
    """
    errors = []
    
    # Parse SQL
    try:
        parsed = sqlparse.parse(query)
        if not parsed:
            errors.append("Empty or invalid query")
            return False, errors
    except Exception as e:
        errors.append(f"SQL parse error: {str(e)}")
        return False, errors
    
    query_upper = query.upper()
    
    # Check for WITH (NOLOCK)
    if "SELECT" in query_upper and "WITH (NOLOCK)" not in query_upper:
        errors.append("Missing WITH (NOLOCK) - required for all SELECT queries")
    
    # Check for TOP limit
    if "SELECT" in query_upper and "TOP" not in query_upper:
        errors.append("Missing TOP limit - add TOP 100 or specify limit")
    
    # Check for DELETE/UPDATE without WHERE
    if ("DELETE FROM" in query_upper or "UPDATE" in query_upper) and "WHERE" not in query_upper:
        errors.append("DANGEROUS: DELETE/UPDATE without WHERE clause")
    
    # Check for DeletedDate filter (common tables have soft deletes)
    if "SELECT" in query_upper and "FROM" in query_upper:
        # Extract table names
        tables = re.findall(r'FROM\s+(\w+)', query_upper)
        soft_delete_tables = ['USERS', 'CADABRAUSER', 'PATIENT', 'PROVIDER', 'APPOINTMENT']
        
        for table in tables:
            if table in soft_delete_tables and "DELETEDDATE IS NULL" not in query_upper:
                errors.append(f"Missing DeletedDate IS NULL check for table {table} (soft deletes)")
    
    # Check for potential SQL injection patterns
    dangerous_patterns = [
        r";\s*DROP",
        r";\s*DELETE",
        r"EXEC\s*\(",
        r"EXECUTE\s*\(",
    ]
    
    for pattern in dangerous_patterns:
        if re.search(pattern, query_upper):
            errors.append(f"Potential SQL injection pattern detected: {pattern}")
    
    # Check for SELECT *
    if "SELECT *" in query_upper or "SELECT*" in query_upper:
        errors.append("Avoid SELECT * - specify columns explicitly for performance")
    
    return len(errors) == 0, errors


def main():
    if len(sys.argv) < 2:
        print("Usage: validate_query.py 'SELECT * FROM table'")
        sys.exit(1)
    
    query = sys.argv[1]
    is_valid, errors = validate_query(query)
    
    if is_valid:
        print("✅ Query is valid")
        sys.exit(0)
    else:
        print("❌ Query validation failed:")
        for error in errors:
            print(f"  • {error}")
        sys.exit(1)


if __name__ == "__main__":
    main()
```

**operations/user-lookup.md:**
```markdown
# User Lookup Operation

Query user information from CadabraUser table.

## Quick Usage

```bash
# Using script (recommended)
python scripts/generate_query.py --template user-lookup --params "user_id=123"

# Manual query
```

## Query Template

```sql
SELECT TOP 100
    UserId,
    FirstName,
    LastName,
    Email,
    CreatedDate
FROM CadabraUser WITH (NOLOCK)
WHERE 
    DeletedDate IS NULL
    AND UserId = @UserId
```

## Placeholder Documentation

**@UserId**: 
- Get from: User's request (e.g., "user 123")
- Format: Integer (no quotes)
- Example: `123`

## Complete Example

**Scenario:** Find user with ID 123

**Query:**
```sql
SELECT TOP 100
    UserId,
    FirstName,
    LastName,
    Email,
    CreatedDate
FROM CadabraUser WITH (NOLOCK)
WHERE 
    DeletedDate IS NULL
    AND UserId = 123
```

**Expected Result:**
```
UserId | FirstName | LastName | Email              | CreatedDate
-------|-----------|----------|--------------------|-----------------
123    | John      | Doe      | john@example.com   | 2024-01-15
```

## Variations

### Search by Name

```sql
SELECT TOP 100
    UserId,
    FirstName,
    LastName,
    Email
FROM CadabraUser WITH (NOLOCK)
WHERE 
    DeletedDate IS NULL
    AND (FirstName LIKE @FirstName + '%' 
         OR LastName LIKE @LastName + '%')
ORDER BY LastName, FirstName
```

**Placeholders:**
- **@FirstName**: User's first name (e.g., 'John')
- **@LastName**: User's last name (e.g., 'Doe')

### Search by Email

```sql
SELECT TOP 100
    UserId,
    FirstName,
    LastName,
    Email
FROM CadabraUser WITH (NOLOCK)
WHERE 
    DeletedDate IS NULL
    AND Email = @Email
```

**Placeholders:**
- **@Email**: Email address (e.g., 'john@example.com')

## Success/Failure Conditions

**Success:** Returns 1+ rows with user data

**0 results:**
- If user expects data → Read guides/troubleshooting.md#no-results
- If unclear → Ask user: "No user found with ID {id}. Is this expected?"

**Error "Invalid object name":**
→ Table doesn't exist in this database. Check you're connected to correct DB.

**Error "Invalid column name":**
→ Read schemas/cadabrauser-schema.md to verify column names

## Validation

Before executing, validate:

```bash
python scripts/validate_query.py "YOUR_QUERY_HERE"
```

## Related Operations

- [provider-queries.md](provider-queries.md) - Query provider information
- [complex-joins.md](complex-joins.md) - Join users with other tables
```

## Key Characteristics

- **Script-driven**: Uses scripts for determinism and validation
- **Comprehensive**: Covers wide range of use cases
- **Well-organized**: Clear separation of concerns
- **Template-based**: Reusable query templates
- **Progressive**: Simple → Complex guidance
- **Validated**: Built-in validation and optimization

## Validation Checklist

Before finalizing:
- [ ] Scripts have proper error handling
- [ ] Scripts have usage examples
- [ ] Operations documented with templates
- [ ] Templates have placeholder documentation
- [ ] Schemas/specs are complete
- [ ] INDEX files for all directories
- [ ] Critical requirements clearly marked
- [ ] Troubleshooting guide exists
- [ ] All cross-references work
