---
description: "Safe code refactoring without breaking existing functionality."
trigger: /refactor
version: "3.2.0"
skills:
  - tech-lead
  - code-reviewer
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Refactor complete", "Tests passed"]
skill: code-reviewer
---

# ♻️ Safe Refactoring ({{STACK_NAME}})

**Objective:** Cleaner code using **{{STACK_NAME}}** idioms.

## 🔄 Execution Flow

### 1. Analysis
- Identify code smells.
- Check against **{{STACK_ARCH_CHECK}}**.

### 2. Safety Net
- Check if tests exist using `{{LIB_TEST}}`.
- If not, suggest writing them first.

### 3. Execution
- Incremental changes.
- Verify with `{{CMD_TEST}}` after each step.

## 💡 AI Guidelines
- **Idiomatic:** Refactor to modern **{{STACK_NAME}}** patterns.
- **Verification:** `{{CMD_TEST}}` must pass.
