---
trigger: manual
description: Quy trình kiểm thử (QA), Validation và Workflows.
---

# 🛡️ the project - QA & Validation Process

## 1. Validation Strategy (Chiến lược kiểm thử)

### A. Unit Testing
*   **Phạm vi:** Domain (UseCases), Data (Repository logic, Mapper), Presentation (Bloc States).
*   **Công cụ:** `flutter_test`, `bloc_test`, `mockito`.
*   **Lệnh:** `make test` (chạy toàn bộ) hoặc `flutter test path/to/file.dart`.
*   **Yêu cầu:** Test case phải bao phủ:
    *   Happy Path (Luồng chạy đúng).
    *   Edge Cases (Null, Empty List, Network Error).

### B. UI/Widget Testing
*   Hạn chế viết Widget Test phức tạp trừ khi cần kiểm tra các Custom Widget quan trọng.

### C. Linting & Static Analysis
*   Luôn chạy `make lint` trước khi tạo PR.
*   Không được ignore các warning quan trọng liên quan đến `const` và `types`.

## 2. Workflows (Quy trình làm việc với Agent)

Dự án có sẵn các quy trình tự động hóa cho Agent. Sử dụng các lệnh sau để kích hoạt:

| Lệnh (Trigger) | Workflow File | Mục đích |
| :--- | :--- | :--- |
| `/investigate` | `workflows/investigate.md` | Phân tích và tìm nguyên nhân Bug (Root Cause Analysis). |
| `/review-pr` | `workflows/review-pr.md` | Review code PR từ thành viên khác theo checklist. |

## 3. Checklist khi Review Code
Sử dụng workflow `/review_pr` để tự động hóa, nhưng cần nhớ các điểm chính:
1.  **Architecture:** Code có đặt đúng layer không?
2.  **Performance:** Có rebuild thừa không? Có dùng `const` constructor không?
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
