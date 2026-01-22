---
description: "Tự động tạo Unit Test và Widget Test cho code hiện có."
trigger: /write-test
---

# 🧪 Viết Kiểm thử (Write Tests)

**Mục tiêu:** Tạo các file test tự động để đảm bảo logic code hoạt động đúng và ngăn chặn lỗi hồi quy (Regression).

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Phân tích Code (Code Analysis):**
    *   Đọc file nguồn cần test (UseCase, Repository, Bloc, hoặc Widget).
    *   Xác định các dependencies cần Mock (sử dụng `mockito` hoặc `mocktail`).

2.  **Lập kế hoạch Test Case:**
    *   **Happy Path:** Input đúng -> Output đúng.
    *   **Edge Cases:** Input null, empty, max value.
    *   **Error Cases:** API throw exception, Network error.

3.  **Viết Test Code:**
    *   Tạo file test tương ứng trong thư mục `test/`.
    *   Tuân thủ cấu trúc: `Arrange` (Chuẩn bị) -> `Act` (Thực thi) -> `Assert` (Kiểm tra).
    *   Sử dụng skill `test-engineer`.

4.  **Chạy & Xác minh (Run & Verify):**
    *   Chạy lệnh `flutter test path/to/test_file.dart`.
    *   Nếu test fail, phân tích nguyên nhân (do code sai hay test sai) và sửa.

## 📊 Checklist Chất lượng
- [ ] Tên test case rõ ràng, mô tả đúng hành vi.
- [ ] Mock được reset sau mỗi test (`setUp`/`tearDown`).
- [ ] Không phụ thuộc vào dữ liệu thật (DB/API) mà phải dùng Mock.

## 💡 Hướng dẫn cho Gemini
*   Luôn kiểm tra xem file test đã tồn tại chưa để append thêm case thay vì overwrite.
*   Ưu tiên test Domain Layer (UseCase) và Presentation Layer (Bloc) trước.
