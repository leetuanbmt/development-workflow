---
description: "Tạo báo cáo tổng quan dự án (Project Onboarding) dành cho PM/QC/Dev mới."
trigger: /project-overview
version: "2.4.0"
skills:
  - tech-lead
  - technical-writer
---

# 📋 Báo Cáo Tổng Quan Dự Án (Project Overview)

**Mục tiêu:** Cung cấp cái nhìn tổng quan toàn diện về dự án, bao gồm thông tin nghiệp vụ, công nghệ, kiến trúc và quy trình phát triển. Dùng để onboarding thành viên mới (PM, QC, Dev).

**Role:** AI sẽ ưu tiên sử dụng skill `tech_lead` (nếu có) để phân tích sâu về kiến trúc và quyết định kỹ thuật.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Kích hoạt Skill (Optional):**
    *   Nếu có skill `tech_lead`, hãy kích hoạt nó để có góc nhìn quản lý kỹ thuật.

2.  **Thu thập thông tin Công nghệ & Phiên bản:**
    *   Đọc `pubspec.yaml`, `melos.yaml` để xác định:
        *   Tên & Mô tả dự án.
        *   Phiên bản SDK Flutter/Dart.
        *   Các thư viện cốt lõi (State Mng, Network, DB, Nav, UI Kit...).

3.  **Phân tích Nghiệp vụ & Features:**
    *   Liệt kê thư mục cấp 1 trong `lib/features/` để xác định các tính năng chính.
    *   Kết hợp đọc `README.md` hoặc tài liệu trong `.agent/` để hiểu ngữ cảnh nghiệp vụ (Domain Knowledge).

4.  **Kiểm tra Kiến trúc & Quy mô:**
    *   Xác định cấu trúc thư mục chính (`lib/core`, `lib/shared`, v.v.).
    *   Nhận diện pattern kiến trúc (Clean Architecture, MVVM, Layered...).
    *   Đánh giá sơ bộ về Convention (Naming, structure).

5.  **Rà soát Quy trình & Môi trường:**
    *   Kiểm tra thư mục `environments/` để liệt kê các môi trường khả dụng.
    *   Đọc `Makefile` để nắm các lệnh build/run/test chuẩn.
    *   Kiểm tra sự tồn tại của CI/CD (`.github/workflows`).

## 📝 Mẫu Báo Cáo Đầu Ra (Output Format)

Kết quả trả về phải tuân theo cấu trúc sau:

### 1. Thông tin Chung (Overview)
*   **Tên dự án:** ...
*   **Mục đích/Loại app:** (Mô tả ngắn gọn business goal)
*   **Phiên bản Flutter/Dart:** ...

### 2. Công nghệ & Kiến trúc (Tech Stack & Architecture)
*   **Kiến trúc:** (VD: Clean Architecture, Feature-first...)
*   **State Management:** ...
*   **Navigation:** ...
*   **Database/Storage:** ...
*   **Network:** ...
*   **Công cụ khác:** (Melos, Build Runner...)

### 3. Tính Năng Chính (Key Features)
*   Liệt kê các feature tìm thấy và mô tả ngắn (nếu đoán được từ tên):
    *   `feature_a`: ...
    *   `feature_b`: ...

### 4. Quy trình Phát triển (Development Workflow)
*   **Môi trường:** (Liệt kê các env tìm thấy trong `environments/`)
*   **Lệnh quan trọng:** (Trích xuất từ Makefile: setup, build, test...)
*   **CI/CD:** (Có/Không, dùng tool gì?)

---
*Lưu ý: Báo cáo này được tổng hợp tự động từ hiện trạng source code bởi AI (vai trò Tech Lead).*
