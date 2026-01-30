#!/bin/bash
# Script to synchronize the AI Agent environment
# Usage: ./sync.sh [--runtime]

# 1. Determine base paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MODE="source" # Default: sync from source code

# Check arguments
if [[ "$1" == "--runtime" ]]; then
    MODE="runtime"
    echo "🔥 Running in RUNTIME MODE (Preserving .agent/workflows)"
else
    echo "📦 Running in SOURCE MODE (Resetting .agent from repository)"
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

# 2. Configure .agent structure
mkdir -p .agent/memory
mkdir -p .agent/skills
mkdir -p .agent/workflows/core
mkdir -p .agent/workflows/ops
mkdir -p .agent/workflows/tech

# 3. Sync Memory (Rules) - Always sync rules from Source
echo "📝 Syncing Memory & Rules..."
if [ -d "$PROJECT_ROOT/core/rules" ]; then
    link_file "$PROJECT_ROOT/core/rules/00-core-behavior.md" ".agent/memory/CONVENTIONS.md"
    link_file "$PROJECT_ROOT/core/rules/03-qa-process.md" ".agent/memory/QA_PROCESS.md"
    link_file "$PROJECT_ROOT/core/rules/04-definition-of-done.md" ".agent/memory/DOD.md"
    link_file "$PROJECT_ROOT/core/rules/07-auditor-mode.md" ".agent/memory/AUDITOR_MODE.md"
fi

# 4. Sync Skills - Always sync Generic Skills from Source
echo "🧠 Syncing Generic Skills..."
if [ -d "$PROJECT_ROOT/skills" ]; then
    rsync -a --exclude='_*' "$PROJECT_ROOT/skills/" .agent/skills/
fi

# 5. Sync Workflows (CONDITIONAL)
if [[ "$MODE" == "source" ]]; then
    echo "⚙️  Syncing Workflows (Reset from Source)..."
    if [ -d "$PROJECT_ROOT/workflows" ]; then
        rsync -a --exclude='_*' "$PROJECT_ROOT/workflows/" .agent/workflows/
    fi
else
    echo "🔒 Skipping Workflow Reset (Using Hydrated Workflows in .agent/)..."
fi

# 6. Ensure project context exists
if [ ! -f ".agent/memory/PROJECT.md" ]; then
    if [ -f "$PROJECT_ROOT/templates/01-project-context.template.md" ]; then
        cp "$PROJECT_ROOT/templates/01-project-context.template.md" .agent/memory/PROJECT.md
        echo "   📄 Initialized PROJECT.md from template."
    else
        touch .agent/memory/PROJECT.md
    fi
fi

# ------------------------------------------------------------------
# [NEW] GEMINI CLI SYNC
# ------------------------------------------------------------------
echo "💎 Configuring .gemini structure (CLI Config)..."
mkdir -p .gemini/commands
mkdir -p .gemini/memory

# Link Core Configs
if [ -f "$PROJECT_ROOT/GEMINI.md" ]; then
    link_file "$PROJECT_ROOT/GEMINI.md" ".gemini/GEMINI.md"
fi
if [ -f "$PROJECT_ROOT/CHEAT_SHEET.md" ]; then
    link_file "$PROJECT_ROOT/CHEAT_SHEET.md" ".gemini/CHEAT_SHEET.md"
fi

# Generate Commands (.toml)
if command -v python3 &> /dev/null; then
    echo "🔄 Generating Gemini Commands (.toml)..."
    
    if [[ "$MODE" == "runtime" ]]; then
        # In Runtime mode, generate commands from the HYDRATED workflows in .agent
        python3 "$PROJECT_ROOT/scripts/generate_commands.py" --source=".agent/workflows"
    else
        # In Source mode, generate commands from the GENERIC workflows in root
        python3 "$PROJECT_ROOT/scripts/generate_commands.py" --source="workflows"
    fi
else
    echo "⚠️  Python3 not found. Skipping command generation."
fi

# 7. Finalize
echo "✅ Sync Complete!"
if [[ "$MODE" == "source" ]]; then
    echo "💡 Next: Run '/setup' to specialize workflows."
else
    echo "🔥 Agent is active with Hydrated Workflows."
fi