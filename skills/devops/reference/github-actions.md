# GitHub Actions Patterns

Reusable workflow patterns for common CI/CD scenarios.

## Pre-Flight Checklist (Before Writing Any Workflow)

Run these checks BEFORE writing a CI or release workflow. Skipping causes CI failures.

1. **System/native dependencies**: Run `cargo tree` (Rust) or check `go.mod` for cgo. Grep for `pkg-config`, `system-deps`, or `-sys` crate suffixes. If found, add `apt-get install` / `brew install` steps.
2. **Binary names vs crate names**: Check `[[bin]]` sections in all `Cargo.toml` files. The binary name may differ from the crate name (e.g., crate `qorvex-cli` → binary `qorvex`).
3. **Workspace vs single crate**: Check for `[workspace]` in root `Cargo.toml`. Use `--workspace` flags for workspaces.
4. **Version injection**: For Go, check if version is hardcoded — add `-ldflags -X` to inject tag. For Rust, check if `clap` reads version from `Cargo.toml` (automatic) or needs build-time injection.
5. **Tauri projects**: Use `tauri-apps/tauri-action` with `tagName` for direct release upload. Do NOT use artifact upload/download — the bundle paths are deeply nested and globs won't match reliably.
6. **macOS system deps**: `brew install` for native libs. Linux: `apt-get install` for `-dev` packages (e.g., `libwebkit2gtk-4.1-dev` for Tauri on Linux).

## Python (uv + pytest)

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: astral-sh/setup-uv@v4
      - name: Install dependencies
        run: uv sync
      - name: Lint
        run: uv run ruff check .
      - name: Format check
        run: uv run ruff format --check .
      - name: Test
        run: uv run pytest --cov=src --cov-fail-under=80
```

## JavaScript/TypeScript (pnpm + vitest)

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
          cache: 'pnpm'
      - name: Install dependencies
        run: pnpm install --frozen-lockfile
      - name: Lint
        run: pnpm lint
      - name: Type check
        run: pnpm tsc --noEmit
      - name: Test
        run: pnpm vitest run --coverage
```

## Rust (cargo)

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: dtolnay/rust-toolchain@stable
      - uses: Swatinem/rust-cache@v2
      - name: Check
        run: cargo check --workspace --all-targets
      - name: Test
        run: cargo test --workspace --all-targets
      - name: Clippy
        run: cargo clippy --workspace --all-targets -- -D warnings

  fmt:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: dtolnay/rust-toolchain@stable
        with:
          components: rustfmt
      - run: cargo fmt --check
```

## Go

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-go@v6
        with:
          go-version-file: go.mod
      - name: Vet
        run: go vet ./...
      - name: Test
        run: go test -race -cover ./...
```

## Release: Rust Cross-Platform Binaries

Tag-triggered, builds for 5 targets, each job uploads directly to the release.

```yaml
name: Release
on:
  push:
    tags: ['v*']

permissions:
  contents: write

jobs:
  build:
    strategy:
      matrix:
        include:
          - target: x86_64-unknown-linux-gnu
            os: ubuntu-latest
            name: mycli-linux-amd64
          - target: aarch64-unknown-linux-gnu
            os: ubuntu-latest
            name: mycli-linux-arm64
          - target: x86_64-apple-darwin
            os: macos-latest
            name: mycli-darwin-amd64
          - target: aarch64-apple-darwin
            os: macos-latest
            name: mycli-darwin-arm64
          - target: x86_64-pc-windows-msvc
            os: windows-latest
            name: mycli-windows-amd64.exe

    runs-on: ${{ matrix.os }}

    steps:
      - uses: actions/checkout@v5
      - uses: dtolnay/rust-toolchain@stable
        with:
          targets: ${{ matrix.target }}

      - name: Install cross-compilation tools
        if: matrix.target == 'aarch64-unknown-linux-gnu'
        run: |
          sudo apt-get update
          sudo apt-get install -y gcc-aarch64-linux-gnu
          echo "CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc" >> $GITHUB_ENV

      - name: Build
        run: cargo build --release --target ${{ matrix.target }}

      - name: Rename binary (unix)
        if: runner.os != 'Windows'
        run: cp target/${{ matrix.target }}/release/BINARY_NAME ${{ matrix.name }}

      - name: Rename binary (windows)
        if: runner.os == 'Windows'
        run: cp target/${{ matrix.target }}/release/BINARY_NAME.exe ${{ matrix.name }}

      - name: Upload to release
        uses: softprops/action-gh-release@v2
        with:
          files: ${{ matrix.name }}
```

**Replace** `mycli` with the release asset prefix and `BINARY_NAME` with the actual binary name from `[[bin]]` in Cargo.toml.

## Release: Go Cross-Platform Binaries

```yaml
name: Release
on:
  push:
    tags: ['v*']

permissions:
  contents: write

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0
      - uses: actions/setup-go@v6
        with:
          go-version-file: go.mod
      - name: Run tests
        run: go test -v ./...
      - name: Build binaries
        env:
          LDFLAGS: -s -w -X your/package/path.Version=${{ github.ref_name }}
        run: |
          mkdir -p dist
          for pair in linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64 windows/arm64; do
            IFS='/' read -r os arch <<< "$pair"
            ext=""; [ "$os" = "windows" ] && ext=".exe"
            GOOS=$os GOARCH=$arch go build -ldflags="${LDFLAGS}" -o "dist/mycli-${os}-${arch}${ext}" ./cmd/mycli
          done
          cd dist && sha256sum * > checksums.txt
      - uses: softprops/action-gh-release@v2
        with:
          files: dist/*
          generate_release_notes: true
```

**Replace** `your/package/path.Version` with the ldflags path to the version variable, and `mycli` with the binary name.

## Release: Tauri Desktop App + CLI

Two parallel job groups: CLI binaries (cross-platform) and Tauri app bundles. Each job uploads directly to the release — do NOT use artifact download/merge for Tauri bundles.

```yaml
name: Release
on:
  push:
    tags: ['v*']

permissions:
  contents: write

jobs:
  cli:
    # Use the "Rust Cross-Platform Binaries" pattern above
    # with: cargo build --release --target ${{ matrix.target }} -p CLI_CRATE_NAME

  app:
    strategy:
      matrix:
        include:
          - os: macos-latest
            args: --target universal-apple-darwin
          - os: ubuntu-latest
            args: ""
          - os: windows-latest
            args: ""
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v5
      - uses: dtolnay/rust-toolchain@stable
        with:
          targets: ${{ matrix.os == 'macos-latest' && 'aarch64-apple-darwin,x86_64-apple-darwin' || '' }}
      - name: Install system dependencies (Linux)
        if: runner.os == 'Linux'
        run: |
          sudo apt-get update
          sudo apt-get install -y libwebkit2gtk-4.1-dev libappindicator3-dev librsvg2-dev patchelf
      - uses: pnpm/action-setup@v4
        with:
          version: 9
      - uses: actions/setup-node@v4
        with:
          node-version: lts/*
          cache: pnpm
          cache-dependency-path: APP_DIR/pnpm-lock.yaml
      - name: Install frontend dependencies
        run: pnpm install
        working-directory: APP_DIR
      - name: Build and upload Tauri app
        uses: tauri-apps/tauri-action@v0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          projectPath: APP_DIR
          tauriScript: pnpm tauri
          args: ${{ matrix.args }}
          tagName: ${{ github.ref_name }}
          releaseName: ${{ github.ref_name }}
          releaseDraft: false
          prerelease: false
```

**Replace** `APP_DIR` with the frontend directory (e.g., `app`), `CLI_CRATE_NAME` with the crate `-p` flag.

**Key**: `tauri-action` with `tagName` uploads .dmg, .msi, .deb, .AppImage, .rpm directly to the GitHub Release. Do not try to capture these via `upload-artifact` — the bundle paths are deeply nested and glob patterns fail.

## Docker Build and Push

```yaml
name: Docker
on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      packages: write
    steps:
      - uses: actions/checkout@v5
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v6
        with:
          push: true
          tags: |
            ghcr.io/${{ github.repository }}:${{ github.sha }}
            ghcr.io/${{ github.repository }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

## Matrix Testing

```yaml
jobs:
  test:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest]
        version: ['3.11', '3.12', '3.13']
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v5
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.version }}
      - run: pip install -e ".[test]"
      - run: pytest
```

## Workflow Tips

- **Cache dependencies** to speed up builds (most setup actions support `cache` parameter).
- **Use `--frozen-lockfile`** (pnpm) or equivalent to catch missing lock file updates.
- **Separate lint and test jobs** for faster feedback on simple issues.
- **Use `concurrency`** to cancel in-progress runs on the same branch:

```yaml
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

- **Pin action versions** to major versions (`@v5`), not `@latest`.
- **Each release job uploads directly** via `softprops/action-gh-release` — avoids fragile artifact download/merge steps.
