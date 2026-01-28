---
description: "Quy trình quản lý Schema Database Drift an toàn, tập trung vào Migration và Data Integrity."
trigger: /manage-db
version: "3.0.0"
skills:
  - flutter-expert
  - test-engineer
---

# 🗄️ Safe Database Management

**Mục tiêu:** Thay đổi Schema DB mà không làm mất dữ liệu người dùng.

## 🔄 Quy trình (Execution Flow)

### 1. Schema Impact Analysis
*   **Audit:** Trước khi thêm cột/bảng, kiểm tra xem nó có ảnh hưởng đến các Query hiện tại (`DAOs`) không?
*   **Constraint Check:** Cột mới có `NOT NULL` không? Nếu có, `defaultValue` là gì?

### 2. Implementation Steps
1.  **Modify Table:** Sửa file `.dart` định nghĩa bảng.
2.  **Generate:** Chạy `make gen` (hoặc lệnh tương ứng của dự án).
3.  **Migration Logic:**
    *   Viết code trong `migration` block của `AppDatabase`.
    *   **BẮT BUỘC:** Phải dùng lệnh `addColumn`, `createTable` của Drift, không viết Raw SQL trừ khi bất khả kháng.

### 3. Verification (Safety First)
*   **Test Migration:**
    *   AI phải đề xuất viết (hoặc tự viết) một test case nhỏ để verify migration từ version N lên N+1.
*   **Sanity Check:**
    *   Chạy thử app để đảm bảo không crash khi mở Database.

## 💡 Hướng dẫn cho AI
*   **Cảnh báo:** Nếu User định xóa cột (Delete Column), hãy cảnh báo 3 lần về việc mất dữ liệu.
*   **Version Control:** Luôn nhắc user tăng `schemaVersion`.