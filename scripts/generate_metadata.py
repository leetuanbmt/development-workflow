import os
import re
import json
import sys

# Default path if not provided
DEFAULT_SKILLS_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "core/skills")
# Support CLI argument for custom path
SKILLS_DIR = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_SKILLS_DIR

def parse_frontmatter(content):
    """
    Parses YAML-like frontmatter manually without external dependencies.
    Supports: key-value, lists of dictionaries.
    """
    metadata = {}
    
    # Extract content between first set of ---
    match = re.search(r"^---\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return None
        
    yaml_text = match.group(1)
    
    # Simple state machine for parsing
    current_list_key = None
    current_list_item = None
    
    lines = yaml_text.split('\n')
    for line in lines:
        line = line.rstrip()
        if not line or line.strip().startswith('#'): 
            continue
            
        # Detect Key-Value (e.g., name: "value")
        # Regex uses single quotes for raw string to handle double quotes inside easily
        kv_match = re.match(r'^([a-zA-Z0-9_-]+):\s*["\"]?(.*?)["\"]?$', line)
        
        # Ensure it's not indented (top-level key)
        if kv_match and not line.startswith(' '):
            key, value = kv_match.groups()
            
            # If value implies a list start (empty or comment), switch mode
            if not value.strip():
                current_list_key = key
                metadata[key] = []
            else:
                metadata[key] = value
                current_list_key = None # Reset list mode
            continue
            
        # Detect List Item (e.g., - name: "value")
        if current_list_key and line.strip().startswith('- '):
            # Start of a new object in the list
            # Extract first key-value pair
            item_match = re.match(r'^\s*-\s+([a-zA-Z0-9_-]+):\s*["\"]?(.*?)["\"]?$', line)
            if item_match:
                k, v = item_match.groups()
                current_list_item = {k: v}
                metadata[current_list_key].append(current_list_item)
            continue
            
        # Detect List Item Property (e.g.,   type: "text")
        if current_list_key and current_list_item is not None and line.strip() and not line.strip().startswith('-'):
            prop_match = re.match(r'^\s+([a-zA-Z0-9_-]+):\s*["\"]?(.*?)["\"]?$', line)
            if prop_match:
                k, v = prop_match.groups()
                current_list_item[k] = v
                
    return metadata

def generate_metadata():
    if not os.path.exists(SKILLS_DIR):
        print(f"❌ Directory not found: {SKILLS_DIR}")
        return

    print(f"🛠  Generating metadata.json from Markdown in {SKILLS_DIR}...")
    
    count = 0
    updated = 0
    skipped = 0
    
    for skill_name in os.listdir(SKILLS_DIR):
        skill_path = os.path.join(SKILLS_DIR, skill_name)
        
        # Skip hidden files or non-directories
        if not os.path.isdir(skill_path) or skill_name.startswith('.'):
            continue
            
        skill_file = os.path.join(skill_path, "SKILL.md")
        if not os.path.exists(skill_file):
            print(f"   ⚠️  Skipping {skill_name}: No SKILL.md found")
            skipped += 1
            continue
            
        # Read and Parse
        try:
            with open(skill_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            frontmatter = parse_frontmatter(content)
            
            if not frontmatter:
                print(f"   ⚠️  Skipping {skill_name}: Invalid or missing Frontmatter")
                skipped += 1
                continue
                
            # Construct standard metadata structure
            metadata_content = {
                "name": frontmatter.get("name", skill_name),
                "version": frontmatter.get("version", "1.0.0"),
                "description": frontmatter.get("description", "No description provided"),
                "inputs": frontmatter.get("inputs", []),
                "outputs": frontmatter.get("outputs", []),
                "is_active": True
            }
            
            # Write metadata.json
            output_file = os.path.join(skill_path, "metadata.json")
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(metadata_content, f, indent=2, ensure_ascii=False)
                
            print(f"   ✅ {skill_name}: Metadata updated from Source.")
            updated += 1
            
        except Exception as e:
            print(f"   ❌ Error processing {skill_name}: {str(e)}")
            import traceback
            traceback.print_exc()
            
    print(f"\n🎉 Completed! Updated: {updated}, Skipped: {skipped}")

if __name__ == "__main__":
    generate_metadata()