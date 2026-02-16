# Knowledge Base Pattern

For skills that primarily provide reference information, documentation, or schema definitions.

## Structure

```
skill-name/
├── SKILL.md (frontmatter + overview + navigation)
├── topics/
│   ├── INDEX.md
│   ├── topic1.md
│   ├── topic2.md
│   └── topic3.md
├── schemas/
│   ├── schema1.json
│   └── schema2.json
└── resources/
    ├── api-spec.yaml
    └── examples.md
```

## When to Use

- Providing reference information or documentation
- Multiple related topics or domains
- Schema, specification, or API documentation
- Need for detailed technical references
- Users need to look up specific information

## Template

```markdown
---
name: knowledge-base-name
description: [What information it provides]. Use when [user needs this information or mentions related terms].
---

# Knowledge Base Title

[Brief overview of what knowledge this skill provides]

## Available Information

Organized by topic:

- **[Topic Category 1]** - Read topics/[category1]/INDEX.md
  - [Brief description]
  
- **[Topic Category 2]** - Read topics/[category2]/INDEX.md
  - [Brief description]
  
- **[Topic Category 3]** - Read topics/[category3]/INDEX.md
  - [Brief description]

## Quick Reference

[Most commonly needed information - like a cheat sheet]

## Schemas and Specifications

- [Schema 1] - Read schemas/[schema1].json
- [Spec 1] - Read resources/[spec1].yaml

## What Are You Looking For?

**[Common question 1]:**
→ Read topics/[relevant-topic].md

**[Common question 2]:**
→ Read topics/[relevant-topic].md

**[Common question 3]:**
→ Read topics/[relevant-topic].md

## Resources

[Links to all documentation files]
```

## Complete Example: Company API Documentation

**SKILL.md:**
```markdown
---
name: company-api
description: Access company API documentation, endpoints, authentication, and integration examples. Use when user needs to integrate with company APIs, mentions API endpoints, or asks about API usage.
---

# Company API Documentation

Complete reference for integrating with company APIs.

## Available APIs

Organized by function:

- **Authentication API** - Read topics/authentication/INDEX.md
  - OAuth2 flow, API keys, token management
  
- **Data API** - Read topics/data-api/INDEX.md
  - Query data, create/update records, batch operations
  
- **Webhook API** - Read topics/webhooks/INDEX.md
  - Event subscriptions, payload validation, retry logic
  
- **Reporting API** - Read topics/reporting/INDEX.md
  - Generate reports, export data, scheduled reports

## Quick Reference

**Base URL:** `https://api.company.com/v2`

**Authentication:**
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
     https://api.company.com/v2/endpoint
```

**Rate Limits:**
- Standard: 100 requests/minute
- Enterprise: 1000 requests/minute

**Response Format:** JSON (all endpoints)

## Common Tasks

**Need to authenticate?**
→ Read topics/authentication/oauth2-flow.md

**Need to query data?**
→ Read topics/data-api/query-data.md

**Need to receive webhooks?**
→ Read topics/webhooks/setup-webhooks.md

**Need to generate reports?**
→ Read topics/reporting/generate-reports.md

## API Schemas

Complete request/response schemas:
- Authentication: schemas/auth-schema.json
- Data API: schemas/data-schema.json
- Webhooks: schemas/webhook-schema.json
- Reporting: schemas/reporting-schema.json

## Quick Start Example

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
    "https://api.company.com/v2/data",
    headers={"Authorization": f"Bearer {token}"}
)
data = data_response.json()
print(data)
```

## Resources

- [topics/INDEX.md](topics/INDEX.md) - All documentation organized by topic
- [schemas/](schemas/) - Request/response schemas
- [resources/api-spec.yaml](resources/api-spec.yaml) - OpenAPI specification
```

**topics/INDEX.md:**
```markdown
# API Documentation Topics

All documentation organized by functional area.

## Authentication

**File: [authentication/INDEX.md](authentication/INDEX.md)**

Topics covered:
- OAuth2 authentication flow
- API key management
- Token refresh and expiration
- Service account authentication

## Data API

**File: [data-api/INDEX.md](data-api/INDEX.md)**

Topics covered:
- Query data with filters
- Create and update records
- Batch operations
- Pagination and sorting
- Error handling

## Webhooks

**File: [webhooks/INDEX.md](webhooks/INDEX.md)**

Topics covered:
- Setting up webhook endpoints
- Event types and payloads
- Signature verification
- Retry logic and error handling
- Testing webhooks

## Reporting

**File: [reporting/INDEX.md](reporting/INDEX.md)**

Topics covered:
- Generate custom reports
- Export data in various formats
- Schedule automated reports
- Report templates
- Performance considerations

## Error Handling

**File: [error-handling.md](error-handling.md)**

Topics covered:
- HTTP status codes
- Error response format
- Common errors and solutions
- Retry strategies
```

**topics/authentication/oauth2-flow.md:**
```markdown
# OAuth2 Authentication Flow

Complete guide to authenticating with OAuth2.

## Overview

Company API uses OAuth2 with the authorization code grant flow.

## Step 1: Obtain Authorization Code

Redirect user to authorization endpoint:

```
https://api.company.com/auth/authorize?
  client_id=YOUR_CLIENT_ID&
  redirect_uri=YOUR_REDIRECT_URI&
  response_type=code&
  scope=read write
```

**Required parameters:**
- `client_id`: Your application's client ID
- `redirect_uri`: Where to send user after authorization
- `response_type`: Must be "code"
- `scope`: Space-separated list of permissions

## Step 2: Exchange Code for Token

User will be redirected back to your `redirect_uri` with a code:

```
https://your-app.com/callback?code=AUTH_CODE
```

Exchange this code for an access token:

```python
import requests

response = requests.post(
    "https://api.company.com/auth/token",
    json={
        "grant_type": "authorization_code",
        "code": "AUTH_CODE",
        "client_id": "YOUR_CLIENT_ID",
        "client_secret": "YOUR_CLIENT_SECRET",
        "redirect_uri": "YOUR_REDIRECT_URI"
    }
)

token_data = response.json()
access_token = token_data["access_token"]
refresh_token = token_data["refresh_token"]
expires_in = token_data["expires_in"]  # seconds
```

## Step 3: Use Access Token

Include token in Authorization header:

```python
headers = {"Authorization": f"Bearer {access_token}"}
response = requests.get(
    "https://api.company.com/v2/data",
    headers=headers
)
```

## Step 4: Refresh Token

When token expires, use refresh token to get new access token:

```python
response = requests.post(
    "https://api.company.com/auth/token",
    json={
        "grant_type": "refresh_token",
        "refresh_token": refresh_token,
        "client_id": "YOUR_CLIENT_ID",
        "client_secret": "YOUR_CLIENT_SECRET"
    }
)

new_token_data = response.json()
access_token = new_token_data["access_token"]
```

## Complete Example

```python
import requests
from flask import Flask, redirect, request

app = Flask(__name__)

CLIENT_ID = "your_client_id"
CLIENT_SECRET = "your_client_secret"
REDIRECT_URI = "http://localhost:5000/callback"

@app.route("/login")
def login():
    auth_url = f"https://api.company.com/auth/authorize?client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}&response_type=code&scope=read write"
    return redirect(auth_url)

@app.route("/callback")
def callback():
    code = request.args.get("code")
    
    # Exchange code for token
    response = requests.post(
        "https://api.company.com/auth/token",
        json={
            "grant_type": "authorization_code",
            "code": code,
            "client_id": CLIENT_ID,
            "client_secret": CLIENT_SECRET,
            "redirect_uri": REDIRECT_URI
        }
    )
    
    token_data = response.json()
    # Store tokens securely
    
    return "Authenticated successfully!"

if __name__ == "__main__":
    app.run(port=5000)
```

## Security Best Practices

1. **Store secrets securely** - Never hardcode client secrets
2. **Use HTTPS** - Always use secure connections
3. **Validate redirect_uri** - Prevent authorization code interception
4. **Short-lived tokens** - Access tokens expire in 1 hour
5. **Secure token storage** - Encrypt tokens at rest

## Troubleshooting

**Error: "invalid_client"**
→ Check client_id and client_secret are correct

**Error: "invalid_grant"**
→ Authorization code has expired or been used already

**Error: "invalid_scope"**
→ Requested scope not allowed for your application

## Related Topics

- [API key authentication](api-key-auth.md) - Simpler alternative for server-to-server
- [Token management](token-management.md) - Best practices for storing tokens
- [Service accounts](service-accounts.md) - Automated workflows
```

## Key Characteristics

- **Reference-focused**: Primarily documentation and lookup
- **Well-organized**: Clear categorization and indexing
- **Searchable**: Easy to find specific information
- **Complete examples**: Show real-world usage
- **Schema definitions**: Structured data specifications

## Validation Checklist

Before finalizing:
- [ ] Topics organized logically with INDEX files
- [ ] Each topic has complete, standalone documentation
- [ ] Schemas/specs in appropriate formats (JSON, YAML, etc.)
- [ ] Cross-references between related topics work
- [ ] Quick reference section for common needs
- [ ] Examples are complete and runnable
- [ ] Description includes relevant search keywords
