#!/bin/bash
# Script to synchronize the AI Agent environment
# Usage: ./sync.sh [--runtime]

# 1. Determine base paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MODE="source" # Default: Reset .agent from Source Code

# Check arguments
if [[ "$1" == "--runtime" ]]; then
    MODE="runtime"
    echo "🔥 Running in RUNTIME MODE (Preserving hydrated workflows in .agent)"
else
    echo "📦 Running in SOURCE MODE (Resetting .agent from repository templates)"
fi

echo "📂 Project Root: $PROJECT_ROOT"

# Helper for symlinking
link_file() {
    src=$1
    dest=$2
    rm -f "$dest"
    ln -sf "$src" "$dest"
    echo "   🔗 Linked: $dest"
}

# ==============================================================================
# PHASE 1: PREPARE ANTIGRAVITY RUNTIME (.agent)
# This is where the Agent looks for Workflows and Skills.
# ==============================================================================
echo "🛠  Configuring .agent (Antigravity Runtime)..."
mkdir -p .agent/memory
mkdir -p .agent/skills
mkdir -p .agent/workflows/core
mkdir -p .agent/workflows/ops
mkdir -p .agent/workflows/tech

# 1.1 Sync Memory (Rules) - Always sync rules from Source (Single Source of Truth)
echo "📝 Syncing Memory & Rules..."
if [ -d "$PROJECT_ROOT/core/rules" ]; then
    link_file "$PROJECT_ROOT/core/rules/00-core-behavior.md" ".agent/memory/CONVENTIONS.md"
    link_file "$PROJECT_ROOT/core/rules/03-qa-process.md" ".agent/memory/QA_PROCESS.md"
    link_file "$PROJECT_ROOT/core/rules/04-definition-of-done.md" ".agent/memory/DOD.md"
    link_file "$PROJECT_ROOT/core/rules/07-auditor-mode.md" ".agent/memory/AUDITOR_MODE.md"
fi

# 1.2 Sync Skills - Always sync Generic Skills from Source
echo "🧠 Syncing Generic Skills..."
if [ -d "$PROJECT_ROOT/skills" ]; then
    rsync -a --exclude='_*' "$PROJECT_ROOT/skills/" .agent/skills/
fi

# 1.3 Sync Workflows (THE CRITICAL PART)
if [[ "$MODE" == "source" ]]; then
    echo "⚙️  Syncing Workflows (Resetting .agent/workflows from Source)..."
    # In Source mode, we ensure .agent mirrors the repo exactly (Generic state)
    if [ -d "$PROJECT_ROOT/workflows" ]; then
        rsync -a --exclude='_*' "$PROJECT_ROOT/workflows/" .agent/workflows/
    fi
else
    echo "🔒 Preserving Hydrated Workflows in .agent/workflows..."
    # In Runtime mode, we DO NOT touch .agent/workflows because /setup has modified them.
fi

# 1.4 Ensure project context exists
if [ ! -f ".agent/memory/PROJECT.md" ]; then
    if [ -f "$PROJECT_ROOT/templates/01-project-context.template.md" ]; then
        cp "$PROJECT_ROOT/templates/01-project-context.template.md" .agent/memory/PROJECT.md
        echo "   📄 Initialized PROJECT.md from template."
    else
        touch .agent/memory/PROJECT.md
    fi
fi

# ==============================================================================
# PHASE 2: CONFIGURE GEMINI CLI (.gemini)
# This is where the CLI looks for commands (.toml).
# IT MUST ALWAYS REFLECT THE CURRENT STATE OF .agent
# ==============================================================================
echo "💎 Configuring .gemini (CLI Config)..."
mkdir -p .gemini/commands
mkdir -p .gemini/memory

# 2.1 Link Core Configs
if [ -f "$PROJECT_ROOT/GEMINI.md" ]; then
    link_file "$PROJECT_ROOT/GEMINI.md" ".gemini/GEMINI.md"
fi
if [ -f "$PROJECT_ROOT/CHEAT_SHEET.md" ]; then
    link_file "$PROJECT_ROOT/CHEAT_SHEET.md" ".gemini/CHEAT_SHEET.md"
fi

# 2.2 Generate Commands (.toml) from .agent
# We always generate commands from .agent so the CLI uses exactly what the Agent sees.
if command -v python3 &> /dev/null; then
    echo "🔄 Generating Gemini Commands (.toml) from .agent/workflows..."
    python3 "$PROJECT_ROOT/scripts/generate_commands.py" --source=".agent/workflows"
else
    echo "⚠️  Python3 not found. Skipping command generation."
fi

# Finalize
echo "✅ Sync Complete!"
if [[ "$MODE" == "source" ]]; then
    echo "💡 System reset to GENERIC mode. Run '/setup' to specialize."
else
    echo "🔥 System running in HYDRATED mode (Stack-Specific)."
fi
