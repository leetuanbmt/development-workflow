# ⚡ AI-Native Development Workflow (Auditor Edition)

> **Auditor-First Mindset:** Powered by **Gemini CLI** & **Google Antigravity** (Context-Aware AI).

Workflow này đã được chuyển đổi từ việc AI "viết hộ" sang việc AI **"thực thi dưới sự giám sát"**. User đóng vai trò là **Kiến trúc sư trưởng (Auditor)**, AI là **Lead Engineer** thực hiện các lệnh kỹ thuật.

## 🏗️ Triết lý Auditor-First

1.  **Intent & Constraints:** User cung cấp **Ý định** (Mục tiêu) và **Ràng buộc** (Kiến trúc, Bảo mật).
2.  **Implementation Plan:** Với các thay đổi phức tạp, AI phải trình bày **Kế hoạch** trước khi chạm vào mã nguồn.
3.  **Verification Loop:** Mọi dòng code sinh ra phải có cơ chế kiểm chứng.

---

## 🛠️ Command Center (13 Workflows)

### 🔴 Core Loop (Hàng ngày) — 6 workflows
| Command | Chức năng |
| :--- | :--- |
| `/start-task` | Phân tích yêu cầu, lập kế hoạch thực hiện |
| `/investigate` | Điều tra nguyên nhân lỗi, xuất báo cáo (NO code edit) |
| `/fix` | Investigate → Plan → Fix → Verify |
| `/review` | Review code/PR/changes (unified, auto-detect mode) |
| `/audit` | Audit multi-aspect (arch/security/analytics/general) |
| `/refactor` | Tái cấu trúc an toàn, không đổi hành vi |

### 🟡 Technical Services — 3 workflows
| Command | Chức năng |
| :--- | :--- |
| `/manage-db` | Quản lý Schema, Migration, Data Integrity |
| `/integrate-api` | Sinh Data Layer từ JSON specs |
| `/write-test` | Viết Unit/Widget/Integration tests |

### 🔵 Operations — 4 workflows
| Command | Chức năng |
| :--- | :--- |
| `/doctor` | Kiểm tra sức khỏe môi trường |
| `/deploy` | Build và deploy ứng dụng |
| `/document` | Tạo tài liệu "sống" |
| `/prepare-release` | Pipeline rà soát trước Release |

---

## 🧠 Skills (8 Core)

| Skill | Focus |
|:---|:---|
| `bug-investigator` | Root cause analysis, debugging |
| `code-reviewer` | Code quality, architecture check |
| `flutter-expert` | Performance, memory, Flutter specifics |
| `feature-architect` | Feature design, layer breakdown |
| `tech-lead` | Architecture decisions, mentoring |
| `test-engineer` | Testing strategy, coverage |
| `security-auditor` | Vulnerabilities, secrets scan |
| `vibecoder` | Fast implementation, full-stack |

---

## 📂 Cấu trúc Dự án

```text
development-workflow/
├── rules/               # 📜 Bộ quy tắc
├── workflows/           # 🚀 Quy trình thực thi (13 active)
│   ├── core/            # Hàng ngày (6)
│   ├── tech/            # Kỹ thuật (3)
│   ├── ops/             # Vận hành (4)
│   └── _archived_legacy # Archived (27)
├── skills/              # 🧠 Kỹ năng (8 active)
│   ├── [8 skill folders]
│   └── _deprecated/     # Archived (14)
└── scripts/             # 🛠 Công cụ hỗ trợ
```

---

## ⚡ Bắt đầu sử dụng

1.  **Đồng bộ hóa môi trường:**
    ```bash
    ./development-workflow/scripts/sync.sh
    ```
2.  **Vận hành theo chuẩn Auditor:**
    - Bước 1: `/start-task [yêu cầu]` để lên kế hoạch.
    - Bước 2: Duyệt kế hoạch và ra lệnh thực thi.
    - Bước 3: `/review` kết quả cuối cùng.

---

## 🗺️ Workflow Flow

```mermaid
graph TD
    A[🎯 User Request] --> B{/start-task}
    B -->|Bug| C[/investigate]
    B -->|Feature| D[/audit]
    B -->|Quick Fix| E[/fix]
    
    C -->|Root Cause Found| E
    D -->|Plan Approved| F[Implement]
    
    E --> G[/review]
    F --> G
    
    G -->|Pass| H[✅ Done]
    G -->|Issues| I[Fix & Iterate]
    I --> G
```

---

*v3.0.0 - Refactored: 40→13 workflows, 22→8 skills*
