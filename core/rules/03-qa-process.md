---
trigger: manual
description: Quy trình kiểm thử (QA), Validation và Workflows.
---

# 🛡️ the project - QA & Validation Process

## 1. Validation Strategy (Chiến lược kiểm thử)

### A. Unit Testing
*   **Phạm vi:** Domain (UseCases), Data (Repository logic, Mapper), Presentation (State Logic).
*   **Công cụ:** Sử dụng Testing Framework phù hợp với ngôn ngữ (VD: `test`, `mock`).
*   **Lệnh:** Chạy lệnh test chuẩn của dự án (VD: `make test`).
*   **Yêu cầu:** Test case phải bao phủ:
    *   Happy Path (Luồng chạy đúng).
    *   Edge Cases (Null, Empty List, Network Error).

### B. UI/Integration Testing
*   Hạn chế viết UI Test phức tạp trừ khi cần kiểm tra các flow quan trọng.

### C. Linting & Static Analysis
*   Luôn chạy bộ lệnh lint (`npm run lint`, `dart analyze`, v.v.) trước khi tạo PR.
*   Không được ignore các warning quan trọng liên quan đến types và security.

## 2. Verification Loop (Quy chuẩn bắt buộc)

Mọi thay đổi phải đi qua vòng lặp kiểm tra:

| Phase | Metric | Threshold |
|:---|:---|:---|
| **Syntax** | No compilation errors | 0 errors |
| **Logic** | Unit tests pass | 100% of new tests |
| **Integration** | E2E/Manual test pass | Critical paths only |
| **Security** | No secrets exposed | 0 findings |

## 3. Workflows (Quy trình làm việc với Agent)

Dự án sử dụng bộ lệnh CLI đã được cấu hình:

| Lệnh (Trigger) | Mục đích | Skill Active |
| :--- | :--- | :--- |
| `/start-task` | Chốt Blueprint & Plan trước khi code. | Product Manager |
| `/fix` | Sửa bug hệ thống. | Bug Investigator |
| `/review` | Review code & UI/UX. | Code Reviewer |
| `/audit` | Kiểm tra sâu Arch/Security/Performance. | Tech Lead |
| `/write-test` | Tạo tự động bộ test suite. | Test Engineer |

## 3. Checklist khi Review Code
Sử dụng workflow `/review_pr` để tự động hóa, nhưng cần nhớ các điểm chính:
1.  **Architecture:** Code có đặt đúng layer không?
2.  **Performance:** Có tối ưu bộ nhớ và hiệu năng không?
3.  **Clean Code:** Tên biến dễ hiểu? Hàm có quá dài (>50 dòng) không?
4.  **Security:** Không hardcode API Key/Token.

## 4. Định dạng Báo cáo Test (Validation Report)
Khi được yêu cầu viết test hoặc validate feature mới, hãy báo cáo theo mẫu:

```markdown
# Validation Report
## 1. Scope
- Tested feature: [Tên tính năng]
- Files covered: [Danh sách file]

## 2. Test Cases Created
- ✅ [Test Case 1]: Passed
- ✅ [Test Case 2]: Passed
- ⚠️ [Test Case 3]: Pending/Issues

## 3. Notes
- [Ghi chú về lỗi tiềm ẩn hoặc cần refactor]
```
