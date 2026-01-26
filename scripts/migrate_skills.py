import os
import json
import re

# Đường dẫn gốc
SKILLS_DIR = "development-workflow/skills"

def migrate_skills():
    print("🚀 Starting Skill Migration (Metadata -> SKILL.md)...")
    
    count = 0
    if not os.path.exists(SKILLS_DIR):
        print(f"❌ Directory not found: {SKILLS_DIR}")
        return

    for skill_name in os.listdir(SKILLS_DIR):
        skill_path = os.path.join(SKILLS_DIR, skill_name)
        metadata_path = os.path.join(skill_path, "metadata.json")
        skill_md_path = os.path.join(skill_path, "SKILL.md")
        
        # Chỉ xử lý nếu có metadata.json và SKILL.md
        if os.path.exists(metadata_path) and os.path.exists(skill_md_path):
            print(f"   🔧 Processing: {skill_name}...")
            
            # 1. Đọc Metadata
            with open(metadata_path, 'r', encoding='utf-8') as f:
                metadata = json.load(f)
            
            # 2. Đọc SKILL.md
            with open(skill_md_path, 'r', encoding='utf-8') as f:
                md_content = f.read()
            
            # 3. Tạo nội dung Interface Definition (Markdown)
            interface_section = "\n\n## 🔌 Interface Definition\n\n"
            
            # Inputs
            if metadata.get("inputs"):
                interface_section += "### Inputs\n"
                for inp in metadata["inputs"]:
                    interface_section += f"- **{inp['name']}** ({inp['type']}): {inp['desc']}\n"
                interface_section += "\n"
            
            # Outputs
            if metadata.get("outputs"):
                interface_section += "### Outputs\n"
                for out in metadata["outputs"]:
                    interface_section += f"- **{out['name']}** ({out['type']}): {out['desc']}\n"
            
            # 4. Append vào SKILL.md (Nếu chưa có)
            if "## 🔌 Interface Definition" not in md_content:
                new_md_content = md_content.strip() + interface_section
                
                with open(skill_md_path, 'w', encoding='utf-8') as f:
                    f.write(new_md_content)
                print(f"      ✅ Updated SKILL.md with Interface Definition.")
            else:
                print(f"      ℹ️  Interface Definition already exists in SKILL.md.")

            # 5. Xóa metadata.json
            os.remove(metadata_path)
            print(f"      🗑  Removed metadata.json")
            
            count += 1
            
    print(f"🎉 Migration Complete! Updated {count} skills.")

if __name__ == "__main__":
    migrate_skills()
