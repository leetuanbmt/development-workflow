import os
import shutil

SKILLS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "skills")

def rename_folders_to_kebab():
    print("🔄 Renaming skill folders to kebab-case...")
    
    if not os.path.exists(SKILLS_DIR):
        print(f"❌ Directory not found: {SKILLS_DIR}")
        return

    for item in os.listdir(SKILLS_DIR):
        old_path = os.path.join(SKILLS_DIR, item)
        
        if os.path.isdir(old_path) and "_" in item:
            new_name = item.replace("_", "-")
            new_path = os.path.join(SKILLS_DIR, new_name)
            
            # Rename
            print(f"   Move: {item} -> {new_name}")
            os.rename(old_path, new_path)

if __name__ == "__main__":
    rename_folders_to_kebab()
