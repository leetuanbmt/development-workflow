---
description: "Chuyển đổi yêu cầu thô sơ thành Tài liệu Đặc tả (PRD/Specs) chi tiết."
trigger: /write-spec
---

# 📝 Viết Đặc tả Tính năng (Write Specs)

**Mục tiêu:** Đóng vai trò Product Manager để làm rõ yêu cầu, định nghĩa User Stories và Acceptance Criteria trước khi Dev bắt đầu code.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Phỏng vấn & Khám phá (Discovery):**
    *   Đọc yêu cầu ban đầu của User.
    *   Đặt câu hỏi "Tại sao?": Mục đích kinh doanh là gì?
    *   Xác định Người dùng mục tiêu (Persona): Ai sẽ dùng tính năng này?

2.  **Định nghĩa User Stories:**
    *   Viết theo mẫu: `As a [User], I want to [Action], so that [Benefit]`.
    *   Phân loại độ ưu tiên: Must Have (MVP) vs Nice to Have.

3.  **Tiêu chí Chấp nhận (Acceptance Criteria - AC):**
    *   Liệt kê các điều kiện cụ thể để tính năng được coi là "Done".
    *   Ví dụ: "Nút Lưu chỉ enable khi đã điền đủ thông tin", "Hiển thị lỗi khi mất mạng".

4.  **Các trường hợp biên (Edge Cases):**
    *   Xác định các luồng Negative: Mất mạng, dữ liệu rỗng, lỗi server.

5.  **Output:**
    *   Tạo file Markdown tại `docs/specs/[feature_name].md` (hoặc in ra màn hình nếu yêu cầu nhỏ).

## 💡 Hướng dẫn cho Gemini
*   Kích hoạt skill `product-manager`.
*   Đừng dùng ngôn ngữ kỹ thuật (như BLoC, DB) trong Spec. Hãy dùng ngôn ngữ người dùng.
*   Luôn yêu cầu xác nhận từ User trước khi chốt Spec.
