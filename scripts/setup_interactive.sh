#!/bin/bash

#############################################################################
# setup_interactive.sh - Interactive Onboarding Wizard for Non-Tech Users
# 
# Usage: ./scripts/setup_interactive.sh
#        ./scripts/setup_interactive.sh --lang=vi
#        ./scripts/setup_interactive.sh --lang=en --non-interactive
#
# Features:
#  - 3 simple questions (wizard-style)
#  - Progress bar visualization
#  - Beginner-friendly language
#  - Automatic stack detection
#  - Help links for each step
#############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
LANG="${LANG:-vi}"
INTERACTIVE="${INTERACTIVE:-true}"
CONFIG_FILE="config.yaml"
VERBOSE=true

# Translations
declare -A MESSAGES_VI=(
    [welcome]="🎉 Chào mừng đến với Development Workflow!"
    [step_1]="📋 Bước 1/3: Loại dự án của bạn là gì?"
    [step_2]="📦 Bước 2/3: Bạn có quản lý nhiều dự án không?"
    [step_3]="🔐 Bước 3/3: Bạn muốn bật kiểm tra security không?"
    [completed]="✅ Hoàn thành! Hệ thống đã sẵn sàng."
    [help_text]="💡 Cần giúp? Xem: docs/GETTING_STARTED_NON_TECH.md"
)

declare -A MESSAGES_EN=(
    [welcome]="🎉 Welcome to Development Workflow!"
    [step_1]="📋 Step 1/3: What type of project do you have?"
    [step_2]="📦 Step 2/3: Do you manage multiple projects?"
    [step_3]="🔐 Step 3/3: Would you like to enable security checks?"
    [completed]="✅ Done! System is ready."
    [help_text]="💡 Need help? See: docs/GETTING_STARTED_NON_TECH.md"
)

# Select language
if [ "$LANG" == "en" ]; then
    declare -n MESSAGES=MESSAGES_EN
else
    declare -n MESSAGES=MESSAGES_VI
fi

###############################################################################
# Helper Functions
###############################################################################

print_header() {
    echo -e "\n${CYAN}${MESSAGES[welcome]}${NC}\n"
    echo -e "Language: ${YELLOW}${LANG}${NC}"
    echo -e "Config: ${YELLOW}${CONFIG_FILE}${NC}\n"
}

print_step() {
    local step_num=$1
    local message=$2
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${message}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_progress() {
    local current=$1
    local total=3
    local percent=$((current * 100 / total))
    local filled=$((current * 10 / total))
    
    printf "Progress: ${GREEN}"
    printf '█%.0s' $(seq 1 $filled)
    printf '░%.0s' $(seq $((filled+1)) 10)
    printf "${NC} ($current/$total)\n\n"
}

print_option() {
    local num=$1
    local text=$2
    echo -e "  ${YELLOW}[$num]${NC} $text"
}

ask_question() {
    local prompt=$1
    local default=$2
    local input
    
    read -p "$(echo -e '${CYAN}> ${NC}')$prompt" input < /dev/tty
    
    if [ -z "$input" ]; then
        echo "$default"
    else
        echo "$input"
    fi
}

detect_stack_auto() {
    # Auto-detect stack from project files
    if [ -f "package.json" ]; then
        echo "nodejs"
    elif [ -f "pubspec.yaml" ]; then
        echo "flutter"
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        echo "python"
    elif [ -f "go.mod" ]; then
        echo "go"
    elif [ -f "Cargo.toml" ]; then
        echo "rust"
    else
        echo "other"
    fi
}

update_config() {
    local key=$1
    local value=$2
    
    if grep -q "^$key:" "$CONFIG_FILE"; then
        sed -i.bak "s/^$key:.*/$key: $value/" "$CONFIG_FILE"
    else
        echo "$key: $value" >> "$CONFIG_FILE"
    fi
}

execute_setup() {
    local stack=$1
    local multi_project=$2
    local security=$3
    
    echo -e "\n${CYAN}⚙️  Đang thực hiện setup...${NC}"
    echo -e "   Stack: ${YELLOW}$stack${NC}"
    echo -e "   Multi-Project: ${YELLOW}$multi_project${NC}"
    echo -e "   Security: ${YELLOW}$security${NC}\n"
    
    # Update config
    update_config "default_stack" "$stack"
    update_config "deployment.parallel_deploy" "$multi_project"
    update_config "security.scan_for_secrets" "$security"
    
    # Run actual setup
    if [ -f "scripts/sync.sh" ]; then
        bash scripts/sync.sh --stack="$stack"
    fi
    
    echo -e "\n${GREEN}✅ ${MESSAGES[completed]}${NC}"
    echo -e "${MESSAGES[help_text]}\n"
}

###############################################################################
# Main Wizard Flow
###############################################################################

main() {
    print_header
    
    # QUESTION 1: Stack Type
    print_step 1 "${MESSAGES[step_1]}"
    print_progress 1
    
    detected=$(detect_stack_auto)
    echo -e "${YELLOW}🔍 Auto-detected: $detected${NC}\n"
    
    print_option 1 "Node.js / JavaScript"
    print_option 2 "Flutter / Dart"
    print_option 3 "Python"
    print_option 4 "Go / Rust / Other"
    echo
    
    stack_choice=$(ask_question "Chọn loại (1-4) hoặc Enter nếu đúng [$detected]: " "$detected")
    
    case $stack_choice in
        1) STACK="nodejs" ;;
        2) STACK="flutter" ;;
        3) STACK="python" ;;
        4) STACK="other" ;;
        *) STACK="$detected" ;;
    esac
    
    # QUESTION 2: Multi-Project
    print_step 2 "${MESSAGES[step_2]}"
    print_progress 2
    
    print_option "y" "Yes - I manage 2+ projects"
    print_option "n" "No - Single project"
    echo
    
    multi_choice=$(ask_question "Lựa chọn (y/n) [n]: " "n")
    
    case $multi_choice in
        y|Y|yes|YES) MULTI="true" ;;
        *) MULTI="false" ;;
    esac
    
    # QUESTION 3: Security
    print_step 3 "${MESSAGES[step_3]}"
    print_progress 3
    
    print_option "y" "Yes - Enable security checks"
    print_option "n" "No - Skip for now"
    echo
    
    security_choice=$(ask_question "Lựa chọn (y/n) [y]: " "y")
    
    case $security_choice in
        n|N|no|NO) SECURITY="false" ;;
        *) SECURITY="true" ;;
    esac
    
    # Execute setup
    execute_setup "$STACK" "$MULTI" "$SECURITY"
    
    return 0
}

###############################################################################
# Non-Interactive Mode (for CI/CD)
###############################################################################

non_interactive_setup() {
    local stack="${1:-nodejs}"
    local multi="${2:-false}"
    local security="${3:-true}"
    
    echo "Running non-interactive setup..."
    echo "  Stack: $stack"
    echo "  Multi-Project: $multi"
    echo "  Security: $security"
    
    execute_setup "$stack" "$multi" "$security"
}

###############################################################################
# Entry Point
###############################################################################

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --lang=*) LANG="${1#*=}" ;;
        --non-interactive) INTERACTIVE="false" ;;
        --stack=*) STACK_ARG="${1#*=}" ;;
        --help|-h)
            echo "Usage: ./scripts/setup_interactive.sh [OPTIONS]"
            echo "Options:"
            echo "  --lang=vi|en           Language (default: vi)"
            echo "  --non-interactive      Skip questions (use defaults)"
            echo "  --stack=<type>         Specify stack explicitly"
            echo "  --help                 Show this help"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# Run wizard
if [ "$INTERACTIVE" == "true" ]; then
    main
else
    non_interactive_setup "$STACK_ARG" "false" "true"
fi
