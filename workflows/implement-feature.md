---
description: "Quy trình triển khai tính năng có bước Brainstorming nội bộ (Phase 3)."
trigger: /implement-feature
---

# 🔨 Implement Feature (Humanized)

## 🤝 Giai đoạn 1: Team Refinement (Brainstorming)
**AI Action:** Đóng vai 3 nhân vật để thảo luận về yêu cầu.

*   **BA:** Làm rõ Business Logic và User Experience.
*   **Architect:** Đề xuất giải pháp kỹ thuật (Clean Arch, Data Flow).
*   **QA Lead:** Cảnh báo các Edge cases và rủi ro.

> **Output của bước này:** Một bản "Hợp đồng thực hiện" đã được tối ưu, không chỉ là code theo yêu cầu mà là code có giải pháp cho rủi ro.

## 🛑 Giai đoạn 2: Pre-flight Check (Mode-based Gate)
Dựa trên `Mode` từ `/start-task`:
*   **Standard:** Kiểm tra gắt gao Spec, Design, API.
*   **Hotfix:** Chỉ kiểm tra file đích và logic lỗi.
*   **Prototype:** Kiểm tra luồng UI chính.

## 🏗 Giai đoạn 3: Execution (Multi-role Coding)
*   **Dev:** Viết code theo Clean Architecture.
*   **Designer (UI/UX Skill):** Review lại UI, thêm padding, màu sắc, animation để app "mượt" hơn.
*   **QC:** Viết Test Cases cho cả Happy Path và Edge Cases đã tìm thấy ở Giai đoạn 1.

## 🛡 Giai đoạn 4: Quality Assurance (DoD)
*   Chạy `make lint`, `make test`.
*   Tự review code dựa trên Checklist DoD.

## 📦 Giai đoạn 5: Handover
Xuất báo cáo PR kèm theo các rủi ro đã được xử lý (Risk Mitigation).