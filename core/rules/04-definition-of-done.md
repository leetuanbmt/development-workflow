---
trigger: always_on
description: Quy chuẩn về Definition of Ready (DoR), Definition of Done (DoD) và Quản lý Artifacts.
---

# ✅ Definition of Done & Ready Standards

AI phải tuân thủ nghiêm ngặt các tiêu chuẩn này trước khi bắt đầu (DoR) và trước khi kết thúc (DoD) bất kỳ task nào.

## 1. Definition of Ready (DoR) - Cổng vào
Trước khi bắt đầu thực thi task (`/start-task` → Blueprint), cần đảm bảo:

*   **Requirement rõ ràng:** Có User Story và ít nhất 3 Acceptance Criteria.
*   **Design/UI:** Có mô tả chi tiết hoặc wireframe về các trạng thái (Loading, Error, Empty, Success).
*   **API Contract:** Nếu feature gọi API, phải có mô tả JSON request/response mẫu hoặc Swagger.

> **Quy tắc Routing:** Nếu thiếu DoR -> AI phải từ chối code ngay và đề xuất chạy `/document` để hoàn thiện hồ sơ trước.

## 2. Standard Artifacts - Quy hoạch tài liệu
Mọi tài liệu sinh ra phải được lưu trữ đúng chỗ:

*   **Feature Specs:** `docs/specs/[feature_name]/SPEC.md`
*   **Architecture Decision Records (ADR):** `docs/adr/YYYY-MM-DD-[title].md`
*   **Tech Design:** `docs/design/[feature_name]/TECHNICAL_DESIGN.md`
*   **Manual Test Plan:** `docs/qa/[feature_name]/TEST_PLAN.md`

## 3. Definition of Done (DoD) - Cổng ra
Một tính năng chỉ được xem là hoàn thành khi pass **Verification Loop**:

| Phase | Metric | Threshold |
|:---|:---|:---|
| **Syntax** | No compilation errors | 0 errors |
| **Logic** | Unit tests pass | 100% of new tests pass |
| **Integration** | E2E/Manual tests pass | Critical paths only |
| **Security** | No secrets exposed | 0 findings |

### Kỹ thuật (Technical)
*   [ ] **Clean Architecture:** Đảm bảo đúng layer separation.
*   [ ] **Code Quality:** Không còn lỗi lint, không còn log thừa.
*   [ ] **Verification:** Đã chạy bộ lệnh verify tương ứng của stack.

### Sản phẩm (Product/UX)
*   [ ] **UI States:** Xử lý đủ các trạng thái UI.
*   [ ] **Error Handling:** Thông báo lỗi thân thiện, không crash.
*   [ ] **I18n:** Không hardcode string, dùng resource file.

## 4. PR Handover Standard
Khi kết thúc task, AI phải tạo nội dung PR Description theo mẫu sau để Dev copy:

```markdown
## 📝 Pull Request Summary
**Feature:** [Tên tính năng]
**Related Issue:** #[Issue ID]

### 🏗 Changes
- [Architecture] Added Domain entities: `UserEntity`...
- [UI] Created `FeaturePage` with states (Loading, Error...).
- [Data] Implemented `RepositoryImpl` with ORM/Client.

### ✅ Verification (DoD Check)
- [ ] `make lint` passed.
- [ ] `make test` passed.
- [ ] UI tested on [Device Name].

### 📸 Screenshots
| Loading | Success | Error |
|---------|---------|-------|
| (Paste) | (Paste) | (Paste)|
```
