# 🚀 Multi-Project Development Workflow Framework

## Overview

Framework này được thiết kế để tái sử dụng cho nhiều dự án khác nhau, hỗ trợ cả **Gemini CLI** và **Google Antigravity**.

## Architecture

```
development-workflow/
├── core/                    # Tech-agnostic components
│   ├── rules/              # Universal rules (6 files)
│   ├── workflows/          # Universal workflows (13 workflows)
│   └── skills/             # Generic skills (6 skills)
├── stacks/                 # Tech-specific components
│   └── flutter/
│       ├── rules/          # Flutter architecture rules
│       └── skills/         # Flutter-specific skills
├── templates/              # Project templates
│   ├── 01-project-context.template.md
│   └── GEMINI.template.md
└── scripts/                # Automation tools
```

## 🚀 Usage Scenarios

### Scenario A: Existing Project (Brownfield)
*You have an active codebase (Flutter, Node, etc.) and want to add AI agents.*

**1. Add Framework**
```bash
git submodule add https://github.com/your-org/development-workflow.git
./development-workflow/init-submodule.sh
```

**2. Auto-Detect Stack**
```bash
./development-workflow/scripts/sync.sh
# System scans pubspec.yaml/package.json to configure AI skills
```

**3. Initialize Context**
```bash
/setup
# AI analyzes your specific architecture (BLoC/GetX/NestJS...) and generates tailored rules.
```

### Scenario B: New Project (Greenfield)
*You are starting from scratch and want AI to guide the setup.*

**1. Prepare Directory**
```bash
mkdir my-new-project && cd my-new-project
git init
git submodule add https://github.com/your-org/development-workflow.git
./development-workflow/init-submodule.sh
```

**2. Consult Tech Lead**
```bash
/setup
```
*   **AI:** "What system do you want to build?"
*   **You:** "A real-time chat app for iOS/Android."
*   **AI:** "Recommended Stack: Flutter + Firebase + Riverpod. Proceed?"

**3. Initialize & Create**
```bash
# After AI suggests the stack:
./development-workflow/scripts/sync.sh --stack=flutter
flutter create .
```

This will:
- Scan your project structure
- Detect tech stack
- Generate `PROJECT.md` with your project context
- Apply appropriate architecture rules

## Supported Stacks

| Stack | Status | Features |
|:---|:---:|:---|
| **Flutter** | ✅ Full | Clean Architecture, BLoC, Drift, flutter-expert skill |
| **Node.js** | 🚧 Planned | Express/NestJS patterns, backend-expert skill |
| **Python** | 🚧 Planned | FastAPI/Django patterns, python-expert skill |
| **Generic** | ✅ Core | Universal workflows & skills only |

## Core Workflows (13)

### Daily Loop (6)
- `/start-task` - Analyze requirements and create implementation plan
- `/investigate` - Root cause analysis (report only, no code changes)
- `/fix` - Full bug fix flow (investigate → plan → fix → verify)
- `/review` - Unified code/PR/changes review
- `/audit` - Multi-aspect audit (architecture/security/analytics)
- `/refactor` - Safe refactoring without breaking functionality

### Technical Services (3)
- `/manage-db` - Database schema & migration management
- `/integrate-api` - Auto-generate data layer from JSON specs
- `/write-test` - Unit/Widget/Integration test generation

### Operations (4)
- `/setup` - Auto-discovery & project context initialization
- `/doctor` - Environment health check
- `/deploy` - Build and deploy application
- `/document` - Generate living documentation

## Core Skills (6)

| Skill | Focus |
|:---|:---|
| `bug-investigator` | Root cause analysis, debugging |
| `code-reviewer` | Code quality, architecture compliance |
| `tech-lead` | Architecture decisions, mentoring |
| `test-engineer` | Testing strategy, coverage |
| `security-auditor` | Vulnerabilities, secrets scan |
| `vibecoder` | High-speed implementation (500-2000 lines) |

## Stack-Specific: Flutter

### Additional Skills
- `flutter-expert` - Performance, memory, jank fixes
- `feature-architect` - Feature design with Clean Architecture

### Additional Rules
- Clean Architecture (Data/Domain/Presentation)
- BLoC pattern enforcement
- Code generation workflow
- Drift database patterns

## Auditor-First Philosophy

```
┌─────────────────────────────────────────┐
│  USER (Auditor/Architect)               │
│  • Define Intent & Constraints          │
│  • Review & Approve Plans               │
│  • Final Sign-off                       │
└──────────────┬──────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────┐
│  AI (Lead Engineer)                     │
│  • Propose Solutions                    │
│  • Execute Code                         │
│  • Self-Verify                          │
│  • Report Status                        │
└─────────────────────────────────────────┘
```

## Advanced Usage

### Watch Mode (Auto-sync on changes)
```bash
./development-workflow/scripts/sync.sh --watch
```

### Multiple Projects
```bash
# Project A (Flutter)
cd project-a/
./development-workflow/scripts/sync.sh --stack=flutter

# Project B (Node.js)
cd project-b/
./development-workflow/scripts/sync.sh --stack=nodejs
```

### Custom Stack

Create your own stack:
```bash
mkdir -p development-workflow/stacks/mystack/{rules,skills,workflows}
# Add your custom rules/skills/workflows
./scripts/sync.sh --stack=mystack
```

## Migration from v3.x

If you're using the old structure:

```bash
# Backup current config
cp -r .gemini .gemini.backup
cp -r .agent .agent.backup

# Pull latest changes
cd development-workflow/
git pull origin main

# Re-sync with new structure
cd ..
./development-workflow/scripts/sync.sh
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Adding new stacks
- Creating custom skills
- Workflow development guidelines

## Version

**v4.0.0** - Multi-Project Refactor
- Core/Stacks separation
- Stack auto-detection
- Template system
- Improved reusability

---

*Powered by Gemini CLI & Google Antigravity*
