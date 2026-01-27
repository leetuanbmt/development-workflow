# 🤖 AI-Native Development Workflow (Portable SOP)

Bộ quy trình chuẩn (Standard Operating Procedure) dành cho AI Agent, giúp tối ưu hóa việc phát triển dự án Flutter/Dart theo mô hình Clean Architecture. Hệ thống này được thiết kế để có thể tích hợp vào bất kỳ dự án nào dưới dạng Git Submodule.

---

## 🚀 Quick Start (Bắt đầu nhanh)

Quy trình bắt buộc khi bắt đầu làm việc hoặc chuyển sang dự án mới:

### Bước 1: Đồng bộ môi trường (Sync)
Đây là bước **tiên quyết** để khởi tạo các liên kết và nạp danh sách lệnh vào Gemini CLI.
*   **Nếu mới add submodule lần đầu:**
    ```bash
    bash .ai-workflow/init-submodule.sh
    ```
*   **Nếu dự án đã có sẵn:**
    ```bash
    make sync  # Hoặc: bash .ai-workflow/scripts/sync.sh
    ```
*(Lệnh này sẽ tạo thư mục `.gemini/` và generate các file `.toml` trong `commands/`)*

### Bước 2: Nạp ngữ cảnh dự án (Setup Agent)
Sau khi Sync thành công, bạn cần chạy lệnh này để AI tự quét `pubspec.yaml`, `Makefile` và cấu trúc thư mục để "hiểu" dự án hiện tại:

> **Lệnh:** `/setup-agent`

### Bước 3: Bắt đầu tác vụ
Khi AI đã hiểu dự án, bạn có thể bắt đầu làm việc:

> **Lệnh:** `/start-task [yêu cầu của bạn]`

---

## 🏗️ Triết lý Cốt lõi (Core Philosophy)
... (giữ nguyên các phần sau)

1.  **Atomic Execution:** Chia nhỏ task lớn. Code không quá 150 dòng/file.
2.  **Clean Architecture:** Tuân thủ nghiêm ngặt 3 layer (Domain, Data, Presentation).
3.  **Internal Simulation:** AI giả lập cuộc họp giữa BA, Architect và QA trước khi thực hiện task để giảm thiểu rủi ro.
4.  **Code Gen Checkpoint:** AI dừng lại tại các điểm quan trọng để con người chạy `make gen`.

---

## 🛠️ Danh mục Workflows (Commands)

Bạn có thể kích hoạt các quy trình sau thông qua Gemini CLI bằng lệnh `/name-workflow`:

| Lệnh | Mô tả | Chi tiết |
| :--- | :--- | :--- |
| [`/start-task`](./workflows/start-task.md) | **Master Workflow.** Khởi đầu mọi task, chọn mode (Hotfix/Standard). | [Link](./workflows/start-task.md) |
| [`/implement-feature`](./workflows/implement-feature.md) | Thực hiện code tính năng mới theo từng bước nhỏ. | [Link](./workflows/implement-feature.md) |
| [`/review-code`](./workflows/review-code.md) | Review code dựa trên chuẩn Clean Arch & Business Logic. | [Link](./workflows/review-code.md) |
| [`/investigate`](./workflows/investigate.md) | Điều tra nguyên nhân gốc rễ (Root Cause) của Bug. | [Link](./workflows/investigate.md) |
| [`/design-feature`](./workflows/design-feature.md) | Thiết kế kiến trúc, database schema trước khi code. | [Link](./workflows/design-feature.md) |
| [`/write-test`](./workflows/write-test.md) | Tạo Unit/Widget tests tự động. | [Link](./workflows/write-test.md) |

> 💡 Xem danh sách đầy đủ tại thư mục [`workflows/`](./workflows/)

---

## 🧠 Danh mục Skills (Specialized Agents)

Hệ thống tự động kích hoạt các kỹ năng chuyên biệt dựa trên ngữ cảnh:

*   **[Feature Architect](./skills/feature-architect/SKILL.md):** Chuyên gia phân rã layer và thiết kế hệ thống.
*   **[Code Reviewer](./skills/code-reviewer/SKILL.md):** Reviewer nghiêm ngặt, tập trung vào "Intent" và "Logic".
*   **[Bug Investigator](./skills/bug-investigator/SKILL.md):** Chuyên gia tìm lỗi và phân tích log.
*   **[Flutter Expert](./skills/flutter-expert/SKILL.md):** Chuyên gia tối ưu hóa UI/UX và BLoC State.
*   **[Tech Lead](./skills/tech-lead/SKILL.md):** Đảm bảo tính nhất quán của toàn bộ dự án.

---

## 📚 Tài liệu Tham khảo (References)

*   **[Cheat Sheet](./CHEAT_SHEET.md):** Tra cứu nhanh các lệnh và quy tắc.
*   **[Metrics Dashboard](./memory/metrics.md):** Theo dõi hiệu suất workflow và insights.
*   **[Architecture Rules](./rules/02-architecture-rules.md):** Tiêu chuẩn thiết kế bắt buộc.
*   **[Coding Conventions](./rules/00-core-behavior.md):** Quy ước đặt tên và phong cách code.
*   **[Definition of Done](./rules/04-definition-of-done.md):** Tiêu chuẩn để hoàn thành một task.

---

## 🔄 Quy trình Code Gen Checkpoint
Dự án phụ thuộc vào Code Generation (`Freezed`, `Drift`). Để tối ưu:
1.  AI sửa file Entity/Model/Table.
2.  AI **DỪNG LẠI** và yêu cầu bạn chạy `make gen`.
3.  Bạn chạy lệnh và xác nhận "OK".
4.  AI tiếp tục viết logic dựa trên code đã được generate.

---
*Duy trì bởi Team Dev - Tuân thủ SOP để đảm bảo chất lượng hệ thống.*
