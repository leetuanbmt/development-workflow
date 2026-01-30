# 📋 Migration Guide: v3.x → v4.0.0

## Overview

Version 4.0.0 refactors the framework into **core** (tech-agnostic) + **stacks** (tech-specific) architecture for better multi-project reusability.

## What Changed

### Directory Structure

**Before (v3.x):**
```
development-workflow/
├── rules/          # Mixed: generic + Flutter-specific
├── workflows/      # All workflows
└── skills/         # Mixed: generic + Flutter-specific
```

**After (v4.0.0):**
```
development-workflow/
├── core/
│   ├── rules/      # Tech-agnostic only
│   ├── workflows/  # Universal workflows
│   └── skills/     # Generic skills
├── stacks/
│   └── flutter/
│       ├── rules/  # Flutter-specific
│       └── skills/ # Flutter-specific
└── templates/      # Project templates
```

### File Mapping

| Old Location | New Location | Type |
|:---|:---|:---|
| `rules/00-core-behavior.md` | `core/rules/00-core-behavior.md` | Core |
| `rules/02-architecture-rules.md` | `stacks/flutter/rules/02-architecture-rules.md` | Stack |
| `rules/03-07-*.md` | `core/rules/03-07-*.md` | Core |
| `workflows/*` | `core/workflows/*` | Core |
| `skills/flutter-expert/` | `stacks/flutter/skills/flutter-expert/` | Stack |
| `skills/feature-architect/` | `stacks/flutter/skills/feature-architect/` | Stack |
| Other skills | `core/skills/*` | Core |

## Migration Steps

### For Existing Projects Using This Framework

#### 1. Backup Current Config
```bash
cd your-project/
cp -r .gemini .gemini.backup
cp -r .agent .agent.backup
```

#### 2. Update Submodule (if using Git submodule)
```bash
cd development-workflow/
git fetch origin
git checkout main
git pull origin main
cd ..
```

#### 3. Re-sync
```bash
# Auto-detect stack
./development-workflow/scripts/sync.sh

# Or specify stack
./development-workflow/scripts/sync.sh --stack=flutter
```

#### 4. Verify
```bash
# Check structure
ls -la .gemini/rules/
ls -la .gemini/skills/

# Test a workflow
# In Gemini CLI:
/doctor
```

#### 5. Clean Up Backup (if everything works)
```bash
rm -rf .gemini.backup .agent.backup
```

### For Framework Maintainers

#### 1. Update Custom Rules

If you have custom rules in `rules/`:

**Before:**
```bash
rules/
├── 00-core-behavior.md
├── 01-project-context.md
├── 02-architecture-rules.md  # Custom Flutter rules
└── 99-custom-rule.md          # Your custom rule
```

**After:**
```bash
# Move generic custom rules
mv rules/99-custom-rule.md core/rules/

# Move stack-specific rules
mv rules/02-architecture-rules.md stacks/flutter/rules/

# Update 01-project-context.md to use template
cp templates/01-project-context.template.md rules/01-project-context.md
# Then customize for your project
```

#### 2. Update Custom Skills

If you have custom skills:

```bash
# Determine if skill is tech-specific or generic
# Generic → core/skills/
# Flutter-specific → stacks/flutter/skills/
# Node-specific → stacks/nodejs/skills/ (create if needed)

# Example:
mv skills/my-custom-skill core/skills/
```

#### 3. Update Custom Workflows

```bash
# All workflows go to core (unless stack-specific)
mv workflows/my-custom-workflow.md core/workflows/ops/
```

## Breaking Changes

### 1. Sync Script Arguments

**Before:**
```bash
./scripts/sync.sh
./scripts/sync.sh gemini
./scripts/sync.sh antigravity
```

**After:**
```bash
./scripts/sync.sh                    # Auto-detect stack
./scripts/sync.sh --stack=flutter    # Explicit stack
./scripts/sync.sh gemini             # Still works
./scripts/sync.sh --watch            # Still works
```

### 2. generate_commands.py

**Before:**
```python
python3 scripts/generate_commands.py
```

**After:**
```python
python3 scripts/generate_commands.py --stack=flutter
```

### 3. Symlink Paths

If you have custom scripts that reference workflow paths:

**Before:**
```bash
WORKFLOW_DIR="development-workflow/workflows"
```

**After:**
```bash
CORE_WORKFLOW_DIR="development-workflow/core/workflows"
STACK_WORKFLOW_DIR="development-workflow/stacks/flutter/workflows"
```

## New Features in v4.0.0

### 1. Stack Auto-Detection

```bash
# Detects Flutter if pubspec.yaml exists
# Detects Node.js if package.json exists
# Detects Python if requirements.txt exists
./scripts/sync.sh
```

### 2. Template System

```bash
# Use templates for new projects
cp templates/01-project-context.template.md your-project/.agent/memory/PROJECT.md
cp templates/GEMINI.template.md your-project/GEMINI.md
```

### 3. Multi-Stack Support

```bash
# Same framework, different stacks
cd flutter-app/
./development-workflow/scripts/sync.sh --stack=flutter

cd nodejs-api/
./development-workflow/scripts/sync.sh --stack=nodejs
```

## Troubleshooting

### Issue: Symlinks broken after update

**Solution:**
```bash
rm -rf .gemini
./development-workflow/scripts/sync.sh
```

### Issue: Missing skills after migration

**Solution:**
Check if skill was moved to stack-specific folder:
```bash
ls development-workflow/stacks/flutter/skills/
```

If needed, re-sync with correct stack:
```bash
./development-workflow/scripts/sync.sh --stack=flutter
```

### Issue: Workflows not showing in Gemini CLI

**Solution:**
Regenerate commands:
```bash
python3 development-workflow/scripts/generate_commands.py --stack=flutter
```

### Issue: Old rules still appearing

**Solution:**
```bash
# Clean and re-sync
rm -rf .gemini .agent
./development-workflow/scripts/sync.sh
```

## Rollback to v3.x

If you need to rollback:

```bash
cd development-workflow/
git checkout release/v3.0.0
cd ..
rm -rf .gemini .agent
./development-workflow/scripts/sync.sh
```

## Support

- Check [README.md](README.md) for updated documentation
- Review [CHANGELOG.md](CHANGELOG.md) for detailed changes
- Open an issue if you encounter problems

---

**Migration completed?** Run `/doctor` to verify your setup!
