#!/bin/bash
# Quick Sync Script - Only sync workflows and skills (no backup, validation)
# Version: 1.0.0
# Usage: ./sync_quick.sh [--workflows-only | --skills-only]

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

SYNC_WORKFLOWS=true
SYNC_SKILLS=true
SYNC_TOML=true

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --workflows-only)
            SYNC_SKILLS=false
            SYNC_TOML=true  # Still need TOML for workflows
            shift
            ;;
        --skills-only)
            SYNC_WORKFLOWS=false
            SYNC_TOML=false
            shift
            ;;
        --help|-h)
            cat <<EOF
⚡ Quick Sync - Fast workflow/skill synchronization

USAGE:
    ./sync_quick.sh [OPTIONS]

OPTIONS:
    (no options)         Sync both workflows and skills
    --workflows-only     Sync workflows only
    --skills-only        Sync skills only
    --help, -h           Show this help

WHAT IT DOES:
    ✅ Copies core/workflows → .agent/workflows
    ✅ Copies core/skills → .agent/skills
    ✅ Generates .toml commands for Gemini CLI
    ❌ NO backup creation
    ❌ NO validation checks
    ❌ NO smart detection

USE CASES:
    - During active development
    - Quick iteration on workflows/skills
    - Testing changes immediately

SAFETY:
    This script does NOT create backups.
    Use './sync.sh --runtime' for production sync.
EOF
            exit 0
            ;;
        *)
            echo "❌ Unknown option: $1"
            echo "💡 Use --help to see available options"
            exit 1
            ;;
    esac
done

echo "⚡ Quick Sync Mode (No Backup)"
echo "📂 Project Root: $PROJECT_ROOT"
echo ""

# Ensure directories exist
mkdir -p .agent/workflows/core
mkdir -p .agent/workflows/ops
mkdir -p .agent/workflows/tech
mkdir -p .agent/skills
mkdir -p .gemini/commands
mkdir -p .gemini/skills

# Sync Workflows
if [[ "$SYNC_WORKFLOWS" == true ]]; then
    echo "📋 Syncing Workflows..."
    if [ -d "$PROJECT_ROOT/core/workflows" ]; then
        rsync -a --delete --exclude='_*' --exclude='.DS_Store' \
            "$PROJECT_ROOT/core/workflows/" .agent/workflows/
        echo "   ✅ Workflows synced to .agent/workflows/"
    else
        echo "   ⚠️  Warning: $PROJECT_ROOT/core/workflows not found"
    fi
fi

# Sync Skills
if [[ "$SYNC_SKILLS" == true ]]; then
    echo "🧠 Syncing Skills..."
    if [ -d "$PROJECT_ROOT/core/skills" ]; then
        # Sync to .agent/skills
        rsync -a --delete --exclude='_*' --exclude='.DS_Store' \
            "$PROJECT_ROOT/core/skills/" .agent/skills/
        echo "   ✅ Skills synced to .agent/skills/"
        
        # Sync to .gemini/skills (for CLI)
        rsync -a --delete --exclude='_*' --exclude='.DS_Store' \
            "$PROJECT_ROOT/core/skills/" .gemini/skills/
        echo "   ✅ Skills synced to .gemini/skills/"
    else
        echo "   ⚠️  Warning: $PROJECT_ROOT/core/skills not found"
    fi
fi

# Generate TOML commands if python3 available
if [[ "$SYNC_TOML" == true ]]; then
    if command -v python3 &> /dev/null; then
        echo "🔄 Generating Gemini Commands (.toml)..."
        python3 "$PROJECT_ROOT/scripts/generate_commands.py" --source=".agent/workflows" 2>/dev/null
        
        if [[ "$SYNC_SKILLS" == true ]]; then
            echo "📊 Generating Skill Metadata..."
            python3 "$PROJECT_ROOT/scripts/generate_metadata.py" ".gemini/skills" 2>/dev/null
        fi
        
        echo "   ✅ Commands generated"
    else
        echo "   ⚠️  Python3 not found - Skipping .toml generation"
    fi
fi

echo ""
echo "✅ Quick Sync Complete!"
echo "💡 Changes synced from core/ → .agent/"

if [[ "$SYNC_WORKFLOWS" == true ]]; then
    echo "   📋 Workflows updated"
fi
if [[ "$SYNC_SKILLS" == true ]]; then
    echo "   🧠 Skills updated"
fi
