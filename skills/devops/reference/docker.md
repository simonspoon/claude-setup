# Docker and Compose Patterns

## Dockerfile Best Practices

### Multi-Stage Build (Python)
```dockerfile
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/deps -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
COPY --from=builder /deps /usr/local/lib/python3.12/site-packages/
COPY . .
RUN useradd -r appuser && chown -R appuser:appuser /app
USER appuser
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Multi-Stage Build (Node.js)
```dockerfile
FROM node:22-slim AS builder
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM node:22-slim
WORKDIR /app
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod
COPY --from=builder /app/dist ./dist
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

### Multi-Stage Build (Rust)
```dockerfile
FROM rust:1.82-slim AS builder
WORKDIR /app
COPY Cargo.toml Cargo.lock ./
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release
RUN rm -rf src
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/myapp /usr/local/bin/
RUN useradd -r appuser
USER appuser
CMD ["myapp"]
```

## .dockerignore Template

```
.git
.github
.env
.env.*
node_modules
target
__pycache__
*.pyc
.pytest_cache
.mypy_cache
.ruff_cache
dist
build
*.md
!README.md
Dockerfile
docker-compose*.yml
.dockerignore
```

## Docker Compose Patterns

### Development Environment
```yaml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/node_modules  # exclude node_modules from bind mount
    environment:
      - DATABASE_URL=postgres://postgres:postgres@db:5432/myapp
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

### Production with Redis and Worker
```yaml
services:
  app:
    image: ghcr.io/org/app:${VERSION:-latest}
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 512M

  worker:
    image: ghcr.io/org/app:${VERSION:-latest}
    command: ["python", "-m", "worker"]
    environment:
      - DATABASE_URL
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
    restart: unless-stopped

volumes:
  redis-data:
```

## Key Rules

1. **Specific base image tags** — never use `:latest` in production.
2. **Layer caching** — copy dependency files before source code.
3. **Non-root user** — always create and switch to a non-root user.
4. **Multi-stage builds** — separate build dependencies from runtime.
5. **.dockerignore** — exclude `.git`, `node_modules`, build artifacts, secrets.
6. **Health checks** — define in compose for dependent services.
7. **Resource limits** — set memory/CPU limits in production compose.
8. **Named volumes** — use named volumes for persistent data, not bind mounts in production.
