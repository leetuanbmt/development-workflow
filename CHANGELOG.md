# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

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