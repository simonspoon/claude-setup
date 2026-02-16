# Skill Patterns and Examples

Complete examples of different skill patterns and structures.

## Pattern 1: Domain-Specific Tool Skills

For skills that wrap tools or libraries:

```markdown
---
name: data-analysis
description: Analyze datasets using pandas and generate visualizations. Use when user needs data analysis, mentions CSV/Excel files, or requests charts and statistics.
---

# Data Analysis

## Quick Start

```python
import pandas as pd
df = pd.read_csv("data.csv")
summary = df.describe()
```

## Common Operations

### Load Data
```python
# CSV files
df = pd.read_csv("data.csv")

# Excel files
df = pd.read_excel("data.xlsx", sheet_name="Sheet1")

# JSON files
df = pd.read_json("data.json")
```

### Clean Data
```python
# Remove duplicates
df = df.drop_duplicates()

# Handle missing values
df = df.fillna(0)
df = df.dropna()
```

### Analyze Data
```python
# Descriptive statistics
summary = df.describe()

# Group by operations
grouped = df.groupby("category")["value"].sum()
```

### Visualize Results
```python
import matplotlib.pyplot as plt

df.plot(kind="bar")
plt.savefig("chart.png")
```

## Reference
See [PANDAS-REFERENCE.md](PANDAS-REFERENCE.md) for complete API documentation.
```

**Directory Structure:**
```
data-analysis/
├── SKILL.md
└── PANDAS-REFERENCE.md
```

---

## Pattern 2: Process/Workflow Skills

For skills encoding organizational processes:

```markdown
---
name: code-review
description: Review code following company standards for security, performance, and style. Use when reviewing pull requests or when user asks for code review.
---

# Code Review Process

Follow this systematic process to review code changes.

## Review Checklist

1. **Security Review** (see [SECURITY.md](SECURITY.md))
   - Check for SQL injection vulnerabilities
   - Verify authentication/authorization
   - Review data validation

2. **Performance Analysis**
   - Check for inefficient queries
   - Look for N+1 query patterns
   - Verify proper caching

3. **Code Style Compliance**
   - Run linter: `npm run lint`
   - Check formatting: `npm run format:check`
   - Review naming conventions

4. **Test Coverage**
   - Verify unit tests exist
   - Check coverage threshold: `npm run test:coverage`
   - Review edge cases

5. **Documentation Completeness**
   - API endpoints documented
   - Complex logic has comments
   - README updated if needed

## Standards

- [SECURITY.md](SECURITY.md) - Security guidelines and common vulnerabilities
- [STYLE.md](STYLE.md) - Code style guide and conventions
- [TESTING.md](TESTING.md) - Test requirements and patterns

## Quick Review

For simple changes, focus on:
1. Security implications
2. Test coverage
3. Basic style compliance
```

**Directory Structure:**
```
code-review/
├── SKILL.md
├── SECURITY.md
├── STYLE.md
└── TESTING.md
```

---

## Pattern 3: Knowledge Base Skills

For skills providing reference information:

```markdown
---
name: company-api
description: Access company API documentation and generate integration code. Use when user needs to integrate with company APIs or asks about API endpoints.
---

# Company API Integration

Documentation and examples for integrating with company APIs.

## Available APIs

- **Authentication API** (see [AUTH.md](AUTH.md))
  - OAuth2 flow
  - API key management
  - Token refresh

- **Data API** (see [DATA.md](DATA.md))
  - Query data
  - Create/update records
  - Batch operations

- **Webhook API** (see [WEBHOOKS.md](WEBHOOKS.md))
  - Event subscriptions
  - Payload validation
  - Retry logic

## Quick Example

```python
import requests

# Authenticate
auth_response = requests.post(
    "https://api.company.com/auth/token",
    json={"api_key": "your-key"}
)
token = auth_response.json()["access_token"]

# Fetch data
data_response = requests.get(
    "https://api.company.com/data",
    headers={"Authorization": f"Bearer {token}"}
)
data = data_response.json()
```

## Complete Documentation

See individual API guides for:
- Detailed endpoint specifications
- Request/response schemas
- Error handling
- Rate limiting
- Best practices
```

**Directory Structure:**
```
company-api/
├── SKILL.md
├── AUTH.md
├── DATA.md
├── WEBHOOKS.md
└── schemas/
    ├── auth-schema.json
    ├── data-schema.json
    └── webhook-schema.json
```

---

## Example 1: Minimal Skill

A simple, single-file skill for basic operations:

```
simple-formatter/
└── SKILL.md
```

```yaml
---
name: simple-formatter
description: Format JSON and XML data for readability. Use when user asks to format, prettify, or clean up JSON or XML.
---

# Simple Formatter

Quick formatting for common data formats.

## Format JSON

```python
import json

# Parse and format
data = json.loads(input_string)
formatted = json.dumps(data, indent=2, sort_keys=True)
print(formatted)
```

## Format XML

```python
import xml.dom.minidom as minidom

# Parse and format
dom = minidom.parseString(xml_string)
formatted = dom.toprettyxml(indent="  ")
print(formatted)
```

## Format YAML

```python
import yaml

# Parse and format
data = yaml.safe_load(yaml_string)
formatted = yaml.dump(data, default_flow_style=False, sort_keys=True)
print(formatted)
```
```

---

## Example 2: Comprehensive Skill with Scripts

A full-featured skill with multiple files and automation:

```
data-platform/
├── SKILL.md
├── SCHEMAS.md
├── QUERIES.md
├── BEST-PRACTICES.md
└── scripts/
    ├── validate_query.py
    └── optimize_query.py
```

**SKILL.md:**
```markdown
---
name: data-platform
description: Generate and optimize SQL queries for the company data platform. Use when working with company databases, data warehouse, or when user mentions SQL queries for internal data.
---

# Data Platform

Work with the company data platform using best practices and validated queries.

## Quick Start

```python
from scripts.validate_query import validate
from scripts.optimize_query import optimize

query = "SELECT * FROM users WHERE status = 'active'"

# Validate query
is_valid, errors = validate(query)

# Optimize query
optimized = optimize(query)
```

## Database Schemas

See [SCHEMAS.md](SCHEMAS.md) for:
- Complete table definitions
- Column types and constraints
- Relationships and foreign keys
- Indexes

## Query Patterns

See [QUERIES.md](QUERIES.md) for:
- Common query templates
- Join patterns
- Aggregation examples
- Performance tips

## Best Practices

See [BEST-PRACTICES.md](BEST-PRACTICES.md) for:
- Security guidelines (preventing SQL injection)
- Performance optimization
- Query testing procedures
- Monitoring and alerting
```

**scripts/validate_query.py:**
```python
#!/usr/bin/env python3
import sys
import sqlparse

def validate(query):
    """Validate SQL query syntax and check for common issues."""
    errors = []
    
    # Parse query
    try:
        parsed = sqlparse.parse(query)
        if not parsed:
            errors.append("Empty or invalid query")
            return False, errors
    except Exception as e:
        errors.append(f"Parse error: {str(e)}")
        return False, errors
    
    # Check for SELECT *
    if "SELECT *" in query.upper():
        errors.append("Avoid SELECT * - specify columns explicitly")
    
    # Check for missing WHERE on DELETE/UPDATE
    if ("DELETE FROM" in query.upper() or "UPDATE" in query.upper()) and "WHERE" not in query.upper():
        errors.append("DELETE/UPDATE without WHERE clause is dangerous")
    
    return len(errors) == 0, errors

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: validate_query.py 'SELECT * FROM table'")
        sys.exit(1)
    
    query = sys.argv[1]
    is_valid, errors = validate(query)
    
    if is_valid:
        print("✓ Query is valid")
    else:
        print("✗ Query has issues:")
        for error in errors:
            print(f"  - {error}")
        sys.exit(1)
```

---

## Example 3: Configuration Management Skill

A skill for managing configurations:

```markdown
---
name: config-manager
description: Manage application configurations across environments (dev, staging, prod). Use when working with config files, environment variables, or deployment configurations.
---

# Configuration Manager

Manage and validate application configurations safely.

## Environments

We support three environments:
- **dev**: Development (local and CI)
- **staging**: Pre-production testing
- **prod**: Production

## Quick Operations

### View Configuration
```bash
./scripts/config.py view staging
```

### Validate Configuration
```bash
./scripts/config.py validate configs/prod.yaml
```

### Generate Config from Template
```bash
./scripts/config.py generate --env prod --output configs/prod.yaml
```

## Configuration Schema

See [SCHEMA.md](SCHEMA.md) for:
- Required fields
- Optional fields
- Value types and constraints
- Environment-specific overrides

## Security Guidelines

**Never commit:**
- API keys or secrets
- Database passwords
- Service credentials

**Always use:**
- Environment variables for secrets
- Secret management service (AWS Secrets Manager)
- Encrypted values for sensitive config

See [SECURITY.md](SECURITY.md) for complete guidelines.

## Templates

See `templates/` directory for:
- `base-config.yaml` - Base configuration template
- `dev-overrides.yaml` - Dev environment specific
- `prod-overrides.yaml` - Prod environment specific
```

**Directory Structure:**
```
config-manager/
├── SKILL.md
├── SCHEMA.md
├── SECURITY.md
├── scripts/
│   └── config.py
└── templates/
    ├── base-config.yaml
    ├── dev-overrides.yaml
    └── prod-overrides.yaml
```

---

## Pattern Selection Guide

**Choose Minimal Skill when:**
- Simple, focused functionality
- No need for additional references
- All content fits comfortably in one file
- No scripts or automation needed

**Choose Domain-Specific Tool Skill when:**
- Wrapping a library or tool
- Need API reference documentation
- Multiple related operations
- Examples can demonstrate common patterns

**Choose Process/Workflow Skill when:**
- Encoding organizational processes
- Multiple steps or phases
- References to standards/guidelines
- Checklists and procedures

**Choose Knowledge Base Skill when:**
- Providing reference information
- Multiple related topics
- Need for detailed documentation
- Schema or spec files to include

**Choose Comprehensive Skill when:**
- Complex functionality
- Need for automation scripts
- Multiple reference documents
- Template files or examples
- Large amounts of reference data
