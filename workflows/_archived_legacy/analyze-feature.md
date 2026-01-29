---
description: "Phân tích sâu logic, luồng dữ liệu và kiến trúc của một tính năng để hiểu rõ ngữ cảnh nghiệp vụ."
trigger: /analyze-feature
version: "2.4.0"
---

# 🧠 Phân tích Tính năng (Feature Analysis & Understanding)

**Mục tiêu:** "Đọc hiểu" tính năng thay vì chỉ kiểm tra cú pháp. Xây dựng bản đồ mental model về cách tính năng hoạt động từ UI xuống Database.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Xác định Điểm vào (Entry Point Discovery):**
    *   Tìm các **Page/Screen** chính của tính năng trong `presentation/pages`.
    *   Kiểm tra `AutoRoute` configuration để biết tính năng này được điều hướng tới từ đâu và có tham số (arguments) gì không.

2.  **Truy vết Luồng dữ liệu (Data Flow Mapping):**
    *   **UI Layer:** Người dùng tương tác gì? (Tap button, scroll, input).
    *   **State Layer (BLoC):** Các sự kiện (Events) nào được bắn ra? State thay đổi như thế nào?
    *   **Domain Layer:** UseCase nào được gọi? Logic nghiệp vụ nằm ở đâu?
    *   **Data Layer:** Dữ liệu lấy từ API (Retrofit) hay DB (Drift)? Cấu trúc bảng (Table) ra sao?

3.  **Trích xuất Logic Nghiệp vụ (Business Logic Extraction):**
    *   Tìm các điều kiện `if/else`, `switch` quan trọng trong BLoC hoặc UseCase.
    *   Xác định các quy tắc validation (ví dụ: không cho phép lưu nếu thiếu tên, logic tính toán giá trị...).

4.  **Phân tích Phụ thuộc (Dependency Analysis):**
    *   Tính năng này phụ thuộc vào các Service chung nào (`UserSession`, `Connectivity`, `Permission`...)?
    *   Có sử dụng các package bên ngoài đặc biệt nào không?

## 📊 Cấu trúc Báo cáo Phân tích

Báo cáo này giúp Reviewer/Developer hiểu rõ "Cái gì" và "Tại sao" trước khi đi vào chi tiết "Như thế nào".

### 1. Tổng quan Tính năng (Overview)
*   **Tên tính năng:** [Tên]
*   **Mục đích:** [Tính năng này giải quyết vấn đề gì cho người dùng?]
*   **Thành phần chính:** [Liệt kê các Screen, Bloc, Table quan trọng]

### 2. Bản đồ Kiến trúc (Architecture Map)
Mô tả luồng đi của dữ liệu:
> `User Action` -> `Bloc Event` -> `UseCase` -> `Repository` -> `Source`

### 3. Logic Nghiệp vụ Cốt lõi (Key Business Logic)
*   **Quy tắc 1:** [Mô tả quy tắc tìm thấy trong code]
*   **Quy tắc 2:** ...
*   **Edge Cases:** [Các trường hợp đặc biệt đã được xử lý hoặc chưa]

### 4. Ghi chú cho Reviewer (Notes for Review)
*   [Phần code này khá phức tạp, cần review kỹ]
*   [Có vẻ logic này đang lặp lại code của tính năng X]
*   [Thiếu xử lý lỗi khi mất mạng ở UseCase Y]

## 💡 Hướng dẫn sử dụng
*   Chạy workflow này **TRƯỚC** khi chạy `/review_code` hoặc `/review_pr` đối với các tính năng lớn/phức tạp.
*   Input nên là đường dẫn thư mục feature (ví dụ: `lib/features/kotei`).
