#!/bin/bash

# Script to select project directory for setup-agent
# Usage: 
#   Interactive: source ./select_project_dir.sh
#   Automated:   source ./select_project_dir.sh "/path/to/project"

# Input argument check
if [ -n "$1" ]; then
    if [ -d "$1" ]; then
        SELECTED_DIR="$1"
        echo "🤖 Auto-selected directory: $SELECTED_DIR"
        echo "RESULT_DIR=$SELECTED_DIR"
        return 0 2>/dev/null || exit 0
    else
        echo "❌ Provided directory does not exist: $1"
        # Fallback to interactive mode check
    fi
fi

echo "🔍 Bạn muốn quét dự án từ đâu?"
options=("Root (Thư mục hiện tại)" "Chọn thư mục con" "Nhập đường dẫn thủ công")
PS3='Vui lòng chọn (1-3): '

select opt in "${options[@]}"
do
    case $opt in
        "Root (Thư mục hiện tại)")
            SELECTED_DIR="."
            break
            ;;
        "Chọn thư mục con")
            echo "📁 Các thư mục hiện có:"
            # List only directories, excluding hidden ones and common ignore folders
            dirs=($(ls -d */ 2>/dev/null | grep -vE "^(\.)"))
            if [ ${#dirs[@]} -eq 0 ]; then
                echo "❌ Không tìm thấy thư mục con nào."
                SELECTED_DIR="."
                break
            fi
            
            PS3='Chọn thư mục (1-${#dirs[@]}): '
            select d in "${dirs[@]}"
            do
                if [ -n "$d" ]; then
                    SELECTED_DIR="${d%/}"
                    break 2
                fi
            done
            ;;
        "Nhập đường dẫn thủ công")
            read -p "⌨️ Nhập đường dẫn: " SELECTED_DIR
            if [ -d "$SELECTED_DIR" ]; then
                break
            else
                echo "❌ Thư mục không tồn tại. Vui lòng thử lại."
            fi
            ;;
        *) echo "❌ Lựa chọn không hợp lệ $REPLY";;
    esac
done

echo "✅ Đã chọn: $SELECTED_DIR"
echo "RESULT_DIR=$SELECTED_DIR"
