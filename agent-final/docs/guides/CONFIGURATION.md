# Framework Configuration Guide

Version: 1.0.0

Mục tiêu: Chuẩn hoá cấu hình framework để có thể tái sử dụng ở nhiều dự án, với khả năng override an toàn theo từng dự án.

---

## 1) Cấu hình Trung tâm (Framework Defaults)

- Tập tin: `agent-final/config/framework.json`
- Nội dung chính:
  - `defaults`: ngôn ngữ, `maxIterations`, `timeoutMinutes` theo workflow
  - `policies`: `parallelization`, `autoApproval`, `qualityGates`
  - `monitoring`: bật/tắt CLI, lịch sử mặc định, sự kiện cần ghi

## 2) Chính sách Cache

- Tập tin: `agent-final/config/cache.policy.json`
- Nội dung: TTL, retention, nén, loại trừ field nặng, đường dẫn lưu trữ, lịch dọn rác

## 3) Override Theo Dự Án

- Đường dẫn gợi ý: `memory/config.override.json`
- Chiến lược: Deep-merge lên `config/framework.json` (ghi đè theo key)
- Ví dụ:

```json
{
  "defaults": {
    "language": "en"
  },
  "policies": {
    "autoApproval": {
      "fix": { "confidenceScore": 0.9 }
    }
  }
}
```

Mẫu có sẵn: `agent-final/memory/config.override.example.json` — sao chép thành `memory/config.override.json` rồi tuỳ chỉnh.

## 4) Thứ tự Ưu tiên Cấu hình

1. `memory/config.override.json` (per-project)
2. `agent-final/config/framework.json` (framework defaults)
3. Hằng số nội bộ trong workflow (chỉ dùng khi 1 & 2 không có)

## 5) Liên kết với Workflow

- Mỗi workflow nên đọc cấu hình qua Orchestrator để thống nhất (ví dụ: `max_iterations`, `timeout_minutes`, `auto_approval`).
- Khi một workflow có điều kiện auto-approval riêng, dẫn chiếu `rules/auto-approval.md`.

## 6) Kiểm soát Song song (Parallelization)

- Chính sách mặc định: `guard = sequential_if_missing_dependencies` và `maxConcurrency = 2`.
- Workflow có thể tắt song song nếu chưa đủ artifact phụ thuộc hoặc tài nguyên hạn chế.

## 7) Giám sát & Sự kiện

- Bật ghi sự kiện auto-approval, cache stats.
- CLI (tài liệu tại `docs/monitoring/WORKFLOW_MONITORING.md`) nên đọc các flag trong cấu hình để hiển thị.

---

Tham khảo thêm:

- `rules/auto-approval.md` — chuẩn hoá điều kiện tự duyệt.
- `docs/guides/CONTEXT_CACHING.md` — kiến trúc cache.
- `docs/guides/CONTEXT_PASSING.md` — hợp đồng context giữa workflows.
