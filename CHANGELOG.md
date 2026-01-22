# Changelog

All notable changes to the AI Development Workflow will be documented in this file.

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