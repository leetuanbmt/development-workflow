---
description: "Quy trình điều tra và sửa lỗi theo chuẩn Auditor (Investigate -> Plan -> Fix -> Verify)."
trigger: /fix
version: "2.0.0"
skills:
  - bug-investigator
  - code-reviewer
---

# 🔧 Systematic Bug Fix

**Mục tiêu:** Sửa lỗi triệt để (Root Cause Fix) thay vì chỉ vá tạm thời (Patching).

## 🔄 Quy trình (Execution Flow)

### 1. Investigation (Điều tra)
*   **Reproduction:** Xác định các bước để tái hiện lỗi.
*   **Trace:** Sử dụng `codebase_investigator` hoặc `grep` để tìm điểm gãy trong luồng dữ liệu.
*   **Root Cause Analysis:** Tại sao lỗi xảy ra? (Logic sai? Null safety? API đổi contract?).

### 2. Solution Audit (Thẩm định giải pháp)
Trước khi sửa, AI phải tự trả lời:
*   Fix này có an toàn không? (Có try-catch, null check chưa?).
*   Fix này có đúng kiến trúc không? (Không gọi DB từ UI).
*   Có cách nào sửa sạch hơn không?

### 3. Execution (Thực thi)
*   Sử dụng `replace` hoặc `write_file` để áp dụng fix.
*   Tuân thủ quy tắc `07-auditor-mode.md`.

### 4. Verification (Kiểm chứng)
*   **Automated:** Viết test case tái hiện lỗi -> Fix -> Test case pass.
*   **Manual:** Hướng dẫn User cách verify lỗi đã hết.

## 💡 Hướng dẫn cho AI
*   **Tránh "Shotgun Debugging":** Không sửa loạn xạ nhiều file cùng lúc với hy vọng nó sẽ chạy.
*   **Log:** Nếu không tìm ra nguyên nhân, hãy đề xuất thêm Log để debug.
