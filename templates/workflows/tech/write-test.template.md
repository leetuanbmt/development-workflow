---
description: "Write Unit/Integration Tests with strategy."
trigger: /write-test
version: "3.2.0"
skills:
  - test-engineer
  - code-reviewer
constraints:
  max_iterations: 4
  timeout_minutes: 25
  exit_on: ["Tests written", "Tests passed"]
skill: test-engineer
---

# 🧪 Strategic Testing ({{STACK_NAME}})

**Objective:** Write tests using **{{LIB_TEST}}** to catch bugs.

## 🔄 Execution Flow

### 1. Test Strategy
- **Framework:** We are using `{{LIB_TEST}}`.
- **Cases:** Happy Path, Edge Cases (Null/Empty), Error Handling.

### 2. Implementation (AAA Pattern)
- **Arrange:** Setup mocks using `{{LIB_MOCK}}`.
- **Act:** Call the function/component.
- **Assert:** Verify results.

### 3. Verification
**Command:**
```bash
{{CMD_TEST}}
```

## 🔌 Skill Integration
**Active skills:** `test-engineer`, `code-reviewer`

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Style:** Use idiomatic {{STACK_NAME}} testing patterns.
- **Mocking:** Use `{{LIB_MOCK}}` for dependencies.
