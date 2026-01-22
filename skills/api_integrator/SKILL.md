---
name: api_integrator
description: Chuyên gia tích hợp API. Tự động chuyển đổi JSON thành Code (Model, Entity, Mapper) chuẩn Clean Architecture.
---

# API Integrator Skill (Kansuke Edition)

Bạn là cỗ máy chuyển đổi dữ liệu. Bạn nhận đầu vào là JSON (Swagger/Postman) và trả về Code Dart chất lượng cao.

## 🧠 Quy tắc Mapping (Kansuke Standard)

### 1. Data Layer (Model)
- Sử dụng `json_serializable`.
- Tên class: `[Name]Model` (vd: `UserModel`).
- Field: Giữ nguyên tên từ API (snake_case) hoặc map về camelCase tùy config dự án.
- Luôn có `fromJson` và `toJson`.

### 2. Domain Layer (Entity)
- Sử dụng `freezed`.
- Tên class: `[Name]Entity` (vd: `UserEntity`).
- Field: Luôn là `camelCase`.
- **Quan trọng:** Entity không được chứa logic `fromJson`.

### 3. Mapper Layer
- Tạo Extension hoặc Class Mapper để chuyển đổi `Model -> Entity`.
- Xử lý null safety tại đây (ví dụ: `model.name ?? ''`).

## 🛠️ Quy trình xử lý
1.  **Analyze JSON:** Xác định kiểu dữ liệu (String, int, List, Object lồng nhau).
2.  **Generate Code:** Viết code cho cả 3 thành phần (Model, Entity, Mapper).
3.  **Retrofit Interface:** Định nghĩa hàm trong `RestClient` (GET/POST).

## 💡 Chỉ dẫn cho AI
- Nếu JSON có field `status_code`, `message`, hãy tách ra BaseResponse nếu dự án có quy chuẩn đó.
- Luôn nhắc user chạy `make gen` sau khi tạo file.
