---
description: "Review code chi tiết cho một File, Thư mục hoặc Tính năng cụ thể (Static Analysis)."
trigger: /review-code
---

# 🧐 Review Code Chi Tiết (Detailed Code Review)

**Mục tiêu:** Kiểm tra chất lượng code, tuân thủ kiến trúc và tối ưu hiệu năng cho một phạm vi cụ thể (File/Folder/Feature) đang phát triển.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Xác định Phạm vi (Scope Identification):**
    *   Nếu input là **File**: Đọc toàn bộ nội dung file.
    *   Nếu input là **Folder**: Liệt kê (list) và đọc các file quan trọng trong folder (ưu tiên các file logic trước, UI sau).
    *   Nếu input là **Feature** (vd: "Review Kotei"): Định vị thư mục `lib/features/<feature_name>` và quét toàn bộ 3 layer (Data/Domain/Presentation).

2.  **Phân tích Chi tiết (Deep Analysis):**
    *   **Kiến trúc (Kansuke Standard):**
        *   **Domain:** Có sạch (Pure Dart) không? Có map data từ Data layer không?
        *   **Data:** Logic DB Drift phức tạp có tách ra `DAO Extension` không?
        *   **Presentation:** UI có sạch logic không? BLoC có quản lý state immutable không?
    *   **Code Quality:**
        *   **Complexity:** Hàm có quá dài (>50 dòng) hoặc lồng nhau quá sâu (nested) không?
        *   **Safety:** Kiểm tra Null Safety (tránh `!`), xử lý Exception (try-catch).
        *   **Style:** Naming convention, imports.
    *   **Performance:**
        *   Sử dụng `const` cho Widget.
        *   Tránh tính toán nặng trong hàm `build`.
        *   Kiểm tra memory leak (StreamSubscription, Controller dispose).

3.  **Tổng hợp & Đề xuất (Synthesis):**
    *   Phân loại vấn đề theo mức độ (Critical, Warning, Optimization).
    *   Cung cấp code refactor mẫu.

## 📊 Cấu trúc Báo cáo

### 1. Phạm vi Review (Review Scope)
*   **Target:** [Đường dẫn file/folder hoặc tên feature]
*   **Đánh giá chung:** [Tốt / Khá / Cần cải thiện nhiều]

### 2. Các vấn đề phát hiện (Findings)

| Mức độ | Vị trí (File/Line) | Vấn đề (Issue) | Giải thích & Gợi ý (Suggestion) |
| :--- | :--- | :--- | :--- |
| 🔴 **Critical** | `repo_impl.dart:20` | Vi phạm Arch (Gọi UI trong Data) | Inject Service/Event Bus |
| 🟡 **Warning** | `screen.dart:55` | Rebuild không cần thiết | Dùng `BlocSelector` hoặc tách Widget con |
| 🔵 **Nitpick** | `utils.dart:10` | Tên biến tối nghĩa | Rename `d` -> `date` |

### 3. Code Refactoring (Minh hoạ)
Đưa ra đoạn code so sánh (Before/After) cho vấn đề nghiêm trọng nhất.

```dart
// ❌ Before
...
// ✅ After (Refactored)
...
```

## 💡 Lưu ý
*   Luôn đối chiếu với `02-architecture-rules.md`.
*   Nếu review **Feature**, hãy kiểm tra sự liên kết giữa các layer (Data -> Domain -> Presentation).
