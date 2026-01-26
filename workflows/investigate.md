---
description: "Phân tích, tìm nguyên nhân gốc rễ (Root Cause) của lỗi và đề xuất giải pháp sửa lỗi."
trigger: /investigate
version: "2.4.0"
skills:
  - bug-investigator
---

# 🐛 Điều tra Lỗi (Bug Investigation Only)

**Mục tiêu:** Phân tích, tìm nguyên nhân gốc rễ (Root Cause) của lỗi và báo cáo chi tiết. **TUYỆT ĐỐI KHÔNG** tự ý sửa code.

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
    *   Đọc code kỹ lưỡng để xác minh giả thuyết.

4.  **Đánh giá Tác động (Impact Analysis):**
    *   Xác định lỗi này ảnh hưởng cục bộ (một màn hình) hay toàn cục?
    *   Có ảnh hưởng đến dữ liệu hay các tính năng liên quan không?

5.  **Lập Báo cáo (Report Generation):**
    *   Tổng hợp thông tin và đưa ra giải pháp đề xuất (nhưng KHÔNG thực thi).

## 📊 Báo cáo Điều tra (Standard Format)

Kết quả điều tra **BẮT BUỘC** phải trình bày theo cấu trúc sau:

### 1. Nguyên nhân
*   Mô tả chi tiết tại sao lỗi xảy ra (Root Cause).
*   Chỉ rõ file và dòng code gây lỗi (nếu tìm thấy).

### 2. Phạm vi ảnh hưởng
*   Lỗi ảnh hưởng đến những màn hình/tính năng nào?
*   Mức độ nghiêm trọng (Blocker/Major/Minor).
*   Rủi ro side-effect nếu sửa.

### 3. Cách xử lý
*   Mô tả giải pháp logic để sửa lỗi.
*   Cung cấp đoạn code gợi ý (Snippet) để Developer tham khảo.
*   **Lưu ý:** KHÔNG được dùng tool `replace` hay `write_file` để sửa code.

## 💡 Hướng dẫn cho Gemini
*   Bạn đóng vai trò là "Thám tử" (Detective), không phải "Thợ sửa chữa".
*   Nhiệm vụ kết thúc sau khi báo cáo được đưa ra.
*   Nếu người dùng muốn sửa, họ sẽ dùng lệnh `/fix` hoặc yêu cầu cụ thể sau đó.