#!/bin/bash
# Script to bump all workflow versions to v5.2.0

set -e

WORKFLOWS=(
  "core/workflows/core/audit.md"
  "core/workflows/core/fix.md"
  "core/workflows/core/investigate.md"
  "core/workflows/core/refactor.md"
  "core/workflows/core/review.md"
  "core/workflows/core/start-task.md"
  "core/workflows/core/vibe.md"
  "core/workflows/ops/deploy.md"
  "core/workflows/ops/doctor.md"
  "core/workflows/ops/document.md"
  "core/workflows/ops/prepare-release.md"
  "core/workflows/ops/setup.md"
  "core/workflows/tech/integrate-api.md"
  "core/workflows/tech/manage-db.md"
  "core/workflows/tech/write-test.md"
)

TARGET_VERSION="5.2.0"

echo "🔄 Bumping workflow versions to v${TARGET_VERSION}..."

for workflow in "${WORKFLOWS[@]}"; do
  if [ -f "$workflow" ]; then
    # Backup original
    cp "$workflow" "${workflow}.bak"
    
    # Replace version line
    sed -i '' 's/^version: ".*"/version: "'"${TARGET_VERSION}"'"/' "$workflow"
    
    echo "   ✅ Updated: $workflow"
  else
    echo "   ⚠️  Not found: $workflow"
  fi
done

echo ""
echo "🎉 Version bump complete!"
echo "🔍 Verify changes:"
echo "   grep -h '^version:' core/workflows/**/*.md | sort | uniq -c"
