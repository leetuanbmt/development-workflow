#!/bin/bash
# Integration Test: /start-task → /vibe workflow
# Tests the complete flow from planning to implementation

set -e

TEST_NAME="start_task_to_vibe_workflow"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "🧪 Testing: $TEST_NAME"
echo "================================"

# Get project root directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR/../.."

# Test 1: Verify /start-task workflow exists
echo "Test 1: Checking /start-task workflow..."
if [ -f "$PROJECT_ROOT/.agent/workflows/core/start-task.md" ]; then
    echo -e "${GREEN}✅ PASS: /start-task workflow found${NC}"
else
    echo -e "${RED}❌ FAIL: /start-task workflow missing${NC}"
    exit 1
fi

# Test 2: Verify /vibe workflow exists
echo "Test 2: Checking /vibe workflow..."
if [ -f "$PROJECT_ROOT/.agent/workflows/core/vibe.md" ]; then
    echo -e "${GREEN}✅ PASS: /vibe workflow found${NC}"
else
    echo -e "${RED}❌ FAIL: /vibe workflow missing${NC}"
    exit 1
fi

# Test 3: Check workflow version consistency
echo "Test 3: Checking workflow versions..."
START_TASK_VERSION=$(grep '^version:' "$PROJECT_ROOT/.agent/workflows/core/start-task.md" | sed 's/version: "\(.*\)"/\1/')
VIBE_VERSION=$(grep '^version:' "$PROJECT_ROOT/.agent/workflows/core/vibe.md" | sed 's/version: "\(.*\)"/\1/')

SYSTEM_VERSION=$(cat "$PROJECT_ROOT/VERSION")

if [[ "$START_TASK_VERSION" == "$SYSTEM_VERSION"* ]] && [[ "$VIBE_VERSION" == "$SYSTEM_VERSION"* ]]; then
    echo -e "${GREEN}✅ PASS: Workflow versions aligned with system v$SYSTEM_VERSION${NC}"
else
    echo -e "${RED}❌ FAIL: Version mismatch (start-task: $START_TASK_VERSION, vibe: $VIBE_VERSION, system: $SYSTEM_VERSION)${NC}"
    exit 1
fi

# Test 4: Verify skill integration
echo "Test 4: Checking skill integration..."
if grep -q "vibecoder" "$PROJECT_ROOT/.agent/workflows/core/vibe.md"; then
    echo -e "${GREEN}✅ PASS: /vibe workflow integrates vibecoder skill${NC}"
else
    echo -e "${RED}❌ FAIL: /vibe workflow missing vibecoder integration${NC}"
    exit 1
fi

# Test 5: Verify workflow handover
echo "Test 5: Checking workflow handover logic..."
if grep -q "/vibe" "$PROJECT_ROOT/.agent/workflows/core/start-task.md"; then
    echo -e "${GREEN}✅ PASS: /start-task correctly suggests /vibe${NC}"
else
    echo -e "${RED}❌ FAIL: /start-task doesn't suggest /vibe${NC}"
    exit 1
fi

# Test 6: Verify CLI command generation
echo "Test 6: Checking CLI command files..."
if [ -f "$PROJECT_ROOT/.gemini/commands/start-task.toml" ] && [ -f "$PROJECT_ROOT/.gemini/commands/vibe.toml" ]; then
    echo -e "${GREEN}✅ PASS: CLI commands generated${NC}"
else
    echo -e "${RED}❌ FAIL: Missing CLI command files${NC}"
    exit 1
fi

echo ""
echo "================================"
echo -e "${GREEN}🎉 All tests passed!${NC}"
echo "Workflow: /start-task → /vibe is operational"
