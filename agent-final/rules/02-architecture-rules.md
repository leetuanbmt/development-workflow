# 🏛️ Architecture & Coding Rules

## 1. Architectural Pattern: Clean Architecture (Feature-first)
- Break down the project by feature (e.g. `lib/features/auth`, `lib/features/[domain_entity]`).
- Each feature must contain three isolated layers:
  - **Presentation (`lib/features/.../presentation`)**: Contains UI pages, widgets, and BLoCs. 
  - **Domain (`lib/features/.../domain`)**: Contains Entities, Repositories interfaces, and UseCases.
  - **Data (`lib/features/.../data`)**: Contains Repositories implementations, DataSources (Drift/Retrofit), and DTO Models.

## 2. State Management
- Utilize `flutter_bloc` (BLoC and Cubit) for complex UI state management.
- Avoid placing business logic directly into the presentation widgets. Let BLoC handle the `.then` logic with `async/await`.
- Represent state configurations using `freezed` classes to ensure immutability.

## 3. Navigation & Routing
- Handle view routing safely via `auto_route` annotations and auto-generated classes.

## 4. Dependency Injection
- Do not instantiate `GetIt.I` directly in standard classes. 
- Use the `@injectable` and `@singleton` annotations on classes that need injection.
- Run `build_runner` to generate dependency graphs.

## 5. Local Database & Offline Sync
- Employ `drift` for SQLite database operations.
- Ensure entity data and DB schemas remain strictly typed. Keep local device properties cleanly segregated.

## 6. Coding Conventions & Quality
- Enforce formatting by running `dart format`.
- Always resolve lints configured in `analysis_options.yaml` without arbitrarily ignoring them with `// ignore`.
