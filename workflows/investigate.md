---
description: "Phân tích, tìm nguyên nhân gốc rễ (Root Cause) của lỗi và đề xuất giải pháp sửa lỗi."
trigger: /investigate
---

# 🐛 Điều tra Lỗi (Bug Investigation)

**Mục tiêu:** Phân tích, tìm nguyên nhân gốc rễ (Root Cause) của lỗi và đề xuất giải pháp sửa lỗi hiệu quả, tránh phát sinh lỗi mới.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Tái hiện & Thu thập Thông tin (Reproduce & Gather):**
    *   Mô tả lỗi: Input là gì? Output mong đợi là gì? Thực tế nhận được gì?
    *   Kiểm tra Logs: Sử dụng `search_file_content` để tìm các dòng `Logger.log` hoặc `print` liên quan.
    *   Kiểm tra Môi trường: Lỗi xảy ra trên Android, iOS hay cả hai? Ở môi trường (flavor) nào?

2.  **Định vị Vùng nghi vấn (Locate Suspect Area):**
    *   Sử dụng `glob` để tìm các file liên quan đến tính năng bị lỗi.
    *   Trace luồng dữ liệu ngược từ UI -> BLoC -> UseCase -> Repository.

3.  **Phân tích Nguyên nhân (Root Cause Analysis):**
    *   Kiểm tra logic tại điểm nghi vấn.
    *   **Common issues:** Null pointer, sai kiểu dữ liệu (parsing error), lỗi bất đồng bộ (async/await), state không được update.
    *   Xác minh giả thuyết bằng cách đọc code chi tiết.

4.  **Đề xuất Giải pháp (Proposed Solution):**
    *   Viết mã sửa lỗi.
    *   Đảm bảo giải pháp tuân thủ kiến trúc hiện tại.

5.  **Xác minh (Verification):**
    *   Viết Unit Test để tái hiện lỗi (Regression Test).
    *   Chạy test để đảm bảo lỗi đã được fix.

## 📊 Cấu trúc Báo cáo (Investigation Report)

### 1. Mô tả Lỗi (Bug Summary)
*   **Vấn đề:** [Mô tả ngắn gọn]
*   **Mức độ:** [Blocker / Major / Minor]

### 2. Phân tích Nguyên nhân (Root Cause)
*   **Nguyên nhân:** [Giải thích tại sao lỗi xảy ra]
*   **Vị trí:** `path/to/file.dart:line_number`

### 3. Giải pháp (Solution)
*   **Cách sửa:** [Mô tả phương án]
*   **Mã nguồn:** (Code snippet Before/After)

### 4. Kiểm thử Xác minh (Verification)
*   [ ] Unit Test đã pass.
- [ ] Đã kiểm tra các side effects liên quan.

## 💡 Hướng dẫn cho Gemini
*   Đừng vội sửa code ngay khi thấy lỗi. Hãy dành thời gian phân tích tại sao nó xảy ra.
*   Luôn ưu tiên giải pháp giải quyết tận gốc vấn đề thay vì chỉ fix ở ngọn (UI).