import os
import re

# Mapping Workflow -> Skill
MAPPING = {
    "workflows/core/investigate.md": "bug-investigator",
    "workflows/core/fix.md": "bug-investigator",
    "workflows/core/review.md": "code-reviewer",
    "workflows/core/audit.md": "tech-lead",
    "workflows/core/refactor.md": "code-reviewer",
    "workflows/core/start-task.md": "feature-architect",
    "workflows/tech/write-test.md": "test-engineer",
    "workflows/tech/integrate-api.md": "feature-architect",
    "workflows/tech/manage-db.md": "flutter-expert",
    "workflows/ops/setup.md": "tech-lead",
    "workflows/ops/doctor.md": "tech-lead",
}

def update_frontmatter(file_path, skill_name):
    if not os.path.exists(file_path):
        print(f"⚠️  File not found: {file_path}")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex để tìm Frontmatter block
    # Tìm --- ở đầu file, theo sau là nội dung, kết thúc bằng ---
    pattern = r'^---\n(.*?)\n---'
    match = re.search(pattern, content, re.DOTALL)

    if match:
        header_content = match.group(1)
        # Kiểm tra xem đã có skill chưa
        if "skill:" in header_content:
            # Update existing skill (nếu cần) - ở đây ta giả sử chưa có hoặc update đè
            new_header = re.sub(r'skill:.*', f'skill: {skill_name}', header_content)
        else:
            # Append skill vào cuối header
            new_header = header_content.strip() + f"\nskill: {skill_name}"
        
        # Reconstruct content
        new_content = content.replace(f"---\n{header_content}\n---", f"---\n{new_header}\n---", 1)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"✅ Updated {file_path} with skill: {skill_name}")
    else:
        # Nếu chưa có frontmatter, tạo mới (ít gặp nhưng đề phòng)
        print(f"⚠️  No frontmatter found in {file_path}, skipping auto-insert to be safe.")

if __name__ == "__main__":
    print("🚀 Batch Updating Workflow Metadata...")
    for path, skill in MAPPING.items():
        update_frontmatter(path, skill)
    print("🎉 Done.")