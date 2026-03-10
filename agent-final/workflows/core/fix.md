---
description: "Systematic bug fix workflow: Investigate root cause → Design fix plan → Implement → Test → Verify. Invokes bug-investigator & vibecoder skills with Clean Architecture enforcement."
trigger: /fix
version: "6.0.0"
skills:
  - bug-investigator
  - vibecoder
  - test-engineer
  - code-quality-auditor
constraints:
  max_iterations: 1
  timeout_minutes: 60
  exit_on:
    [
      "Fix verified and tests pass",
      "User rejected plan",
      "Investigation failed",
    ]
  auto_approval_gate: "confidence_score > 0.85"
skill: bug-investigator
---

# 🔧 Systematic Bug Fix Workflow

**Objective:** Root cause bug fixes instead of temporary patches, enforcing Clean Architecture rules.

**Status:** Production-ready (v6.0.0)

---

## 📊 Execution Flow Overview

```
┌─────────────────────────────────────────────────────────────┐
│ INPUT: crashlog OR error message OR "thing is broken"       │
└────────────────────┬────────────────────────────────────────┘
                     │
          ┌──────────▼──────────┐
          │ STEP 1: INVESTIGATE │ (5-10 min)
          │ Invoke bug-inv...  │
          └──────────┬──────────┘
                     │
            ┌────────▼────────┐
            │ STEP 2: PLAN    │ (5 min)
            │ Strategy design │
            └────────┬────────┘
                     │
            ┌────────▼─────────────┐
            │ STEP 3: DESIGN CHECK │ (Ask user approve plan)
            │ ✏️ Wait user "OK"    │
            └────────┬─────────────┘
                     │
      ┌──────────────▼──────────────┐
      │ STEP 4: IMPLEMENT FIX       │ (10-20 min)
      │ Invoke vibecoder skill      │
      └──────────┬──────────────────┘
                 │
    ┌────────────▼─────────────┐
    │ STEP 5: GENERATE TESTS   │ (10-15 min)
    │ Invoke test-engineer     │
    └────────────┬─────────────┘
                 │
  ┌──────────────▼──────────────┐
  │ STEP 6: VERIFY & AUDIT      │ (5-10 min)
  │ Run tests + code-quality    │
  └──────────┬───────────────────┘
             │
    ┌────────▼────────┐
    │ OUTPUT: PR Ready │
    └─────────────────┘
```

---

## 📥 Input Schema

```json
{
  "type": "object",
  "required": ["error_source"],
  "properties": {
    "error_source": {
      "type": "string",
      "description": "One of: stacktrace | crash_log | error_message | feature_broken | user_description",
      "enum": [
        "stacktrace",
        "crash_log",
        "error_message",
        "feature_broken",
        "user_description"
      ]
    },
    "error_content": {
      "type": "string",
      "description": "Full stacktrace or error details (5-500 lines)"
    },
    "context": {
      "type": "object",
      "properties": {
        "affected_feature": { "type": "string", "example": "gallery" },
        "affected_file": {
          "type": "string",
          "example": "lib/features/gallery/presentation/bloc/gallery_bloc.dart"
        },
        "affected_layer": {
          "type": "string",
          "enum": ["presentation", "domain", "data", "unknown"]
        },
        "reproduction_steps": {
          "type": "string",
          "description": "How to reproduce the bug"
        },
        "environment": {
          "type": "string",
          "example": "iOS 15.2 / Android 12 / Web"
        }
      }
    },
    "related_files": {
      "type": "array",
      "description": "Related source files to provide context",
      "items": { "type": "string" }
    }
  }
}
```

**Example input:**

```json
{
  "error_source": "crash_log",
  "error_content": "Exception: NoSuchMethodError: The method '[]' was called on null.\n#1 GalleryBloc.build (package:app/features/gallery/...dart:45:22)",
  "context": {
    "affected_feature": "gallery",
    "reproduction_steps": "1. Open Gallery page 2. Scroll down 3. Tap back",
    "environment": "iOS 15.2"
  }
}
```

---

## 📤 Output Schema

```json
{
  "type": "object",
  "properties": {
    "phase": { "type": "string" },
    "status": {
      "type": "string",
      "enum": [
        "investigating",
        "awaiting_approval",
        "implementing",
        "testing",
        "completed",
        "failed"
      ]
    },
    "investigation_report": {
      "type": "object",
      "properties": {
        "error_type": { "type": "string" },
        "root_cause": { "type": "string" },
        "affected_layer": { "type": "string" },
        "affected_files": { "type": "array" },
        "severity": {
          "type": "string",
          "enum": ["critical", "high", "medium", "low"]
        }
      }
    },
    "fix_plan": {
      "type": "object",
      "properties": {
        "strategy": { "type": "string" },
        "files_to_modify": { "type": "array" },
        "estimated_effort": { "type": "string" },
        "risks": { "type": "array" },
        "needs_db_migration": { "type": "boolean" },
        "needs_api_change": { "type": "boolean" }
      }
    },
    "fixed_code": {
      "type": "object",
      "properties": {
        "file_path": { "type": "string" },
        "changes": { "type": "string", "description": "Diff or code snippet" }
      }
    },
    "tests_added": { "type": "array" },
    "verification_result": {
      "type": "object",
      "properties": {
        "tests_passed": { "type": "boolean" },
        "linter_passed": { "type": "boolean" },
        "code_quality_score": { "type": "number" },
        "issues_found": { "type": "array" }
      }
    },
    "pr_description": { "type": "string" }
  }
}
```

---

## 🔄 Step-by-Step Execution

### STEP 1: Investigation (5-10 min) 🔍

**Invoke:** `bug-investigator` skill

**Inputs:**

- Full stacktrace or crash log
- Affected feature/file
- Reproduction steps (if available)

**Process:**

1. Parse error message & extract key info
2. Classify error type (null safety, logic, API, async, etc.)
3. Trace data flow through layers (Presentation → Domain → Data)
4. Identify most relevant stacktrace frame
5. Read `.agent/memory/ARCHITECTURE.md` to verify layer separation
6. Read affected source files

**Outputs:**

```markdown
## 🐛 Bug Investigation Report

**Error Type:** NoSuchMethodError (null reference)
**Severity:** 🔴 Critical (app crash)
**Root Cause:** GalleryBloc attempts to access data before initialization
**Affected Layer:** Presentation (BLoC) + Domain (Entity)
**Affected Files:**

- lib/features/gallery/presentation/bloc/gallery_bloc.dart:45
- lib/features/gallery/domain/entities/photo.dart:12

**Stack Analysis:**
The most relevant frame is #1 GalleryBloc.build() on line 45.
The widget build method tries to access state.photos['name']
but state.photos is null because FutureBuilder hasn't completed yet.

**Why It Happened:**
Missing error state handling in BLoC. When API fails,
the BLoC doesn't emit an error state, leaving null dangling.
```

**Exit if:**

- ❌ Error log corrupted/incomplete → ask user for better log
- ❌ Multiple root causes found → user chooses which to fix first

---

### STEP 2: Design Fix Plan (5 min) 📋

**Invoke:** `bug-investigator` + `vibecoder` (planning mode)

**Process:**

1. Read ARCHITECTURE.md - verify layer rules
2. Design minimal fix strategy
3. Identify all files that need changes
4. Check if fix breaks any other features
5. Estimate effort & risk

**Outputs:**

```markdown
## ✏️ Fix Plan

**Strategy:** Add null-safe operator + emit error state in BLoC

**Files to Modify:**

1. lib/features/gallery/domain/entities/photo.dart
   - Add null safety check for photo data

2. lib/features/gallery/presentation/bloc/gallery_bloc.dart
   - Emit GalleryError state when API fails
   - Add null-safety operators in build method

3. ADD: test/features/gallery/presentation/bloc/gallery_bloc_test.dart
   - Test case for null photo API response

**Architecture Check:**
✅ Domain layer stays pure (no framework deps)
✅ Presentation calls Domain (correct dependency)
✅ No circular dependencies
✅ Follows BLoC error state pattern

**Risks:**
⚠️ Low: Changes only GalleryBloc, no shared code affected
⚠️ Need to verify: Other features using this BLoC

**Estimated Effort:** 20 minutes
**DB Migration:** No
**API Change:** No
```

---

### STEP 3: Design Approval (2 min) ⏸️

**MANDATORY STOP POINT**

AI presents plan and waits for user input:

```
🛑 PLAN APPROVAL REQUIRED

[Fix Plan from Step 2 displayed above]

Do you approve this plan?
Options:
  ✅ "OK" or "Approved" → Proceed to Step 4
  ❌ "No" / "Reject" → Stop, wait for user changes
  🔄 "Modify" → Back to Step 2 with new constraints
```

**User says:** "OK" → Continue to Step 4
**User says:** "NO" → Workflow stops, return error state

---

### STEP 4: Implementation (10-20 min) 💻

**Invoke:** `vibecoder` skill

**Inputs:**

- Investigation report (from Step 1)
- Approved fix plan (from Step 2)
- ARCHITECTURE.md (rules verification)
- Affected source files
- Related test files

**Process:**

1. Read approved fix plan
2. Modify each file according to plan
3. **ENFORCE:** Check Clean Architecture rules at each change
   - Domain layer: No framework imports ✅
   - Presentation: Uses BLoC pattern ✅
   - Data: Implements repository interface ✅
4. Add null-safe operators, error handling, proper state management
5. Run `dart format` on modified files
6. Keep changes minimal (only what's needed)

**Outputs:**

```dart
// lib/features/gallery/presentation/bloc/gallery_bloc.dart (BEFORE)
on<FetchPhotos>((event, emit) async {
  final response = await _repo.fetch();
  emit(GallerySuccess(response.photos)); // ❌ No error handling
});

// (AFTER)
on<FetchPhotos>((event, emit) async {
  try {
    final response = await _repo.fetch();
    if (response.photos != null) { // ✅ Null check
      emit(GallerySuccess(response.photos));
    } else {
      emit(GalleryError('No photos found'));
    }
  } catch (e) {
    emit(GalleryError(e.toString())); // ✅ Error state
  }
});
```

---

### STEP 5: Generate Tests (10-15 min) 🧪

**Invoke:** `test-engineer` skill

**Process:**

1. Verify if bug had existing test coverage
2. If NO: Create regression test for this bug
3. If YES: Update existing tests to verify fix
4. Follow Arrange-Act-Assert pattern
5. Mock external dependencies

**Outputs:**

```dart
// test/features/gallery/presentation/bloc/gallery_bloc_test.dart

group('GalleryBloc error handling', () {
  test('emits GalleryError when API returns null', () async {
    // Arrange: Mock API returning null
    when(_mockRepo.fetch()).thenAnswer((_) async => PhotoResponse(photos: null));

    // Act: Fetch photos
    add(FetchPhotos());

    // Assert: Expect error state
    await expectLater(
      bloc.stream,
      emitsInOrder([
        GalleryLoading(),
        isA<GalleryError>().having((e) => e.message, 'message', contains('No photos')),
      ]),
    );
  });
});
```

---

### STEP 6: Verify & Audit (5-10 min) ✅

**Invoke:** `test-engineer` + `code-quality-auditor` skills

**Process:**

1. Run `make test` - verify all tests pass
2. Run `make lint` - verify no linter errors
3. Run `test-engineer/scripts/run_coverage.sh` - check coverage
4. Invoke `code-quality-auditor` for:
   - Architecture compliance
   - Null safety
   - Code smells
   - Performance impact
5. Manual verification: Does fix actually solve original problem?

**Outputs:**

```
✅ VERIFICATION REPORT

Test Results:
  ✅ All tests pass (203/203)
  ✅ New regression test added
  ✅ Code coverage: 85% (was 82%)

Linter Results:
  ✅ No warnings
  ✅ All files formatted

Code Quality Audit:
  ✅ Architecture: Compliant (9/10)
  ✅ Null safety: Fixed (was 6/10, now 9/10)
  ✅ State management: Correct BLoC pattern
  📝 Minor: Consider renaming variable 'e' to 'error'

Manual Verification:
  ✅ Crash no longer occurs
  ✅ Gallery shows proper error message to user
  ✅ Related features not affected
  ✅ Can retry after fixing API issue

Status: ✅ FIX VERIFIED - READY FOR PR
```

---

## 🔌 Skill Integration Details

### Step 1 → Invoke `bug-investigator`

```yaml
Input:
  error_source: stacktrace
  error_content: full_crash_log

Skill Config:
  focus: "root cause analysis"
  architecture_context: true # Read ARCHITECTURE.md
  code_context: true # Read affected files

Output: investigation_report with root_cause, affected_files, severity
```

### Step 4 → Invoke `vibecoder`

```yaml
Input:
  mode: "fix_mode"
  fix_plan: approved_plan_from_step_2
  architecture_rules: ARCHITECTURE.md

Skill Config:
  enforce_clean_architecture: true
  follow_bud_patterns: true
  add_null_checks: true

Output: fixed_code with all modifications
```

### Step 5 → Invoke `test-engineer`

```yaml
Input:
  related_files: ["test/...test.dart"]
  bug_type: "null_reference"
  coverage_target: 80%

Output: regression_test with setup, mock, assertions
```

### Step 6 → Invoke `code-quality-auditor`

```yaml
Input:
  feature_folder: affected_feature_path
  check_types: ["architecture", "null_safety", "performance"]

Output: audit_report with scores and issues
```

---

## ⚠️ Error Handling

### If Investigation Fails (Step 1)

```
❌ ERROR: Cannot determine root cause
  - Stacktrace incomplete or corrupted
  - Multiple root causes (ambiguous)

ACTION: Ask user for more info
  1. "Can you provide full stacktrace?"
  2. "Does this error reproduce 100%?"
  3. "Any recent changes before this bug?"
```

### If Fix Plan Rejected (Step 3)

```
❌ USER REJECTED PLAN

ACTION:
  1. Ask what's wrong with plan
  2. Modify plan based on feedback
  3. Get re-approval OR stop if user can't decide
```

### If Tests Fail (Step 6)

```
❌ ERROR: New tests fail after fix

ACTION:
  1. Check what test is failing
  2. Verify fix actually addressed root cause
  3. If not: Go back to Step 4, adjust implementation
  4. Retest
```

---

## 💡 AI Guidelines

**Language:** All outputs must be in **Vietnamese**

**Philosophy:**

- 🎯 **Fix root cause, not symptoms** - If UI broken because Domain layer logic is wrong, fix Domain
- 🧪 **Add tests for bugs** - If bug wasn't covered by tests, add regression test
- 🏗️ **Respect Clean Architecture** - Example: Don't patch UI if bug is in data layer
- ⏸️ **Plan before execute** - NEVER skip Step 3 approval
- ✅ **Verify before ship** - NEVER merge without passing tests + linter

**Minimal approach:**

- Touch only files necessary for fix
- Don't refactor while fixing
- Don't add unrelated improvements
- Keep changes focused & reviewable

---

## 📝 PR Description Template (Step 6 Output)

When fix is verified, generate PR description:

```markdown
## 🐛 Fix Crash: GalleryBloc null reference

**Issue:** App crashes when Gallery API returns null response
**Root Cause:** Missing null-safety checks in BLoC event handler
**Severity:** 🔴 Critical (production blocker)

### Changes

- [Presentation] Added error state emission in GalleryBloc
- [Domain] Verified Entity null-safety
- [Tests] Added regression test for null API responses

### Verification

- ✅ `make lint` passed
- ✅ `make test` passed (203/203)
- ✅ Code coverage maintained (85%)
- ✅ Manual verification on iOS/Android

### Testing

1. Open Gallery page
2. Simulate API failure (set response to null)
3. Verify error message shown (not crash)

### Related

- Affected feature: Gallery
- Affects versions: 1.x, 2.x
```

---

## 🎯 Success Criteria

✅ Fix is **approved by user** (Step 3)  
✅ **All tests pass** (Step 6)  
✅ **Linter passes** (Step 6)  
✅ **Code quality audit** passes (Step 6)  
✅ **Manual verification** confirms bug is fixed  
✅ **No regressions** in related features

---

## ⏱️ Typical Duration

- Investigation: 5-10 min
- Planning: 5 min
- Approval: 2 min (waiting for user)
- Implementation: 10-20 min
- Testing: 10-15 min
- Verification: 5-10 min

**Total:** 40-60 minutes (depending on bug complexity)
