#!/bin/bash
# Script đồng bộ hóa môi trường AI Agent
# Tự động nhận diện đường dẫn (Submodule-ready)

# 1. Xác định các đường dẫn gốc
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_ROOT="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(dirname "$WORKFLOW_ROOT")"
WORKFLOW_DIR_NAME=$(basename "$WORKFLOW_ROOT")

echo "🚀 Starting AI Environment Sync..."
echo "📂 Workflow Root: $WORKFLOW_ROOT"
echo "🏠 Project Root: $PROJECT_ROOT"

# Di chuyển về Project Root để thực hiện symlink chính xác
cd "$PROJECT_ROOT" || exit

# Hàm helper tạo symlink an toàn
link_folder() {
    src=$1
    dest=$2
    rm -rf "$dest" # Xóa cũ (nếu là folder hoặc link)
    ln -s "$src" "$dest"
    echo "   🔗 Linked: $dest -> $src"
}

sync_gemini() {
    echo "🛠  Configuring .gemini structure..."
    mkdir -p .gemini
    mkdir -p .gemini/memory

    # Tạo các Symlink logic (Trỏ về thư mục workflow)
    link_folder "$WORKFLOW_DIR_NAME/rules" ".gemini/rules"
    link_folder "$WORKFLOW_DIR_NAME/skills" ".gemini/skills"
    link_folder "$WORKFLOW_DIR_NAME/CHEAT_SHEET.md" ".gemini/CHEAT_SHEET.md"
    link_folder "$WORKFLOW_DIR_NAME/GEMINI.md" ".gemini/GEMINI.md"

    # 2. Generate Commands (MD -> TOML)
    rm -rf .gemini/commands
    mkdir -p .gemini/commands

    echo "🔄 Generating Gemini Commands (.toml)..."
    if command -v python3 &> /dev/null; then
        python3 "$WORKFLOW_DIR_NAME/scripts/generate_commands.py"
    else
        python "$WORKFLOW_DIR_NAME/scripts/generate_commands.py"
    fi
}

sync_antigravity() {
    echo "🛠  Configuring .agent structure..."
    rm -rf .agent
    mkdir -p .agent/memory
    mkdir -p .agent/skills
    mkdir -p .agent/workflows

    # 1. README
    cp "$WORKFLOW_DIR_NAME/README.md" .agent/README.md 2>/dev/null || true

    # 2. Memory (Mapped from Rules)
    if [ -d "$WORKFLOW_DIR_NAME/rules" ]; then
        cp "$WORKFLOW_DIR_NAME/rules/01-project-context.md" .agent/memory/PROJECT.md 2>/dev/null || true
        cp "$WORKFLOW_DIR_NAME/rules/02-architecture-rules.md" .agent/memory/ARCHITECTURE.md 2>/dev/null || true
        cp "$WORKFLOW_DIR_NAME/rules/00-core-behavior.md" .agent/memory/CONVENTIONS.md 2>/dev/null || true
        touch .agent/memory/GLOSSARY.md
    fi

    # 3. Skills & Workflows (Recursive Copy)
    if [ -d "$WORKFLOW_DIR_NAME/skills" ]; then
        cp -R "$WORKFLOW_DIR_NAME/skills/"* .agent/skills/
    fi
    if [ -d "$WORKFLOW_DIR_NAME/workflows" ]; then
        for wf_path in "$WORKFLOW_DIR_NAME/workflows"/*.md; do
            wf_file=$(basename "$wf_path")
            wf_name=$(echo "${wf_file%.md}" | tr '_' '-')
            cp "$wf_path" ".agent/workflows/$wf_name.md"
        done
    fi
}

sync_all() {
    sync_gemini
    sync_antigravity
    echo "✅ Sync Complete! Your AI is ready."
}

watch_loop() {
    echo "👀 Watching for changes in $WORKFLOW_DIR_NAME..."
    echo "   (Press Ctrl+C to stop)"
    
    # Primitive watch implementation using sleep & timestamp comparison
    # Ideally should use fswatch or entr if available
    
    # We will compute a simple hash of the directory state
    get_state() {
        find "$WORKFLOW_DIR_NAME" -type f -name "*.md" -o -name "*.py" -o -name "*.sh" | xargs -I {} ls -lT {} 2>/dev/null | cksum
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

case "$1" in
    gemini) sync_gemini ;;
    antigravity) sync_antigravity ;;
    --watch) 
        sync_all
        watch_loop
        ;;
    *)
        sync_all
        ;;
esac