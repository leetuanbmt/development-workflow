# {{PROJECT_NAME}} - Testing Strategy

> **Last Updated:** {{DATE}}  
> **Test Framework:** {{TEST_FRAMEWORK}}

---

## 1. Testing Pyramid

```
        ┌─────────────┐
        │    E2E      │  5-10% ({{E2E_COUNT}} tests)
        ├─────────────┤
        │ Integration │ 15-25% ({{INTEGRATION_COUNT}} tests)
        ├─────────────┤
        │    Unit     │ 65-80% ({{UNIT_COUNT}} tests)
        └─────────────┘

Target Coverage: {{COVERAGE_TARGET}}%
Current Coverage: {{CURRENT_COVERAGE}}%
```

---

## 2. Unit Tests

### Scope

- **Focus:** Individual functions, methods, classes
- **Isolation:** {{UNIT_TEST_ISOLATION_LEVEL}}
- **Mocking:** {{MOCKING_LIBRARY}}

### Test Types

| Type            | Purpose                 | Coverage %               |
| --------------- | ----------------------- | ------------------------ |
| {{TEST_TYPE_1}} | {{TEST_TYPE_1_PURPOSE}} | {{TEST_TYPE_1_COVERAGE}} |
| {{TEST_TYPE_2}} | {{TEST_TYPE_2_PURPOSE}} | {{TEST_TYPE_2_COVERAGE}} |

### File Structure

```
{{UNIT_TEST_FILE_STRUCTURE}}
```

### Example Test

```
{{UNIT_TEST_EXAMPLE}}
```

### Running Unit Tests

```bash
{{UNIT_TEST_RUN_COMMAND}}
```

---

## 3. Integration Tests

### Scope

- **Focus:** {{INTEGRATION_TEST_FOCUS}}
- **Database:** {{INTEGRATION_TEST_DB}}
- **API Mocking:** {{INTEGRATION_TEST_API_MOCKING}}

### Test Levels

- **Repository Tests:** {{REPOSITORY_TEST_STRATEGY}}
- **Use Case Tests:** {{USE_CASE_TEST_STRATEGY}}
- **BLoC/State Tests:** {{STATE_TEST_STRATEGY}}

### Example

```
{{INTEGRATION_TEST_EXAMPLE}}
```

### Running Integration Tests

```bash
{{INTEGRATION_TEST_RUN_COMMAND}}
```

---

## 4. Widget/Component Tests

### Scope

- **Focus:** {{WIDGET_TEST_FOCUS}}
- **Approach:** {{WIDGET_TEST_APPROACH}}
- **Snapshot Testing:** {{SNAPSHOT_TESTING_ENABLED}}

### Key Assertions

```
{{WIDGET_TEST_ASSERTIONS}}
```

### Example

```
{{WIDGET_TEST_EXAMPLE}}
```

### Running Widget Tests

```bash
{{WIDGET_TEST_RUN_COMMAND}}
```

---

## 5. End-to-End (E2E) Tests

### Scope

- **Coverage:** {{E2E_COVERAGE_RANGE}}
- **Tool:** {{E2E_TEST_TOOL}}
- **Scenarios:** {{E2E_SCENARIOS_COUNT}} critical user flows

### Critical User Flows

1. {{CRITICAL_FLOW_1}}
2. {{CRITICAL_FLOW_2}}
3. {{CRITICAL_FLOW_3}}

### Example

```
{{E2E_TEST_EXAMPLE}}
```

### Running E2E Tests

```bash
{{E2E_TEST_RUN_COMMAND}}
```

---

## 6. Coverage Requirements

### Minimum Coverage by Layer

| Layer               | Target                     | Critical?           |
| ------------------- | -------------------------- | ------------------- |
| Domain (Use Cases)  | {{DOMAIN_COVERAGE}}%       | ✅ Yes              |
| Data (Repositories) | {{DATA_COVERAGE}}%         | ✅ Yes              |
| Presentation (BLoC) | {{PRESENTATION_COVERAGE}}% | ⚠️ Critical paths   |
| UI Widgets          | {{UI_COVERAGE}}%           | ⚠️ Critical widgets |

### Enforcement

- **CI Check:** {{COVERAGE_CI_ENFORCEMENT}}
- **Failure Threshold:** {{COVERAGE_FAILURE_THRESHOLD}}%
- **Report Location:** {{COVERAGE_REPORT_LOCATION}}

---

## 7. Test Data & Fixtures

### Test Data Management

- **Strategy:** {{TEST_DATA_STRATEGY}}
- **Reset Between Tests:** {{TEST_DATA_RESET}}
- **Builders Pattern:** {{BUILDERS_PATTERN_ENABLED}}

### Fixtures

```
{{TEST_FIXTURE_EXAMPLE}}
```

---

## 8. Mocking & Stubbing

### Mocking Framework

- **Library:** {{MOCKING_LIBRARY}}
- **Usage:** {{MOCKING_USAGE_LEVEL}}

### When to Mock

- **Always Mock:** {{ALWAYS_MOCK}}
- **Never Mock:** {{NEVER_MOCK}}
- **Sometimes Mock:** {{SOMETIMES_MOCK}}

### Example

```
{{MOCKING_EXAMPLE}}
```

---

## 9. Flaky Test Handling

### Detection

- **Tool:** {{FLAKY_DETECTION_TOOL}}
- **Action:** {{FLAKY_ACTION_STRATEGY}}

### Prevention

- {{FLAKY_PREVENTION_1}}
- {{FLAKY_PREVENTION_2}}
- {{FLAKY_PREVENTION_3}}

---

## 10. CI/CD Integration

### Testing in Pipeline

**Pre-commit:**

```bash
{{PRE_COMMIT_TEST_COMMAND}}
```

**Pre-push:**

```bash
{{PRE_PUSH_TEST_COMMAND}}
```

**On PR:**

```bash
{{PR_TEST_COMMAND}}
```

### Quality Gates

- **Coverage:** ≥ {{COVERAGE_TARGET}}%
- **Pass Rate:** 100%
- **Build Time:** < {{MAX_BUILD_TIME}} mins

---

## 11. Performance Testing

### Benchmarks

- **Load Test Target:** {{LOAD_TEST_TARGET}}
- **Performance Baseline:** {{PERFORMANCE_BASELINE}}
- **Regression Threshold:** {{PERFORMANCE_REGRESSION_THRESHOLD}}%

### Tools

- {{PERFORMANCE_TOOL_1}}
- {{PERFORMANCE_TOOL_2}}

---

## 12. Quick Commands

```bash
# Run all tests
{{RUN_ALL_TESTS}}

# Run unit tests
{{RUN_UNIT_TESTS}}

# Run with coverage
{{RUN_WITH_COVERAGE}}

# Run specific test
{{RUN_SPECIFIC_TEST}}

# Generate coverage report
{{GENERATE_COVERAGE_REPORT}}

# Watch mode (auto-rerun on changes)
{{WATCH_MODE_COMMAND}}
```
