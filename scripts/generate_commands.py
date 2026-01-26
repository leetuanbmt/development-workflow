import os
import glob
import re

# Cấu hình đường dẫn (Relative to Project Root)
WORKFLOW_DIR = "development-workflow/workflows"
COMMAND_DIR = ".gemini/commands"

def parse_frontmatter(content):
    """Trích xuất description từ YAML Frontmatter"""
    description = "AI Workflow Command"
    
    if content.startswith("---"):
        try:
            parts = content.split("---", 2)
            if len(parts) >= 3:
                header = parts[1]
                for line in header.split("\n"):
                    if line.strip().startswith("description:"):
                        description = line.split(":", 1)[1].strip().strip('"').strip("'")
        except Exception:
            pass
            
    return description

def convert_md_to_toml():
    # Đảm bảo thư mục output tồn tại
    if not os.path.exists(COMMAND_DIR):
        os.makedirs(COMMAND_DIR)
        print(f"Created directory: {COMMAND_DIR}")

    print(f"🔄 Converting workflows from {WORKFLOW_DIR} to {COMMAND_DIR}...")
    
    count = 0
    for md_path in glob.glob(f"{WORKFLOW_DIR}/*.md"):
        filename = os.path.basename(md_path)
        cmd_name = filename.replace(".md", ".toml")
        output_path = os.path.join(COMMAND_DIR, cmd_name)
        
        with open(md_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        description = parse_frontmatter(content)
        
        # Escape triple quotes để tránh lỗi cú pháp TOML
        safe_content = content.replace('"""', '\"\"\"')
        
        # Tạo nội dung TOML (Dùng phép cộng chuỗi thay vì f-string multiline phức tạp để an toàn)
        toml_content = 'description = "' + description + '"\n'
        toml_content += 'prompt = """\n' + safe_content + '\n"""'
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(toml_content)
            
        print(f"   ✅ Generated: {cmd_name}")
        count += 1

    print(f"🎉 Done! Converted {count} commands.")

if __name__ == "__main__":
    # Chạy từ root project
    if not os.path.exists(WORKFLOW_DIR):
        print(f"❌ Error: Cannot find {WORKFLOW_DIR}. Please run this script from the project root.")
    else:
        convert_md_to_toml()