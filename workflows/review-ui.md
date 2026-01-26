---
description: "Đánh giá giao diện và trải nghiệm người dùng dựa trên Design System."
trigger: /review-ui
version: "2.4.0"
skills:
  - ui-ux-designer
---

# 🎨 Đánh giá UI/UX (UI/UX Review)

**Mục tiêu:** Đảm bảo giao diện lập trình đúng thiết kế, tuân thủ Design System của Kansuke và thân thiện với người dùng.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Kiểm tra Thẩm mỹ (Visual Check):**
    *   **Màu sắc:** Có sử dụng đúng biến màu trong `Theme` không? (Tránh hardcode Hex).
    *   **Typography:** Font size, weight có đúng chuẩn không?
    *   **Padding/Margin:** Khoảng cách giữa các phần tử có nhất quán không?

2.  **Kiểm tra Trải nghiệm (UX Check):**
    *   **Feedback:** Button có hiệu ứng khi tap không?
    *   **Loading:** Có hiển thị loading khi chờ data không?
    *   **Error State:** Có thông báo lỗi thân thiện khi hỏng không?
    *   **Flow:** Luồng thao tác có tự nhiên và ít bước nhất có thể không?

3.  **Kiểm tra Code UI:**
    *   Widget có bị lồng quá sâu (Nested hell) không?
    *   Có tách nhỏ Widget để tái sử dụng không?
    *   Sử dụng skill `ui-ux-designer`.

## 📊 Cấu trúc Báo cáo UI Review

### 1. Visual Bugs (Lỗi hiển thị)
*   [ ] Màu nút sai (dùng Red thay vì Primary).
*   [ ] Text bị tràn (Overflow) trên màn hình nhỏ.

### 2. UX Improvements (Cải thiện trải nghiệm)
*   [ ] Nên thêm Skeleton Loading thay vì Spinner.
*   [ ] Nút "Back" quá nhỏ, khó bấm.

## 💡 Hướng dẫn cho Gemini
*   Nếu không có file Design gốc, hãy so sánh với các màn hình hiện có trong App để đảm bảo sự nhất quán.
