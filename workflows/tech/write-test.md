---
description: "Write Unit/Widget/Integration Tests with strategy (Strategy-based Testing)."
trigger: /write-test
version: "3.1.0"
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
- ✅ **Happy Path:** Main flow must work correctly.
- ⚠️ **Edge Cases:** Null input, Empty List, Network Error, Timeout, Boundary values.
- 🛡️ **Security:** Test access permissions/validations.

### 2. Mocking Setup
- Identify dependencies that need mocking.
- Ensure Mocking library (Mockito, Mocktail, Jest Mocks, PyTest Mocks) is configured properly.

### 3. Implementation (AAA Pattern)
- **Arrange:** Prepare test data (Fixtures, Factories).
- **Act:** Call function under test.
- **Assert:** Verify output AND side-effects (verify mock was called X times, state changed).

## 🔌 Skill Integration

**Active skills:** `test-engineer`, `code-reviewer`

**Skill sequence:**
1. **test-engineer:** Defines test strategy, identifies test cases.
2. **test-engineer:** Implements tests using AAA pattern.
3. **code-reviewer:** Validates test quality and readability.

Both skills work together to ensure tests are effective and maintainable.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **No Hardcode:** Use factories or `faker` library to generate test data.
- **Readable Names:** Test case names should read like sentences (e.g., `should return Error when API fails`).
- **Test Logic:** Test the business logic, not the framework.
