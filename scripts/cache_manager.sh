#!/bin/bash

#############################################################################
# cache_manager.sh - Manage Development Workflow Cache System
#
# Usage: ./scripts/cache_manager.sh status
#        ./scripts/cache_manager.sh clear
#        ./scripts/cache_manager.sh clear --pattern="pr_review"
#        ./scripts/cache_manager.sh invalidate --age=1h
#
# Features:
#  - View what's cached
#  - Clear cache (selective or all)
#  - Auto-invalidate old cache
#  - Monitor cache size
#############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Config
CACHE_DIR="${CACHE_DIR:-./.agent/.cache}"
CONFIG_FILE="${CONFIG_FILE:-config.yaml}"

###############################################################################
# Helper Functions
###############################################################################

print_header() {
    echo -e "\n${CYAN}┌────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${NC} Cache Manager - $(basename "$CACHE_DIR")${CYAN}           │${NC}"
    echo -e "${CYAN}└────────────────────────────────────────┘${NC}\n"
}

format_bytes() {
    local bytes=$1
    if [ $bytes -lt 1024 ]; then
        echo "${bytes}B"
    elif [ $bytes -lt 1048576 ]; then
        echo "$((bytes / 1024))KB"
    else
        echo "$((bytes / 1048576))MB"
    fi
}

format_time() {
    local seconds=$1
    if [ $seconds -lt 60 ]; then
        echo "${seconds}s ago"
    elif [ $seconds -lt 3600 ]; then
        echo "$((seconds / 60))m ago"
    elif [ $seconds -lt 86400 ]; then
        echo "$((seconds / 3600))h ago"
    else
        echo "$((seconds / 86400))d ago"
    fi
}

###############################################################################
# Status Command
###############################################################################

cmd_status() {
    print_header
    
    if [ ! -d "$CACHE_DIR" ]; then
        echo -e "${YELLOW}⚠️  Cache directory not found: $CACHE_DIR${NC}\n"
        return 1
    fi
    
    local total_size=0
    local file_count=0
    local now=$(date +%s)
    
    echo -e "${BLUE}Cache Contents:${NC}\n"
    
    if [ -z "$(ls -A "$CACHE_DIR" 2>/dev/null)" ]; then
        echo -e "  ${YELLOW}Empty${NC}\n"
    else
        echo -e "  ${BLUE}File${NC:40} ${BLUE}Size${NC:10} ${BLUE}Age${NC}"
        echo -e "  ${BLUE}==============================================================${NC}"
        
        while IFS= read -r file; do
            local filename=$(basename "$file")
            local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
            local mtime=$(stat -f%m "$file" 2>/dev/null || stat -c%Y "$file" 2>/dev/null || echo 0)
            local age=$((now - mtime))
            local age_str=$(format_time $age)
            local size_str=$(format_bytes $size)
            
            total_size=$((total_size + size))
            file_count=$((file_count + 1))
            
            printf "  %-40s %10s %s\n" "$filename" "$size_str" "$age_str"
        done < <(find "$CACHE_DIR" -type f 2>/dev/null)
    fi
    
    echo
    local total_size_str=$(format_bytes $total_size)
    
    # Get max size from config
    local max_size_mb=100
    if [ -f "$CONFIG_FILE" ]; then
        max_size_mb=$(grep "max_size_mb:" "$CONFIG_FILE" | awk '{print $2}' 2>/dev/null || echo 100)
    fi
    local max_size=$((max_size_mb * 1048576))
    
    echo -e "${BLUE}Summary:${NC}"
    echo -e "  Files: ${YELLOW}$file_count${NC}"
    echo -e "  Total Size: ${YELLOW}$total_size_str${NC} / ${max_size_mb}MB"
    
    if [ $total_size -gt $max_size ]; then
        echo -e "  Status: ${RED}⚠️  Over limit!${NC}"
    else
        local percent=$((total_size * 100 / max_size))
        if [ $percent -gt 80 ]; then
            echo -e "  Status: ${YELLOW}🔷 ${percent}% full${NC}"
        else
            echo -e "  Status: ${GREEN}✅ OK (${percent}% full)${NC}"
        fi
    fi
    
    echo
}

###############################################################################
# Clear Command
###############################################################################

cmd_clear() {
    local pattern="${1:-.}"
    local dry_run=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --pattern=*) pattern="${1#*=}" ;;
            --dry-run) dry_run=true ;;
            *) ;;
        esac
        shift
    done
    
    print_header
    
    if [ ! -d "$CACHE_DIR" ]; then
        echo -e "${YELLOW}⚠️  Cache directory not found${NC}\n"
        return 1
    fi
    
    local files_to_delete=()
    local total_freed=0
    
    # Find matching files
    while IFS= read -r file; do
        if [[ "$(basename "$file")" =~ $pattern ]]; then
            files_to_delete+=("$file")
            local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
            total_freed=$((total_freed + size))
        fi
    done < <(find "$CACHE_DIR" -type f 2>/dev/null)
    
    if [ ${#files_to_delete[@]} -eq 0 ]; then
        echo -e "${YELLOW}No files matching pattern: $pattern${NC}\n"
        return 0
    fi
    
    # Show what will be deleted
    echo -e "${BLUE}Files to delete (${#files_to_delete[@]} files, $(format_bytes $total_freed)):${NC}\n"
    for file in "${files_to_delete[@]}"; do
        echo -e "  ${YELLOW}✓${NC} $(basename "$file")"
    done
    echo
    
    if [ "$dry_run" == "true" ]; then
        echo -e "${YELLOW}Dry run - not deleting${NC}\n"
        return 0
    fi
    
    # Confirm deletion
    read -p "Delete these files? (y/N) " -n 1 -r < /dev/tty
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Cancelled${NC}\n"
        return 0
    fi
    
    # Delete files
    for file in "${files_to_delete[@]}"; do
        rm -f "$file"
    done
    
    echo -e "${GREEN}✅ Deleted ${#files_to_delete[@]} files (freed $(format_bytes $total_freed))${NC}\n"
}

###############################################################################
# Invalidate Command
###############################################################################

cmd_invalidate() {
    local age_spec="${1:-.}"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --age=*) age_spec="${1#*=}" ;;
            *) ;;
        esac
        shift
    done
    
    print_header
    
    # Convert time spec to seconds
    local max_age_seconds=3600  # default: 1 hour
    
    if [[ $age_spec =~ ^([0-9]+)([smh])$ ]]; then
        local amount="${BASH_REMATCH[1]}"
        local unit="${BASH_REMATCH[2]}"
        
        case "$unit" in
            s) max_age_seconds=$amount ;;
            m) max_age_seconds=$((amount * 60)) ;;
            h) max_age_seconds=$((amount * 3600)) ;;
        esac
    fi
    
    echo -e "${BLUE}Invalidating cache older than $(format_time $max_age_seconds)...${NC}\n"
    
    local now=$(date +%s)
    local deleted=0
    local total_freed=0
    
    # Find old files
    while IFS= read -r file; do
        local mtime=$(stat -f%m "$file" 2>/dev/null || stat -c%Y "$file" 2>/dev/null || echo 0)
        local age=$((now - mtime))
        
        if [ $age -gt $max_age_seconds ]; then
            local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
            rm -f "$file"
            deleted=$((deleted + 1))
            total_freed=$((total_freed + size))
            echo -e "  ${GREEN}✓${NC} Deleted: $(basename "$file") ($(format_time $age))"
        fi
    done < <(find "$CACHE_DIR" -type f 2>/dev/null)
    
    echo
    echo -e "${GREEN}✅ Invalidated $deleted files ($(format_bytes $total_freed) freed)${NC}\n"
}

###############################################################################
# Cleanup Command
###############################################################################

cmd_cleanup() {
    print_header
    
    echo -e "${BLUE}Running cache cleanup...${NC}\n"
    
    # Get settings from config
    local max_size_mb=100
    local auto_invalidate_hours=1
    
    if [ -f "$CONFIG_FILE" ]; then
        max_size_mb=$(grep "max_size_mb:" "$CONFIG_FILE" | awk '{print $2}' 2>/dev/null || echo 100)
        auto_invalidate_hours=$(grep "auto_invalidate_hours:" "$CONFIG_FILE" | awk '{print $2}' 2>/dev/null || echo 1)
    fi
    
    local max_size=$((max_size_mb * 1048576))
    
    # 1. Invalidate old cache
    echo -e "${BLUE}Step 1: Invalidating cache older than ${auto_invalidate_hours}h...${NC}"
    cmd_invalidate --age="${auto_invalidate_hours}h" > /dev/null
    
    # 2. Check total size
    echo -e "${BLUE}Step 2: Checking cache size...${NC}"
    local total_size=$(du -sk "$CACHE_DIR" 2>/dev/null | awk '{print $1 * 1024}' || echo 0)
    
    if [ $total_size -gt $max_size ]; then
        echo -e "${YELLOW}⚠️  Cache over limit! ($((total_size / 1048576))MB > ${max_size_mb}MB)${NC}"
        echo -e "${BLUE}Step 3: Removing oldest files...${NC}"
        
        # Remove oldest files until under limit
        local files=()
        while IFS= read -r file; do
            files+=("$file")
        done < <(find "$CACHE_DIR" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | awk '{print $2}')
        
        for file in "${files[@]}"; do
            if [ $total_size -le $max_size ]; then
                break
            fi
            local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
            rm -f "$file"
            total_size=$((total_size - size))
            echo -e "  ${GREEN}✓${NC} Removed: $(basename "$file")"
        done
    fi
    
    echo -e "\n${GREEN}✅ Cleanup complete${NC}\n"
}

###############################################################################
# Help & Main
###############################################################################

print_help() {
    cat <<EOF
${CYAN}Cache Manager${NC} - Manage Development Workflow Cache

${BLUE}Usage:${NC}
  ./scripts/cache_manager.sh <command> [options]

${BLUE}Commands:${NC}
  status                    Show cache contents and stats
  clear [--pattern=regex]   Delete cache files
                            Examples:
                              clear                          (all files)
                              clear --pattern="pr_review"    (specific pattern)
                              clear --pattern="^skill_"      (regex)
  
  invalidate [--age=<spec>] Remove cache older than specified time
                            Spec format: <number>[s|m|h]
                            Examples:
                              invalidate --age=1h        (1 hour)
                              invalidate --age=30m       (30 minutes)
  
  cleanup                   Auto-cleanup: invalidate old + respect size limit
  
  help, -h, --help          Show this help

${BLUE}Options:${NC}
  --dry-run                 Show what would be deleted (don't delete)

${BLUE}Examples:${NC}
  ./scripts/cache_manager.sh status
  ./scripts/cache_manager.sh invalidate --age=1h
  ./scripts/cache_manager.sh clear --pattern="pr_review" --dry-run
  ./scripts/cache_manager.sh cleanup

EOF
}

main() {
    if [ $# -eq 0 ]; then
        print_help
        exit 1
    fi
    
    local command="$1"
    shift
    
    case "$command" in
        status)
            cmd_status ;;
        clear)
            cmd_clear "$@" ;;
        invalidate)
            cmd_invalidate "$@" ;;
        cleanup)
            cmd_cleanup ;;
        help|-h|--help)
            print_help ;;
        *)
            echo -e "${RED}Unknown command: $command${NC}"
            print_help
            exit 1
            ;;
    esac
}

main "$@"
