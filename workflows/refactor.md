---
description: "Cải thiện cấu trúc, hiệu năng và độ dễ đọc của mã nguồn mà không làm thay đổi hành vi."
trigger: /refactor
version: "2.4.0"
skills:
  - code-reviewer
  - flutter-expert
---

# ♻️ Refactoring Code

**Mục tiêu:** Cải thiện cấu trúc, hiệu năng và độ dễ đọc của mã nguồn mà không làm thay đổi hành vi bên ngoài (External Behavior).

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Đánh giá & Lập kế hoạch (Assessment):**
    *   Xác định "Code Smell": Hàm quá dài, lặp code, đặt tên khó hiểu, vi phạm Architecture.
    *   Đảm bảo khu vực cần refactor đã có Unit Test bao phủ (Test Coverage). Nếu chưa, phải viết Test trước.

2.  **Thực hiện Refactor (Execution):**
    *   **Rename:** Đổi tên biến/hàm cho rõ nghĩa.
    *   **Extract Method:** Tách hàm dài thành các hàm nhỏ hơn.
    *   **Extract Widget:** Tách UI phức tạp thành các Widget con (`const`).
    *   **Move Class:** Di chuyển file về đúng layer (Domain/Data/Presentation).

3.  **Xác minh (Verification):**
    *   Chạy lại toàn bộ Test: `make test`.
    *   Đảm bảo không có Regression (Lỗi hồi quy).

## 📊 Checklist An toàn
- [ ] Đã backup code (commit) trước khi sửa.
- [ ] Test case đã pass 100% trước khi sửa.
- [ ] Test case vẫn pass 100% sau khi sửa.
- [ ] Không thay đổi Logic nghiệp vụ.

## 💡 Hướng dẫn cho Gemini
*   Luôn refactor từng bước nhỏ (Baby Steps).
*   Sử dụng skill `code-reviewer` để tự đánh giá code sau khi refactor.