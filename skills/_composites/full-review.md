---
name: full-review
type: composite
description: Review toàn diện code với cả logic, security và performance
version: "2.4.0"
components:
  - skill: code-reviewer
    role: Logic & Architecture check
    order: 1
  - skill: security-auditor
    role: Security vulnerability scan
    order: 2
  - skill: flutter-expert
    role: Performance & memory check
    order: 3
execution: parallel
---

# 🔍 Full Review (Composite Skill)

Kết hợp 3 chuyên gia để review code toàn diện.

## Components

| Order | Skill | Responsibility |
|:--:|:--|:--|
| 1 | code-reviewer | Logic, architecture, clean code |
| 2 | security-auditor | Vulnerabilities, data exposure |
| 3 | flutter-expert | Performance, memory, optimization |

## Execution Mode: Parallel
Tất cả components chạy đồng thời, kết quả được merge thành một report.

## Output Format

```markdown
## 🔍 Full Review Report

### 1. Code Quality (code-reviewer)
- [findings...]

### 2. Security (security-auditor)
- [findings...]

### 3. Performance (flutter-expert)
- [findings...]

### Summary
| Category | Issues | Severity |
|:--|:--:|:--|
| Code | X | Critical/Major/Minor |
| Security | Y | ... |
| Performance | Z | ... |
```

## When to Use
- Review PR quan trọng
- Kiểm tra trước release
- Audit code legacy
