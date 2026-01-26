---
description: "Tự động sinh code Model, Entity, Mapper từ JSON API Response."
trigger: /integrate-api
version: "2.4.0"
skills:
  - api-integrator
---

# 🔌 Tích hợp API (API Integration)

**Mục tiêu:** Tăng tốc độ phát triển bằng cách tự động hóa quy trình viết code Data Layer từ đặc tả API (JSON).

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Input Analysis:**
    *   Người dùng cung cấp: JSON Response mẫu hoặc lệnh cURL.
    *   Xác định tên Feature và tên Object chính (ví dụ: `User`).

2.  **Generate Data Layer (Model):**
    *   Tạo file `data/models/[name]_model.dart`.
    *   Sử dụng `@JsonSerializable`.

3.  **Generate Domain Layer (Entity):**
    *   Tạo file `domain/entities/[name]_entity.dart`.
    *   Sử dụng `@freezed`.

4.  **Generate Mapper:**
    *   Tạo file `data/mappers/[name]_mapper.dart`.
    *   Viết hàm extension `toEntity()` cho Model.

5.  **Define Repository Interface:**
    *   Thêm chữ ký hàm vào `domain/repositories/i_[feature]_repository.dart`.

## 📝 Ví dụ Output
```dart
// Model
@JsonSerializable()
class UserModel {
  final String? id;
  final String? full_name;
  ...
}

// Entity
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String fullName,
  }) = _UserEntity;
}
```

## 💡 Hướng dẫn cho Gemini
*   Kích hoạt skill `api-integrator`.
*   Luôn xử lý các trường hợp Nullable một cách cẩn thận trong Mapper.
