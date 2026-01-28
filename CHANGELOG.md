# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

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