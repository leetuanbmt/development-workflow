---
trigger: always_on
description: "Architecture rules for {{PROJECT_NAME}}"
---

# Architecture Rules: {{PROJECT_NAME}}

**Version:** 1.0.0  
**Last Updated:** {{DATE}}

---

## 1. Architectural Pattern

**Pattern:** {{ARCHITECTURE_PATTERN}}

### Layers

```
┌─────────────────────────────────────────┐
│       Presentation Layer (UI)           │ ← User interactions, UI components
├─────────────────────────────────────────┤
│    Domain Layer (Business Logic)        │ ← Entities, Use Cases, Interfaces
├─────────────────────────────────────────┤
│    Data Layer (External Integration)    │ ← APIs, Databases, Services
└─────────────────────────────────────────┘
```

### Dependency Flow

- **Allowed:** `Presentation → Domain ← Data` (one direction only)
- **Forbidden:** Upward dependencies, circular imports
- **Abstraction:** Domain defines interfaces; Data implements them

---

## 2. Layer-Specific Rules

### Domain Layer (Core Business Logic)

**Responsibility:** Define business entities and use cases

**Rules:**

- [ ] No framework dependencies ({{FRAMEWORK_NAME}} imports forbidden)
- [ ] No external API calls (use repositories)
- [ ] No UI references
- [ ] All entities must be immutable (use `{{IMMUTABLE_TECH}}`)
- [ ] All use cases return **Result** types (success/failure)

**Example Structure:**

```
domain/
├── entities/
│   └── {{entity_name}}.dart
├── repositories/
│   └── {{repo_name}}_repository.dart    (abstract interface)
└── use_cases/
    └── {{use_case_name}}_use_case.dart
```

### Data Layer (External Integration)

**Responsibility:** Fetch/persist data from external sources

**Rules:**

- [ ] Implement domain layer interfaces (repositories)
- [ ] DTOs must map to domain entities via mappers
- [ ] All API errors must be converted to domain exceptions
- [ ] Implement caching strategy ({{CACHING_STRATEGY}})
- [ ] No business logic (only data transformation)

**Example Structure:**

```
data/
├── data_sources/
│   ├── {{name}}_remote_data_source.dart
│   └── {{name}}_local_data_source.dart
├── models/
│   └── {{name}}_dto.dart              (serializable)
├── repositories/
│   └── {{name}}_repository_impl.dart  (implements domain interface)
└── mappers/
    └── {{name}}_mapper.dart           (DTO ↔ Entity)
```

### Presentation Layer (User Interface)

**Responsibility:** Display data and handle user interactions

**Rules:**

- [ ] Use {{STATE_MANAGEMENT}} for state management
- [ ] No direct API calls (use repository from domain)
- [ ] Each page has corresponding BLoC/StateManager
- [ ] All non-matching states trigger error dialogs
- [ ] Navigation only via router (no direct Navigator calls)

**Example Structure:**

```
presentation/
├── pages/
│   └── {{page_name}}_page.dart
├── widgets/
│   └── {{widget_name}}.dart
├── {{feature}}_bloc/
│   ├── bloc.dart
│   ├── event.dart
│   ├── state.dart
│   └── repository.dart
└── routes/
    └── routes.dart
```

---

## 3. Code Generation & Build Tools

### Code Generation

- [ ] Run `{{CODE_GEN_COMMAND}}` after any `.dart` changes involving:
  - `@freezed` classes
  - `@injectable` dependencies
  - `@JsonSerializable` models

- **Tool:** {{CODE_GEN_TOOL}}
- **Check Generated Files:** Verify new `.g.dart` and `.freezed.dart` files

### Build & Compilation

- **Build Command:** `{{BUILD_COMMAND}}`
- **Check Output:** No warnings allowed (see {{LINT_CONFIG}})

---

## 4. Dependency Injection Rules

**Framework:** {{DI_FRAMEWORK}}

- [ ] All external dependencies injected via {{DI_FRAMEWORK}}
- [ ] No singleton factories without `@singleton` annotation
- [ ] Dependencies registered in `{{DI_SETUP_FILE}}`

### Example

```
{{DI_EXAMPLE}}
```

---

## 5. Error Handling

### Exception Hierarchy

```
CustomException (domain)
├── ValidationException
├── NetworkException
├── CacheException
└── ServerException
```

### Handling Strategy

- [ ] ALL network calls wrapped in try-catch
- [ ] all errors converted to domain exceptions
- [ ] User-friendly messages in presentation layer
- [ ] Critical errors logged via {{LOGGING_TOOL}}

---

## 6. State Management ({{STATE_MANAGEMENT}})

### Rules

- {{STATE_MANAGEMENT_RULE_1}}
- {{STATE_MANAGEMENT_RULE_2}}
- {{STATE_MANAGEMENT_RULE_3}}

### Example BLoC

```
{{BLOC_EXAMPLE}}
```

---

## 7. Testing Architecture

### Test Structure

```
test/
├── unit/                    (domain + data logic)
│   ├── domain/
│   │   └── use_cases/
│   └── data/
│       └── repositories/
├── integration/             (cross-layer tests)
│   └── features/
└── widget/                  (UI component tests)
    └── presentation/
```

### Test Requirements

- **Unit:** ≥ {{UNIT_COVERAGE}}% coverage
- **Integration:** {{INTEGRATION_TEST_COUNT}} scenarios
- **Widget:** Critical screens only
- **Command:** `{{TEST_COMMAND}}`

---

## 8. API Integration Rules

### REST API Standards

- **Base URL:** {{API_BASE_URL}}
- **Auth Header:** `Authorization: Bearer {{TOKEN_KEY}}`
- **Timeout:** {{API_TIMEOUT}}ms
- **Retry:** {{RETRY_STRATEGY}}

### Response Handling

```json
// Success (200, 201)
{ "data": {...}, "message": "OK" }

// Error (4xx, 5xx)
{ "error": "message", "code": "ERROR_CODE" }
```

---

## 9. Database Conventions

### Naming

- **Tables:** snake_case plural (`users`, `products`)
- **Columns:** snake_case (`user_id`, `created_at`)
- **Primary Keys:** `id` (auto-increment)
- **Foreign Keys:** `{table}_id` (e.g., `user_id`)
- **Timestamps:** `created_at`, `updated_at` (UTC)

### Migrations

**Tool:** {{MIGRATION_TOOL}}

- [ ] Migrations versionned and committed
- [ ] Data migrations include rollback
- [ ] Syntax tested locally before pushing

---

## 10. Performance Rules

### Bundle Size

- **Target:** {{BUNDLE_SIZE_TARGET}}MB
- **Check:** `{{BUNDLE_SIZE_CHECK_CMD}}`

### Load Time

- **First Paint:** {{FIRST_PAINT_TARGET}}ms
- **Interaction Ready:** {{TTI_TARGET}}ms

### Memory

- **Peak Usage:** {{MEMORY_TARGET}}MB
- **Profiling Tool:** {{MEMORY_PROFILER}}

---

## 11. Code Review Checklist (for Reviewers)

- [ ] Respects layer separation
- [ ] No circular dependencies
- [ ] Test coverage adequate
- [ ] Error handling complete
- [ ] No hardcoded values
- [ ] Naming clear & consistent
- [ ] API contract followed
- [ ] Performance acceptable
- [ ] Security standards met

---

## 12. Common Pitfalls & Fixes

| Issue         | Symptom       | Fix       |
| ------------- | ------------- | --------- |
| {{PITFALL_1}} | {{SYMPTOM_1}} | {{FIX_1}} |
| {{PITFALL_2}} | {{SYMPTOM_2}} | {{FIX_2}} |
| {{PITFALL_3}} | {{SYMPTOM_3}} | {{FIX_3}} |

---

## 13. Tools & Commands Quick Reference

```bash
# Code generation
{{CODE_GEN_COMMAND}}

# Linting
{{LINT_COMMAND}}

# Testing
{{TEST_COMMAND}}

# Build
{{BUILD_COMMAND}}

# Profiling
{{PROFILING_COMMAND}}
```
