---
trigger: always_on
description: Quy tắc kiến trúc, tiêu chuẩn coding và best practices cho Flutter/Dart trong dự án.
---

# 📐 Kansuke Photo - Architecture & Coding Rules

Bạn là một Senior Flutter Engineer tuân thủ nghiêm ngặt các nguyên tắc sau:

## 1. Clean Architecture Enforcement
Code bắt buộc phải được chia tách rõ ràng thành 3 tầng:

### A. Domain Layer (`lib/features/*/domain`)
*   **Nội dung:** Entities, UseCases, Repository Interfaces.
*   **Nguyên tắc:** 
    *   Là **Pure Dart**. Không được import thư viện Flutter (trừ khi dùng cho annotation).
    *   Entities phải Immutable (sử dụng `@freezed`).
    *   Repository Interface định nghĩa hợp đồng (contract), trả về `Future<Either<Failure, Type>>` (nếu dùng dartz/fpdart) hoặc `Future<Type>`.

### B. Data Layer (`lib/features/*/data`)
*   **Nội dung:** Repository Implementations, Data Sources (Remote/Local), Models (DTOs).
*   **Nguyên tắc:**
    *   Models/DTOs thực hiện `fromJson`/`toJson`.
    *   Map data từ Model sang Entity trước khi trả về Domain layer.
    *   **Database Logic:** Các logic database phức tạp (Drift) nên được tách thành **DAO Extensions** (ví dụ: `lib/core/extensions/databases/input_dao_ext.dart`) thay vì viết trực tiếp quá dài trong Repository.

### C. Presentation Layer (`lib/features/*/presentation`)
*   **Nội dung:** Widgets, Pages, BLoCs/Cubits.
*   **Nguyên tắc:**
    *   **Logic:** Tuyệt đối không viết Business Logic trong UI. Logic phải nằm trong BLoC.
    *   **State:** Sử dụng `flutter_bloc`. State phải Immutable (Freezed).
    *   **UI:** Ưu tiên sử dụng `Cupertino` widgets cho các thành phần giao diện chuẩn iOS.
    *   **Structure:** Tách nhỏ widget nếu file quá 150 dòng.

## 2. Coding Conventions (Quy ước)
*   **Naming:**
    *   File: `snake_case.dart`
    *   Class: `PascalCase`
    *   Variable/Function: `camelCase`
*   **Null Safety:** Không dùng `!` (bang operator) trừ khi chắc chắn 100% (cần comment giải thích). Ưu tiên dùng `?.` hoặc pattern matching.
*   **Imports:** Kiểm tra kỹ việc sử dụng relative path vs package path. Giữ nhất quán theo module hiện tại.
*   **Comments:**
    *   Bắt buộc sử dụng **`///`** (Triple Slashes) cho tài liệu (Documentation) của Class, Method, và Public Members để hỗ trợ DartDoc và IDE tooltip.
    *   Chỉ sử dụng `//` cho các giải thích logic ngắn gọn nằm bên trong thân hàm.

## 3. Quy trình Thêm Tính năng (Feature Implementation Flow)
Khi thực hiện một tính năng mới (Ví dụ: "Thêm lý do disable vào Menu"), hãy tuân thủ luồng suy nghĩ:

1.  **Domain:** Cập nhật `Entity` (thêm field flag).
2.  **Data:** Cập nhật `Model/Table` (Drift) và `DAO Extension` để lấy dữ liệu từ DB.
3.  **Presentation (Bloc):** Update State và Event để xử lý data mới.
4.  **Presentation (UI):** Update `Widget`/`Page` để hiển thị dựa trên State mới.
5.  **Codegen:** Chạy `make gen` để cập nhật code sinh tự động.

## 4. Code Generation Rules
Dự án phụ thuộc nhiều vào code generation.
*   **Khi nào chạy:** Sau khi sửa Entity, Model, API Service (Retrofit), Table (Drift), hoặc Routes.
*   **Lệnh:** `make gen` (cho one-time build) hoặc `make gen-watch`.