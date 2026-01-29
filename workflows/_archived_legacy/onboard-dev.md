---
description: "Quy trình tích hợp thành viên mới (Onboarding) nhanh và chuẩn xác."
trigger: /onboard-dev
version: "3.0.0"
skills:
  - tech-lead
  - devops-engineer
---

# 👋 Developer Onboarding

**Mục tiêu:** Dev mới có thể commit code đầu tiên trong vòng 24h.

## 🔄 Quy trình (Execution Flow)

### 1. Environment Doctor (Bác sĩ môi trường)
*   Yêu cầu Dev chạy script kiểm tra môi trường (nếu có): `./scripts/doctor.sh`.
*   Nếu không có script, AI hướng dẫn check tay:
    *   Flutter version?
    *   Java/Gradle version?
    *   CocoaPods version?

### 2. Knowledge Transfer (Chuyển giao tri thức)
*   Đừng bắt đọc hết Wiki. Hãy chỉ đọc những thứ cốt lõi:
    *   `.agent/memory/ARCHITECTURE.md` (Cách tổ chức code).
    *   `.agent/memory/CONVENTIONS.md` (Cách đặt tên).
    *   `development-workflow/GEMINI.md` (Cách làm việc với AI).

### 3. First Task Assignment
*   Đề xuất các task "Good First Issue":
    *   Thêm Unit Test đơn giản.
    *   Sửa lỗi UI nhỏ (Padding, Color).
    *   Update Document.

## ✅ Validation Checklist
- [ ] Chạy được app trên máy ảo/thật.
- [ ] Chạy được `make gen` không lỗi.
- [ ] Chạy được `make test` pass xanh.
- [ ] Đã cài đặt Gemini CLI extension.

## 💡 Hướng dẫn cho AI
*   **Thân thiện:** Dùng giọng văn chào mừng, khích lệ.
*   **Hỗ trợ:** Nếu Dev gặp lỗi setup, hãy dùng skill `bug-investigator` để giúp họ fix ngay.