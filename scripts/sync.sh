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
# Xóa folder commands cũ để đảm bảo sạch sẽ
rm -rf .gemini/commands
mkdir -p .gemini/commands

echo "🔄 Generating Gemini Commands (.toml)..."
if command -v python3 &> /dev/null; then
    python3 development-workflow/scripts/generate_commands.py
else
    echo "⚠️  Python3 not found. Trying python..."
    python development-workflow/scripts/generate_commands.py
fi

# 3. Cập nhật Submodule (Optional & Safe)
# Nếu update lỗi thì chỉ warn user, không chặn quá trình sync config
if [ -d ".git" ]; then
    echo "📦 Updating development-workflow submodule..."
    if git submodule update --init --recursive; then
        echo "   ✅ Submodules updated."
    else
        echo "   ⚠️  WARNING: Could not update submodules (dirty working tree?)."
        echo "   👉 Please check 'git status' inside submodules manually."
    fi
fi

echo "✅ Sync Complete! Your AI is ready."
echo "👉 Try: /help to see available commands."