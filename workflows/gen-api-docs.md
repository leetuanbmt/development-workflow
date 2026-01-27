---
description: "Tự động tạo tài liệu API từ mã nguồn."
trigger: /gen-api-docs
version: "1.0.0"
skills:
  - api-documentation-generator
  - technical-writer
---

# 📝 Generate API Docs Workflow

**Mục tiêu:** Tự động hóa việc tạo và cập nhật tài liệu API để đảm bảo đồng bộ với code.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Scan Codebase:**
    *   Quét các file Model, Repository và API Clients (Retrofit/Dio).
    *   Trích xuất comment và annotation.

2.  **Generate Documentation:**
    *   Tạo file Markdown hoặc OpenAPI Spec (Swagger).
    *   Mô tả Endpoint, Request Params, Response Schema.

3.  **Review & Refine:**
    *   Kiểm tra tính dễ hiểu của tài liệu.
    *   Thêm ví dụ minh họa (Example Usage).

4.  **Publish:**
    *   Lưu tài liệu vào thư mục `docs/api/` hoặc cập nhật Wiki.
