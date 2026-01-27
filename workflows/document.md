---
description: "Tài liệu hóa mã nguồn và tính năng. Hợp nhất từ cấp độ code (DartDoc) đến cấp độ nghiệp vụ (Sequence Diagram)."
trigger: /document
version: "1.0.0"
skills:
  - technical-writer
  - product-manager
---

# 📚 Unified Documentation

**Mục tiêu:** Tạo ra hệ thống tài liệu nhất quán từ chi tiết kỹ thuật đến tổng quan nghiệp vụ.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Select Scope:**
    *   **Level 1 (Code):** Thêm DartDoc/JSDoc cho các class, method. Tập trung vào API Contract.
    *   **Level 2 (Feature):** Tạo tài liệu tính năng (Markdown). Bao gồm Sequence Diagram (Mermaid) và Architecture Overview.
    *   **Level 3 (Business):** Trích xuất Business Rules và Test Scenarios cho BA/QC.

2.  **Implementation:**
    *   Sử dụng `technical-writer` để đảm bảo văn phong chuyên nghiệp.
    *   Tự động lưu vào thư mục `docs/` nếu là tài liệu tính năng.

## 💡 Hướng dẫn cho AI
- Nếu user yêu cầu "document this file" -> Thực hiện Level 1.
- Nếu user yêu cầu "document this feature" -> Thực hiện Level 2 & 3.
