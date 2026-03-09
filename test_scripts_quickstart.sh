#!/bin/bash

#############################################################################
# test_scripts_quickstart.sh - Quick validation of all new scripts
#
# Run this to verify everything works:
# ./test_scripts_quickstart.sh
#
# Or use make:
# ./test_scripts_quickstart.sh --make
#############################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

print_header() {
    echo -e "\n${BLUE}┌────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC} Quick Script Validation${BLUE}            │${NC}"
    echo -e "${BLUE}└────────────────────────────────────────┘${NC}\n"
}

test_passed() {
    local name=$1
    echo -e "${GREEN}✅ PASS${NC}  $name"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_failed() {
    local name=$1
    local error=$2
    echo -e "${RED}❌ FAIL${NC}  $name"
    echo -e "         ${RED}Error: $error${NC}"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

test_skipped() {
    local name=$1
    local reason=$2
    echo -e "${YELLOW}⊘ SKIP${NC}  $name (${reason})"
    TESTS_SKIPPED=$((TESTS_SKIPPED + 1))
}

###############################################################################
# Test 1: Check if all scripts exist
###############################################################################

test_1_scripts_exist() {
    echo -e "\n${BLUE}Test 1: Scripts Exist${NC}"
    
    local scripts=(
        "scripts/setup_interactive.sh"
        "scripts/detect_stack_with_validation.sh"
        "scripts/skill_confidence_scorer.py"
        "scripts/cache_manager.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            test_passed "$script exists"
        else
            test_failed "$script exists" "File not found"
        fi
    done
}

###############################################################################
# Test 2: Check if scripts are executable
###############################################################################

test_2_scripts_executable() {
    echo -e "\n${BLUE}Test 2: Scripts Executable${NC}"
    
    local scripts=(
        "scripts/setup_interactive.sh"
        "scripts/detect_stack_with_validation.sh"
        "scripts/cache_manager.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -x "$script" ]; then
            test_passed "$script is executable"
        else
            test_failed "$script is executable" "Not executable (run: chmod +x $script)"
        fi
    done
}

###############################################################################
# Test 3: Config file validation
###############################################################################

test_3_config_yaml() {
    echo -e "\n${BLUE}Test 3: Config.yaml Exists${NC}"
    
    if [ -f "config.yaml" ]; then
        test_passed "config.yaml exists"
        
        # Check for key settings
        if grep -q "language:" config.yaml; then
            test_passed "config.yaml has 'language' setting"
        else
            test_failed "config.yaml has 'language' setting" "Setting not found"
        fi
        
        if grep -q "cache:" config.yaml; then
            test_passed "config.yaml has 'cache' section"
        else
            test_failed "config.yaml has 'cache' section" "Section not found"
        fi
    else
        test_failed "config.yaml exists" "File not found"
    fi
}

###############################################################################
# Test 4: Script syntax validation
###############################################################################

test_4_bash_syntax() {
    echo -e "\n${BLUE}Test 4: Bash Syntax Validation${NC}"
    
    local scripts=(
        "scripts/setup_interactive.sh"
        "scripts/detect_stack_with_validation.sh"
        "scripts/cache_manager.sh"
    )
    
    for script in "${scripts[@]}"; do
        if bash -n "$script" 2>/dev/null; then
            test_passed "$script bash syntax valid"
        else
            test_failed "$script bash syntax valid" "Syntax error in script"
        fi
    done
}

###############################################################################
# Test 5: Python syntax validation
###############################################################################

test_5_python_syntax() {
    echo -e "\n${BLUE}Test 5: Python Syntax Validation${NC}"
    
    if command -v python3 &> /dev/null; then
        if python3 -m py_compile scripts/skill_confidence_scorer.py 2>/dev/null; then
            test_passed "skill_confidence_scorer.py syntax valid"
        else
            test_failed "skill_confidence_scorer.py syntax valid" "Syntax error"
        fi
    else
        test_skipped "skill_confidence_scorer.py syntax" "Python3 not installed"
    fi
}

###############################################################################
# Test 6: Script help text
###############################################################################

test_6_script_help() {
    echo -e "\n${BLUE}Test 6: Script Help Text (--help)${NC}"
    
    # Test setup_interactive help
    if bash scripts/setup_interactive.sh --help > /dev/null 2>&1; then
        test_passed "setup_interactive.sh --help works"
    else
        test_failed "setup_interactive.sh --help works" "Command failed"
    fi
    
    # Test detect_stack help
    if bash scripts/detect_stack_with_validation.sh --help > /dev/null 2>&1; then
        test_passed "detect_stack.sh --help works"
    else
        test_failed "detect_stack.sh --help works" "Command failed"
    fi
    
    # Test cache_manager help
    if bash scripts/cache_manager.sh help > /dev/null 2>&1; then
        test_passed "cache_manager.sh help works"
    else
        test_failed "cache_manager.sh help works" "Command failed"
    fi
    
    # Test skill scorer help
    if command -v python3 &> /dev/null; then
        if python3 scripts/skill_confidence_scorer.py --help > /dev/null 2>&1; then
            test_passed "skill_scorer.py --help works"
        else
            test_failed "skill_scorer.py --help works" "Command failed"
        fi
    fi
}

###############################################################################
# Test 7: Makefile targets
###############################################################################

test_7_makefile_targets() {
    echo -e "\n${BLUE}Test 7: Makefile New Targets${NC}"
    
    if make help &> /dev/null | grep -q "setup-wizard"; then
        test_passed "Makefile has 'make setup-wizard' target"
    else
        test_failed "Makefile has 'make setup-wizard' target" "Target not found"
    fi
    
    if make -n cache-status &> /dev/null; then
        test_passed "Makefile 'make cache-status' is defined"
    else
        test_failed "Makefile 'make cache-status' is defined" "Target not found"
    fi
}

###############################################################################
# Test 8: Documentation files
###############################################################################

test_8_documentation() {
    echo -e "\n${BLUE}Test 8: Documentation Files${NC}"
    
    local docs=(
        "SCRIPTS_REFERENCE.md"
        "DELIVERY_SUMMARY.md"
    )
    
    for doc in "${docs[@]}"; do
        if [ -f "$doc" ]; then
            test_passed "$doc exists"
        else
            test_failed "$doc exists" "File not found"
        fi
    done
}

###############################################################################
# Test 9: Detect stack functionality
###############################################################################

test_9_detect_stack() {
    echo -e "\n${BLUE}Test 9: Stack Detection (Dry Run)${NC}"
    
    # Create a test project structure
    mkdir -p .test_project
    touch .test_project/package.json
    
    # Test detection in test directory
    if (cd .test_project && bash ../scripts/detect_stack_with_validation.sh --force > /tmp/detect_test.out 2>&1); then
        if grep -q "primary\|nodejs" /tmp/detect_test.out; then
            test_passed "detect_stack.sh can detect Node.js project"
        else
            test_failed "detect_stack.sh can detect Node.js project" "Detection output unexpected"
        fi
    else
        test_failed "detect_stack.sh runs without error" "Script execution failed"
    fi
    
    # Cleanup
    rm -rf .test_project /tmp/detect_test.out
}

###############################################################################
# Test 10: Skill scorer functionality
###############################################################################

test_10_skill_scorer() {
    echo -e "\n${BLUE}Test 10: Skill Scorer (Dry Run)${NC}"
    
    if command -v python3 &> /dev/null; then
        if python3 scripts/skill_confidence_scorer.py "find a bug" > /tmp/scorer_test.out 2>&1; then
            if grep -qi "bug-investigator\|confidence" /tmp/scorer_test.out; then
                test_passed "skill_scorer.py can score a task"
            else
                test_failed "skill_scorer.py can score a task" "Output format unexpected"
            fi
        else
            test_failed "skill_scorer.py runs without error" "Script execution failed"
        fi
        rm -f /tmp/scorer_test.out
    else
        test_skipped "skill_scorer.py execution" "Python3 not installed"
    fi
}

###############################################################################
# Summary & Results
###############################################################################

print_summary() {
    echo -e "\n${BLUE}┌────────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│${NC}  Results${BLUE}                             │${NC}"
    echo -e "${BLUE}└────────────────────────────────────────┘${NC}\n"
    
    echo -e "  ${GREEN}Passed:${NC}  $TESTS_PASSED"
    echo -e "  ${RED}Failed:${NC}  $TESTS_FAILED"
    echo -e "  ${YELLOW}Skipped:${NC} $TESTS_SKIPPED"
    echo
    
    local total=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}✅ All tests passed! ($TESTS_PASSED / $total)${NC}\n"
        return 0
    else
        echo -e "${RED}❌ Some tests failed! ($TESTS_PASSED passed, $TESTS_FAILED failed)${NC}\n"
        return 1
    fi
}

###############################################################################
# Main
###############################################################################

main() {
    print_header
    
    # Verify we're in right directory
    if [ ! -f "Makefile" ] || [ ! -d "scripts" ]; then
        echo -e "${RED}Error: Must run from development-workflow root directory${NC}"
        exit 1
    fi
    
    # Run all tests
    test_1_scripts_exist
    test_2_scripts_executable
    test_3_config_yaml
    test_4_bash_syntax
    test_5_python_syntax
    test_6_script_help
    test_7_makefile_targets
    test_8_documentation
    test_9_detect_stack
    test_10_skill_scorer
    
    # Print summary
    print_summary
}

main
