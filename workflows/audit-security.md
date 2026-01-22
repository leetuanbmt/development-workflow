---
description: "Rà soát lỗ hổng bảo mật và tuân thủ quy tắc an toàn dữ liệu."
trigger: /audit-security
---

# 🛡️ Kiểm tra Bảo mật (Security Audit)

**Mục tiêu:** Phát hiện và cảnh báo các nguy cơ bảo mật tiềm ẩn trong mã nguồn trước khi release.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Quét Dữ liệu Nhạy cảm (Data Scan):**
    *   Tìm kiếm các từ khóa: `password`, `token`, `key`, `secret`, `auth`.
    *   Đảm bảo không hardcode API Key trong code.

2.  **Kiểm tra Lưu trữ (Storage Check):**
    *   Kiểm tra việc sử dụng `SharedPreferences` (không lưu data nhạy cảm).
    *   Đảm bảo Token được lưu trong `FlutterSecureStorage`.

3.  **Kiểm tra Network & Logging:**
    *   Đảm bảo không `print()` thông tin nhạy cảm ra console.
    *   Kiểm tra cấu hình SSL/TLS (nếu có).

4.  **Phân tích Dependencies:**
    *   (Optional) Kiểm tra xem có package nào quá cũ hoặc có lỗ hổng đã biết không.

## 📊 Báo cáo Bảo mật (Security Report)

### 1. Critical Issues (Nghiêm trọng - Fix ngay)
*   🔴 Hardcoded API Key tại `api_client.dart`.
*   🔴 Log toàn bộ response body chứa user token.

### 2. Warnings (Cảnh báo)
*   🟡 Sử dụng package `xyz` đã ngừng bảo trì.

## 💡 Hướng dẫn cho Gemini
*   Sử dụng skill `security-auditor`.
*   Luôn giả định tình huống xấu nhất (Attacker có quyền truy cập vật lý vào máy).
