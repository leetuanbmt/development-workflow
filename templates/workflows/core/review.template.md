---
description: "Review code, PR, or Git changes."
trigger: /review
version: "2.2.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Report generated"]
skill: code-reviewer
---

# 🧐 Unified Code Review ({{STACK_NAME}})

**Objective:** Quality check code using **{{STACK_NAME}}** standards.

## 🚀 Execution Steps

### 1. Automated Checks (Mental)
- Does code pass `{{CMD_LINT}}` rules?
- Does code follow `{{FILE_VERSION}}` dependencies?

### 2. Deep Analysis
**Focus on {{STACK_NAME}} patterns:**
- {{STACK_ARCH_CHECK}}
- {{STACK_PERF_CHECK}}

### 3. Report Generation
Generate table of issues with Severity/File/Line.

## 💡 AI Guidelines
- **Constructive:** Suggest improvements based on official {{STACK_NAME}} style guides.
