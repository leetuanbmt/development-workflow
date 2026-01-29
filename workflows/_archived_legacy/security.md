---
description: "Kiểm tra bảo mật toàn diện. Kết hợp rà soát mã nguồn (Audit) và mô phỏng tấn công (Pentest)."
trigger: /security
version: "1.0.0"
skills:
  - security-auditor
  - ethical-hacking-methodology
---

# 🛡️ Unified Security (Audit & Pentest)

**Mục tiêu:** Đảm bảo ứng dụng an toàn trước các cuộc tấn công và không rò rỉ dữ liệu nhạy cảm.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Passive Audit (Rà soát tĩnh):**
    *   Quét mã nguồn tìm Hardcoded Keys, Secrets, Tokens.
    *   Kiểm tra Logging (tránh log dữ liệu nhạy cảm).
    *   Kiểm tra Data Storage (Secure storage vs Shared Prefs).

2.  **Active Pentest (Mô phỏng tấn công):**
    *   Phân tích các Endpoint và luồng Authentication.
    *   Mô phỏng các lỗi OWASP Top 10 (Injection, Broken Auth, Data Exposure).

3.  **Remediation Report:**
    *   🔴 **Critical:** Lỗ hổng cho phép chiếm quyền hoặc lộ data.
    *   🟡 **Warning:** Cấu hình chưa tối ưu hoặc dùng thư viện lỗi thời.

## 💡 Hướng dẫn cho AI
- Luôn ưu tiên tính bảo mật dữ liệu của người dùng.
- Cung cấp giải pháp fix lỗi ngay lập tức cho các phát hiện Critical.
