---
description: "Kiểm tra danh sách việc cần làm trước khi phát hành phiên bản mới."
trigger: /prepare-release
skills:
  - devops-engineer
---

# 🚀 Chuẩn bị Release (Release Preparation)

**Mục tiêu:** Đảm bảo ứng dụng ổn định, đúng phiên bản và sẵn sàng để build bản production.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Version Bump:**
    *   Kiểm tra `pubspec.yaml`.
    *   Tăng `version` code (SemVer: Major.Minor.Patch+BuildNumber).
    *   Chạy script cập nhật version native (nếu có).

2.  **Clean & Build Check:**
    *   Chạy `make clean`.
    *   Chạy `make gen` để đảm bảo code sinh mới nhất.
    *   Chạy `make lint` để đảm bảo không còn lỗi static.
    *   Chạy `make test` để đảm bảo logic đúng.

3.  **Changelog Update:**
    *   Tổng hợp các commit/PR từ lần release trước.
    *   Cập nhật file `CHANGELOG.md` hoặc `release_notes/`.

4.  **Environment Configuration:**
    *   Đảm bảo file `.env.release` hoặc cấu hình Production đã chính xác.
    *   Tắt các flag debug/log của môi trường Dev.

## 📊 Checklist Release
- [ ] Version number đã tăng.
- [ ] Test pass 100%.
- [ ] Lint pass (không có error).
- [ ] Changelog đã cập nhật.

## 💡 Hướng dẫn cho Gemini
*   Sử dụng skill `devops-engineer`.
*   Nếu có script build tự động (`build_distribute.sh`), hãy gợi ý user chạy nó.
