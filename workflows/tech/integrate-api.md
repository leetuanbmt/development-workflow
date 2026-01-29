---
description: "Tự động sinh Data Layer (Model, Entity, Mapper) từ JSON specs."
trigger: /integrate-api
version: "3.0.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Code generated", "Verification complete"]
---

# 🔌 Robust API Integration

**Objective:** Sinh code Data Layer chuẩn Clean Architecture, xử lý Null Safety triệt để.

## 🔄 Execution Flow

### 1. Spec Analysis
*   Đọc JSON Response.
*   **Naming Audit:** JSON là `snake_case` -> Dart phải là `camelCase`. Phải dùng `@JsonKey(name: '...')`.
*   **Type Audit:** Trường nào có thể `null`? Trường nào là `List`?

### 2. Code Generation Plan
AI phải sinh code theo thứ tự phụ thuộc:
1.  **Model (Data):** Chứa `fromJson`/`toJson`.
2.  **Entity (Domain):** Class thuần Dart, không có annotation serialization (trừ Freezed).
3.  **Mapper:** Extension method `toEntity()` (Xử lý null fallback tại đây).

### 3. Verification
*   User kiểm tra xem type mapping có đúng nghiệp vụ không (Ví dụ: `status` trả về `int` hay `String`?).

## 💡 AI Guidelines
*   **Mapper Pattern:** Logic biến đổi data (Data Transformation) phải nằm trong Mapper, tuyệt đối không nằm trong UI hay Repository.
*   **Fallback:** Nếu trường `String?` bị null, Mapper nên map về `""` hay giữ nguyên `null`? (Hỏi User hoặc theo Convention).