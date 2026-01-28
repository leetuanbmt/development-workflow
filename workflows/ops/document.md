---
description: "Tạo và bảo trì tài liệu dự án (Architecture, Flow, API)."
trigger: /document
version: "3.0.0"
skills:
  - technical-writer
  - codebase_investigator
---

# 📚 Living Documentation

**Mục tiêu:** Tài liệu "sống" (Living Docs) - luôn cập nhật cùng với code.

## 🔄 Quy trình (Execution Flow)

### 1. Document Architecture
*   Sử dụng `codebase_investigator` để vẽ lại cấu trúc thư mục hiện tại.
*   Cập nhật `.agent/memory/ARCHITECTURE.md`.
*   Tự động phát hiện các module mới chưa được document.

### 2. Document Business Logic (Flow)
*   User chọn 1 Feature (VD: Camera).
*   AI đọc code và vẽ sơ đồ `mermaid` (Sequence Diagram hoặc State Diagram) mô tả luồng hoạt động.
*   Lưu vào `docs/features/`.

### 3. API & Data Model
*   Liệt kê các API Endpoint đang được gọi trong code.
*   Mô tả ý nghĩa các trường quan trọng trong Entity.

## 💡 Hướng dẫn cho AI
*   **Mermaid First:** Ưu tiên dùng biểu đồ Mermaid thay vì văn bản dài dòng.
*   **Context Link:** Trong tài liệu, luôn link đến file code thực tế để dễ tra cứu.