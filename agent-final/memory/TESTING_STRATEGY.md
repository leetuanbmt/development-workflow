> ⚠️ **Update coverage targets and test distribution after running `/init`.**

# Testing Strategy

**Version:** 2.0.0  
**Status:** Production Guide  
**Author:** test-engineer  
**Role:** Test coverage standards, testing patterns, quality gates

---

## Overview

Testing is a **first-class responsibility** in [PROJECT_NAME]. We follow a **test-driven development (TDD)** approach with the testing pyramid: many unit tests, fewer widget tests, minimal integration tests.

**Coverage Target:** 70%+ overall coverage, 90%+ for critical path (auth, photo capture, upload)

---

## Test Pyramid

```
        ┌─────────────────────────┐
        │   E2E / Integration     │ ← ~5% (UI flows only)
        │    (< 10 tests)         │
        ├────────────────────────┐│
        │   Widget / UI Tests    ├┘ ← ~25% (UI components)
        │      (100+ tests)      │
        ├────────────────────────┴┐
        │    Unit Tests          ├─→ ← ~70% (business logic)
        │  (1000+ tests)         │
        └────────────────────────┘
```

### Test Distribution

| Layer           | Priority | Count    | Coverage | Tools                 | Owners        |
| --------------- | -------- | -------- | -------- | --------------------- | ------------- |
| **Unit**        | P0       | 800-1000 | 90%+     | mockito, expect       | test-engineer |
| **Widget**      | P1       | 100-200  | 70%+     | flutter_test, falsify | QA            |
| **Integration** | P2       | 5-15     | 50%+     | integration_test      | test-engineer |
| **E2E**         | P3       | 1-5      | Manual   | Firebase Test Lab     | QA            |

---

## Unit Testing

### 1. Use Case Testing (Critical Path)

```dart
// lib/features/photo/domain/usecases/get_photos_use_case_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('GetPhotosUseCase', () {
    late GetPhotosUseCase useCase;
    late MockPhotoRepository mockRepository;

    setUp(() {
      mockRepository = MockPhotoRepository();
      useCase = GetPhotosUseCase(repository: mockRepository);
    });

    group('execute', () {
      /// ✅ SUCCESS: Happy path
      test('should return PhotoPage when repository fetch succeeds', () async {
        // Arrange
        final mockPhotos = [
          const Photo(
            id: 'photo-1',
            filePath: '/photos/img.jpg',
            createdAt: _fixedDate,
          ),
        ];
        final mockPhotoPage = PhotoPage(
          photos: mockPhotos,
          hasMore: false,
          total: 1,
        );

        when(mockRepository.getPhotos(page: 1))
          .thenAnswer((_) async => right(mockPhotoPage));

        // Act
        final result = await useCase.execute(page: 1);

        // Assert
        expect(result, right(mockPhotoPage));

        verify(mockRepository.getPhotos(page: 1)).called(1);
        verifyNoMoreInteractions(mockRepository);
      });

      /// ✅ FAILURE: Network error
      test('should return Failure when network error occurs', () async {
        // Arrange
        when(mockRepository.getPhotos(page: 1))
          .thenAnswer((_) async => left(PhotoFailure.networkError()));

        // Act
        final result = await useCase.execute(page: 1);

        // Assert
        expect(
          result,
          left(isA<PhotoFailure>()),
        );
      });

      /// ✅ BOUNDARY: Empty results
      test('should handle empty photo list', () async {
        // Arrange
        final emptyPage = PhotoPage(photos: [], hasMore: false, total: 0);
        when(mockRepository.getPhotos(page: 1))
          .thenAnswer((_) async => right(emptyPage));

        // Act
        final result = await useCase.execute(page: 1);

        // Assert
        expect(result.getOrElse(() => PhotoPage.empty()).photos, isEmpty);
      });

      /// ✅ TIMEOUT: Request takes too long
      test('should timeout after 30 seconds', () async {
        // Arrange
        when(mockRepository.getPhotos(page: 1))
          .thenAnswer((_) async => left(PhotoFailure.timeout()));

        // Act & Assert
        expect(
          () => useCase.execute(page: 1),
          completes,
        );
      });
    });
  });
}
```

### 2. Repository Testing

```dart
// lib/features/photo/data/repositories/photo_repository_impl_test.dart

void main() {
  group('PhotoRepositoryImpl', () {
    late PhotoRepositoryImpl repository;
    late MockRemotePhotoDataSource mockRemoteDataSource;
    late MockLocalPhotoDataSource mockLocalDataSource;
    late MockNetworkInfo mockNetworkInfo;

    setUp(() {
      mockRemoteDataSource = MockRemotePhotoDataSource();
      mockLocalDataSource = MockLocalPhotoDataSource();
      mockNetworkInfo = MockNetworkInfo();

      repository = PhotoRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo,
      );
    });

    group('getPhotos', () {
      /// ✅ ONLINE: Fetch from API
      test('should return remote photos when connected', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        final photoDTO = const PhotoDTO(
          id: '1',
          filePath: '/photos/img.jpg',
          createdAt: '2024-01-01',
          syncStatus: 'synced',
        );

        when(mockRemoteDataSource.getPhotos(page: 1))
          .thenAnswer((_) async => [photoDTO]);

        when(mockLocalDataSource.cachePhotos([photoDTO]))
          .thenAnswer((_) async => {});

        // Act
        final result = await repository.getPhotos(page: 1);

        // Assert
        expect(result, right(isA<List<PhotoEntity>>()));

        verify(mockRemoteDataSource.getPhotos(page: 1));
        verify(mockLocalDataSource.cachePhotos([photoDTO]));
      });

      /// ✅ OFFLINE: Fallback to cache
      test('should return cached photos when offline', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        final cachedPhotoDTOs = [const PhotoDTO(...)];
        when(mockLocalDataSource.getCachedPhotos())
          .thenAnswer((_) async => cachedPhotoDTOs);

        // Act
        final result = await repository.getPhotos(page: 1);

        // Assert
        expect(result, right(isA<List<PhotoEntity>>()));

        verifyNever(mockRemoteDataSource.getPhotos(page: any));
        verify(mockLocalDataSource.getCachedPhotos());
      });

      /// ✅ SYNC: Queue for later upload
      test('should queue photos for sync when connection restored', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        // Act
        await repository.queuePhotoForSync(photoEntity);

        // Assert
        verify(mockLocalDataSource.addToSyncQueue(any));
      });
    });
  });
}
```

### 3. Data Mapper Testing

```dart
// lib/features/photo/data/models/mappers/photo_mapper_test.dart

void main() {
  group('PhotoMapper', () {
    late PhotoMapper mapper;

    setUp(() {
      mapper = PhotoMapper();
    });

    /// ✅ MAP DTO → Entity
    test('should map PhotoDTO to PhotoEntity correctly', () {
      // Arrange
      const photoDTO = PhotoDTO(
        id: 'photo-1',
        filePath: '/photos/img.jpg',
        createdAt: '2024-01-01T12:00:00Z',
        syncStatus: 'synced',
      );

      // Act
      final entity = mapper.toDomainEntity(photoDTO);

      // Assert
      expect(entity.id, 'photo-1');
      expect(entity.filePath, '/photos/img.jpg');
      expect(entity.syncStatus, 'synced');
      expect(entity.createdAt, isA<DateTime>());
    });

    /// ✅ MAP Entity → DTO
    test('should map PhotoEntity to DTO correctly', () {
      // Arrange
      final entity = Photo(
        id: 'photo-1',
        filePath: '/photos/img.jpg',
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      final dto = mapper.toDTO(entity);

      // Assert
      expect(dto.id, 'photo-1');
      expect(dto.filePath, '/photos/img.jpg');
      expect(dto.createdAt, '2024-01-01');
    });

    /// ✅ NULL HANDLING
    test('should handle null optional fields in DTO', () {
      // Arrange
      const photoDTO = PhotoDTO(
        id: 'photo-1',
        filePath: '/photos/img.jpg',
        createdAt: '2024-01-01T12:00:00Z',
        description: null,  // Optional field
      );

      // Act
      final entity = mapper.toDomainEntity(photoDTO);

      // Assert
      expect(entity.description, isNull);
    });
  });
}
```

### 4. BLoC Testing

```dart
// lib/features/photo/presentation/bloc/photo_gallery_bloc_test.dart

void main() {
  group('PhotoGalleryBloc', () {
    late PhotoGalleryBloc photoGalleryBloc;
    late MockGetPhotosUseCase mockGetPhotosUseCase;

    setUp(() {
      mockGetPhotosUseCase = MockGetPhotosUseCase();
      photoGalleryBloc = PhotoGalleryBloc(
        getPhotosUseCase: mockGetPhotosUseCase,
      );
    });

    tearDown(() {
      photoGalleryBloc.close();  // Important: clean up resources
    });

    group('FetchPhotos', () {
      /// ✅ LOADING STATE
      test('should emit Loading then Loaded on success', () async {
        // Arrange
        final mockPhotos = [const Photo(id: '1', filePath: '/img.jpg')];
        final mockPhotoPage = PhotoPage(photos: mockPhotos, hasMore: false);

        when(mockGetPhotosUseCase.execute(page: 1))
          .thenAnswer((_) async => right(mockPhotoPage));

        // Act & Assert
        expect(
          photoGalleryBloc.stream,
          emitsInOrder([
            const PhotoState.loading(),
            PhotoState.loaded(photoPage: mockPhotoPage),
          ]),
        );

        photoGalleryBloc.add(const FetchPhotos());
      });

      /// ✅ ERROR STATE
      test('should emit Error on failure', () async {
        // Arrange
        when(mockGetPhotosUseCase.execute(page: 1))
          .thenAnswer((_) async => left(PhotoFailure.networkError()));

        // Act & Assert
        expect(
          photoGalleryBloc.stream,
          emitsInOrder([
            const PhotoState.loading(),
            const PhotoState.error(message: 'Network error'),
          ]),
        );

        photoGalleryBloc.add(const FetchPhotos());
      });

      /// ✅ MULTIPLE EVENTS
      test('should handle consecutive LoadMore events', () async {
        // Arrange
        final page1 = PhotoPage(photos: [const Photo(id: '1')], hasMore: true);
        final page2 = PhotoPage(photos: [const Photo(id: '2')], hasMore: false);

        when(mockGetPhotosUseCase.execute(page: 1))
          .thenAnswer((_) async => right(page1));
        when(mockGetPhotosUseCase.execute(page: 2))
          .thenAnswer((_) async => right(page2));

        // Act & Assert
        expect(
          photoGalleryBloc.stream,
          emitsInOrder([
            const PhotoState.loading(),
            PhotoState.loaded(photoPage: page1),
            const PhotoState.loading(),
            PhotoState.loaded(photoPage: page2),
          ]),
        );

        photoGalleryBloc.add(const FetchPhotos());
        await Future.delayed(const Duration(milliseconds: 100));
        photoGalleryBloc.add(const LoadMorePhotos());
      });
    });
  });
}
```

---

## Widget Testing

### 1. Page-level Widget Test

```dart
// lib/features/photo/presentation/pages/photo_gallery_page_test.dart

void main() {
  group('PhotoGalleryPage', () {
    late MockPhotoGalleryBloc mockPhotoGalleryBloc;

    setUp(() {
      mockPhotoGalleryBloc = MockPhotoGalleryBloc();
    });

    /// ✅ INITIAL STATE
    testWidgets('should display loading indicator initially',
        (WidgetTester tester) async {
      // Arrange
      when(mockPhotoGalleryBloc.state)
        .thenReturn(const PhotoState.loading());

      // Act
      await tester.pumpWidget(
        _createTestApp(photoGalleryBloc: mockPhotoGalleryBloc),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    /// ✅ LOADED STATE
    testWidgets('should display photos grid when loaded',
        (WidgetTester tester) async {
      // Arrange
      final mockPhotos = [
        const Photo(id: '1', filePath: '/img1.jpg'),
        const Photo(id: '2', filePath: '/img2.jpg'),
      ];
      final photoPage = PhotoPage(photos: mockPhotos, hasMore: false);

      when(mockPhotoGalleryBloc.state)
        .thenReturn(PhotoState.loaded(photoPage: photoPage));

      // Act
      await tester.pumpWidget(
        _createTestApp(photoGalleryBloc: mockPhotoGalleryBloc),
      );

      // Assert
      expect(find.byType(PhotoGridItem), findsWidgets);
      expect(find.byType(PhotoGridItem), findsNWidgets(2));
    });

    /// ✅ ERROR STATE
    testWidgets('should display error message on failure',
        (WidgetTester tester) async {
      // Arrange
      when(mockPhotoGalleryBloc.state)
        .thenReturn(const PhotoState.error(message: 'Network error'));

      // Act
      await tester.pumpWidget(
        _createTestApp(photoGalleryBloc: mockPhotoGalleryBloc),
      );

      // Assert
      expect(find.text('Network error'), findsOneWidget);
      expect(find.byType(RetryButton), findsOneWidget);
    });

    /// ✅ INFINITE SCROLL
    testWidgets('should load more on scroll to bottom',
        (WidgetTester tester) async {
      // Arrange
      final page1 = PhotoPage(photos: List.generate(20,
        (i) => Photo(id: '$i', filePath: '/img$i.jpg')),
        hasMore: true);

      when(mockPhotoGalleryBloc.state)
        .thenReturn(PhotoState.loaded(photoPage: page1));

      // Act
      await tester.pumpWidget(
        _createTestApp(photoGalleryBloc: mockPhotoGalleryBloc),
      );
      await tester.pumpAndSettle();

      // Scroll to bottom
      await tester.scroll(find.byType(GridView), Offset(0, -5000));
      await tester.pumpAndSettle();

      // Assert
      verify(mockPhotoGalleryBloc.add(const LoadMorePhotos()))
        .called(greaterThan(0));
    });
  });

  Widget _createTestApp({required MockPhotoGalleryBloc photoGalleryBloc}) {
    return MaterialApp(
      home: BlocProvider<PhotoGalleryBloc>.value(
        value: photoGalleryBloc,
        child: const PhotoGalleryPage(),
      ),
    );
  }
}
```

### 2. Component Widget Test

```dart
// lib/features/photo/presentation/widgets/photo_grid_item_test.dart

void main() {
  group('PhotoGridItem', () {
    /// ✅ RENDERING
    testWidgets('should render photo image', (WidgetTester tester) async {
      // Arrange
      const photo = Photo(
        id: 'photo-1',
        filePath: '/photos/img.jpg',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGridItem(photo: photo, onTap: () {}),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
    });

    /// ✅ INTERACTION
    testWidgets('should call onTap callback when tapped',
        (WidgetTester tester) async {
      // Arrange
      const photo = Photo(
        id: 'photo-1',
        filePath: '/photos/img.jpg',
      );

      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGridItem(
              photo: photo,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });

    /// ✅ LOADING STATE
    testWidgets('should show shimmer while loading', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PhotoGridItem.loading(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Shimmer), findsOneWidget);
    });
  });
}
```

---

## Integration Testing

### 1. Feature Integration Test

```dart
// lib/features/photo/presentation/pages/photo_gallery_integration_test.dart

void main() {
  group('Photo Gallery Feature Integration', () {
    late GetIt getIt;
    late PhotoRepository photoRepository;
    late PhotoGalleryBloc photoGalleryBloc;

    setUp(() async {
      // Arrange: Initialize real instances (not mocks)
      getIt = GetIt.instance;

      // Use fake data sources
      getIt.registerSingleton<PhotoRepository>(
        FakePhotoRepository(),  // Pre-populated with test data
      );

      photoRepository = getIt<PhotoRepository>();
      photoGalleryBloc = PhotoGalleryBloc(
        getPhotosUseCase: GetPhotosUseCase(repository: photoRepository),
      );
    });

    tearDown(() async {
      photoGalleryBloc.close();
      getIt.reset();
    });

    testWidgets('should display cached photos without network',
        (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        BlocProvider<PhotoGalleryBloc>.value(
          value: photoGalleryBloc,
          child: const MaterialApp(
            home: PhotoGalleryPage(),
          ),
        ),
      );

      // Emit event
      photoGalleryBloc.add(const FetchPhotos());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PhotoGridItem), findsNWidgets(5));  // 5 cached photos
    });

    testWidgets('should sync photos on network restoration',
        (WidgetTester tester) async {
      // Arrange: Start offline with pending photos
      final photos = await photoRepository.getSyncQueuePhotos();
      expect(photos, hasLength > 0);

      // Act: Simulate network restoration
      (photoRepository as FakePhotoRepository).simulateNetworkRestored();
      photoGalleryBloc.add(const SyncPendingPhotos());
      await tester.pumpAndSettle(Duration(seconds: 2));

      // Assert
      final syncedPhotos = await photoRepository.getSyncQueuePhotos();
      expect(syncedPhotos, isEmpty);  // All synced
    });
  });
}
```

---

## Test Data Builders

### Factory Pattern for Test Data

```dart
// lib/test/builders/photo_builder.dart

class PhotoBuilder {
  String id = 'photo-1';
  String filePath = '/photos/test.jpg';
  DateTime createdAt = DateTime(2024, 1, 1);
  String syncStatus = 'synced';
  String? description;

  PhotoBuilder withId(String id) {
    this.id = id;
    return this;
  }

  PhotoBuilder withSyncStatus(String status) {
    this.syncStatus = status;
    return this;
  }

  PhotoBuilder pending() {
    syncStatus = 'pending';
    return this;
  }

  PhotoBuilder synced() {
    syncStatus = 'synced';
    return this;
  }

  Photo build() => Photo(
    id: id,
    filePath: filePath,
    createdAt: createdAt,
    syncStatus: syncStatus,
    description: description,
  );
}

// Usage:
final photo = PhotoBuilder()
  .withId('photo-123')
  .pending()
  .build();

final photos = List.generate(10,
  (i) => PhotoBuilder()
    .withId('photo-$i')
    .synced()
    .build(),
);
```

---

## Mocking Strategy

### Using Mockito

```dart
// lib/test/mocks/mock_photo_repository.dart

import 'package:mockito/mockito.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}
class MockPhotoApiClient extends Mock implements PhotoApiClient {}
class MockLocalDatabase extends Mock implements LocalDatabase {}

// Usage with when/thenAnswer
void main() {
  test('example', () async {
    final mock = MockPhotoRepository();

    when(mock.getPhotos(page: 1))
      .thenAnswer((_) async => right(mockPhotoPage));

    final result = await mock.getPhotos(page: 1);

    verify(mock.getPhotos(page: 1)).called(1);
  });
}
```

### Using Mocktail (Modern Alternative)

```dart
// lib/test/mocks/mocktail_mocks.dart

import 'package:mocktail/mocktail.dart';

class MockPhotoRepository extends Mock implements PhotoRepository {}

void main() {
  test('example', () async {
    final mock = MockPhotoRepository();

    when(() => mock.getPhotos(page: 1))
      .thenAnswer((_) async => right(mockPhotoPage));

    final result = await mock.getPhotos(page: 1);

    verify(() => mock.getPhotos(page: 1)).called(1);
  });
}
```

---

## Coverage Requirements

### Critical Path (90%+ coverage)

- [ ] `lib/features/auth/` - Authentication
- [ ] `lib/features/photo/domain/usecases/` - All use cases
- [ ] `lib/features/qr_code/` - QR scanning
- [ ] `lib/core/error/` - Error handling
- [ ] `lib/core/extensions/` - Extension methods

```bash
# Check coverage
codecov --required --minimum-coverage 90
```

### Standard Path (70%+ coverage)

- [ ] `lib/features/*/data/repositories/` - Repository implementations
- [ ] `lib/features/*/data/models/` - Data models and mappers
- [ ] `lib/core/di/` - Dependency injection setup
- [ ] `lib/core/network/` - Network utilities

### UI Layer (50%+ coverage)

- [ ] `lib/features/*/presentation/pages/` - Full page tests
- [ ] `lib/features/*/presentation/widgets/` - Component tests
- [ ] Not required: Trivial setters/getters

---

## Running Tests

### Run All Tests

```bash
# All tests in debug mode
make test

# With coverage
make test-coverage

# Watch mode (re-run on changes)
dart test --watch
```

### Run Specific Tests

```bash
# Single test file
dart test lib/features/photo/domain/usecases/get_photos_use_case_test.dart

# Single test
dart test -n "should return PhotoPage when repository fetch succeeds"

# By pattern
dart test -k "Widget"  # Run all widget tests
```

### Coverage Report

```bash
# Generate coverage
dart test --coverage=coverage

# Report
format_coverage --packages=.packages -i coverage/coverage.lcov --report-on=lib > coverage.html

# View
open coverage.html  # Or visit in browser
```

---

## CI/CD Integration

### GitHub Actions (`.github/workflows/test.yml`)

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.27.1"

      - name: Get dependencies
        run: flutter pub get

      - name: Run tests
        run: dart test

      - name: Coverage
        run: |
          dart test --coverage=coverage
          format_coverage --packages=.packages -i coverage/coverage.lcov --report-on=lib

      - name: Upload coverage
        uses: codecov/codecov-action@v2
        with:
          files: ./coverage.lcov
```

---

## Test Best Practices

### ✅ DO

- [ ] Test behavior, not implementation
- [ ] One assertion per test (arrange-act-assert pattern)
- [ ] Use descriptive test names
- [ ] Mock external dependencies (API, database)
- [ ] Test both happy path and error cases
- [ ] Use builders for complex test data
- [ ] Verify interactions (verify mockito calls)
- [ ] Clean up resources in tearDown()

### ❌ DON'T

- [ ] Test Flutter internals (don't test `Text` widget)
- [ ] Create circular dependencies between tests
- [ ] Use `Thread.sleep()` instead of `await`
- [ ] Ignore flaky tests
- [ ] Mock everything (test real repository logic)
- [ ] Skip error case tests
- [ ] Duplicate test data
- [ ] Print debug output in production code

---

## Quality Gates

### Before Merge

| Gate         | Target    | Tool         | Command                                  |
| ------------ | --------- | ------------ | ---------------------------------------- |
| **Tests**    | 100% pass | flutter_test | `make test`                              |
| **Coverage** | 70%+      | codecov      | `make test-coverage`                     |
| **Lint**     | 0 errors  | dart_lint    | `make lint`                              |
| **Format**   | 0 diffs   | dart_format  | `dart format --set-exit-if-changed lib/` |

### CI Pipeline

```
1. Code pushed
   ↓
2. Run tests (fail → block)
   ↓
3. Check coverage (< 70% → warning)
   ↓
4. Run linter (errors → block)
   ↓
5. Format check (diffs → block)
   ↓
6. Ready for review
```

---

## Common Issues & Solutions

### Issue: "Test hangs forever"

```dart
❌ Missing await:
test('example', () async {
  // Never awaited!
  useCase.execute();  // BUG
});

✅ Fix: Always await async operations
test('example', () async {
  final result = await useCase.execute();  // ✅
  expect(result, isNotNull);
});
```

### Issue: "Mockito error: 'Unfinished stubs'"

```dart
❌ Forgot setUp:
test('example', () {
  final mock = MockPhotoRepository();
  // Mock not configured before use
  await mock.getPhotos();  // ERROR
});

✅ Fix: Configure mock in setUp or before use
setUp(() {
  mock = MockPhotoRepository();
  when(mock.getPhotos(page: any))
    .thenAnswer((_) async => right(mockPage));
});
```

### Issue: "Widget test fails: 'No Material widget found'"

```dart
❌ Missing Material app:
testWidgets('example', (tester) async {
  await tester.pumpWidget(MyWidget());  // Missing MaterialApp
});

✅ Fix: Wrap with Material app
testWidgets('example', (tester) async {
  await tester.pumpWidget(
    MaterialApp(home: MyWidget()),
  );
});
```

---

## Summary

| Aspect                | Standard                  | Target             |
| --------------------- | ------------------------- | ------------------ |
| **Unit Tests**        | Minimum 70% of test count | 800-1000 tests     |
| **Widget Tests**      | 100-200 tests             | 50+ per feature    |
| **Integration Tests** | Minimal (E2E only)        | 5-15 tests         |
| **Coverage**          | 70%+ overall              | 90%+ critical path |
| **Test Pyramid**      | 70:25:5 ratio             | Never inverted     |
| **Test Speed**        | All unit tests < 5s       | 3s target          |
| **CI/CD**             | Gating all merges         | 100% enforcement   |

---

**Reference:**

- [Flutter Testing](https://flutter.dev/docs/testing)
- [Mockito](https://pub.dev/packages/mockito)
- [BLoC Testing](https://bloclibrary.dev/#/fluttertestingblocwithtestbloc)
