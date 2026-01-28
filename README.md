# ⚡ AI-Native Development Workflow (Auditor Edition)

> **Auditor-First Mindset:** Powered by **Gemini CLI** & **Google Antigravity** (Context-Aware AI).

Chào mừng đến với môi trường phát triển tốc độ cao. Workflow này đã được chuyển đổi từ việc AI "viết hộ" sang việc AI **"thực thi dưới sự giám sát"**. User đóng vai trò là **Kiến trúc sư trưởng (Auditor)**, AI là **Lead Engineer** thực hiện các lệnh kỹ thuật.

## 🏗️ Triết lý Auditor-First

1.  **Intent & Constraints:** User cung cấp **Ý định** (Mục tiêu) và **Ràng buộc** (Kiến trúc, Bảo mật).
2.  **Implementation Plan:** Với các thay đổi phức tạp, AI phải trình bày **Kế hoạch** trước khi chạm vào mã nguồn (Rule 07).
3.  **Verification Loop:** Mọi dòng code sinh ra phải có cơ chế kiểm chứng (Test case hoặc Audit report). Code chưa được verify là code chưa hoàn thiện.

## 🛠️ Command Center (Categorized)

Hệ thống được tổ chức thành 3 nhóm chức năng chính để tối ưu hóa sự tập trung:

### 🔴 Core Loop (Hàng ngày)
| Command | Chức năng | Mô tả |
| :--- | :--- | :--- |
| **/start-task** | **Initialize** | Phân tích yêu cầu, chọn Mode (Hotfix/Feature) và lập kế hoạch thực hiện. |
| **/audit** | **Inspect** | Soi lỗi logic, kiến trúc và rủi ro tiềm ẩn của một file/folder bất kỳ. |
| **/investigate**| **Analyze** | Điều tra nguyên nhân gốc rễ (Root Cause) và xuất báo cáo theo Template chuẩn. |
| **/fix** | **Repair** | Sửa lỗi dựa trên kết quả điều tra, đảm bảo không gây side-effects. |
| **/refactor** | **Clean Up** | Tái cấu trúc mã nguồn an toàn (có Safety Net) mà không đổi hành vi. |

### 🟡 Technical Services (Chuyên sâu)
| Command | Chức năng | Mô tả |
| :--- | :--- | :--- |
| **/audit-arch** | **Structure** | Kiểm tra độ tuân thủ kiến trúc động (Dependency Rule) dựa trên context module. |
| **/manage-db** | **Database** | Quản lý Schema, Migration Drift an toàn và Data Integrity. |
| **/integrate-api**| **API Client** | Sinh code Data Layer (Model/Entity/Mapper) chuẩn Clean Arch từ JSON specs. |
| **/write-test** | **Quality** | Viết kịch bản kiểm thử chiến lược (AAA Pattern) cho các luồng quan trọng. |

### 🔵 Operations & Docs (Vận hành)
| Command | Chức năng | Mô tả |
| :--- | :--- | :--- |
| **/prepare-release**| **Publish** | Pipeline rà soát cuối: Versioning, Lint, Test và Smoke Test trước khi Release. |
| **/document** | **Knowledge** | Tạo tài liệu "sống" (Living Docs), vẽ sơ đồ Mermaid mô tả logic nghiệp vụ. |
| **/onboard-dev** | **Onboarding** | Tích hợp thành viên mới vào dự án trong vòng 24h với Checklist tự động. |

## 📂 Cấu trúc Dự án

```text
development-workflow/
├── rules/               # 📜 Bộ quy tắc (07-auditor-mode.md...)
├── workflows/           # 🚀 Quy trình thực thi (Core/Tech/Ops)
│   ├── core/            # Hàng ngày (start-task, fix, audit...)
│   ├── tech/            # Kỹ thuật (db, api, test...)
│   └── ops/             # Vận hành (release, document...)
├── skills/              # 🧠 Kỹ năng chuyên môn (code-reviewer, tech-lead...)
└── scripts/             # 🛠 Công cụ hỗ trợ (sync.sh, generate_commands.py)
```

## ⚡ Bắt đầu sử dụng

1.  **Đồng bộ hóa môi trường:**
    ```bash
    ./development-workflow/scripts/sync.sh
    ```
2.  **Vận hành theo chuẩn Auditor:**
    - Bước 1: `/start-task [yêu cầu]` để lên kế hoạch.
    - Bước 2: Duyệt kế hoạch và ra lệnh thực thi.
    - Bước 3: `/audit` hoặc `/review` kết quả cuối cùng.

## 🔧 Công nghệ Hỗ trợ (Powered By)

Workflow này được xây dựng dựa trên nền tảng công nghệ AI tiên tiến:

*   **Gemini CLI:** Giao diện dòng lệnh thông minh giúp tương tác trực tiếp với LLM ngay trong Terminal.
*   **Google Antigravity:** Hệ thống quản lý Context Window khổng lồ, cho phép AI hiểu toàn bộ dự án mà không cần RAG phức tạp.

---
*Lưu ý: Mọi quy tắc và quy trình đều tập trung vào việc duy trì độ bền vững của mã nguồn trong dài hạn.*
