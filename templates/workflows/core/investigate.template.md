---
description: "Analyze root cause of bugs. Report ONLY."
trigger: /investigate
version: "3.3.0"
skills:
  - bug-investigator
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Report generated"]
  no_code_edit: true
skill: bug-investigator
---

# 🕵️ Bug Investigation ({{STACK_NAME}})

**Objective:** Find root cause using **{{STACK_NAME}}** debugging strategies.

## 🚀 Execution Steps

### 1. Context Gathering
- Trace data flow.
- Look for **{{COMMON_BUGS}}**.

### 2. Root Cause Analysis
- Verify hypothesis.
- Check relevant config files (`{{FILE_VERSION}}`, `{{FILE_ENV}}`).

### 3. Report Generation
Generate detailed report.

## 💡 AI Guidelines
- **No Auto-fix:** Investigation ONLY.
- **Evidence:** Reference specific files and lines.
