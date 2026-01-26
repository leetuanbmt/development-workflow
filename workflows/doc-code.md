---
description: "Tự động thêm DartDoc comments (///) cho các Class và Method."
trigger: /doc-code
version: "2.4.0"
skills:
  - technical-writer
---

# 📚 Viết DartDoc (Code Documentation)

**Mục tiêu:** Đảm bảo mã nguồn dễ hiểu, dễ bảo trì thông qua việc cập nhật tài liệu chi tiết ở cấp độ code (Low-level).

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Phân tích Code:**
    *   Quét file được chỉ định.
    *   Tìm các Public Class, Method, Field thiếu comment.

2.  **Generate DartDoc:**
    *   Thêm comment `///` giải thích chức năng.
    *   Giải thích tham số (`[param]`), giá trị trả về (`Returns`), và lỗi ngoại lệ (`Throws`).
    *   Sử dụng skill `technical-writer`.

3.  **Refinement:**
    *   Đảm bảo comment ngắn gọn, súc tích, đúng ngữ pháp tiếng Anh (hoặc Việt tùy dự án).

## 💡 Hướng dẫn cho Gemini
*   Tập trung vào Contract (Input/Output) và Side Effects.
*   Tránh comment thừa thãi (vd: `// init variable`).