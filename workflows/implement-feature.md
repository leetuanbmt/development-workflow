---
description: "Triển khai tính năng mới từ bản thiết kế hoặc Spec theo chuẩn Clean Architecture."
trigger: /implement-feature
---

# 🔨 Triển khai Tính năng (Feature Implementation)

**Mục tiêu:** Chuyển đổi bản thiết kế (Design) hoặc Spec thành mã nguồn chất lượng cao, tuân thủ Clean Architecture và đã được kiểm thử.

## 📋 Yêu cầu đầu vào (Input Requirements)
Để bắt đầu hiệu quả nhất, người dùng cần cung cấp:
*   **Mô tả tính năng:** User Story hoặc Specs chi tiết.
*   **Design (nếu có):** Figma link, screenshot hoặc mô tả UI component.
*   **Database Schema:** Nếu có thay đổi về bảng dữ liệu.

## 🧠 Chiến lược thực hiện (Execution Strategy)
*   **Sequential Implementation:** Không code toàn bộ 3 layers cùng lúc. Thực hiện tuần tự: Domain -> Data -> Presentation.
*   **Verification:** Sau mỗi layer, phải kiểm tra tính đúng đắn (như chạy build_runner hoặc test) trước khi sang layer tiếp theo.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Chuẩn bị (Preparation):**
    *   Đọc kỹ Spec hoặc Design Doc (nếu có).
    *   Kích hoạt skill `feature-architect` nếu cần làm rõ kiến trúc.
    *   Tạo nhánh git mới: `git checkout -b feature/[tên-tính-năng]`.

2.  **Triển khai Tầng Domain (Domain Implementation):**
    *   Tạo `Entity` (Freezed).
    *   Định nghĩa `Repository Interface`.
    *   Viết `UseCase` và Unit Test cho UseCase.

3.  **Triển khai Tầng Data (Data Implementation):**
    *   Tạo `Model` (DTO) và Mapper.
    *   Implement `Repository`.
    *   Cấu hình `Retrofit` API hoặc `Drift` Table.
    *   Chạy `make gen`.

4.  **Triển khai Tầng Presentation (UI Implementation):**
    *   Tạo `Bloc/Cubit`, định nghĩa State/Event.
    *   Viết Test cho Bloc.
    *   Xây dựng Widget/Page (sử dụng `ui-ux-designer` skill để tham vấn).

5.  **Review & Refine:**
    *   Tự review code (Self-Review).
    *   Chạy `make lint` và `make test`.

## 📊 Cấu trúc Báo cáo Tiến độ

### 1. Trạng thái (Status)
*   **Domain:** ✅ Hoàn thành / 🚧 Đang làm
*   **Data:** ✅ Hoàn thành / 🚧 Đang làm
*   **Presentation:** ✅ Hoàn thành / 🚧 Đang làm

### 2. Các thay đổi chính (Key Changes)
*   Liệt kê các file quan trọng đã tạo/sửa.

### 3. Vấn đề gặp phải (Blockers)
*   Nếu có, mô tả chi tiết để PM/Architect hỗ trợ.