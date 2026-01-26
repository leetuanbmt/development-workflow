#!/bin/bash
# Script đồng bộ hóa môi trường AI Agent (Vibecoding Edition)
# Usage: ./development-workflow/scripts/sync.sh

echo "🚀 Starting AI Environment Sync..."

# 1. Setup cấu trúc .gemini (Gemini CLI) - ƯU TIÊN SỐ 1
echo "🛠  Configuring .gemini structure..."
mkdir -p .gemini
mkdir -p .gemini/memory

# Hàm helper tạo symlink an toàn
link_folder() {
    src=$1
    dest=$2
    rm -rf "$dest" # Xóa cũ (nếu là folder hoặc link)
    ln -s "$src" "$dest"
    echo "   🔗 Linked: $dest -> $src"
}

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

# 3. Setup cấu trúc .agent (Google Antigravity Standard)
echo "🛠  Configuring .agent structure..."

# Xóa .agent/skills cũ để đảm bảo sạch sẽ
rm -rf .agent/skills
mkdir -p .agent/skills

# Copy Skills (Source is Native Kebab-case)
if [ -d "development-workflow/skills" ]; then
    # Copy toàn bộ folder skills sang .agent
    cp -R development-workflow/skills/* .agent/skills/
    echo "   ✨ Synced .agent skills (Strict Google Antigravity Format)"
    
    # Đã loại bỏ phần tạo Alias snake_case để tránh duplicate
else
    echo "   ⚠️  Warning: development-workflow/skills directory not found!"
fi

# Sync workflows cho .agent - Chuyển sang kebab-case
echo "🛠  Configuring .agent workflows..."
rm -rf .agent/workflows
mkdir -p .agent/workflows

# Copy rules
mkdir -p .agent/rules
if [ -d "development-workflow/rules" ]; then
    cp -R development-workflow/rules/* .agent/rules/ 2>/dev/null || true
fi

if [ -d "development-workflow/workflows" ]; then
    for wf_path in development-workflow/workflows/*.md; do
        if [ -f "$wf_path" ]; then
            wf_name=$(basename "$wf_path")
            # Chuyển sang kebab-case
            kebab_wf_name=$(echo "$wf_name" | tr '_' '-')
            cp "$wf_path" ".agent/workflows/$kebab_wf_name"
        fi
    done
    echo "   ✅ Synced .agent workflows"
fi

cp development-workflow/CHEAT_SHEET.md .agent/ 2>/dev/null || true

echo "✅ Sync Complete! Your AI is ready (Google Antigravity Compliant)."