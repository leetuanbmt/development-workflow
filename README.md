# 🤖 AI Development Workflow (SOP)

Đây là bộ cấu hình chuẩn cho hệ thống AI Agent hỗ trợ phát triển dự án. Quy trình này được thiết kế để cân bằng giữa **tốc độ phát triển** và **tính ổn định của hệ thống** (Clean Architecture).

---

## 🚦 Master Workflow: `/start-task`
Mọi tác vụ bắt đầu bằng lệnh `/start-task`. AI sẽ không bao giờ code ngay mà thực hiện 3 bước:
1.  **Memory Check:** Tìm kiếm bài học cũ trong Knowledge Base.
2.  **Internal Simulation (Brainstorming):** Giả lập cuộc họp giữa BA, Architect và QA Lead để tìm rủi ro.
3.  **Mode Selection:** Chọn chế độ `Standard` (Full quy trình), `Hotfix` (Làm nhanh), hoặc `Prototype` (POC).

---

## ⏸️ Code Gen Checkpoint (QUAN TRỌNG)
Dự án phụ thuộc vào Code Generation (`Freezed`, `Drift`, `Retrofit`). Để tối ưu tài nguyên:
*   **AI Action:** Khi sửa file gốc, AI sẽ **DỪNG LẠI** tại checkpoint.
*   **User Action:** Người dùng tự chạy lệnh `make gen` trên máy local.
*   **Resume:** AI tiếp tục viết code logic sau khi người dùng xác nhận "OK".

---

## 🛠 Các Lệnh Điều phối (Workflows)

| Lĩnh vực | Lệnh (Command) | Mục đích |
| :--- | :--- | :--- |
| **Setup** | `/setup-agent` | Khởi tạo ngữ cảnh dự án (Tech Stack, Rules). |
| **Đặc tả** | `/write-spec` | Viết User Stories và Acceptance Criteria. |
| **Kiến trúc** | `/design-feature` | Thiết kế các layer (Domain/Data/Presentation). |
| **Phát triển** | `/implement-feature`| **(Atomic Execution)** Chia nhỏ task, code từng phần. |
| **Chất lượng** | `/review-code` | Review code dựa trên chuẩn Clean Architecture & Lint. |
| **Sửa lỗi** | `/investigate` | Điều tra nguyên nhân gốc rễ (Root Cause Analysis). |

---

## 📐 Nguyên tắc Cốt lõi (Core Rules)

1.  **Atomic Execution:** Chia nhỏ task lớn. Code không quá 150 dòng/file. Dừng lại xác nhận sau mỗi file lớn.
2.  **Clean Architecture:** Tuân thủ nghiêm ngặt 3 layer. Domain layer là Pure Dart.
3.  **Context-Aware Review:** Reviewer phải hiểu nghiệp vụ (Intent) trước khi check cú pháp.
4.  **Proactive Memory:** Tự động đề xuất lưu bài học kinh nghiệm sau mỗi task thành công.

---

## 🚀 Cách Bắt đầu
1.  Đảm bảo đã cài đặt đủ môi trường Flutter/Dart.
2.  Chạy `/setup-agent` để AI cập nhật ngữ cảnh dự án mới nhất.
3.  Sử dụng `/start-task [yêu cầu]` để bắt đầu làm việc.