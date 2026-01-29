---
description: "Sửa lỗi triệt để theo flow: Quick Investigate → Plan → Fix → Verify."
trigger: /fix
version: "2.1.0"
skills:
  - bug-investigator
  - code-reviewer
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Fix applied and verified", "User rejected plan"]
---

# 🔧 Systematic Bug Fix

**Objective:** Sửa lỗi triệt để (Root Cause Fix) thay vì vá tạm thời (Patching).

## 🚀 Execution Flow

### Step 1: Quick Investigation (5 min max)
- Xác định reproduction steps
- Trace luồng dữ liệu để tìm điểm gãy
- Root Cause Analysis: Logic sai? Null safety? API contract changed?

### Step 2: Solution Audit
Trước khi sửa, tự trả lời:
- [ ] Fix có an toàn? (try-catch, null check)
- [ ] Fix đúng kiến trúc? (không gọi DB từ UI)
- [ ] Có cách sửa sạch hơn?

### Step 3: Execute Fix
- Sử dụng `replace_file_content` để áp dụng
- Một file tại một thời điểm
- Commit message format: `fix: [short description]`

### Step 4: Verification
```bash
# Chạy test liên quan
flutter test test/features/[feature]/ --name "[test_name]"
```
- Nếu không có test → Đề xuất viết test mới
- Hướng dẫn user manual verify

## 💡 AI Guidelines
- **No Shotgun Debugging:** Không sửa loạn xạ nhiều file
- **Focused:** Một bug = một fix commit
- **Traceable:** Mọi thay đổi phải reference root cause
