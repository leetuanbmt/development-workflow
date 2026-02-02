# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

## [5.2.0] - 2026-02-02
### 🧠 Dynamic Intelligence & Reliability Upgrade

**Key Improvement:**
The Agent's self-awareness (Metadata) is now **Dynamic** and **Internationalized**. The system no longer relies on hardcoded Python dictionaries but learns its capabilities directly from the `SKILL.md` documentation.

#### ✨ Features
- **Dynamic Metadata Parsing:** `scripts/generate_metadata.py` now parses YAML Frontmatter directly from Markdown files.
- **Single Source of Truth:** Updating `SKILL.md` automatically updates the Agent's definition registry (`metadata.json`).
- **Internationalization (i18n):** All 10 Core Skills (Tech Lead, Product Manager, Reviewer...) now have standardized **English Metadata** for global compatibility.

#### 🛠 Infrastructure & Fixes
- **Unified Memory:** `.gemini/memory` is now a symlink to `.agent/memory`. The CLI and the Agent Runtime now share the exact same brain.
- **Rules Synchronization:** Fixed `scripts/sync.sh` to correctly symlink `core/rules` to `.agent/rules`.
- **Doctor Check:** `scripts/doctor.sh` now passes reliably with the corrected directory structure.
- **Cleanup:** Removed legacy migration scripts and hardcoded skill dictionaries.

---

## [5.1.0] - 2026-02-02
### 🚀 Product Mindset & Vibecode DNA Integration

**MAJOR UPGRADE:**
Transformed the Agent from a "Reactive Coder" to a "Proactive Product Partner" by integrating the core philosophy of Vibecode Kit v4.

#### ✨ New Skills
- **`product-manager`:** The new "brain" of the operation. Proactively proposes Vision, asks for Context, and generates Blueprints.
- **`frontend-architect`:** Ensures UI/UX excellence. Audits for generic design, enforces aesthetics (Typography, Spacing, Motion) and Accessibility.
- **`copywriter`:** Professional UX writer for Landing pages, microcopy, and error messages.

#### 🔄 Enhanced Workflows
- **`/start-task`:** Refactored to use the **Vision -> Context -> Blueprint** flow. No longer just waits for instructions.
- **`/review`:** Now includes a dedicated **UI/UX Audit** step (Aesthetics, Tokens, A11y) alongside code logic review.

#### 🏗️ Architecture & Cleanup
- **Unified Core:** Deleted legacy root `skills/` and `workflows/` folders. All source of truth is now in `core/`.
- **Sync Logic:** Updated `scripts/sync.sh` to strictly sync from `core/`, preventing regression.
- **Templates:** Added `templates/products/` containing battle-tested templates for **Landing Pages**, **SaaS Apps**, and **Dashboards**.

#### 🧠 Core Behavior
- Updated `00-core-behavior.md` to enforce **Partnership Mindset**:
    - "Vision First, Ask Later".
    - "Blueprint is Law".
    - "Proactive Proposal".

---

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