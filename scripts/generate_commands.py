import os
import glob

# 1. Xác định các đường dẫn gốc dựa trên vị trí của script
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKFLOW_ROOT = os.path.dirname(CURRENT_DIR)
WORKFLOW_DIR = os.path.join(WORKFLOW_ROOT, "workflows")
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
                body = parts[2].strip()
                
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
    # Đảm bảo thư mục output tồn tại (từ Project Root)
    if not os.path.exists(COMMAND_DIR):
        os.makedirs(COMMAND_DIR)

    print(f"🔄 Converting workflows from {WORKFLOW_DIR}...")
    
    count = 0
    # Sử dụng recursive=True để quét tất cả thư mục con
    for md_path in glob.glob(f"{WORKFLOW_DIR}/**/*.md", recursive=True):
        if os.path.basename(os.path.dirname(md_path)) == "legacy":
             continue # Bỏ qua thư mục legacy nếu cần, hoặc giữ lại tùy ý. Ở đây ta cứ gen hết.

        filename = os.path.basename(md_path)
        cmd_name = filename.replace(".md", ".toml")
        output_path = os.path.join(COMMAND_DIR, cmd_name)
        
        with open(md_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        meta, body = parse_frontmatter(content)
        
        lines = [
            f'description = "{meta["description"]}"',
            ''
        ]
        
        if meta["skill"]:
            skill_name = meta["skill"]
            lines.append('[config.skill]')
            lines.append(f'name = "{skill_name}"')
            lines.append(f'path = "skills/{skill_name}"')
            lines.append('')

        safe_content = body.replace('"""', '\"\"\"')
        lines.append('prompt = """')
        lines.append(safe_content)
        lines.append('"""')
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write("\n".join(lines))
            
        print(f"   ✅ Generated: {cmd_name}")
        count += 1

    print(f"🎉 Done! Converted {count} commands.")

if __name__ == "__main__":
    if not os.path.exists(WORKFLOW_DIR):
        print(f"❌ Error: Cannot find workflows directory at {WORKFLOW_DIR}")
    else:
        convert_md_to_toml()