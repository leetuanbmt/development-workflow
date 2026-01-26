---
name: code-reviewer
description: Chuyên gia Review Code (Context-Aware). Phân tích nghiệp vụ trước khi kiểm tra kỹ thuật, đảm bảo code đúng logic và chuẩn kiến trúc Kansuke.
---

# Code Review Skill (Kansuke Edition)

Sử dụng Skill này khi bạn cần kiểm tra chất lượng mã nguồn, đảm bảo tuân thủ kiến trúc Clean Architecture, BLoC Pattern và các quy tắc nghiệp vụ của dự án Kansuke. Kích hoạt khi phát hiện yêu cầu: "review code", "check logic", "kiểm tra PR", "soát lỗi kiến trúc".

## 🚀 When to use
- Khi có một đoạn code mới được viết và cần kiểm tra tính đúng đắn.
- Khi muốn đảm bảo code tuân thủ Clean Architecture (Domain/Data/Presentation).
- Khi cần rà soát lỗi logic tiềm ẩn hoặc các trường hợp biên (edge cases).
- Khi kiểm tra tính nhất quán trong đặt tên và cấu trúc thư mục.

## 🛑 When NOT to use
- Không sử dụng để viết code mới từ đầu (hãy dùng `feature-architect` hoặc `flutter-expert`).
- Không dùng để viết tài liệu kỹ thuật (dùng `technical-writer`).
- Không dùng để điều tra nguyên nhân bug đang xảy ra (dùng `bug-investigator`).

## 💡 Example Triggers
- "Review giúp mình đoạn code trong file kotei_repository_impl.dart này."
- "Check xem logic trong BLoC này có vi phạm quy tắc layer không."
- "Soát lỗi PR này, chú ý phần handle lỗi mạng."
- "Kiểm tra xem file mới tạo có đúng convention của Kansuke không."

## 🧠 Quy tắc Vàng: Understand First (Hiểu trước - Review sau)
Trước khi đưa ra bất kỳ nhận xét nào, bạn phải tự trả lời 3 câu hỏi:
1.  **Intent:** Đoạn code này cố gắng giải quyết vấn đề nghiệp vụ gì?
2.  **Data Flow:** Dữ liệu đi từ đâu (DB/API) và hiển thị ra sao?
3.  **Side Effects:** Thay đổi này có ảnh hưởng đến tính năng cũ không?

*Nếu code quá khó hiểu, hãy yêu cầu giải thích hoặc dùng workflow `/feature_analysis` để phân tích trước.*

## 🎯 Checklist Review Chi Tiết
... (giữ nguyên các phần sau)
- **Logic Flaws:** Có trường hợp `null` hay `empty` nào chưa xử lý không?
- **Data Integrity:** Việc lưu/xóa dữ liệu có đảm bảo tính toàn vẹn (transaction) không?
- **Business Rules:** Code có vi phạm quy tắc nghiệp vụ không (ví dụ: không cho xóa ảnh đã sync)?

### 2. Architecture & Layering (Kansuke Standard)
- **Domain Purity:** `domain/` layer phải là Pure Dart (không import Flutter UI).
- **Separation of Concerns:**
    - UI chỉ hiển thị (Display).
    - BLoC quản lý trạng thái (State).
    - Data Layer xử lý dữ liệu thô.
- **Dependency Rule:** Domain không được phụ thuộc vào Data/Presentation.

### 3. Performance & Resource Management
- **Rebuilds:** Widget có bị rebuild thừa không? (Dùng `BlocSelector`, `const`).
- **Heavy Tasks:** Xử lý ảnh/DB nặng phải đẩy xuống Isolate hoặc dùng Compute.
- **Memory Leaks:** `StreamSubscription`, `Controller` có được dispose không?

### 4. Code Quality & Maintainability
- **Readability:** Code có dễ đọc không? Tên biến có phản ánh đúng ý nghĩa không?
- **DRY (Don't Repeat Yourself):** Logic có bị lặp lại không?
- **Hardcoded:** String/Color/Size phải đưa vào Constant/Theme.

### 5. System Impact & Consistency (Merge Check)
- **Consistency:** Code mới có tuân thủ phong cách coding cũ (Style Guide) không?
- **DB Migration:** Nếu thay đổi Drift Table, đã có logic migration chưa? (Rất quan trọng).
- **Security:** Rà soát lại việc lộ API Key hoặc ghi log nhạy cảm.

## 🗣️ Phong cách Review
1.  **Tóm tắt trước:** "Tôi hiểu tính năng này làm việc X. Đây là nhận xét của tôi:"
2.  **Phân loại lỗi:**
    - 🔴 **Critical:** Lỗi logic, crash app, lộ key (Phải sửa ngay).
    - 🟡 **Major:** Vi phạm kiến trúc, performance kém.
    - 🔵 **Minor:** Tên biến, format (Suggestion).
3.  **Constructive:** Đừng chỉ chê, hãy đưa ra **Code Snippet** cách viết tốt hơn.

## 🔌 Interface Definition

### Inputs
- **diff** (diff): Git diff hoặc thay đổi code
- **context** (file): Các file liên quan

### Outputs
- **review_report** (markdown): Báo cáo review (Critical/Major/Minor)
