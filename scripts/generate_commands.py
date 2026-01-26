import os
import glob
import re

# Cấu hình đường dẫn (Relative to Project Root)
WORKFLOW_DIR = "development-workflow/workflows"
COMMAND_DIR = ".gemini/commands"

def parse_frontmatter(content):
    """Trích xuất description, skill và trả về nội dung chính (đã bỏ frontmatter)"""
    meta = {
        "description": "AI Workflow Command",
        "skill": None
    }
    body = content
    
    if content.startswith("---"):
        try:
            parts = content.split("---", 2)
            if len(parts) >= 3:
                header = parts[1]
                body = parts[2].strip() # Lấy phần nội dung sau frontmatter và xóa khoảng trắng thừa đầu/cuối
                
                for line in header.split("\n"):
                    line = line.strip()
                    if line.startswith("description:"):
                        meta["description"] = line.split(":", 1)[1].strip().strip('"').strip("'")
                    elif line.startswith("skill:"):
                        meta["skill"] = line.split(":", 1)[1].strip().strip('"').strip("'")
        except Exception:
            pass
            
    return meta, body

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
        
        meta, body = parse_frontmatter(content)
        
        # --- TOML GENERATION START ---
        lines = []
        
        # 1. Description
        lines.append(f'description = "{meta["description"]}"')
        lines.append('') # Empty line
        
        # 2. Config Block (Skill)
        if meta["skill"]:
            skill_name = meta["skill"] # Keep snake_case for Gemini CLI
            lines.append('[config.skill]')
            lines.append(f'name = "{skill_name}"')
            lines.append(f'path = "skills/{skill_name}"') # Relative path in .gemini
            lines.append('') # Empty line

        # 3. Prompt
        # Escape triple quotes in content to avoid TOML syntax errors
        # Sử dụng body (nội dung đã bỏ frontmatter) thay vì content gốc
        safe_content = body.replace('"""', '\"\"\"')
        
        lines.append('prompt = """')
        lines.append(safe_content)
        lines.append('"""')
        
        toml_content = "\n".join(lines)
        # --- TOML GENERATION END ---
        
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