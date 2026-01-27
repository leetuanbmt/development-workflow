import os
import re

SKILLS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "skills")

def fix_yaml_name():
    print("🔧 Fixing YAML 'name' in SKILL.md to kebab-case...")
    
    for skill_name in os.listdir(SKILLS_DIR):
        skill_path = os.path.join(SKILLS_DIR, skill_name)
        skill_md_path = os.path.join(skill_path, "SKILL.md")
        
        if os.path.exists(skill_md_path):
            with open(skill_md_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Regex tìm dòng "name: value" trong frontmatter
            # Group 1: key, Group 2: value
            pattern = r"^(name:\s*)(.+)$"
            
            def replace_kebab(match):
                prefix = match.group(1)
                old_name = match.group(2).strip()
                new_name = old_name.replace("_", "-")
                if old_name != new_name:
                    print(f"   Update {skill_name}: {old_name} -> {new_name}")
                return f"{prefix}{new_name}"
            
            # Chỉ replace trong 10 dòng đầu (Frontmatter)
            lines = content.split('\n')
            new_lines = []
            in_frontmatter = False
            
            for i, line in enumerate(lines):
                if line.strip() == "---":
                    in_frontmatter = not in_frontmatter
                
                if in_frontmatter and line.startswith("name:"):
                    new_line = re.sub(pattern, replace_kebab, line, flags=re.MULTILINE)
                    new_lines.append(new_line)
                else:
                    new_lines.append(line)
            
            new_content = "\n".join(new_lines)
            
            with open(skill_md_path, 'w', encoding='utf-8') as f:
                f.write(new_content)

if __name__ == "__main__":
    fix_yaml_name()
