---
description: "Audit code theo nhiều góc độ. Tự động chọn aspect phù hợp dựa trên context."
trigger: /audit
version: "2.0.0"
skills:
  - code-reviewer
  - tech-lead
constraints:
  max_iterations: 3
  timeout_minutes: 25
  exit_on: ["Audit report generated", "Plan approved"]
---

# 🕵️ Unified Audit Mode

**Mục tiêu:** Phân tích sâu code/feature theo nhiều góc độ trước khi thực hiện thay đổi.

## 🎯 Aspect Detection (Tự động)

| Keywords | Aspect | Focus |
|:---|:---|:---|
| `architecture`, `layer`, `dependency` | `architecture` | Clean Arch compliance |
| `security`, `token`, `api key` | `security` | Vulnerabilities |
| `tracking`, `analytics`, `event` | `analytics` | Event tracking |
| (default) | `general` | Logic, edge cases |

## 🚀 Execution Steps

### 1. Context Discovery
- Đọc `.agent/memory/ARCHITECTURE.md` nếu có
- Xác định module/feature đang audit
- Phân tích pattern đang dùng (Clean Arch, MVC, etc.)

### 2. Deep Investigation
- Quét logic liên quan đến yêu cầu
- Xác định constraints hiện có
- Check resource management (memory, streams)

### 3. Aspect-Specific Checks

#### Architecture Aspect
- [ ] Dependency Rule: Domain không import UI/Data
- [ ] Separation of Concerns: UI chỉ render, Logic trong BLoC
- [ ] Coupling: Không import chéo giữa features

#### Security Aspect
- [ ] Secrets: Không hardcode API keys
- [ ] Logging: Không log sensitive data
- [ ] Input validation: Sanitize user input

#### Analytics Aspect
- [ ] Event naming convention
- [ ] Required parameters present
- [ ] No PII in tracking

### 4. Generate Report

```markdown
## Audit Report

### Aspect: [architecture/security/analytics/general]

### Findings
- ✅ **Good:** [Điểm tuân thủ tốt]
- ⚠️ **Warning:** [Technical debt tiềm ẩn]
- 🔴 **Violation:** [Vi phạm nghiêm trọng]

### Implementation Plan (nếu cần thay đổi)
1. [Step 1]
2. [Step 2]
Files affected: [list]
```

## 💡 AI Guidelines
- Không giáo điều: Simple widget không cần full Clean Arch
- Giải thích "Why": Tại sao vi phạm này nguy hiểm
- Chờ approval trước khi thực thi plan
