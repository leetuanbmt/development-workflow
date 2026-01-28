---
description: "Khởi động task mới với quy trình phân tích và lập kế hoạch chuẩn Auditor."
trigger: /start-task
version: "3.0.0"
skills:
  - tech-lead
  - feature-architect
  - product-manager
---

# 🚀 Start Task (Auditor Edition)

**Mục tiêu:** Chuyển đổi yêu cầu thô (Raw Request) thành Kế hoạch hành động (Action Plan) có thể kiểm soát được.

## 🔄 Quy trình (Execution Flow)

### 1. Context & Memory Loading
*   **Memory Scan:** Kiểm tra `.agent/memory/knowledge_base.md` để tìm các bài học liên quan.
*   **Project Context:** Đọc `.agent/memory/PROJECT.md` để hiểu mục tiêu dự án.

### 2. Mode Selection (Chọn chế độ)
Dựa trên yêu cầu, AI đề xuất 1 trong 3 chế độ:
*   **🔥 Hotfix:** Sửa lỗi gấp. Bỏ qua Spec chi tiết, tập trung vào Fix & Verify.
*   **🏗️ Feature:** Tính năng mới. Yêu cầu Plan chi tiết (Layering, API, UI).
*   **🧪 Prototype:** Thử nghiệm. Code nhanh, chấp nhận nợ kỹ thuật (nhưng phải cô lập).

### 3. Strategic Planning (Quan trọng)
AI phải trình bày kế hoạch gồm 3 phần:
*   **🎯 Objective:** Mục tiêu cuối cùng là gì? (Definition of Done).
*   **⚠️ Risks & Constraints:** Có rủi ro gì về kiến trúc, performance, hay bảo mật?
*   **📋 Implementation Steps:** Các bước thực hiện cụ thể (dưới dạng checklist).

### 4. User Confirmation
*   Chờ Auditor (User) duyệt Plan.
*   Nếu duyệt -> Chuyển sang thực thi (dùng các lệnh `/fix`, `/implement`...).

## 💡 Hướng dẫn cho AI
*   **Không diễn kịch:** Bỏ qua màn "Họp team giả lập". Hãy đóng vai trò là một trợ lý kỹ thuật cao cấp báo cáo trực tiếp cho CTO.
*   **Tư duy phản biện:** Nếu yêu cầu của User mơ hồ, hãy đặt câu hỏi làm rõ (Clarifying Questions) thay vì đoán mò.
