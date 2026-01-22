# 🧠 Project Knowledge Base (Bộ nhớ Dự án)

File này lưu trữ các bài học kinh nghiệm, lỗi đặc thù (Gotchas), và các quy tắc ngầm của dự án mà không thể hiện trong code.

## 1. Technical Gotchas (Lỗi kỹ thuật đã gặp)
*   **[Ví dụ] Conflict thư viện:** Không dùng `GetX` chung với `AutoRoute` vì xung đột Navigation Key.
*   **[Ví dụ] Android Build:** Khi build release phải tắt `shrinkResources` nếu dùng thư viện động X.

## 2. Business Rules (Quy tắc nghiệp vụ đặc thù)
*   **[Ví dụ]** Mọi màn hình nhập liệu tiền tệ phải support tối đa 12 số.

## 3. Preferred Patterns (Thói quen ưu thích)
*   User thích dùng `Freezed` kiểu Union Case cho State Management.
*   Luôn dùng `SizedBox` thay vì `Container` để tạo khoảng cách (Performance).

---
**Hướng dẫn cho AI:**
1.  **READ:** Luôn đọc file này khi chạy `/start-task`.
2.  **WRITE:** Khi sửa xong một lỗi khó (`/investigate`), hãy cập nhật bài học vào đây.
