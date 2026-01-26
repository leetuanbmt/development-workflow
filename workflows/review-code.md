---
description: "Review code chi tiết, bắt buộc kiểm tra tuân thủ DoD, Lint và Test."
trigger: /review-code
version: "2.4.0"
skills:
  - code-reviewer
---

# 🧐 Review Code (DoD Enforced)

**Mục tiêu:** Kiểm tra chất lượng code không chỉ bằng mắt (logic) mà còn bằng tiêu chuẩn DoD (Lint, Test, Arch).

## 🚀 Các bước thực hiện (Execution Steps)

1.  **MANDATORY: Kích hoạt Skill Chuyên môn (Skill Activation)**
    *   Đọc kỹ yêu cầu của user.
    *   Nếu yêu cầu chứa từ khóa: `memory leak`, `performance`, `slow`, `jank` -> **BẮT BUỘC** gọi skill `flutter-expert`.
    *   Nếu yêu cầu chứa từ khóa: `security`, `hack`, `token` -> **BẮT BUỘC** gọi skill `security-auditor`.
    *   Nếu không có từ khóa đặc biệt -> Gọi skill `code-reviewer`.
    *   *Lưu ý: Không được tự ý review bằng kiến thức chung (general knowledge) mà chưa kích hoạt skill.*

2.  **Xác định Phạm vi & Intent:**
    *   **Phạm vi:** File, Folder hoặc Feature.
    *   **Delegation (Quan trọng):**
        *   Nếu user hỏi về **Memory Leak**, **Performance**, **Jank**: ➡️ Gọi ngay skill `flutter-expert`.
        *   Nếu user hỏi về **Security**, **Privacy**: ➡️ Gọi skill `security-auditor`.
        *   Các trường hợp review logic, kiến trúc chung: ➡️ Dùng skill `code-reviewer`.

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