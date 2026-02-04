#!/bin/bash

# Doctor Script - Check Environment Health & Sync Status

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🏥 Starting Doctor Check..."
echo "=============================="

ERRORS=0

# 1. Check Required Tools
check_tool() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✅ Found $1${NC}"
    else
        echo -e "${RED}❌ Missing $1${NC}"
        ((ERRORS++))
    fi
}

echo "🛠  Checking Tools..."
check_tool "git"
check_tool "flutter"
# melos might be installed globally or locally
if command -v "melos" &> /dev/null || ( [ -f "pubspec.yaml" ] && grep -q "melos" pubspec.yaml ); then
     echo -e "${GREEN}✅ Found melos${NC}"
else
     echo -e "${YELLOW}⚠️  Melos not found (Global). Check local setup.${NC}"
fi

echo ""

# 1b. Check Security Tools (Recommended)
echo "🛡️  Checking Security Tools (Recommended)..."
check_security_tool() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✅ Found $1 (Security enforced)${NC}"
    else
        echo -e "${YELLOW}⚠️  Missing $1 (Recommended for secret scanning)${NC}"
        echo -e "${YELLOW}   Install: $2${NC}"
    fi
}

check_security_tool "git-secrets" "brew install git-secrets (macOS) | apt-get install git-secrets (Linux)"
check_security_tool "trufflehog" "brew install trufflehog (macOS) | pip install trufflehog (Cross-platform)"

echo ""

# 2. Check Directories existence
echo "📂 Checking Structure..."
if [ -d ".agent" ]; then
    echo -e "${GREEN}✅ Found .agent directory${NC}"
else
    echo -e "${RED}❌ Missing .agent directory. Run 'make sync'${NC}"
    ((ERRORS++))
fi

if [ -d ".gemini" ]; then
    echo -e "${GREEN}✅ Found .gemini directory${NC}"
else
    echo -e "${RED}❌ Missing .gemini directory. Run 'make sync'${NC}"
    ((ERRORS++))
fi

echo ""

# 3. Check Sync Status (Simple File Count & Timestamp heuristic)
echo "🔄 Checking Sync Status..."

check_sync() {
    SRC="$1"
    DEST="$2"
    NAME="$3"

    if [ ! -d "$SRC" ]; then
        return
    fi

    # Count files
    COUNT_SRC=$(find "$SRC" -type f | wc -l)
    
    # Destination might have different structure (flat vs nested), so simple count matches specific files
    # For .agent/memory vs rules, we map specific files.
    # Let's check generally if DEST exists and is not empty
    if [ ! -d "$DEST" ]; then
        echo -e "${RED}❌ Missing destination $DEST${NC}"
        ((ERRORS++))
        return
    fi
    
    COUNT_DEST=$(find "$DEST" -type f | wc -l)

    # Very basic check: If source has files but dest has 0, it's broken
    if [ "$COUNT_SRC" -gt 0 ] && [ "$COUNT_DEST" -eq 0 ]; then
         echo -e "${RED}❌ $NAME seems empty ($COUNT_DEST files) while source has $COUNT_SRC files.${NC}"
         ((ERRORS++))
    else
         echo -e "${GREEN}✅ $NAME seems populated.${NC}"
    fi
}

check_sync "development-workflow/rules" ".agent/memory" "Agent Memory"
check_sync "development-workflow/skills" ".agent/skills" "Agent Skills"

# Check Symlinks for .gemini
if [ -L ".gemini/rules" ]; then
    echo -e "${GREEN}✅ .gemini/rules is a valid symlink${NC}"
else
    echo -e "${RED}❌ .gemini/rules is NOT a symlink or missing${NC}"
    ((ERRORS++))
fi

echo ""

# 4. Smart Workflow Suggestions
suggest_workflow() {
    echo "💡 Smart Workflow Suggestions:"
    
    SUGGESTIONS=0
    
    # Check recent git changes
    if git rev-parse --git-dir > /dev/null 2>&1; then
        RECENT_FILES=$(git diff --name-only HEAD~5 2>/dev/null | head -10)
        
        # BLoC/Cubit changes → suggest testing
        if echo "$RECENT_FILES" | grep -qE "(bloc|cubit)\.dart$"; then
            echo "   → /write-test (BLoC/Cubit changes detected)"
            ((SUGGESTIONS++))
        fi
        
        # Data layer changes → suggest architecture audit
        if echo "$RECENT_FILES" | grep -qE "(entity|model|mapper|repository)\.dart$"; then
            echo "   → /audit (Data layer changes)"
            ((SUGGESTIONS++))
        fi
        
        # Presentation changes → suggest review
        if echo "$RECENT_FILES" | grep -qE "presentation/.+\.dart$"; then
            echo "   → /review (Presentation layer changes)"
            ((SUGGESTIONS++))
        fi
        
        # Bug fix patterns
        if git log --oneline -5 2>/dev/null | grep -qiE "(fix|bug|issue)"; then
            echo "   → /write-test (Recent bug fixes - add regression tests)"
            ((SUGGESTIONS++))
        fi
    fi
    
    # Check for common project patterns
    if [ -f "pubspec.yaml" ]; then
        # Flutter project
        if grep -q "flutter_bloc" pubspec.yaml 2>/dev/null; then
            echo "   → /vibecode (Flutter + BLoC project ready)"
            ((SUGGESTIONS++))
        fi
    fi
    
    # Check for uncommitted changes
    if git status --porcelain 2>/dev/null | grep -q "^M"; then
        echo "   → /review (Uncommitted changes detected)"
        ((SUGGESTIONS++))
    fi
    
    if [ $SUGGESTIONS -eq 0 ]; then
        echo "   → /start-task (No specific context - use master workflow)"
    fi
}

suggest_workflow

echo ""
echo "=============================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}🎉 All systems operational! You are ready to code.${NC}"
else
    echo -e "${RED}⚠️  Found $ERRORS issues. Please review above.${NC}"
    exit 1
fi

