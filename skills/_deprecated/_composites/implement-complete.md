---
name: implement-complete
type: composite
description: Implement feature end-to-end từ design đến testing
version: "2.4.0"
components:
  - skill: feature-architect
    role: Design architecture & data flow
    order: 1
  - skill: flutter-expert
    role: Implementation with best practices
    order: 2
  - skill: test-engineer
    role: Write unit & widget tests
    order: 3
execution: sequential
---

# 🏗️ Implement Complete (Composite Skill)

Pipeline triển khai feature hoàn chỉnh từ thiết kế đến testing.

## Pipeline Stages

```mermaid
graph LR
    A[feature-architect] --> B[flutter-expert] --> C[test-engineer]
    A -->|Design Doc| B
    B -->|Code| C
```

| Stage | Skill | Output |
|:--:|:--|:--|
| 1 | feature-architect | Architecture design, file structure |
| 2 | flutter-expert | Clean code implementation |
| 3 | test-engineer | Unit tests, widget tests |

## Execution Mode: Sequential
Mỗi stage hoàn thành trước khi chuyển sang stage tiếp theo.

## Checkpoints

### After Stage 1 (Design)
- [ ] Architecture phù hợp Clean Arch
- [ ] Data flow rõ ràng
- [ ] User approve design

### After Stage 2 (Implementation)
- [ ] Code chạy được
- [ ] Lint pass
- [ ] Code gen complete (`make gen`)

### After Stage 3 (Testing)
- [ ] Unit tests pass
- [ ] Coverage >= 80%
- [ ] Edge cases covered

## When to Use
- Implement feature mới hoàn toàn
- Feature có độ phức tạp cao
- Cần đảm bảo quality từ đầu
