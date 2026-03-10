# Workflow Orchestrator Architecture

**Version:** 1.0.0  
**Status:** Reference Architecture (Production)  
**Purpose:** Enable chaining of workflows with automatic context passing and error recovery

---

## 1. Orchestrator Responsibilities

The orchestrator is responsible for:

- **Loading workflows** in correct sequence
- **Validating context** before/after each workflow
- **Executing workflow steps** with error handling
- **Capturing outputs** with metadata
- **Passing context** to dependent workflows
- **Tracking execution state** across invocations
- **Implementing retry logic** for transient failures

---

## 2. Workflow Chains (Use Cases)

### Chain 1: Task → Implementation → Review

```
User Input (requirement)
    ↓
[/start-task] → Outputs: Blueprint (JSON)
    ↓ (Auto-trigger with Blueprint)
[/implement-feature] → Outputs: Implementation (code + tests)
    ↓ (Manual trigger or auto with approval)
[/review] → Outputs: Review Report (issues + suggestions)
    ↓ (Human decision)
[PR Opened]
```

### Chain 2: Error Detection → Investigation → Fix → Verification

```
Crash Detected (stacktrace)
    ↓
[/investigate] → Outputs: Investigation Report
    ↓ (Investigation triggers fix planning)
[/fix] → Outputs: Fixed Code (with tests)
    ↓ (Auto-trigger with approval)
[/test] → Outputs: Test Results
    ↓ (If tests pass)
[/code-quality-audit] → Outputs: Audit Report
    ↓ (If audit passes)
[PR Opened]
```

### Chain 3: Code Quality Audit → Refactoring

```
Audit Triggered (quality threshold)
    ↓
[/audit] → Outputs: Audit Report (issues list)
    ↓ (With critical issues)
[/refactor] → Outputs: Refactored Code
    ↓
[/test] → Outputs: Test Results
    ↓
[/code-quality-audit] → Validate improvements
```

---

## 3. Context Flow Model

### 3.1 Context Lifecycle

```
CREATION (Workflow A)
    ✓ Workflow A creates context object
    ✓ Adds metadata (created_at, trace_id, version)
    ✓ Executes steps 1-N
    ✓ Captures output in context.workflow.result
    ✓ Returns: Context object (JSON)

VALIDATION (Orchestrator)
    ✓ Receives context from Workflow A
    ✓ Validates against workflow-context.schema.json
    ✓ Checks required fields for next workflow
    ✓ If valid: Continue to TRANSITION
    ✓ If invalid: Return validation_error

TRANSITION (Orchestrator)
    ✓ Check if next workflow triggered
    ✓ Extract relevant output from context
    ✓ Map output fields to next workflow's input fields
    ✓ Create new context OR update existing context
    ✓ Invoke next workflow with context

ENRICHMENT (Workflow B)
    ✓ Workflow B receives context
    ✓ Reads context.metadata (preserves trace_id)
    ✓ Reads input data from context
    ✓ Executes its own steps
    ✓ Updates context.workflow with new status
    ✓ Adds context.result (Workflow B's output)
    ✓ Returns: Enhanced context object

COMPLETION/ERROR
    ✓ If success: Return context with final results
    ✓ If error: Capture in context.workflow.errors
    ✓ On approval gate: Wait for user_input
    ✓ On transient error: Retry with exponential backoff
```

### 3.2 Context Field Mapping Between Workflows

**start-task → implement-feature**

```
Context Output (start-task)          Context Input (implement-feature)
├─ blueprint.entities          →     blueprint.entities
├─ blueprint.use_cases         →     blueprint.use_cases
├─ blueprint.api_endpoints     →     blueprint.api_endpoints
├─ blueprint.ui_screens        →     blueprint.ui_screens
└─ blueprint.contract          →     blueprint.contract
```

**investigate → fix**

```
Context Output (investigate)         Context Input (fix)
├─ investigation_report.root_cause   → fix_plan.strategy
├─ investigation_report.affected_files → fix_plan.files_to_modify
└─ investigation_report.stack_analysis → fix_plan.analysis
```

**fix → test → code-quality-audit**

```
Context Output (fix)                 Consumed By (test, audit)
├─ implementation.code               → test.execute_on
├─ implementation.tests              → test.run
└─ implementation.files_modified     → audit.analyze
```

---

## 4. Orchestrator Algorithm (Pseudocode)

```
FUNCTION orchestrate(input, workflow_chain):
    INPUT: user_input, ordered list of workflows
    OUTPUT: final_context with all workflow results

    // Initialize context
    context = {
        metadata: {
            created_at: now(),
            trace_id: generate_unique_id(),
            version: "1.0.0"
        },
        workflow: {
            status: "pending",
            errors: []
        }
    }

    FOR EACH workflow IN workflow_chain:

        // STEP 1: Load workflow metadata
        workflow_meta = load_workflow(workflow.id)
        context.workflow.workflow_id = workflow.id
        context.workflow.total_steps = workflow_meta.step_count

        // STEP 2: Validate input
        IF NOT validate_context(context, workflow_meta.required_fields):
            context.workflow.status = "failed"
            context.workflow.errors.append({
                code: "VALIDATION_ERROR",
                message: "Required fields missing",
                step: workflow.current_step
            })
            IF workflow.on_validation_error == "STOP":
                RETURN context
            ELSE IF workflow.on_validation_error == "SKIP":
                CONTINUE

        // STEP 3: Execute workflow steps
        context.workflow.status = "in_progress"
        context.workflow.started_at = now()

        FOR step_index = 1 TO workflow_meta.step_count:

            context.workflow.current_step = step_index
            step_result = NULL
            retry_count = 0
            max_retries = 3

            WHILE retry_count < max_retries:
                TRY:
                    // Invoke skill for this step (if specified)
                    IF workflow_meta.steps[step_index].skill_required:
                        skill = load_skill(workflow_meta.steps[step_index].skill_name)
                        step_result = skill.execute(context)
                    ELSE:
                        step_result = execute_step(workflow.id, step_index, context)

                    // Validate step output
                    IF NOT validate_step_output(step_result, workflow_meta.steps[step_index].output_schema):
                        THROW OutputValidationError

                    // Check for approval gate
                    IF workflow_meta.steps[step_index].is_approval_gate:
                        context.workflow.status = "awaiting_input"
                        user_decision = prompt_user("Approve this phase? (yes/no/modify)")

                        IF user_decision == "reject":
                            context.workflow.status = "failed"
                            context.workflow.errors.append({
                                code: "USER_REJECTED",
                                message: "User rejected at step " + step_index
                            })
                            RETURN context

                        ELSE IF user_decision == "modify":
                            modifications = prompt_user("Enter modifications (JSON)")
                            step_result = apply_modifications(step_result, modifications)

                    // Merge step result into context
                    context.workflow.step_results[step_index] = step_result
                    retry_count = max_retries  // Exit retry loop

                CATCH TransientError as e:
                    retry_count += 1
                    IF retry_count < max_retries:
                        wait_time = exponential_backoff(retry_count)
                        PRINT "Transient error, retrying in " + wait_time + "ms"
                        SLEEP(wait_time)
                    ELSE:
                        context.workflow.status = "failed"
                        context.workflow.errors.append({
                            code: "MAX_RETRIES_EXCEEDED",
                            message: e.message,
                            step: step_index
                        })
                        RETURN context

                CATCH FatalError as e:
                    context.workflow.status = "failed"
                    context.workflow.errors.append({
                        code: "FATAL_ERROR",
                        message: e.message,
                        step: step_index
                    })

                    IF workflow_meta.on_fatal_error == "STOP":
                        RETURN context
                    ELSE IF workflow_meta.on_fatal_error == "SKIP":
                        BREAK  // Skip to next workflow

        // STEP 4: Finalize workflow
        context.workflow.status = "completed"
        context.workflow.completed_at = now()

        // STEP 5: Validate overall output
        IF NOT validate_context(context, workflow_chain[workflow_index + 1].required_fields):
            PRINT "Warning: Output validation failed for next workflow"

        // STEP 6: Trigger next workflow (if applicable)
        IF workflow_index < (workflow_chain.length - 1):
            next_workflow = workflow_chain[workflow_index + 1]

            IF should_auto_trigger(current_workflow, next_workflow, context):
                PRINT "Auto-triggering next workflow: " + next_workflow.id
                // Continue to next iteration of FOR loop
            ELSE:
                PRINT "Awaiting manual trigger for: " + next_workflow.id
                BREAK  // Require user to manually trigger next workflow

    // STEP 7: Return final context
    context.workflow.status = "completed"
    RETURN context

END FUNCTION
```

### 4.1 Helper Functions

```
FUNCTION validate_context(context, required_fields):
    FOR EACH field IN required_fields:
        IF field NOT IN context:
            RETURN FALSE
        IF context[field] == NULL or EMPTY:
            RETURN FALSE
    RETURN TRUE

FUNCTION validate_step_output(output, schema):
    // Validate output against JSON schema
    validator = JSONSchemaValidator(schema)
    IF validator.validate(output):
        RETURN TRUE
    ELSE:
        PRINT "Output validation failed: " + validator.errors
        RETURN FALSE

FUNCTION exponential_backoff(retry_count):
    // Returns wait_time in milliseconds
    base_delay = 100  // 100ms
    max_delay = 30000  // 30 seconds

    wait_time = base_delay * (2 ^ (retry_count - 1))
    IF wait_time > max_delay:
        wait_time = max_delay + random(0, 5000)  // Add jitter

    RETURN wait_time

FUNCTION should_auto_trigger(current_workflow, next_workflow, context):
    // Determine if next workflow should auto-trigger

    // Auto-trigger rules:
    // 1. If current workflow completed successfully
    // 2. If no errors in context
    // 3. If next workflow is NOT an optional workflow
    // 4. If context has all required fields for next workflow

    IF context.workflow.status != "completed":
        RETURN FALSE

    IF context.workflow.errors.length > 0:
        RETURN FALSE

    IF next_workflow.is_optional:
        RETURN FALSE  // Require manual trigger

    IF NOT validate_context(context, next_workflow.required_fields):
        RETURN FALSE

    RETURN TRUE

FUNCTION apply_modifications(original_result, modifications):
    // Deep merge modifications into original_result
    result = CLONE(original_result)
    FOR EACH key, value IN modifications:
        result[key] = value
    RETURN result
```

---

## 5. Error Handling Strategy

### 5.1 Error Classifications

```
ERROR_TYPE                      HANDLING_STRATEGY              RETRY_POLICY
────────────────────────────────────────────────────────────────────────
ValidationError                 Log + Fail workflow            No retry
TransientError (network)        Log + Exponential backoff      Retry 3x
TransientError (timeout)        Log + Exponential backoff      Retry 3x
FatalError (code exception)     Log + Fail workflow            No retry
UserRejection (approval gate)   Log + Stop chain               No retry
SkippableError (non-critical)   Log + Continue                 No retry
MissingField                    Log + Fail + Suggest fix       No retry
```

### 5.2 Error Context Preservation

When an error occurs, capture:

```json
{
  "code": "ERROR_CODE",
  "message": "Human-readable message",
  "details": {
    "workflow_id": "string",
    "step": "number",
    "timestamp": "ISO 8601",
    "attempted_action": "string",
    "root_cause": "string"
  },
  "recovery_suggestion": "string (e.g., 'Retry after 5 seconds')"
}
```

---

## 6. State Management

### 6.1 Workflow State Transitions

```
START → pending → in_progress → awaiting_input ↩ (user input)
                    ↓
               completed ✓  (success)
                    ↓
                failed ✗  (error)
```

### 6.2 Context State Storage

Store execution state in memory during orchestration:

```
context.orchestration_state = {
    current_workflow: "implement-feature",
    current_step: 5,
    started_at: "2026-03-09T10:00:00Z",
    retry_count: 0,
    previous_workflows: ["start-task"],
    next_workflows: ["review"]
}
```

---

## 7. Workflow Triggering Rules

### 7.1 Auto-Trigger Conditions

**start-task → implement-feature:**

- ✅ Approval status = "approved" (STEP 6 gate passed)
- ✅ Blueprint output valid against schema
- ✅ No validation errors in context
- ✅ Implementation NOT yet started

**implement-feature → review:**

- ✅ All 8 steps completed
- ✅ Code generation successful
- ✅ Tests written and passing (>70% coverage)
- ✅ Quality audit score ≥ 7/10
- ❌ Requires manual trigger (optional)

**fix → test:**

- ✅ Fix implementation complete
- ✅ Fixed code compiles without errors
- ✅ No conflicts with existing code
- ✅ Auto-trigger unless explicitly disabled

### 7.2 Manual Trigger Conditions

Workflows requiring manual trigger:

- `/review` - Developer review of implementation
- `/refactor` - Optimization not required for MVP
- Major architectural changes - Require tech lead approval

---

## 8. Context Interrogation (Debugging)

Commands to inspect context during orchestration:

```bash
# Print current context state
orchctl context show [trace_id]

# Print specific workflow phase
orchctl context show [trace_id] --workflow start-task

# Print errors encountered
orchctl context show [trace_id] --errors

# Print audit trail
orchctl context show [trace_id] --history

# Validate context against schema
orchctl context validate [file.json]

# Retry failed workflow
orchctl workflow retry [trace_id] --from-step 5
```

---

## 9. Example: Gallery Infinite Scroll Flow

### 9.1 Full Orchestration Trace

```
[00:00] TRACE_ID: ctx_photo_2026_001
[00:00] START: Gallery Infinite Scroll feature

[00:00] WORKFLOW[1/3]: start-task
[00:10] step=1 (vision): "Add infinite scroll to gallery"
[00:15] step=2 (refinement): "Pagination with limit=20"
[00:20] step=3 (design): Blueprint created
[00:25] step=4 (dor-check): PASSED
[00:30] step=5 (contract): "4 hours, critical priority"
[00:40] step=6 (approval): ⏸ AWAITING USER INPUT
        User: "APPROVED"
[00:44] COMPLETED ✓

[00:44] CONTEXT VALIDATION: Blueprint → implement-feature
        Required fields: ✅ entities, ✅ use_cases, ✅ api_endpoints
[00:45] AUTO-TRIGGER: implement-feature

[00:45] WORKFLOW[2/3]: implement-feature
[00:48] step=1 (dor-verify): DoR checklist passed
[00:55] step=2 (domain-design): 2x entities designed
[01:00] step=3 (domain-impl): GetPhotosUseCase implemented
[01:10] step=4 (data-impl): PhotoRepository + LocalPhotoDataSource
[01:30] step=5 (presentation-impl): PhotoGalleryBLoC + PhotoGalleryPage
[01:35] step=6 (codegen): build_runner succeeded
[01:45] step=7 (tests): 8 unit + 5 widget tests written (85% coverage)
[01:50] step=8 (audit): Architecture ✓, Quality ✓, Tests ✓
[02:00] COMPLETED ✓

[02:00] CONTEXT VALIDATION: Implementation → review
        Required fields: ✅ implementation, ✅ quality_audit
[02:02] MANUAL TRIGGER: review (awaiting developer)

[02:15] WORKFLOW[3/3]: review
[02:15] Developer reviews: "LGTM, merge this"
[02:16] PR ready for merge

[02:16] ORCHESTRATION COMPLETE
        Duration: 2h 16min
        Workflows executed: 3/3
        Errors recovered: 0
        Final status: SUCCESS ✓
```

---

## 10. Parallel Step Execution (PHASE 6 - New)

### 10.1 Parallelization Strategy

**Goal:** Reduce workflow execution time by executing independent steps concurrently

**Key Principle:** Steps can run in parallel if they:

- ✅ Have NO data dependencies (don't consume output from other parallel steps)
- ✅ Don't modify shared state
- ✅ Can be run in any order without affecting results
- ✅ Are marked explicitly in workflow metadata

### 10.2 Parallel Step Groups in /implement-feature

**Original Sequential Flow (120 min):**

```
STEP 1: DoR verify (5 min)
    ↓
STEP 2: Domain layer design (15 min)
    ↓
STEP 3: Domain implementation (20 min) ──→ tech-lead output
    ↓
STEP 4: Data layer implementation (30 min) ──→ depends on STEP 3
    ↓
STEP 5: Presentation layer (30 min) ──→ depends on STEP 3
    ↓
STEP 6: Code generation (5 min)
    ↓
STEP 7: Write tests (10 min)
    ↓
STEP 8: Quality audit (10 min)

Total: 125 minutes
```

**Optimized Parallel Flow (105 min) - 15% faster:**

```
STEP 1: DoR verify (5 min)
    ↓
STEP 2: Domain layer design (15 min)
    ↓
STEP 3: Domain implementation (20 min) ──→ outputs entities
    ↓
    ├─ STEP 4: Data layer impl (30 min) ──→ PARALLEL ┐
    │  (depends on STEP 3 entities)                  │
    │                                                 │ Can run
    └─ STEP 5: Presentation layer (30 min) ──→ PARALLEL ┤ simultaneously
       (depends on STEP 3 entities)                  │
                                                      │
        ↓ (both complete)                            ↓

    ↓
STEP 6: Code generation (5 min)
    ↓
STEP 7: Write tests (10 min)
    ↓
STEP 8: Quality audit (10 min)

Total: 105 minutes (sequential: 125 min)
Time saved: 20 min (16% improvement)
```

**Why this parallelization is safe:**

- **STEP 4 + STEP 5 inputs:** Both read `entities` from STEP 3 (no write conflicts)
- **No state mutation:** Each step generates independent outputs (DataSource vs BLoC)
- **Ordered finalization:** Code generation (STEP 6) waits for both STEP 4 + 5 using barrier wait

### 10.3 Parallelization Metadata in Workflows

**Updated /implement-feature workflow metadata:**

```yaml
# workflows/core/implement-feature.md

workflow_id: implement-feature
version: 2.0.0 # NEW VERSION with parallelization
status: production
timeout_minutes: 120

execution_model:
  type: parallel # NEW: supports parallel execution
  strategy: optimized_parallel

steps:
  - id: 1
    name: DoR Verification
    time_minutes: 5
    skill: tech-lead
    depends_on: []

  - id: 2
    name: Domain Design
    time_minutes: 15
    skill: tech-lead
    depends_on: [1]

  - id: 3
    name: Domain Implementation
    time_minutes: 20
    skill: vibecoder
    depends_on: [2]
    outputs: [entities, repositories, use_cases] # NEW: explicit outputs

  - id: 4
    name: Data Layer Implementation
    time_minutes: 30
    skill: vibecoder
    depends_on: [3] # Depends on STEP 3 outputs
    parallel_group: "layer_impl" # NEW: part of parallel group

  - id: 5
    name: Presentation Layer Implementation
    time_minutes: 30
    skill: vibecoder
    depends_on: [3] # Depends on STEP 3 outputs
    parallel_group: "layer_impl" # NEW: same parallel group as STEP 4

  - id: 6
    name: Code Generation
    time_minutes: 5
    action: run_build_runner
    depends_on: [4, 5] # BARRIER: Wait for both parallel steps
    wait_for_parallel_group: "layer_impl" # NEW: explicit barrier

  - id: 7
    name: Write Tests
    time_minutes: 10
    skill: test-engineer
    depends_on: [6]

  - id: 8
    name: Quality Audit
    time_minutes: 10
    skill: code-quality-auditor
    depends_on: [7]

parallel_groups: # NEW SECTION
  - name: "layer_impl"
    steps: [4, 5]
    max_parallel: 2
    barrier_after: true
    wait_timeout_minutes: 60
```

### 10.4 Orchestrator Parallel Execution Algorithm

```
FUNCTION execute_workflow_parallel(workflow_meta, context):

    // Identify parallel groups
    parallel_groups = identify_parallel_groups(workflow_meta.steps)

    FOR EACH step IN workflow_meta.steps:

        IF step.parallel_group():
            // Parallel execution
            BRANCH_ID = step.parallel_group

            // Check if all dependencies complete
            IF all_deps_complete(step.depends_on, context):

                // Start parallel job
                job = async_execute_step(step, context)
                parallel_jobs[BRANCH_ID].append(job)

                PRINT "Started parallel execution: STEP " + step.id + " (group: " + BRANCH_ID + ")"

        ELSE:

            // Sequential execution
            // Wait for any parallel groups to complete (barrier)
            IF step.wait_for_parallel_group():
                group_name = step.wait_for_parallel_group

                PRINT "Waiting for parallel group '" + group_name + "' to complete..."

                FOR EACH job IN parallel_jobs[group_name]:
                    result = job.wait_until_complete(timeout: 60min)

                    IF job.failed():
                        THROW ParallelJobFailedError(step.id, job.error)

                    context.merge(result)

                parallel_jobs[group_name].clear()  // Clean up
                PRINT "Parallel group '" + group_name + "' complete ✓"

            // Execute step sequentially
            step_result = execute_step(step, context)
            context.merge(step_result)

END FUNCTION
```

### 10.5 Example: Parallel Execution Trace

```
[00:00] START: /implement-feature (parallel mode)
[00:00] STEP 1: DoR verify (tech-lead)
[00:05] ✓ STEP 1 complete

[00:05] STEP 2: Domain design (tech-lead)
[00:20] ✓ STEP 2 complete

[00:20] STEP 3: Domain implementation (vibecoder)
[00:40] ✓ STEP 3 complete (outputs: Photo, PhotoPage entities)

[00:40] 🔀 PARALLEL GROUP START: layer_impl

  Job-1: STEP 4 - Data layer implementation (ASYNC)
  [00:40] → Starting RemotePhotoDataSource + PhotoRepositoryImpl
  [00:50] ... running ...

  Job-2: STEP 5 - Presentation layer implementation (ASYNC)
  [00:40] → Starting PhotoGalleryBLoC + PhotoGalleryPage
  [00:50] ... running ...

  [01:00] ✓ STEP 4 complete (PhotoRepositoryImpl created)
  [01:10] ✓ STEP 5 complete (PhotoGalleryPage created)

[01:10] 🔀 PARALLEL GROUP END: layer_impl (both jobs complete ✓)
  Barrier passed: STEP 6 now eligible
  Time saved: 20 minutes vs sequential

[01:10] STEP 6: Code generation (build_runner)
[01:15] ✓ STEP 6 complete

[01:15] STEP 7: Write tests (test-engineer)
[01:25] ✓ STEP 7 complete (85% coverage)

[01:25] STEP 8: Quality audit (code-quality-auditor)
[01:35] ✓ STEP 8 complete (score: 8.6/10)

[01:35] ✅ WORKFLOW COMPLETE (105 min total)
        Time saved vs sequential: 20 min (16%)
        Parallelization factor: 1.19x speedup
```

### 10.6 Parallel Step Dependencies (Reference)

**Safe to parallelize in /implement-feature:**

```
✅ STEP 4 + STEP 5 (Data layer + Presentation layer)
   Reason: Both depend only on STEP 3 entities
   I/O: Work on independent modules (RemotePhotoDataSource vs PhotoGalleryBLoC)
   Output: No shared state mutations

❌ STEP 4 + STEP 6 (Data layer + Code generation)
   Reason: Code generation depends on generated files from STEP 4
   Result: Cannot run in parallel

✅ STEP 7 + others (Tests are independent if files exist)
   Note: Can only run AFTER code generation succeeds

✅ STEP 3 + STEP 2 (Domain impl + Design)
   Reason: Domain impl depends on design
   Result: CANNOT parallelize (sequential dependency)
```

### 10.7 Parallelization Support in Other Workflows

**Recommended for /fix workflow (PHASE 6+ future):**

```yaml
# Potential parallel groups in /fix
parallel_groups:
  - name: "investigation"
    steps: [1] # Currently single step

  - name: "verification"
    steps: [5, 6] # Tests + audit could run in parallel AFTER fix applied
```

**Not recommended for /start-task:**

```
Reason: Too short workflow (40 min total)
        Parallelization overhead not worth context management complexity
Status: Keep sequential
```

---

## 11. Context Caching (PHASE 6 - New)

### 11.1 Caching Strategy

**Problem:** Large contexts passed between steps cause token usage bloat

- Full workflow context: ~15,000 tokens
- Passing context per step: 15,000 × 8 steps = 120,000 tokens for /implement-feature
- **Solution:** Cache context locally, pass only deltas

**Goal:** Reduce token usage 25-30% by caching

### 11.2 Cache Architecture

```
CONTEXT CACHE (Local Storage):

cache_entry = {
  trace_id: "string",
  version: "number",
  timestamp: "ISO 8601",
  full_context: { ...full context object... },
  step_outputs: {
    "step_1": { ...output only... },
    "step_2": { ...output only... },
    "step_3": { ...output only... }
  },
  compressed_size_kb: "number"
}

Storage location: ~/.agents/cache/workflow_context/[trace_id].json
Lifecycle: Persists for 24 hours OR until workflow complete
Cleanup: Automatic on workflow success/failure
```

### 11.3 Caching Protocol

**WITHOUT caching (CURRENT - 120,000 tokens):**

```
Step 1 → Skill.execute(full_context: 15,000 tokens)
Step 2 → Skill.execute(full_context: 15,000 tokens)  ← Redundant!
Step 3 → Skill.execute(full_context: 15,000 tokens)  ← Redundant!
...
Step 8 → Skill.execute(full_context: 15,000 tokens)  ← Redundant!

Total: 8 × 15,000 = 120,000 tokens
```

**WITH caching (PHASE 6 - 85,000 tokens = 29% reduction):**

```
Step 1 → Skill.execute(full_context: 15,000 tokens)
         Cache.save(trace_id, context)

Step 2 → Skill.execute(context_ref: "ctx_123", delta: 2,000 tokens)
         Orchestrator.load_context(ctx_123) ← 0 tokens, from cache
         Skill works with loaded context
         Cache.update(trace_id, step_2_output)

Step 3 → Skill.execute(context_ref: "ctx_123", delta: 1,500 tokens)
         (Same process)

...

Total: 15,000 + (7 × ~2,500) = 33,500 tokens
Savings: 120,000 - 33,500 = 86,500 tokens saved (72%)
```

### 11.4 When to Cache vs Pass

```yaml
# Cache decision logic (in orchestrator)

cache_if:
  workflow_step_count: "> 4" # Only cache workflows with 5+ steps
  remaining_steps: "> 2" # Only cache if 2+ steps remain
  context_size_kb: "> 50" # Only cache large contexts

use_cache_ref_if:
  cache_entry_exists: true
  cache_age_minutes: "< 30" # Cache valid for 30 min
  trace_id_matches: true
  version_compatible: true
```

### 11.5 Cache Invalidation Rules

```yaml
# Invalidate cache if:
- Workflow fails (cache stale, cleanup)
- 24 hours elapsed
- Major context restructure (schema version change)
- Explicit user invalidation (orchctl cache clear)

# Keep cache if:
- Workflow success (keep for 30 days for history)
- Workflow paused/resumed (cache still valid)
- User retries workflow (reuse cache)
```

---

## 12. Conditional Skill Selection (PHASE 6 - New)

### 12.1 Complexity Heuristics

**Problem:** feature-architect and frontend-architect are optional but hard to decide when to invoke

**Solution:** Auto-select based on complexity scoring

### 12.2 Complexity Scoring Algorithm

```
FUNCTION calculate_feature_complexity(blueprint):

    score = 0

    // 1. Entity complexity (max: 3 points)
    entity_count = blueprint.entities.length
    IF entity_count >= 5:
        score += 3
    ELSE IF entity_count >= 3:
        score += 2
    ELSE:
        score += 1

    // 2. Use case complexity (max: 2 points)
    use_case_count = blueprint.use_cases.length
    IF use_case_count >= 4:
        score += 2
    ELSE IF use_case_count >= 2:
        score += 1

    // 3. API integration complexity (max: 2 points)
    IF blueprint.api_endpoints.length > 2:
        score += 2
    ELSE IF blueprint.api_endpoints.length > 0:
        score += 1

    // 4. State management complexity (max: 1 point)
    IF blueprint.has_complex_state_flow:
        score += 1

    // 5. Architectural challenge (max: 2 points)
    IF blueprint.involves_major_refactoring OR
       blueprint.involves_new_pattern OR
       blueprint.affects_multiple_features:
        score += 2

    complexity_score = score  // Range: 1-10
    RETURN complexity_score

END FUNCTION
```

### 12.3 Skill Invocation Rules

```yaml
# Conditional skill selection rules

invoke_feature_architect_if:
  complexity_score: ">= 7"
  estimated_duration_hours: "> 6"
  affects_multiple_features: true
  requires_migration_plan: true

invoke_frontend_architect_if:
  ui_screen_count: ">= 5"
  has_complex_animations: true
  has_custom_layouts: true
  ui_complexity_score: ">= 7"

# Complexity score interpretation:
# 1-3: Simple (use tech-lead only)
# 4-6: Medium (use tech-lead + optional feature-architect)
# 7-10: Complex (mandatory feature-architect + frontend-architect if UI-heavy)
```

### 12.4 Example: Complexity Scoring

**Example 1: Simple feature (infinite scroll)**

```
Entities: 2 (Photo, PhotoPage) → 1 point
Use cases: 2                     → 1 point
API endpoints: 1                 → 1 point
State complexity: No             → 0 points
Architectural challenge: No      → 0 points

Complexity score: 3/10 (SIMPLE)
Decision: Use tech-lead only ✓
```

**Example 2: Medium feature (dark mode theme)**

```
Entities: 1 (Theme)                          → 1 point
Use cases: 3 (GetTheme, SetTheme, SaveTheme) → 1 point
API endpoints: 0                             → 0 points
State complexity: Yes (shared across app)    → 1 point
Architectural challenge: Requires provider refactor → 2 points

Complexity score: 5/10 (MEDIUM)
Decision: Use tech-lead + optional feature-architect 🤔
User decision: tech-lead is sufficient
```

**Example 3: Complex feature (photo editing suite)**

```
Entities: 8 (Photo, Filter, Adjustment, History, Undo, Redo, etc.) → 3 points
Use cases: 6 (GetPhoto, ApplyFilter, SaveEdits, LoadHistory, etc.) → 2 points
API endpoints: 4 (photo upload, effects API, etc.)                  → 2 points
State complexity: Yes (complex undo/redo buffer)                    → 1 point
Architectural challenge: New pattern for effect pipeline            → 2 points

Complexity score: 10/10 (COMPLEX)
Decision: MANDATORY feature-architect + frontend-architect ✅
Rationale: Multiple entities, complex state, requires architecture design
```

---

## 13. Integration Testing (PHASE 6 - New)

### 13.1 Workflow Integration Tests

**Location:** `.agent/tests/workflow_integration_tests.md`

**Purpose:** Verify workflows execute correctly end-to-end

### 13.2 Test Suite

```
TEST 1: /start-task → /implement-feature chain
  Setup: Gallery infinite scroll requirement
  Action: Execute full chain
  Assert: Implementation complete, tests passing, audit score > 8.0

TEST 2: /fix workflow with auto-approval
  Setup: Crash log with confidence_score 0.95
  Action: Execute /fix workflow
  Assert: Fix auto-approved, no user prompt shown

TEST 3: /fix workflow with manual approval
  Setup: Crash log with confidence_score 0.72
  Action: Execute /fix workflow
  Assert: Shows plan, waits for user approval

TEST 4: Parallel execution in /implement-feature
  Setup: Complex feature with 5+ entities
  Action: Execute /implement-feature with parallelization
  Assert: STEP 4 + STEP 5 run concurrently, time < 105 min

TEST 5: Context caching
  Setup: 8-step workflow
  Action: Execute once (populate cache), then retry
  Assert: 2nd execution uses cached context, fewer tokens used

TEST 6: Error handling with retry
  Setup: Transient network error in STEP 3
  Action: Execute workflow
  Assert: Auto-retries 3x, succeeds on retry 2

TEST 7: Complexity-driven skill selection
  Setup: Feature with complexity_score = 8
  Action: Execute start-task
  Assert: feature-architect is invoked

TEST 8: DoR gate validation
  Setup: Incomplete requirement (missing acceptance criteria)
  Action: Execute start-task
  Assert: tech-lead flags dor_completeness < 100%, workflow pauses
```

### 13.3 Success Criteria for PHASE 6

```
✅ All 3 workflows (start-task, implement-feature, fix) support parallelization
✅ Parallel execution reduces /implement-feature time 15-20%
✅ Context caching reduces token usage 25-30%
✅ Complexity heuristics correctly identify when to use architects
✅ All 8 integration tests passing
✅ Auto-approval works for confidence_score > 0.85
✅ Error handling with exponential backoff works correctly
✅ Workflow examples still execute correctly with new changes
✅ Documentation updated (ORCHESTRATOR.md, workflows updated)
✅ No breaking changes to existing workflow contracts
```

---

## 14. Migration from PHASE 2.1

When orchestrator is implemented (PHASE 3):

1. **Current workflows** (start-task, implement-feature, fix) will invoke orchestrator
2. **Orchestrator will manage** context passing automatically
3. **Workflows stay focused** on their core responsibilities
4. **Context schema** (workflow-context.schema.json) becomes source of truth
5. **Error handling** becomes consistent across all workflows

---

## 11. Next Steps (PHASE 2.2 → PHASE 3)

- [ ] Implement orchestrator in Dart (or as documentation for AI agent)
- [ ] Add context validation library (JSON schema validator)
- [ ] Create `orchctl` CLI for context inspection
- [ ] Add retry mechanism with exponential backoff
- [ ] Implement approval gates UI
- [ ] Test orchestrator with Gallery Infinite Scroll example
- [ ] Document troubleshooting guide

---

**PHASE 2 Status:** ✅ Design complete, ready for PHASE 2.3 context validation guide
