---
description: "Tái cấu trúc mã nguồn an toàn, đảm bảo không làm hỏng logic hiện tại."
trigger: /refactor
version: "3.0.0"
skills:
  - tech-lead
  - code-reviewer
---

# ♻️ Safe Refactoring

**Mục tiêu:** Code sạch hơn, dễ đọc hơn, nhưng chức năng phải giữ nguyên (Behavior Preserving).

## 🔄 Quy trình (Execution Flow)

### 1. Analysis & Mapping
*   **Dependency Graph:** File này được gọi bởi ai? Sửa nó thì ảnh hưởng đến module nào?
*   **Smell Detection:** Chỉ ra chính xác vấn đề (Code lặp, Long method, God class...).

### 2. Safety Net Strategy (Lưới an toàn)
*   Kiểm tra xem đã có Unit Test chưa?
*   Nếu chưa, đề xuất:
    *   Option A: Viết Test trước (Khuyên dùng).
    *   Option B: Tạo Golden Master (Lưu output hiện tại để so sánh).
    *   Option C: Manual Checklist (Nếu code UI khó test).

### 3. Incremental Execution (Thực hiện từng bước)
*   Không refactor toàn bộ file 1000 dòng một lúc.
*   Chia nhỏ: Rename trước -> Extract Method sau -> Move Class cuối cùng.
*   Sau mỗi bước nhỏ, verify lại ngay.

### 4. Final Review
*   Sử dụng `/review` hoặc skill `code-reviewer` để đảm bảo code mới tuân thủ Clean Code.

## 💡 Hướng dẫn cho AI
*   **Tôn trọng Convention:** Đặt tên biến/hàm theo đúng quy chuẩn dự án (`.agent/memory/CONVENTIONS.md`).
*   **Không thay đổi Logic:** Refactor != Fix Bug. Đừng cố sửa lỗi trong lúc refactor (trừ khi lỗi quá hiển nhiên và nhỏ).
