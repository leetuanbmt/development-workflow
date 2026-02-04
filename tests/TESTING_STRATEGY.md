# Testing Strategy for AI-Native Development Workflow

## 1. Test Categories

### 1.1 Unit Tests
- **Target:** Individual scripts (sync.sh, doctor.sh, generate_metadata.py)
- **Tool:** Bash unit testing framework (bats) / pytest
- **Coverage:** Core logic, error handling

### 1.2 Integration Tests
- **Target:** Workflow end-to-end flows
- **Tool:** Custom bash scripts simulating user interactions
- **Coverage:** `/start-task` → `/vibe`, `/fix` → verification

### 1.3 Smoke Tests
- **Target:** System health across different stacks
- **Tool:** doctor.sh wrapper
- **Coverage:** Flutter, Node.js, Python setups

## 2. Test Structure

```
tests/
├── unit/
│   ├── test_sync.sh
│   ├── test_doctor.sh
│   └── test_metadata_generator.py
├── integration/
│   ├── test_start_task_workflow.sh
│   ├── test_vibe_workflow.sh
│   └── test_fix_workflow.sh
├── smoke/
│   ├── test_flutter_setup.sh
│   ├── test_nodejs_setup.sh
│   └── test_python_setup.sh
└── fixtures/
    ├── sample_pubspec.yaml
    ├── sample_package.json
    └── sample_requirements.txt
```

## 3. Test Execution

### Manual Testing
```bash
# Run all tests
make test

# Run specific category
make test-unit
make test-integration
make test-smoke
```

### CI/CD (GitHub Actions)
```yaml
name: Test Suite
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: make test
```

## 4. Success Criteria

| Test Category | Pass Rate | Threshold |
|:---|:---:|:---|
| Unit Tests | 100% | All must pass |
| Integration Tests | 90%+ | Critical flows |
| Smoke Tests | 100% | Stack detection |

## 5. Test Implementation Plan

### Phase 1 (Week 1)
- [ ] Create test structure
- [ ] Write unit tests for sync.sh
- [ ] Write unit tests for doctor.sh

### Phase 2 (Week 2)
- [ ] Integration test: /start-task → /vibe
- [ ] Integration test: /fix workflow
- [ ] Smoke tests for Flutter

### Phase 3 (Week 3)
- [ ] Setup GitHub Actions CI/CD
- [ ] Add code coverage reporting
- [ ] Document test writing guide
