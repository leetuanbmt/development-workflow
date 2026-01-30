---
description: "Auto-generate Data Layer (Model, Entity, Mapper) from JSON specs."
trigger: /integrate-api
version: "3.1.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Code generated", "Verification complete"]
---

# 🔌 Robust API Integration

**Objective:** Generate Clean Architecture Data Layer code with proper Null Safety and Type checking.

## 🔄 Execution Flow

### 1. Spec Analysis
- Read JSON Response or Swagger/OpenAPI spec.
- **Naming Audit:** API is often `snake_case` → Client code should be standard (e.g., `camelCase` for JS/Dart, `snake_case` for Python). Use serialization annotations if needed (`@JsonKey`, `@JsonProperty`).
- **Type Audit:** Which fields can be `null`? Which are `List`? Are dates strings or timestamps?

### 2. Code Generation Plan
AI must generate code in dependency order:
1. **Model/DTO (Data):** Handles serialization/deserialization.
2. **Entity (Domain):** Pure business object, no framework annotations.
3. **Mapper:** Logic to transform DTO ↔ Entity (Handle null fallback here).

### 3. Verification
- Verify type mapping matches business logic (e.g., does `status` return `int` or `String`?).
- Ensure breaking changes in API don't crash the app (defensive parsing).

## 🔌 Skill Integration

**Active skill:** `code-reviewer`

Applied during **Step 3 (Verification):**
- Validates generated code follows Clean Architecture.
- Checks naming conventions.
- Ensures proper null safety handling.
- Reviews mapper pattern implementation.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Mapper Pattern:** Data transformation logic must be in Mapper, NEVER in UI or Repository.
- **Fallback:** If a nullable field is missing, should Mapper map to a default value or keep `null`? (Ask User or follow Project Convention).
