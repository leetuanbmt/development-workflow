#!/bin/bash

#############################################################################
# detect_stack_with_validation.sh - Robust Tech Stack Detection
# 
# Usage: ./scripts/detect_stack_with_validation.sh
#        ./scripts/detect_stack_with_validation.sh --json
#        ./scripts/detect_stack_with_validation.sh --force
#
# Purpose:
#  - Detect tech stack with high confidence
#  - Handle ambiguous cases (Node + Python)
#  - Validate detected stack makes sense
#  - Allow manual override
#  - Cache results for future use
#############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Config
CACHE_FILE=".agent/.stack_detection_cache"
OUTPUT_FORMAT="text"  # text, json
FORCE_REDETECT=false
ERROR_ON_AMBIGUOUS=false

###############################################################################
# Detection Functions
###############################################################################

detect_nodejs() {
    [ -f "package.json" ] || return 1
    return 0
}

detect_flutter() {
    [ -f "pubspec.yaml" ] || return 1
    return 0
}

detect_python() {
    [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ] || return 1
    return 0
}

detect_go() {
    [ -f "go.mod" ] || return 1
    return 0
}

detect_rust() {
    [ -f "Cargo.toml" ] || return 1
    return 0
}

detect_ruby() {
    [ -f "Gemfile" ] || [ -f "Rakefile" ] || return 1
    return 0
}

detect_django() {
    [ -f "manage.py" ] || return 1
    return 0
}

detect_rails() {
    [ -f "config/rails_env.rb" ] || return 1
    return 0
}

detect_java() {
    [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "settings.gradle" ] || return 1
    return 0
}

detect_dotnet() {
    ls *.csproj 2>/dev/null | head -1 > /dev/null || return 1
    return 0
}

###############################################################################
# Main Detection Logic
###############################################################################

run_detection() {
    local detected_stacks=()
    
    # Run all detectors
    detect_nodejs && detected_stacks+=("nodejs")
    detect_flutter && detected_stacks+=("flutter")
    detect_python && detected_stacks+=("python")
    detect_go && detected_stacks+=("go")
    detect_rust && detected_stacks+=("rust")
    detect_ruby && detected_stacks+=("ruby")
    detect_django && detected_stacks+=("django")
    detect_rails && detected_stacks+=("rails")
    detect_java && detected_stacks+=("java")
    detect_dotnet && detected_stacks+=("dotnet")
    
    echo "${detected_stacks[@]}"
}

###############################################################################
# Confidence Scoring
###############################################################################

score_primary_stack() {
    local stack=$1
    local score=0
    
    case "$stack" in
        nodejs)
            [ -f "package.json" ] && score=$((score + 30))
            [ -f "package-lock.json" ] && score=$((score + 20))
            [ -f "tsconfig.json" ] && score=$((score + 10))
            [ -d "node_modules" ] && score=$((score + 10))
            ;;
        flutter)
            [ -f "pubspec.yaml" ] && score=$((score + 30))
            [ -f "pubspec.lock" ] && score=$((score + 20))
            [ -d "lib" ] && score=$((score + 10))
            ;;
        python)
            [ -f "requirements.txt" ] && score=$((score + 25))
            [ -f "setup.py" ] && score=$((score + 25))
            [ -f "pyproject.toml" ] && score=$((score + 20))
            [ -d "venv" ] && score=$((score + 10))
            ;;
        go)
            [ -f "go.mod" ] && score=$((score + 40))
            [ -f "go.sum" ] && score=$((score + 10))
            ;;
        rust)
            [ -f "Cargo.toml" ] && score=$((score + 40))
            [ -f "Cargo.lock" ] && score=$((score + 10))
            ;;
    esac
    
    echo "$score"
}

select_primary_stack() {
    local stacks=("$@")
    
    if [ ${#stacks[@]} -eq 0 ]; then
        echo "unknown"
        return 1
    fi
    
    if [ ${#stacks[@]} -eq 1 ]; then
        echo "${stacks[0]}"
        return 0
    fi
    
    # Multiple stacks detected - score them
    local highest_score=0
    local best_stack=""
    
    for stack in "${stacks[@]}"; do
        score=$(score_primary_stack "$stack")
        if [ $score -gt $highest_score ]; then
            highest_score=$score
            best_stack="$stack"
        fi
    done
    
    echo "$best_stack"
}

###############################################################################
# Output Formatting
###############################################################################

output_text() {
    local primary=$1
    local all_stacks=$2
    local confidence=$3
    
    echo -e "\n${BLUE}═══════════════════════════════════${NC}"
    echo -e "${GREEN}Stack Detection Result${NC}"
    echo -e "${BLUE}═══════════════════════════════════${NC}\n"
    
    echo -e "Primary Stack: ${YELLOW}$primary${NC}"
    echo -e "Confidence: ${YELLOW}$confidence%${NC}"
    echo -e "All Detected: ${YELLOW}$all_stacks${NC}\n"
    
    if [ "$confidence" -lt 50 ]; then
        echo -e "${YELLOW}⚠️  Low confidence! Please verify manually:${NC}"
        echo -e "   export STACK=$primary"
        echo -e "   # or use: ./scripts/setup_interactive.sh --stack=nodejs\n"
    fi
    
    echo -e "${BLUE}═══════════════════════════════════${NC}\n"
}

output_json() {
    local primary=$1
    local all_stacks=$2
    local confidence=$3
    
    cat <<EOF
{
  "primary": "$primary",
  "detected": [$all_stacks],
  "confidence": $confidence,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

###############################################################################
# Validation & Caching
###############################################################################

save_cache() {
    local stack=$1
    
    mkdir -p ".agent"
    cat > "$CACHE_FILE" <<EOF
{
  "stack": "$stack",
  "timestamp": "$(date +%s)",
  "detected_by": "detect_stack_with_validation.sh"
}
EOF
}

load_cache() {
    if [ ! -f "$CACHE_FILE" ]; then
        return 1
    fi
    
    # Check if cache is fresh (< 1 hour)
    local cache_time=$(cat "$CACHE_FILE" | grep -o '"timestamp": [0-9]*' | grep -o '[0-9]*')
    local now=$(date +%s)
    local age=$((now - cache_time))
    
    if [ $age -gt 3600 ]; then
        return 1  # Cache expired
    fi
    
    cat "$CACHE_FILE" | grep -o '"stack": "[^"]*' | grep -o '"[^"]*"' | sed 's/"//g'
}

###############################################################################
# Main
###############################################################################

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --json) OUTPUT_FORMAT="json" ;;
            --force) FORCE_REDETECT=true ;;
            --error-on-ambiguous) ERROR_ON_AMBIGUOUS=true ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS]"
                echo "Options:"
                echo "  --json                 Output as JSON"
                echo "  --force                Skip cache, redetect"
                echo "  --error-on-ambiguous   Exit with error if multiple stacks found"
                exit 0
                ;;
        esac
        shift
    done
    
    # Try cache first
    if [ "$FORCE_REDETECT" == "false" ]; then
        cached=$(load_cache 2>/dev/null || true)
        if [ -n "$cached" ]; then
            if [ "$OUTPUT_FORMAT" == "json" ]; then
                output_json "$cached" "$cached" "100" 
            else
                echo -e "${BLUE}📦 Using cached detection: ${YELLOW}$cached${NC}"
            fi
            return 0
        fi
    fi
    
    # Run detection
    detected=$(run_detection)
    IFS=' ' read -r -a stacks_array <<< "$detected"
    
    # Select primary
    primary=$(select_primary_stack "${stacks_array[@]}")
    
    # Calculate confidence
    confidence=$(score_primary_stack "$primary")
    
    # Validate
    if [ ${#stacks_array[@]} -gt 1 ]; then
        if [ "$ERROR_ON_AMBIGUOUS" == "true" ]; then
            echo -e "${RED}❌ Ambiguous: Multiple stacks detected!${NC}" >&2
            echo "Run interactively: ./scripts/setup_interactive.sh" >&2
            return 1
        fi
    fi
    
    if [ "$primary" == "unknown" ]; then
        echo -e "${RED}❌ Could not detect tech stack!${NC}" >&2
        echo "Please specify manually: export STACK=nodejs" >&2
        return 1
    fi
    
    # Output result
    detected_str=$(IFS=', '; echo "${stacks_array[*]}")
    
    if [ "$OUTPUT_FORMAT" == "json" ]; then
        output_json "$primary" "$detected_str" "$confidence"
    else
        output_text "$primary" "$detected_str" "$confidence"
    fi
    
    # Cache result
    save_cache "$primary"
    
    return 0
}

main "$@"
