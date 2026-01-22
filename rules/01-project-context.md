---
trigger: always_on
description: Context cốt lõi của dự án Kansuke Photo. Chứa Tech Stack, Cấu trúc thư mục và Build Commands.
---

# 🏗️ Kansuke Photo - Project Context

## 1. Tổng quan (Overview)
*   **Dự án:** Kansuke Photo (Module quản lý hình ảnh/Kotei của hệ sinh thái Kansuke).
*   **Loại:** Flutter Mobile Application (Android & iOS).
*   **Workspace:** Quản lý bởi `melos` (Monorepo style).

## 2. Tech Stack (Strict)
*   **Framework:** Flutter (SDK >= 3.27.1), Dart (SDK >= 3.5.4).
*   **Architecture:** Clean Architecture (Data -> Domain -> Presentation).
*   **State Management:** `flutter_bloc`.
*   **DI:** `injectable` & `get_it`.
*   **Navigation:** `auto_route`.
*   **Database:** `drift` (SQLite).
*   **Network:** `retrofit` & `dio`.
*   **Code Gen:** `build_runner`, `freezed`, `json_serializable`.
*   **UI Library:** `Cupertino` (iOS-style widgets).

## 3. Cấu trúc Thư mục (Directory Structure)
```text
kansuke-photo/
├── lib/
│   ├── config/          # App configurations
│   ├── core/            # Shared logic, extensions, constants
│   ├── di/              # Dependency Injection setup
│   ├── features/        # Feature Modules (Clean Arch)
│   │   └── kotei/       # Example Feature
│   │       ├── data/    # Repos Impl, Data Sources, DTOs
│   │       ├── domain/  # Entities, UseCases, Repos Interfaces
│   │       └── presentation/ # Pages, Widgets, Blocs
│   └── routes/          # Navigation configurations
├── environments/        # Config files (.env.*)
├── android/             # Native Android
├── ios/                 # Native iOS
├── melos.yaml           # Workspace management
└── Makefile             # Shortcut commands
```

## 4. Các Lệnh Quan Trọng (Critical Commands)
Luôn ưu tiên sử dụng `make` hoặc `melos` thay vì lệnh `flutter` thuần để đảm bảo đúng cấu hình môi trường.

| Mục đích | Lệnh (Command) | Ghi chú |
| :--- | :--- | :--- |
| **Setup Môi trường** | `make setup` | Cài dependencies và chạy codegen lần đầu. |
| **Code Generation** | `make gen` | Chạy build_runner (xóa output cũ). |
| **Watch Gen** | `make gen-watch` | Chạy build_runner chế độ watch. |
| **Run Android** | `make build-android` | Debug mode. |
| **Run iOS** | `make build-ios` | Debug mode. |
| **Lint Check** | `make lint` | Kiểm tra format và analyze code. |
| **Unit Test** | `make test` | Chạy toàn bộ test. |

## 5. Environment Variables
*   File cấu hình nằm trong thư mục `environments/` (ví dụ: `.env.test_flight`, `.env.release`).
*   Script `configure_photo_env.sh` chịu trách nhiệm inject biến môi trường vào Native code (Gradle/Info.plist).
