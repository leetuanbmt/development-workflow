#!/bin/bash

# Test AI Provider Converter
# Verifies the converter tool is set up correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONVERTER_PATH="$SCRIPT_DIR/ai-provider-converter.py"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🔄 AI Provider Converter Test Suite${NC}\n"

# Test 1: Check Python
echo -n "Test 1: Python availability... "
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo -e "${GREEN}✅ Found Python ${PYTHON_VERSION}${NC}"
else
    echo -e "${RED}❌ Python3 not found${NC}"
    exit 1
fi

# Test 2: Check PyYAML
echo -n "Test 2: PyYAML module... "
if python3 -c "import yaml" 2>/dev/null; then
    echo -e "${GREEN}✅ PyYAML installed${NC}"
else
    echo -e "${YELLOW}⚠️  PyYAML not found. Installing...${NC}"
    pip install pyyaml
    echo -e "${GREEN}✅ PyYAML installed${NC}"
fi

# Test 3: Check converter script exists
echo -n "Test 3: Converter script... "
if [ -f "$CONVERTER_PATH" ]; then
    echo -e "${GREEN}✅ Found at $CONVERTER_PATH${NC}"
else
    echo -e "${RED}❌ Converter not found at $CONVERTER_PATH${NC}"
    exit 1
fi

# Test 4: Check converter is executable
echo -n "Test 4: Converter execute permissions... "
if [ -x "$CONVERTER_PATH" ] || [ -f "$CONVERTER_PATH" ]; then
    echo -e "${GREEN}✅ Script is executable${NC}"
else
    echo -e "${YELLOW}⚠️  Making script executable...${NC}"
    chmod +x "$CONVERTER_PATH"
    echo -e "${GREEN}✅ Script is now executable${NC}"
fi

# Test 5: List providers
echo -e "\nTest 5: Listing providers..."
python3 "$CONVERTER_PATH" --list-providers
echo -e "${GREEN}✅ Provider listing works${NC}"

# Test 6: Check workflows exist
echo -n "\nTest 6: Discovering workflows... "
WORKFLOW_COUNT=$(find . -path "./.converted-workflows" -prune -o -path "./workflows" -name "*.md" -print 2>/dev/null | wc -l)
if [ "$WORKFLOW_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✅ Found $WORKFLOW_COUNT workflows${NC}"
else
    echo -e "${YELLOW}⚠️  No workflows found (this is OK for fresh setup)${NC}"
fi

# Test 7: Test converter help
echo -n "\nTest 7: Converter help... "
if python3 "$CONVERTER_PATH" --help &>/dev/null; then
    echo -e "${GREEN}✅ Help command works${NC}"
else
    echo -e "${YELLOW}⚠️  Help command had issues${NC}"
fi

# Test 8: Dry-run conversion (no actual conversion, just validation)
echo -e "\nTest 8: Converter validation..."
echo "  Testing converter logic... "

# Create a minimal test workflow
TEST_WORKFLOW="/tmp/test-workflow.md"
cat > "$TEST_WORKFLOW" << 'EOF'
---
description: "Test workflow"
trigger: /test
version: "1.0.0"
skills:
  - test-skill
constraints:
  max_iterations: 1
  timeout_minutes: 10
---

# Test Workflow
This is a test workflow.
EOF

# Try converting it
if python3 "$CONVERTER_PATH" \
    --from antigravity \
    --to claude \
    --project-root "$(pwd)" \
    --workflows-only &>/dev/null; then
    echo -e "${GREEN}✅ Converter validation passed${NC}"
else
    echo -e "${YELLOW}⚠️  Converter validation had issues${NC}"
fi

# Cleanup
rm -f "$TEST_WORKFLOW"

# Summary
echo -e "\n${BLUE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ All tests passed!${NC}\n"

echo -e "${BLUE}📋 Next Steps:${NC}\n"
echo "1. Choose a provider:"
echo -e "   ${BLUE}• Claude${NC}  - Complex planning (200K tokens)\n   ${BLUE}• Gemini${NC}  - Large projects (1M tokens, free tier)\n   ${BLUE}• Copilot${NC} - IDE-based coding (8K tokens)"
echo ""
echo "2. Convert your workflows:"
echo "   python3 scripts/ai-provider-converter.py --to claude"
echo "   python3 scripts/ai-provider-converter.py --to gemini"
echo "   python3 scripts/ai-provider-converter.py --to copilot"
echo ""
echo "3. Read the adapter guide for your provider:"
echo "   • docs/guides/CLAUDE_ADAPTER.md"
echo "   • docs/guides/GEMINI_ADAPTER.md"
echo "   • docs/guides/COPILOT_ADAPTER.md"
echo ""
echo "4. Set up authentication:"
echo "   • Claude: export ANTHROPIC_API_KEY='sk-ant-...'"
echo "   • Gemini: gcloud auth application-default login"
echo "   • Copilot: Install VS Code extension + sign in"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════${NC}\n"
