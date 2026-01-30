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

**Objective:** Root cause fix using **{{STACK_NAME}}** debugging techniques.

## 🚀 Execution Flow

### Step 1: Investigation
- Trace data flow.
- Check specific **{{STACK_NAME}}** pitfalls (e.g., {{COMMON_BUGS}}).

### Step 2: Solution Audit
Present fix plan. **STOP** for approval.

### Step 3: Execution
- Implement fix.
- **TDD:** Write a failing test using `{{LIB_TEST}}` first if possible.

### Step 4: Verification
**Run Command:**
```bash
{{CMD_TEST}}
```

## 💡 AI Guidelines
- **Minimal Changes:** Touch only what is necessary.
- **Verification:** Using `{{CMD_TEST}}` is mandatory.
