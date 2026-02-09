# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

## [5.3.2] - 2026-02-09
### 🧐 Enhanced Review Workflow - Interactive Base Detection & Metrics

**Theme:** Improve review accuracy via Human-in-the-loop and better reporting.

#### ✨ New Features
- **Interactive Fallback:** Nếu AI không tự tin về branch gốc (hoặc diff > 20 files), quy trình sẽ tạm dừng và hỏi người dùng chỉ định base branch.
- **Report Summary Table:** Thêm bảng tổng hợp số lượng Issue theo mức độ (Critical/Major/Minor) ngay đầu báo cáo.
- **Performance Audit:** Bổ sung hạng mục audit hiệu năng (Complexity, IO/Network, Rendering, Memory Check).

---

## [5.3.1] - 2026-02-09
### 🧐 Enhanced Review Workflow - Dynamic Base Detection

**Theme:** Improve review accuracy by automatically detecting the parent branch.

#### ✨ New Features
- **Dynamic Parent Branch Detection:** AI giờ đây tự động nhận diện branch gốc (Base Branch) để so sánh thay vì mặc định `origin/main`.
- **Three-Level Heuristics:** Sử dụng 3 cấp độ kiểm tra (show-branch, decoration-log, common-fallback) để tìm điểm tách branch chính xác nhất.
- **Improved Scoping:** Báo cáo rõ ràng phạm vi so sánh `$FEATURE_BRANCH` vs `$BASE_BRANCH` kèm số lượng file thay đổi trước khi audit.

#### 🔧 Internal Fixes
- **Unified Sync:** Đồng bộ cải tiến từ file nguồn `core/workflows/` sang runtime `.agent/`.
- **Filtration Update:** Bổ sung `vendor/` và `dist/` vào danh sách loại trừ khi quét file để tối ưu Token.

---

## [5.3.0] - 2026-02-05
### 🛡️ Sync Safety Enhancement - Smart Detection & Protection

**Theme:** Prevent data loss and enhance developer confidence during sync operations.

#### ✨ New Features
- **Smart Sync Detection:** Auto-detects if project has been initialized via `/setup`
  - Checks if `PROJECT.md` has been filled (no longer contains `[PLACEHOLDER]` markers)
  - Checks for `.setup-completed` flag file
  - Detects presence of custom skills beyond the 10 core skills
- **Auto-Backup System:** Creates timestamped backups before any destructive operations
  - Backup location: `.agent/.backup-YYYYMMDD-HHMMSS/`
  - Includes `RESTORE.md` with step-by-step restoration instructions
  - Preserves memory/, skills/, and workflows/ directories

#### 🔄 Enhanced Sync Modes
- **Smart Mode (default):** `./sync.sh`
  - Auto-detects initialization state
  - Preserves `PROJECT.md` if already filled
  - Protects custom skills (only updates core skills)
  - Safe for daily use
- **Runtime Mode:** `./sync.sh --runtime`
  - Preserves hydrated workflows
  - Updates core files only
  - Recommended after `/setup`
- **Force Reset Mode:** `./sync.sh --force-reset`
  - Complete reset to factory defaults
  - Requires typing "YES" for confirmation
  - Creates backup before proceeding
  - Use only when intentional clean slate needed
- **Backup-Only Mode:** `./sync.sh --backup-only`
  - Creates backup without syncing
  - Useful before major manual changes

#### 🛠 Infrastructure Improvements
- **Enhanced CLI:** `./sync.sh --help` shows comprehensive usage documentation
- **Detection Functions:**
  - `is_project_initialized()` - Checks if PROJECT.md filled
  - `is_setup_completed()` - Checks for .setup-completed flag
  - `has_custom_skills()` - Detects skills beyond core 10
- **Backup Function:** `backup_runtime()` with automatic restore instructions

#### 📚 Documentation Updates
- **CHEAT_SHEET.md:** Added v5.3.0 sync options section with safety features explanation
- **Migration Guide:** Clear upgrade path for existing users
- **Sync Script Help:** Inline documentation with examples

#### 🔒 Safety Guarantees
- ✅ **PROJECT.md Protection:** Never overwritten if initialized
- ✅ **Custom Skills Preservation:** User-created skills never deleted
- ✅ **Backup Before Action:** Auto-backup when risks detected
- ✅ **Confirmation Gates:** Destructive operations require explicit confirmation
- ✅ **Rollback Path:** Clear instructions in backup RESTORE.md

#### ⚠️ Migration Notes for Existing Users
**No breaking changes** - all existing workflows continue to work:
- Old: `./sync.sh` → Now has smart detection (safer)
- Old: `./sync.sh --runtime` → Works exactly the same
- New: `./sync.sh --force-reset` → Explicit command for old "source mode" behavior

**Recommended Action:**
1. After upgrading, run `./sync.sh` (will auto-detect your project)
2. If PROJECT.md already filled, it will be preserved
3. Custom skills will be kept intact
4. Run `/doctor` to verify system health

---

## [5.2.1] - 2026-02-04
### 🚀 Vibe Coding Enhancement & System Alignment

**Theme:** Production readiness & developer experience improvements.

#### ✨ New Features
- **`/vibe` Workflow:** New official command for high-throughput implementation (bridges `/start-task` → coding).
- **Error Recovery Protocol:** Vibecoder now has max 2 attempts with clear escalation path.
- **Incremental Verification:** Auto-validation after each layer (Data/Domain/Presentation).
- **Safety Enforcement:** Pre-flight checks (secrets scan, critical file detection) before code generation.

#### 🔧 Documentation & Alignment
- **Version Consistency:** All 15 workflows bumped to v5.2.0 (matching system version).
- **Verification Loop:** Added concrete metrics table to GEMINI.md, DOD.md, QA_PROCESS.md.
  - Syntax: 0 errors | Logic: 100% tests pass | Integration: Critical paths | Security: 0 secrets
- **CHEAT_SHEET.md:** Updated to v4.1 with AI-Native features (Vibe Coding, Agent Skills).
- **CONVENTIONS.md:** Clarified Vibe Coding high-throughput (500-2000 lines) vs modularity (~150-300 lines per file).

#### 🎭 Skill System Improvements
- **Fixed Dispatch Ambiguity:** `design` → `ui design` (frontend-architect) vs `system design` (tech-lead).
- **Skill Composition Patterns:** Documented 4 patterns (Sequential Pipeline, Parallel Review, Nested Delegation, Iterative Refinement).
- **Expanded Skill List:** Now 10 core skills (added `feature-architect` for domain modeling).

#### 🛠 Infrastructure
- **ORCHESTRATOR v4.1:** Refined dispatch rules with Notes column and disambiguation logic.
- **README.md:** Added "Advanced AI-Native Features" section (Vibe Coding, Skills, Verification Loop).
- **System Evaluation Report:** Comprehensive audit identifying maturity level (3.5/5 CMM) and strategic roadmap.

#### 🐛 Fixes
- **Ghost Commands:** Removed references to non-existent `/implement-feature` and `/vibecode`.
- **Documentation Sync:** 100% alignment across all core documents (GEMINI.md, CHEAT_SHEET, DOD.md, QA_PROCESS.md).

---

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