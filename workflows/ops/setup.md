---
description: "Phân tích Tech Stack, khởi tạo tri thức Agent (.agent) và đồng bộ hóa lệnh CLI (.gemini)."
trigger: /setup
version: "4.4.0"
skills: 
  - tech-lead
constraints:
  max_iterations: 15
skill: tech-lead
---

# 🛠 Setup & Specialize Agent Environment

**Vai trò:** Project Architect & System Configurator.
**Mục tiêu:** Biến Agent từ "Chung chung" thành "Chuyên gia" của dự án hiện tại.

## 🔄 Execution Flow

### 1. Discovery (Khám phá dự án)
*   **Hành động:** Quét các file cấu hình (`package.json`, `pubspec.yaml`, `go.mod`...).
*   **Xác định:** Ngôn ngữ, Framework, Công cụ Build/Test.

### 2. Định nghĩa hằng số dự án (Project Constants)
AI tự xác định các giá trị (ví dụ: `CMD_TEST`, `STACK_NAME`, `LIB_MOCK`...) dựa trên kết quả khám phá.

### 3. Cấu hình Trí não Agent (.agent) - [Dành cho Antigravity]
Đây là nơi AI lưu trữ tri thức và quy trình để tự soi chiếu trong quá trình làm việc.

*   **PROJECT.md:** Lưu các hằng số vào `.agent/memory/PROJECT.md`.
*   **ARCHITECTURE.md:** Tạo quy tắc kiến trúc tại `.agent/memory/ARCHITECTURE.md`.
*   **Skills:** Tạo `framework-expert` tại `.agent/skills/framework-expert/SKILL.md` (từ template).
*   **Workflows:** Hydrate các template và lưu bản MD vào `.agent/workflows/`.

### 4. Cấu hình Giao diện CLI (.gemini) - [Dành cho User]
Đây là bước quan trọng nhất để CLI có thể gửi đúng Prompt đã hydrated cho AI.

*   **Hành động:** Chạy script đồng bộ ở chế độ Runtime:
    ```bash
    bash scripts/sync.sh --runtime
    ```
*   **Mục đích:** Chuyển đổi toàn bộ Workflows đã hydrated trong `.agent/workflows/` thành các file `.toml` trong `.gemini/commands/`.

### 5. Kiểm tra & Bàn giao
*   Xác nhận các file `.toml` trong `.gemini/commands/` đã chứa các lệnh cụ thể (ví dụ: đã có `npm test` thay vì `{{CMD_TEST}}`).
*   **Báo cáo:** Liệt kê Stack đã nhận diện và các lệnh đã được cấu hình.

## 💡 AI Guidelines

**Lưu ý quan trọng về cấu trúc:**
- **`.agent`**: Là nơi bạn (AI) lưu trữ tri thức. Bạn có thể đọc lại các file ở đây bất cứ lúc nào bằng tool `read_file` để đảm bảo làm đúng quy trình.
- **`.gemini`**: Là nơi CLI lấy Prompt để gửi cho bạn. Việc chạy `sync.sh --runtime` là bắt buộc để "cập nhật tiếng nói" của bạn với người dùng.

**Ngôn ngữ:**
- Toàn bộ nội dung trong `.agent` và `.gemini` phải bằng **tiếng Anh**.
- Báo cáo kết quả cuối cùng cho User bằng **tiếng Việt**.
