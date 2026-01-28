---
description: "Thiết kế và kiểm tra hệ thống Tracking (GA4, Firebase)."
trigger: /audit-analytics
version: "1.0.0"
skills:
  - analytics-tracking
  - flutter-expert
---

# 📊 Analytics Audit & Setup Workflow

**Mục tiêu:** Đảm bảo dữ liệu người dùng được thu thập chính xác, tuân thủ quyền riêng tư và có ý nghĩa thống kê.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Measurement Strategy (Chiến lược đo lường):**
    *   Xác định Key Events (Conversion, User Engagement).
    *   Xây dựng Event Taxonomy (Naming Convention, Parameters).

2.  **Implementation Check (Kiểm tra cài đặt):**
    *   Scan code để tìm các điểm gọi `logEvent`.
    *   Kiểm tra việc khởi tạo Firebase Analytics/GA4.

3.  **Privacy Audit:**
    *   Kiểm tra tuân thủ GDPR/CCPA (User Consent).
    *   Đảm bảo không log PII (Personal Identifiable Information) vào Analytics.

4.  **Validation:**
    *   Xác minh luồng dữ liệu (Data Stream) trong DebugView.
