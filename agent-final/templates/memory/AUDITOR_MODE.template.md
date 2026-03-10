# {{PROJECT_NAME}} - Auditor Mode Guidelines

> **Last Updated:** {{DATE}}  
> **Purpose:** Standards for auditing code/features from multiple perspectives

---

## 1. Architecture Audit

**Trigger Keywords:** `architecture`, `design`, `layer`, `dependency`, `pattern`

### Checklist

- [ ] **Layer Separation:** Domain, Data, Presentation clearly separated
- [ ] **Dependency Rules:** No upward dependencies (correct direction)
- [ ] **Circular Dependencies:** None detected
- [ ] **Cohesion:** Related code grouped logically
- [ ] **Coupling:** Loose coupling via interfaces/abstractions
- [ ] **SOLID Principles:**
  - [ ] Single Responsibility: Each class has one reason to change
  - [ ] Open/Closed: Open for extension, closed for modification
  - [ ] Liskov Substitution: Subtypes substitutable for base types
  - [ ] Interface Segregation: Clients depend only on methods they use
  - [ ] Dependency Inversion: Depend on abstractions, not concretions

### Report Format

```markdown
## 🏗️ Architecture Audit Report

**Scope:** [Files audited]
**Date:** [Date]

### ✅ Strengths

- {{STRENGTH_1}}
- {{STRENGTH_2}}

### ⚠️ Violations

- {{VIOLATION_1}} (Line {{LINE}})
- {{VIOLATION_2}} (File {{FILE}})

### 💡 Recommendations

- {{RECOMMENDATION_1}}
- {{RECOMMENDATION_2}}

**Decision:** [PROCEED / NEEDS_REVISION / BLOCKED]
```

---

## 2. Security Audit

**Trigger Keywords:** `security`, `auth`, `token`, `api key`, `secret`, `encrypt`, `password`

### Checklist

- [ ] **No Hardcoded Secrets:** No API keys, passwords, tokens in code
- [ ] **Secret Storage:** {{SECRET_STORAGE_METHOD}} used correctly
- [ ] **Authentication:** {{AUTH_METHOD}} properly implemented
- [ ] **Authorization:** User roles/permissions enforced
- [ ] **Input Validation:** User input validated/sanitized
- [ ] **Output Encoding:** Data encoded to prevent injection attacks
- [ ] **HTTPS/TLS:** {{TLS_VERSION}} or higher
- [ ] **Certificate Pinning:** {{CERT_PINNING_REQUIREMENT}}
- [ ] **PII Protection:** Personal data not logged or stored insecurely
- [ ] **Dependency Security:** No known vulnerabilities
  - [ ] Run: `{{DEPENDENCY_CHECK_COMMAND}}`

### Critical Issues

| Issue                | Severity | Fix       |
| -------------------- | -------- | --------- |
| {{CRITICAL_ISSUE_1}} | CRITICAL | {{FIX_1}} |
| {{CRITICAL_ISSUE_2}} | HIGH     | {{FIX_2}} |

### Report Format

```markdown
## 🔐 Security Audit Report

**Scope:** [Features audited]
**Threat Level:** [LOW / MEDIUM / HIGH / CRITICAL]

### Critical Findings

- {{CRITICAL_FINDING_1}}

### Recommended Actions

1. {{ACTION_1}}
2. {{ACTION_2}}

**Decision:** [PROCEED / NEEDS_SECURITY_FIX / BLOCKED]
```

---

## 3. Performance Audit

**Trigger Keywords:** `performance`, `speed`, `latency`, `memory`, `bundle`, `optimize`

### Checklist

- [ ] **Load Time:** {{LOAD_TIME_TARGET}}ms (first meaningful paint)
- [ ] **Memory Usage:** Peak {{MEMORY_TARGET}}MB
- [ ] **CPU Impact:** {{CPU_IMPACT_TARGET}}% background
- [ ] **Battery Drain:** {{BATTERY_TARGET}}% per hour (if applicable)
- [ ] **Bundle Size:** {{BUNDLE_SIZE_TARGET}}MB
- [ ] **Network Usage:** {{NETWORK_BUDGET_TARGET}}MB min/day
- [ ] **No Memory Leaks:** Verified with {{MEMORY_PROFILER}}
- [ ] **Efficient Algorithms:** Time complexity acceptable {{TIME_COMPLEXITY_TARGET}}
- [ ] **Caching Strategy:** Implemented correctly {{CACHING_TECH}}

### Measurements

```bash
# Capture baseline
{{PERF_MEASUREMENT_CMD}}
```

### Report Format

```markdown
## ⚡ Performance Audit Report

### Metrics

| Metric    | Baseline       | Current       | Status     |
| --------- | -------------- | ------------- | ---------- |
| Load Time | {{BASELINE}}ms | {{CURRENT}}ms | {{STATUS}} |
| Memory    | {{BASELINE}}MB | {{CURRENT}}MB | {{STATUS}} |

### Bottlenecks Found

- {{BOTTLENECK_1}} ({{IMPACT}}% impact)
- {{BOTTLENECK_2}}

### Optimization Suggestions

- {{SUGGESTION_1}}

**Decision:** [PROCEED / OPTIMIZE_BEFORE_MERGE / BLOCKED]
```

---

## 4. Code Quality Audit

**Trigger Keywords:** `quality`, `maintainability`, `readability`, `complexity`, `lint`

### Checklist

- [ ] **Linter Passes:** `{{LINT_COMMAND}}` — 0 errors/warnings
- [ ] **Code Formatting:** `{{FORMAT_COMMAND}}` applied
- [ ] **Cyclomatic Complexity:** Functions < {{MAX_CYCLOMATIC_COMPLEXITY}}
- [ ] **Method Length:** Methods < {{MAX_METHOD_LENGTH}} lines
- [ ] **Test Coverage:** ≥ {{COVERAGE_MIN}}%
- [ ] **Documentation:** Complex code documented
- [ ] **Naming:** Clear, self-explanatory names
- [ ] **DRY (Don't Repeat Yourself):** No copy-paste code

### Code Smell Detection

```bash
{{CODE_SMELL_DETECTION_CMD}}
```

### Report Format

```markdown
## 🔍 Code Quality Audit Report

### Quality Metrics

- Cyclomatic Complexity: {{COMPLEXITY_SCORE}}/10
- Test Coverage: {{COVERAGE}}%
- Code Duplication: {{DUPLICATION}}%

### Issues Found

- {{ISSUE_1}} (Severity: {{SEVERITY}})
  Location: {{FILE}}:{{LINE}}

**Decision:** [PROCEED / FIX_BEFORE_MERGE / BLOCKED]
```

---

## 5. Testing Coverage Audit

**Trigger Keywords:** `test`, `coverage`, `unit test`, `integration test`

### Checklist

- [ ] **Unit Tests:** ≥ {{UNIT_COVERAGE}}% coverage
- [ ] **Integration Tests:** {{INTEGRATION_TEST_COUNT}} scenarios covered
- [ ] **Edge Cases:** Error cases tested (null, empty, invalid)
- [ ] **No Flaky Tests:** All tests pass reliably
- [ ] **Test Documentation:** Test purposes clear
- [ ] **Mock Strategy:** Appropriate mocks vs. real objects

### Coverage Report

```bash
{{COVERAGE_REPORT_CMD}}
```

### Report Format

```markdown
## 🧪 Testing Coverage Audit Report

### Coverage by Layer

| Layer        | Coverage        | Target             | Status     |
| ------------ | --------------- | ------------------ | ---------- |
| Domain       | {{DOMAIN_COV}}% | {{DOMAIN_TARGET}}% | {{STATUS}} |
| Data         | {{DATA_COV}}%   | {{DATA_TARGET}}%   | {{STATUS}} |
| Presentation | {{PRES_COV}}%   | {{PRES_TARGET}}%   | {{STATUS}} |

### Missing Tests

- {{MISSING_TEST_1}}

**Decision:** [PROCEED / ADD_TESTS / BLOCKED]
```

---

## 6. Accessibility (A11Y) Audit

**Trigger Keywords:** `accessibility`, `a11y`, `wcag`, `screen reader`, `keyboard`

### Checklist

- [ ] **WCAG {{A11Y_STANDARD}}:** Compliant
- [ ] **Keyboard Navigation:** All features keyboard accessible
- [ ] **Screen Reader:** Tested with {{SCREEN_READER_TOOL}}
- [ ] **Color Contrast:** WCAG AA (4.5:1) minimum
- [ ] **Text Alternatives:** Images have alt text
- [ ] **Focus Management:** Clear focus indicators
- [ ] **Semantic HTML:** Proper tags used
- [ ] **Mobile Accessibility:** Touch targets ≥ {{MIN_TOUCH_SIZE}}px

### Automated Check

```bash
{{A11Y_TEST_CMD}}
```

### Report Format

```markdown
## ♿ Accessibility Audit Report

### A11Y Violations

- {{VIOLATION_1}} (WCAG {{LEVEL}})
- {{VIOLATION_2}}

### Recommendations

1. {{RECOMMENDATION_1}}

**Decision:** [PROCEED / FIX_A11Y / BLOCKED]
```

---

## 7. Audit Decision Matrix

| Audit Type | PROCEED | NEEDS REVISION | BLOCKED |
|------------|---------|******\_\_\_\_******|---------|
| **Architecture** | {{ARCH_PROCEED}} | {{ARCH_REVISION}} | {{ARCH_BLOCKED}} |
| **Security** | {{SEC_PROCEED}} | {{SEC_REVISION}} | {{SEC_BLOCKED}} |
| **Performance** | {{PERF_PROCEED}} | {{PERF_REVISION}} | {{PERF_BLOCKED}} |
| **Quality** | {{QUALITY_PROCEED}} | {{QUALITY_REVISION}} | {{QUALITY_BLOCKED}} |
| **Testing** | {{TEST_PROCEED}} | {{TEST_REVISION}} | {{TEST_BLOCKED}} |
| **A11Y** | {{A11Y_PROCEED}} | {{A11Y_REVISION}} | {{A11Y_BLOCKED}} |

---

## 8. Audit Frequency

| Type          | Frequency   | Trigger                       |
| ------------- | ----------- | ----------------------------- |
| Architecture  | Per PR      | {{ARCH_TRIGGER}}              |
| Security      | Per PR      | API changes, auth changes     |
| Performance   | Per sprint  | Major features, optimizations |
| Code Quality  | Per PR      | Auto (linter)                 |
| Testing       | Per sprint  | Coverage drops                |
| Accessibility | Per quarter | A11Y requirement added        |

---

## 9. Tools & Commands

```bash
# Architecture analysis
{{ARCH_ANALYSIS_CMD}}

# Security scanning
{{SECURITY_SCAN_CMD}}

# Performance profiling
{{PERF_PROFILE_CMD}}

# Code quality
{{CODE_QUALITY_CMD}}

# Testing coverage
{{COVERAGE_CMD}}

# Accessibility check
{{A11Y_CHECK_CMD}}
```
