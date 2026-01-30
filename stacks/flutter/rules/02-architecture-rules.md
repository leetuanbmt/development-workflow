---
trigger: always_on
description: Quy tắc kiến trúc cho việc phát triển Workflow và Scripts.
---

# 🏗 Architecture Rules: Workflow Development

> **Áp dụng cho:** Việc chỉnh sửa repo `development-workflow`.

## 1. Nguyên tắc cốt lõi (Core Principles)
*   **Single Source of Truth:** Mọi chỉnh sửa phải thực hiện trong các thư mục nguồn (`workflows/`, `skills/`, `rules/`), **KHÔNG** sửa trực tiếp trong `.gemini/` hoặc `.agent/` (vì sẽ bị ghi đè khi sync).
*   **Modular Design:** Mỗi Workflow và Skill phải độc lập, tự chứa (self-contained).
*   **Auditor-First:** Tài liệu hướng dẫn phải viết cho con người đọc (User/Auditor), không phải chỉ cho máy.

## 2. Quy chuẩn Scripting (Automation)

### Python (`scripts/*.py`)
*   **Type Hinting:** Bắt buộc sử dụng Type Hints cho function arguments và return types.
*   **Error Handling:** Sử dụng `try-except` rõ ràng, không nuốt lỗi (swallow exceptions).
*   **Docstrings:** Các module và function chính phải có docstring mô tả mục đích.
*   **No Hardcoding:** Đường dẫn file phải sử dụng `os.path` hoặc `pathlib`, tương đối với root dự án.

### Bash (`scripts/*.sh`)
*   **Safety First:** Luôn bắt đầu script với `set -e` (thoát khi lỗi) hoặc xử lý lỗi thủ công.
*   **Portable:** Tránh sử dụng các lệnh chỉ có trên Linux hoặc macOS (BSD) mà không kiểm tra (ví dụ: `sed -i` khác nhau).
*   **Logging:** In ra các bước thực hiện (`echo "🚀 Step..."`) để User theo dõi.

## 3. Quy chuẩn Markdown (Knowledge Base)
*   **Frontmatter:** Các file trong `workflows/` bắt buộc phải có frontmatter YAML chứa `description`.
*   **Headers:** Sử dụng `#` cho Title, `##` cho Section chính. Tránh nest quá sâu (quá h4).
*   **Linking:** Khi tham chiếu file khác, sử dụng đường dẫn tương đối chính xác.

## 4. Quy trình Thay đổi (Change Workflow)
1.  **Edit:** Sửa file source (`rules/`, `skills/`...).
2.  **Verify:** Chạy `./scripts/validate.sh` (nếu có) hoặc kiểm tra cú pháp.
3.  **Sync:** Chạy `./scripts/sync.sh` để áp dụng thay đổi vào runtime `.gemini/`.
4.  **Test:** Thử nghiệm lệnh CLI tương ứng để đảm bảo hoạt động đúng.