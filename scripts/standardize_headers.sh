#!/bin/bash
# Standardize Vietnamese headers to English in workflow files

WORKFLOWS=(
  "workflows/core/audit.md"
  "workflows/core/fix.md"
  "workflows/core/investigate.md"
  "workflows/core/refactor.md"
  "workflows/core/review.md"
  "workflows/core/start-task.md"
  "workflows/ops/deploy.md"
  "workflows/ops/doctor.md"
  "workflows/ops/document.md"
  "workflows/ops/prepare-release.md"
  "workflows/tech/integrate-api.md"
  "workflows/tech/manage-db.md"
  "workflows/tech/write-test.md"
)

for file in "${WORKFLOWS[@]}"; do
  if [ -f "$file" ]; then
    echo "Processing: $file"
    
    # Standardize section headers
    sed -i '' \
      -e 's/\*\*Mục tiêu:\*\*/\*\*Objective:\*\*/g' \
      -e 's/## 🔄 Quy trình (Execution Flow)/## 🔄 Execution Flow/g' \
      -e 's/## 🚀 Các bước /## 🚀 Steps /g' \
      -e 's/## 💡 Hướng dẫn cho AI/## 💡 AI Guidelines/g' \
      -e 's/## ⚠️ Lưu ý/## ⚠️ Important Notes/g' \
      -e 's/## ⚠️ Điều kiện Tiên quyết (Prerequisites)/## ⚠️ Prerequisites/g' \
      -e 's/## 🎯 Chọn Môi Trường (Environment Selection)/## 🎯 Environment Selection/g' \
      -e 's/## 📋 Deployment Checklist/## 📋 Deployment Checklist/g' \
      "$file"
    
    echo "  ✅ Done"
  fi
done

echo ""
echo "🎉 Standardization complete!"
