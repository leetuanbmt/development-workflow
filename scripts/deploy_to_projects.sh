#!/bin/bash
# Script to deploy workflows and skills to other projects
# Usage: ./scripts/deploy_to_projects.sh [project_name]

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PARENT_DIR="$(dirname "$PROJECT_ROOT")"

# List of target projects (auto-detect or specify)
declare -a PROJECTS=(
    "kansuke-app"
    "kansuke-photo"
)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Deploying Workflows & Skills to Projects${NC}"
echo ""

# Filter projects if argument provided
if [ -n "$1" ]; then
    PROJECTS=("$1")
    echo -e "${YELLOW}📌 Deploying to specific project: $1${NC}"
fi

# Deploy function
deploy_to_project() {
    local project=$1
    local target_path="$PARENT_DIR/$project"
    
    if [ ! -d "$target_path" ]; then
        echo -e "${YELLOW}  ⚠️  Skipping $project (not found)${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📦 Deploying to: $project${NC}"
    
    # Create .agent directory if not exists
    mkdir -p "$target_path/.agent"
    
    # Copy skills (following symlinks with -L)
    if [ -d "$PROJECT_ROOT/.agent/skills" ]; then
        echo "   🧠 Copying skills..."
        cp -R -L "$PROJECT_ROOT/.agent/skills" "$target_path/.agent/"
    fi
    
    # Copy workflows (following symlinks with -L)
    if [ -d "$PROJECT_ROOT/.agent/workflows" ]; then
        echo "   📋 Copying workflows..."
        cp -R -L "$PROJECT_ROOT/.agent/workflows" "$target_path/.agent/"
    fi
    
    # Copy to .gemini if exists
    if [ -d "$target_path/.gemini" ]; then
        echo "   💎 Syncing to .gemini..."
        
        # Copy skills
        mkdir -p "$target_path/.gemini/skills"
        cp -R -L "$PROJECT_ROOT/.agent/skills" "$target_path/.gemini/" 2>/dev/null || true
        
        # Generate commands if python available
        if command -v python3 &> /dev/null && [ -f "$PROJECT_ROOT/scripts/generate_commands.py" ]; then
            echo "   🔄 Generating .toml commands..."
            cd "$target_path" && python3 "$PROJECT_ROOT/scripts/generate_commands.py" --source=".agent/workflows" 2>/dev/null
            cd "$PROJECT_ROOT"
        fi
    fi
    
    echo -e "${GREEN}   ✅ Deployed to $project${NC}"
    return 0
}

# Deploy to all projects
deployed_count=0
failed_count=0

for project in "${PROJECTS[@]}"; do
    if deploy_to_project "$project"; then
        ((deployed_count++))
    else
        ((failed_count++))
    fi
    echo ""
done

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Successfully deployed: $deployed_count${NC}"
if [ $failed_count -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Skipped: $failed_count${NC}"
fi
echo ""
echo -e "${BLUE}💡 Next Steps:${NC}"
echo "   1. Test workflows in each project: cd ../project-name && /review"
echo "   2. Verify .agent/skills/ content"
echo "   3. Check .gemini/commands/ for updated .toml files"
