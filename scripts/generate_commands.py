import os
import glob
import sys

# 1. Base Paths
CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(CURRENT_DIR)
WORKFLOW_ROOT = os.path.join(PROJECT_ROOT, "workflows")
COMMAND_DIR = ".gemini/commands"

def parse_frontmatter(content):
    """Extract description from YAML frontmatter."""
    meta = {
        "description": "AI Workflow Command"
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
        except Exception:
            pass
            
    return meta, body

def convert_md_to_toml():
    if not os.path.exists(COMMAND_DIR):
        os.makedirs(COMMAND_DIR)

    print(f"🔄 Converting workflows from {WORKFLOW_ROOT}...")
    
    # Scan all markdown files in workflows/ recursively
    workflow_files = glob.glob(f"{WORKFLOW_ROOT}/**/*.md", recursive=True)
    
    count = 0
    for md_path in workflow_files:
        filename = os.path.basename(md_path)
        # Skip zip or hidden files
        if filename.startswith("_") or not filename.endswith(".md"):
            continue
            
        cmd_name = filename.replace(".md", ".toml")
        output_path = os.path.join(COMMAND_DIR, cmd_name)
        
        try:
            with open(md_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            meta, body = parse_frontmatter(content)
            
            lines = [
                f'description = "{meta["description"]}"',
                ''
            ]
            
            # Escape triple quotes just in case
            safe_content = body.replace('"""', '\"\"\"')
            lines.append('prompt = """')
            lines.append(safe_content)
            lines.append('"""')
            
            with open(output_path, 'w', encoding='utf-8') as f:
                f.write("\n".join(lines))
                
            print(f"   ✅ Generated: {cmd_name}")
            count += 1
        except Exception as e:
            print(f"   ❌ Failed to process {filename}: {e}")

    print(f"🎉 Done! Converted {count} commands.")

if __name__ == "__main__":
    if not os.path.exists(WORKFLOW_ROOT):
        print(f"❌ Error: Cannot find workflows directory at {WORKFLOW_ROOT}")
    else:
        convert_md_to_toml()
