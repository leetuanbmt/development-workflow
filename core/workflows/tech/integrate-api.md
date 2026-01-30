---
description: "Auto-generate Data Layer (Model, Entity, Mapper) from JSON specs."
trigger: /integrate-api
version: "3.0.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Code generated", "Verification complete"]
skill: feature-architect
---

# 🔌 Robust API Integration

**Objective:** Generate Clean Architecture Data Layer code with proper Null Safety.

## 🔄 Execution Flow

### 1. Spec Analysis
- Read JSON Response
- **Naming Audit:** JSON is `snake_case` → Dart must be `camelCase`. Must use `@JsonKey(name: '...')`.
- **Type Audit:** Which fields can be `null`? Which are `List`?

### 2. Code Generation Plan
AI must generate code in dependency order:
1. **Model (Data):** Contains `fromJson`/`toJson`
2. **Entity (Domain):** Pure Dart class, no serialization annotations (except Freezed)
3. **Mapper:** Extension method `toEntity()` (Handle null fallback here)

### 3. Verification
- User verifies type mapping matches business logic (e.g., does `status` return `int` or `String`?)

## 🔌 Skill Integration

**Active skill:** `code-reviewer`

Applied during **Step 3 (Verification):**
- Validates generated code follows Clean Architecture
- Checks naming conventions (snake_case → camelCase)
- Ensures proper null safety handling
- Reviews mapper pattern implementation

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Mapper Pattern:** Data transformation logic must be in Mapper, NEVER in UI or Repository
- **Fallback:** If `String?` field is null, should Mapper map to `""` or keep `null`? (Ask User or follow Convention)