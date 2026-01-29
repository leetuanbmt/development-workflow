---
description: "Tạo Widget UI tái sử dụng theo chuẩn Atomic Design/the project Style."
trigger: /create-component
version: "2.4.0"
---

# 🧩 Tạo UI Component

**Mục tiêu:** Xây dựng Widget độc lập (Reusable), dễ bảo trì và tuân thủ Design System của dự án. Tránh lặp lại code UI.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Phân tích Design & Scope:**
    *   Widget này thuộc loại nào?
        *   **Atom:** Nút bấm, Input, Icon, Text style cơ bản.
        *   **Molecule:** Search Bar (Input + Button), User Card (Avatar + Name).
        *   **Organism:** Header, Footer, List Product.
    *   Xác định vị trí lưu: `lib/core/presentation/widgets/` (chung toàn app) hay `lib/features/[feature]/presentation/widgets/` (riêng feature).

2.  **Coding (Implementation):**
    *   Sử dụng `StatelessWidget` nếu không cần quản lý state nội bộ.
    *   Tất cả các thuộc tính phải là `final`. Constructor nên là `const`.
    *   Không hardcode màu/size. Dùng `Theme.of(context)` hoặc `AppColors`/`AppDimens`.

3.  **Theming & Variants:**
    *   Hỗ trợ các biến thể (ví dụ: Button có `primary`, `secondary`, `disabled`).
    *   Xử lý Dark Mode/Light Mode tự động qua Theme.

4.  **Testing & Demo:**
    *   Viết Widget Test đơn giản (pumpWidget) để đảm bảo không crash.
    *   (Optional) Tạo file example cách sử dụng.

## 📝 Code Template (Ví dụ)

```dart
class the projectButton extends StatelessWidget {
  const the projectButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    // Implementation using Theme.of(context)
  }
}
```

## 💡 Hướng dẫn cho Gemini
*   Sử dụng skill `ui-ux-designer`.
*   Luôn ưu tiên tái sử dụng các widget của `Cupertino` hoặc `Material` có sẵn trước khi bọc lại (Wrap).
