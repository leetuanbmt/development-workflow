---
description: "Quy trình an toàn để thay đổi Schema Database (Drift) và viết Migration."
trigger: /manage-db
---

# 🗄️ Quản lý Database Migration

**Mục tiêu:** Cập nhật cấu trúc Database an toàn, đảm bảo tính toàn vẹn dữ liệu và không gây crash app cho người dùng cũ.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Modify Schema:**
    *   Cập nhật file Table (`.dart`) trong thư mục `data/tables/` hoặc tương ứng.
    *   Nếu thêm cột mới, cân nhắc `nullable` hoặc `withDefault` để tránh lỗi dữ liệu cũ.

2.  **Generate Code:**
    *   Chạy lệnh `make gen` để Drift cập nhật code sinh (`.g.dart`).

3.  **Bump Schema Version:**
    *   Tăng `schemaVersion` trong file Database chính (`AppDatabase`).

4.  **Write Migration Logic:**
    *   Override `migration` getter trong `AppDatabase`.
    *   Viết logic cho từng version:
        ```dart
        if (from < 2) {
          await m.addColumn(users, users.isPremium);
        }
        if (from < 3) {
          await m.createTable(posts);
        }
        ```

5.  **Verification (Quan trọng):**
    *   Sử dụng skill `test-engineer`.
    *   Viết/Chạy Test Migration để đảm bảo data từ version cũ lên version mới vẫn sống sót.
    *   Kiểm tra `Drift` schema helper (nếu có cấu hình).

## 📊 Checklist An toàn
- [ ] Đã backup DB cũ (nếu test trên thiết bị thật).
- [ ] Cột mới thêm vào không được `NOT NULL` (trừ khi có default value).
- [ ] Đã chạy test migration thành công.

## 💡 Hướng dẫn cho Gemini
*   Luôn nhắc User backup file `default_db.sqlite` trong assets nếu đó là DB khởi tạo.
*   Cảnh báo rủi ro mất dữ liệu nếu user định xóa bảng.
