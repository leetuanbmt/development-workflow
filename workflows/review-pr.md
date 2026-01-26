---
description: "Kiểm tra tổng thể các thay đổi trong Pull Request, đảm bảo chất lượng và kiến trúc."
trigger: /review-pr
skills:
  - code-reviewer
  - qa-lead
---

# 🏁 Review Pull Request (PR Review)

**Mục tiêu:** Kiểm tra tổng thể các thay đổi trong một Pull Request, đảm bảo chất lượng mã nguồn, tính nhất quán của kiến trúc và không có lỗi logic trước khi merge vào nhánh chính.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Tổng quan Thay đổi (Review Overview):**
    *   Sử dụng `git diff` hoặc `git show` để xem danh sách các file thay đổi.
    *   Đọc mô tả PR (nếu có) để hiểu mục tiêu của tác giả.

2.  **Kiểm tra Kiến trúc & Layering:**
    *   Các file mới có đặt đúng thư mục (feature/layer) không?
    *   Có vi phạm nguyên tắc phụ thuộc (ví dụ: Domain phụ thuộc Data) không?
    *   Check DI: Các service mới đã được inject đúng cách chưa?

3.  **Kiểm tra Logic & Nghiệp vụ:**
    *   Logic mới có giải quyết đúng yêu cầu không?
    *   Các trường hợp biên (Edge cases) đã được xử lý chưa?
    *   Có đoạn code nào quá phức tạp cần đơn giản hóa không?

4.  **Kiểm tra Chất lượng Code (Clean Code):**
    *   Naming convention (Dart style).
    *   Sử dụng `const` cho Widgets.
    *   Hàm/Lớp có quá lớn không?
    *   Có code thừa (dead code) hay comment dư thừa không?

5.  **Kiểm tra Test & Validation:**
    *   Có file test mới đi kèm không?
    *   Chạy `make lint` và `make test` để xác nhận PR không làm hỏng project.

## 📊 Cấu trúc Báo cáo Review PR

### 1. Tóm tắt (Summary)
*   **Mục tiêu PR:** [Mô tả ngắn]
*   **Trạng thái:** [✅ Approved / ⚠️ Needs Changes / ❌ Declined]

### 2. Chi tiết Nhận xét (Detailed Feedback)

| File | Dòng | Loại | Nhận xét & Gợi ý |
| :--- | :--- | :--- | :--- |
| `path/to/file` | `10` | Logic | Cần kiểm tra null ở đây để tránh crash. |
| `path/to/file` | `45` | Style | Nên đặt tên biến rõ nghĩa hơn (vd: `isSuccess`). |

### 3. Đề xuất Refactor (nếu có)
```dart
// Suggestion for improvement
```

## 💡 Hướng dẫn cho Gemini
*   Luôn giữ thái độ khách quan và xây dựng.
*   Ưu tiên các vấn đề về kiến trúc và logic trước khi soi lỗi format.
*   Nếu PR quá lớn, hãy yêu cầu tác giả chia nhỏ hoặc review theo từng module.