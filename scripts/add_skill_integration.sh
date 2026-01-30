#!/bin/bash
# Add Skill Integration sections to workflows

# 1. Xác định thư mục gốc của dự án (Dynamic Path Resolution)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKFLOW_ROOT="$(dirname "$SCRIPT_DIR")"

echo "📂 Project Root: $WORKFLOW_ROOT"
cd "$WORKFLOW_ROOT" || exit

# /investigate
cat >> workflows/core/investigate.md.tmp << 'EOF'

## 🔌 Skill Integration

**Active skill:** `bug-investigator`

This workflow automatically loads and applies the bug-investigator skill methodology. The AI will:
1. Read `skills/bug-investigator/SKILL.md` for investigation procedures
2. Follow root cause analysis techniques
3. Generate report in skill's specified format
EOF

# /fix
cat >> workflows/core/fix.md.tmp << 'EOF'

## 🔌 Skill Integration

**Active skills:** `bug-investigator`, `code-reviewer`

**Skill sequence:**
1. **bug-investigator** → Quick investigation (Step 1)
2. **bug-investigator** + **code-reviewer** → Solution design (Step 2-3)
3. **code-reviewer** → Verification (Step 4)

Skills are applied automatically inline - no separate invocation needed.
EOF

# /review
cat >> workflows/core/review.md.tmp << 'EOF'

## 🔌 Skill Integration

**Active skill:** `code-reviewer`

Auto-loads code review checklist and standards from `skills/code-reviewer/SKILL.md`.
Applies context-aware review methodology automatically.
EOF

# /audit
cat >> workflows/core/audit.md.tmp << 'EOF'

## 🔌 Skill Integration

**Active skills:** `code-reviewer`, `tech-lead`

**Skill sequence:**
1. **code-reviewer** → Technical compliance check
2. **tech-lead** → Architecture decision validation

Both skills applied based on audit aspect selected.
EOF

echo "✅ Skill integration templates created in .tmp files"
echo "👉 Please manually review and merge these .tmp files into the markdown files."