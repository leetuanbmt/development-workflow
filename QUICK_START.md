# 🚀 Quick Reference: v5.0.0 Multi-Project Framework

## 📦 Installation

### Option 1: Git Submodule (Recommended)
```bash
cd your-project/
git submodule add https://github.com/your-org/development-workflow.git
./development-workflow/init-submodule.sh
```

### Option 2: Symlink (Local Dev)
```bash
cd your-project/
ln -s /path/to/development-workflow ./development-workflow
./development-workflow/scripts/sync.sh
```

---

## ⚡ Quick Commands

### Sync Framework
```bash
# Auto-detect stack
./development-workflow/scripts/sync.sh

# Specify stack
./development-workflow/scripts/sync.sh --stack=flutter
./development-workflow/scripts/sync.sh --stack=nodejs
./development-workflow/scripts/sync.sh --stack=python

# Watch mode (auto-sync on changes)
./development-workflow/scripts/sync.sh --watch
```

### Initialize Project
```bash
# In Gemini CLI or Antigravity
/setup
```

### Health Check
```bash
/doctor
```

### Security Tools Setup (Recommended)
```bash
# Install git-secrets
brew install git-secrets  # macOS
# OR
apt-get install git-secrets  # Linux

# Install trufflehog
brew install trufflehog  # macOS
# OR
pip install trufflehog  # Cross-platform

# Setup pre-commit hook (optional but recommended)
cp development-workflow/templates/hooks/pre-commit.template .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

---

## 📁 Directory Structure

```
development-workflow/
├── core/                    # Tech-agnostic
│   ├── rules/              # 6 universal rules
│   ├── workflows/          # 13 workflows
│   └── skills/             # 6 generic skills
├── stacks/                 # Tech-specific
│   └── flutter/
│       ├── rules/          # Flutter architecture
│       └── skills/         # flutter-expert, feature-architect
└── templates/              # Project templates
```

---

## 🎯 Core Workflows (13)

### Daily Loop (6)
| Command | Purpose |
|:---|:---|
| `/start-task` | Analyze & plan |
| `/investigate` | Root cause analysis (report only) |
| `/fix` | Full bug fix flow |
| `/review` | Code/PR/changes review |
| `/audit` | Multi-aspect audit |
| `/refactor` | Safe refactoring |

### Technical (3)
| Command | Purpose |
|:---|:---|
| `/manage-db` | Database schema & migrations |
| `/integrate-api` | Auto-generate data layer |
| `/write-test` | Test generation |

### Operations (4)
| Command | Purpose |
|:---|:---|
| `/setup` | Initialize project context |
| `/doctor` | Environment health check |
| `/deploy` | Build & deploy |
| `/document` | Generate documentation |

---

## 🧠 Core Skills (6)

| Skill | Trigger Keywords |
|:---|:---|
| `bug-investigator` | bug, lỗi, crash, error |
| `code-reviewer` | review, check, PR |
| `tech-lead` | (manual) |
| `test-engineer` | test, coverage, mock |
| `security-auditor` | security, token, secret |
| `vibecoder` | vibe, fast, implement |

---

## 📦 Stack Support

| Stack | Status | Features |
|:---|:---:|:---|
| **Flutter** | ✅ | Clean Arch, BLoC, flutter-expert |
| **Node.js** | 🚧 | Planned |
| **Python** | 🚧 | Planned |
| **Generic** | ✅ | Core only |

---

## 🔄 Migration from v3.x/v4.x

```bash
# 1. Backup
cp -r .gemini .gemini.backup
cp -r .agent .agent.backup

# 2. Update submodule
cd development-workflow/
git pull origin main

# 3. Re-sync
cd ..
./development-workflow/scripts/sync.sh

# 4. Verify
/doctor

# 5. Clean up (if OK)
rm -rf .gemini.backup .agent.backup
```

See [MIGRATION.md](MIGRATION.md) for details.

---

## 🎨 Auditor-First Workflow

```
USER (Auditor)          AI (Lead Engineer)
      │                        │
      ├─ Define Intent ───────▶│
      │                        ├─ Propose Plan
      │◀─ Review Plan ─────────┤
      │                        │
      ├─ Approve ─────────────▶│
      │                        ├─ Execute Code
      │                        ├─ Self-Verify
      │◀─ Report Status ───────┤
      │                        │
      ├─ Final Sign-off ──────▶│
      └────────────────────────┘
```

---

## 🛠️ Troubleshooting

### Symlinks broken
```bash
rm -rf .gemini
./development-workflow/scripts/sync.sh
```

### Missing skills
```bash
# Check stack
ls development-workflow/stacks/flutter/skills/

# Re-sync with correct stack
./development-workflow/scripts/sync.sh --stack=flutter
```

### Workflows not showing
```bash
python3 development-workflow/scripts/generate_commands.py --stack=flutter
```

---

## 📚 Key Files

| File | Purpose |
|:---|:---|
| `README.md` | Full documentation |
| `MIGRATION.md` | Upgrade guide |
| `CHANGELOG.md` | Version history |
| `REFACTORING_SUMMARY.md` | v5.0.0 details |
| `CHEAT_SHEET.md` | Command reference |

---

## 💡 Pro Tips

1. **Use watch mode** during development:
   ```bash
   ./development-workflow/scripts/sync.sh --watch
   ```

2. **Custom stacks**: Create your own in `stacks/mystack/`

3. **Templates**: Customize templates in `templates/` for your org

4. **Auto-detection**: Let sync.sh detect your stack automatically

5. **Multiple projects**: Same framework, different stacks!

---

## 🔗 Quick Links

- [Full README](README.md)
- [Migration Guide](MIGRATION.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)

---

**Version:** 5.0.0  
**Updated:** 2026-01-30  
**Status:** ✅ Production Ready
