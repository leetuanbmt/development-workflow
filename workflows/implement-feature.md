---
description: "Quy trình triển khai tính năng có bước Brainstorming nội bộ (Phase 3)."
trigger: /implement-feature
version: "2.4.0"
skills:
  - flutter-expert
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

## ⏸️ Giai đoạn 3.5: Code Gen Checkpoint (User Action Required)
Nếu thay đổi có liên quan đến `Entity`, `Retrofit`, `Drift`, `Freezed`:
1.  **AI Stop:** Dừng lại, không được viết tiếp code logic phụ thuộc vào file chưa sinh.
2.  **User Request:** "Bạn vui lòng chạy `make gen`. Tôi sẽ đợi."
3.  **Resume:** Sau khi User confirm "Done" hoặc "OK", AI mới tiếp tục sang Giai đoạn 4.

## 🛡 Giai đoạn 4: Quality Assurance (DoD & Regression)

*   **Lint Check:** Chạy `make lint`. Tự động fix lỗi nếu có thể (`dart fix --apply`).

*   **Regression Test:** Chạy `make test` (toàn bộ dự án) để đảm bảo feature mới không làm hỏng tính năng cũ.

*   **Self-Review:** Đối chiếu với checklist DoD.



## 📦 Giai đoạn 5: Handover (Automation)

1.  **Generate Report:** Sử dụng tool `write_file` để tạo file báo cáo PR tại `docs/prs/PR_[FeatureName].md` thay vì chỉ in ra màn hình.

2.  **User Notification:** Thông báo cho user đường dẫn file báo cáo và hướng dẫn lệnh `git push`.
