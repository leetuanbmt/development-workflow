#!/bin/bash
# validate.sh - Kiểm tra tính nhất quán của AI Development Workflow
# Usage: ./$(basename $(dirname $(dirname $0)))/scripts/validate.sh

echo "🔍 Validating AI Development Workflow..."
echo "========================================="

ERRORS=0
WARNINGS=0

# 1. Check YAML frontmatter in workflows
echo ""
echo "📋 Checking workflow frontmatter..."
for f in workflows/*.md; do
    if ! head -10 "$f" | grep -q "^description:"; then
        echo "  ❌ Missing 'description' in $f"
        ((ERRORS++))
    fi
    if ! head -10 "$f" | grep -q "^trigger:"; then
        echo "  ❌ Missing 'trigger' in $f"
        ((ERRORS++))
    fi
    if ! head -10 "$f" | grep -q "^version:"; then
        echo "  ⚠️ Missing 'version' in $f"
        ((WARNINGS++))
    fi
done
echo "  ✅ Workflow frontmatter check complete"

# 2. Check skill structure
echo ""
echo "📋 Checking skill structure..."
for skill_dir in skills/*/; do
    # Skip special folders like _composites
    if [[ "$(basename "$skill_dir")" == _* ]]; then
        continue
    fi
    if [ ! -f "${skill_dir}SKILL.md" ]; then
        echo "  ❌ Missing SKILL.md in $skill_dir"
        ((ERRORS++))
    fi
done
echo "  ✅ Skill structure check complete"

# 3. Check required files exist
echo ""
echo "📋 Checking required files..."
REQUIRED_FILES=(
    "README.md"
    "CHANGELOG.md"
    "CHEAT_SHEET.md"
    "VERSION"
    "memory/knowledge_base.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "  ❌ Missing required file: $file"
        ((ERRORS++))
    fi
done
echo "  ✅ Required files check complete"

# 4. Check for broken workflow references
echo ""
echo "📋 Checking workflow references..."
for f in workflows/*.md; do
    # Extract skill references
    grep -oP "(?<=- )[a-z-]+" "$f" 2>/dev/null | while read skill; do
        if [ ! -d "skills/$skill" ] && [ "$skill" != "" ]; then
            echo "  ⚠️ Referenced skill '$skill' not found (in $f)"
        fi
    done
done
echo "  ✅ Workflow references check complete"

# 5. Version consistency
echo ""
echo "📋 Checking version consistency..."
ROOT_VERSION=$(cat VERSION 2>/dev/null | tr -d '\n')
echo "  📌 Root version: $ROOT_VERSION"

MISMATCHED=0
for f in workflows/*.md; do
    WF_VERSION=$(grep "^version:" "$f" 2>/dev/null | sed 's/version: *"\([^"]*\)"/\1/' | tr -d ' ')
    if [ "$WF_VERSION" != "" ] && [ "$WF_VERSION" != "$ROOT_VERSION" ]; then
        echo "  ⚠️ Version mismatch in $f: $WF_VERSION (expected $ROOT_VERSION)"
        ((WARNINGS++))
        ((MISMATCHED++))
    fi
done
if [ $MISMATCHED -eq 0 ]; then
    echo "  ✅ All versions consistent"
fi

# Summary
echo ""
echo "========================================="
echo "📊 Validation Summary"
echo "========================================="
echo "  ❌ Errors:   $ERRORS"
echo "  ⚠️ Warnings: $WARNINGS"
echo ""

if [ $ERRORS -gt 0 ]; then
    echo "❌ Validation FAILED - Please fix errors before proceeding"
    exit 1
else
    echo "✅ Validation PASSED"
    exit 0
fi
