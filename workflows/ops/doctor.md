---
description: "Kiểm tra sức khỏe môi trường Agent & Sync Status."
trigger: /doctor
version: "1.0.0"
skills:
  - devops-engineer
---

# 🏥 Doctor Check (Environment & Sync Diagnostic)

**Mục tiêu:** Kiểm tra tính toàn vẹn của môi trường Agent, trạng thái đồng bộ (Sync Status) và các công cụ cần thiết. Giúp phát hiện lỗi "Out of Sync" hoặc thiếu dependencies.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Chạy Diagnostic Script:**
    *   **HÀNH ĐỘNG:** Chạy script `development-workflow/scripts/doctor.sh`.
    *   Script này sẽ kiểm tra:
        *   Các tool bắt buộc: `python3`, `melos`, `flutter`.
        *   Trạng thái đồng bộ: So sánh checksum/timestamp giữa `development-workflow/rules` và `.agent/memory`.
        *   Cấu trúc thư mục: Kiểm tra sự tồn tại của `.gemini`, `.agent` và các symlink.

2.  **Phân tích kết quả:**
    *   Đọc output từ script.
    *   Nếu phát hiện lỗi (❌), hãy giải thích nguyên nhân cho người dùng.
    *   Đề xuất lệnh sửa lỗi (ví dụ: `make sync`, `flutter pub get`).

3.  **Tự động sửa lỗi (Auto-Fix - Optional):**
    *   Nếu lỗi là "Out of Sync", hỏi người dùng có muốn chạy Sync ngay không.
    *   Nếu đồng ý, chạy `make sync`.

4.  **Smart Workflow Suggestions:**
    *   Script tự động phân tích context và suggest workflow phù hợp:
        *   BLoC/Cubit changes → `/write-test`
        *   Data layer changes → `/audit-architecture`
        *   Presentation changes → `/review-ui`
        *   Recent bug fixes → `/write-test` (regression tests)
        *   Uncommitted changes → `/review-code`

## 📝 Script Logic (Tham khảo)

Script `doctor.sh` thực hiện các kiểm tra sau:

```bash
# 1. Check Tools
check_tool "flutter"
check_tool "melos"

# 2. Check Sync
compare_dirs "development-workflow/rules" ".agent/memory"
compare_dirs "development-workflow/skills" ".agent/skills"

# 3. Smart Suggestions
suggest_workflow  # Analyze git history & project patterns
```

## ⚠️ Lưu ý
*   Luôn ưu tiên chạy `make sync` nếu có bất kỳ nghi ngờ nào về sự không đồng nhất.
*   Suggestions dựa trên 5 commits gần nhất - cần có git history.
