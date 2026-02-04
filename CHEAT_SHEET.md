# ⚡ Quick Reference - AI-Native Development Workflow (v4.1)

> Bảng tra cứu nhanh các lệnh và quy chuẩn cho Antigravity Workflow.

## 🎯 Workflow Commands

### 🌟 Core Workflows (Hydrated)
| Command | Mục đích | Skill Active |
|:---|:---|:---|
| `/setup` | **Phải chạy đầu tiên.** Detect stack & cấu hình Agent. | Tech Lead |
| `/start-task` | Chuyển ý tưởng/bug thành Blueprint & Plan. | Product Manager |
| `/vibe` | Thực thi Job Briefs (Fast coding). | Vibecoder |
| `/fix` | Sửa bug (Investigate → Plan → Fix → Verify). | Bug Investigator |
| `/audit` | Kiểm tra sâu (Arch, Security, Performance). | Security / Tech Lead |
| `/review` | Review code & UI/UX (PR hoặc local changes). | Code Reviewer |
| `/deploy` | Build & Deploy với safety checks. | Tech Lead |
| `/doctor` | Kiểm tra sức khỏe Agent & môi trường. | - |

### 🛠️ Specialist Workflows
| Command | Mục đích | Skill Active |
|:---|:---|:---|
| `/document` | Tạo/Cập nhật tài liệu (DOD, SPEC, ADR). | Tech Lead |
| `/write-test` | Viết Unit/Widget/Integration tests. | Test Engineer |
| `/integrate-api` | Auto-generate Data Layer từ JSON/Swagger. | Feature Architect |
| `/manage-db` | Quản lý migration & schema an toàn. | Tech Lead |
| `/refactor` | Refactor code mà không làm thay đổi logic. | Code Reviewer |

---

## 🚀 AI-Native Rules (Vibe Coding)

| Rule | Value | Note |
|:---|:---|:---|
| **Context Limit** | 1M+ Tokens | Tận dụng full context codebase. |
| **Output Limit** | 2000+ Lines | AI có thể viết toàn bộ module một lúc. |
| **Verification** | Required | Code chưa verify là code chết. |
| **Safety Hook** | Secrets Scan | Tự động chặn commit nếu lộ API Key. |

---

## ✅ Verification Loop (Success Criteria)

Mọi task hoàn thành phải pass bộ lọc sau:

| Phase | Metric | Threshold |
|:---|:---|:---|
| **Syntax** | No compilation errors | 0 errors |
| **Logic** | Unit tests pass | 100% of new tests |
| **Integration** | E2E/Manual test pass | Critical paths only |
| **Security** | No secrets exposed | 0 findings |

---

## 🎭 Agent Skills & Dispatch

AI tự động kích hoạt skill dựa trên keyword:
- `ui/ux`, `css`, `frontend` → **Frontend Architect**
- `bug`, `crash`, `error` → **Bug Investigator**
- `system design`, `arch` → **Tech Lead**
- `vibe`, `nhanh`, `code` → **Vibecoder** (High-speed implementation)

*Nếu request "design" chung chung, AI sẽ hỏi lại: "UI design hay System design?"*

---

## 🏗️ Project Structure (Standard)

```text
.agent/               # 🧠 Agent Brain (Workflows, Skills, Rules)
.gemini/              # ⚙️ CLI Runtime Config
docs/                 # 📚 Project Documentation
  ├── specs/          # Feature specifications
  ├── adr/            # Architecture Decision Records
  └── qa/             # Test plans & reports
scripts/              # 🔧 Maintenance & Sync utilities
```

---

## 📞 Sync & Emergency

```bash
# Sync lại toàn bộ môi trường (khi đổi branch hoặc update workflow)
./scripts/sync.sh --runtime

# Kiểm tra lỗi cấu hình
/doctor

# Rollback khi AI làm sai logic nặng
git stash push -m "ai-failed-attempt" && git stash drop
```
