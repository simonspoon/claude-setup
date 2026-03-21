# Tauri v2 + SolidJS Desktop Apps
Last updated: 2026-03-20
Last researched: 2026-03-20
Sources: crates.io, npm, tauri.app docs, GitHub releases

## Summary

Tauri v2 is a lightweight desktop app framework (Rust backend + web frontend). SolidJS is a first-class official template. The combination gives a fast, small binary with reactive UI.

## Current Versions

| Component | Version | Notes |
|-----------|---------|-------|
| tauri (core) | 2.10.3 | |
| tauri-cli | 2.10.0 | |
| create-tauri-app | 4.7.0 | |
| solid-js | 1.9.11 | Do NOT use 2.0-beta (released Mar 3, 2026) |

## Scaffold Command

```bash
pnpm create tauri-app my-app --template solid-ts
```

## Key Architecture Points

- **Frontend↔Backend IPC**: Use Tauri's native `invoke` — it's JSON-RPC-like, no extra deps needed
- **External process↔Tauri**: Embed an axum WebSocket server in the Tauri backend for external clients (e.g., CLI tools)
- **WebSocket server**: `axum 0.8` with `axum::extract::ws` — wraps tungstenite with stable API
- **WebSocket client**: `tokio-tungstenite 0.28.0` — pin to 0.28, 0.29 just shipped (Mar 17, 2026)
- **JSON-RPC**: `jsonrpsee 0.26` if you need full spec compliance; pin minor version (breaks on minor bumps). For simple cases, roll lightweight JSON-RPC over raw WS.

## Prerequisites (macOS)

- Xcode Command Line Tools
- Rust via rustup
- Node.js LTS
- pnpm

## Cargo Workspace with Tauri

Tauri's scaffold creates `src-tauri/` inside the frontend project. To use a Cargo workspace with shared crates:

1. Scaffold normally, then wrap in workspace
2. Root `Cargo.toml` declares workspace members including `app/src-tauri`
3. Shared crates (core, protocol) go in `crates/`
4. Both CLI and Tauri backend depend on shared crates via path deps

## Event System (Rust → Frontend)

- Import `tauri::Emitter` to use `emit()` on `AppHandle`
- `app.handle().clone()` gives an owned `AppHandle` that is `Clone + Send + Sync`
- `handle.emit("event-name", payload)?` — payload must be `Serialize + Clone`
- Frontend listens via `listen<T>("event-name", callback)` from `@tauri-apps/api/event`
- Frontend responds via `invoke()` (not `emit()`) — invoke gives typed return values
- Always call the `UnlistenFn` returned by `listen()` in `onCleanup()`

## Spawning Async Tasks (axum server, background work)

- **Prefer `tauri::async_runtime::spawn`** over `std::thread::spawn` + separate runtime
- Avoids "no reactor running" panics from mismatched tokio contexts
- Clone `AppHandle` in `setup()`, move into the spawned task
- For request/response patterns across tasks: use `tokio::sync::oneshot` channels stored in shared state

## DOM Capture (Screenshots)

- `html-to-image` 1.11.13 (npm) — `toPng(element, { pixelRatio })` returns base64 data URL
- WKWebView (macOS) may silently drop CSS background-images in SVG foreignObject
- Base64 PNG via IPC: strip `data:image/png;base64,` prefix, send via `invoke()`
- For large payloads (2-4MB), JSON serialization works but benchmark if latency matters

## Related Topics

- [Rust CLI Patterns](../architecture/rust-cli-patterns.md)
