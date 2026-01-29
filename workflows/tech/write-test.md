---
description: "Viết Unit/Widget Test có chiến lược (Strategy-based Testing)."
trigger: /write-test
version: "3.0.0"
skills:
  - test-engineer
  - code-reviewer
constraints:
  max_iterations: 4
  timeout_minutes: 25
  exit_on: ["Tests written", "Tests passed"]
---

# 🧪 Strategic Testing

**Mục tiêu:** Viết test để bắt lỗi (Catch bugs), không phải viết test để đủ số lượng (Not just coverage).

## 🔄 Quy trình (Execution Flow)

### 1. Test Strategy (Lập chiến lược)
Trước khi code, AI phải liệt kê các trường hợp cần test:
*   ✅ **Happy Path:** Luồng chính phải chạy đúng.
*   ⚠️ **Edge Cases:** Null input, Empty List, Network Error, Timeout.
*   🛡️ **Security:** Test quyền truy cập (nếu có).

### 2. Mocking Setup
*   Xác định dependencies cần mock.
*   Đảm bảo `mocktail` hoặc `mockito` được cấu hình đúng `setUp` và `tearDown`.

### 3. Implementation (AAA Pattern)
*   **Arrange:** Chuẩn bị dữ liệu giả.
*   **Act:** Gọi hàm cần test.
*   **Assert:** Kiểm tra kết quả output VÀ side-effects (verify hàm mock được gọi mấy lần).

## 💡 Hướng dẫn cho AI
*   **Không Hardcode:** Sử dụng thư viện `faker` (nếu có) hoặc factory để tạo data test.
*   **Readable Names:** Tên test case phải như một câu văn (VD: `should return Error when API fails`).