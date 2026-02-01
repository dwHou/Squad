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
CURSOR_DIR="$HOME/.cursor"
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
    "$CLAUDE_DIR/protocols/visualization.md"
    "$CLAUDE_DIR/skills"
    "$CURSOR_DIR/rules/00-squad-core.md"
    "$CURSOR_DIR/agents/researcher.md"
    "$CURSOR_DIR/agents/engineer.md"
    "$CURSOR_DIR/agents/tester.md"
    "$CURSOR_DIR/commands/squad.md"
    "$CURSOR_DIR/protocols/visualization.md"
    "$CURSOR_DIR/skills"
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
        elif [ -d "$file" ]; then
            rm -rf "$file"
            echo -e "  ${GREEN}[removed]${NC} $file (directory)"
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
echo -e "${DIM}Token-efficient multi-agent orchestration for Claude Code & Cursor IDE${NC}"
echo ""

# Handle Clean Mode
if [ "$CLEAN_MODE" = true ]; then
    if [ -f "$CLAUDE_DIR/rules/00-squad-core.md" ] || [ -f "$CURSOR_DIR/rules/00-squad-core.md" ]; then
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

# Claude Code directories
mkdir -p "$CLAUDE_DIR/rules"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/protocols"
mkdir -p "$CLAUDE_DIR/skills"

# Cursor IDE directories
mkdir -p "$CURSOR_DIR/rules"
mkdir -p "$CURSOR_DIR/agents"
mkdir -p "$CURSOR_DIR/commands"
mkdir -p "$CURSOR_DIR/protocols"
mkdir -p "$CURSOR_DIR/skills"

# Shared configuration directory
mkdir -p "$SQUAD_DIR"

echo -e "  ${GREEN}[ok]${NC} ~/.claude/ (Claude Code)"
echo -e "  ${GREEN}[ok]${NC} ~/.cursor/ (Cursor IDE)"
echo -e "  ${GREEN}[ok]${NC} ~/.squad/ (Shared config)"
echo ""

# ============================================================
# 2. Install Core Files
# ============================================================
echo -e "${BLUE}[2/4] Installing core files${NC}"

# Rules - install to both IDEs
cp "$SOURCE_DIR/rules/00-squad-core.md" "$CLAUDE_DIR/rules/"
cp "$SOURCE_DIR/rules/00-squad-core.md" "$CURSOR_DIR/rules/"
echo -e "  ${GREEN}[ok]${NC} Core rules → ~/.claude/rules/ & ~/.cursor/rules/"

# Agents - install to both IDEs
cp "$SOURCE_DIR"/agents/*.md "$CLAUDE_DIR/agents/"
cp "$SOURCE_DIR"/agents/*.md "$CURSOR_DIR/agents/"
AGENT_COUNT=$(find "$SOURCE_DIR/agents" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
echo -e "  ${GREEN}[ok]${NC} Agents ($AGENT_COUNT files) → ~/.claude/agents/ & ~/.cursor/agents/"

# Commands - install to both IDEs
cp "$SOURCE_DIR"/commands/*.md "$CLAUDE_DIR/commands/"
cp "$SOURCE_DIR"/commands/*.md "$CURSOR_DIR/commands/"
echo -e "  ${GREEN}[ok]${NC} Commands → ~/.claude/commands/ & ~/.cursor/commands/"

# Protocols - install to both IDEs (reference documentation, rules already in core file)
if [ -d "$SOURCE_DIR/protocols" ]; then
    mkdir -p "$CLAUDE_DIR/protocols"
    mkdir -p "$CURSOR_DIR/protocols"
    cp "$SOURCE_DIR"/protocols/*.md "$CLAUDE_DIR/protocols/" 2>/dev/null || true
    cp "$SOURCE_DIR"/protocols/*.md "$CURSOR_DIR/protocols/" 2>/dev/null || true
    PROTOCOL_COUNT=$(find "$SOURCE_DIR/protocols" -maxdepth 1 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$PROTOCOL_COUNT" -gt 0 ]; then
        echo -e "  ${GREEN}[ok]${NC} Protocols ($PROTOCOL_COUNT files) → ~/.claude/protocols/ & ~/.cursor/protocols/ (reference)"
    fi
fi

# Router - shared configuration
cp "$SOURCE_DIR/router/router.yaml" "$SQUAD_DIR/"
echo -e "  ${GREEN}[ok]${NC} Router config → ~/.squad/"

# Skills - install to both IDEs
if [ -d "$SOURCE_DIR/skills" ]; then
    cp -r "$SOURCE_DIR/skills"/* "$CLAUDE_DIR/skills/"
    cp -r "$SOURCE_DIR/skills"/* "$CURSOR_DIR/skills/"
    SKILL_COUNT=$(find "$SOURCE_DIR/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
    echo -e "  ${GREEN}[ok]${NC} Skills ($SKILL_COUNT modules) → ~/.claude/skills/ & ~/.cursor/skills/"
fi

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
echo "Add permissions to both Claude Code and Cursor IDE settings?"
echo ""
echo -e "  ${DIM}Claude Code: ~/.claude/settings.json${NC}"
echo -e "  ${DIM}Cursor IDE: ~/.cursor/settings.json${NC}"
echo -e "  ${DIM}Read(path:$CLAUDE_DIR/**)${NC}"
echo -e "  ${DIM}Read(path:$CURSOR_DIR/**)${NC}"
echo -e "  ${DIM}Read(path:$SQUAD_DIR/**)${NC}"
echo ""

if [ "$FORCE_MODE" = true ]; then
    ADD_PERMS="y"
else
    read -p "Add permissions? [Y/n] " -n 1 -r ADD_PERMS
    echo ""
fi

if [[ ! $ADD_PERMS =~ ^[Nn]$ ]]; then
    if command -v python3 &>/dev/null; then
        CLAUDE_DIR_ENV="$CLAUDE_DIR" CURSOR_DIR_ENV="$CURSOR_DIR" SQUAD_DIR_ENV="$SQUAD_DIR" python3 << 'PYTHON_SCRIPT'
import json
import os

claude_dir = os.environ.get("CLAUDE_DIR_ENV", "")
cursor_dir = os.environ.get("CURSOR_DIR_ENV", "")
squad_dir = os.environ.get("SQUAD_DIR_ENV", "")

allow_entries = [
    f"Read(path:{claude_dir}/**)",
    f"Read(path:{cursor_dir}/**)",
    f"Read(path:{squad_dir}/**)",
]

# Update Claude Code settings
claude_settings_path = os.path.expanduser("~/.claude/settings.json")
if os.path.exists(claude_settings_path):
    with open(claude_settings_path, "r", encoding="utf-8") as f:
        claude_settings = json.load(f)
else:
    claude_settings = {}

claude_permissions = claude_settings.setdefault("permissions", {})
claude_allow = claude_permissions.setdefault("allow", [])

for entry in allow_entries:
    if entry and entry not in claude_allow:
        claude_allow.append(entry)

if "defaultMode" not in claude_permissions:
    claude_permissions["defaultMode"] = "default"

os.makedirs(os.path.dirname(claude_settings_path), exist_ok=True)
with open(claude_settings_path, "w", encoding="utf-8") as f:
    json.dump(claude_settings, f, indent=2, ensure_ascii=False)

# Update Cursor IDE settings
cursor_settings_path = os.path.expanduser("~/.cursor/settings.json")
if os.path.exists(cursor_settings_path):
    with open(cursor_settings_path, "r", encoding="utf-8") as f:
        cursor_settings = json.load(f)
else:
    cursor_settings = {}

cursor_permissions = cursor_settings.setdefault("permissions", {})
cursor_allow = cursor_permissions.setdefault("allow", [])

for entry in allow_entries:
    if entry and entry not in cursor_allow:
        cursor_allow.append(entry)

if "defaultMode" not in cursor_permissions:
    cursor_permissions["defaultMode"] = "default"

os.makedirs(os.path.dirname(cursor_settings_path), exist_ok=True)
with open(cursor_settings_path, "w", encoding="utf-8") as f:
    json.dump(cursor_settings, f, indent=2, ensure_ascii=False)

print("ok")
PYTHON_SCRIPT
        echo -e "  ${GREEN}[ok]${NC} Updated ~/.claude/settings.json"
        echo -e "  ${GREEN}[ok]${NC} Updated ~/.cursor/settings.json"
    else
        echo -e "  ${YELLOW}[skip]${NC} Python3 not found, cannot update settings.json"
        echo ""
        echo "Please manually add these permissions:"
        echo -e "  ${DIM}~/.claude/settings.json: Read(path:$CLAUDE_DIR/**), Read(path:$SQUAD_DIR/**)${NC}"
        echo -e "  ${DIM}~/.cursor/settings.json: Read(path:$CURSOR_DIR/**), Read(path:$SQUAD_DIR/**)${NC}"
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
echo -e "  ${DIM}$CLAUDE_DIR/${NC}              Claude Code (rules, agents, commands)"
echo -e "  ${DIM}$CURSOR_DIR/${NC}             Cursor IDE (rules, agents, commands)"
echo -e "  ${DIM}$SQUAD_DIR/${NC}              Shared configuration"
echo ""
echo -e "Squad will automatically detect your IDE environment when you run ${GREEN}/squad${NC}"
echo ""
echo -e "Try it in Claude Code or Cursor IDE: ${GREEN}/squad --help${NC}"
echo ""
echo -e "${DIM}Documentation: README.md${NC}"
echo -e "${DIM}Configuration: ~/.squad/config.yaml${NC}"
echo ""
