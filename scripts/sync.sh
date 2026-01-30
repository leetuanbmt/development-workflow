#!/bin/bash
# Script đồng bộ hóa môi trường AI Agent
# Tự động nhận diện đường dẫn (Submodule-ready) + Stack-aware

# 1. Xác định các đường dẫn gốc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_ROOT="$(dirname "$SCRIPT_DIR")"

# 2. Parse arguments
STACK="auto"
WATCH_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --stack)
            STACK="$2"
            shift 2
            ;;
        --watch)
            WATCH_MODE=true
            shift
            ;;
        gemini|antigravity)
            MODE="$1"
            shift
            ;;
        *)
            shift
            ;;
    esac
done

echo "🚀 Starting AI Environment Sync..."
echo "📂 Workflow Root: $WORKFLOW_ROOT"
echo "🏠 Target Root: $(pwd)"
echo "📦 Stack: $STACK"

# Sử dụng đường dẫn tuyệt đối cho nguồn để đảm bảo symlink hoạt động đúng từ bất kỳ đâu
SRC_PREFIX="$WORKFLOW_ROOT"

# 3. Auto-detect stack nếu cần
detect_stack() {
    if [ "$STACK" = "auto" ]; then
        if [ -f "pubspec.yaml" ]; then
            STACK="flutter"
            echo "🔍 Detected: Flutter project"
        elif [ -f "package.json" ]; then
            STACK="nodejs"
            echo "🔍 Detected: Node.js project"
        elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
            STACK="python"
            echo "🔍 Detected: Python project"
        else
            STACK="generic"
            echo "🔍 Detected: Generic project (no stack-specific features)"
        fi
    fi
}

# Hàm helper tạo symlink an toàn
link_folder() {
    src=$1
    dest=$2
    rm -rf "$dest" # Xóa cũ (nếu là folder hoặc link)
    
    # Sử dụng ln -s với đường dẫn tuyệt đối
    ln -s "$src" "$dest"
    echo "   🔗 Linked: $dest -> $src"
}

sync_gemini() {
    echo "🛠  Configuring .gemini structure..."
    mkdir -p .gemini

    # Tạo các Symlink logic (Trỏ về core)
    link_folder "$SRC_PREFIX/core/rules" ".gemini/rules"
    link_folder "$SRC_PREFIX/core/skills" ".gemini/skills"
    
    # Link stack-specific nếu có
    if [ "$STACK" != "generic" ] && [ -d "$SRC_PREFIX/stacks/$STACK" ]; then
        echo "   📦 Merging stack: $STACK"
        # Merge rules
        if [ -d "$SRC_PREFIX/stacks/$STACK/rules" ]; then
            for rule in "$SRC_PREFIX/stacks/$STACK/rules"/*; do
                if [ -f "$rule" ]; then
                    ln -sf "$rule" ".gemini/rules/$(basename "$rule")"
                fi
            done
        fi
        # Merge skills
        if [ -d "$SRC_PREFIX/stacks/$STACK/skills" ]; then
            for skill in "$SRC_PREFIX/stacks/$STACK/skills"/*; do
                if [ -d "$skill" ]; then
                    ln -sf "$skill" ".gemini/skills/$(basename "$skill")"
                fi
            done
        fi
    fi
    
    if [ -d "$SRC_PREFIX/memory" ]; then
        link_folder "$SRC_PREFIX/memory" ".gemini/memory"
    else
        # Nếu không có memory chung, tạo folder local
        rm -rf ".gemini/memory"
        mkdir -p ".gemini/memory"
    fi

    link_folder "$SRC_PREFIX/CHEAT_SHEET.md" ".gemini/CHEAT_SHEET.md"
    link_folder "$SRC_PREFIX/GEMINI.md" ".gemini/GEMINI.md"

    # 2. Generate Commands (MD -> TOML)
    rm -rf .gemini/commands
    mkdir -p .gemini/commands

    echo "🔄 Generating Gemini Commands (.toml)..."
    if command -v python3 &> /dev/null; then
        python3 "$SRC_PREFIX/scripts/generate_commands.py" --stack="$STACK"
    else
        python "$SRC_PREFIX/scripts/generate_commands.py" --stack="$STACK"
    fi
}

sync_antigravity() {
    echo "🛠  Configuring .agent structure..."
    
    # Backup Custom Architecture Rules if they exist and are significant (>1000 bytes)
    CUSTOM_ARCH=""
    if [ -f ".agent/memory/ARCHITECTURE.md" ]; then
         SIZE=$(python3 -c "import os; print(os.path.getsize('.agent/memory/ARCHITECTURE.md'))" 2>/dev/null || echo 0)
         if [ "$SIZE" -gt 1000 ]; then
             CUSTOM_ARCH=$(cat ".agent/memory/ARCHITECTURE.md")
             echo "   💾 Backing up custom Architecture Rules ($SIZE bytes)..."
         fi
    fi

    rm -rf .agent
    mkdir -p .agent/memory
    mkdir -p .agent/skills
    mkdir -p .agent/workflows

    # 1. README
    cp "$SRC_PREFIX/README.md" .agent/README.md 2>/dev/null || true

    # 2. Memory (Mapped from Core Rules + Stack Rules)
    # Use Symlinks (ln -sf) instead of Copy (cp) to keep memory "live"
    if [ -d "$SRC_PREFIX/core/rules" ]; then
        ln -sf "$SRC_PREFIX/core/rules/00-core-behavior.md" .agent/memory/CONVENTIONS.md
        ln -sf "$SRC_PREFIX/core/rules/03-qa-process.md" .agent/memory/QA_PROCESS.md
        ln -sf "$SRC_PREFIX/core/rules/04-definition-of-done.md" .agent/memory/DOD.md
        ln -sf "$SRC_PREFIX/core/rules/07-auditor-mode.md" .agent/memory/AUDITOR_MODE.md
    fi
    
    # Copy stack-specific architecture rules
    if [ "$STACK" != "generic" ] && [ -f "$SRC_PREFIX/stacks/$STACK/rules/02-architecture-rules.md" ]; then
        # For known stacks, link directly to source
        ln -sf "$SRC_PREFIX/stacks/$STACK/rules/02-architecture-rules.md" .agent/memory/ARCHITECTURE.md
    else
        # Fallback to minimal rules for Generic/Uninitialized
        # RESTORE backup if available, otherwise use minimal template
        if [ -n "$CUSTOM_ARCH" ]; then
             echo "$CUSTOM_ARCH" > .agent/memory/ARCHITECTURE.md
             echo "   ↩️  Restored custom Architecture Rules."
        else
             cp "$SRC_PREFIX/templates/02-architecture-minimal.template.md" .agent/memory/ARCHITECTURE.md 2>/dev/null || true
        fi
    fi
    
    # Project context template (will be filled by /setup)
    if [ ! -f ".agent/memory/PROJECT.md" ]; then
        cp "$SRC_PREFIX/templates/01-project-context.template.md" .agent/memory/PROJECT.md 2>/dev/null || true
    fi
    
    touch .agent/memory/GLOSSARY.md
    
    # Copy user memory (Knowledge Base, Preferences, History)
    if [ -d "$SRC_PREFIX/memory" ]; then
        cp -R "$SRC_PREFIX/memory/"* .agent/memory/ 2>/dev/null || true
    fi

    # 3. Skills & Workflows (Core + Stack, Exclude archived/deprecated folders)
    if [ -d "$SRC_PREFIX/core/skills" ]; then
        rsync -a --exclude='_*' "$SRC_PREFIX/core/skills/" .agent/skills/
    fi
    
    # Merge stack skills
    if [ "$STACK" != "generic" ] && [ -d "$SRC_PREFIX/stacks/$STACK/skills" ]; then
        rsync -a --exclude='_*' "$SRC_PREFIX/stacks/$STACK/skills/" .agent/skills/
    fi
    
    if [ -d "$SRC_PREFIX/core/workflows" ]; then
        rsync -a --exclude='_*' "$SRC_PREFIX/core/workflows/" .agent/workflows/
    fi
}

sync_all() {
    detect_stack
    sync_gemini
    sync_antigravity
    echo "✅ Sync Complete! Your AI is ready."
    echo "📦 Stack: $STACK"
    echo "💡 Next: Run '/setup' to initialize project context"
}

watch_loop() {
    echo "👀 Watching for changes in $SRC_PREFIX..."
    echo "   (Press Ctrl+C to stop)"
    
    # Primitive watch implementation using sleep & timestamp comparison
    
    # We will compute a simple hash of the directory state
    get_state() {
        find "$SRC_PREFIX/core" "$SRC_PREFIX/stacks" -type f -name "*.md" -o -name "*.py" -o -name "*.sh" 2>/dev/null | xargs -I {} ls -lT {} 2>/dev/null | cksum
    }

    LAST_STATE=$(get_state)

    while true; do
        sleep 2
        CURRENT_STATE=$(get_state)
        
        if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
            echo "🔄 Change detected! Syncing..."
            sync_all
            LAST_STATE=$CURRENT_STATE
            echo "👀 Waiting for next change..."
        fi
    done
}

# Main execution
if [ "$WATCH_MODE" = true ]; then
    sync_all
    watch_loop
elif [ -n "$MODE" ]; then
    detect_stack
    case "$MODE" in
        gemini) sync_gemini ;;
        antigravity) sync_antigravity ;;
    esac
else
    sync_all
fi
