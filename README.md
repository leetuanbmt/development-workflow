# Standard AI Development Workflow (SOP)

Đây là bộ cấu hình chuẩn cho hệ thống AI Agent hỗ trợ phát triển phần mềm. Kansuke Photo là dự án hiện tại đang áp dụng bộ quy trình này.

---

## 🚦 Master Workflow: `/start-task`
Đây là cổng giao tiếp duy nhất để bắt đầu mọi tác vụ. AI sẽ thực hiện thảo luận đa vai trò trước khi hành động.

### 💡 Ví dụ Template chuẩn (Biometric Login Integration)

> **User:** `/start-task Thêm tính năng đăng nhập bằng sinh trắc học`

🟢 BẮT ĐẦU: /start-task Thêm tính năng đăng nhập bằng sinh trắc học

System: Xác định Intent -> New Feature.
Default Mode: Standard (Vì đây là tính năng bảo mật, cần kỹ lưỡng).

AI sẽ kích hoạt "Cuộc họp nội bộ" (Simulation).

---

🗣️ Phase 1: Team Brainstorming Session

> **🤖 Moderator (Tech Lead):** "Team, chúng ta có yêu cầu làm Login Biometric (Vân tay/FaceID). Mode: Standard. Mọi người cho ý kiến nhé."
>
> **🕵️ QA Lead (Risk Assessment):**
> "Khoan đã, tính năng này đầy rủi ro. Tôi có vài câu hỏi 'What-if':
> 1. Thiết bị: Nếu máy không có cảm biến vân tay (hoặc bị hỏng), app có ẩn nút này đi không hay disable?
> 2. Fallback: Nếu user đổi vân tay trong cài đặt máy (ví dụ thêm ngón tay mới), token cũ có bị vô hiệu hóa không? (Bảo mật).
> 3. Flow: Nếu xác thực thất bại quá 5 lần (bị OS khóa tạm thời), UI sẽ báo gì? Có nút chuyển sang nhập Password thường không?"
>
> **🏛️ Architect (Tech Solution):**
> "Ghi nhận ý kiến của QA. Về kỹ thuật, tôi đề xuất:
> 1. Lib: Dùng `local_auth`.
> 2. Logic: Check `canCheckBiometrics` trước khi render UI.
> 3. Storage: Token đăng nhập phải được lưu trong `flutter_secure_storage`.
> 4. Security: Cấu hình `AndroidEmbeddingV2` cho Android và `FaceID` permission trong `Info.plist` iOS."
>
> **🧑‍💼 BA (User Experience):**
> "Về trải nghiệm, tôi muốn:
> 1. Lần đầu mở app sau khi update, nên có dialog hỏi 'Bạn có muốn bật đăng nhập nhanh không?'.
> 2. Nút Biometric phải nằm gần ngón cái, dễ bấm.
> 3. Icon phải đổi linh hoạt (FaceID icon cho iPhone X+, Fingerprint cho Android cũ)."
>
> **🤖 Moderator (Conclusion):**
> "Chốt! Chúng ta cần một Spec chi tiết xử lý 3 vấn đề: Hardware Check, Fallback Flow, và Secure Storage. Chưa đủ điều kiện để Code ngay (DoR Fail)."

---

🛑 Phase 2: Action Proposal (User Interaction)

Dựa trên cuộc thảo luận trên, tôi (AI Agent) quay lại hỏi bạn:

> Chào bạn, Team đã thảo luận xong.
> Chúng tôi phát hiện vài điểm cần làm rõ trước khi code để tránh bug về sau:
> 1. Fallback: Khi Biometric fail, bạn muốn user nhập PIN hay Password account?
> 2. UI: Bạn có muốn hiện dialog gợi ý bật Biometric lần đầu không?
>
> Đề xuất: Hãy chạy `/write-spec` để chốt các luồng này trước. Bạn có đồng ý không?

*(Tôi đang đợi phản hồi của bạn để tiếp tục, thay vì tự ý code bừa).*

---

## 🛠 Detailed Workflows (Quy trình Chi tiết)

AI sẽ tự động điều phối các workflow dưới đây:

| Lĩnh vực | Lệnh (Command) | File Cấu hình | Mục đích |
| :--- | :--- | :--- | :--- |
| **Setup** | `/setup-agent` | `workflows/setup-agent.md` | **(Run First)** Tự động quét và cài đặt ngữ cảnh dự án. |
| **Hệ thống** | `/project-overview`| `workflows/project-overview.md` | Báo cáo tổng quan dự án (Onboarding). |
| **Sản phẩm** | `/write-spec` | `workflows/write-spec.md` | Viết tài liệu đặc tả (User Stories, Specs). |
| **Thiết kế** | `/design-feature` | `workflows/design-feature.md` | Thiết kế kiến trúc (Domain/Data/UI). |
| **Phát triển** | `/implement-feature` | `workflows/implement-feature.md` | **(Gated Check DoR)** Biến Spec thành Code. |
| **Chất lượng** | `/review-code` | `workflows/review-code.md` | **(DoD Enforced)** Review code theo chuẩn Lint/Test. |
| **Sửa lỗi** | `/investigate` | `workflows/investigate.md` | Điều tra và sửa lỗi (Root Cause Analysis). |

---

## 📏 System Rules (Bộ Luật)

Agent tham chiếu các file luật trong `.agent/rules/` để đảm bảo tính nhất quán:
1.  **`00-core-behavior.md`**: Quy tắc ứng xử & Template thảo luận chuẩn.
2.  **`01-project-context.md`**: Ngữ cảnh riêng của dự án (Tech Stack, Commands).
3.  **`02-architecture-rules.md`**: Quy chuẩn Clean Architecture.
4.  **`04-definition-of-done.md`**: Tiêu chuẩn DoR/DoD.

---

## 🚀 Getting Started (Hướng dẫn Cài đặt)

Để áp dụng bộ quy trình này vào dự án mới:
1.  Copy thư mục `.agent/` vào root dự án.
2.  Chạy lệnh khởi tạo: **`/setup-agent`** (Để AI tự học dự án của bạn).
3.  Bắt đầu làm việc: `/start-task`.
