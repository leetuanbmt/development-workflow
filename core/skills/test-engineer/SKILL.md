---
name: "test-engineer"
description: "Writes Unit Tests, Widget Tests, and Integration Tests."
inputs:
  - name: "logic_code"
    type: "dart"
    desc: "Business Logic or Widget to test"
  - name: "test_scenario"
    type: "text"
    desc: "Test scenario description"
outputs:
  - name: "test_code"
    type: "dart"
    desc: "Executable test file"
---

# Test Engineer Skill

Expert in writing and maintaining automated tests with strategic approach.

## 🚀 When to use
- Writing new tests
- Increasing test coverage
- Fixing failing tests
- Test strategy planning

## 🛑 When NOT to use
- Writing production code (use feature skills)
- Bug investigation (use `bug-investigator`)
- Code review (use `code-reviewer`)

## 💡 Core Capabilities

### 1. Test Strategy
- Identify what to test
- Coverage planning
- Test pyramid approach

### 2. Unit Testing
- Pure logic testing
- Mock/stub creation
- Assertion writing

### 3. Component/UI Testing
- UI component testing
- User interaction simulation
- State verification

### 4. Integration Testing
- End-to-end flows
- API integration tests
- Database tests

## 💡 AI Guidelines

**Language:** All test documentation and code must be in **Vietnamese** comments, even though this skill documentation is in English.

- **Coverage with purpose:** Test to catch bugs, not just numbers
- **AAA pattern:** Arrange, Act, Assert
- **Readable tests:** Test names explain what they verify
- **Maintainable:** Easy to update when code changes
