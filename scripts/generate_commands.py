import os
import glob
import sys

# 1. Xác định các đường dẫn gốc dựa trên vị trí của script
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
WORKFLOW_ROOT = os.path.dirname(CURRENT_DIR)
CORE_WORKFLOW_DIR = os.path.join(WORKFLOW_ROOT, "core", "workflows")
STACKS_DIR = os.path.join(WORKFLOW_ROOT, "stacks")
COMMAND_DIR = ".gemini/commands"

# Parse stack argument
STACK = "generic"
for arg in sys.argv[1:]:
    if arg.startswith("--stack="):
        STACK = arg.split("=")[1]

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

    print(f"🔄 Converting workflows from core + stack ({STACK})...")
    
    # Collect all workflow paths
    workflow_paths = []
    
    # 1. Core workflows (always included)
    if os.path.exists(CORE_WORKFLOW_DIR):
        for md_path in glob.glob(f"{CORE_WORKFLOW_DIR}/**/*.md", recursive=True):
            parent_folder = os.path.basename(os.path.dirname(md_path))
            if not parent_folder.startswith("_"):
                workflow_paths.append(md_path)
    
    # 2. Stack-specific workflows (if stack is not generic)
    if STACK != "generic":
        stack_workflow_dir = os.path.join(STACKS_DIR, STACK, "workflows")
        if os.path.exists(stack_workflow_dir):
            for md_path in glob.glob(f"{stack_workflow_dir}/**/*.md", recursive=True):
                parent_folder = os.path.basename(os.path.dirname(md_path))
                if not parent_folder.startswith("_"):
                    workflow_paths.append(md_path)
    
    count = 0
    for md_path in workflow_paths:
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
        
        safe_content = body.replace('"""', '\\"\\"\\"')
        lines.append('prompt = """')
        lines.append(safe_content)
        lines.append('"""')
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write("\n".join(lines))
            
        print(f"   ✅ Generated: {cmd_name}")
        count += 1

    print(f"🎉 Done! Converted {count} commands (Core + {STACK}).")

if __name__ == "__main__":
    if not os.path.exists(CORE_WORKFLOW_DIR):
        print(f"❌ Error: Cannot find core workflows directory at {CORE_WORKFLOW_DIR}")
    else:
        convert_md_to_toml()