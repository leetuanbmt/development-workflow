# Context Passing Guide

**Version:** 1.0.0  
**Purpose:** Document how AI workflows exchange data and coordinate execution  
**Reference:** [orchestrator.md](./ORCHESTRATOR.md) | [workflow-context.schema.json](../schema/workflow-context.schema.json)

---

## 1. Context Passing Overview

### 1.1 What is Context?

Context is a **JSON object** that travels between workflows, carrying:

- **Input data** needed by the current workflow
- **Output data** produced by the previous workflow
- **Execution metadata** (timestamps, trace ID, execution state)
- **Error logs** if failures occurred

Example structure:

```json
{
  "metadata": {
    "trace_id": "ctx_photo_2026_001",
    "created_at": "2026-03-09T10:00:00Z",
    "version": "1.0.0"
  },
  "workflow": {
    "workflow_id": "start-task",
    "status": "completed",
    "current_step": 6
  },
  "blueprint": { ... },  // Output from start-task
  "implementation": { ... }  // Output from implement-feature
}
```

### 1.2 Why Context Matters

Without context passing:

- ❌ Workflows run independently (no coordination)
- ❌ Humans must manually copy/paste outputs between workflows
- ❌ Error context lost when workflows fail
- ❌ No audit trail of decisions made

With context passing:

- ✅ Workflows automatically chain together
- ✅ Data flows automatically (no manual copy/paste)
- ✅ Complete error history preserved
- ✅ Full audit trail for compliance/debugging

---

## 2. Core Context Passing Patterns

### Pattern 1: Sequential Pass-Through

**Overview:** Output from Workflow A becomes input to Workflow B

```
Workflow A                    Orchestrator             Workflow B
┌─────────────┐              ┌──────────┐            ┌─────────────┐
│ start-task  │──create──→   │ Context  │──read───→  │implement-   │
│ Executes    │              │ Object   │            │ feature     │
│ 6 steps     │              │ (JSON)   │            │ Reads       │
│ Outputs:    │              │          │            │ blueprint   │
│ blueprint   │──────────────┴──────────┘            │             │
└─────────────┘                                       └─────────────┘

Context transformation:
INPUT (from A):  { blueprint: {...} }
OUTPUT (to B):   { blueprint: {...} }  ← Same field, ready to use
```

**Concrete example:**

```javascript
// start-task OUTPUT:
{
  "metadata": { "trace_id": "ctx1", "version": "1.0.0" },
  "blueprint": {
    "feature_name": "Gallery Infinite Scroll",
    "entities": [...],
    "use_cases": [...]
  }
}

// implement-feature reads context:
const blueprint = context.blueprint;  // Direct access
const entities = blueprint.entities;  // Ready to implement
```

### Pattern 2: Branching Pass-Through

**Overview:** One workflow output triggers multiple dependent workflows

```
Investigation Output
        ↓
    (Route based on severity)
        ├───→ HIGH: /fix-critical
        ├───→ MEDIUM: /fix-standard
        └───→ LOW: /refactor

// Example:
if (context.investigation_report.severity === "critical") {
    trigger_workflow("fix-critical", context);
} else {
    trigger_workflow("fix-standard", context);
}
```

### Pattern 3: Aggregating Pass-Through

**Overview:** Multiple workflow outputs combine into one context

```
Parallel Executions         Aggregation         Final Output
┌─ GetPhotosUseCase ─┐
│  unit tests ✓      │
└──────────┬──────────┘
           │
           └──→ ┌──────────────┐
                │ Quality      │ ──→ { tests, code_review,
           ┌──→ │ Audit        │       architecture_review }
           │    │ Aggregates   │
┌──────────┴─┐  └──────────────┘
│ Architecture
│ Review ✓   │
└────────────┘
```

---

## 3. Real Example: Gallery Infinite Scroll

### 3.1 Initial Input

**User provides:**

```
requirement: "Add infinite scroll to gallery view"
context: {
  priority: "high",
  deadline: "2 days",
  design_available: true
}
```

### 3.2 Step-by-Step Context Evolution

#### STEP 1: User Triggers `/start-task`

**Input:**

```json
{
  "requirement": "Add infinite scroll to gallery view",
  "context": {
    "priority": "high"
  }
}
```

**Workflow executes** (6 steps):

- step 1: Extract vision
- step 2: Refine requirement
- step 3: Design architecture
- step 4: Verify DoR
- step 5: Create contract
- step 6: Approval gate ⏸ (wait user)

#### STEP 2: User Approves

**User input (at approval gate):**

```
Type: "APPROVED"
```

**Context AFTER approval:**

```json
{
  "metadata": {
    "trace_id": "ctx_gallery_2026_001",
    "created_at": "2026-03-09T10:00:00Z",
    "version": "1.0.0",
    "created_by": "start-task"
  },
  "workflow": {
    "workflow_id": "start-task",
    "status": "completed",
    "current_step": 6,
    "completed_at": "2026-03-09T10:45:00Z"
  },
  "blueprint": {
    "feature_name": "Gallery Infinite Scroll",
    "description": "Add infinite scroll pagination to gallery",
    "priority": "high",

    "entities": [
      {
        "name": "Photo",
        "attributes": [
          { "name": "id", "type": "String" },
          { "name": "filePath", "type": "String" },
          { "name": "createdAt", "type": "DateTime" }
        ]
      },
      {
        "name": "PhotoPage",
        "attributes": [
          { "name": "items", "type": "List<Photo>" },
          { "name": "nextPage", "type": "int" },
          { "name": "hasMore", "type": "bool" }
        ]
      }
    ],

    "use_cases": [
      {
        "name": "GetPhotosUseCase",
        "inputs": ["page: int", "limit: int"],
        "outputs": ["Result<PhotoPage>"]
      },
      {
        "name": "LoadMorePhotosUseCase",
        "inputs": ["currentPhotos: List<Photo>"],
        "outputs": ["Result<List<Photo>>"]
      }
    ],

    "api_endpoints": [
      {
        "method": "GET",
        "path": "/photos",
        "description": "Fetch paginated photos"
      }
    ],

    "ui_screens": [
      {
        "name": "PhotoGalleryPage",
        "type": "page",
        "states": ["initial", "loading", "loaded", "error"]
      },
      {
        "name": "PhotoGrid",
        "type": "widget"
      }
    ],

    "state_management": {
      "approach": "BLoC",
      "events": ["FetchPhotos", "LoadMore"],
      "states": ["Initial", "Loading", "Loaded", "Error"]
    },

    "dor": {
      "requirement_clear": true,
      "design_complete": true,
      "api_contract_documented": true,
      "assets_available": true
    },

    "contract": {
      "in_scope": ["Infinite scroll", "Pagination", "Error handling"],
      "out_of_scope": ["Analytics", "Search filtering"],
      "dod": [
        "Infinite scroll works smoothly",
        "70%+ test coverage",
        "Zero linter warnings",
        "Architecture audit passes"
      ],
      "estimated_effort": "4 hours"
    }
  },

  "user_input": {
    "gate_id": "start-task.step6",
    "decision": "approved",
    "timestamp": "2026-03-09T10:45:00Z"
  }
}
```

#### STEP 3: Orchestrator Auto-Triggers `/implement-feature`

**Validation check:**

```javascript
// Context has blueprint? YES ✓
// Blueprint has entities? YES (Photo, PhotoPage) ✓
// Blueprint has use_cases? YES (GetPhotos, LoadMore) ✓
// Approval status? approved ✓
// → AUTO-TRIGGER implement-feature
```

#### STEP 4: `/implement-feature` Executes

**Workflow reads from context:**

```javascript
const blueprint = context.blueprint;
// Use blueprint.entities, blueprint.use_cases, blueprint.api_endpoints

// Executes 8 steps:
// 1. DoR verification ✓
// 2. Domain design (Photo, PhotoPage entities) ✓
// 3. Domain implementation (GetPhotosUseCase, LoadMorePhotosUseCase) ✓
// 4. Data layer (PhotoRepository, RemotePhotoDataSource) ✓
// 5. Presentation layer (PhotoGalleryBLoC, PhotoGalleryPage, PhotoGrid) ✓
// 6. Code generation (build_runner) ✓
// 7. Tests (8 unit + 5 widget = 85% coverage) ✓
// 8. Quality audit (all scores > 8/10) ✓
```

**Context AFTER implementation:**

```json
{
  "metadata": {
    "trace_id": "ctx_gallery_2026_001", // SAME trace_id
    "created_at": "2026-03-09T10:00:00Z"
  },

  "workflow": {
    "workflow_id": "implement-feature",
    "status": "completed",
    "current_step": 8,
    "started_at": "2026-03-09T10:45:00Z",
    "completed_at": "2026-03-09T12:50:00Z"
  },

  "blueprint": {
    /* ... same as before ... */
  },

  "implementation": {
    "domain_layer": {
      "entities_created": ["Photo", "PhotoPage"],
      "repositories_defined": ["PhotoRepository"],
      "use_cases_implemented": ["GetPhotosUseCase", "LoadMorePhotosUseCase"]
    },

    "data_layer": {
      "repositories_implemented": ["PhotoRepositoryImpl"],
      "data_sources_created": ["RemotePhotoDataSource", "LocalPhotoDataSource"],
      "models_created": ["PhotoDTO", "PhotoPageDTO"]
    },

    "presentation_layer": {
      "blocs_created": ["PhotoGalleryBLoC"],
      "pages_created": ["PhotoGalleryPage"],
      "widgets_created": ["PhotoGrid", "PhotoGalleryItem"]
    },

    "code_generation": {
      "build_runner_success": true,
      "generated_files": [
        "photo.freezed.dart",
        "photo.g.dart",
        "photo_dto.freezed.dart"
      ]
    },

    "tests": {
      "unit_tests": 8,
      "widget_tests": 5,
      "coverage_percent": 85
    }
  },

  "quality_audit": {
    "architecture_score": 9.0,
    "code_quality_score": 8.5,
    "performance_score": 9.0,
    "security_score": 8.0,
    "test_coverage_score": 8.5,
    "issues": [
      {
        "severity": "low",
        "category": "documentation",
        "message": "Add JSDoc for PhotoGalleryBLoC events"
      }
    ]
  }
}
```

#### STEP 5: Context Ready for Next Workflow

**Review workflow receives context:**

```javascript
const implementation = context.implementation;
const qualityAudit = context.quality_audit;

// Developer reviews implementation with all details
// → All code, tests, audit scores available in one context
```

---

## 4. Context Validation Checklist

### 4.1 Before Workflow Execution

**Checklist for `/implement-feature`:**

```markdown
- [x] context.blueprint exists
- [x] context.blueprint.entities.length > 0
- [x] context.blueprint.use_cases.length > 0
- [x] context.blueprint.dor is fully checked
- [x] context.blueprint.contract defined
- [x] context.user_input.decision === "approved"
- [x] No errors in context.workflow.errors
      → Status: READY TO EXECUTE
```

**Checklist for `/code-quality-audit`:**

```markdown
- [x] context.implementation exists
- [x] context.implementation.code_generation.build_runner_success
- [x] context.implementation.tests.coverage_percent >= 70
- [x] source files exist in lib/
- [x] test files exist in test/
- [x] No unresolved compilation errors
      → Status: READY TO EXECUTE
```

### 4.2 After Workflow Execution

**Validation for output:**

```javascript
// Validate that all output fields are present
const requiredFields = ["implementation", "quality_audit"];
const hasAllFields = requiredFields.every(
  (field) => context[field] !== undefined && context[field] !== null,
);

if (!hasAllFields) {
  throw new ValidationError("Missing required output fields");
}
```

---

## 5. Error Scenarios and Recovery

### 5.1 Scenario A: Missing Blueprint

**Problem:**

```
❌ /implement-feature triggered without blueprint from /start-task
```

**Context state:**

```json
{
  "workflow": {
    "workflow_id": "implement-feature",
    "status": "failed",
    "errors": [
      {
        "code": "MISSING_BLUEPRINT",
        "message": "blueprint field not found in context",
        "step": 1
      }
    ]
  }
}
```

**Recovery:**

```
1. Check if /start-task was completed
2. If not: Run /start-task first
3. If yes: Check /start-task output validation
4. Retry /implement-feature with correct context
```

### 5.2 Scenario B: Approval Rejected

**Problem:**

```
User rejects blueprint at /start-task step 6
```

**Context state:**

```json
{
  "workflow": {
    "status": "failed",
    "errors": [
      {
        "code": "USER_REJECTED",
        "message": "User rejected blueprint at approval gate",
        "step": 6
      }
    ]
  },
  "user_input": {
    "gate_id": "start-task.step6",
    "decision": "rejected",
    "timestamp": "2026-03-09T10:50:00Z"
  }
}
```

**Recovery:**

```
1. User provides feedback on what to change
2. Blueprint is sent back to /start-task (or new requirement)
3. Modifications applied to blueprint
4. Re-run /start-task approval gate
```

### 5.3 Scenario C: Tests Fail During Implementation

**Problem:**

```
Widget tests fail while /implement-feature running
```

**Context state:**

```json
{
  "workflow": {
    "workflow_id": "implement-feature",
    "status": "failed",
    "current_step": 7,
    "errors": [
      {
        "code": "TEST_FAILURE",
        "message": "5 widget tests failed",
        "details": {
          "failed_tests": [
            "PhotoGridLoadMoreTrigger_test.dart::test_load_more_on_scroll",
            "PhotoGalleryPage_test.dart::test_error_state"
          ],
          "failure_reason": "StreamController not awaited in cleanup"
        }
      }
    ]
  },
  "implementation": {
    "tests": {
      "unit_tests": 8,
      "widget_tests": 5,
      "coverage_percent": 0
    }
  }
}
```

**Recovery:**

```
1. Review failed tests in context.workflow.errors
2. Fix implementation code (PhotoGalleryBLoC cleanup)
3. Re-run tests (step 7)
4. Continue from step 7 (or step 8 audit if tests pass)
```

---

## 6. Context Passing Between Different Chains

### 6.1 Chain: Fix Bug

```
Error Detection
    ↓
[/investigate] ← Creates: investigation_report
    ↓
[/fix] ← Reads: investigation_report
         Creates: fix_plan, fixed_code
    ↓
[/test] ← Reads: fixed_code
         Creates: test_results
    ↓
[/code-quality-audit] ← Reads: fixed_code, test_results
                        Creates: audit_report
```

**Context evolution:**

```
STAGE 1 (post-investigate):
{
  "investigation_report": {
    "root_cause": "BLoC not disposing StreamController",
    "affected_files": ["lib/features/gallery/presentation/bloc/photo_gallery_bloc.dart"]
  }
}

STAGE 2 (post-fix):
{
  "investigation_report": { ... },
  "fix_plan": {
    "strategy": "Add dispose() cleanup in _close()",
    "files_to_modify": ["photo_gallery_bloc.dart"],
    "approval_status": "approved"
  },
  "implementation": {
    "fixed_code": "... updated BLoC code ..."
  }
}

STAGE 3 (post-test):
{
  "investigation_report": { ... },
  "fix_plan": { ... },
  "implementation": { ... },
  "tests": {
    "new_regression_tests": 1,
    "existing_tests_still_passing": true
  }
}

STAGE 4 (post-audit):
{
  "investigation_report": { ... },
  "fix_plan": { ... },
  "implementation": { ... },
  "tests": { ... },
  "quality_audit": {
    "architecture_score": 9.0,
    "test_coverage_score": 8.5
  }
}
```

---

## 7. Context Validation Rules

### 7.1 General Rules

```javascript
// Rule 1: Trace ID must be preserved
assert(context.metadata.trace_id !== undefined);

// Rule 2: Version must match schema
assert(context.metadata.version === "1.0.0");

// Rule 3: Invalid timestamps
assert(
  new Date(context.metadata.created_at) < new Date(context.metadata.updated_at),
);

// Rule 4: Status must be valid enum
const validStatuses = ["pending", "in_progress", "completed", "failed"];
assert(validStatuses.includes(context.workflow.status));

// Rule 5: Errors array must be valid
context.workflow.errors.forEach((error) => {
  assert(error.code);
  assert(error.message);
  assert(error.step);
});
```

### 7.2 Workflow-Specific Rules

**For `/start-task` output:**

```javascript
// Must have complete blueprint
assert(context.blueprint.feature_name);
assert(context.blueprint.entities.length > 0);
assert(context.blueprint.dor);
assert(context.blueprint.contract);
assert(context.blueprint.contract.estimated_effort);

// Must have approval decision
assert(context.user_input);
assert(context.user_input.decision === "approved");
```

**For `/implement-feature` output:**

```javascript
// Must have implementation in all layers
assert(
  context.implementation.domain_layer &&
    context.implementation.data_layer &&
    context.implementation.presentation_layer,
);

// Must have tests
assert(context.implementation.tests.unit_tests > 0);
assert(context.implementation.tests.widget_tests > 0);
assert(context.implementation.tests.coverage_percent >= 70);

// Must pass audit
assert(context.quality_audit.test_coverage_score >= 7);
```

---

## 8. Troubleshooting Guide

| Problem                                    | Cause                                        | Solution                                             |
| ------------------------------------------ | -------------------------------------------- | ---------------------------------------------------- |
| "blueprint not found"                      | /start-task didn't complete                  | Run /start-task first                                |
| "Validation error: required field missing" | Context schema mismatch                      | Check workflow-context.schema.json                   |
| "Trace ID mismatch"                        | Different workflows have different trace IDs | Use same trace_id throughout chain                   |
| "Approval gate never triggered"            | /start-task configured to skip gate          | Ensure approval gate NOT skipped                     |
| "Tests fail mysteriously"                  | Code written for old API                     | Check API changes in context.blueprint.api_endpoints |
| "Quality audit score too low"              | Architecture violates rules                  | Reference ARCHITECTURE.md and fix violations         |

---

## 9. Best Practices

### ✅ DO:

- ✅ Preserve trace_id across entire workflow chain
- ✅ Validate context before EACH workflow execution
- ✅ Log context at each stage (for debugging)
- ✅ Store full context for audit trail
- ✅ Use JSON schema for validation (not manual checks)
- ✅ Handle missing fields gracefully with clear error messages

### ❌ DON'T:

- ❌ Modify trace_id between workflows
- ❌ Assume previous workflow succeeded without checking
- ❌ Copy/paste context fields (it's error-prone)
- ❌ Lose error history when passing to next workflow
- ❌ Skip validation to "save time"
- ❌ Return context without proper error details

---

## 10. Quick Reference

### Context Creation

```javascript
context = {
  metadata: {
    created_at: new Date().toISOString(),
    trace_id: generateTraceId(),
    version: "1.0.0",
    created_by: "start-task",
  },
  workflow: {
    workflow_id: "start-task",
    status: "in_progress",
    total_steps: 6,
    current_step: 1,
  },
};
```

### Context Reading

```javascript
const blueprint = context.blueprint;
const errors = context.workflow.errors;
const traceId = context.metadata.trace_id;
```

### Context Validation

```javascript
const schema = loadJsonSchema("workflow-context.schema.json");
const isValid = validateJson(context, schema);
if (!isValid) {
  logValidationErrors();
  throw new ValidationError();
}
```

### Context Passing

```javascript
// After workflow A completes
return context; // Contains all input + output

// Workflow B receives
const nextContext = receivedContext; // Same trace_id
```

---

## 11. What's Next?

✅ **PHASE 2 Complete:**

1. Context Schema (workflow-context.schema.json) - **DONE**
2. Orchestrator Algorithm (ORCHESTRATOR.md) - **DONE**
3. Context Passing Guide (this file) - **DONE**

📋 **PHASE 3 (Clarify Skills):**

- [ ] Create skill responsibility matrix
- [ ] Document when each skill invoked
- [ ] Resolve overlaps (code-reviewer vs code-quality-auditor)

🎯 **PHASE 4 (Enrich Memory):**

- [ ] Expand PROJECT.md with tech stack details
- [ ] Detail ARCHITECTURE.md with more rules
- [ ] Add CONVENTIONS.md for common patterns

📚 **PHASE 5 (Workflow Examples):**

- [ ] Gallery Infinite Scroll (complete walkthrough)
- [ ] Bug Fix Workflow (complete walkthrough)
- [ ] Refactoring Workflow (complete walkthrough)

---

**Framework Maturity: PHASE 2 → 8.5/10** (up from 8.2/10)  
**Estimated PHASE 3 effort:** 2-3 hours
