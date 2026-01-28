---
description: "Phân tích sâu nguyên nhân lỗi và xuất báo cáo điều tra theo Template chuẩn."
trigger: /investigate
version: "3.0.0"
skills:
  - bug-investigator
  - codebase_investigator
  - code-reviewer
---

# 🕵️ Bug Investigation Protocol

**Mục tiêu:** Tìm ra nguyên nhân gốc rễ (Root Cause) và đánh giá tác động, KHÔNG tự động sửa code.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Context Gathering (Thu thập thông tin):**
    *   Đọc log lỗi (nếu có).
    *   Đọc code tại vị trí nghi ngờ xảy ra lỗi.
    *   Sử dụng `codebase_investigator` để truy vết luồng dữ liệu (Data Trace).

2.  **Root Cause Analysis (Phân tích nguyên nhân):**
    *   Tại sao lỗi xảy ra? (Logic sai, Null pointer, Race condition, API change?).
    *   Xác minh giả thuyết bằng cách đối chiếu code.

3.  **Impact Analysis (Đánh giá tác động):**
    *   Lỗi này ảnh hưởng đến những file nào?
    *   Những màn hình/tính năng nào bị liên đới?

4.  **Report Generation (Xuất báo cáo):**
    *   Tổng hợp thông tin và in ra theo đúng Format yêu cầu bên dưới.

## 📝 Template Báo Cáo (BẮT BUỘC)

AI phải trả về kết quả chính xác theo định dạng sau:

```markdown
**Tên Vấn đề**
[Mô tả ngắn gọn lỗi là gì, ví dụ: Crash tại màn hình Camera khi bấm nút Back]

***Nguyên nhân***
[Giải thích kỹ thuật chi tiết. Ví dụ: Biến `controller` bị dispose trước khi gọi lệnh `stop()` do race condition giữa hàm `dispose` và `onPressed`.]

***Phạm vi ảnh hưởng***
- File chính: `path/to/file.dart`
- Module liên quan: [Liệt kê các module bị ảnh hưởng, ví dụ: Camera, Gallery]
- Rủi ro: [Ví dụ: Có thể gây memory leak nếu không sửa]

***Cách xử lý***
1. [Bước 1: Ví dụ - Thêm kiểm tra `mounted` trước khi gọi `setState`]
2. [Bước 2: Ví dụ - Wrap logic trong `try-catch`]
3. [Gợi ý Code Snippet nếu cần thiết]
```

## 💡 Hướng dẫn cho AI
*   **Fact-Check:** Nguyên nhân phải dựa trên bằng chứng trong code, không đoán mò.
*   **Concise:** Đi thẳng vào vấn đề kỹ thuật, không văn hoa.
*   **Solution:** Cách xử lý phải cụ thể (tên hàm, dòng code), để Auditor có thể dùng nó làm input cho lệnh `/fix` sau này.
