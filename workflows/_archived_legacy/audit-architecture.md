---
description: "Phân tích độ tuân thủ kiến trúc dựa trên nguyên tắc Dependency Rule và Separation of Concerns (Linh hoạt theo Context)."
trigger: /audit-architecture
version: "3.0.0"
skills:
  - feature-architect
  - code-reviewer
  - codebase_investigator
---

# 🏗️ Dynamic Architecture Audit

**Mục tiêu:** Đánh giá chất lượng kiến trúc dựa trên nguyên tắc (Principles) thay vì cấu trúc thư mục cứng nhắc (Structure). Đảm bảo tính linh hoạt cho các module có độ phức tạp khác nhau.

## 🚀 Quy trình Audit (The Audit Loop)

### Bước 1: Context Discovery (Khám phá ngữ cảnh)
*Trước khi phán xét, phải hiểu luật chơi của module đó.*
1.  **Đọc cấu hình dự án:** Đọc `.agent/memory/ARCHITECTURE.md` để lấy "Luật chung" (nếu có).
2.  **Phân tích Module:** Quét module được chỉ định để xác định Pattern đang dùng (Clean Arch, MVC, Vertical Slice, hay Simple Provider).
3.  **Xác định Ranh giới (Boundaries):** Đâu là UI? Đâu là Logic? Đâu là Data?

### Bước 2: Dependency Graph Analysis (Phân tích phụ thuộc)
*Kiểm tra luồng dữ liệu và sự phụ thuộc.*
1.  **Check Dependency Rule:**
    *   Lớp Business (Domain/Logic) CÓ phụ thuộc vào UI/Framework không? (❌ Cấm kỵ)
    *   Lớp Business CÓ phụ thuộc trực tiếp vào DB/API (Data) không? (❌ Nên qua Interface/Repository)
2.  **Check Coupling:**
    *   Các Feature có import chéo nhau bừa bãi không?
    *   Có file nào import quá nhiều package (God Object) không?

### Bước 3: Logic Distribution (Phân bổ logic)
1.  **UI Layer:** Chỉ chứa logic hiển thị (Render)? Có chứa logic gọi API hay xử lý data phức tạp không?
2.  **State Management:** State có được quản lý tập trung (Bloc/Provider) hay rải rác trong `setState`?
3.  **Data Layer:** Có mapping dữ liệu thô (DTO) sang Business Model sạch sẽ không?

### Bước 4: Report & Recommendations
*Báo cáo dựa trên ngữ cảnh.*
*   **Với Core Feature:** Yêu cầu Clean Arch nghiêm ngặt.
*   **Với UI Component/Utility:** Chấp nhận cấu trúc đơn giản, miễn là tách biệt UI và Logic.
*   **Format:**
    *   ✅ **Good:** Những điểm tuân thủ tốt nguyên tắc SOLID.
    *   ⚠️ **Warning:** Điểm có thể gây Technical Debt (Hard dependency, Magic numbers).
    *   🔴 **Violation:** Vi phạm nghiêm trọng (Domain gọi UI, Circular Dependency).

## 💡 Hướng dẫn cho AI (Auditor Mindset)
*   **Không giáo điều:** Đừng bắt buộc một Simple Widget phải có đủ Domain/Data layer. Hãy audit dựa trên *độ phức tạp* của nó.
*   **Tập trung vào "Why":** Nếu code vi phạm, hãy giải thích *tại sao* nó nguy hiểm (VD: Khó test, khó bảo trì) thay vì chỉ nói "Sai quy tắc".
*   **Sử dụng `codebase_investigator`:** Để vẽ sơ đồ phụ thuộc trước khi kết luận.