#!/bin/bash
# Description: Create a clean diff for PR review with SMART base branch detection.
# Usage: ./create_pr_diff.sh [-b base_branch] [-y] [--help]

# Default values
BASE_BRANCH=""
CONFIRM=true
OUTPUT_FILE="pr_changes.diff"
CACHE_FILE=".pr_review_cache"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Argument parsing
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -b|--base) BASE_BRANCH="$2"; shift ;;
        -y|--yes) CONFIRM=false ;;
        -h|--help) 
            echo "Usage: ./create_pr_diff.sh [-b base_branch] [-y] [--help]"
            echo ""
            echo "Options:"
            echo "  -b, --base BRANCH  Specify base branch manually"
            echo "  -y, --yes          Skip confirmation (auto-confirm)"
            echo "  -h, --help         Show this help message"
            exit 0 
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Get current branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Check if running from project root
if [ ! -d ".git" ] && [ ! -f ".git" ]; then
    echo -e "${RED}❌ Error: Must run from Git repository root${NC}"
    exit 1
fi

# Function: Find the most likely parent branch using merge-base
find_parent_branch() {
    local current_branch="$1"
    local candidates=()
    
    # Fetch latest refs quietly (log separately, not in return value)
    git fetch origin --quiet 2>/dev/null || true
    
    # Get all remote branches except current
    local all_branches=$(git branch -r | grep -v HEAD | grep -v "$current_branch" | sed 's/^[[:space:]]*origin\///')
    
    # Priority order for common base branches
    local priority_branches=("main" "master" "develop" "staging")
    
    # Add priority branches first if they exist
    for branch in "${priority_branches[@]}"; do
        if echo "$all_branches" | grep -qx "$branch"; then
            candidates+=("origin/$branch")
        fi
    done
    
    # Find branches with common ancestor (merge-base)
    local best_branch=""
    local min_distance=999999
    
    for candidate in "${candidates[@]}"; do
        if git show-ref --verify --quiet "refs/remotes/$candidate"; then
            # Calculate distance from merge-base to current branch
            local merge_base=$(git merge-base "$candidate" HEAD 2>/dev/null || echo "")
            if [ -n "$merge_base" ]; then
                local distance=$(git rev-list --count "$merge_base..HEAD" 2>/dev/null || echo "999999")
                
                if [ "$distance" -lt "$min_distance" ]; then
                    min_distance=$distance
                    best_branch=$candidate
                fi
            fi
        fi
    done
    
    echo "$best_branch"
}

# Auto-detect base branch if not provided
if [ -z "$BASE_BRANCH" ]; then
    # Check cache first
    if [ -f "$CACHE_FILE" ]; then
        CACHED_BASE=$(cat "$CACHE_FILE" | grep "BASE_BRANCH=" | cut -d'=' -f2)
        CACHED_CURRENT=$(cat "$CACHE_FILE" | grep "CURRENT_BRANCH=" | cut -d'=' -f2)
        
        if [ "$CACHED_CURRENT" = "$CURRENT_BRANCH" ]; then
            echo -e "${GREEN}📦 Using cached base branch: $CACHED_BASE${NC}"
            BASE_BRANCH="$CACHED_BASE"
        fi
    fi
    
    # Detect if cache miss
    if [ -z "$BASE_BRANCH" ]; then
        echo -e "${BLUE}🔍 Auto-detecting parent branch...${NC}"
        echo -e "${BLUE}🔄 Fetching latest refs...${NC}"
        BASE_BRANCH=$(find_parent_branch "$CURRENT_BRANCH")
    fi
fi

if [ -z "$BASE_BRANCH" ]; then
    echo -e "${RED}❌ Error: Could not auto-detect base branch.${NC}"
    echo "Please specify one with: -b origin/branch-name"
    exit 1
fi

# Verify base branch exists
if ! git show-ref --verify --quiet "refs/remotes/$BASE_BRANCH"; then
    echo -e "${RED}❌ Error: Base branch '$BASE_BRANCH' does not exist.${NC}"
    exit 1
fi

# Calculate diff stats with error handling
MERGE_BASE=$(git merge-base "$BASE_BRANCH" HEAD 2>/dev/null || echo "")
if [ -z "$MERGE_BASE" ]; then
    echo -e "${RED}❌ Error: Cannot find common ancestor with '$BASE_BRANCH'.${NC}"
    echo "This might mean branches have completely different histories."
    exit 1
fi

CHANGED_FILES=$(git diff --name-only "$BASE_BRANCH...HEAD" 2>/dev/null | wc -l | tr -d ' ')
COMMITS_AHEAD=$(git rev-list --count "$MERGE_BASE..HEAD" 2>/dev/null || echo "0")

echo ""
echo -e "${BLUE}📋 Review Context:${NC}"
echo -e "   Feature Branch: ${GREEN}$CURRENT_BRANCH${NC}"
echo -e "   Target Base:    ${YELLOW}$BASE_BRANCH${NC}"
echo -e "   Merge Point:    ${YELLOW}$(git log --oneline -1 $MERGE_BASE)${NC}"
echo -e "   Changed Files:  ${GREEN}$CHANGED_FILES${NC}"
echo -e "   Commits Ahead:  ${GREEN}$COMMITS_AHEAD${NC}"
echo "----------------------------------------"

# Confirmation step
if [ "$CONFIRM" = true ]; then
    read -p "$(echo -e ${YELLOW}❓ Proceed with diff generation? [Y/n]: ${NC})" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${RED}🚫 Cancelled.${NC}"
        exit 0
    fi
fi

# Generate diff
echo -e "${BLUE}📝 Generating diff...${NC}"
git diff "$BASE_BRANCH...HEAD" -- . \
    ':(exclude)package-lock.json' \
    ':(exclude)yarn.lock' \
    ':(exclude)pnpm-lock.yaml' \
    ':(exclude)*.lock' \
    ':(exclude)*.min.js' \
    ':(exclude)*.map' \
    ':(exclude)dist/*' \
    ':(exclude)build/*' \
    ':(exclude).dart_tool/*' \
    ':(exclude).idea/*' \
    ':(exclude).vscode/*' \
    ':(exclude)*.g.dart' \
    ':(exclude)*.freezed.dart' \
    ':(exclude)*.gen.dart' \
    ':(exclude)Podfile.lock' \
    > "$OUTPUT_FILE"

if [ -s "$OUTPUT_FILE" ]; then
    LINES=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')
    echo -e "${GREEN}✅ Success: Diff saved to '$OUTPUT_FILE' ($LINES lines).${NC}"
    
    # Save to cache
    echo "BASE_BRANCH=$BASE_BRANCH" > "$CACHE_FILE"
    echo "CURRENT_BRANCH=$CURRENT_BRANCH" >> "$CACHE_FILE"
    echo "TIMESTAMP=$(date +%s)" >> "$CACHE_FILE"
    
    echo -e "${GREEN}👉 File ready for /review workflow.${NC}"
else
    echo -e "${YELLOW}⚠️  Warning: Diff is empty. Are branches identical?${NC}"
    rm -f "$CACHE_FILE"
fi
