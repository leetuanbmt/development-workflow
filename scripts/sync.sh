#!/bin/bash
# Script to synchronize the AI Agent environment
# Version: 5.3.0 - Enhanced with Smart Sync and Safety Features
# Usage: ./sync.sh [OPTIONS]

# 1. Determine base paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MODE="source"  # Default: Reset .agent from Source Code
BACKUP_ONLY=false
FORCE_RESET=false

# Show help
show_help() {
    cat << EOF
🔧 Sync Script v5.3.0 - AI Agent Environment Synchronization

USAGE:
    ./sync.sh [OPTIONS]

OPTIONS:
    (no options)       Smart sync (auto-detects initialization state)
    --runtime          Preserve hydrated workflows (for initialized projects)
    --force-reset      FULL RESET (deletes all custom data - requires confirmation)
    --backup-only      Create backup without syncing
    --help, -h         Show this help message

MODES:
    SOURCE MODE (default):
        - Resets .agent/ from core/ templates
        - Smart detection: preserves initialized PROJECT.md and custom skills
        
    RUNTIME MODE (--runtime):
        - Preserves hydrated workflows
        - Updates core files only
        
    FORCE RESET (--force-reset):
        - Complete reset to factory defaults
        - Deletes ALL custom configurations
        - Requires user confirmation

EXAMPLES:
    # First-time setup
    ./sync.sh
    
    # After /setup has been run
    ./sync.sh --runtime
    
    # Backup before major changes
    ./sync.sh --backup-only
    
    # Complete reset (dangerous!)
    ./sync.sh --force-reset

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --runtime)
            MODE="runtime"
            shift
            ;;
        --force-reset)
            FORCE_RESET=true
            MODE="force"
            shift
            ;;
        --backup-only)
            BACKUP_ONLY=true
            shift
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "❌ Unknown option: $1"
            echo "💡 Use --help to see available options"
            exit 1
            ;;
    esac
done

# Handle force reset confirmation
if [[ "$FORCE_RESET" == true ]]; then
    echo "⚠️  FORCE RESET MODE - This will DELETE all custom configurations!"
    echo "   - Custom skills will be lost"
    echo "   - Initialized PROJECT.md will be reset"
    echo "   - Hydrated workflows will be reset"
    echo ""
    read -p "Are you sure? Type 'YES' to confirm: " confirmation
    if [[ "$confirmation" != "YES" ]]; then
        echo "❌ Reset cancelled."
        exit 0
    fi
    echo "📦 Creating backup before reset..."
    # Continue with forced mode
fi

# Handle backup-only mode
if [[ "$BACKUP_ONLY" == true ]]; then
    echo "📦 BACKUP-ONLY MODE"
    # Will create backup and exit (logic below)
fi

# Display mode
if [[ "$BACKUP_ONLY" != true ]]; then
    case $MODE in
        runtime)
            echo "🔥 Running in RUNTIME MODE (Preserving hydrated workflows)"
            ;;
        force)
            echo "� Running in FORCE RESET MODE (Full reset to defaults)"
            ;;
        *)
            echo "📦 Running in SMART SYNC MODE (Auto-detection enabled)"
            ;;
    esac
fi

echo "📂 Project Root: $PROJECT_ROOT"


# Helper for symlinking
link_file() {
    src=$1
    dest=$2
    rm -rf "$dest"
    ln -sf "$src" "$dest"
    echo "   🔗 Linked: $dest"
}

# ==============================================================================
# DETECTION FUNCTIONS (v5.3.0)
# ==============================================================================

# Check if PROJECT.md has been filled (not a template anymore)
is_project_initialized() {
    if [ -f ".agent/memory/PROJECT.md" ]; then
        # If file contains placeholder patterns, it's still a template
        if grep -q "\[PROJECT_NAME\]" ".agent/memory/PROJECT.md" 2>/dev/null; then
            return 1  # Still template = NOT initialized
        else
            return 0  # Filled = initialized
        fi
    fi
    return 1  # File doesn't exist = NOT initialized
}

# Check if setup workflow has been completed
is_setup_completed() {
    [ -f ".agent/.setup-completed" ]
    return $?
}

# Check if there are custom skills (non-core skills)
has_custom_skills() {
    # Count non-symlink, non-hidden directories in .agent/skills/
    if [ -d ".agent/skills" ]; then
        local custom_count=$(find .agent/skills -maxdepth 1 -type d ! -name ".*" ! -name "skills" | wc -l | xargs)
        [ "$custom_count" -gt 10 ]  # More than 10 core skills = has custom
        return $?
    fi
    return 1  # No skills dir = no custom skills
}

# Create timestamped backup of runtime state
backup_runtime() {
    local BACKUP_DIR=".agent/.backup-$(date +%Y%m%d-%H%M%S)"
    
    echo "📦 Creating backup..."
    mkdir -p "$BACKUP_DIR"
    
    # Backup critical directories
    if [ -d ".agent/memory" ]; then
        cp -r .agent/memory "$BACKUP_DIR/" 2>/dev/null || true
    fi
    if [ -d ".agent/skills" ]; then
        cp -r .agent/skills "$BACKUP_DIR/" 2>/dev/null || true
    fi
    if [ -d ".agent/workflows" ]; then
        cp -r .agent/workflows "$BACKUP_DIR/" 2>/dev/null || true
    fi
    
    # Create restore instructions
    cat > "$BACKUP_DIR/RESTORE.md" << EOF
# Backup Restore Instructions

**Backup Created:** $(date)
**To Restore:**

\`\`\`bash
# Restore memory
cp -r $BACKUP_DIR/memory .agent/

# Restore skills
cp -r $BACKUP_DIR/skills .agent/

# Restore workflows
cp -r $BACKUP_DIR/workflows .agent/

# Then re-run sync
./scripts/sync.sh --runtime
\`\`\`
EOF
    
    echo "   ✅ Backup created: $BACKUP_DIR"
    return 0
}

# ==============================================================================
# SPECIAL MODES HANDLING
# ==============================================================================

# Backup-only mode: Create backup and exit
if [[ "$BACKUP_ONLY" == true ]]; then
    backup_runtime
    echo "✅ Backup completed. No sync performed."
    exit 0
fi

# Force reset mode: Override detection functions
if [[ "$MODE" == "force" ]]; then
    # Create comprehensive backup first
    backup_runtime
    
    # Override functions to allow full reset
    is_project_initialized() { return 1; }
    is_setup_completed() { return 1; }
    has_custom_skills() { return 1; }
    
    echo "💥 Force reset enabled - All protections disabled"
fi

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
    link_file "$PROJECT_ROOT/core/rules" ".agent/rules"
    link_file "$PROJECT_ROOT/core/rules/00-core-behavior.md" ".agent/memory/CONVENTIONS.md"
    link_file "$PROJECT_ROOT/core/rules/03-qa-process.md" ".agent/memory/QA_PROCESS.md"
    link_file "$PROJECT_ROOT/core/rules/04-definition-of-done.md" ".agent/memory/DOD.md"
    link_file "$PROJECT_ROOT/core/rules/07-auditor-mode.md" ".agent/memory/AUDITOR_MODE.md"
fi

# 1.2 Sync Skills - Smart Sync (v5.3.0)
echo "🧠 Syncing Skills..."
if [ -d "$PROJECT_ROOT/core/skills" ]; then
    # Detect if project has custom skills or is initialized
    if is_setup_completed || has_custom_skills; then
        echo "   🔒 Project initialized - Using SAFE sync mode"
        echo "   📌 Preserving custom skills, updating core skills only..."
        
        # Create backup before any changes
        backup_runtime
        
        # Sync core skills but DON'T delete existing ones
        rsync -a --ignore-existing --exclude='_*' "$PROJECT_ROOT/core/skills/" .agent/skills/
        
        # Update existing core skills (files that already exist)
        for skill_dir in "$PROJECT_ROOT/core/skills"/*; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                if [ -d ".agent/skills/$skill_name" ]; then
                    # Update only if it's a core skill (exists in source)
                    rsync -a --exclude='_*' "$skill_dir/" ".agent/skills/$skill_name/"
                fi
            fi
        done
    else
        echo "   📦 Fresh project - Using FULL sync mode"
        rsync -a --exclude='_*' "$PROJECT_ROOT/core/skills/" .agent/skills/
    fi
fi

# 1.3 Sync Workflows (THE CRITICAL PART)
if [[ "$MODE" == "source" ]]; then
    echo "⚙️  Syncing Workflows (Resetting .agent/workflows from Source)..."
    # In Source mode, we ensure .agent mirrors the repo exactly (Generic state)
    if [ -d "$PROJECT_ROOT/core/workflows" ]; then
        rsync -a --exclude='_*' "$PROJECT_ROOT/core/workflows/" .agent/workflows/
    fi
else
    echo "🔒 Preserving Hydrated Workflows in .agent/workflows..."
    # In Runtime mode, we DO NOT touch .agent/workflows because /setup has modified them.
fi

# 1.4 Ensure project context exists (Smart Detection - v5.3.0)
if is_project_initialized; then
    echo "   🔒 PROJECT.md already initialized - PRESERVING"
else
    if [ ! -f ".agent/memory/PROJECT.md" ]; then
        if [ -f "$PROJECT_ROOT/templates/01-project-context.template.md" ]; then
            cp "$PROJECT_ROOT/templates/01-project-context.template.md" .agent/memory/PROJECT.md
            echo "   📄 Initialized PROJECT.md from template."
        else
            touch .agent/memory/PROJECT.md
        fi
    else
        echo "   ⚠️  PROJECT.md exists but not initialized (still template)"
        echo "   💡 Run '/setup' to fill project context"
    fi
fi


# ==============================================================================
# PHASE 2: CONFIGURE GEMINI CLI (.gemini)
# This is where the CLI looks for commands (.toml).
# IT MUST ALWAYS REFLECT THE CURRENT STATE OF .agent
# ==============================================================================
echo "💎 Configuring .gemini (CLI Config)..."
mkdir -p .gemini/commands

# 2.0 Sync Memory (Link .gemini/memory -> .agent/memory)
# We want the CLI to see exactly the same context/memory as the Agent runtime.
if [ -d ".agent/memory" ]; then
    link_file "$PROJECT_ROOT/.agent/memory" ".gemini/memory"
fi

# 2.1 Link Core Configs
if [ -f "$PROJECT_ROOT/GEMINI.md" ]; then
    link_file "$PROJECT_ROOT/GEMINI.md" ".gemini/GEMINI.md"
fi
if [ -f "$PROJECT_ROOT/CHEAT_SHEET.md" ]; then
    link_file "$PROJECT_ROOT/CHEAT_SHEET.md" ".gemini/CHEAT_SHEET.md"
fi
if [ -d "$PROJECT_ROOT/core/rules" ]; then
    link_file "$PROJECT_ROOT/core/rules" ".gemini/rules"
fi

# 2.2 Sync Skills to .gemini
echo "🧠 Syncing Skills to .gemini/skills..."
mkdir -p .gemini/skills
if [ -d "$PROJECT_ROOT/core/skills" ]; then
    rsync -a --exclude='_*' "$PROJECT_ROOT/core/skills/" .gemini/skills/
fi

# 2.3 Generate Commands (.toml) from .agent
# We always generate commands from .agent so the CLI uses exactly what the Agent sees.
if command -v python3 &> /dev/null; then
    echo "🔄 Generating Gemini Commands (.toml) from .agent/workflows..."
    python3 "$PROJECT_ROOT/scripts/generate_commands.py" --source=".agent/workflows"
    
    echo "📊 Generating Skill Metadata..."
    python3 "$PROJECT_ROOT/scripts/generate_metadata.py" ".gemini/skills"
else
    echo "⚠️  Python3 not found. Skipping generation."
fi

# Finalize
echo "✅ Sync Complete!"
if [[ "$MODE" == "source" ]]; then
    echo "💡 System reset to GENERIC mode. Run '/setup' to specialize."
else
    echo "🔥 System running in HYDRATED mode (Stack-Specific)."
fi
