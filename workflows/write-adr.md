---
description: "Ghi lại quyết định kiến trúc quan trọng (ADR) để lưu vết lịch sử dự án."
trigger: /write-adr
skills:
  - tech-lead
---

# 🏛️ Ghi nhận Quyết định Kiến trúc (Write ADR)

**Mục tiêu:** Tạo tài liệu lưu trữ lý do, bối cảnh và kết quả của các quyết định kỹ thuật quan trọng. Giúp team hiểu "Tại sao chúng ta lại làm thế này?" trong tương lai.

## 🚀 Các bước thực hiện (Execution Steps)

1.  **Xác định Vấn đề (Context):**
    *   Vấn đề kỹ thuật hoặc nghiệp vụ đang gặp phải là gì?
    *   Các ràng buộc (Constraints) là gì?

2.  **Liệt kê Lựa chọn (Options):**
    *   **Option 1:** Mô tả + Ưu điểm + Nhược điểm.
    *   **Option 2:** Mô tả + Ưu điểm + Nhược điểm.
    *   ...

3.  **Ra quyết định (Decision):**
    *   Chúng ta chọn phương án nào?
    *   Lý do chính yếu (Driver) là gì?

4.  **Hệ quả (Consequences):**
    *   Kết quả tích cực (Positive).
    *   Hệ quả tiêu cực hoặc nợ kỹ thuật chấp nhận (Negative/Tech Debt).

## 📝 Template Output
Tạo file mới tại `docs/adr/[000X]-[tên-quyết-định-kebab-case].md`:

```markdown
# [Title]

*   **Status:** Accepted / Proposed / Deprecated
*   **Date:** YYYY-MM-DD
*   **Deciders:** [Names]

## Context and Problem Statement
[Mô tả vấn đề]

## Decision Drivers
*   [Driver 1]
*   [Driver 2]

## Considered Options
*   [Option 1]
*   [Option 2]

## Decision Outcome
Chosen option: "[Option 1]", because [Justification].

## Pros and Cons of the Options
### [Option 1]
*   Good, because ...
*   Bad, because ...

### [Option 2]
*   Good, because ...
*   Bad, because ...
```

## 💡 Hướng dẫn cho Gemini
*   Kích hoạt skill `technical-writer` hoặc `feature-architect`.
*   Đảm bảo số thứ tự ADR tăng dần.
