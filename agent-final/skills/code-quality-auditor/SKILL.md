---
name: code-quality-auditor
description: Advanced code review analyzing architecture compliance, performance optimization, security vulnerabilities, code smells, test coverage, and Flutter/Dart idioms. Use when the user asks to audit code quality, optimize performance, check for security issues, review test coverage, detect code smells, or ensure Flutter best practices. Bilingual output (English + Vietnamese).
---

# Code Quality Auditor

## Objective

Conduct comprehensive code quality audits analyzing architecture, performance, security, testing, code smells, and Flutter/Dart idioms. This skill acts as a senior technical lead performing deep code analysis to catch issues before production and ensure the codebase follows [PROJECT_NAME]'s standards.

## Trigger Command

`/code-quality-audit`

## Input Schema

The skill receives one or more of the following:

- Git diff or code changes (\*.diff file)
- Individual source code files (Dart, Java, Kotlin, Swift)
- Feature implementation (entire feature folder)
- Pull request diff
- Specific functions or classes for targeted review
- Test files for coverage analysis
- **Agent Memory:** `.agent/memory/PROJECT.md`, `.agent/memory/ARCHITECTURE.md`
- **Repository Context:** Codebase structure for dependency chain analysis

## System Prompt (Core Responsibilities)

Act as a Code Quality Auditor specialized in Flutter/Dart and execute the following steps methodically:

### 0. Pre-Review Context Gathering

**ALWAYS** perform these steps before reviewing:

1. **Architecture Verification:**
   - Read `.agent/memory/ARCHITECTURE.md` to understand Clean Architecture rules
   - Identify the feature layer and verify dependency relationships:
     - `presentation/` (UI, BLoCs, Pages) → `domain/` (UseCases, Entities) → `data/` (Repositories, DataSources)
   - Confirm no circular dependencies exist

2. **Project Standards:**
   - Review `.agent/memory/PROJECT.md` for coding conventions, naming patterns, error handling rules
   - Note the state management approach (BLoC, Provider, GetX, etc.)
   - Understand the API contract and data models

3. **File Context:**
   - Trace the data flow through layers
   - Identify related files that should be reviewed together
   - Note external dependencies and their versions

### 1. Architecture & Clean Code Compliance

**Check dependency rules (CRITICAL):**

- ✅ Domain layer has NO external dependencies (only Dart standard library, exceptions)
- ✅ Domain layer uses only Entities and Value Objects (no DTOs leak in)
- ✅ Presentation never directly imports Data layer
- ✅ AllBLoC/Provider dependencies injected via constructor (`@injectable`)
- ✅ No direct `GetIt.I<>()` calls outside factory/entry point
- ✅ Repository pattern correctly implemented (abstractions in domain, implementations in data)

**Code organization:**

- ✅ Consistent file naming: `snake_case.dart` for files, `PascalCase` for classes
- ✅ Logical folder structure maintained
- ✅ Related models grouped logically
- ✅ No "god classes" (classes with single responsibility)

**Design patterns:**

- ✅ Proper use of mixins (not abused for inheritance)
- ✅ Sealed classes used correctly for bounded types
- ✅ Factory constructors where appropriate
- ✅ Builder pattern for complex object construction

### 2. Flutter/Dart Idioms & Best Practices

**Null safety & type safety:**

- ✅ Proper use of `?` (nullable), `!` (null assertion only when safe), `??` (null coalescing)
- ✅ No unnecessary null checks (e.g., `if (x != null) { ... }` should be `x?.doSomething()`)
- ✅ Late-binding (`late`) used correctly, not as last resort
- ✅ `required` keyword on mandatory parameters
- ✅ Final variables used by default, `var` used appropriately

**Async/Concurrency:**

- ✅ `async/await` used instead of `.then()` chains
- ✅ Proper exception handling in `try-catch` blocks at Data/Presentation layers
- ✅ No fire-and-forget futures without error handling
- ✅ BLoC event handling doesn't emit after closure (check `if (!isClosed)`)
- ✅ Race conditions prevented (use `bloc_concurrency` or cancel tokens)
- ✅ FutureBuilder/StreamBuilder always handles loading, error, and empty states

**State management (BLoC-specific):**

- ✅ Events are immutable (use `@immutable` or sealed classes)
- ✅ States properly represent all UI states (initial, loading, success, error)
- ✅ No business logic in BLoCs, only orchestration
- ✅ Proper use of `emit()` vs `state` getter
- ✅ BLoC initialization in the correct layer

**Widget composition:**

- ✅ Widgets are focused and reusable
- ✅ Consumer/Selector properly used to minimize rebuilds
- ✅ const constructors where possible
- ✅ No unnecessary nested rebuilds
- ✅ Keys used appropriately (avoid when not needed, essential for lists)

### 3. Performance & Optimization

**Flutter rendering:**

- 🔍 Check for excessive rebuilds (`Consumer` watching entire state instead of selector)
- 🔍 Unnecessary `setState()` calls
- 🔍 Expensive operations inside `build()` method
- 🔍 Large list rendering without `ListView.builder` or `PagedListView`
- 🔍 Proper use of `RepaintBoundary` for expensive widgets
- 🔍 Image caching configured (`CachedNetworkImage` with cache manager)

**Memory optimization:**

- 🔍 Proper resource cleanup (streams closed, callbacks unsubscribed)
- 🔍 No memory leaks from controllers or listeners
- 🔍 Large objects disposed in widget lifecycle
- 🔍 Image size optimized for display dimensions

**Data layer efficiency:**

- 🔍 Appropriate caching strategy (local DB, in-memory, HTTP cache headers)
- 🔍 Batch API calls where possible
- 🔍 Pagination implemented for large datasets
- 🔍 Query optimization in Drift (proper indexing, select only needed fields)

### 4. Security & Vulnerability Prevention

**Data Protection:**

- 🛡️ Sensitive data not logged (passwords, tokens, PII)
- 🛡️ Flutter Secure Storage used for tokens/secrets (not SharedPreferences)
- 🛡️ API keys not hardcoded in source (use environment variables or secure config)
- 🛡️ HTTPS enforced (certificates pinned where applicable)
- 🛡️ WebView security: `allow_user_interaction`, `enable_zoom`, `js_mode` configured safely

**Input Validation:**

- 🛡️ User input validated before processing (length, format, type)
- 🛡️ API responses validated against expected schema
- 🛡️ No SQL injection risks (Drift parameterized queries used)
- 🛡️ File paths sanitized, no directory traversal possible

**Error Handling:**

- 🛡️ Error messages don't expose sensitive system information
- 🛡️ Exceptions never leaked to users (wrapped in friendly messages)
- 🛡️ Stack traces not exposed in production UI

**Permissions & Platform Channels:**

- 🛡️ Permissions requested only when needed (not at startup)
- 🛡️ Platform channel method names don't expose sensitive operations
- 🛡️ Android: targetSdkVersion updated, dangerous permissions declared
- 🛡️ iOS: Info.plist permissions properly documented for App Store review

### 5. Code Smells & Refactoring Opportunities

**Common smells to detect:**

- 👃 **Duplicated Code:** Logic repeated in multiple places → Extract to shared function/mixin
- 👃 **Long Functions:** Methods exceeding 20-30 lines → Break into smaller, focused functions
- 👃 **Feature Envy:** Class accessing many methods from another class → Might belong in that class
- 👃 **Data Clumps:** Same parameters passed together repeatedly → Group into class/record
- 👃 **Magic Numbers:** Hardcoded values without explanation → Extract to named constant
- 👃 **Inconsistent Naming:** Similar concepts with different names → Standardize
- 👃 **Deep Nesting:** if/else/if chains → Refactor to early returns or switch
- 👃 **Type Checking:** `if (obj is Type)` chains → Use sealed classes or pattern matching
- 👃 **Temporary Variables:** Variables hold intermediate results → Consider using pipelines or methods

**Refactoring suggestions:**

- 🔧 Extract class when class is doing too much
- 🔧 Replace null checks with null-safe operators
- 🔧 Convert callback functions to lambda/arrow functions for readability
- 🔧 Use `cascade` operator (`..`) for multiple operations on same object
- 🔧 Replace loop with higher-order functions (`map`, `where`, `fold`)

### 6. Testing & Coverage

**Test Coverage Analysis:**

- ✅ Unit tests cover business logic (BLoCs, UseCases, ValueObjects)
- ✅ Mock external dependencies (repositories, HTTP clients)
- ✅ Widget tests verify UI behavior and state transitions
- ✅ Integration tests cover critical user flows (expensive data operations)
- ✅ Edge cases tested: null values, empty lists, API errors, timeouts

**Test Quality:**

- ✅ Arrange-Act-Assert pattern clear and consistent
- ✅ Meaningful test names describe scenario and expected behavior
- ✅ No shared state between tests (independent and repeatable)
- ✅ Proper use of `setUp()` and `tearDown()`
- ✅ Test fixtures organized in logical files
- ✅ Mock builders create realistic mock data

**Coverage Goals:**

- 🎯 Critical paths: 80%+ coverage (auth, payment, data access)
- 🎯 Feature logic: 60%+ coverage (BLoCs, UseCases)
- 🎯 UI: Limited but focused on complex logic (not every build method)

### 7. Error Handling & Logging

**Error Handling Strategy:**

- ⚠️ Centralized error handling at layer boundaries
- ⚠️ Custom exception types for business errors vs infrastructure errors
- ⚠️ Error recovery paths implemented where possible
- ⚠️ User-friendly error messages in UI layer
- ⚠️ Graceful degradation when features unavailable

**Logging:**

- 📝 Structured logging with clear levels (info, warning, error)
- 📝 No sensitive data in logs (tokens, emails, personal info)
- 📝 Logs helpful for debugging without exposing internals
- 📝 Logging doesn't impact performance (lazy evaluation if expensive)

### 8. Documentation & Comments

**Code Clarity:**

- 📖 Self-documenting code with clear names (few comments needed)
- 📖 Complex logic explained inline
- 📖 Public APIs documented with docstrings (`///`)
- 📖 Architectural decisions captured in design docs or memory files
- 📖 Non-obvious behavior explained (why, not what)

---

## Review Severity Levels

| Level           | Definition                                                       | Examples                                                  |
| --------------- | ---------------------------------------------------------------- | --------------------------------------------------------- |
| **CRITICAL** 🔴 | Must fix before merge. Security risk, data loss, runtime crash   | Null safety violation, SQL injection, circular dependency |
| **HIGH** 🟠     | Should fix. Major logic error or architecture violation          | BLoC calling GetIt directly, API response not validated   |
| **MEDIUM** 🟡   | Should improve. Performance issue, code smell, pattern deviation | Unnecessary rebuilds, magic numbers, long function        |
| **LOW** 🟢      | Nice to have. Consistency, readability, minor optimization       | Naming convention, code formatting, trivial refactoring   |

---

## Output Schema

Always generate reviews in bilingual markdown format (English + Vietnamese):

```markdown
## 🔍 Code Quality Audit Report

**Auditor:** Code Quality Auditor | **Date:** [Date] | **Overall Status:** 🟢 APPROVED / 🟡 NEEDS IMPROVEMENT / 🔴 BLOCKED

---

### 📋 Summary

**File(s) Reviewed:** [list]
**Total Issues:** [count] (🔴 Critical: X | 🟠 High: Y | 🟡 Medium: Z | 🟢 Low: W)
**Architecture Score:** [8/10]
**Security Score:** [8/10]
**Performance Score:** [7/10]
**Testing Score:** [6/10]

---

### ✅ Strengths

- [Positive observation with context]
- [Well-implemented pattern]

---

### 🛑 Critical Issues (Must Fix)

| #   | Category     | Location       | Issue                           | Impact                       | Fix                                  |
| --- | ------------ | -------------- | ------------------------------- | ---------------------------- | ------------------------------------ |
| 1   | Architecture | `file.dart:45` | Domain imports external package | Can break layer independence | Remove import, abstract to interface |

**Vietnamese:** Kiến trúc phụ thuộc vào gói bên ngoài, vi phạm quy tắc Clean Architecture.

---

### ⚠️ High Priority Issues

| #   | Category | Location               | Issue                             | Suggestion                                        |
| --- | -------- | ---------------------- | --------------------------------- | ------------------------------------------------- |
| 1   | Security | `auth_service.dart:67` | API token logged in error message | Use `logger.error('Auth failed')` without details |

**Vietnamese:** Token API bị lộ trong logs. Sử dụng thông báo lỗi chung chung.

---

### 💡 Medium Priority Improvements

| #   | Category    | Location                | Current                                       | Suggested                                 |
| --- | ----------- | ----------------------- | --------------------------------------------- | ----------------------------------------- |
| 1   | Performance | `gallery_bloc.dart:120` | `Consumer(builder: ...)` watches entire state | Use `Selector<GalleryState, List<Photo>>` |

**Vietnamese:** Consumer xem toàn bộ trạng thái, gây rebuild không cần thiết. Dùng Selector để optimize.

---

### 📝 Low Priority Suggestions

- **Code Smell:** Duplicated validation logic in `validators.dart` and `models.dart` → Extract to shared utility
  - _Vietnamese:_ Logic xác thực trùng lặp. Nên tách ra thành hàm chung.

---

### 🧪 Test Coverage Analysis

**Current Coverage:** 65%

**High Priority Tests Needed:**

- [ ] Unit test for `GalleryUseCase.fetchPhotos()` error cases
- [ ] Widget test for gallery infinite scroll behavior
- [ ] Mock HTTP 500 error scenarios

**Vietnamese:** Cần thêm test cho xử lý lỗi và infinite scroll.

---

### 🎯 Recommendations for Next Steps

1. **Immediate:** Fix Critical issues before merge
2. **Before Release:** Address High priority items
3. **Backlog:** Low priority improvements can be done in future sprints
4. **Follow-up:** Add tests for error handling paths

---

### 📚 Reference Links

- [Architecture Guidelines](../../../.agent/memory/ARCHITECTURE.md)
- [Project Standards](../../../.agent/memory/PROJECT.md)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)

---

_Review completed with architectural, performance, security, code quality, and testing analysis._
```

---

## Flutter/Dart Code Smell Examples

### Example 1: State Management Rebuild Issue

**❌ Problematic Code:**

```dart
// gallery_page.dart - watches ENTIRE state, rebuilds everything
BlocBuilder<GalleryBloc, GalleryState>(
  builder: (context, state) {
    if (state is GalleryLoading) return LoadingWidget();
    if (state is GallerySuccess) {
      return ListView.builder(
        itemCount: state.photos.length,
        itemBuilder: (context, index) => PhotoCard(state.photos[index]),
      );
    }
    return ErrorWidget();
  },
);
```

**⚠️ Issue:** Entire list rebuilds every time state changes, even if photos list unchanged.

**✅ Fixed:**

```dart
// Uses Selector to watch only the photos list
BlocSelector<GalleryBloc, GalleryState, List<Photo>>(
  selector: (state) => state is GallerySuccess ? state.photos : [],
  builder: (context, photos) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, index) => PhotoCard(photos[index]),
    );
  },
);
```

**Chinese:** 選擇器只觀看 photos 列表，避免不必要的重建。（Vietnamese: Selector chỉ xem danh sách ảnh, tránh rebuild không cần thiết。）

---

### Example 2: Async Race Condition in BLoC

**❌ Problematic Code:**

```dart
on<FetchPhotos>((event, emit) async {
  emit(PhotosLoading());

  // Two fetches in parallel - race condition possible
  final local = await _localRepo.getPhotos();
  final remote = await _remoteRepo.getPhotos();

  // If BLoC disposed between awaits, this crashes
  emit(PhotosSuccess(photos: local + remote));
});
```

**✅ Fixed:**

```dart
on<FetchPhotos>(
  (event, emit) async {
    emit(PhotosLoading());

    try {
      final local = await _localRepo.getPhotos();
      final remote = await _remoteRepo.getPhotos();

      // Safe emit - check if BLoC still active
      if (!isClosed) {
        emit(PhotosSuccess(photos: local + remote));
      }
    } catch (e) {
      if (!isClosed) {
        emit(PhotosError(e.toString()));
      }
    }
  },
  transformer: droppable(), // Ignore new events while processing
);
```

**Vietnamese:** Thêm kiểm tra `!isClosed` trước emit và dùng `droppable()` để tránh race condition.

---

### Example 3: Domain Layer Dependency Violation

**❌ Problematic Code:**

```dart
// lib/features/photos/domain/usecases/get_photos_usecase.dart
import 'package:http/http.dart'; // ❌ Violates Clean Architecture!
import 'package:drift/drift.dart'; // ❌ Data layer detail leaks!

class GetPhotosUseCase {
  Future<List<Photo>> call() async {
    final response = await http.get(...); // Direct HTTP call in domain
    // ...
  }
}
```

**✅ Fixed:**

```dart
// Domain layer - only abstract repository, no framework dependencies
import '../repositories/photo_repository.dart'; // ✅ Abstract interface
import '../entities/photo.dart'; // ✅ Pure entity

class GetPhotosUseCase {
  final PhotoRepository repository;

  GetPhotosUseCase(this.repository);

  Future<List<Photo>> call() async {
    return repository.getPhotos(); // Delegated to repository
  }
}
```

**Vietnamese:** Domain layer chỉ sử dụng abstract repository, không import HTTP hay Drift.

---

## Integration with Memory Files

This skill references and validates against:

- `.agent/memory/ARCHITECTURE.md` - Enforces dependency rules
- `.agent/memory/PROJECT.md` - Project coding standards and conventions
- `pubspec.yaml` - Dependency versions and plugin compatibility
- `lib/` structure - Actual file organization and naming

---

## Suggested Follow-up Skills

After using code-quality-auditor, consider:

1. **refactoring-expert** — Deep refactoring based on identified smells
2. **security-auditor** — Focused security vulnerability assessment
3. **performance-profiler** — Detailed performance optimization analysis
4. **test-engineer** — Test strategy and coverage improvement

---

## Tips for Best Results

✨ **For Dart/Flutter Code Reviews:**

- Provide the entire feature folder for full context (presentation + domain + data)
- Include related models and DTOs for data flow analysis
- Include test files to check coverage
- Use `/code-quality-audit [feature_folder]` for comprehensive review

✨ **For Specific Reviews:**

- Use `BLoC files only` to review state management patterns
- Use `API integration only` to audit network layer
- Use `UI widgets only` to check rendering efficiency

✨ **Maximum Value:**

- Run this before creating pull requests to catch issues early
- Use findings to create architecture guidelines or coding standards
- Reference this skill's output when mentoring junior developers
