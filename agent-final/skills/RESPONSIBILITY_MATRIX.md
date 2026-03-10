# Skill Responsibility Matrix

**Version:** 1.0.0  
**Status:** Production Guide  
**Purpose:** Define when each skill is invoked, what it does, and its input/output contract

---

## Quick Reference Table

| Skill                  | Primary Purpose                                        | Primary Workflow                | Layer Focus                  | Input Type          | Output Type          |
| ---------------------- | ------------------------------------------------------ | ------------------------------- | ---------------------------- | ------------------- | -------------------- |
| `product-manager`      | Product vision + requirements refinement               | start-task                      | Product                      | Free text           | Feature requirements |
| `tech-lead`            | Architecture design + DoR verification                 | start-task, implement-feature   | Architecture                 | Requirements        | Design blueprint     |
| `vibecoder`            | High-speed production code implementation              | implement-feature, fix          | Domain + Data + Presentation | Design spec         | Complete code files  |
| `test-engineer`        | Test suite creation + coverage tracking                | implement-feature, fix          | Testing                      | Source code         | Test files + metrics |
| `code-quality-auditor` | Architecture + code quality + defensive patterns audit | implement-feature, fix (step 6) | Audit + Error handling       | Source code         | Audit report         |
| `bug-investigator`     | Root cause analysis + confidence scoring               | fix (step 1)                    | Debugging                    | Error/crash log     | Investigation report |
| `security-auditor`     | Security vulnerability scan                            | Optional audit                  | Security                     | Source code         | Security report      |
| `feature-architect`    | Major feature design                                   | Optional: start-task            | Architecture                 | Complex requirement | Detailed design      |
| `frontend-architect`   | UI/UX architecture                                     | Optional: implement-feature     | Presentation                 | UI requirements     | UI architecture      |

---

## Skill Profiles (Detailed)

### 1. Product Manager

**Invoked At:** `/start-task` - STEP 1-2 (Vision Extraction & Refinement)

**Responsibilities:**

- Extract clear product vision from ambiguous requirement
- Refine requirements with user interaction
- Identify scope boundaries (in-scope vs out-of-scope)
- Determine priority and effort estimate
- Create human-friendly narrative of feature

**Input Contract:**

```
Requirement (text): "Add infinite scroll to gallery"
Context (optional): { priority, deadline, design_available }
```

**Output Contract:**

```json
{
  "refined_requirement": "Add lazy-loaded infinite scroll pagination to gallery view with UI loading indicators",
  "priority": "high",
  "estimated_duration": "4 hours",
  "dependencies": ["API supports pagination", "UI design available"],
  "assumptions": [
    "Data structure supports limit/offset",
    "Users have <500 photos"
  ],
  "edge_cases": [
    "First load",
    "Network failure",
    "Empty gallery",
    "All photos loaded"
  ]
}
```

**Success Criteria:**

- ✅ Requirement is specific and testable
- ✅ Effort estimate within 1-2 hours accuracy
- ✅ All dependencies explicitly listed
- ✅ Edge cases identified (minimum 3)

**Overlap Resolution:** Does NOT overlap with tech-lead (which is technical architecture, not product scope)

---

### 2. Tech Lead

**Invoked At:** `/start-task` - STEP 3 (Design) AND `/implement-feature` - STEP 2 (Domain Design)

**Responsibilities:**

- Design technical architecture (layers, components, data flow)
- Define domain entities and use cases
- Verify Clean Architecture adherence
- Identify required API contracts
- Review DoR completeness

**Input Contract (start-task):**

```json
{
  "refined_requirement": "string",
  "product_context": { "priority", "duration", "dependencies" },
  "codebase_context": "reference to PROJECT.md + ARCHITECTURE.md"
}
```

**Input Contract (implement-feature):**

```json
{
  "blueprint": { "entities", "use_cases", "api_endpoints", "ui_screens" },
  "code_context": "reference to existing feature folders"
}
```

**Output Contract (start-task):**

```json
{
  "entities": [
    { "name": "Photo", "attributes": [...], "validation_rules": [...] },
    { "name": "PhotoPage", "attributes": [...] }
  ],
  "use_cases": [
    { "name": "GetPhotosUseCase", "inputs": [...], "outputs": [...] }
  ],
  "api_endpoints": [
    { "method": "GET", "path": "/photos", "description": "..." }
  ],
  "ui_screens": [
    { "name": "PhotoGalleryPage", "type": "page", "states": [...] }
  ],
  "state_management": { "approach": "BLoC", "events": [...], "states": [...] },
  "architectural_notes": "Follows Clean Architecture with injectable DI"
}
```

**Output Contract (implement-feature):**

```json
{
  "domain_layer_design": {
    "entities": ["Photo", "PhotoPage"],
    "repositories": ["PhotoRepository"],
    "use_cases": ["GetPhotosUseCase"],
    "validation_rules": "..."
  },
  "data_layer_design": {
    "data_sources": ["RemotePhotoDataSource", "LocalPhotoDataSource"],
    "models": ["PhotoDTO", "PhotoPageDTO"],
    "mappers": "..."
  },
  "presentation_layer_design": {
    "blocs": ["PhotoGalleryBLoC"],
    "pages": ["PhotoGalleryPage"],
    "widgets": ["PhotoGrid", "PhotoGalleryItem"]
  },
  "dor_verification": { "requirement_clear": true, "design_complete": true, ... }
}
```

**Success Criteria:**

- ✅ Design follows Clean Architecture (Data → Domain → Presentation)
- ✅ DoR checklist 100% complete
- ✅ All API contracts documented
- ✅ State management approach chosen (BLoC)
- ✅ Effort estimate validated

**Overlap Resolution:** Tech-lead does design, NOT implementation (that's vibecoder)

---

### 3. Vibecoder

**Invoked At:** `/implement-feature` - STEP 3-5 (Domain → Data → Presentation) AND `/fix` - STEP 4 (Fix Implementation)

**Responsibilities:**

- Implement domain layer (entities, repositories, use cases)
- Implement data layer (DTOs, data sources, mappers)
- Implement presentation layer (BLoC, Pages, Widgets)
- Write production-grade code with defensive patterns
- Apply code generation tools (freezed, retrofit, injectable)

**Input Contract:**

```json
{
  "blueprint": { "entities", "use_cases", "api_endpoints" },
  "design": { "domain_layer_design", "data_layer_design", "presentation_layer_design" },
  "code_context": "reference to lib/ folder structure"
}
```

**Output Contract:**

```json
{
  "domain_layer": {
    "entities_created": ["Photo", "PhotoPage"],
    "repositories_defined": ["PhotoRepository"],
    "use_cases_implemented": ["GetPhotosUseCase"]
  },
  "data_layer": {
    "repositories_implemented": ["PhotoRepositoryImpl"],
    "data_sources_created": ["RemotePhotoDataSource"],
    "models_created": ["PhotoDTO"],
    "generated_files": ["photo_dto.freezed.dart"]
  },
  "presentation_layer": {
    "blocs_created": ["PhotoGalleryBLoC"],
    "pages_created": ["PhotoGalleryPage"],
    "widgets_created": ["PhotoGrid"],
    "generated_files": ["photo_gallery_bloc.freezed.dart"]
  },
  "code_quality": {
    "defensive_patterns_applied": "null checks, error handling",
    "compilation_successful": true,
    "linter_warnings": 0
  }
}
```

**Success Criteria:**

- ✅ All layers implemented (Domain, Data, Presentation)
- ✅ Code compiles without errors
- ✅ build_runner execution successful (generated files present)
- ✅ 0 linter warnings
- ✅ Defensive patterns applied (null safety, error handling)
- ✅ Follows codebase conventions (naming, folder structure)

**Overlap Resolution:** Vibecoder does implementation, NOT testing (that's test-engineer) or auditing (that's code-quality-auditor)

---

### 4. Test Engineer

**Invoked At:** `/implement-feature` - STEP 7 (Write Tests) AND `/fix` - STEP 5 (Generate Tests)

**Responsibilities:**

- Write unit tests for domain layer (use cases, repositories)
- Write widget tests for presentation layer (BLoCs, Pages)
- Achieve 70%+ code coverage
- Test edge cases and error scenarios
- Verify test quality and maintainability

**Input Contract:**

```json
{
  "source_code": { "domain_layer_files", "data_layer_files", "presentation_layer_files" },
  "specifications": { "use_cases", "error_cases", "edge_cases" }
}
```

**Output Contract:**

```json
{
  "unit_tests": {
    "files_created": [
      "get_photos_use_case_test.dart",
      "photo_repository_test.dart"
    ],
    "count": 8,
    "coverage": 85
  },
  "widget_tests": {
    "files_created": ["photo_gallery_page_test.dart", "photo_grid_test.dart"],
    "count": 5,
    "coverage": 80
  },
  "total_coverage": 85,
  "coverage_requirement_met": true,
  "test_failures": 0,
  "test_execution_time": "2.3s"
}
```

**Success Criteria:**

- ✅ Total coverage ≥ 70%
- ✅ All tests passing
- ✅ No skipped tests (no `skip()`)
- ✅ Edge cases covered (minimum 3 per use case)
- ✅ Mocking done correctly (using `mockito` or `mocktail`)

**Overlap Resolution:** Test-engineer writes tests, NOT audit (that's code-quality-auditor)

---

### 5. Code Quality Auditor

**Invoked At:** `/implement-feature` - STEP 8 (Quality Audit) AND `/fix` - STEP 6 (Verify & Audit)

**Responsibilities:**

- Verify Clean Architecture rules followed
- Check code quality (maintainability, readability)
- Verify performance (no N+1 queries, proper pagination)
- Security: Check for common vulnerabilities
- Test coverage validation
- Linter compliance
- **NEW:** Identify defensive patterns (edge cases, error handling, null safety)
- **NEW:** Recommend defensive improvements for future resilience

**Input Contract:**

```json
{
  "source_code": "reference to lib/ folder",
  "tests": "reference to test/ folder",
  "implementation_report": { "coverage", "linter_warnings", "generated_files" }
}
```

**Output Contract:**

```json
{
  "architecture_score": 9.0,
  "code_quality_score": 8.5,
  "performance_score": 9.0,
  "security_score": 8.0,
  "test_coverage_score": 8.5,
  "defensive_patterns_score": 8.0,
  "overall_score": 8.6,
  "issues": [
    {
      "severity": "low",
      "category": "documentation",
      "message": "Add JSDoc for PhotoGalleryBLoC",
      "file": "lib/features/gallery/presentation/bloc/photo_gallery_bloc.dart",
      "line": 42
    }
  ],
  "violations": [
    {
      "severity": "high",
      "rule": "Clean Architecture - Domain must not depend on Data",
      "message": "Violation: ...",
      "file": "lib/features/gallery/domain/use_case.dart"
    }
  ],
  "defensive_recommendations": [
    {
      "pattern": "Add null coalescing for optional fields",
      "location": "lib/features/gallery/domain/entities/photo_entity.dart:15",
      "benefit": "Prevents runtime NPE in edge cases"
    }
  ],
  "pass": true
}
```

**Success Criteria:**

- ✅ Overall score ≥ 8.0/10
- ✅ No "high" or "critical" violations
- ✅ Test coverage ≥ 70%
- ✅ 0 linter warnings
- ✅ All architectural rules followed
- ✅ Defensive patterns documented (new)

**Overlap Resolution:**

- Code-quality-auditor does AUDIT/VERIFICATION, NOT implementation (vibecoder)
- Code-quality-auditor ≠ code-reviewer (reviewer is human, auditor is automated checks)
- **Consolidates:** offensive-coder responsibilities

---

### 6. Bug Investigator

**Invoked At:** `/fix` - STEP 1 (Investigation)

**Responsibilities:**

- Analyze crash logs / error messages
- Trace stack trace to root cause
- Identify affected layer (Presentation, Domain, Data)
- Determine affected files
- Provide root cause summary
- Identify reproduction steps

**Input Contract:**

```json
{
  "error_source": "crash_log | error_message | stacktrace",
  "error_content": "full error text",
  "context": { "when_happened", "how_to_reproduce", "affected_feature" }
}
```

**Output Contract:**

```json
{
  "error_type": "NullPointerException",
  "root_cause": "StreamController not disposed in _close() method",
  "confidence_score": 0.95,
  "severity": "high",
  "affected_layer": "presentation",
  "affected_files": [
    "lib/features/gallery/presentation/bloc/photo_gallery_bloc.dart"
  ],
  "stack_analysis": "Full trace analysis showing execution path",
  "reproduction_steps": "1. Open gallery\n2. Scroll to bottom\n3. Close page",
  "fix_complexity": "low|medium|high",
  "estimated_fix_time_minutes": 20
}
```

**Confidence Score Interpretation:**

- **0.9-1.0:** Auto-approved by /fix workflow (skip user approval)
- **0.75-0.89:** User approval required (show plan to user)
- **0.5-0.74:** Requires investigation review (ambiguous, needs discussion)
- **< 0.5:** Cannot continue (need more information)

**Success Criteria:**

- ✅ Root cause identified with confidence_score > 0.7
- ✅ Affected files listed (all entry points)
- ✅ Reproduction steps clear and testable
- ✅ Severity level justified
- ✅ Confidence score in output (triggers auto-approval if > 0.85)

**Overlap Resolution:** Bug-investigator does INVESTIGATION, NOT fixing (vibecoder fixes)

---

### 7. Security Auditor

**Invoked At:** Optional audit workflow (not in main path)

**Responsibilities:**

- Scan for common security vulnerabilities
- Check authentication/authorization
- Verify data encryption
- Check for data leaks
- Run SAST/vulnerability scanners

**Input Contract:**

```json
{
  "source_code": "reference to lib/ folder",
  "dependencies": "reference to pubspec.yaml"
}
```

**Output Contract:**

```json
{
  "vulnerabilities": [
    {
      "type": "CleartextTransmission",
      "severity": "critical",
      "description": "API call uses HTTP instead of HTTPS",
      "file": "lib/data/datasource/remote_photo_data_source.dart",
      "recommendation": "Use HTTPS for all network calls"
    }
  ],
  "dependency_scan": {
    "total_dependencies": 42,
    "outdated": 3,
    "vulnerable": 2
  },
  "pass": true
}
```

**Success Criteria:**

- ✅ No critical vulnerabilities
- ✅ No outdated high-risk dependencies
- ✅ Authentication properly implemented
- ✅ Data encryption in place where needed

---

### 8. Defensive Coder

**Invoked At:** Code review gates (optional, called by vibecoder for complex features)

**Responsibilities:**

- Identify edge cases not covered
- Add error handling patterns
- Add null-safety checks
- Add input validation
- Suggest resilience patterns

**Input Contract:**

```json
{
  "source_code": "proposed code",
  "feature_context": { "inputs", "outputs", "dependencies" }
}
```

**Output Contract:**

```json
{
  "edge_cases_found": [
    "Empty result list",
    "Network timeout",
    "Widget unmounted during async operation",
    "Invalid photo format"
  ],
  "defensive_patterns_needed": [
    "if (!context.mounted) return;",
    "try/catch with specific exception types",
    "Input validation for photo URLs"
  ],
  "suggested_code": "...",
  "risk_level": "medium"
}
```

**Success Criteria:**

- ✅ 3+ edge cases identified
- ✅ Suggested patterns follow codebase conventions
- ✅ Risk level assessment clear

---

### 9. Feature Architect

**Invoked At:** Optional: `/start-task` - STEP 3 (for complex features) OR `/implement-feature` - STEP 2

**Responsibilities:**

- Design major architectural features
- Plan system-wide changes
- Design integrations between features
- Performance optimization strategies
- Migration planning

**Input Contract:**

```json
{
  "complex_requirement": "string describing major architectural challenge",
  "codebase_state": "current architecture overview"
}
```

**Output Contract:**

```json
{
  "architectural_approach": "proposed solution",
  "components": ["component1", "component2"],
  "data_flow": "diagram or description",
  "migration_strategy": "how to integrate into existing system",
  "performance_considerations": "expected impact",
  "risks": ["risk1", "risk2"],
  "alternatives_considered": ["alt1", "alt2"]
}
```

**Success Criteria:**

- ✅ Approach is scalable
- ✅ Risks identified and mitigated
- ✅ Performance impact analyzed
- ✅ Integration points clear

---

### 10. Frontend Architect

**Invoked At:** Optional: `/implement-feature` - STEP 2 (for UI-heavy features)

**Responsibilities:**

- Design UI/UX architecture
- Define component hierarchy
- Plan state management for complex UIs
- Animation/performance optimization
- Accessibility considerations

**Input Contract:**

```json
{
  "ui_requirements": "description of UI needs",
  "design_mockup": "reference to Figma or design tool"
}
```

**Output Contract:**

```json
{
  "component_hierarchy": "tree structure of widgets",
  "state_management_plan": "BLoC structure and event flow",
  "animation_strategy": "animation points and performance",
  "responsive_design": "how different screen sizes handled",
  "accessibility_plan": "a11y considerations"
}
```

**Success Criteria:**

- ✅ Component hierarchy is clear
- ✅ State management not over-engineered
- ✅ Performance considerations addressed
- ✅ Accessibility requirements met

---

## When to Call Each Skill

### Skill Selection Flowchart

```
START: New task/fix needed
  │
  ├─ Is it a NEW FEATURE?
  │   ├─ YES → start-task workflow
  │   │   ├─ STEP 1-2: Call product-manager
  │   │   └─ STEP 3: Call tech-lead (+ optional feature-architect if complex)
  │   │
  │   └─ Is it implemented yet?
  │       ├─ NO → implement-feature workflow
  │       │   ├─ STEP 2: Call tech-lead (domain design)
  │       │   ├─ STEP 3-5: Call vibecoder (implementation)
  │       │   ├─ STEP 7: Call test-engineer (tests)
  │       │   └─ STEP 8: Call code-quality-auditor (audit)
  │       │
  │       └─ YES → review workflow
  │           └─ Manual code review required
  │
  ├─ Is it a BUG FIX?
  │   ├─ STEP 1: Call bug-investigator (investigation)
  │   ├─ STEP 4: Call vibecoder (fix implementation)
  │   ├─ STEP 5: Call test-engineer (regression tests)
  │   └─ STEP 6: Call code-quality-auditor (audit)
  │
  ├─ Is it a SECURITY AUDIT?
  │   └─ Call security-auditor
  │
  └─ Is it a MAJOR REFACTOR?
      └─ Call feature-architect + vibecoder
```

---

## Skill Invocation Rules (Hard Constraints)

### Rule 1: Sequential Dependency

```
product-manager (requirements refined)
    ↓ (uses output of)
tech-lead (architecture defined)
    ↓ (uses output of)
vibecoder (implementation provided)
    ↓ (uses output of)
test-engineer (tests provided)
    ↓ (uses output of)
code-quality-auditor (approval)
```

### Rule 2: Never Skip Approval Gates

- ❌ DO NOT skip code-quality-auditor in step 8
- ❌ DO NOT skip product-manager refinement in start-task
- ✅ DO wait for approval before proceeding

### Rule 3: Context Preservation

- ✅ Use same context object when calling multiple skills
- ✅ Preserve trace_id across all skill invocations
- ❌ DO NOT create new context after each skill

### Rule 4: Input Validation Before Invocation

```javascript
// Before calling code-quality-auditor
if (!implementation.tests.coverage_percent >= 70) {
  return "FAIL: Test coverage below 70%";
}
if (implementation.code_generation.build_runner_success !== true) {
  return "FAIL: Code generation failed";
}
// NOW safe to call code-quality-auditor
```

---

## Skill Overlap Resolution (Detailed)

### Issue 1: code-reviewer vs code-quality-auditor

**Status:** code-reviewer is DEPRECATED, consolidate into code-quality-auditor

**Reason:**

- code-reviewer (human review) is subjective
- code-quality-auditor (automated checks) is objective and consistent
- Both serve review function → consolidate
- Use code-quality-auditor for automated checks
- Use manual workflow step for human review (if needed)

**Action:** Remove code-reviewer skill from workflows, use code-quality-auditor instead

### Issue 2: vibecoder vs test-engineer vs code-quality-auditor

**Status:** Clear responsibility division - CONSOLIDATED

**vibecoder responsibility:** Base implementation with null-safety
**test-engineer responsibility:** Comprehensive test suite + edge cases
**code-quality-auditor responsibility:** Advanced defensive patterns + edge case audit (NEW - consolidated from defensive-coder)

**Solution:**

- Vibecoder writes defensive base code
- Test-engineer tests it thoroughly
- Code-quality-auditor reviews defensive patterns during STEP 8 audit

### Issue 3: tech-lead vs feature-architect

**Status:** Clear responsibility division

**tech-lead:** Standard feature architecture + DoR verification
**feature-architect:** Only for MAJOR/COMPLEX architectural decisions (scaling, migrations, integrations)

**Solution:** Use tech-lead by default, only call feature-architect for complexity scores > 8/10

### Issue 4: bug-investigator confidence scoring

**Status:** NEW - Confidence scoring enables auto-approval gates

**bug-investigator output:** Now includes confidence_score (0.0-1.0)
**Auto-approval trigger:** If confidence_score > 0.85 for /fix STEP 2-3, skip user approval

**Solution:**

- Bug-investigator provides confidence_score
- Orchestrator checks: IF confidence > 0.85 THEN auto-approve ELSE ask user
- Reduces /fix workflow time for high-confidence bugs

---

## Consolidation Recommendations

### Recommended Changes

**1. Archive/Deprecate** `code-reviewer`

- Function: Consolidate into `code-quality-auditor`
- Timeline: Immediate
- Action: Update all workflows to use code-quality-auditor

**2. Consolidate** `defensive-coder` → `code-quality-auditor`

- Function: Merge defensive pattern review into code-quality-auditor
- Responsibility: Code-quality-auditor now audits both code quality AND defensive patterns
- Timeline: Immediate
- Action: Update RESPONSIBILITY_MATRIX, update workflows, update SKILL_INTEGRATION guide
- Impact: 10 skills → 9 skills, cleaner matrix

**3. Optionalize** `feature-architect` and `frontend-architect`

- Keep for complex features only
- Add complexity score threshold (≥7/10)
- Don't call by default

---

## Quick Decision Tree (Copy-Paste for Workflows)

```yaml
# In workflow YAML metadata:
skill_invocation_rules:
  - rule: "If task is feature requirement refinement → call product-manager"
  - rule: "If task needs architectural design → call tech-lead"
  - rule: "If task is implementation → call vibecoder"
  - rule: "If task is test writing → call test-engineer"
  - rule: "If task is code audit → call code-quality-auditor"
  - rule: "If task is crash analysis → call bug-investigator"
  - rule: "If task is security check → call security-auditor (optional)"
  - rule: "If architectural complexity > 7/10 → call feature-architect (optional)"
  - rule: "If UI complexity > 7/10 → call frontend-architect (optional)"
```

---

## Integration with Orchestrator

**From ORCHESTRATOR.md:**

When orchestrator calls a workflow step:

1. ✅ Check if step has associated skill
2. ✅ Validate context has all required input fields
3. ✅ Load skill SKILL.md for detailed instructions
4. ✅ Pass context to skill
5. ✅ Capture skill output
6. ✅ Validate output against expected schema
7. ✅ Merge into context object
8. ✅ Continue to next step

```javascript
// Orchestrator logic (pseudocode)
const skill = load_skill(step.skill_name);
const skill_input = extract_input_from_context(context, step.input_fields);
const skill_output = skill.execute(skill_input);
const validated_output = validate_output(skill_output, step.output_schema);
context.merge(validated_output);
```

---

## Next Phase Integration

**PHASE 4 (Enrich Memory)** will use this matrix to:

- Add skill references to ARCHITECTURE.md
- Update PROJECT.md with skill descriptions
- Create SKILL_USAGE.md with examples

---

**Document Version:** 1.0.0  
**Last Updated:** 2026-03-09  
**Status:** Ready for Implementation
