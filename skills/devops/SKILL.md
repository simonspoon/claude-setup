---
name: devops
description: Create and manage CI/CD pipelines, Docker configurations, deployment scripts, and infrastructure. Use when working with GitHub Actions, CI/CD, Docker, docker-compose, deployment, infrastructure, Terraform, pipelines, devops, containerization, environment management, or build automation.
---

# DevOps

Create and manage CI/CD pipelines, container configurations, deployment scripts, and infrastructure patterns.

## Critical Requirements

- **Every deployment artifact (script, workflow, or pipeline) MUST include or document rollback steps.** This applies to bash scripts, GitHub Actions deploy workflows, and any other deployment mechanism. If the deployment method doesn't support automated rollback, add a comment block documenting the manual rollback procedure.

## Prerequisites

- For GitHub Actions: repository must be on GitHub
- For Docker: Docker/Podman installed locally for testing
- For infrastructure: relevant CLI tools (terraform, aws, gcloud, etc.)

## Activation Protocol

1. **Detect the project's package manager and toolchain.** Do NOT assume tools from user preferences — check what the project actually uses:
   ```bash
   # JavaScript/TypeScript — check lock file (first match wins)
   if [ -f pnpm-lock.yaml ]; then echo "pnpm"
   elif [ -f yarn.lock ]; then echo "yarn"
   elif [ -f package-lock.json ]; then echo "npm"
   fi
   # Python — check for uv, poetry, pip (first match wins)
   if [ -f uv.lock ]; then echo "uv"
   elif [ -f poetry.lock ]; then echo "poetry"
   elif [ -f requirements.txt ]; then echo "pip"
   fi
   ```
   Use the DETECTED package manager in all generated configs. If no lock file exists, then fall back to user preferences (pnpm for JS, uv for Python).
2. Determine the task type (see "What Do You Need?" below).
3. Read the relevant reference file for patterns and examples.
4. Check for existing CI/CD or Docker configuration in the project.
5. Follow the appropriate workflow.

## What Do You Need?

**GitHub Actions workflow:**
Read reference/github-actions.md, then:
1. **Run the Pre-Flight Checklist** in reference/github-actions.md BEFORE writing any workflow. This catches system deps, binary name mismatches, and Tauri gotchas that cause CI failures.
2. Check `.github/workflows/` for existing workflows.
3. If existing workflows are found, review them and update rather than replace. Bump pinned action versions if outdated.
4. If no workflows exist, create a new workflow YAML using the language-appropriate pattern.
5. Validate syntax: `actionlint` if available, otherwise manual review.
6. Test locally with `act` if available.

**Docker configuration:**
Read reference/docker.md, then:
1. Check for existing `Dockerfile`, `docker-compose.yml`, `.dockerignore`.
2. Create or modify container configuration.
3. Build and test locally before committing.

**Deployment script or workflow:**
1. Determine target environment and deployment method.
2. For bash scripts: use the deployment script template below with proper error handling.
3. For GitHub Actions deploy workflows: add a rollback job that triggers on deploy failure, or document rollback in a comment block at the top of the workflow.
4. Include rollback instructions or mechanism — see Critical Requirements above.
5. Test in a safe environment first.

**Infrastructure guidance:**
1. Identify the infrastructure tool (Terraform, CloudFormation, etc.).
2. Apply infrastructure-as-code best practices.
3. Ensure state management is configured.
4. Review security implications.

## GitHub Actions Quick Reference

### Common Workflow Structure
```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - name: Setup
        # language-specific setup
      - name: Install dependencies
        # package install
      - name: Lint
        # linter
      - name: Test
        # test runner
```

### Language-Specific Patterns

Read reference/github-actions.md for complete patterns for:
- Python (uv + pytest)
- JavaScript/TypeScript (pnpm + vitest/jest)
- Rust (cargo)
- Go

For monorepos, combine the relevant language patterns into separate jobs within one workflow, using path filters to trigger only affected jobs.

## Docker Quick Reference

### Dockerfile Best Practices
```dockerfile
# Use specific version tags, not :latest
FROM python:3.12-slim AS builder

# Install dependencies first (layer caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code last
COPY . .

# Run as non-root user
RUN useradd -r appuser
USER appuser

CMD ["python", "-m", "myapp"]
```

Read reference/docker.md for multi-stage builds, compose patterns, and .dockerignore templates.

## Deployment Script Template

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration
APP_NAME="${APP_NAME:?APP_NAME must be set}"
DEPLOY_ENV="${DEPLOY_ENV:?DEPLOY_ENV must be set}"
PREVIOUS_VERSION="${PREVIOUS_VERSION:-}"

echo "Deploying ${APP_NAME} to ${DEPLOY_ENV}..."

# Pre-deploy checks
echo "Running pre-deploy checks..."
# Add health checks, dependency verification here

# Deploy
echo "Deploying..."
# Deployment commands here

# Post-deploy verification
echo "Verifying deployment..."
# Health check the deployed service

echo "Deployment complete."

# Rollback function — call if post-deploy verification fails
rollback() {
    echo "Rolling back ${APP_NAME} on ${DEPLOY_ENV}..."
    if [[ -n "${PREVIOUS_VERSION}" ]]; then
        echo "Restoring previous version: ${PREVIOUS_VERSION}"
        # Add rollback commands here (e.g., redeploy previous image, revert migration)
    else
        echo "WARNING: No PREVIOUS_VERSION set. Manual rollback required."
    fi
}
```

## Environment Management

### Secrets and Configuration
- Use GitHub Actions secrets for CI/CD credentials.
- Use `.env.example` to document required variables (never commit `.env`). Add `.env` and `.env.*` to `.gitignore`, but keep `.env.example` tracked (`!.env.example`).
- Use environment-specific config files: `config.production.toml`, `config.staging.toml`.
- Validate all required environment variables at startup (e.g., use `${VAR:?VAR must be set}` in bash, or check at application entry point).

### Environment Parity
- Dev, staging, and production should use the same Docker image.
- Differences should be configuration only (env vars), not code.
- Pin all dependency versions across environments.

## Rules

1. **Scripts in bash.** Deployment and automation scripts use bash unless Python is required for complexity.
2. **Pin versions.** All Docker base images, GitHub Actions, and dependencies use specific version tags. Note: `@stable` is acceptable for toolchain selectors (e.g., `rust-toolchain@stable`) where a rolling stable channel is intentional.
3. **Fail fast.** Scripts use `set -euo pipefail`. CI pipelines fail on first error.
4. **No secrets in code.** Use environment variables, secret managers, or CI/CD secrets.
5. **Test before deploy.** CI must pass before any deployment step runs.
6. **Rollback plan.** Every deployment script includes or documents rollback steps.

## Reference

- **GitHub Actions patterns** -- Read reference/github-actions.md
- **Docker and Compose patterns** -- Read reference/docker.md
