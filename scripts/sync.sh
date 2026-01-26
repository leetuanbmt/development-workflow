#!/bin/bash
# Script đồng bộ hóa môi trường AI Agent (Vibecoding Edition)
# Usage: ./development-workflow/scripts/sync.sh [gemini|antigravity]

echo "🚀 Starting AI Environment Sync..."

# Hàm helper tạo symlink an toàn
link_folder() {
    src=$1
    dest=$2
    rm -rf "$dest" # Xóa cũ (nếu là folder hoặc link)
    ln -s "$src" "$dest"
    echo "   🔗 Linked: $dest -> $src"
}

sync_gemini() {
    # 1. Setup cấu trúc .gemini (Gemini CLI) - ƯU TIÊN SỐ 1
    echo "🛠  Configuring .gemini structure..."
    mkdir -p .gemini
    mkdir -p .gemini/memory

    # Tạo các Symlink logic (Trỏ về development-workflow)
    link_folder "../development-workflow/rules" ".gemini/rules"
    link_folder "../development-workflow/skills" ".gemini/skills"
    link_folder "../development-workflow/CHEAT_SHEET.md" ".gemini/CHEAT_SHEET.md"
    link_folder "../development-workflow/GEMINI.md" ".gemini/GEMINI.md"

    # 2. Generate Commands (MD -> TOML)
    rm -rf .gemini/commands
    mkdir -p .gemini/commands

    echo "🔄 Generating Gemini Commands (.toml)..."
    if command -v python3 &> /dev/null; then
        python3 development-workflow/scripts/generate_commands.py
    else
        echo "⚠️  Python3 not found. Trying python..."
        python development-workflow/scripts/generate_commands.py
    fi
}

sync_antigravity() {
    echo "🛠  Configuring .agent structure (Strict Google Antigravity Standard)..."

    # Làm sạch và tạo cấu trúc gốc
    rm -rf .agent
    mkdir -p .agent/memory
    mkdir -p .agent/skills
    mkdir -p .agent/workflows

    # 1. README
    cp development-workflow/README.md .agent/README.md 2>/dev/null || true

    # 2. Memory (Mapped from Rules)
    if [ -d "development-workflow/rules" ]; then
        cp development-workflow/rules/01-project-context.md .agent/memory/PROJECT.md 2>/dev/null || true
        cp development-workflow/rules/02-architecture-rules.md .agent/memory/ARCHITECTURE.md 2>/dev/null || true
        cp development-workflow/rules/00-core-behavior.md .agent/memory/CONVENTIONS.md 2>/dev/null || true
        touch .agent/memory/GLOSSARY.md
    fi

    # 3. Skills Structure (Nested Directory)
    if [ -d "development-workflow/skills" ]; then
        cp -R development-workflow/skills/* .agent/skills/
        
        # Đảm bảo sub-dirs cho Skills
        for skill_dir in .agent/skills/*; do
            if [ -d "$skill_dir" ]; then
                mkdir -p "$skill_dir/resources" "$skill_dir/examples" "$skill_dir/scripts"
            fi
        done
        
        echo "   ✨ Synced skills"
    fi

    # 4. Workflows Structure (Flat Files)
    if [ -d "development-workflow/workflows" ]; then
        for wf_path in development-workflow/workflows/*.md; do
            if [ -f "$wf_path" ]; then
                wf_file=$(basename "$wf_path")
                # Chuyển sang kebab-case
                wf_name=$(echo "${wf_file%.md}" | tr '_' '-')
                
                # Copy thành file phẳng: .agent/workflows/workflow-name.md
                cp "$wf_path" ".agent/workflows/$wf_name.md"
            fi
        done
        echo "   ✅ Synced workflows (Flat structure)"
    fi

    cp development-workflow/CHEAT_SHEET.md .agent/ 2>/dev/null || true
}

case "$1" in
    gemini)
        sync_gemini
        ;;
    antigravity)
        sync_antigravity
        ;;
    *)
        sync_gemini
        sync_antigravity
        echo "✅ Sync Complete! Your AI is ready (Google Antigravity Compliant)"
        ;;
esac