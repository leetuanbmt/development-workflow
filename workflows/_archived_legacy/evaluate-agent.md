---
description: "Kiểm thử và đánh giá độ tin cậy của AI Agent."
trigger: /evaluate-agent
version: "1.0.0"
skills:
  - agent-evaluation
  - test-engineer
---

# 🤖 Agent Evaluation Workflow

**Mục tiêu:** Đánh giá khả năng suy luận, tuân thủ quy tắc và độ tin cậy của Agent trong dự án.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Define Benchmarks (Xác định tiêu chí):**
    *   Xác định các kịch bản test (Test Scenarios): e.g., "Review Code đúng chuẩn Clean Arch", "Refactor không làm gãy logic".
    *   Định nghĩa Metric thành công.

2.  **Execute Tests (Chạy thử nghiệm):**
    *   Gửi các prompt mẫu hoặc task giả lập cho Agent.
    *   Ghi lại output của Agent.

3.  **Assess (Đánh giá):**
    *   So sánh output với kỳ vọng (Expected Result).
    *   Phân tích hành vi (Behavioral Analysis).

4.  **Report & Improve:**
    *   Báo cáo các điểm yếu (Hallucination, Logic Error).
    *   Đề xuất tinh chỉnh Prompt hoặc Context.
