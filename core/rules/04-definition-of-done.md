---
trigger: always_on
description: Quy chuẩn về Definition of Ready (DoR), Definition of Done (DoD) và Quản lý Artifacts.
---

# ✅ Definition of Done & Ready Standards

AI phải tuân thủ nghiêm ngặt các tiêu chuẩn này trước khi bắt đầu (DoR) và trước khi kết thúc (DoD) bất kỳ task nào.

## 1. Definition of Ready (DoR) - Cổng vào
Trước khi bắt đầu code tính năng (`/implement-feature`), cần đảm bảo:

*   **Requirement rõ ràng:** Có User Story và ít nhất 3 Acceptance Criteria.
*   **Design/UI:** Có hình ảnh thiết kế, link Figma, hoặc mô tả chi tiết về các trạng thái (Loading, Error, Empty, Success).
*   **API Contract:** Nếu feature gọi API, phải có Swagger/Postman hoặc mô tả JSON request/response mẫu.
*   **Asset:** Các icon/ảnh cần thiết đã có sẵn hoặc có chỉ định dùng placeholder.

> **Quy tắc Routing:** Nếu thiếu DoR -> AI phải từ chối code ngay và đề xuất chạy `/write-spec` hoặc `/design-feature` để hoàn thiện hồ sơ trước.

## 2. Standard Artifacts - Quy hoạch tài liệu
Mọi tài liệu sinh ra phải được lưu trữ đúng chỗ, không để rải rác:

*   **Feature Specs:** `docs/specs/[feature_name]/SPEC.md`
*   **Architecture Decision Records (ADR):** `docs/adr/YYYY-MM-DD-[title].md`
*   **Tech Design:** `docs/design/[feature_name]/TECHNICAL_DESIGN.md`
*   **Manual Test Plan:** `docs/qa/[feature_name]/TEST_PLAN.md`

## 3. Definition of Done (DoD) - Cổng ra
Một tính năng chỉ được xem là hoàn thành khi:

### Kỹ thuật (Technical)
*   [ ] **Clean Architecture:** Đủ 3 layers (Domain, Data, Presentation).
*   [ ] **Code Quality:** Không còn lỗi Lint (`make lint` pass). Không còn `print` log thừa.
*   [ ] **Code Gen:** Dữ liệu generated (nếu có) không bị conflict.
*   [ ] **Tests:** 
    *   Unit Test cho UseCase và Repository.
    *   State/Logic Test cho UI Logic.
    *   UI/Snapshot Test (nếu được yêu cầu).

### Sản phẩm (Product/UX)
*   [ ] **UI States:** Đã xử lý đủ các trạng thái: `Initial`, `Loading`, `Success`, `Error`, `Empty`.
*   [ ] **Error Handling:** Có thông báo lỗi thân thiện cho người dùng (Toast/Dialog) chứ không crash app.
*   [ ] **I18n:** Các chuỗi text phải được tách ra file ngôn ngữ (Resource file), không hardcode string.

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
