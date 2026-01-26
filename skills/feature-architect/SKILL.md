---
name: feature-architect
description: Chuyên gia thiết kế kiến trúc tính năng. Giúp phân rã yêu cầu thành các layer (Data/Domain/Presentation) và kế hoạch implementation.
---

# Feature Architect Skill (Kansuke Edition)

Sử dụng Skill này khi bạn nhận được yêu cầu tính năng mới và cần một bản thiết kế kỹ thuật chi tiết theo chuẩn Clean Architecture. Kích hoạt khi có các từ khóa: "thiết kế tính năng", "phân rã layer", "lên kế hoạch implementation", "tạo cấu trúc file cho feature".

## 🚀 When to use
- Khi bắt đầu triển khai một User Story hoặc Feature mới.
- Khi cần xác định các Class, Entity, UseCase và Repository cần thiết.
- Khi cần thiết kế schema cho Database (Drift) hoặc cấu trúc API Model.
- Khi cần một lộ trình (implementation plan) từng bước để code không bị sót.

## 🛑 When NOT to use
- Không dùng để fix bug nhỏ (dùng `bug-investigator`).
- Không dùng để review code đã có sẵn (dùng `code-reviewer`).
- Không dùng để viết code UI chi tiết (dùng `flutter-expert`).

## 💡 Example Triggers
- "Thiết kế giúp mình tính năng 'Đồng bộ ảnh lên server'."
- "Phân rã layer cho màn hình 'Danh sách Kotei' theo Clean Architecture."
- "Cần tạo cấu trúc thư mục và file cho feature 'Chỉnh sửa Profile'."
- "Lên kế hoạch triển khai tính năng 'Quét mã QR' cho app Kansuke."

## 🛠️ Quy trình Thiết kế (Design Process)
... (giữ nguyên phần Design Process)
*   **DAO Extension:** Logic query phức tạp nào cần viết thêm vào DAO?
*   **DTOs:** Cấu trúc JSON từ API mapping với Entity như thế nào?
*   **Repository Implementation:** Cách kết hợp Local DB (Drift) và Remote API (Retrofit).

### 3. Presentation Layer (Giao diện & State)
*   **BLoC/Cubit:** Định nghĩa các State (`Initial`, `Loading`, `Success`, `Failure`) và Events.
*   **Screens/Widgets:** Chia nhỏ màn hình thành các Widget con nào? Sử dụng component nào của thư viện `Cupertino`?
*   **Navigation:** Đăng ký route nào trong `AutoRouter`?

### 4. Dependency Injection (DI)
*   Cần đăng ký module nào vào `GetIt`/`Injectable`?

## 📝 Định dạng Output
Luôn trả về kế hoạch dưới dạng Markdown danh sách các việc cần làm (Todo List) và cấu trúc cây thư mục dự kiến:

**Ví dụ:**
```markdown
## 📂 File Structure Plan
- `lib/features/kotei/domain/entities/kotei.dart`
- `lib/features/kotei/data/repos/kotei_repo_impl.dart`
- ...

## 📋 Implementation Steps
1. [Domain] Define Entity & Repository Interface.
2. [Data] Implement Drift Table & DAO.
3. [User Action] Run `make gen` (AI waits here).
4. [Presentation] Implement Bloc & UI.
```

## 🔌 Interface Definition

### Inputs
- **requirement** (text): Yêu cầu nghiệp vụ (User Story)

### Outputs
- **architecture_plan** (markdown): Sơ đồ layer và danh sách file cần tạo
- **data_flow** (markdown): Luồng dữ liệu
