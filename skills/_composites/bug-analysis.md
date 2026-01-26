---
name: bug-analysis
type: composite
description: Phân tích bug sâu với cả root cause và technical details
version: "2.4.0"
components:
  - skill: bug-investigator
    role: Find root cause & impact analysis
    order: 1
  - skill: flutter-expert
    role: Deep technical investigation
    order: 2
execution: sequential
---

# 🐛 Bug Analysis (Composite Skill)

Kết hợp điều tra viên và chuyên gia kỹ thuật để phân tích bug phức tạp.

## Pipeline

| Stage | Skill | Focus |
|:--:|:--|:--|
| 1 | bug-investigator | Root cause, impact, reproduce steps |
| 2 | flutter-expert | Memory issues, lifecycle, deep debug |

## Execution Mode: Sequential
1. bug-investigator tìm root cause và phạm vi ảnh hưởng
2. flutter-expert đào sâu vào kỹ thuật (nếu cần)

## Output Format

```markdown
## 🐛 Bug Analysis Report

### Phase 1: Investigation (bug-investigator)
**Root Cause:** [description]
**Impact:** [scope & severity]
**Reproduce Steps:** [1, 2, 3...]

### Phase 2: Technical Deep Dive (flutter-expert)
**Memory Analysis:** [if applicable]
**Lifecycle Issues:** [if applicable]
**Performance Impact:** [if applicable]

### Recommended Fix
[Solution with code snippets]
```

## When to Use
- Bug liên quan đến memory/performance
- Bug khó reproduce
- Bug ảnh hưởng nhiều components
- Crash không rõ nguyên nhân
