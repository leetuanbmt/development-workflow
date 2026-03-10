---
description: "<Mô tả ngắn gọn về workflow>"
trigger: /<command>
version: "1.0.0"
skills:
  - <primary-skill>
constraints:
  max_iterations: 1
  timeout_minutes: 30
  exit_on: ["<Điều kiện thoát>"]
skill: <primary-skill>
---

# 🚀 <Tên Workflow>

**Objective:** <Mục tiêu ngắn gọn>

**Status:** Production-ready (v1.0.0)

---

## 📥 Input Schema

```json
{
  "type": "object",
  "required": ["<key>"]
}
```

## 📤 Output Schema

```json
{
  "type": "object",
  "properties": { "status": { "type": "string" } }
}
```

## 🔄 Step-by-Step Execution

### STEP 1: <Tên bước>

**Process:** <Mô tả ngắn>
**Outputs:** <Kết quả mong đợi>

---

## 🧩 Cấu hình đề xuất

- Đọc `agent-final/config/framework.json` để lấy: `maxIterations`, `timeoutMinutes`, `autoApproval`.
- Khi có điều kiện tự duyệt, dẫn chiếu `rules/auto-approval.md`.
