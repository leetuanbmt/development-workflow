---
description: "Systematic bug fix following: Investigate → Plan → Fix → Verify."
trigger: /fix
version: "2.3.0"
skills:
  - bug-investigator
  - code-reviewer
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Fix verified", "User rejected plan"]
skill: bug-investigator
---

# 🔧 Systematic Bug Fix ({{STACK_NAME}})

**Objective:** Root cause fix using **{{STACK_NAME}}** debugging techniques with intelligent routing.

## 🚀 Execution Flow

### Step 1: Analyze & Route
- **Investigation:** Trace data flow & check **{{STACK_NAME}}** pitfalls (e.g., {{COMMON_BUGS}}).
- **Complexity Assessment:**
    - **Lite Mode:** If fix is simple (< 10 LOC, no breaking changes) -> **GOTO Step 3 (Execution)** directly.
    - **Deep Mode:** If fix is complex -> **Proceed to Step 2**.

### Step 2: Solution Audit (Deep Mode Only)
*Skip this step if "Lite Mode" is active.*

Present fix plan. **STOP** for approval.

### Step 3: Execution
- Implement fix (Auto-apply for Lite Mode).
- **TDD:** Write a failing test using `{{LIB_TEST}}` first if possible.

### Step 4: Verification
**Run Command:**
```bash
{{CMD_TEST}}
```

## 💡 AI Guidelines
- **Intelligent Routing:** Check complexity first.
- **Lite Mode:** Fix fast, but MUST verify.
- **Deep Mode:** Plan first, never fix without approval.
- **Verification:** Using `{{CMD_TEST}}` is mandatory.
