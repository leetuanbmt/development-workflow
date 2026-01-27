---
description: "Chuyển đổi yêu cầu nghiệp vụ thành bản thiết kế kỹ thuật chi tiết theo chuẩn Clean Architecture."
trigger: /design-feature
version: "2.4.0"
skills:
  - feature-architect
---

# 🏗️ Thiết kế Kiến trúc Tính năng (Feature Architecture Design)

**Mục tiêu:** Chuyển đổi yêu cầu nghiệp vụ thành bản thiết kế kỹ thuật chi tiết theo chuẩn Clean Architecture của dự án the project. Đảm bảo tính nhất quán giữa các layer Data, Domain, và Presentation.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Phân tích Yêu cầu (Requirement Analysis):**
    *   Xác định mục tiêu chính của tính năng.
    *   Xác định các Actors (User, System, API) tham gia vào quy trình.

2.  **Thiết kế Tầng Domain (Core Logic):**
    *   **Entities:** Định nghĩa các đối tượng dữ liệu chính (Sử dụng `freezed`).
    *   **Use Cases:** Liệt kê các hành động người dùng thực hiện (ví dụ: `GetList`, `UpdateItem`).
    *   **Repository Interface:** Định nghĩa hợp đồng (contract) dữ liệu.

3.  **Thiết kế Tầng Data (Data Handling):**
    *   **Schema:** Xác định các bảng Drift cần thiết hoặc sửa đổi bảng hiện có.
    *   **Remote/Local Sources:** Xác định các API endpoints (Retrofit) và các truy vấn DB (DAO).
    *   **Mappers:** Quy tắc chuyển đổi giữa DTO (Data Transfer Object) và Entity.

4.  **Thiết kế Tầng Presentation (UI & State):**
    *   **State Management:** Thiết kế các trạng thái (State) và sự kiện (Event) cho BLoC.
    *   **UI Components:** Phân rã màn hình thành các Widget nhỏ, tái sử dụng.
    *   **Navigation:** Cấu hình Route và tham số truyền nhận qua `AutoRouter`.

5.  **Kế hoạch Implementation (Implementation Plan):**
    *   Xây dựng danh sách Task (Todo List) theo thứ tự ưu tiên.
    *   Phác thảo cấu trúc cây thư mục mới.

## 📊 Cấu trúc Bản thiết kế (Output Structure)

### 1. Phân rã Layer (Layer Breakdown)
*   **Domain:** Entities, Use Cases, Repository Interfaces.
*   **Data:** Models/DTOs, Repository Impls, DataSources (API/DB).
*   **Presentation:** BLoC, Pages, Widgets.

### 2. Kế hoạch File (File Structure Plan)
```text
lib/features/[feature_name]/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

### 3. Danh sách Công việc (Implementation Checklist)
- [ ] Định nghĩa Domain Entities & Repo Interface.
- [ ] Thiết kế Database Schema (nếu có).
- [ ] Thực hiện Codegen (`make gen`).
- [ ] Triển khai Data Sources & Repositories.
- [ ] Xây dựng BLoC & UI.

## 💡 Hướng dẫn cho Gemini
*   Luôn tuân thủ nguyên tắc: Domain không phụ thuộc vào bất kỳ layer nào khác.
*   Sử dụng `injectable` để quản lý Dependency Injection.
*   Khuyến khích chia nhỏ task để có thể verify từng phần qua unit test.