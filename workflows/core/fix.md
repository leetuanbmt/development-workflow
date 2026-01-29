---
description: "Systematic bug fix following: Quick Investigate → Plan → Fix → Verify."
trigger: /fix
version: "2.1.0"
skills:
  - bug-investigator
  - code-reviewer
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Fix applied and verified", "User rejected plan"]
---

# 🔧 Systematic Bug Fix

**Objective:** Root cause fix instead of temporary patching.

## 🚀 Execution Flow

### Step 1: Quick Investigation (5 min max)
- Identify reproduction steps
- Trace data flow to find breaking point
- Root Cause Analysis: Logic error? Null safety? API contract changed?

### Step 2: Solution Audit (Mandatory)
Present fix plan with:
- **Files to modify:** List all affected files
- **Approach:** Explain the fix strategy
- **Risks:** Potential side effects
- **Testing plan:** How to verify the fix

**STOP HERE** - Wait for user approval before proceeding.

### Step 3: Execution
- Implement the approved fix
- Follow project conventions (check `.agent/memory/CONVENTIONS.md`)
- Add defensive code where applicable

### Step 4: Verification
- Run tests: `flutter test` or equivalent
- Manual smoke test if UI-related
- Check for regression in related features

## 💡 AI Guidelines
- **Plan first:** Never fix without approval
- **Minimal changes:** Touch only what's necessary
- **Add tests:** If bug had no test coverage, add one
