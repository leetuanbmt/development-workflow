---
description: "Hướng dẫn onboarding cho developer mới gia nhập dự án."
trigger: /onboard-dev
version: "2.4.0"
skills:
  - tech-lead
  - technical-writer
---

# 👋 Onboard Developer

**Mục tiêu:** Hướng dẫn developer mới làm quen với dự án một cách nhanh chóng và hiệu quả.

## 🚀 Quy trình Onboarding (5 Steps)

### Step 1: Environment Setup (30 phút)

```bash
# Clone repository
git clone [repo-url]
cd {{PROJECT_NAME}}

# Cài đặt dependencies
make setup

# Chạy code generation
make gen

# Verify setup
make run-dev
```

**Checklist:**
- [ ] Flutter SDK đúng version (xem pubspec.yaml)
- [ ] Xcode/Android Studio configured
- [ ] IDE plugins: Dart, Flutter, Bloc

### Step 2: Architecture Overview (1 giờ)

Chạy lệnh để lấy tổng quan:
```
/project-overview
```

**Kiến thức cần nắm:**
- Clean Architecture (Domain/Data/Presentation)
- BLoC Pattern với Freezed
- Dependency Injection với GetIt

**Tài liệu đọc thêm:**
- [README.md](file:///README.md)
- [.agent/memory/ARCHITECTURE.md](file:///.agent/memory/ARCHITECTURE.md)

### Step 3: Codebase Exploration (2 giờ)

**Thư mục quan trọng:**
| Path | Mục đích |
|:--|:--|
| `lib/core/` | Shared utilities, widgets, services |
| `lib/features/` | Feature modules (Clean Arch) |
| `lib/di/` | Dependency Injection config |
| `lib/routes/` | Navigation (AutoRoute) |

**Bài tập:**
1. Tìm và đọc 1 Feature hoàn chỉnh (VD: `lib/features/auth/`)
2. Trace luồng từ UI → Bloc → UseCase → Repository
3. Xem cách Entity được map từ Model

### Step 4: Development Workflow (30 phút)

**Các lệnh thường dùng:**
```bash
make run-dev      # Chạy app development
make gen          # Generate code (Freezed, Retrofit, Drift)
make lint         # Check code style
make test         # Run all tests
```

**AI Commands:**
| Command | Khi nào dùng |
|:--|:--|
| `/start-task` | Bắt đầu bất kỳ task nào |
| `/implement-feature` | Thêm tính năng mới |
| `/investigate` | Điều tra bug |
| `/fix` | Sửa bug đã điều tra |
| `/review-code` | Review code trước PR |

### Step 5: First Task (1-2 ngày)

**Gợi ý task đầu tiên:**
1. Fix 1 bug nhỏ có label `good-first-issue`
2. Thêm unit test cho 1 UseCase
3. Cải thiện UI của 1 screen đơn giản

**Quy trình:**
```
/start-task [task description] --mode hotfix
```

## 📚 Tài liệu Tham khảo

| Loại | Đường dẫn |
|:--|:--|
| Architecture Rules | `.agent/memory/ARCHITECTURE.md` |
| Coding Conventions | `.agent/memory/CONVENTIONS.md` |
| Knowledge Base | `{{WORKFLOW_DIR}}/memory/knowledge_base.md` |
| Workflow Cheat Sheet | `{{WORKFLOW_DIR}}/CHEAT_SHEET.md` |

## ✅ Onboarding Checklist

### Week 1
- [ ] Setup môi trường thành công
- [ ] Hiểu kiến trúc tổng quan
- [ ] Complete first task
- [ ] Tham gia code review

### Week 2
- [ ] Implement 1 feature nhỏ end-to-end
- [ ] Viết unit tests
- [ ] Sử dụng thành thạo AI workflows

## 💡 Tips for New Developers

1. **Đừng ngại hỏi** - Dùng `/investigate` để AI giúp hiểu code
2. **Commit thường xuyên** - Atomic commits dễ review
3. **Đọc Knowledge Base** - Tránh lặp lại lỗi đã biết
4. **Follow patterns** - Copy structure từ features có sẵn
