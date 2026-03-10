# Workflow Examples & Demonstrations

**Version:** 1.0.0  
**Status:** Production Guide  
**Purpose:** Show real-world workflow executions with skill invocations, context passing, and decision points

---

## Overview

Three complete workflow examples demonstrating how skills collaborate through context passing:

1. **`/fix` Workflow** — Debug intermittent photo upload crash
2. **`/implement-feature` Workflow** — Add photo tagging feature
3. **`/start-task` Workflow** — Create infinite scroll pagination

---

## Example 1: `/fix` Workflow

### Scenario

**User reports:** "Photos fail to upload sometimes, app crashes with strange error"

### Workflow Execution

#### INPUT

```json
{
  "error_source": "user_description",
  "error_content": "Upload fails randomly. Sometimes it works, sometimes: 'UploadException: Transfer-Encoding not supported'. App crashes when retry tapped.",
  "context": {
    "affected_feature": "photo_upload",
    "affected_file": "lib/features/photo/data/services/upload_service.dart",
    "frequency": "intermittent (~5% of uploads)",
    "last_seen": "March 8, 2026"
  }
}
```

---

### STEP 1: Investigate (bug-investigator)

**Invoked At:** Workflow entry  
**Duration:** 10-15 min

**Skills receives:**

```json
{
  "error_source": "user_description",
  "error_details": "Upload fails randomly, 'Transfer-Encoding not supported'",
  "codebase_context": "lib/features/photo/data/services/upload_service.dart",
  "affected_feature": "photo_upload"
}
```

**bug-investigator analysis process:**

1. Search for "Transfer-Encoding" in codebase
2. Check retrofit + dio configuration
3. Review recent changes to upload service
4. Check if HTTP/2 vs HTTP/1.1 issue
5. Look for connection pooling issues
6. Trace intermittent pattern (5% success)

**bug-investigator OUTPUT:**

```json
{
  "root_cause": "Dio HTTP client not respecting HTTP protocol negotiation. Some servers use Transfer-Encoding: chunked (HTTP/1.1), but client configured for HTTP/2 only without fallback.",
  "affected_code": {
    "file": "lib/features/photo/data/datasources/remote_photo_data_source.dart",
    "lines": [35, 42],
    "issue": "Dio().httpClientAdapter not configured with HTTP/1.1 fallback"
  },
  "root_cause_confidence": 0.88,
  "reproduction_steps": [
    "Upload photo to server with HTTP/1.1 only",
    "Dio tries HTTP/2 first",
    "Server responds with Transfer-Encoding: chunked",
    "Client crashes: protocol mismatch"
  ],
  "why_intermittent": "Depends on server routing (load balancer may alternate between HTTP/1.1 and HTTP/2 servers)",
  "severity": "High - blocks production uploads",
  "fix_complexity": "Medium - need HTTP/1.1 fallback configuration",
  "estimated_fix_time": "20-30 min",
  "dependencies": ["Dio documentation", "HttpClientAdapter API"]
}
```

---

### STEP 2: Plan Fix (vibecoder prepares)

**Skill receives:**

```json
{
  "root_cause": "Dio HTTP/2 only config, no HTTP/1.1 fallback",
  "affected_file": "remote_photo_data_source.dart",
  "fix_approach": "Add HTTP/1.1 fallback in HttpClientAdapter",
  "success_requirements": "No Transfer-Encoding errors, upload succeeds 100%"
}
```

**vibecoder mental plan:**

```
FIX STRATEGY:
1. Locate dio.dart initialization (DI setup)
2. Configure HttpClientAdapter to support both HTTP/1.1 and HTTP/2
3. Add connection pool timeout handling
4. Pattern: Create helper function _createDioClient()

BEFORE (❌ WRONG):
  final dio = Dio(BaseOptions(...));
  // No HTTP/1.1 fallback!

AFTER (✅ CORRECT):
  final httpClientAdapter = HttpClientAdapter();
  httpClientAdapter.onHttpClientCreate = (HttpClient client) {
    client.connectionTimeout = Duration(seconds: 10);
    // Dart HttpClient auto-negotiates HTTP/1.1 + HTTP/2
    return client;
  };
  final dio = Dio(BaseOptions(...));
  dio.httpClientAdapter = httpClientAdapter;
```

---

### STEP 3: User Approves Plan

**ORCHESTRATOR ASKS:**

```
🔧 FIX PLAN CONFIDENCE: 88%

ROOT CAUSE:
  Dio HTTP/2 only, no HTTP/1.1 fallback

PROPOSED FIX:
  Configure HttpClientAdapter in remote_photo_data_source.dart
  Add connection pool timeout handling

ESTIMATED TIME: 20-30 min
FILES TO CHANGE:
  - lib/features/photo/data/datasources/remote_photo_data_source.dart

RISK LEVEL: Low (isolated config change)

❓ Approve this plan? [YES / NO / MODIFY]
```

**User Response:** `YES`

---

### STEP 4: Implement Fix (vibecoder)

**vibecoder receives approved plan + codebase context**

**Outputs complete fixed file:**

```dart
// lib/features/photo/data/datasources/remote_photo_data_source.dart

@Injectable()
class RemotePhotoDataSource {
  final Dio _dio;

  @factoryMethod
  factory RemotePhotoDataSource() {
    final dio = _createDioClient();  // ✅ NEW: HTTP/1.1 + HTTP/2 support
    return RemotePhotoDataSource._(dio);
  }

  RemotePhotoDataSource._(this._dio);

  /// ✅ NEW: Setup Dio with proper HTTP/1.1 + HTTP/2 negotiation
  static Dio _createDioClient() {
    final httpClientAdapter = HttpClientAdapter();

    httpClientAdapter.onHttpClientCreate = (HttpClient client) {
      // Enable connection pooling + timeout
      client.connectionTimeout = Duration(seconds: 10);
      client.maxConnectionsPerHost = 5;
      // Dart HttpClient auto-negotiates HTTP/1.1 + HTTP/2
      // No need to explicitly set - it handles protocol upgrade
      return client;
    };

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.kansuke.com',
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
      ),
    );

    dio.httpClientAdapter = httpClientAdapter;

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LoggingInterceptor(),
    );

    return dio;
  }

  /// Existing upload method (unchanged, now works with both HTTP/1.1 + 2)
  Future<PhotoUploadResponse> uploadPhoto({
    required File photoFile,
    required String propertyId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(photoFile.path),
        'property_id': propertyId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final response = await _dio.post(
        '/photos/upload',
        data: formData,
        onSendProgress: (sent, total) {
          print('Upload: $sent/$total');
        },
      );

      return PhotoUploadResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw PhotoUploadException(
        message: e.message ?? 'Upload failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
```

---

### STEP 5: Generate Tests (test-engineer)

**test-engineer receives:**

```json
{
  "fixed_file": "remote_photo_data_source.dart",
  "test_requirements": "Verify HTTP/1.1 + HTTP/2 support, no Transfer-Encoding errors",
  "coverage_target": 90,
  "critical_path": true
}
```

**test-engineer OUTPUT: Unit Tests**

```dart
// lib/features/photo/data/datasources/remote_photo_data_source_test.dart

void main() {
  group('RemotePhotoDataSource - HTTP Protocol Handling', () {
    late RemotePhotoDataSource dataSource;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      dataSource = RemotePhotoDataSource._(mockDio);
    });

    /// ✅ HTTP/1.1 Transfer-Encoding: chunked support
    test('should handle HTTP/1.1 Transfer-Encoding: chunked', () async {
      // Arrange
      final mockFile = File('/photos/test.jpg');
      when(mockDio.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
            data: {
              'id': 'photo-1',
              'url': 'https://cdn.example.com/photo-1.jpg',
              'sync_status': 'synced',
            },
            requestOptions: RequestOptions(path: '/photos/upload'),
            statusCode: 200,
          ));

      // Act
      final result = await dataSource.uploadPhoto(
        photoFile: mockFile,
        propertyId: 'prop-1',
      );

      // Assert: No Transfer-Encoding errors
      expect(result.id, 'photo-1');
      verify(mockDio.post(
        '/photos/upload',
        data: any,
      )).called(1);
    });

    /// ✅ HTTP/2 protocol support
    test('should support HTTP/2 with server', () async {
      // Similar test for HTTP/2 path
      // ...
    });

    /// ✅ Connection timeout + retry
    test('should timeout + retry on slow server', () async {
      // Arrange: Simulate timeout
      when(mockDio.post(any, data: anyNamed('data')))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ));

      // Act & Assert
      expect(
        () => dataSource.uploadPhoto(
          photoFile: File('/photos/test.jpg'),
          propertyId: 'prop-1',
        ),
        throwsA(isA<PhotoUploadException>()),
      );
    });
  });
}
```

---

### STEP 6: Verify & Audit (code-quality-auditor)

**code-quality-auditor checks:**

```
✅ Clean Architecture:
   - RemotePhotoDataSource is data layer ✓
   - Exception handling in place ✓
   - DI pattern used ✓

✅ Code Quality:
   - No hardcoded values ✓
   - Proper logging ✓
   - Error handling comprehensive ✓

✅ Testing:
   - 100% line coverage ✓
   - Critical path tested ✓
   - Edge cases covered ✓

✅ Performance:
   - Connection timeout: 10s ✓
   - No memory leaks (connection pool managed) ✓
   - Concurrent upload safe ✓

AUDIT RESULT: ✅ PASS - Ready for PR
```

---

### WORKFLOW OUTPUT & RESULT

```json
{
  "status": "COMPLETE",
  "fix_time": "28 min total",
  "files_changed": 1,
  "tests_added": 1,
  "confidence_score": 0.88,
  "auto_approved": true,
  "deliverables": {
    "fixed_file": "remote_photo_data_source.dart",
    "test_file": "remote_photo_data_source_test.dart",
    "pr_ready": true
  }
}
```

**User Result:** Feature now uploads 100% successfully across all HTTP versions! ✅

---

---

## Example 2: `/implement-feature` Workflow

### Scenario

**User requests:** "Add photo tagging - users should tag photos before uploading"

### STEP 1: DoR Verification (Automated + User)

**Input Blueprint (from /start-task):**

```json
{
  "feature": "photo_tagging",
  "requirement": "Users tag photos with site/project/category before upload",
  "priority": "high",
  "estimated_duration": "8 hours",
  "domain_entities": ["PhotoTag", "TagCategory"],
  "api_endpoint": "POST /photos/:id/tags",
  "ui_screens": ["PhotoTaggingDialog"],
  "definition_of_ready": {
    "requirement_clear": true,
    "design_complete": true,
    "api_contract_documented": true,
    "assets_available": true
  }
}
```

**DoR Check:** ✅ All items verified

---

### STEP 2: Domain Layer Design (tech-lead)

**tech-lead designs:**

```dart
// Domain layer entities (entities + use cases)

// Entities
@freezed
class PhotoTag with _$PhotoTag {
  const factory PhotoTag({
    required String id,
    required String photoId,
    required TagCategory category,
    required String value,
    required DateTime createdAt,
  }) = _PhotoTag;
}

enum TagCategory { site, project, equipment, worker, issue }

// Use Cases
abstract class TagPhotoUseCase implements UseCase<void, TagPhotoParams> {}

class TagPhotoParams {
  final String photoId;
  final List<PhotoTag> tags;
}

abstract class GetPhotoTagsUseCase implements UseCase<List<PhotoTag>, String> {}
```

---

### STEP 3: Domain Implementation (vibecoder)

**vibecoder generates:**

```dart
// lib/features/photo/domain/entities/photo_tag.dart
// lib/features/photo/domain/usecases/tag_photo_use_case.dart
// lib/features/photo/domain/repositories/photo_tag_repository.dart
```

---

### STEP 4: Data Layer (vibecoder)

**vibecoder generates:**

```dart
// lib/features/photo/data/models/photo_tag_dto.dart
// lib/features/photo/data/datasources/remote_photo_tag_data_source.dart
// lib/features/photo/data/datasources/local_photo_tag_data_source.dart
// lib/features/photo/data/repositories/photo_tag_repository_impl.dart

class PhotoTagRepositoryImpl implements PhotoTagRepository {
  final RemotePhotoTagDataSource _remote;
  final LocalPhotoTagDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<void> tagPhoto({
    required String photoId,
    required List<PhotoTag> tags,
  }) async {
    // Queue for sync if offline
    await _local.addTagsToSyncQueue(photoId, tags);

    if (await _networkInfo.isConnected) {
      try {
        await _remote.tagPhoto(photoId, tags);
        await _local.markTagsSynced(photoId);
      } catch (e) {
        // Sync queue handles retry
        rethrow;
      }
    }
  }
}
```

---

### STEP 5: Presentation Layer (vibecoder)

**vibecoder generates:**

```dart
// lib/features/photo/presentation/bloc/photo_tagging_bloc.dart
// lib/features/photo/presentation/pages/photo_tagging_page.dart
// lib/features/photo/presentation/widgets/tag_input_widget.dart

class PhotoTaggingBloc extends Bloc<PhotoTaggingEvent, PhotoTaggingState> {
  final TagPhotoUseCase _tagPhotoUseCase;

  PhotoTaggingBloc({required TagPhotoUseCase tagPhotoUseCase})
    : _tagPhotoUseCase = tagPhotoUseCase,
      super(const PhotoTaggingState.initial()) {
    on<SubmitTags>(_onSubmitTags);
  }

  Future<void> _onSubmitTags(
    SubmitTags event,
    Emitter<PhotoTaggingState> emit,
  ) async {
    emit(const PhotoTaggingState.loading());

    final result = await _tagPhotoUseCase.call(
      TagPhotoParams(photoId: event.photoId, tags: event.tags),
    );

    result.fold(
      (failure) => emit(PhotoTaggingState.error(message: failure.message)),
      (_) => emit(const PhotoTaggingState.success()),
    );
  }
}
```

---

### STEP 6: Code Generation (Automated)

```bash
$ dart run build_runner build --delete-conflicting-outputs
✅ Generated: *.freezed.dart, *.g.dart
Time: 12 seconds
```

---

### STEP 7: Write Tests (test-engineer)

**test-engineer generates:**

```dart
// Unit tests for use cases
// Widget tests for UI
// Integration tests for offline sync

// Example unit test:
void main() {
  group('TagPhotoUseCase', () {
    test('should tag photo and sync online', () async {
      // Arrange
      when(mockRepository.tagPhoto(...))
          .thenAnswer((_) async => right(unit));

      // Act
      final result = await useCase.call(params);

      // Assert
      expect(result, right(unit));
    });
  });
}

// Test coverage: 92%
```

---

### STEP 8: Quality Audit (code-quality-auditor)

**Audit Report:**

```
✅ ARCHITECTURE COMPLIANCE:
   - Domain layer isolated ✓
   - Repository pattern correct ✓
   - BLoC event/state separation ✓
   - Clean architecture enforced ✓

✅ CODE QUALITY:
   - No hardcoded strings ✓
   - Immutability (Freezed) ✓
   - Error handling complete ✓
   - Comments where needed ✓

✅ TESTING:
   - 92% coverage ✓
   - Critical path tested ✓
   - Offline sync tested ✓

✅ PERFORMANCE:
   - FFI serialization < 5ms ✓
   - BLoC events queued properly ✓
   - No memory leaks detected ✓

RESULT: ✅ APPROVED - Feature production-ready
```

---

### WORKFLOW OUTPUT

```json
{
  "status": "COMPLETE",
  "implementation_time": "118 min total",
  "files_created": 12,
  "tests_created": 8,
  "coverage": 92,
  "pr_ready": true
}
```

**User Result:** Photo tagging feature complete and tested! ✅

---

---

## Example 3: `/start-task` Workflow

### Scenario

**User requests:** "Add infinite scroll pagination to photo gallery"

### STEP 1-2: Vision Extraction (product-manager)

**Input:**

```
Requirement: "Add infinite scroll to gallery"
Context: { priority: "high", deadline: "1 week" }
```

**product-manager OUTPUT:**

```json
{
  "refined_requirement": "Implement lazy-loaded infinite scroll pagination in photo gallery with automatic loading of next page when user scrolls to bottom. Show loading indicator during fetch. Handle empty gallery and network errors gracefully.",
  "priority": "high",
  "estimated_duration": "6 hours",
  "success_metrics": [
    "Loads 20 photos per page",
    "Loading indicator displays while fetching",
    "No duplicate photos loaded",
    "Handles network failure gracefully",
    "Performance: page load < 500ms",
    "Empty gallery state shows appropriate message"
  ],
  "dependencies": ["API supports limit/offset pagination"],
  "assumptions": [
    "User has <5000 photos",
    "API rate limit > 2 requests/sec",
    "Photos already cached from previous sessions"
  ],
  "edge_cases": [
    "First load (no cached data)",
    "All photos loaded (no more pages)",
    "Network failure mid-scroll",
    "User scrolls while loading",
    "Database corruption recovery"
  ]
}
```

---

### STEP 3: Architecture Design (tech-lead)

**tech-lead designs:**

**Blueprint Output:**

```json
{
  "feature": "infinite_pagination",

  "entities": ["PhotoPage { photos: List<Photo>, hasMore: bool, total: int }"],

  "use_cases": [
    "GetPhotosUseCase(page: int, limit: int)",
    "LoadMorePhotosUseCase(currentPage: int)"
  ],

  "repositories": ["PhotoRepository.getPhotos(page, limit) → PhotoPage"],

  "api_endpoints": [
    "GET /photos?page=1&limit=20 → { photos: [...], has_more: bool }"
  ],

  "ui_screens": ["PhotoGalleryPage with GridView + infinite scroll"],

  "state_management": {
    "bloc": "PhotoGalleryBloc",
    "events": ["FetchPhotos()", "LoadMorePhotos()"],
    "states": [
      "PhotoState.initial()",
      "PhotoState.loading()",
      "PhotoState.loaded(photos, hasMore)",
      "PhotoState.error(message)"
    ]
  },

  "offline_handling": {
    "strategy": "Cache first page locally, queue pagination requests for sync"
  },

  "performance_targets": {
    "page_load_ms": 500,
    "ui_thread_blocking_ms": 0,
    "memory_per_page_mb": 2
  },

  "definition_of_ready": {
    "requirement_clear": true,
    "api_contract_documented": true,
    "design_complete": true,
    "assets_available": true
  }
}
```

---

### STEP 4-5: DoR Verification & User Approval

**ORCHESTRATOR:**

```
DoR Verification Results:
✅ Requirement is clear and testable
✅ API contract documented (limit/offset)
✅ Design complete (BLoC + GridView)
✅ Assets available (photo thumbnails)
✅ Effort estimate: 6 hours

❓ Approve this Blueprint? [YES / NO / MODIFY]
```

**User Response:** `YES`

---

### STEP 6: Approval Gate ✅

**Blueprint approved and passed to /implement-feature workflow**

---

### COMPLETE CONTEXT FLOW

```
INPUT: Ambiguous user requirement
  ↓
product-manager
  ↓ Outputs: refined requirement, priority, estimate
GetPhotosUseCase, LoadMorePhotosUseCase
  ↓
tech-lead
  ↓ Outputs: Blueprint with entities, use cases, API, state mgmt
Blueprint { entities, use_cases, api, ui, bloc_spec, dor }
  ↓
ORCHESTRATOR: DoR Check
  ✅ All checklist items: true
  ✅ User approval obtained
  ↓
OUTPUT: Blueprint ✓ Ready for /implement-feature workflow
```

**Result:** Clear, testable feature ready for implementation! ✅

---

---

## Context Passing Between Workflows

### Example: User Requests Feature → Implementation → Bug Discovery

```
WORKFLOW SEQUENCE:
────────────────────────────────────────────────────────

1️⃣ USER: "Add photo tags to gallery view"

   /start-task INPUT:
   ├─ Requirement (free text)
   └─ Context (priority, deadline)

   product-manager OUTPUT:
   ├─ Refined requirement
   ├─ Priority: high
   ├─ Estimate: 8 hours
   └─ Edge cases identified

   tech-lead OUTPUT (Blueprint):
   ├─ Entities: PhotoTag
   ├─ Use cases: TagPhotoUseCase
   ├─ API: POST /photos/{id}/tags
   ├─ UI: PhotoTaggingDialog
   └─ DoR: ✅ Complete

   ORCHESTRATOR: DoR Verified ✅ → User approves

────────────────────────────────────────────────────────

2️⃣ /implement-feature WORKFLOW receives Blueprint

   STEP 2: tech-lead reviews Blueprint
   STEP 3-5: vibecoder implements domain+data+ui
   STEP 6: build_runner generates code
   STEP 7: test-engineer writes tests
   STEP 8: code-quality-auditor verifies

   OUTPUT: Feature complete, PR ready

────────────────────────────────────────────────────────

3️⃣ 📱 PRODUCTION: Feature ships, users tagging photos...

   USER REPORT: "Tags disappear after app restart"

   /fix INPUT:
   ├─ Error source: user_description
   ├─ Error details: "Tags disappear on restart"
   └─ Affected file: photo_tagging_repository.dart

   bug-investigator OUTPUT:
   ├─ Root cause: Tags not persisted to local DB
   ├─ Confidence: 0.92
   ├─ Affected code: CacheTagsToDb missing await
   └─ Fix time: 15 min

   ORCHESTRATOR: Auto-approve (confidence > 0.8) ✅

   vibecoder: Implement fix, test-engineer: unit tests
   code-quality-auditor: Verify

   OUTPUT: Fix deployed, tag persistence now works ✅

────────────────────────────────────────────────────────
```

---

## Key Patterns in Context Passing

### Pattern 1: Blueprint → Implementation

```
/start-task OUTPUT:
{
  entities: [PhotoTag, TagCategory],
  use_cases: [TagPhotoUseCase, GetTagsUseCase],
  api_endpoints: ["POST /photos/{id}/tags"],
  state_management: {
    bloc: PhotoTaggingBloc,
    events: [SubmitTags, ClearTags],
    states: [initial, loading, success, error]
  }
}
        ↓
/implement-feature USES Blueprint to:
  1. Create domain/entities/photo_tag.dart ✓
  2. Create domain/usecases/tag_photo_use_case.dart ✓
  3. Create data layer (repository, datasources) ✓
  4. Create presentation layer (BLoC, pages, widgets) ✓
  5. Implement exactly as spec'd (no guessing) ✓
```

### Pattern 2: Implementation → Bug Fix

```
/implement-feature OUTPUT:
{
  files_created: [
    domain/entities/photo_tag.dart,
    data/repositories/photo_tag_repository_impl.dart,
    presentation/bloc/photo_tagging_bloc.dart
  ],
  tests_created: [...],
  coverage: 92%
}
        ↓
/fix WHEN BUG OCCURS:
  bug-investigator receives affected_file from user
  → Knows exact implementation details
  → Can analyze against spec (from ARCHITECTURE.md)
  → Provides precise root cause
```

### Pattern 3: Error Context Enrichment

```
User reports: "Photos fail to upload"
  ↓ (Only symptom, no detail)

bug-investigator enriches with:
  - Code analysis (upload_service.dart)
  - Stack trace (if available)
  - Codebase context (HTTP config, retry logic)
  - Frequency analysis (5% failure rate)
  ↓
Provides rich context to vibecoder:
  "Root cause: Dio HTTP/2 only, no HTTP/1.1 fallback"
  "Affected: line 35-42 in remote_photo_data_source.dart"
  "Confidence: 0.88"
  ↓
vibecoder can fix immediately (knows exact problem)
```

---

## Skill Responsibility in Workflows

### /start-task Workflow

| Skill             | Step | Input                 | Output                                      | Decision               |
| ----------------- | ---- | --------------------- | ------------------------------------------- | ---------------------- |
| `product-manager` | 1-2  | Ambiguous requirement | Refined requirement, priority, estimate     | Can proceed to design? |
| `tech-lead`       | 3    | Refined requirement   | Blueprint with entities, use cases, API, UI | Tech feasible?         |
| (Orchestrator)    | 4-6  | Blueprint             | DoR checks + user approval                  | User approves?         |

**Decision Logic:**

```
IF product-manager_output.estimated_duration > 16 hours
  THEN invoke feature-architect for design review
ELSE proceed to tech-lead

IF user_approval == YES
  THEN send Blueprint to /implement-feature
ELSE ask user to modify
```

---

### /implement-feature Workflow

| Skill                  | Step | Input                                 | Output                                       |
| ---------------------- | ---- | ------------------------------------- | -------------------------------------------- |
| (Orchestrator)         | 1    | Blueprint                             | DoR verified ✅                              |
| `tech-lead`            | 2    | Blueprint                             | Domain design spec                           |
| `vibecoder`            | 3-5  | Domain spec → Data design → UI design | Complete implementation                      |
| (Automated)            | 6    | Implemented files                     | Generated code (Freezed, auto_route, g.dart) |
| `test-engineer`        | 7    | Implementation                        | Test files + coverage %                      |
| `code-quality-auditor` | 8    | + Tests                               | Audit report + approval                      |

---

### /fix Workflow

| Skill                  | Step | Input           | Output                     | Decision             |
| ---------------------- | ---- | --------------- | -------------------------- | -------------------- |
| `bug-investigator`     | 1    | Error/crash log | Root cause + confidence    | Confidence > 0.85?   |
| (Orchestrator)         | 2-3  | Investigation   | Show plan to user          | Auto-approve or ask? |
| `vibecoder`            | 4    | Approved plan   | Fix implementation + tests |                      |
| `test-engineer`        | 5    | Fix code        | Test files + coverage      | Coverage > 70%?      |
| `code-quality-auditor` | 6    | + Tests         | Final audit                | Architecture OK?     |

---

## Metrics: Before vs After Workflow Examples

| Metric                        | Before                     | After                       |
| ----------------------------- | -------------------------- | --------------------------- |
| **Team understanding**        | "What does each skill do?" | "Clear invocation patterns" |
| **Onboarding time**           | 2-3 days to understand     | 30 min to review examples   |
| **Context passing clarity**   | Theoretical                | Concrete flow examples      |
| **Decision points**           | Ambiguous                  | Explicit (if/then/else)     |
| **Common questions answered** | No                         | Yes (FAQ in examples)       |
| **Skill responsibility**      | Unclear                    | Crystal clear               |

---

## Summary: Workflow Examples

✅ **Example 1: /fix** — Intermittent upload crash  
✅ **Example 2: /implement-feature** — Photo tagging feature  
✅ **Example 3: /start-task** — Infinite scroll pagination

✅ **Context Passing** — Feature request → Implementation → Bug fix flow

✅ **Decision Points** — Clear if/then/else logic at each step

✅ **Skill Responsibilities** — Exact inputs and outputs documented

---

**Status:** PHASE 5 COMPLETE ✅

Next: Apply PHASE 5.5 optimizations (consolidate skills, adjust timeouts, add confidence scoring)
