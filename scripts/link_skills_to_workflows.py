import os
import re

WORKFLOW_DIR = "development-workflow/workflows"

# Mapping: Tên Workflow (kebab-case file name) -> List Skills (kebab-case)
WORKFLOW_SKILL_MAP = {
    "audit-architecture.md": ["tech-lead"],
    "audit-security.md": ["security-auditor"],
    "design-feature.md": ["feature-architect"],
    "doc-code.md": ["technical-writer"],
    "doc-feature.md": ["product-manager"],
    "implement-feature.md": ["flutter-expert"],
    "integrate-api.md": ["api-integrator"],
    "investigate.md": ["bug-investigator"],
    "manage-db.md": ["flutter-expert"], # Drift logic thường dính đến Flutter Expert hoặc Backend
    "manage-i18n.md": ["localization-expert"],
    "prepare-release.md": ["devops-engineer"],
    "review-code.md": ["code-reviewer"],
    "review-pr.md": ["code-reviewer", "qa-lead"], # Multi-skill
    "review-ui.md": ["ui-ux-designer"],
    "write-test.md": ["test-engineer"],
    "write-adr.md": ["tech-lead"],
    "write-spec.md": ["product-manager"]
}

def link_skills():
    print("🔗 Linking Skills to Workflows (Frontmatter Injection)...")
    
    if not os.path.exists(WORKFLOW_DIR):
        print(f"❌ Directory not found: {WORKFLOW_DIR}")
        return

    count = 0
    for filename, skills in WORKFLOW_SKILL_MAP.items():
        file_path = os.path.join(WORKFLOW_DIR, filename)
        
        if os.path.exists(file_path):
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check if 'skills:' already exists
            if "skills:" in content.split("---", 2)[1]:
                print(f"   ⏭️  Skipping {filename}: 'skills' already defined.")
                continue

            # Inject 'skills' into Frontmatter
            # Tìm vị trí kết thúc của Frontmatter (dấu --- thứ 2)
            parts = content.split("---", 2)
            if len(parts) >= 3:
                frontmatter = parts[1]
                body = parts[2]
                
                # Build yaml list string
                skill_yaml = "\nskills:"
                for skill in skills:
                    skill_yaml += f"\n  - {skill}"
                
                # Append to frontmatter
                new_frontmatter = frontmatter.rstrip() + skill_yaml + "\n"
                
                new_content = "---" + new_frontmatter + "---" + body
                
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                
                print(f"   ✅ Linked {filename} -> {skills}")
                count += 1
            else:
                print(f"   ⚠️  Warning: {filename} has invalid frontmatter.")
        else:
             print(f"   ⚠️  Warning: Workflow {filename} not found.")

    print(f"🎉 Done! Updated {count} workflows.")

if __name__ == "__main__":
    link_skills()
