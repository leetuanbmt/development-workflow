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

### 🛡️ Edge Case Coverage (CRITICAL - v5.3.1)

**Rule:** Code KHÔNG được merge nếu thiếu xử lý các case abnormal phổ biến.

#### 📋 Category 1: Input Validation (ALWAYS FIRST)
*   [ ] **Null/Undefined:** Check `if (!value)` trước khi access properties
*   [ ] **Empty Collections:** Validate `.length > 0` trước khi iterate
*   [ ] **Invalid Type:** TypeScript guards hoặc runtime type check
*   [ ] **Boundary Values:** Test với 0, -1, MAX_INT, empty string
*   [ ] **Special Characters:** Handle quotes, HTML tags, emoji trong user input
*   [ ] **Injection Prevention:** Sanitize input trước khi pass vào SQL/HTML/Shell

#### 🌐 Category 2: Network & External Dependencies
*   [ ] **Timeout Protection:** Mọi API call phải có timeout (default 30s)
*   [ ] **Network Offline:** Handle `NetworkException` hoặc check connectivity
*   [ ] **HTTP Errors:** Xử lý riêng 4xx (client) vs 5xx (server)
*   [ ] **Malformed Response:** Validate API response schema trước khi parse
*   [ ] **Retry Logic:** Implement exponential backoff cho transient errors
*   [ ] **Race Conditions:** Handle concurrent requests (debounce/throttle)

#### 💾 Category 3: State & Resource Management
*   [ ] **Memory Limits:** Handle OOM gracefully (pagination, lazy loading)
*   [ ] **Disk Full:** Catch storage exceptions, show user-friendly error
*   [ ] **Permission Denied:** Request permissions trước, handle rejection
*   [ ] **Resource Locked:** Handle file/DB already in use
*   [ ] **Cleanup in Finally:** Always release resources (close files, connections)
*   [ ] **Concurrent Modification:** Lock/version check khi update shared state

#### 🔐 Category 4: Security & Authorization
*   [ ] **Unauthenticated User:** Redirect to login, don't crash
*   [ ] **Unauthorized Access:** Return 403, log attempt
*   [ ] **Rate Limiting:** Handle 429 Too Many Requests
*   [ ] **Token Expiry:** Auto-refresh token hoặc re-authenticate
*   [ ] **CSRF/XSS Prevention:** Use framework protections, sanitize output

#### 🖱️ Category 5: User Behavior (UI/UX)
*   [ ] **Double Click:** Disable button after first click
*   [ ] **Back Button:** Save state hoặc confirm navigation
*   [ ] **Page Refresh:** Persist critical data to localStorage
*   [ ] **Slow Device:** Show loading indicators for operations > 500ms
*   [ ] **Screen Rotation:** UI adapts to landscape/portrait
*   [ ] **Accessibility:** Screen reader support, keyboard navigation

#### 🚫 Auto-Fail Conditions (MUST FIX)

Code bị **REJECT** nếu có bất kỳ pattern nào sau:

```typescript
// ❌ CRITICAL FAILURES
user.name  // No null check
await api.call()  // No try-catch
items[0]  // No length check
JSON.parse(data)  // No validation
fetch(url)  // No timeout
localStorage.set()  // No quota check
file.write()  // No finally cleanup
```

### Kỹ thuật (Technical)
*   [ ] **Clean Architecture:** Đảm bảo đúng layer separation.
*   [ ] **Code Quality:** Không còn lỗi lint, không còn log thừa.
*   [ ] **Verification:** Đã chạy bộ lệnh verify tương ứng của stack.
*   [ ] **Edge Cases:** Đã pass checklist 5 categories phía trên ✅

### Sản phẩm (Product/UX)
*   [ ] **UI States:** Xử lý đủ các trạng thái: Loading, Success, Error, Empty.
*   [ ] **Error Handling:** Thông báo lỗi thân thiện, actionable (có button retry).
*   [ ] **I18n:** Không hardcode string, dùng resource file.
*   [ ] **Graceful Degradation:** App không crash khi gặp unexpected error.

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
