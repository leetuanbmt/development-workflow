---
description: "Quản lý đa ngôn ngữ: Tìm hardcode string và đồng bộ file ARB."
trigger: /manage-i18n
skills:
  - localization-expert
---

# 🌐 Quản lý Đa ngôn ngữ (i18n Management)

**Mục tiêu:** Đảm bảo ứng dụng hỗ trợ đa ngôn ngữ hoàn hảo, không còn sót text cứng (Hardcode) và các file dịch thuật được đồng bộ.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Quét Hardcode (Scan):**
    *   Chạy script `.agent/skills/localization-expert/scripts/find_hardcode.sh`.
    *   Liệt kê các vị trí nghi vấn đang dùng `Text('Raw String')`.

2.  **Trích xuất & Đặt tên Key (Extract):**
    *   Với mỗi chuỗi raw, đề xuất một Key tên hợp lý (ví dụ: `buttonSubmit` thay vì `submit`).
    *   Thêm Key vào file gốc (thường là `intl_en.arb` hoặc `intl_ja.arb`).

3.  **Đồng bộ & Sắp xếp (Sync & Sort):**
    *   Đảm bảo Key mới được thêm vào **tất cả** các file ngôn ngữ khác với giá trị tạm (hoặc dịch nếu biết).
    *   Sắp xếp lại các dòng trong file `.arb` theo thứ tự A-Z để clean.

4.  **Refactor Code:**
    *   Thay thế `Text('Raw String')` bằng `Text(S.of(context).newKey)`.

## 📊 Checklist
- [ ] Không còn Text hardcode trong các màn hình chính.
- [ ] Các file `.arb` có số lượng key bằng nhau.
- [ ] Đã chạy `make gen` (nếu dùng thư viện sinh code cho i18n).

## 💡 Hướng dẫn cho Gemini
*   Kích hoạt skill `localization-expert`.
*   Cảnh giác với các chuỗi format có biến số (vd: "Hello $name"), phải chuyển thành ARB params (`Hello {name}`).
