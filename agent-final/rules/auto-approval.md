---
description: Quy chuẩn tập trung cho Auto-Approval theo loại workflow.
version: 1.0.0
---

# ✅ Auto-Approval Policy (Tập trung)

Mục tiêu: Chuẩn hoá ngưỡng phê duyệt tự động để dùng lại trong nhiều dự án, tránh lệch cấu hình giữa các workflow.

## Bảng Ngưỡng Mặc Định

| Workflow             | Điều kiện tự duyệt                                         | Nguồn                | Ghi chú                                         |
| -------------------- | ---------------------------------------------------------- | -------------------- | ----------------------------------------------- |
| `/fix`               | `confidence_score ≥ 0.85`                                  | fix.md               | Cho phép bỏ qua chờ duyệt khi độ tin cậy đủ cao |
| `/start-task`        | `dor_completeness == 100%`                                 | start-task.md        | Blueprint đủ DoR thì có thể tự chuyển bước      |
| `/implement-feature` | `tests.coverage_percent ≥ 70%` AND `linter_passed == true` | implement-feature.md | Gate chất lượng trước bàn giao                  |

## Quy Tắc Áp Dụng

- Chính sách này là nguồn tập trung, được các workflow đọc làm mặc định.
- Cho phép override theo dự án qua `memory/config.override.json` (deep-merge theo key).
- Mọi quyết định auto-approval phải phát sự kiện monitoring với: `trace_id`, `workflow_id`, `điều kiện`, `giá trị đo được`.

## Ví Dụ Override Theo Dự Án

```json
{
  "policies": {
    "autoApproval": {
      "fix": { "confidenceScore": 0.9 },
      "implement-feature": { "testCoverageMin": 0.8 }
    }
  }
}
```

## Lưu Ý

- Khi một workflow định nghĩa điều kiện riêng, phải trích dẫn về policy này để tránh trôi chuẩn.
- Khi thay đổi ngưỡng, cập nhật changelog ngắn trong PR mô tả tác động rủi ro.
