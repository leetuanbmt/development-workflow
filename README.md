# Kansuke Photo Agent - Configuration & Guide

Đây là trung tâm cấu hình cho AI Agent của dự án **Kansuke Photo**. Thư mục này định nghĩa danh tính, kỹ năng, quy tắc và quy trình làm việc chuẩn.

## 🧠 Core Identity (Danh tính Cốt lõi)
- **Role:** Senior Flutter Engineer & Full-stack Assistant.
- **Language:** Tiếng Việt (Vietnamese).
- **Style:** Chuyên nghiệp, ngắn gọn, trung lập cảm xúc.
- **Philosophy:** Clean Architecture, Test-Driven Development (TDD), Automation First.

## 📂 Cấu trúc Thư mục

```text
.agent/
├── rules/          # Các quy tắc "bất di bất dịch" (Tech stack, Architecture).
├── skills/         # Các kỹ năng chuyên sâu (Personas).
└── workflows/      # Các quy trình tương tác tự động (Trigger commands).
```

---

## ⚡️ Workflows (Quy trình Tự động)

Sử dụng các lệnh (Slash Commands) sau để kích hoạt các quy trình chuẩn hoá:

| Lĩnh vực | Lệnh (Command) | File Cấu hình | Mục đích |
| :--- | :--- | :--- | :--- |
| **Hệ thống** | `/project-status` | `workflows/project-status.md` | Nắm bắt nhanh tình trạng dự án và ngữ cảnh. |
| **Quản trị (Lead)**| `/audit-architecture`| `workflows/audit-architecture.md` | Kiểm tra tuân thủ kiến trúc Clean Arch/BLoC. |
| **Phân tích** | `/analyze-feature` | `workflows/analyze-feature.md` | Phân tích logic và luồng dữ liệu của tính năng. |
| **Sản phẩm** | `/write-spec` | `workflows/write-spec.md` | Viết tài liệu đặc tả (User Stories, Specs). |
| **Thiết kế** | `/design-feature` | `workflows/design-feature.md` | Thiết kế kiến trúc hệ thống (Domain/Data/UI). |
| | `/write-adr` | `workflows/write-adr.md` | Ghi lại quyết định kiến trúc (ADR). |
| **Phát triển** | `/implement-feature` | `workflows/implement-feature.md` | Biến Spec/Design thành Code. |
| | `/integrate-api` | `workflows/integrate-api.md` | Sinh code Model/Entity/Mapper từ JSON. |
| | `/manage-i18n` | `workflows/manage-i18n.md` | Quản lý đa ngôn ngữ & Hardcode string. |
| | `/refactor` | `workflows/refactor.md` | Cải thiện cấu trúc code an toàn. |
| | `/manage-db` | `workflows/manage-db.md` | Quản lý Drift Schema & Migration. |
| | `/create-component`| `workflows/create-component.md` | Tạo Widget tái sử dụng (Atomic). |
| **Chất lượng** | `/write-test` | `workflows/write-test.md` | Tự động viết Unit/Widget Test. |
| | `/review-code` | `workflows/review-code.md` | Review chi tiết file/folder/feature. |
| | `/review-pr` | `workflows/review-pr.md` | Review Pull Request tổng thể. |
| | `/review-ui` | `workflows/review-ui.md` | Đánh giá giao diện và trải nghiệm (UX). |
| | `/investigate` | `workflows/investigate.md` | Điều tra nguyên nhân gốc rễ và sửa lỗi. |
| | `/audit-security` | `workflows/audit-security.md` | Kiểm tra lỗ hổng bảo mật. |
| **Vận hành** | `/doc-code` | `workflows/doc-code.md` | Viết DartDoc comment cho code. |
| | `/doc-feature` | `workflows/doc-feature.md` | Tạo tài liệu tính năng (Diagram, Test Case). |
| | `/prepare-release` | `workflows/prepare-release.md` | Chuẩn bị đóng gói phiên bản mới. |

---

## 📏 Rules (Quy tắc Cốt lõi)

Agent sẽ tự động tham chiếu các file này để đảm bảo code sinh ra đúng chuẩn dự án:

1.  **`00-core-behavior.md`**: Quy tắc ứng xử cốt lõi (Tiếng Việt, Trung thực, Khách quan).
2.  **`01-project-context.md`**: Thông tin tổng quan dự án (Tech Stack, Commands).
3.  **`02-architecture-rules.md`**: Quy chuẩn Clean Architecture, Coding Convention, DAO Extensions.
4.  **`03-qa-process.md`**: Quy trình kiểm thử (Testing), Validation và báo cáo.

---

## 🧠 Skills (Kỹ năng Chuyên sâu)

Agent có thể đóng vai các chuyên gia khác nhau tùy theo yêu cầu:

*   **`tech_lead`**: Định hướng giải pháp, kiểm soát tuân thủ kiến trúc.
*   **`product_manager`**: Phân tích yêu cầu, viết Specs.
*   **`feature_analysis`**: Đọc hiểu logic, luồng dữ liệu (Analysis).
*   **`feature_architect`**: Thiết kế hệ thống, DB Schema (Design).
*   **`flutter_expert`**: Chuyên gia Flutter/BLoC, tối ưu hiệu năng.
*   **`api_integrator`**: Tích hợp API, sinh Model/Entity tự động.
*   **`localization_expert`**: Quản lý đa ngôn ngữ (i18n).
*   **`ui_ux_designer`**: Tư vấn giao diện, trải nghiệm người dùng.
*   **`devops_engineer`**: Quản lý CI/CD, Build system.
*   **`code_reviewer`**: Review logic và architecture.
*   **`bug_investigator`**: Điều tra và sửa lỗi.
*   **`test_engineer`**: Viết Unit/Widget Test.
*   **`technical_writer`**: Viết tài liệu dự án.
*   **`security_auditor`**: Kiểm tra bảo mật.
*   **`pr_reviewer`**: Review Pull Request.

---

## 💡 Getting Started (Bắt đầu)

Khi bắt đầu một task, hãy luôn:
1.  Xác định **Skill** phù hợp cần kích hoạt.
2.  Tham chiếu **Rule** liên quan.
3.  Sử dụng **Workflow** (Lệnh `/`) để đảm bảo quy trình chuẩn.

Lệnh build quan trọng:
*   `make gen`: Chạy build_runner (sau khi sửa Entity/Retrofit/Drift).
*   `make setup`: Cài đặt môi trường.
