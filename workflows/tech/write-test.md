---
description: "Write Unit/Widget Tests with strategy (Strategy-based Testing)."
trigger: /write-test
version: "3.0.0"
skills:
  - test-engineer
  - code-reviewer
constraints:
  max_iterations: 4
  timeout_minutes: 25
  exit_on: ["Tests written", "Tests passed"]
---

# 🧪 Strategic Testing

**Objective:** Write tests to catch bugs, not just for coverage numbers.

## 🔄 Execution Flow

### 1. Test Strategy
Before coding, AI must list test cases:
- ✅ **Happy Path:** Main flow must work correctly
- ⚠️ **Edge Cases:** Null input, Empty List, Network Error, Timeout
- 🛡️ **Security:** Test access permissions (if applicable)

### 2. Mocking Setup
- Identify dependencies that need mocking
- Ensure `mocktail` or `mockito` is configured properly in `setUp` and `tearDown`

### 3. Implementation (AAA Pattern)
- **Arrange:** Prepare test data
- **Act:** Call function under test
- **Assert:** Verify output AND side-effects (verify mock was called X times)

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **No Hardcode:** Use `faker` library (if available) or factories to generate test data
- **Readable Names:** Test case names should read like sentences (e.g., `should return Error when API fails`)