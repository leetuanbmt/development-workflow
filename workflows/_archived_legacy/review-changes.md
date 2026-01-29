---
description: "So sánh thay đổi với Git, đánh giá chức năng và phân tích phạm vi ảnh hưởng."
trigger: /review-changes
version: "2.4.0"
skills:
  - code-reviewer
  - tech-lead
---

# 🔍 Review Changes & Impact Analysis

**Mục tiêu:** Phân tích sâu các thay đổi so với Git, không chỉ check syntax mà còn đánh giá tác động hệ thống.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Thu thập dữ liệu Git (Git Extraction):**
    *   Nếu user cung cấp file: Chạy `git diff HEAD <file_path>` để lấy thay đổi chưa commit, hoặc `git diff HEAD~1 HEAD <file_path>` cho commit gần nhất.
    *   Nếu user cung cấp commit hash: Chạy `git show <commit_hash>`.
    *   Nếu không nói gì: Chạy `git diff HEAD` để xem toàn bộ thay đổi hiện tại.

2.  **Phân tích Chức năng (Functional Evaluation):**
    *   Xác định **Mục tiêu thay đổi**: Code này đang fix bug, thêm feature hay refactor?
    *   Đánh giá tính đúng đắn của logic mới so với yêu cầu nghiệp vụ.
    *   Kiểm tra các trường hợp biên (edge cases) phát sinh từ logic mới.

3.  **Phân tích Phạm vi Ảnh hưởng (Impact Assessment):**
    *   **BẮT BUỘC:** Gọi `delegate_to_agent` với `codebase_investigator` để tìm các file đang sử dụng (depend on) các Class/Function vừa bị sửa đổi.
    *   Kiểm tra sự thay đổi trong Data Model: Nếu sửa Model/Entity, các file Mapper, Repository và UI nào sẽ bị hỏng?
    *   Kiểm tra ảnh hưởng đến Performance: Thay đổi này có gây loop vô tận hoặc rebuild UI quá nhiều không?

4.  **Kiểm tra Test (Regression Check):**
    *   Xác định các Unit Test liên quan cần chạy lại.
    *   Đề xuất các test case mới cần bổ sung cho phần logic vừa thêm.

## 📊 Cấu trúc Báo cáo Review

### 1. Tóm tắt Thay đổi (Change Summary)
*   **Loại thay đổi:** [Feature/Bugfix/Refactor]
*   **Mục tiêu chính:** [Mô tả ngắn gọn]

### 2. Đánh giá Chức năng (Functional Review)
*   **Điểm tốt:** Những gì đã làm tốt.
*   **Vấn đề Logic:** Các lỗi logic hoặc rủi ro tiềm ẩn.

### 3. Phân tích Tác động (Impact Analysis) ⚠️
*   **Phạm vi ảnh hưởng:** Danh sách các module/file bị tác động gián tiếp.
*   **Rủi ro Regresson:** Những tính năng cũ nào có nguy cơ bị hỏng?

### 4. Checklist Thực thi (Action Items)
*   [ ] Lệnh chạy test liên quan: `flutter test <path_to_test>`
*   [ ] Các file cần cập nhật thêm (nếu có).

---
*Lưu ý: Luôn ưu tiên tính ổn định của hệ thống lên hàng đầu.*
