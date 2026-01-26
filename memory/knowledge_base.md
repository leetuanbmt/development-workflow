# 🧠 Project Knowledge Base

> **Version:** 2.4.0 | **Last Updated:** 2026-01-26

File này lưu trữ các bài học kinh nghiệm, lỗi đặc thù (Gotchas), và các quy tắc ngầm của dự án.

---

## 📑 Index

| ID | Category | Tags | Title |
|:--:|:--|:--|:--|
| KB-001 | Technical | `navigation`, `conflict` | GetX vs AutoRoute conflict |
| KB-002 | Technical | `android`, `build` | shrinkResources issue |
| KB-003 | Business | `input`, `currency` | Currency input limit |
| KB-004 | Pattern | `state`, `freezed` | Preferred State Pattern |
| KB-005 | Pattern | `widget`, `performance` | SizedBox vs Container |

---

## 🔧 Technical Gotchas

### KB-001: GetX vs AutoRoute Navigation Conflict
- **Tags:** `navigation`, `conflict`, `library`
- **Problem:** GetX xung đột Navigation Key với AutoRoute
- **Solution:** Không dùng GetX navigation khi project đã dùng AutoRoute
- **Discovered:** Initial setup

### KB-002: Android Release Build - shrinkResources
- **Tags:** `android`, `build`, `release`
- **Problem:** Build release crash khi dùng thư viện động
- **Solution:** Tắt `shrinkResources` trong `build.gradle`
- **Discovered:** Release v1.0

---

## 📋 Business Rules

### KB-003: Currency Input Maximum Digits
- **Tags:** `input`, `currency`, `validation`
- **Rule:** Mọi màn hình nhập liệu tiền tệ phải support tối đa 12 số
- **Reason:** Yêu cầu từ khách hàng Nhật Bản
- **Applies to:** All currency input fields

---

## 🎯 Preferred Patterns

### KB-004: State Management with Freezed
- **Tags:** `state`, `freezed`, `bloc`
- **Pattern:** Sử dụng Unified State (single class + status enum) thay vì Union Cases cho Feature Bloc
- **Reason:** Dễ giữ data khi refresh, hỗ trợ nhiều trạng thái đồng thời
- **Exception:** Small components (ButtonBloc) có thể dùng Union

### KB-005: SizedBox for Spacing
- **Tags:** `widget`, `performance`, `ui`
- **Pattern:** Luôn dùng `SizedBox` thay vì `Container` để tạo khoảng cách
- **Reason:** Performance tốt hơn, Container có overhead không cần thiết

---

## 🏷️ Tag Reference

| Tag | Description |
|:--|:--|
| `android` | Android specific |
| `ios` | iOS specific |
| `build` | Build/Release related |
| `navigation` | Routing/Navigation |
| `state` | State management |
| `performance` | Performance optimization |
| `ui` | UI/Widget related |
| `bloc` | BLoC pattern |
| `freezed` | Freezed library |
| `database` | Drift/SQLite |
| `api` | Network/API |
| `camera` | Camera feature |
| `qr` | QR code feature |

---

## 📝 Hướng dẫn Sử dụng

### Cho AI Agent
1. **READ:** Luôn đọc file này khi chạy `/start-task`
2. **SEARCH:** Tìm theo Tags hoặc ID trong Index
3. **WRITE:** Sau khi fix bug khó, thêm entry mới theo format

### Thêm Entry Mới
```markdown
### KB-XXX: [Title]
- **Tags:** `tag1`, `tag2`
- **Problem/Pattern/Rule:** [Mô tả]
- **Solution/Reason:** [Giải thích]
- **Discovered:** [Date hoặc Context]
```
