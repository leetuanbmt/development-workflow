# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

## [5.1.0] - 2026-01-30
### 🔌 Skill Integration & Core Framework Cleanup

- **[NEW]** **Antigravity Progressive Disclosure:** Aligned all workflows with the new skill activation pattern. Agent now auto-discovers and activates skills via the `skills:` frontmatter array.
- **[UPDATE]** **Workflow Standardization:** Updated `skills:` array across all 14 core workflows for seamless activation.
- **[CLEANUP]** **Redundant Fields:** Removed legacy `skill:` (singular) fields and non-existent `feature-architect` skill references from core workflows.
- **[CLEANUP]** **Core Refactor:** Refactored core workflows and rules to ensure a 100% technology-agnostic framework.
- **[ARCHIVE]** **Legacy Assets:** Archived deprecated workflows and skills into `.zip` files to reduce noise in the active environment.
- **[FIX]** **Synchronization:** Resolved inconsistencies between core framework and active workspace files.

---

## [5.0.0] - 2026-01-30
### 🏗️ Multi-Project Architecture (Core/Stacks Separation)

**BREAKING CHANGES:**
- **Directory restructure:** `rules/`, `workflows/`, `skills/` → `core/` + `stacks/`
- **Stack-aware sync:** `sync.sh` now supports `--stack` parameter
- **Template system:** New `templates/` folder for project initialization

#### New Structure
```
core/                    # Tech-agnostic (6 rules, 13 workflows, 6 skills)
stacks/flutter/          # Flutter-specific (1 rule, 2 skills)
templates/               # Project templates
```

#### Migration
- **Core Rules:** 00, 03-07 → `core/rules/`
- **Flutter Rules:** 02 → `stacks/flutter/rules/`
- **Core Skills:** bug-investigator, code-reviewer, tech-lead, test-engineer, security-auditor, vibecoder → `core/skills/`
- **Flutter Skills:** flutter-expert, feature-architect → `stacks/flutter/skills/`
- **All Workflows:** → `core/workflows/`

#### New Features
- **Stack Auto-Detection:** Detects Flutter/Node.js/Python automatically
- **Multi-Stack Support:** Same framework for different tech stacks
- **Template System:** `01-project-context.template.md`, `GEMINI.template.md`
- **Improved Reusability:** Use as Git submodule across multiple projects

#### Scripts Updated
- **sync.sh:** Added `--stack` parameter, auto-detection logic, merge core + stack
- **generate_commands.py:** Scan from `core/workflows/` + `stacks/{stack}/workflows/`
- **New:** `MIGRATION.md` - Detailed migration guide from v3.x/v4.x

#### Documentation
- **README.md:** Complete rewrite focusing on multi-project usage
- **MIGRATION.md:** Step-by-step migration guide
- **Templates:** Added project initialization templates

See [MIGRATION.md](MIGRATION.md) for upgrade instructions.

---

## [4.0.0] - 2026-01-29
### 🔧 System Refactoring (Anti-Loop & Consolidation)

**BREAKING CHANGES:**
- **Workflows reduced:** 40 → 13 (-67%)
- **Skills reduced:** 22 → 8 (-63%)
- **Archived:** 27 legacy workflows, 14 deprecated skills

#### Consolidated Workflows
| Before | After |
|:---|:---|
| `/review`, `/review-code`, `/review-pr`, `/review-changes` | `/review` (unified, auto-detect mode) |
| `/audit`, `/audit-architecture`, `/audit-security`, `/audit-analytics` | `/audit` (unified, aspect detection) |
| `/investigate` + `/fix` overlap | Clear separation: investigate=report only, fix=full flow |

#### Archived (moved to `_archived_legacy/` and `_deprecated/`)
- **Workflows:** `legacy/*`, `vibecode`, `review-ui`, `brainstorm`, `aso`, `evaluate-agent`, `gen-api-docs`, `onboard-dev`, `project-overview`, `setup-agent`, `create-component`, `write-adr`, `write-spec`, `manage-i18n`, `audit-architecture`, `audit-analytics`, `security`
- **Skills:** `technical-writer`, `localization-expert`, `ui-ux-designer`, `product-manager`, `devops-engineer`, `app-store-optimization`, `analytics-tracking`, `api-documentation-generator`, `ethical-hacking-methodology`, `mobile-design`, `agent-evaluation`, `qa-lead`, `api-integrator`, `_composites`

#### Anti-Loop Guardrails
- **[NEW]** Added `constraints` section to all core workflows (`max_iterations`, `timeout_minutes`, `exit_on`)
- **[FIX]** Removed hallucinated `codebase_investigator` skill reference from `/investigate`
- **[UPDATE]** Simplified `ORCHESTRATOR.md` dispatch rules (first-match wins)

#### Scripts Updated
- **[UPDATE]** `sync.sh`: Uses `rsync --exclude='_*'` to skip archived folders
- **[UPDATE]** `generate_commands.py`: Skips folders starting with `_`
- **[UPDATE]** `doctor.sh`: Updated workflow suggestions to new names

#### Active Components (13 workflows, 8 skills)
**Workflows:**
- Core: `/start-task`, `/investigate`, `/fix`, `/review`, `/audit`, `/refactor`
- Tech: `/manage-db`, `/integrate-api`, `/write-test`
- Ops: `/doctor`, `/deploy`, `/document`, `/prepare-release`

**Skills:**
- `bug-investigator`, `code-reviewer`, `flutter-expert`, `feature-architect`
- `tech-lead`, `test-engineer`, `security-auditor`, `vibecoder`

---

## [3.2.0] - 2026-01-28
### 📊 Metrics & Documentation Enhancement
- **[NEW]** **Smart Workflow Suggestions:** `/doctor` now analyzes git history and project patterns to suggest relevant workflows.
- **[NEW]** **Case Study:** Added real-world case study from kansuke-photo project with 3 bug investigation examples.
- **[NEW]** **Visual Flow Diagram:** README.md now includes Mermaid diagram showing workflow decision tree.
- **[UPDATE]** **Metrics Dashboard:** Updated with real usage data (20+ sessions, 90% success rate).
- **[UPDATE]** **Workflow Leaderboard:** `/investigate` and `/review-code` now top the usage charts.

## [3.1.0] - 2026-01-27
### 👮 Auditor Edition (Safety & Control)
- **[BREAKING]** Restructured `workflows/` directory into categorized folders:
    - `core/`: Daily commands (`start-task`, `fix`, `audit`...).
    - `tech/`: Technical operations (`manage-db`, `integrate-api`...).
    - `ops/`: Operations (`release`, `document`...).
- **[NEW]** **Rule 07 (Auditor Mode):** Enforces "Plan -> Approve -> Execute" protocol.
- **[NEW]** **`/audit` Workflow:** Dedicated workflow for code/architecture inspection without auto-fixing.
- **[NEW]** **`/investigate` Workflow:** Specialized in Root Cause Analysis with strict reporting template.
- **[UPDATE]** **`/start-task`:** Removed "Internal Simulation" role-play, replaced with "Strategic Planning".
- **[UPDATE]** **`sync.sh` & `generate_commands.py`:** Added recursive directory support.
- **[DOCS]** Updated `README.md` to reflect the "Auditor-First" philosophy.

## [3.0.0] - 2026-01-27
### 🚀 Antigravity Revolution (AI-Native Shift)
- **[BREAKING]** Removed "Atomic Execution" (150 lines limit). System now operates in **High Velocity Mode**.
- **[NEW]** **Vibecoder Skill:** The Ultimate Polyglot Agent for massive code generation and self-correction.
- **[NEW]** **`/vibe` Workflow:** One-touch command for end-to-end feature implementation (`Absorb` -> `Build` -> `Verify`).
- **[ENHANCE]** **Unified Workflows:** Consolidated fragmented commands into powerful tools:
    - `/review`: Combines Code Review, PR Review, and Git Diff Analysis.
    - `/fix`: Combines Investigation and Execution.
    - `/document`: Combines Code Docs and Feature Docs.
    - `/security`: Combines Audit and Pentest.
- **[CLEANUP]** Moved legacy workflows (`implement-feature`, `analyze`, `investigate`...) to `workflows/legacy/`.

## [2.5.2] - 2026-01-27
### 🎨 Mobile & Quality Standards
- **[NEW]** Added `/mobile-design` skill (Mobile Architect Strategy).
- **[NEW]** Added `mobile_audit.py` script for automated mobile best practice checks.
- **[NEW]** Integrated **Code Review Checklist** (`rules/05-code-review-checklist.md`) into `/review-code`.
- **[NEW]** Integrated **Clean Code Standards** (`rules/06-clean-code.md`) into `/refactor`.
- **[UPDATE]** All skills updated to reference new rules.

## [2.5.1] - 2026-01-27
### 🔌 New Integrations (Awesome Skills)
- **[NEW]** Integrated 5 new external skills from `antigravity-awesome-skills`:
    - `/pentest` (Ethical Hacking Methodology)
    - `/evaluate-agent` (Agent Evaluation Framework)
    - `/audit-analytics` (Analytics Tracking & Measurement)
    - `/gen-api-docs` (API Documentation Generator)
    - `/aso` (App Store Optimization)
- **[UPDATE]** All new workflows are fully synced and ready to use.

## [2.5.0] - 2026-01-27
### 🚀 New Features (Diagnostics & Sync)
- **[NEW]** Added `/doctor` workflow - comprehensive environment and sync health diagnostic.
- **[NEW]** Added `scripts/doctor.sh` - automated check for tools (flutter, melos) and sync integrity.
- **[ENHANCE]** `sync.sh` now supports `--watch` mode for real-time synchronization.
- **[ENHANCE]** `/setup-agent` now includes an auto-sync step to ensure immediate context availability.
- **[ENHANCE]** `select_project_dir.sh` now supports non-interactive execution for automated workflows.

## [2.4.1] - 2026-01-26
### 🔧 Documentation Optimization
- **[IMPROVE]** Consolidate `QUICK_REFERENCE.md` into `CHEAT_SHEET.md` for single source of truth
- **[DELETE]** Remove redundant `QUICK_REFERENCE.md` file (~40% content overlap)
- **[ENHANCE]** Expand `CHEAT_SHEET.md` from 46→135 lines: added full 15 workflows, BLoC patterns, emergency commands

### 📊 Metrics & Analytics
- **[NEW]** Add `memory/metrics.md` - Workflow performance dashboard with Mermaid charts
- **[NEW]** Add `memory/usage-patterns.md` - Detailed usage analytics and pattern tracking
- **[ENHANCE]** Update `CONTRIBUTING.md` with metrics logging guidelines
- **[ENHANCE]** Update `README.md` to reference metrics dashboard

## [2.4.0] - 2026-01-26
### 🚀 Major Improvements (Agent Enhancement)
- **[NEW]** Thêm `/fix` workflow - hoàn thiện flow Investigate → Fix
- **[NEW]** Thêm `/deploy` workflow - quy trình deploy với rollback plan
- **[NEW]** Thêm `/onboard-dev` workflow - hướng dẫn developer mới
- **[NEW]** Thêm `QUICK_REFERENCE.md` - bảng tra cứu nhanh
- **[NEW]** Thêm `CONTRIBUTING.md` - hướng dẫn đóng góp
- **[NEW]** Thêm `scripts/validate.sh` - kiểm tra tính nhất quán
- **[IMPROVE]** Chuẩn hóa YAML frontmatter với `version` field cho tất cả 27 workflows
- **[IMPROVE]** Refactor `knowledge_base.md` với Index, Tags system và format chuẩn

## [2.3.0] - 2026-01-26
### 🔧 Bug Fixes & Documentation
- **[NEW]** Thêm `CHEAT_SHEET.md` - Hướng dẫn nhanh các lệnh thường dùng.
- **[NEW]** Thêm `GEMINI.md` - Cấu hình system prompt cho Gemini CLI.
- **[NEW]** Thêm `scripts/check_arch.sh` - Script kiểm tra vi phạm Clean Architecture.
- **[FIX]** Sửa đánh số section trong `rules/00-core-behavior.md` (1,2,5,6 → 1,2,3,4).
- **[FIX]** Sửa đường dẫn workflow sai trong `rules/03-qa-process.md`.

## [2.2.0] - 2026-01-22
### ⚡️ Optimization & Workflow Refinement
- **Code Gen Checkpoint:** Thêm quy tắc bắt buộc AI dừng lại (Wait Step) khi gặp task cần chạy `build_runner`, chuyển quyền thực thi cho User.
- **Skill Unification:** Tinh gọn hệ thống Skill.
    - Hợp nhất `pr_reviewer` vào `code_reviewer` (Reviewer giờ đây check cả tính nhất quán và DB migration).
    - Merge `feature_analyst` vào `feature_architect`.
- **Documentation:** Cập nhật `README.md` phản ánh chính xác quy trình "Humanized Simulation" và "Atomic Execution".

## [2.1.0] - 2026-01-22
### 🚀 Enhancements (Advanced Automation)
- **Atomic Execution:** AI tự động chia nhỏ các task lớn (quy tắc >150 dòng) để tránh mất context và đảm bảo chất lượng code.
- **CI/CD Auto-Discovery:** `/setup-agent` đã hỗ trợ phát triển các công cụ tự động hóa (GitHub Actions, Fastlane, Jenkins).
- **Proactive Memory:** AI chủ động đề xuất ghi nhớ bài học kinh nghiệm sau mỗi task thay vì đợi user nhắc.

## [2.0.0] - 2026-01-22
### 🚀 Major Features (Enterprise Grade)
- **Master Workflow (`/start-task`):** Cổng giao tiếp duy nhất. Hỗ trợ đa chế độ (Hotfix/Standard/Prototype).
- **Humanized Simulation:** Cơ chế "Họp team nội bộ" (Internal Simulation) giữa BA, Architect và QA Lead trước khi làm task.
- **Auto-Discovery (`/setup-agent`):** Tự động quét và cấu hình Context cho dự án mới (Tech stack, Design system).
- **Project Memory:** Hệ thống lưu trữ bài học kinh nghiệm (`knowledge_base.md`).

## [1.0.0] - 2025-12-01
- Initial Release: Basic skills and workflows (Implement, Review).