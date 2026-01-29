---
description: "Review code, PR hoặc Git changes. Tự động detect context và mode."
trigger: /review
version: "2.0.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Report generated"]
---

# 🧐 Unified Code Review

**Objective:** Kiểm tra chất lượng code trong một bước duy nhất. Tự động phát hiện context.

## 🎯 Mode Detection (Tự động)

| Context | Mode | Trigger |
|:---|:---|:---|
| File path được chỉ định | `code` | Review file cụ thể |
| Có uncommitted changes | `changes` | `git diff HEAD` |
| Có branch/PR reference | `pr` | `git diff origin/main` |

## 🚀 Execution Steps

### 1. Identify Change Source
```bash
# AI tự chạy để xác định context
git status --short
git diff --stat HEAD
```

### 2. Multidimensional Check
- **Logic:** Tính đúng đắn, edge cases, null safety
- **Architecture:** Clean Arch compliance, Dependency Rule
- **Style:** Lint/Format theo `analysis_options.yaml`
- **Impact:** Files bị ảnh hưởng gián tiếp

### 3. Generate Report

```markdown
## Review Report

### DoD Checklist
| Criteria | Status |
|:---|:---|
| Lint/Format | ✅/🔴 |
| Clean Arch | ✅/🔴 |
| Tests | ✅/⚠️ |

### Findings
- 🔴 **Critical:** [Lỗi logic, crash]
- 🟡 **Major:** [Vi phạm arch, thiếu test]
- 🔵 **Minor:** [Naming, style]

### Suggested Fixes
[Code snippets for Critical/Major issues]
```

## 💡 AI Guidelines
- Thay đổi nhỏ → Báo cáo ngắn gọn
- PR lớn → Phân tích theo từng module
- Luôn cung cấp code snippet cho Critical/Major
- KHÔNG tự sửa code, chỉ report
