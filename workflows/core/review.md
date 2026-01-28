---
description: "Review code, thay đổi Git hoặc Pull Request một cách toàn diện. Hợp nhất từ các quy trình cũ."
trigger: /review
version: "1.0.0"
skills:
  - code-reviewer
  - tech-lead
---

# 🧐 Unified Review (Logic, Arch, Git)

**Mục tiêu:** Kiểm tra chất lượng code, kiến trúc và tác động của các thay đổi trong một bước duy nhất.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Identify Change Source:**
    *   Tự động xác định nguồn review: File hiện tại, `git diff HEAD`, hoặc một commit cụ thể.
    *   Sử dụng `git status` và `git diff` để hiểu ngữ cảnh thay đổi.

2.  **Multidimensional Audit:**
    *   **Logic:** Kiểm tra tính đúng đắn, edge cases và hiệu năng.
    *   **Architecture:** Đảm bảo tuân thủ Layering (Clean Arch) và Dependency Rule.
    *   **Style:** Kiểm tra Lint/Format theo tiêu chuẩn dự án.
    *   **Impact:** Sử dụng `codebase_investigator` để tìm các vùng bị ảnh hưởng gián tiếp.

3.  **Synthesis Report:**
    *   🔴 **Critical:** Lỗi logic, crash, vi phạm kiến trúc nghiêm trọng.
    *   🟡 **Major:** Thiếu test, code quá phức tạp, vi phạm style.
    *   🔵 **Minor:** Gợi ý tối ưu, đặt tên, comments.

## 💡 Hướng dẫn cho AI
- Nếu thay đổi nhỏ, hãy đưa ra báo cáo ngắn gọn.
- Nếu là PR lớn, hãy phân tích theo từng module.
- Luôn cung cấp giải pháp (Code snippet) cho các vấn đề Critical/Major.
