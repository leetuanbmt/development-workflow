---
description: "Chế độ Auditor: Phân tích sâu, kiểm tra kiến trúc và logic trước khi thực hiện thay đổi."
trigger: /audit
version: "1.1.0"
skills:
  - code-reviewer
  - feature-architect
  - tech-lead
---

# 🕵️ Auditor Mode Workflow

**Mục tiêu:** Chuyển đổi AI sang chế độ hỗ trợ chuyên sâu, tập trung vào việc phân tích và lập kế hoạch cho Auditor duyệt.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Deep Investigation:**
    *   Sử dụng `codebase_investigator` hoặc `search_file_content` để quét toàn bộ logic liên quan đến yêu cầu.
    *   Xác định các ràng buộc (Constraints) hiện có trong codebase.

2.  **Architecture & Security Audit:**
    *   Đối chiếu với `02-architecture-rules.md` để đảm bảo không vi phạm Layering.
    *   Kiểm tra các vấn đề về tài nguyên (Memory leaks, Resource disposal, Deadlocks).

3.  **Strategic Planning:**
    *   Trình bày 1 Implementation Plan rõ ràng dưới dạng bullet points.
    *   Liệt kê các file sẽ bị thay đổi và lý do.

4.  **Auditor Verification:**
    *   Chờ phản hồi từ User.
    *   Nếu được duyệt, tiến hành thực thi bằng các tool `replace`/`write_file`.
    *   Nếu không, điều chỉnh kế hoạch dựa trên feedback.

## 💡 Hướng dẫn cho AI
- Tuyệt đối không tự ý ghi đè file mà không giải thích logic trước.
- Luôn ưu tiên tính an toàn và bền vững của hệ thống hơn là tốc độ triển khai tức thời.
- Nếu phát hiện lỗi trong yêu cầu của Auditor, phải lịch sự chỉ ra và đề xuất phương án tốt hơn.
