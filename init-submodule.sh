#!/bin/bash
# Script khởi tạo bộ AI Workflow khi dùng làm Submodule

# 1. Xác định các đường dẫn
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_ROOT="$SCRIPT_DIR"
PROJECT_ROOT="$(dirname "$WORKFLOW_ROOT")"

echo "🌟 Initializing AI Workflow Submodule..."

# 2. Tạo file cấu hình mặc định nếu chưa có
if [ ! -f "$PROJECT_ROOT/GEMINI.md" ]; then
    echo "📝 Creating default GEMINI.md in project root..."
    cat > "$PROJECT_ROOT/GEMINI.md" <<EOL
# Gemini CLI Configuration

Dự án này sử dụng bộ AI Workflow chuẩn.

## Hướng dẫn
1. Sync môi trường: Chạy \`./$(basename "$WORKFLOW_ROOT")/scripts/sync.sh\`
2. Workflows: Gõ \`/help\` trong Gemini CLI.

EOL
fi

# 3. Chạy sync lần đầu
echo "🔄 Running first sync..."
bash "$WORKFLOW_ROOT/scripts/sync.sh"

echo "✅ Initialization complete!"
echo "👉 NEXT STEP: Run '/setup-agent' in your Gemini CLI to initialize project context."
