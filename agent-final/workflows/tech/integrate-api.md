---
description: "Auto-generate Data Layer (Model, Entity, Mapper) from JSON specs."
trigger: /integrate-api
version: "5.2.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Code generated", "Verification complete"]
---

# 🔌 Robust API Integration

**Objective:** Generate Clean Architecture Data Layer code with proper Null Safety.

## 🔄 Execution Flow

### 1. Spec Analysis
- Read JSON Response
- **Naming Audit:** JSON is `snake_case` → Code must follow language convention (e.g. `camelCase`).
- **Type Audit:** Which fields can be `null`? Which are `List`?

### 2. Code Generation Plan
AI must generate code in dependency order using project tools:
1. **Model (Data):** Use `@freezed` and `@JsonSerializable`. 
2. **Entity (Domain):** Pure Class with `@freezed` (no JSON annotations).
3. **Mapper:** Transformation method `toEntity()` (Handle null fallback here).
4. **Network:** Use `retrofit` annotations (`@GET`, `@POST`) in the API interface.

*Note: Remind user to run `dart run build_runner build -d` after generation.*

### 3. Verification
- User verifies type mapping matches business logic (e.g., does `status` return `int` or `String`?)

## 🔌 Skill Integration

**Active skill:** `code-reviewer`

Applied during **Step 3 (Verification):**
- Validates generated code follows Clean Architecture
- Checks naming conventions
- Ensures proper null safety handling
- Reviews mapper pattern implementation

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Mapper Pattern:** Data transformation logic must be in Mapper, NEVER in UI or Repository
- **Fallback:** If `String?` field is null, should Mapper map to `""` or keep `null`? (Ask User or follow Convention)