#!/usr/bin/env bash
set -euo pipefail

# install.sh — Symlink claude-setup skills, agents, and commands into ~/.claude/
#
# Usage:
#   ./install.sh              Install (create symlinks)
#   ./install.sh --check      Report what's out of sync without changing anything
#   ./install.sh --uninstall  Remove symlinks created by this script

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

SKILLS_SRC="$REPO_DIR/skills"
AGENTS_SRC="$REPO_DIR/agents"
COMMANDS_SRC="$REPO_DIR/commands"

SKILLS_DST="$CLAUDE_DIR/skills"
AGENTS_DST="$CLAUDE_DIR/agents"
COMMANDS_DST="$CLAUDE_DIR/commands"

MODE="install"
if [[ "${1:-}" == "--check" ]]; then
    MODE="check"
elif [[ "${1:-}" == "--uninstall" ]]; then
    MODE="uninstall"
elif [[ -n "${1:-}" ]]; then
    echo "Unknown flag: $1"
    echo "Usage: $0 [--check | --uninstall]"
    exit 1
fi

changes=0

link_item() {
    local src="$1"
    local dst="$2"
    local label="$3"

    if [[ "$MODE" == "check" ]]; then
        if [[ -L "$dst" ]]; then
            local current
            current="$(readlink "$dst")"
            if [[ "$current" == "$src" ]]; then
                echo "  ok  $label"
            else
                echo "  !!  $label -> $current (expected $src)"
                changes=$((changes + 1))
            fi
        elif [[ -e "$dst" ]]; then
            echo "  !!  $label exists but is not a symlink"
            changes=$((changes + 1))
        else
            echo "  --  $label (missing)"
            changes=$((changes + 1))
        fi
        return
    fi

    if [[ "$MODE" == "uninstall" ]]; then
        if [[ -L "$dst" ]]; then
            local current
            current="$(readlink "$dst")"
            if [[ "$current" == "$src" ]]; then
                rm "$dst"
                echo "  removed  $label"
                changes=$((changes + 1))
            else
                echo "  skipped  $label (points to $current, not ours)"
            fi
        else
            echo "  skipped  $label (not a symlink)"
        fi
        return
    fi

    # install mode
    if [[ -L "$dst" ]]; then
        local current
        current="$(readlink "$dst")"
        if [[ "$current" == "$src" ]]; then
            echo "  exists  $label"
            return
        fi
        rm "$dst"
        echo "  updated $label"
    elif [[ -e "$dst" ]]; then
        echo "  SKIP    $label (exists and is not a symlink — remove manually)"
        return
    else
        echo "  linked  $label"
    fi
    ln -s "$src" "$dst"
    changes=$((changes + 1))
}

# --- Skills (directories, skip SKILLS-INDEX.md) ---
echo "Skills:"
if [[ "$MODE" == "install" ]]; then
    mkdir -p "$SKILLS_DST"
fi
for item in "$SKILLS_SRC"/*/; do
    name="$(basename "$item")"
    link_item "$SKILLS_SRC/$name" "$SKILLS_DST/$name" "$name"
done

# --- Agents (.md files) ---
echo ""
echo "Agents:"
if [[ "$MODE" == "install" ]]; then
    mkdir -p "$AGENTS_DST"
fi
for item in "$AGENTS_SRC"/*.md; do
    name="$(basename "$item")"
    link_item "$AGENTS_SRC/$name" "$AGENTS_DST/$name" "$name"
done

# --- Commands (.md files) ---
echo ""
echo "Commands:"
if [[ "$MODE" == "install" ]]; then
    mkdir -p "$COMMANDS_DST"
fi
for item in "$COMMANDS_SRC"/*.md; do
    name="$(basename "$item")"
    link_item "$COMMANDS_SRC/$name" "$COMMANDS_DST/$name" "$name"
done

# --- Summary ---
echo ""
case "$MODE" in
    check)
        if [[ $changes -eq 0 ]]; then
            echo "Everything is in sync."
        else
            echo "$changes item(s) out of sync. Run $0 to fix."
        fi
        ;;
    install)
        if [[ $changes -eq 0 ]]; then
            echo "Nothing to do — already installed."
        else
            echo "Done. $changes item(s) linked."
        fi
        ;;
    uninstall)
        if [[ $changes -eq 0 ]]; then
            echo "Nothing to remove."
        else
            echo "Done. $changes item(s) removed."
        fi
        ;;
esac
