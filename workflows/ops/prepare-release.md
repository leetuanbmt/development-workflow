---
description: "Quy trình Release Engineering: Build, Test, và Audit trước khi lên Production."
trigger: /prepare-release
version: "3.0.0"
skills: []
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Release ready", "Validation failed"]
---

# 🚀 Production Release Protocol

**Mục tiêu:** "Zero Critical Bugs" trên môi trường Production.

## 🔄 Quy trình (Execution Flow)

### 1. Pre-Flight Check (Kiểm tra trước cất cánh)
*   **Version Audit:** So sánh `pubspec.yaml` với git tag gần nhất.
*   **Changelog Audit:** Đảm bảo mọi tính năng mới đều đã được ghi lại.
*   **Environment Audit:** File `.env` production có chứa key thật chưa? (Tuyệt đối không commit key lên git).

### 2. Automated Validation
*   Chạy pipeline kiểm tra:
    ```bash
    make clean && make gen
    flutter analyze --no-fatal-infos
    flutter test
    ```
*   Nếu bất kỳ lệnh nào fail -> **ABORT RELEASE**.

### 3. Manual Sanity Check (Smoke Test)
*   Auditor (User) phải xác nhận đã test thủ công trên thiết bị thật:
    *   [ ] App cài đặt được (Installable).
    *   [ ] Mở lên không crash (Launch check).
    *   [ ] Login thành công.
    *   [ ] Feature quan trọng nhất hoạt động đúng.

### 4. Build & Tag
*   Đề xuất lệnh build: `flutter build apk/ipa --release --obfuscate`.
*   Đề xuất lệnh git tag: `git tag -a v1.0.0 -m "Release v1.0.0"`.

## 💡 Hướng dẫn cho AI
*   **Bảo mật:** Nhắc user kiểm tra lại `proguard-rules.pro` (Android) nếu có dùng code obfuscation.
*   **Assets:** Nhắc user tối ưu ảnh/icon để giảm dung lượng app.