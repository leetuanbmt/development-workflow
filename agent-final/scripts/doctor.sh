#!/usr/bin/env bash
# .agent/scripts/doctor.sh
# Environment health check for AI Workflow Framework
# Usage: bash .agent/scripts/doctor.sh

set -e

AGENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

pass() { echo -e "  ${GREEN}✅ $1${NC}"; }
fail() { echo -e "  ${RED}❌ $1${NC}"; ERRORS=$((ERRORS+1)); }
warn() { echo -e "  ${YELLOW}⚠️  $1${NC}"; WARNINGS=$((WARNINGS+1)); }
info() { echo -e "  ${BLUE}ℹ️  $1${NC}"; }

ERRORS=0
WARNINGS=0

echo ""
echo -e "${BLUE}🏥 AI Workflow Doctor — Environment Check${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── 1. Core Tools ─────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[1/5] Core Tools${NC}"

check_tool() {
  if command -v "$1" &>/dev/null; then
    pass "$1 found ($(command -v "$1"))"
  else
    fail "$1 not found — install it to use this workflow"
  fi
}

check_tool git
check_tool python3

# ── 2. .agent Structure ───────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[2/5] .agent Folder Structure${NC}"

required_dirs=(
  "memory" "rules" "skills" "workflows" "scripts" "schema"
)
for dir in "${required_dirs[@]}"; do
  if [ -d "$AGENT_DIR/$dir" ]; then
    pass "$dir/ present"
  else
    fail "$dir/ missing — framework may be incomplete"
  fi
done

# ── 3. Project Config ─────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[3/5] Project Config${NC}"

if [ -f "$AGENT_DIR/memory/PROJECT.md" ]; then
  # Check if still a template (has unresolved placeholders)
  if grep -q '\[PROJECT_NAME\]' "$AGENT_DIR/memory/PROJECT.md"; then
    warn "memory/PROJECT.md still has [PROJECT_NAME] placeholder — run /init to configure"
  else
    pass "memory/PROJECT.md configured"
  fi
else
  fail "memory/PROJECT.md missing — run /init to create it"
fi

if [ -f "$AGENT_DIR/memory/ARCHITECTURE.md" ]; then
  if grep -q '\[PROJECT_NAME\]' "$AGENT_DIR/memory/ARCHITECTURE.md"; then
    warn "memory/ARCHITECTURE.md still has placeholders — run /init to configure"
  else
    pass "memory/ARCHITECTURE.md configured"
  fi
else
  warn "memory/ARCHITECTURE.md missing — run /init to generate"
fi

# ── 4. Git Status ─────────────────────────────────────────────────────────────
echo ""
echo -e "${BLUE}[4/5] Git Repository${NC}"

if git rev-parse --is-inside-work-tree &>/dev/null; then
  pass "Inside a git repository"
  
  # Uncommitted changes
  uncommitted=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  if [ "$uncommitted" -gt 0 ]; then
    warn "$uncommitted uncommitted change(s) — consider /review-changes before proceeding"
  else
    pass "Working tree clean"
  fi

  # Last 5 commits (for workflow suggestions)
  echo ""
  info "Recent commits:"
  git log --oneline -5 2>/dev/null | while read line; do
    echo "     $line"
  done
else
  warn "Not inside a git repository — some features may not work"
fi

# ── 5. Smart Workflow Suggestions ─────────────────────────────────────────────
echo ""
echo -e "${BLUE}[5/5] Workflow Suggestions${NC}"

if git rev-parse --is-inside-work-tree &>/dev/null; then
  changed_files=$(git diff --name-only HEAD~1 HEAD 2>/dev/null || echo "")
  
  if echo "$changed_files" | grep -qE "(bloc|reducer|store|provider)" 2>/dev/null; then
    info "State management changes detected → consider /write-test"
  fi
  if echo "$changed_files" | grep -qE "(datasource|repository|api|service)" 2>/dev/null; then
    info "Data layer changes detected → consider /audit"
  fi
  if echo "$changed_files" | grep -qE "(page|screen|view|widget|component)" 2>/dev/null; then
    info "Presentation changes detected → consider /review"
  fi
  if [ "$uncommitted" -gt 0 ] 2>/dev/null; then
    info "Uncommitted changes present → consider /review-changes"
  fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo -e "${GREEN}✅ All checks passed — environment is healthy${NC}"
elif [ "$ERRORS" -eq 0 ]; then
  echo -e "${YELLOW}⚠️  $WARNINGS warning(s) — environment is functional but needs attention${NC}"
else
  echo -e "${RED}❌ $ERRORS error(s), $WARNINGS warning(s) — fix errors before proceeding${NC}"
fi
echo ""
