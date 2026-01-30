---
description: "Systematic bug fix following: Quick Investigate → Plan → Fix → Verify."
trigger: /fix
version: "2.2.0"
skills:
  - bug-investigator
  - code-reviewer
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Fix applied and verified", "User rejected plan"]
skill: bug-investigator
---

# 🔧 Systematic Bug Fix

**Objective:** Root cause fix instead of temporary patching.

## 🚀 Execution Flow

### Step 1: Quick Investigation (5 min max)
- Identify reproduction steps.
- Trace data flow to find breaking point.
- Root Cause Analysis: Logic error? Null safety? API contract changed?
- Check if this is a regression (did it work before?).

### Step 2: Solution Audit (Mandatory)
Present fix plan with:
- **Files to modify:** List all affected files.
- **Approach:** Explain the fix strategy.
- **Risks:** Potential side effects.
- **Test Strategy:** How to verify the fix (New Unit Test? Integration Test? Manual?).

**STOP HERE** - Wait for user approval before proceeding.

### Step 3: Execution
- **TDD Preference:** If possible, write a failing test case first.
- Implement the approved fix.
- Follow project conventions (check `.agent/memory/ARCHITECTURE.md` and `.agent/memory/PROJECT.md`).
- Add defensive code where applicable.

### Step 4: Verification
- Run tests: `flutter test`, `npm test`, or equivalent.
- Manual smoke test if UI-related.
- Check for regression in related features.

## 🔌 Skill Integration

**Active skills:** `bug-investigator`, `code-reviewer`

**Skill sequence:**
1. **Step 1 (Investigation):** Apply `bug-investigator` methodology.
2. **Step 2 (Planning):** Use both skills for solution design.
3. **Step 4 (Verification):** Apply `code-reviewer` standards.

AI automatically loads both skill methodologies and applies them at appropriate steps.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Plan first:** Never fix without approval.
- **Minimal changes:** Touch only what's necessary to fix the bug.
- **Add tests:** If the bug had no test coverage, adding a test is mandatory (unless technically impossible).