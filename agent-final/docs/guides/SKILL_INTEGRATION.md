# Skill Integration Guide for Workflows

**Version:** 1.0.0  
**Status:** Implementation Guide  
**Purpose:** Document how to invoke skills within each workflow step

---

## Overview

This guide shows the exact point in each workflow where skills are invoked, what data is passed, and what output is expected.

---

## Workflow: `/start-task`

### Purpose

Transform feature ideas into approved Blueprints with complete DoR (Definition of Ready)

### Skill Integration Map

```
┌─────────────────────────────────────────────────────┐
│ STEP 1-2: Vision Extraction & Refinement           │
├─────────────────────────────────────────────────────┤
│ Skill: product-manager                              │
│ Input: { requirement, context }                     │
│ Output: { refined_requirement, priority, estimate } │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 3: Architecture Design                         │
├─────────────────────────────────────────────────────┤
│ Skill: tech-lead                                    │
│         (+ optional: feature-architect if complex)  │
│ Input: { refined_requirement, product_context }    │
│ Output: Blueprint { entities, use_cases, api... }  │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 4-6: DoR Verification → Approval              │
├─────────────────────────────────────────────────────┤
│ No skill needed (automated checks + user approval)  │
└─────────────────────────────────────────────────────┘
           │
           ▼
      OUTPUT: Blueprint ✓
```

### Detailed Step Breakdown

**STEP 1-2: Call product-manager**

```yaml
trigger: "Product vision extraction"
skill: "product-manager"
input:
  requirement: string # User provides: "Add infinite scroll"
  context:
    priority: enum [critical, high, medium, low]
    deadline: string # e.g., "2 days"
    design_available: bool
output:
  refined_requirement: string # Clear, testable requirement
  priority: enum [critical, high, medium, low]
  estimated_duration: string # "4 hours"
  dependencies: array # ["API supports pagination"]
  assumptions: array # ["User has <500 photos"]
  edge_cases: array # ["First load", "Network failure"]
validation:
  - required_fields: [refined_requirement, priority, estimated_duration]
  - effort_estimate_in_hours: number
next_step: tech_lead_design
```

**STEP 3: Call tech-lead**

```yaml
trigger: "Architecture design based on refined requirements"
skill: "tech-lead"
input:
  refined_requirement: string # From product-manager
  product_context:
    priority: enum
    estimated_duration: string
  code_context: "reference to lib/ folder" # For codebase alignment
output:
  blueprint:
    entities: array # [Photo, PhotoPage]
    use_cases: array # [GetPhotosUseCase]
    api_endpoints: array # [GET /photos]
    ui_screens: array # [PhotoGalleryPage]
    state_management:
      approach: "BLoC"
      events: array
      states: array
    dor:
      requirement_clear: bool
      design_complete: bool
      api_contract_documented: bool
      assets_available: bool
validation:
  - required_fields: [entities, use_cases, api_endpoints, ui_screens]
  - dor_all_checked: bool
  - all_validate_rules_met: bool
next_step: dor_verification
```

**STEP 4-6: No skills**

```yaml
trigger: "After tech-lead completes design"
action: "Automated DoR verification + User approval"
input: "blueprint from tech-lead"
output: "approved blueprint + user_input decision"
validation:
  - all_dor_items_true: bool
  - user_decision: enum [approved, rejected, modified]
on_rejection: "return blueprint for modification"
on_approval: "pass to implement-feature"
```

---

## Workflow: `/implement-feature`

### Purpose

Implement a complete feature through Domain → Data → Presentation layers with testing and audit

### Skill Integration Map

```
┌─────────────────────────────────────────────────────┐
│ STEP 1: DoR Verification                           │
│ (No skill, automated check)                         │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 2: Domain Layer Design                        │
├─────────────────────────────────────────────────────┤
│ Skill: tech-lead                                    │
│ Input: { blueprint, codebase_context }             │
│ Output: domain_layer_design spec                   │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 3-5: Implementation                           │
├─────────────────────────────────────────────────────┤
│ Skill: vibecoder (Domain → Data → Presentation)    │
│ Input: design specs from tech-lead                 │
│ Output: complete source code files                 │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 6: Code Generation                           │
│ (No skill, automated: build_runner)                │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 7: Test Writing                              │
├─────────────────────────────────────────────────────┤
│ Skill: test-engineer                               │
│ Input: source code from vibecoder                  │
│ Output: test files + coverage metrics              │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 8: Quality Audit                             │
├─────────────────────────────────────────────────────┤
│ Skill: code-quality-auditor                        │
│ Input: source + tests + metrics                    │
│ Output: audit report with scores                   │
└─────────────────────────────────────────────────────┘
           │
           ▼
      OUTPUT: Implementation ✓
```

### Detailed Step Breakdown

**STEP 2: Call tech-lead (Domain Design)**

```yaml
trigger: "Before implementation starts"
skill: "tech-lead"
input:
  blueprint: object                # From start-task approval
  codebase_context:
    existing_features: array       # [gallery, folder, album]
    current_patterns: string       # "Reference to CONVENTIONS.md"
output:
  domain_layer_design:
    entities: array                # [Photo, PhotoPage]
    repositories: array            # [PhotoRepository]
    use_cases: array               # [GetPhotosUseCase]
    validation_rules: string
  data_layer_design:
    data_sources: array            # [RemotePhotoDataSource]
    models: array                  # [PhotoDTO]
  presentation_layer_design:
    blocs: array                   # [PhotoGalleryBLoC]
    pages: array                   # [PhotoGalleryPage]
    widgets: array                 # [PhotoGrid]
  dor_verification: object
    requirement_clear: true
    design_complete: true
    api_contract_documented: true
validation:
  - all_layers_designed: bool
validation:
  - verify_layer_independence: "Domain does not depend on Data/Presentation"
  - verify_clean_architecture: bool
next_step: vibecoder_implementation
```

**STEP 3-5: Call vibecoder (Implementation)**

```yaml
trigger: "After design is complete"
skill: "vibecoder"
input:
  blueprint: object # From start-task
  design: object # From tech-lead
  layer_focus: enum [domain, data, presentation]
  code_context: "reference to lib/"
output_per_layer:
  domain_layer:
    entities_created: array # [Photo, PhotoPage]
    repositories_defined: array # [PhotoRepository]
    use_cases_implemented: array # [GetPhotosUseCase]
  data_layer:
    repositories_implemented: array
    data_sources_created: array
    models_created: array
  presentation_layer:
    blocs_created: array
    pages_created: array
    widgets_created: array
validation:
  - all_files_created: bool
  - no_compilation_errors: bool
  - linter_warnings_count: 0
  - defensive_patterns_applied: "null checks, error handling"
next_step: code_generation
```

**STEP 6: Code Generation (No skill)**

```yaml
trigger: "After vibecoder completes all layers"
action: "Run build_runner automatically"
command: "dart run build_runner build --delete-conflicting-outputs"
expected_output:
  generated_files: array
    - "*.freezed.dart"
    - "*.g.dart"
validation:
  - build_runner_success: true
  - no_build_errors: bool
on_failure: "Return error context, do not proceed"
next_step: test_writing
```

**STEP 7: Call test-engineer (Test Writing)**

```yaml
trigger: "After code generation succeeds"
skill: "test-engineer"
input:
  source_files: array # All .dart files in lib/
  specifications:
    use_cases: array # [GetPhotosUseCase]
    error_cases: array # [NetworkError, NullPhoto]
    edge_cases: array # [EmptyList, FirstLoad]
  test_context: "reference to existing test patterns"
output:
  unit_tests:
    files_created: array # [get_photos_use_case_test.dart]
    count: number # 8
    coverage_percent: number # 85
  widget_tests:
    files_created: array # [photo_gallery_page_test.dart]
    count: number # 5
    coverage_percent: number # 80
  total_coverage: number # 85
validation:
  - total_coverage_gte_70: bool
  - all_tests_passing: bool
  - no_skipped_tests: bool # No .skip() calls
  - mock_usage_correct: "using mockito/mocktail"
next_step: quality_audit
```

**STEP 8: Call code-quality-auditor (Audit)**

```yaml
trigger: "After tests pass (coverage >= 70%)"
skill: "code-quality-auditor"
input:
  source_code: "reference to lib/"
  tests: "reference to test/"
  implementation_metrics:
    total_coverage: number
    linter_warnings: number
    build_runner_success: bool
output:
  scores:
    architecture_score: number # 0-10
    code_quality_score: number # 0-10
    performance_score: number # 0-10
    security_score: number # 0-10
    test_coverage_score: number # 0-10
    overall_score: number # 0-10
  violations: array # Clean Architecture violations
  issues: array # Code quality issues
  pass: bool # true if all scores >= 8
validation:
  - check_architecture_rules: "Domain doesn't depend on Data/Presentation"
  - check_code_quality: "Maintainability, readability"
  - check_performance: "No N+1 queries, pagination"
  - check_security: "No common vulnerabilities"
  - check_test_coverage: ">= 70%"
  - check_linter: "0 warnings"
on_high_severity_violations: "Return error, request fix"
on_pass: "Mark feature ready for review"
```

---

## Workflow: `/fix`

### Purpose

Systematically fix bugs through root cause analysis → fix implementation → verification

### Skill Integration Map

```
┌─────────────────────────────────────────────────────┐
│ STEP 1: Investigation                              │
├─────────────────────────────────────────────────────┤
│ Skill: bug-investigator                            │
│ Input: { crash_log, error_message }                │
│ Output: investigation_report with root cause       │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 2-3: Plan & Approval                          │
│ (No skill, automated + user approval)              │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 4: Fix Implementation                         │
├─────────────────────────────────────────────────────┤
│ Skill: vibecoder                                    │
│ Input: investigation_report + fix_plan             │
│ Output: fixed code + file list                     │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 5: Regression Tests                           │
├─────────────────────────────────────────────────────┤
│ Skill: test-engineer                               │
│ Input: fixed code                                  │
│ Output: regression tests + new tests               │
└─────────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────┐
│ STEP 6: Audit & Verification                       │
├─────────────────────────────────────────────────────┤
│ Skill: code-quality-auditor                        │
│ Input: fixed code + tests                          │
│ Output: audit report + verification                │
└─────────────────────────────────────────────────────┘
           │
           ▼
      OUTPUT: PR Ready ✓
```

### Detailed Step Breakdown

**STEP 1: Call bug-investigator**

```yaml
trigger: "Crash or error reported"
skill: "bug-investigator"
input:
  error_source: enum [crash_log, error_message, stacktrace]
  error_content: string # Full error/crash details
  context:
    when_happened: string # "After user scrolled"
    feature: string # "Gallery view"
output:
  error_type: string # "NullPointerException"
  root_cause: string # "StreamController not disposed"
  severity: enum [critical, high, medium, low]
  affected_layer: enum [presentation, domain, data]
  affected_files: array # [photo_gallery_bloc.dart]
  stack_analysis: string # Detailed trace analysis
  reproduction_steps: string # "1. Open app\n2. Scroll..."
  confidence: number # 0.0-1.0
validation:
  - root_cause_confidence_gte_80: bool
  - affected_files_identified: bool
  - reproduction_testable: bool
next_step: fix_planning
```

**STEP 2-3: Plan & Approval (No skill)**

```yaml
trigger: "After investigation completes"
action: "Create fix plan + wait user approval"
input: investigation_report
output:
  fix_plan:
    strategy: string # "Add dispose() call"
    files_to_modify: array # [photo_gallery_bloc.dart]
    estimated_effort: string # "30 minutes"
    risks: array # ["May affect other parts using BLoC"]
    approval_status: enum [pending, approved, rejected]
user_input:
  gate_id: "fix.step3"
  decision: enum [approved, rejected, modified]
validation:
  - user_decision_received: bool
on_rejection: "Stop fix workflow, wait for new plan"
on_approval: "Proceed to implementation"
```

**STEP 4: Call vibecoder (Fix Implementation)**

```yaml
trigger: "After plan approved"
skill: "vibecoder"
input:
  fix_plan: object                 # From step 2-3
  investigation_report: object     # From bug-investigator
  source_code: "reference to lib/"
output:
  fixed_code: object
    files_modified: array          # [photo_gallery_bloc.dart]
    code_changes: string           # Detailed changes
    defensive_patterns: string     # Edge case fixes applied
validation:
  - files_modified_match_plan: bool
  - no_new_compilation_errors: bool
  - linter_warnings: 0
next_step: regression_testing
```

**STEP 5: Call test-engineer (Regression Tests)**

```yaml
trigger: "After fix implemented"
skill: "test-engineer"
input:
  fixed_code: object # From vibecoder
  root_cause: string # From investigation
  original_error: string
output:
  regression_tests:
    count: number # 1+ tests
    covers_original_error: bool
    covers_edge_cases: bool
  existing_tests_still_passing: bool
  total_coverage: number
validation:
  - regression_test_fails_without_fix: bool # Proof test catches bug
  - regression_test_passes_with_fix: bool
  - no_new_test_failures: bool
next_step: quality_audit
```

**STEP 6: Call code-quality-auditor (Audit)**

```yaml
trigger: "After regression tests pass"
skill: "code-quality-auditor"
input:
  fixed_code: object
  tests: object
  metrics:
    regression_tests_passing: bool
    coverage: number
output:
  fix_verification:
    root_cause_fixed: bool
    no_regressions: bool
    no_architectural_violations: bool
  scores:
    architecture_score: number # Must be >= 8
    code_quality_score: number # Must be >= 8
    test_coverage_score: number # Must be >= 8
validation:
  - all_scores_gte_8: bool
  - no_high_severity_issues: bool
next_step: pr_ready
```

---

## Optional Skill: Feature Integration Scenarios

### Complex Feature? When to add `feature-architect`

**Add to start-task STEP 3 if:**

- Requirement affects multiple features
- Requires database migration
- Affects authentication/security layer
- Requires significant refactoring
- Complexity score > 7/10 (estimated)

**Pattern:**

```yaml
STEP 3 (Enhanced):
  - Call tech-lead (standard design)
  - If complexity_score > 7:
      - Also call feature-architect
      - Merge both outputs
      - Create comprehensive blueprint
```

### Complex UI? When to add `frontend-architect`

**Add to implement-feature STEP 2 if:**

- Feature has complex state management
- Multiple animation points
- Custom gestures or scroll behavior
- Performance-critical UI (large lists)
- Complexity score > 7/10

**Pattern:**

```yaml
STEP 2 (Enhanced):
  - Call tech-lead (domain design)
  - If ui_complexity_score > 7:
      - Also call frontend-architect
      - Merge presentation layer design
      - Add animation/performance notes
```

---

## Skill Invocation Validation Checklist

Before calling any skill, verify:

```markdown
### Pre-Invocation Checklist (All workflows)

- [ ] Context object exists and trace_id is preserved
- [ ] All required input fields present in context
- [ ] Input data types match skill's expected input schema
- [ ] Previous step completed successfully (no errors)
- [ ] No approval gates blocking this skill invocation
- [ ] Skill documentation (SKILL.md) reviewed
- [ ] Skill timeout configured appropriately
- [ ] Output validation schema prepared for this step

### Skill-Specific Pre-Checks

#### Before calling product-manager:

- [ ] Requirement is non-empty (string.length > 0)
- [ ] Priority is valid enum value
- [ ] No conflicting priorities already set

#### Before calling tech-lead:

- [ ] product-manager output available (or blueprint from prior flow)
- [ ] Code context points to valid lib/ folder
- [ ] Architecture rules loaded from ARCHITECTURE.md

#### Before calling vibecoder:

- [ ] Design specs complete (no missing entities/use_cases)
- [ ] Code context available and accessible
- [ ] All dependencies resolvable (no missing packages)

#### Before calling test-engineer:

- [ ] Source code compiles without errors
- [ ] Build generation successful (if code generation needed)
- [ ] Test framework installed (test/ folder exists)

#### Before calling code-quality-auditor:

- [ ] Source code compiles
- [ ] Tests run and pass (if testing stage)
- [ ] Coverage data available
- [ ] Linter can run and complete
```

---

## Orchestrator Integration

When orchestrator encounters a workflow step with a skill:

```javascript
// Orchestrator pseudocode (from ORCHESTRATOR.md)
if (step.skill_required) {
  // 1. Load skill
  const skill = load_skill(step.skill_name);

  // 2. Extract input from context
  const input = context[step.input_source];

  // 3. Validate input
  if (!validate_against_schema(input, skill.input_schema)) {
    throw new ValidationError("Skill input validation failed");
  }

  // 4. Invoke skill
  const output = skill.execute(input);

  // 5. Validate output
  if (!validate_against_schema(output, step.output_schema)) {
    throw new ValidationError("Skill output validation failed");
  }

  // 6. Merge into context
  context[step.output_field] = output;
  context.metadata.updated_at = now();
}
```

---

## Next Steps

After skill integration is verified:

- [ ] Update workflow YAML metadata with skill references
- [ ] Test skill invocation with Gallery Infinite Scroll example
- [ ] Test error cases (skill failures)
- [ ] Document troubleshooting if skill fails
- [ ] Create workflow examples for PHASE 5

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-03-09  
**Status:** Implementation Ready
