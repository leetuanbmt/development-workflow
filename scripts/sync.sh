#!/bin/bash
# Script to synchronize the AI Agent environment
# Supports Template-based architecture and multi-stack projects

# 1. Determine base paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Starting AI Environment Sync..."
echo "📂 Project Root: $PROJECT_ROOT"

# Helper for symlinking
link_file() {
    src=$1
    dest=$2
    ln -sf "$src" "$dest"
    echo "   🔗 Linked: $dest"
}

# 2. Configure .agent structure
echo "🛠  Configuring .agent structure..."
mkdir -p .agent/memory
mkdir -p .agent/skills
mkdir -p .agent/workflows/core
mkdir -p .agent/workflows/ops
mkdir -p .agent/workflows/tech

# 3. Sync Memory (Rules)
echo "📝 Syncing Memory & Rules..."
if [ -d "$PROJECT_ROOT/core/rules" ]; then
    link_file "$PROJECT_ROOT/core/rules/00-core-behavior.md" ".agent/memory/CONVENTIONS.md"
    link_file "$PROJECT_ROOT/core/rules/03-qa-process.md" ".agent/memory/QA_PROCESS.md"
    link_file "$PROJECT_ROOT/core/rules/04-definition-of-done.md" ".agent/memory/DOD.md"
    link_file "$PROJECT_ROOT/core/rules/07-auditor-mode.md" ".agent/memory/AUDITOR_MODE.md"
fi

# 4. Sync Skills
echo "🧠 Syncing Generic Skills..."
if [ -d "$PROJECT_ROOT/skills" ]; then
    # Sync all generic skills from root skills folder
    rsync -a --exclude='_*' "$PROJECT_ROOT/skills/" .agent/skills/
fi

# 5. Sync Workflows
echo "⚙️  Syncing Workflows..."
# Note: We sync the root workflows folder. 
# Specialized workflows (hydrated by /setup) will reside here or in .agent/workflows.
if [ -d "$PROJECT_ROOT/workflows" ]; then
    rsync -a --exclude='_*' "$PROJECT_ROOT/workflows/" .agent/workflows/
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

# 7. Finalize
echo "✅ Sync Complete!"
echo "💡 Next: Run '/setup' to specialize workflows for your tech stack."