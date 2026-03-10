# 🔄 Framework Distribution & Multi-Project Setup Guide

**Purpose:** How to distribute the AI workflow framework across multiple projects and initialize it for each project.

---

## Quick Start Overview

For each new project:

1. **Copy** entire `.agent/` folder
2. **Run** `/init` workflow
3. **Start** developing with `/start-task`

**Time:** ~5-10 minutes per project

---

## Step-by-Step: Adding Framework to a New Project

### Option A: Existing Project (Already Has Code)

```bash
# 1. Go to your project root
cd /path/to/my-flutter-app

# 2. Copy the framework
cp -r /path/to/template/.agent .

# 3. Verify copy
ls -la .agent/
# Should show: docs/, lib/, memory/, rules/, skills/, workflows/

# 4. Initialize for your project
/init

# Follow the prompts to customize for your project
# Optional (recommended): apply per-project override
cp .agent/memory/config.override.example.json .agent/memory/config.override.json
vim .agent/memory/config.override.json  # adjust language/autoApproval/qualityGates
```

### Option B: Brand New Project

```bash
# 1. Create project directory
mkdir my-new-app && cd my-new-app

# 2. Copy framework
cp -r /path/to/template/.agent .

# 3. Initialize
/init
# AI: "What technology stack do you want?"
# You: "Flutter + Firebase"
# AI creates everything

# Optional (recommended): apply per-project override
cp .agent/memory/config.override.example.json .agent/memory/config.override.json
vim .agent/memory/config.override.json

# 4. Create actual project structure
flutter create .
# OR
npm init -y
# OR
mkdir src && python -m venv venv

# 5. Start development
/start-task
```

---

## What Happens During /init

The `/init` workflow does the following:

### Step 1: Information Gathering

```
AI Questions:
├─ Project name? → "kansuke-photo"
├─ Description? → "AI-powered photo management app"
├─ Technology stack? → "Flutter + Firebase + Drift"
├─ Architecture pattern? → "Clean Architecture + BLoC"
├─ Team size? → "3 developers"
├─ Production? → "Yes, iOS + Android"
└─ Any existing code? → "Yes, GitHub link"
```

### Step 2: Auto-Detection

```
System Scans:
├─ pubspec.yaml → Detects Flutter dependencies
├─ firebase.json → Detects Firebase config
├─ Existing /lib → Detects architecture pattern
├─ .git history → Understands development pace
└─ README.md → Gathers project context
```

### Step 3: Generate Project Files

**Creates:** `memory/PROJECT.md`

```markdown
# Kansuke-Photo Project Context

## Business Context

- Mobile app for photo management with AI features
- Launched on iOS & Android
- Team: 3 developers

## Technology Stack

- Frontend: Flutter 3.27.1
- Backend: Firebase
- Database: Drift (local)
- State Management: BLoC

## Architecture

- Pattern: Clean Architecture (Data/Domain/Presentation)
- Layers properly separated
- BLoC for state management
- Repository pattern for data access
```

**Creates:** `memory/ARCHITECTURE.md`

```markdown
# Kansuke-Photo Architecture

## Folder Structure
```

lib/
├── core/ # Shared utilities, themes, constants
├── data/ # Data layer (API, local DB, repositories)
├── domain/ # Domain layer (entities, use cases)
├── features/ # Feature-specific code
└── routes/ # Navigation

```

## Design Patterns
- Repository Pattern: Abstract data access
- BLoC Pattern: State management
- Dependency Injection: GetIt
- Singleton: Caching layer
```

**Creates:** `memory/CODE_STYLE.md`

```markdown
# Kansuke-Photo Code Style

## Dart/Flutter Conventions

- Use `final` by default
- Format with `dart format`
- Lint with `flutter analyze`
- Comments for complex logic

## Naming

- Classes: PascalCase
- Variables: camelCase
- Constants: lowerCamelCase
- Files: snake_case
```

**Creates:** `memory/TESTING_STRATEGY.md`

```markdown
# Testing Strategy

## Test Types

- Unit: Core business logic
- Widget: UI components
- Integration: Full features
- E2E: Critical user flows

## Coverage Target: 80%+
```

**Updates:** `rules/02-architecture-rules.md`

```markdown
# Architecture Rules for Kansuke-Photo

## Clean Architecture

- Keep layers separate
- No business logic in UI
- No UI references in domain

## BLoC Usage

- One BLoC per feature
- Bloc emits immutable states
- Use Equatable for equality
```

### Step 4: Customize Skills

Adjusts `skills/RESPONSIBILITY_MATRIX.md`:

```markdown
# Skill Assignments (Kansuke-Photo)

## available-skills:

- vibecoder: ✅ (High-speed Flutter implementation)
- flutter-expert: ✅ (Performance optimization)
- feature-architect: ✅ (Feature design)
- test-engineer: ✅ (Widget & unit tests)
- code-reviewer: ✅ (Code quality)

## skill-trigger-rules:

- /implement-feature → vibecoder (80%) + feature-architect (20%)
- /fix → bug-investigator (100%)
- /write-test → test-engineer (100%)
```

---

## Project-Specific Customization Options

After `/init` completes, you can customize further:

### Option 1: Adjust PROJECT.md

```bash
# Edit your project context
vim memory/PROJECT.md
# Update team info, product goals, etc.
```

### Option 2: Add Custom Rules

```bash
# Create project-specific rule
cat > rules/08-flutter-optimization.md << 'EOF'
# Flutter Performance Rules

- Use const constructors always
- Avoid rebuilds with Provider keys
- Profile memory in debug builds
EOF
```

### Option 3: Create Custom Skill

```bash
# See: docs/guides/SKILL_INTEGRATION.md
mkdir skills/my-custom-skill
cat > skills/my-custom-skill/SKILL.md << 'EOF'
# Custom Skill for Kansuke-Photo

...
EOF
```

---

## Scenario Examples

### Example 1: Adding Framework to Flutter App (In Progress)

```bash
# Project: kansuke-photo
# Status: Has 6 months of code
# Goal: Use AI for faster development

# Step 1: Copy
cd ~/projects/kansuke-photo
cp -r ~/templates/ai-framework/.agent .

# Step 2: Init
/init
# Responds to prompts with kansuke-photo info

# Generated files:
# ✅ memory/PROJECT.md
# ✅ memory/ARCHITECTURE.md (detects BLoC pattern)
# ✅ memory/CODE_STYLE.md
# ✅ memory/TESTING_STRATEGY.md (detects widget tests)
# ✅ rules/02-architecture-rules.md (customizes for Clean Arch)

# Step 3: Start
/start-task
# Prompt: "Implement photo editing with filters"
```

### Example 2: Adding Framework to Node.js Backend

```bash
# Project: backup-service
# Status: New project
# Goal: Use AI to bootstrap initial code

# Step 1: Create project
mkdir backup-service && cd backup-service
npm init -y

# Step 2: Copy framework
cp -r ~/templates/ai-framework/.agent .

# Step 3: Init
/init
# Prompts: Node.js + Express + PostgreSQL + Jest

# Generated:
# ✅ PROJECT.md → Node.js service context
# ✅ ARCHITECTURE.md → Express patterns
# ✅ CODE_STYLE.md → JavaScript conventions
# ✅ TESTING_STRATEGY.md → Jest setup

# Step 4: Generate boilerplate
/start-task     # Plan architecture
/implement-feature  # AI generates Express app
/write-test     # AI writes Jest tests
```

### Example 3: Adding Framework to Python Project

```bash
# Project: data-processor
# Status: Existing Python code
# Goal: Speed up feature development

# Step 1: Copy
cd ~/projects/data-processor
cp -r ~/templates/ai-framework/.agent .

# Step 2: Init
/init
# Detects Python, FastAPI, SQLAlchemy

# Step 3: Use
/start-task
```

---

## Framework File Organization

### What Gets Copied (Never Changes Per Project)

```
.agent/
├── docs/                    # Reference guides (universal)
├── lib/                     # Core algorithms (universal)
├── skills/                  # Skill definitions (universal)
├── workflows/               # Workflow definitions (universal)
├── rules/                   # Rule templates (universal)
└── README.md                # This guide
```

### What Gets Customized Per Project

```
.agent/
└── memory/                  # Project knowledge base (custom per project)
    ├── PROJECT.md           # Generated by /init
    ├── ARCHITECTURE.md      # Generated by /init
    ├── CODE_STYLE.md        # Generated by /init
    ├── TESTING_STRATEGY.md  # Generated by /init
    └── [your-custom-files]  # Your additions
```

---

## Troubleshooting

### Problem: /init hangs or takes too long

**Solution:**

```bash
# Check if it's analyzing a huge codebase
# Kill it and run with a limit
/init --skip-analysis-of-large-files
```

### Problem: Generated PROJECT.md is incomplete

**Solution:**

```bash
# Edit manually
vim memory/PROJECT.md

# Or re-run init
/init --force-regenerate
```

### Problem: Framework workflows don't match my stack

**Solution:**

1. Check `skills/RESPONSIBILITY_MATRIX.md`
2. Create custom skill (see [SKILL_INTEGRATION.md](./SKILL_INTEGRATION.md))
3. Add project-specific rules

---

## Best Practices

### ✅ DO:

- Keep `.agent/` folder in git (entire team benefits)
- Customize `memory/` files for your project
- Run `/init` once per project
- Document any custom rules you add
- Share improvements with other projects

### ❌ DON'T:

- Modify core `workflows/`, `skills/`, `rules/` files
- Delete `docs/` folder (needed for reference)
- Skip `/init` setup (loses customization)
- Ignore generated `memory/` files

---

## Distribution Channels

### Option A: Shared Git Repository

```bash
# Template repository
https://github.com/your-org/ai-workflow-framework/

# All projects reference it
project-1/.agent → symlink to framework
project-2/.agent → symlink to framework
```

### Option B: Copy Per Project

```bash
# Each project gets independent copy
project-1/.agent/  # Full copy
project-2/.agent/  # Full copy
project-3/.agent/  # Full copy

# Benefit: No shared dependencies
# Downside: Updates require copying again
```

### Option C: Git Submodule

```bash
# In each project
git submodule add https://github.com/your-org/ai-framework .agent

# To update
git submodule update --remote
```

---

## Migrating Existing Project Configs

If you already have `.instructions.md` or `.copilot-instructions.md`:

```bash
# Option 1: Merge into memory/PROJECT.md
cat .instructions.md >> .agent/memory/PROJECT.md

# Option 2: Create wrapper
ln -s .agent/memory/PROJECT.md .instructions.md
```

---

## Team Coordination

### For Team Leads

1. **Setup once:** Prepare template in `/path/to/template/.agent`
2. **Share link:** Give team the path (or GitHub link)
3. **Per-project:** Each developer runs `/init` in their project
4. **Sync:** Occasionally update template, team pulls latest

### For Developers

1. **Copy:** Get `.agent/` folder
2. **Initialize:** Run `/init`
3. **Work:** Use workflows for daily development
4. **Update:** Pull latest template when shared

---

## Next Steps

After initialization:

1. **Review generated files**

   ```bash
   cat memory/PROJECT.md
   cat memory/ARCHITECTURE.md
   ```

2. **Start developing**

   ```bash
   /start-task              # Plan feature
   /implement-feature       # Build it
   ```

3. **Monitor progress**

   ```bash
   orchctl watch workflows  # Real-time view
   ```

4. **Deploy to production**
   ```bash
   /deploy                  # Deploy
   ```

---

## Support

- **Questions about setup?** See [CONTEXT_PASSING.md](./CONTEXT_PASSING.md)
- **How to customize?** See [SKILL_INTEGRATION.md](./SKILL_INTEGRATION.md)
- **Monitoring issues?** See [../../docs/monitoring/WORKFLOW_MONITORING.md](../../docs/monitoring/WORKFLOW_MONITORING.md)
- **Deployment help?** See [../../docs/deployment/PRODUCTION_DEPLOYMENT.md](../../docs/deployment/PRODUCTION_DEPLOYMENT.md)

---

**Version:** Framework Distribution v1.0  
**Last Updated:** March 10, 2026

_Copy. Initialize. Build. Deploy._ 🚀
