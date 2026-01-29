#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

PROJECT_ROOT=$(pwd)
SOURCE_DIR="$PROJECT_ROOT/squad-dist"
CLAUDE_DIR="$HOME/.claude"
SQUAD_DIR="$HOME/.squad"

# ============================================================
# Command Line Options
# ============================================================
CLEAN_MODE=false
UNINSTALL_MODE=false
FORCE_MODE=false

show_help() {
    echo -e "${BLUE}Squad Installer${NC}"
    echo ""
    echo "Usage: ./install.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help, -h        Show this help message"
    echo "  --clean, -c       Clean old version before installing"
    echo "  --uninstall, -u   Uninstall Squad (remove installed files)"
    echo "  --force, -f       Skip confirmation prompts"
    echo ""
    echo "Examples:"
    echo "  ./install.sh              Normal install"
    echo "  ./install.sh --clean      Clean old version, then install"
    echo "  ./install.sh --uninstall  Remove Squad installation"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            show_help
            exit 0
            ;;
        --clean|-c)
            CLEAN_MODE=true
            shift
            ;;
        --uninstall|-u)
            UNINSTALL_MODE=true
            shift
            ;;
        --force|-f)
            FORCE_MODE=true
            shift
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
        *)
            echo -e "${RED}Unexpected argument: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# ============================================================
# Clean Functions
# ============================================================

SQUAD_FILES=(
    "$CLAUDE_DIR/rules/00-squad-core.md"
    "$CLAUDE_DIR/agents/researcher.md"
    "$CLAUDE_DIR/agents/engineer.md"
    "$CLAUDE_DIR/agents/tester.md"
    "$CLAUDE_DIR/commands/squad.md"
    "$SQUAD_DIR/router.yaml"
    "$SQUAD_DIR/config.yaml"
)

clean_squad() {
    echo -e "${BLUE}Cleaning Squad installation...${NC}"
    echo ""

    for file in "${SQUAD_FILES[@]}"; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo -e "  ${GREEN}[removed]${NC} $file"
        fi
    done

    echo ""
    echo -e "${GREEN}Squad cleaned.${NC}"
}

do_uninstall() {
    echo -e "${BLUE}Squad Uninstaller${NC}"
    echo ""
    echo "The following files will be removed:"
    echo ""
    for file in "${SQUAD_FILES[@]}"; do
        if [ -f "$file" ]; then
            echo -e "  ${DIM}$file${NC}"
        fi
    done
    echo ""

    if [ "$FORCE_MODE" != true ]; then
        read -p "Continue with uninstall? [y/N] " -r REPLY
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Uninstall cancelled."
            exit 0
        fi
    fi

    clean_squad

    echo ""
    echo -e "${GREEN}Squad has been uninstalled.${NC}"
    exit 0
}

# ============================================================
# Handle Uninstall Mode
# ============================================================
if [ "$UNINSTALL_MODE" = true ]; then
    do_uninstall
fi

# ============================================================
# Main Installation
# ============================================================
echo -e "${BLUE}Squad Installer${NC}"
echo -e "${DIM}Token-efficient multi-agent orchestration for Claude Code${NC}"
echo ""

# Handle Clean Mode
if [ "$CLEAN_MODE" = true ]; then
    if [ -f "$CLAUDE_DIR/rules/00-squad-core.md" ]; then
        clean_squad
        echo ""
    else
        echo -e "${DIM}No existing installation found, skipping clean.${NC}"
        echo ""
    fi
fi

# Check source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}Error: squad-dist/ directory not found${NC}"
    echo "Make sure you're running this script from the Squad repository root."
    exit 1
fi

# ============================================================
# 1. Create Directories
# ============================================================
echo -e "${BLUE}[1/4] Creating directories${NC}"

mkdir -p "$CLAUDE_DIR/rules"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$SQUAD_DIR"

echo -e "  ${GREEN}[ok]${NC} ~/.claude/rules/"
echo -e "  ${GREEN}[ok]${NC} ~/.claude/agents/"
echo -e "  ${GREEN}[ok]${NC} ~/.claude/commands/"
echo -e "  ${GREEN}[ok]${NC} ~/.squad/"
echo ""

# ============================================================
# 2. Install Core Files
# ============================================================
echo -e "${BLUE}[2/4] Installing core files${NC}"

# Rules
cp "$SOURCE_DIR/rules/00-squad-core.md" "$CLAUDE_DIR/rules/"
echo -e "  ${GREEN}[ok]${NC} Core rules → ~/.claude/rules/"

# Agents
cp "$SOURCE_DIR"/agents/*.md "$CLAUDE_DIR/agents/"
AGENT_COUNT=$(find "$SOURCE_DIR/agents" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
echo -e "  ${GREEN}[ok]${NC} Agents ($AGENT_COUNT files) → ~/.claude/agents/"

# Commands
cp "$SOURCE_DIR"/commands/*.md "$CLAUDE_DIR/commands/"
echo -e "  ${GREEN}[ok]${NC} Commands → ~/.claude/commands/"

# Router
cp "$SOURCE_DIR/router/router.yaml" "$SQUAD_DIR/"
echo -e "  ${GREEN}[ok]${NC} Router config → ~/.squad/"

echo ""

# ============================================================
# 3. Create Config File
# ============================================================
echo -e "${BLUE}[3/4] Creating configuration${NC}"

if [ ! -f "$SQUAD_DIR/config.yaml" ]; then
    cat > "$SQUAD_DIR/config.yaml" << 'EOF'
# Squad Configuration
# Version: 0.1.0

# Language preference (en | zh)
language: en

# Verbose mode (show detailed routing)
verbose: false

# Model preferences (optional overrides)
# models:
#   researcher: haiku
#   engineer: sonnet
#   tester: haiku
EOF
    echo -e "  ${GREEN}[ok]${NC} Created ~/.squad/config.yaml"
else
    echo -e "  ${YELLOW}[skip]${NC} config.yaml already exists"
fi

echo ""

# ============================================================
# 4. Configure Permissions (Optional)
# ============================================================
echo -e "${BLUE}[4/4] Permissions${NC}"
echo ""
echo "Squad agents need read access to installed files."
echo "Add these permissions to ~/.claude/settings.json?"
echo ""
echo -e "  ${DIM}Read(path:$CLAUDE_DIR/**)${NC}"
echo -e "  ${DIM}Read(path:$SQUAD_DIR/**)${NC}"
echo ""

if [ "$FORCE_MODE" = true ]; then
    ADD_PERMS="y"
else
    read -p "Add permissions? [Y/n] " -n 1 -r ADD_PERMS
    echo ""
fi

if [[ ! $ADD_PERMS =~ ^[Nn]$ ]]; then
    mkdir -p "$CLAUDE_DIR"

    if command -v python3 &>/dev/null; then
        CLAUDE_DIR_ENV="$CLAUDE_DIR" SQUAD_DIR_ENV="$SQUAD_DIR" python3 << 'PYTHON_SCRIPT'
import json
import os

settings_path = os.path.expanduser("~/.claude/settings.json")
claude_dir = os.environ.get("CLAUDE_DIR_ENV", "")
squad_dir = os.environ.get("SQUAD_DIR_ENV", "")

allow_entries = [
    f"Read(path:{claude_dir}/**)",
    f"Read(path:{squad_dir}/**)",
]

if os.path.exists(settings_path):
    with open(settings_path, "r", encoding="utf-8") as f:
        settings = json.load(f)
else:
    settings = {}

permissions = settings.setdefault("permissions", {})
allow = permissions.setdefault("allow", [])

for entry in allow_entries:
    if entry and entry not in allow:
        allow.append(entry)

if "defaultMode" not in permissions:
    permissions["defaultMode"] = "default"

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)

print("ok")
PYTHON_SCRIPT
        echo -e "  ${GREEN}[ok]${NC} Updated ~/.claude/settings.json"
    else
        echo -e "  ${YELLOW}[skip]${NC} Python3 not found, cannot update settings.json"
        echo ""
        echo "Please manually add these to ~/.claude/settings.json permissions.allow:"
        echo -e "  ${DIM}Read(path:$CLAUDE_DIR/**)${NC}"
        echo -e "  ${DIM}Read(path:$SQUAD_DIR/**)${NC}"
    fi
else
    echo -e "  ${DIM}Skipped permission update${NC}"
fi

# ============================================================
# Done
# ============================================================
echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo "Installed to:"
echo -e "  ${DIM}$CLAUDE_DIR/rules/${NC}       Core rules (auto-loaded)"
echo -e "  ${DIM}$CLAUDE_DIR/agents/${NC}      Agent definitions"
echo -e "  ${DIM}$CLAUDE_DIR/commands/${NC}    Commands"
echo -e "  ${DIM}$SQUAD_DIR/${NC}              Configuration"
echo ""
echo -e "Start Claude Code and try: ${GREEN}/squad --help${NC}"
echo ""
echo -e "${DIM}Documentation: README.md${NC}"
echo -e "${DIM}Configuration: ~/.squad/config.yaml${NC}"
echo ""
