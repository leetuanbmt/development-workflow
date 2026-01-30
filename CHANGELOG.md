# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

## [4.0.0] - 2026-01-30
### 🧬 Universal Stack Support (Stack-Agnostic Revolution)

**BREAKING CHANGES:**
- **Dynamic Setup:** `/setup` no longer uses hardcoded logic. It uses a **Template + Placeholder** engine to generate workflows for **ANY** tech stack.
- **Removed Hardcoded Stacks:** `stacks/flutter` and `stacks/node` folders have been removed. The system is now 100% dynamic.
- **New Directory Structure:** Introduced `templates/` directory for storing generic logic.

#### Key Features
- **Universal Setup:** One command (`/setup`) initializes environment for Flutter, Node.js, Python, Go, Rust, etc.
- **Auto-Hydration:** Workflows like `/deploy`, `/fix`, `/test` are automatically rewritten with project-specific commands (e.g., `npm run test` or `cargo test`).
- **Expert Skill Generation:** AI automatically generates a `framework-expert` skill for the detected technology (e.g., "Rust Expert" or "Next.js Expert").

#### New Directory Structure
```
templates/               # 🧩 Universal Logic (with {{PLACEHOLDERS}})
  ├── skills/            # Expert skill templates
  └── workflows/         # Workflow templates (deploy, test, fix...)
workflows/               # ⚙️ The Engine (setup.md, etc.)
skills/                  # 🧠 Generic Core Skills (Tech Lead, Reviewer)
core/                    # 📜 Universal Rules
scripts/                 # 🔧 Sync & Maintenance
```

#### Updated Workflows
- **`/setup`:** The "Compiler" that drives the whole system.
- **`/deploy`:** Now supports `{{CMD_BUILD}}` and `{{DEPLOY_DESTINATION}}`.
- **`/prepare-release`:** Now checks `{{FILE_VERSION}}` and runs `{{CMD_TEST}}`.
- **`/write-test`:** Uses `{{LIB_TEST}}` and `{{LIB_MOCK}}`.
- **Core Workflows:** `audit`, `fix`, `review` now include `{{STACK_HINTS}}`.

#### Documentation
- **PROJECT.md:** Updated to reflect "Meta-Framework" architecture.
- **README.md:** Complete rewrite focusing on Universal Stack Support.

---

## [5.1.0] - 2026-01-30
### 🔌 Skill Integration & Core Framework Cleanup
...
