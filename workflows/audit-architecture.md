---
description: "Kiểm tra tuân thủ Clean Architecture và BLoC Pattern của dự án."
trigger: /audit-architecture
skills:
  - tech-lead
---

# 🛡️ Kiểm toán Kiến trúc (Architecture Audit)

**Mục tiêu:** Rà soát mã nguồn để đảm bảo tuân thủ nghiêm ngặt 3 tầng của Clean Architecture và các quy chuẩn BLoC đã thống nhất.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Chạy Script Tự động (Auto Scan):**
    *   Thực thi `.agent/skills/tech-lead/scripts/check_arch.sh`.
    *   Phân tích các lỗi (nếu có) từ output của script.

2.  **Kiểm tra BLoC Pattern (Manual Check):**
    *   Chọn ngẫu nhiên hoặc chỉ định một Feature Bloc.
    *   Kiểm tra xem có dùng đúng **Unified State** (State class + Status Enum) không?
    *   Kiểm tra xem Events có được xử lý bất đồng bộ đúng cách (concurrency) không?

3.  **Kiểm tra Dependency Injection:**
    *   Các Repository/UseCase có được inject qua constructor không?
    *   Có file nào dùng `GetIt.I` kiểu Service Locator bừa bãi không?

4.  **Báo cáo & Đề xuất:**
    *   Liệt kê danh sách các điểm vi phạm.
    *   Gợi ý cách Refactor để đưa về đúng chuẩn.

## 📊 Mẫu Báo cáo Audit
```markdown
# Architecture Audit Report

## 1. Automated Check
- [ ] Domain Layer Isolation: ✅ Pass
- [ ] Presentation Layer Isolation: ❌ Fail (Found import data in `profile_screen.dart`)

## 2. Pattern Check
- Feature: `QrCode`
- State Pattern: Unified State ✅
- Logic Placement: Logic nằm trong Bloc ✅

## 3. Action Items
- Remove import `data/models/user_model.dart` from `profile_screen.dart`.
- Move mapping logic to `UserMapper`.
```

## 💡 Hướng dẫn cho Gemini
*   Kích hoạt skill `tech-lead`.
*   Nếu phát hiện vi phạm nghiêm trọng (như gọi API từ UI), hãy dùng từ ngữ mạnh mẽ để cảnh báo.
