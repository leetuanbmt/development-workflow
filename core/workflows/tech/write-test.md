---
description: "Write Unit/Widget Tests with strategy (Strategy-based Testing)."
trigger: /write-test
version: "5.2.0"
skills:
  - test-engineer
  - code-reviewer
constraints:
  max_iterations: 4
  timeout_minutes: 25
  exit_on: ["Tests written", "Tests passed"]
skill: test-engineer
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

## 🔌 Skill Integration

**Active skills:** `test-engineer`, `code-reviewer`

**Skill sequence:**
1. **test-engineer:** Defines test strategy, identifies test cases
2. **test-engineer:** Implements tests using AAA pattern
3. **code-reviewer:** Validates test quality and readability

Both skills work together to ensure tests are effective and maintainable.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **No Hardcode:** Use `faker` library (if available) or factories to generate test data
- **Readable Names:** Test case names should read like sentences (e.g., `should return Error when API fails`)