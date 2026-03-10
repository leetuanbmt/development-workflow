# 🏛️ Architecture & Coding Standards

## 1. Architectural Pattern: Clean Architecture (Feature-based)

Dự án tuân theo kiến trúc Clean Architecture được tổ chức theo tính năng (Feature-first).

### Layers (Tầng):
1.  **Presentation Layer:**
    *   **Widgets:** UI components (Pages, Views, Widgets). `StatelessWidget` được ưu tiên.
    *   **State Management:** BLoC / Cubit. Logic UI, xử lý trạng thái.
2.  **Domain Layer:**
    *   **Entities:** Pure Dart objects, không phụ thuộc framework (dùng `freezed`).
    *   **Repositories (Interfaces):** Định nghĩa hợp đồng (contract) cho việc truy xuất dữ liệu.
    *   **UseCases:** (Optional) Logic nghiệp vụ thuần túy.
3.  **Data Layer:**
    *   **Data Sources:** Gọi API (Retrofit), truy cập DB (Drift), SharedPreferences.
    *   **Repositories (Implementation):** Triển khai interface từ Domain layer.
    *   **Models (DTOs):** Data Transfer Objects, map dữ liệu từ JSON/DB sang Entity.

## 2. Coding Conventions

### General
*   **Linting:** Tuân thủ nghiêm ngặt `analysis_options.yaml`. Không suppress lints trừ khi bất khả kháng.
*   **Formatting:** Luôn chạy `dart format` trước khi commit.
*   **Naming:**
    *   Classes: `PascalCase`
    *   Variables/Functions: `camelCase`
    *   Files: `snake_case.dart`

### State Management (BLoC)
*   Mỗi màn hình phức tạp nên có một BLoC/Cubit riêng.
*   Event và State nên dùng `freezed` để đảm bảo immutability và pattern matching.
*   UI chỉ lắng nghe State và gửi Event. Không xử lý logic nghiệp vụ trong UI.

### Dependency Injection (Injectable)
*   Sử dụng `@injectable`, `@singleton`, `@lazySingleton` để đăng ký dependencies.
*   Luôn inject qua Constructor. Tránh dùng `GetIt.I` trực tiếp trong class.

### Asynchronous Programming
*   Dùng `async`/`await` thay vì `.then()`.

## 3. Testing Strategy
*   **Unit Tests:** Test BLoC, UseCases, Repositories. Mock dependencies bằng `mockito`.

## 4. File Structure (Example Feature)
```
lib/features/[domain_entity]/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```
