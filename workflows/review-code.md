---
description: "Review code chi tiết, bắt buộc kiểm tra tuân thủ DoD, Lint và Test."
trigger: /review-code
---

# 🧐 Review Code (DoD Enforced)

**Mục tiêu:** Kiểm tra chất lượng code không chỉ bằng mắt (logic) mà còn bằng tiêu chuẩn DoD (Lint, Test, Arch).

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Xác định Phạm vi & Chuẩn bị:**
    *   **Phạm vi:** File, Folder hoặc Feature.
    *   **Context:** Đọc `04-definition-of-done.md` và `analysis_options.yaml` để hiểu luật chơi.

2.  **Thực thi "QA Simulation" (AI đóng vai CI):**
    Trước khi đọc logic, hãy thử chạy (hoặc giả lập chạy) các lệnh chất lượng:
    *   **Lint:** Code có vi phạm rules trong `analysis_options.yaml` không? (Vd: `prefer_single_quotes`, `require_trailing_commas`).
    *   **Arch:** Có vi phạm Clean Arch (Domain import Flutter, Data gọi UI)?
    *   **Test:** Tính năng này đã có Unit Test/Widget Test chưa? (Kiểm tra thư mục `test/`).

3.  **Phân tích Logic & UX:**
    *   **State Management:** BLoC/Cubit có xử lý đủ 4 trạng thái (Loading, Error, Success, Empty) không?
    *   **Safety:** Check Null Safety (`!`), Resource Disposal (Controller, Stream).
    *   **Performance:** Rebuild không cần thiết? Dùng `const` chưa?

## 📊 Mẫu Báo cáo Review (DoD Standard)

Kết quả review phải trả về theo định dạng sau:

### 1. DoD Checklist (Pass/Fail)
| Tiêu chí | Trạng thái | Ghi chú |
| :--- | :--- | :--- |
| **Lint/Format** | ✅ Pass / 🔴 Fail | (Nếu Fail, chỉ ra lỗi style) |
| **Clean Arch** | ✅ Pass / 🔴 Fail | (Kiểm tra Dependency Rule) |
| **Tests** | ✅ Có / ⚠️ Thiếu | (Unit test coverage) |
| **UI States** | ✅ Đủ / ⚠️ Thiếu | (Check Loading/Error UI) |

### 2. Chi tiết Vấn đề (Findings)
Phân loại lỗi theo mức độ ảnh hưởng:

*   🔴 **Critical (Chặn Merge):** Lỗi Logic, Crash, Vi phạm Arch nghiêm trọng.
*   🟡 **Major (Cần sửa):** Vi phạm Lint, Thiếu Test, Performance kém.
*   🔵 **Minor (Nên sửa):** Naming, Clean Code, Comment.

**Ví dụ:**
> 🔴 **Critical:** `user_repo_impl.dart` import `material.dart`. Vi phạm quy tắc Data Layer.
> 🟡 **Major:** Chưa có test cho `LoginUseCase`.

### 3. Đề xuất Sửa đổi (Refactor Plan)
Cung cấp code mẫu để fix lỗi Critical/Major.

---
*Lưu ý: Nếu code quá tệ (nhiều lỗi Critical), hãy đề nghị Reject và Refactor lại thay vì fix lặt vặt.*