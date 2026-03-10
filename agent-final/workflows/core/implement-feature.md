---
description: "Full feature implementation workflow: From Blueprint → Domain layer → Data layer → Presentation layer → Code generation → Tests → Quality audit. Enforces Clean Architecture at each step."
trigger: /implement-feature
version: "1.0.0"
skills:
  - tech-lead
  - vibecoder
  - test-engineer
  - code-quality-auditor
constraints:
  max_iterations: 1
  timeout_minutes: 120
  parallel_steps: ["S2-S4", "S6-S7"]
  exit_on:
    ["Feature complete and verified", "DoR not met", "Test coverage < 70%"]
skill: vibecoder
---

# 🚀 Full Feature Implementation Workflow

**Objective:** Implement complete feature end-to-end (Domain → Data → Presentation) with tests and quality assurance.

**Status:** Production-ready (v1.0.0)

**Prerequisites:**

- Must have Blueprint from `/start-task` workflow
- Definition of Ready (DoR) must be met
- API contract documented (if needed)

---

## 📊 Execution Flow Overview

```
┌─────────────────────────────────────────────────────────────┐
│ INPUT: Blueprint from /start-task (with API specs)          │
│ REQUIRES: DoR met (design, API contract, assets)            │
└────────────────────┬────────────────────────────────────────┘
                     │
       ┌─────────────▼──────────────┐
       │ STEP 1: DoR VERIFICATION   │ (5 min)
       │ Check requirements valid   │
       └─────────────┬──────────────┘
                     │
    ┌────────────────▼───────────────┐
    │ STEP 2: DOMAIN LAYER DESIGN    │ (15 min)
    │ Entities + UseCases            │
    └────────────────┬───────────────┘
                     │
  ┌──────────────────▼─────────────────┐
  │ STEP 3: CREATE DOMAIN LAYER        │ (15-20 min)
  │ Invoke vibecoder                   │
  └──────────────────┬─────────────────┘
                     │
┌──────────────────▼──────────────────┐
│ STEP 4: DATA LAYER DESIGN & IMPL    │ (20-30 min)
│ Repository + DataSources            │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│ STEP 5: PRESENTATION LAYER IMPL     │ (20-30 min)
│ Pages + Widgets + BLoC              │
└──────────────────┬──────────────────┘
                   │
    ┌──────────────▼──────────────┐
    │ STEP 6: CODE GENERATION     │ (5-10 min)
    │ Run build_runner            │
    └──────────────┬──────────────┘
                   │
    ┌──────────────▼──────────────┐
    │ STEP 7: WRITE TESTS         │ (20-30 min)
    │ Unit + Widget tests         │
    └──────────────┬──────────────┘
                   │
  ┌────────────────▼────────────────┐
  │ STEP 8: QUALITY AUDIT           │ (15 min)
  │ Architecture + Performance      │
  └────────────────┬────────────────┘
                   │
          ┌────────▼────────┐
          │ OUTPUT: Ready   │
          │ for /review     │
          └─────────────────┘
```

---

## 📥 Input Schema

```json
{
  "type": "object",
  "required": ["blueprint", "feature_name"],
  "properties": {
    "blueprint": {
      "type": "object",
      "description": "From /start-task workflow - output",
      "required": ["entities", "use_cases", "data_sources", "ui_screens"],
      "properties": {
        "feature_name": { "type": "string" },
        "description": { "type": "string" },
        "entities": {
          "type": "array",
          "description": "Domain entities with attributes",
          "items": {
            "properties": {
              "name": { "type": "string" },
              "attributes": { "type": "array" }
            }
          }
        },
        "use_cases": {
          "type": "array",
          "description": "Domain use cases"
        },
        "data_sources": {
          "type": "array",
          "items": {
            "properties": {
              "type": { "enum": ["retrofit", "drift", "local"] },
              "endpoints": { "type": "array" }
            }
          }
        },
        "ui_screens": {
          "type": "array",
          "description": "UI pages and screens",
          "items": { "properties": { "name": { "type": "string" } } }
        },
        "state_management": { "type": "string", "example": "BLoC" },
        "estimated_effort": { "type": "string" }
      }
    },
    "dor": {
      "type": "object",
      "description": "Definition of Ready checklist",
      "properties": {
        "requirement_clear": { "type": "boolean" },
        "design_complete": { "type": "boolean" },
        "api_contract_documented": { "type": "boolean" },
        "assets_available": { "type": "boolean" }
      }
    }
  }
}
```

---

## 📤 Output Schema

```json
{
  "type": "object",
  "properties": {
    "phase": { "type": "string" },
    "status": { "type": "string" },
    "dor_verification": { "type": "object" },
    "domain_layer": {
      "type": "object",
      "properties": {
        "entities_created": { "type": "array" },
        "repositories_defined": { "type": "array" },
        "use_cases_implemented": { "type": "array" }
      }
    },
    "data_layer": {
      "type": "object",
      "properties": {
        "repositories_implemented": { "type": "array" },
        "data_sources_created": { "type": "array" },
        "models_created": { "type": "array" }
      }
    },
    "presentation_layer": {
      "type": "object",
      "properties": {
        "blocs_created": { "type": "array" },
        "pages_created": { "type": "array" },
        "widgets_created": { "type": "array" }
      }
    },
    "code_generation": {
      "type": "object",
      "properties": {
        "build_runner_success": { "type": "boolean" },
        "generated_files": { "type": "array" }
      }
    },
    "tests": {
      "type": "object",
      "properties": {
        "unit_tests": { "type": "integer" },
        "widget_tests": { "type": "integer" },
        "coverage_percent": { "type": "number" }
      }
    },
    "quality_report": {
      "type": "object",
      "properties": {
        "architecture_score": { "type": "number" },
        "code_quality_score": { "type": "number" },
        "issues_found": { "type": "array" }
      }
    }
  }
}
```

---

## 🔄 Step-by-Step Execution

### STEP 1: DoR Verification (5 min) ✅

**Process:**

1. Verify Blueprint received from `/start-task`
2. Check all required sections present
3. Validate against Definition of Ready:
   - [ ] Requirement clear (User story + acceptance criteria)
   - [ ] Design complete (UI mockups or description)
   - [ ] API contract documented (endpoints + request/response)
   - [ ] Assets available (icons, images, or placeholders specified)

**Outputs:**

```markdown
## Definition of Ready Check

**Blueprint Received:** Gallery infinite scroll (Riverpod)

Requirements:
✅ User story: "As user, I want to scroll infinitely through 1000+ photos"
✅ Acceptance criteria: 3 defined (pagination, performance, error handling)

Design:
✅ Figma mockup: [link provided]
✅ UI states: Loading, Error, Empty, Success, Pagination states

API Contract:
✅ GET /photos?limit=50&offset=0 documented
✅ Request/response schemas provided

Assets:
✅ Placeholder images available

Status: ✅ DoR MET - Proceed to implementation
```

**If DoR NOT met:**

```
❌ DoR NOT MET - Cannot proceed

Missing:
  1. UI design (Figma link) - REQUIRED
  2. API pagination strategy - REQUIRED

ACTION:
  Run /start-task again or provide missing requirements before continuing
```

---

### STEP 2: Domain Layer Design (15 min) 📐

**Invoke:** `tech-lead` skill

**Process:**

1. Analyze use cases from Blueprint
2. Design Entity classes (core business logic)
3. Design Repository interfaces (abstract contracts)
4. Design UseCase classes (business operations)
5. Define value objects if needed
6. **VERIFY:** Domain layer has NO external dependencies

**Outputs:**

```markdown
## Domain Layer Design

### Entities

- `Photo` entity with: id, url, createdAt, metadata
- `PhotoFilter` value object with: limit, offset, sorting

### Repositories (Interfaces)

- `PhotoRepository` interface (abstract)
  - `getPhotos(offset, limit): Future<List<Photo>>`
  - `searchPhotos(query): Future<List<Photo>>`
  - `deletePhoto(id): Future<void>`

### UseCases

- `GetPhotosUseCase(repository)`
  - Handles pagination logic
  - Validates input parameters
  - Returns Result<List<Photo>>

### Value Objects

- `PhotoFilter` (limit, offset)
- `PhotoMetadata` (size, duration, EXIF)

Architecture Verification:
✅ No external packages imported
✅ No framework dependencies
✅ Pure Dart - only standard library
✅ All types immutable (@immutable)
```

---

### STEP 3: Create Domain Layer (15-20 min) 💻

**Invoke:** `vibecoder` skill (domain mode)

**Process:**

1. Create `lib/features/[feature]/domain/entities/` folder
2. Implement each Entity class with `@immutable`
3. Implement Repository interfaces (abstract)
4. Implement UseCase classes
5. Add proper null-safety
6. Follow naming conventions
7. Add doc comments (`///`)

**Outputs:**

```dart
// lib/features/photos/domain/entities/photo.dart
@immutable
class Photo {
  final String id;
  final String url;
  final DateTime createdAt;
  final PhotoMetadata? metadata;

  const Photo({
    required this.id,
    required this.url,
    required this.createdAt,
    this.metadata,
  });
}

// lib/features/photos/domain/repositories/photo_repository.dart
abstract class PhotoRepository {
  /// Fetch paginated photos from repository
  ///
  /// Parameters:
  ///   - [limit]: Number of items per page (default: 50)
  ///   - [offset]: Skip first N items (default: 0)
  ///
  /// Returns: List of Photo entities
  /// Throws: RepositoryException if fetch fails
  Future<List<Photo>> getPhotos({
    required int limit,
    required int offset,
  });
}

// lib/features/photos/domain/usecases/get_photos_usecase.dart
@injectable
class GetPhotosUseCase {
  final PhotoRepository _repository;

  GetPhotosUseCase(this._repository);

  /// Execute: Get paginated photos
  /// Validates parameters and delegates to repository
  Future<Result<List<Photo>>> call({
    required int limit,
    required int offset,
  }) async {
    try {
      // Validation
      if (limit < 1 || limit > 100) {
        return Failure('Limit must be 1-100');
      }
      if (offset < 0) {
        return Failure('Offset cannot be negative');
      }

      // Fetch
      final photos = await _repository.getPhotos(
        limit: limit,
        offset: offset,
      );

      return Success(photos);
    } catch (e) {
      return Failure('Failed to fetch photos: $e');
    }
  }
}
```

**Verification:**

- ✅ All classes in `domain/` folder
- ✅ No external dependencies
- ✅ Proper null-safety
- ✅ `@immutable` on entities

---

### STEP 4: Create Data Layer (20-30 min) 💾

**Invoke:** `vibecoder` skill (data mode)

**Process:**

1. Create DTOs (Data Transfer Objects) from API contract
2. Implement DataSources (Retrofit for API, Drift for local)
3. Implement Repository (concrete)
4. Add mappers (DTO ↔ Entity conversion)
5. Add error handling

**Outputs:**

```dart
// lib/features/photos/data/models/photo_dto.dart
@freezed
class PhotoDTO with _$PhotoDTO {
  const factory PhotoDTO({
    required String id,
    required String url,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    PhotoMetadataDTO? metadata,
  }) = _PhotoDTO;

  factory PhotoDTO.fromJson(Map<String, dynamic> json) =>
      _$PhotoDTOFromJson(json);
}

// lib/features/photos/data/datasources/photo_remote_datasource.dart
abstract class PhotoRemoteDataSource {
  Future<List<PhotoDTO>> getPhotos({
    required int limit,
    required int offset,
  });
}

@Injectable(as: PhotoRemoteDataSource)
class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final PhotoApiClient _apiClient;

  PhotoRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PhotoDTO>> getPhotos({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _apiClient.getPhotos(
        limit: limit,
        offset: offset,
      );
      return response.data ?? [];
    } catch (e) {
      throw DataSourceException('Failed to fetch photos: $e');
    }
  }
}

// lib/features/photos/data/repositories/photo_repository_impl.dart
@Injectable(as: PhotoRepository)
class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource _remoteDataSource;
  final PhotoLocalDataSource _localDataSource;

  PhotoRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Photo>> getPhotos({
    required int limit,
    required int offset,
  }) async {
    try {
      // Try remote first
      final dtos = await _remoteDataSource.getPhotos(
        limit: limit,
        offset: offset,
      );

      // Cache locally
      await _localDataSource.cachePhotos(dtos);

      // Convert DTO → Entity
      return dtos.map((dto) => dto.toDomain()).toList();
    } on Exception catch (e) {
      // Fallback to local cache
      final cached = await _localDataSource.getPhotos(offset, limit);
      if (cached.isNotEmpty) return cached;

      rethrow;
    }
  }
}
```

**Verification:**

- ✅ DTOs match API contract
- ✅ Repository implements abstract interface
- ✅ DataSources handle network errors
- ✅ Proper dependency injection

---

### STEP 5: Create Presentation Layer (20-30 min) 🎨

**Invoke:** `vibecoder` skill (presentation mode)

**Process:**

1. Create BLoC or Cubit for state management
2. Define States (Loading, Success, Error, Pagination)
3. Create Events (Fetch, LoadMore, Filter)
4. Implement Pages (full screens)
5. Create Widgets (reusable components)
6. Add error handling UI

**Outputs:**

```dart
// lib/features/photos/presentation/bloc/gallery_bloc.dart
@freezed
class GalleryState with _$GalleryState {
  const factory GalleryState.initial() = _Initial;
  const factory GalleryState.loading() = _Loading;
  const factory GalleryState.success({
    required List<Photo> photos,
    required bool hasMore,
    required int offset,
  }) = _Success;
  const factory GalleryState.error(String message) = _Error;
}

@freezed
class GalleryEvent with _$GalleryEvent {
  const factory GalleryEvent.fetchPhotos() = FetchPhotos;
  const factory GalleryEvent.loadMore() = LoadMore;
}

@injectable
class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetPhotosUseCase _getPhotosUseCase;
  static const _pageSize = 50;
  int _currentOffset = 0;

  GalleryBloc(this._getPhotosUseCase) : super(const GalleryState.initial()) {
    on<FetchPhotos>(_onFetchPhotos);
    on<LoadMore>(_onLoadMore);
  }

  Future<void> _onFetchPhotos(FetchPhotos event, Emitter<GalleryState> emit) async {
    emit(const GalleryState.loading());
    _currentOffset = 0;

    final result = await _getPhotosUseCase(
      limit: _pageSize,
      offset: _currentOffset,
    );

    result.fold(
      (failure) => emit(GalleryState.error(failure)),
      (photos) => emit(GalleryState.success(
        photos: photos,
        hasMore: photos.length >= _pageSize,
        offset: _currentOffset,
      )),
    );
  }

  Future<void> _onLoadMore(LoadMore event, Emitter<GalleryState> emit) async {
    state.mapOrNull(
      success: (state) async {
        _currentOffset += _pageSize;

        final result = await _getPhotosUseCase(
          limit: _pageSize,
          offset: _currentOffset,
        );

        result.fold(
          (failure) => emit(GalleryState.error(failure)),
          (newPhotos) {
            final allPhotos = [...state.photos, ...newPhotos];
            emit(GalleryState.success(
              photos: allPhotos,
              hasMore: newPhotos.length >= _pageSize,
              offset: _currentOffset,
            ));
          },
        );
      },
    );
  }
}

// lib/features/photos/presentation/pages/gallery_page.dart
class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<GalleryBloc>()..add(const GalleryEvent.fetchPhotos()),
      child: const GalleryView(),
    );
  }
}

class GalleryView extends StatelessWidget {
  const GalleryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) => state.when(
          initial: () => const SizedBox(),
          loading: () => const Center(child: CircularProgressIndicator()),
          success: (photos, hasMore, offset) => _buildPhotoList(
            context,
            photos,
            hasMore,
          ),
          error: (message) => Center(
            child: Text('Error: $message'),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoList(BuildContext context, List<Photo> photos, bool hasMore) {
    return ListView.builder(
      itemCount: photos.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == photos.length) {
          // Load more trigger
          context.read<GalleryBloc>().add(const GalleryEvent.loadMore());
          return const Center(child: CircularProgressIndicator());
        }

        return PhotoCard(photo: photos[index]);
      },
    );
  }
}
```

**Verification:**

- ✅ BLoC handles all states (initial, loading, success, error)
- ✅ Events properly separate concerns
- ✅ UI responds to state changes
- ✅ Error messages user-friendly

---

### STEP 6: Code Generation (5-10 min) ⚡

**Process:**

1. Run `dart run build_runner build --delete-conflicting-outputs`
2. Verify no conflicts
3. Check all `.g.dart` files generated
4. Run linter to verify generated code

**Outputs:**

```bash
$ dart run build_runner build --delete-conflicting-outputs

Building package executable...
[INFO] Generating build script...
[INFO] Running build...
[INFO] Generating Dart build script snapshot......
[INFO] Resolving asset graph...
[INFO] Generating SDK summary...
[INFO] Generating Dart build script snapshot......

[INFO] 0:00:15 Running builders...
[INFO] 0:00:35 Running builders on lib/features/photos/domain/usecases/get_photos_usecase.dart
  ✓ Generated: lib/features/photos/domain/usecases/get_photos_usecase.g.dart
[INFO] 0:00:40 Running builders on lib/features/photos/presentation/bloc/gallery_bloc.dart
  ✓ Generated: lib/features/photos/presentation/bloc/gallery_bloc.freezed.dart
  ✓ Generated: lib/features/photos/presentation/bloc/gallery_bloc.g.dart

Build succeeded!
```

---

### STEP 7: Write Tests (20-30 min) 🧪

**Invoke:** `test-engineer` skill

**Process:**

1. Create unit tests for UseCase
2. Create unit tests for Repository
3. Create widget tests for Pages
4. Create widget tests for Widgets
5. Add edge cases & error scenarios
6. Target 70%+ code coverage

**Outputs:**

```dart
// test/features/photos/domain/usecases/get_photos_usecase_test.dart
void main() {
  group('GetPhotosUseCase', () {
    late MockPhotoRepository mockRepository;
    late GetPhotosUseCase useCase;

    setUp(() {
      mockRepository = MockPhotoRepository();
      useCase = GetPhotosUseCase(mockRepository);
    });

    test('returns photos when repository succeeds', () async {
      // Arrange
      final photos = [_createPhoto()];
      when(mockRepository.getPhotos(limit: 50, offset: 0))
          .thenAnswer((_) async => photos);

      // Act
      final result = await useCase(limit: 50, offset: 0);

      // Assert
      expect(result, isA<Success>().having((s) => s.data, 'data', photos));
    });

    test('returns error when limit exceeds maximum', () async {
      // Act
      final result = await useCase(limit: 150, offset: 0);

      // Assert
      expect(result, isA<Failure>()
          .having((f) => f.message, 'message', contains('Limit must be 1-100')));
      verify(mockRepository.getPhotos(any, any)).never();
    });

    test('returns error when offset is negative', () async {
      // Act
      final result = await useCase(limit: 50, offset: -1);

      // Assert
      expect(result, isA<Failure>()
          .having((f) => f.message, 'message', contains('negative')));
    });
  });
}

// test/features/photos/presentation/bloc/gallery_bloc_test.dart
void main() {
  group('GalleryBloc', () {
    late MockGetPhotosUseCase mockGetPhotosUseCase;
    late GalleryBloc galleryBloc;

    setUp(() {
      mockGetPhotosUseCase = MockGetPhotosUseCase();
      galleryBloc = GalleryBloc(mockGetPhotosUseCase);
    });

    test('emits [Loading, Success] when FetchPhotos succeeds', () async {
      // Arrange
      final photos = [_createPhoto()];
      when(mockGetPhotosUseCase.call(any))
          .thenAnswer((_) async => Success(photos));

      // Act & Assert
      await expectLater(
        galleryBloc.stream,
        emitsInOrder([
          isA<GalleryState>(),  // initial state
          isA<Loading>(),
          isA<Success>().having((s) => s.photos, 'photos', photos),
        ]),
      );

      add(const GalleryEvent.fetchPhotos());
    });

    test('emits [Loading, Error] when FetchPhotos fails', () async {
      // Arrange
      when(mockGetPhotosUseCase.call(any))
          .thenAnswer((_) async => Failure('Network error'));

      // Act & Assert
      await expectLater(
        galleryBloc.stream,
        emitsInOrder([
          isA<GalleryState>(),
          isA<Loading>(),
          isA<Error>().having((e) => e.message, 'message', contains('Network')),
        ]),
      );

      galleryBloc.add(const GalleryEvent.fetchPhotos());
    });
  });
}

// test/features/photos/presentation/pages/gallery_page_test.dart
void main() {
  group('GalleryPage', () {
    testWidgets('displays photos when BLoC emits success', (WidgetTester tester) async {
      // Arrange - Mock BLoC
      final mockBloc = MockGalleryBloc();
      when(mockBloc.state).thenReturn(
        GalleryState.success(
          photos: [_createPhoto()],
          hasMore: false,
          offset: 0,
        ),
      );

      // Act
      await tester.pumpWidget(
        BlocProvider<GalleryBloc>(
          create: (_) => mockBloc,
          child: const MaterialApp(home: GalleryPage()),
        ),
      );

      // Assert
      expect(find.text('Gallery'), findsWidgets);
      expect(find.byType(PhotoCard), findsWidgets);
    });

    testWidgets('shows error message when BLoC emits error', (WidgetTester tester) async {
      // Arrange
      final mockBloc = MockGalleryBloc();
      whenListen(
        mockBloc,
        Stream.fromIterable([GalleryState.error('Network error')]),
        initialState: GalleryState.initial(),
      );

      // Act
      await tester.pumpWidget(
        BlocProvider<GalleryBloc>(
          create: (_) => mockBloc,
          child: const MaterialApp(home: GalleryPage()),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Network error'), findsWidgets);
    });
  });
}
```

**Verification:**

- ✅ Unit tests for domain layer
- ✅ Unit tests for data layer
- ✅ Widget tests for UI
- ✅ Error cases covered
- ✅ Coverage report generated

---

### STEP 8: Quality Audit (15 min) ✅

**Invoke:** `code-quality-auditor` skill

**Process:**

1. Run `make lint` - all warnings fixed
2. Run `make test` - all tests pass
3. Check code coverage (target: 70%+)
4. Audit architecture compliance
5. Check for performance issues
6. Generate audit report

**Outputs:**

```markdown
## 🔍 Code Quality Audit Report

### Linter Results

✅ All files formatted: `dart format lib/ test/`
✅ No linter warnings or errors
✅ Analysis completed successfully

### Test Results

✅ All tests pass: 45/45 ✓

- Domain: 12 tests
- Data: 15 tests
- Presentation: 18 tests
  ✅ Code coverage: 78% (target: 70%)
- Domain: 95%
- Data: 82%
- Presentation: 65%

### Architecture Compliance

✅ Domain layer: Pure (no dependencies)
✅ Presentation layer: Correct dependency
✅ Data layer: Implements repository interface correctly
✅ No circular dependencies detected

### Performance Analysis

✅ BLoC state transitions: Efficient
✅ Widget rebuilds: Optimized (using Selector)
✅ ListView: Using builder (not ListView)
✅ Memory: No detected leaks

### Code Quality Scores

- Architecture: 9/10 (excellent)
- Null safety: 9/10 (proper operators)
- Code organization: 8/10 (clear structure)
- Test coverage: 8/10 (78% coverage)
- Performance: 8/10 (pagination optimized)

### Issues Found

None critical or high priority.

### Recommendations

1. Consider adding more widget tests (currently 65%)
2. Document API pagination behavior

**Status:** ✅ APPROVED - Ready for /review workflow
```

---

## 🔌 Skill Integration Details

### Step 2 → Invoke `tech-lead` (Design mode)

```yaml
Input:
  feature: blueprint with use cases
  architecture: ARCHITECTURE.md rules

Output:
  domain design: entities, repositories, use cases
  architecture_verified: true
```

### Step 3 → Invoke `vibecoder` (Domain mode)

```yaml
Input:
  design: domain layer architecture
  enforcement: clean_architecture_strict = true

Output:
  domain code: entities, repositories, use cases
  verification: no_external_dependencies = true
```

### Step 4 → Invoke `vibecoder` (Data mode)

```yaml
Input:
  api_contract: from blueprint
  repositories: interfaces from domain

Output:
  data code: DTOs, datasources, repository impl
  verification: mapper_patterns = correct
```

### Step 5 → Invoke `vibecoder` (Presentation mode)

```yaml
Input:
  domain: entities + usecases
  design: ui mockups/states

Output:
  presentation code: BLoC, pages, widgets
  verification: bloc_pattern = correct
```

### Step 7 → Invoke `test-engineer`

```yaml
Input:
  feature_code: complete domain + data + presentation
  coverage_target: 70%

Output:
  tests: unit + widget test files
  verification: coverage >= 70%
```

### Step 8 → Invoke `code-quality-auditor`

```yaml
Input:
  feature_folder: complete feature
  check_types: all

Output:
  audit_report: scores + issues
```

---

## ⚠️ Error Handling

### If DoR Not Met (Step 1)

```
❌ Definition of Ready NOT MET

Missing:
  - UI design (Figma link)
  - API response schema

ACTION:
  1. Return to /start-task
  2. Complete missing requirements
  3. Re-run /implement-feature
```

### If Build Fails (Step 6)

```
❌ build_runner failed

Error: Conflict in generated files

ACTION:
  1. Run: dart run build_runner clean
  2. Run: dart run build_runner build --delete-conflicting-outputs
  3. If persists: Check model annotations, resolve JSON conflicts
```

### If Tests Fail (Step 7)

```
❌ Test coverage below 70%

Coverage: 55% (target: 70%)

ACTION:
  1. Identify uncovered code
  2. Add unit tests for domain logic
  3. Add widget tests for UI edge cases
  4. Re-run until >= 70%
```

### If Audit Fails (Step 8)

```
❌ Architecture violations found

Issues:
  1. Presentation layer imports data directly
  2. Domain layer has network dependency

ACTION:
  1. Fix architectural violations
  2. Restructure imports
  3. Re-run audit
```

---

## 💡 AI Guidelines

**Language:** All outputs must be in **Vietnamese**

**Philosophy:**

- 🎯 **Domain First** - Design domain layer before data/presentation
- ✅ **Test Everything** - Minimum 70% coverage required
- 🏗️ **Respect Clean Architecture** - Strict layer separation
- ⏸️ **Verify at Each Step** - Don't proceed if previous step fails
- 🔍 **Quality Assurance** - Audit before marking complete

---

## 📋 PR Description (Output - Step 8)

When feature is complete, generate PR description:

```markdown
## 🚀 Feature: Gallery Infinite Scroll (Riverpod)

**Feature:** Add infinite scroll pagination to gallery
**Sprint:** [Sprint name]
**Related Issue:** #[Issue ID]

### Architecture Overview
```

Domain Layer (Pure Business Logic):

- Photo entity
- PhotoRepository interface
- GetPhotosUseCase

Data Layer (External Integration):

- PhotoRemoteDataSource (Retrofit)
- PhotoLocalDataSource (Drift)
- PhotoRepositoryImpl

Presentation Layer (UI):

- GalleryBloc (State management)
- GalleryPage (Screen)
- PhotoCard (Reusable widget)

```

### Key Features
- ✅ Infinite scroll with pagination
- ✅ Offline cache fallback
- ✅ Error state UI
- ✅ Loading indicators
- ✅ 78% test coverage

### Testing
- ✅ 45 tests, all passing
- ✅ Domain: 95% coverage
- ✅ Data: 82% coverage
- ✅ Presentation: 65% coverage

### Code Quality
- ✅ `dart format` passed
- ✅ `make lint` passed
- ✅ Architecture audit: 9/10

### Manual Testing
- [x] iOS: Scroll smooth @ 60fps
- [x] Android: Scroll smooth @ 60fps
- [x] Error handling: Works correctly
- [x] Offline mode: Uses cache fallback
```

---

## 🎯 Success Criteria

✅ **DoR verified** (Step 1)  
✅ **Domain layer implemented** (Step 3)  
✅ **Data layer implemented** (Step 4)  
✅ **Presentation layer implemented** (Step 5)  
✅ **Code generation successful** (Step 6)  
✅ **Tests pass (70%+ coverage)** (Step 7)  
✅ **Audit passes** (Step 8)  
✅ **No linter warnings** (Step 8)  
✅ **Architecture compliant** (Step 8)

---

## ⏱️ Typical Duration

- DoR verification: 5 min
- Domain design: 15 min
- Domain implementation: 15-20 min
- Data implementation: 20-30 min
- Presentation implementation: 20-30 min
- Code generation: 5-10 min
- Tests: 20-30 min
- Audit: 15 min

**Total:** 2.5-3 hours (depending on feature complexity)

---

## 📝 Folder Structure After Implementation

```
lib/features/photos/
├── data/
│   ├── datasources/
│   │   ├── photo_local_datasource.dart
│   │   └── photo_remote_datasource.dart
│   ├── models/
│   │   ├── photo_dto.dart
│   │   └── photo_dto.freezed.dart
│   └── repositories/
│       └── photo_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── photo.dart
│   ├── repositories/
│   │   └── photo_repository.dart
│   └── usecases/
│       ├── get_photos_usecase.dart
│       └── get_photos_usecase.g.dart
└── presentation/
    ├── bloc/
    │   ├── gallery_bloc.dart
    │   ├── gallery_bloc.freezed.dart
    │   └── gallery_bloc.g.dart
    ├── pages/
    │   └── gallery_page.dart
    └── widgets/
        └── photo_card.dart

test/features/photos/
├── domain/
│   └── usecases/
│       └── get_photos_usecase_test.dart
├── data/
│   ├── datasources/
│   │   └── photo_remote_datasource_test.dart
│   └── repositories/
│       └── photo_repository_impl_test.dart
└── presentation/
    ├── bloc/
    │   └── gallery_bloc_test.dart
    └── pages/
        └── gallery_page_test.dart
```
