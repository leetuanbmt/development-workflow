---
description: "Điều tra và sửa lỗi. Hợp nhất từ /investigate và /fix cũ."
trigger: /fix
version: "1.0.0"
skills:
  - bug-investigator
  - vibecoder
---

# 🔧 Unified Fix & Investigate

**Mục tiêu:** Tìm nguyên nhân gốc rễ và triển khai giải pháp sửa lỗi hiệu quả nhất.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Investigation (Thám tử):**
    *   Tái hiện lỗi qua log hoặc mô tả.
    *   Truy vết Root Cause (UI -> BLoC -> Domain -> Data).
    *   Xác định phạm vi ảnh hưởng.

2.  **Proposed Solution:**
    *   Nếu lỗi đơn giản -> AI đề xuất fix và hỏi user (hoặc tự fix nếu dùng `/vibe`).
    *   Nếu lỗi phức tạp -> Đưa ra báo cáo phân tích trước.

3.  **Execution (Sửa lỗi):**
    *   Triển khai sửa lỗi với `vibecoder` (High velocity).
    *   Đảm bảo không gây side-effect (Regression check).

4.  **Verification:**
    *   Chạy lint/test liên quan.

## 💡 Hướng dẫn cho AI
- Không cần bắt buộc chạy `/investigate` trước nếu lỗi đã rõ ràng.
- Luôn ưu tiên giải pháp tối giản, ít tác động tiêu cực nhất đến hệ thống.