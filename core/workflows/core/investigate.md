---
description: "Analyze root cause of bugs and generate investigation report. Report ONLY, NO code fixes."
trigger: /investigate
version: "3.1.0"
skills:
  - bug-investigator
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Report generated"]
  no_code_edit: true
skill: bug-investigator
---

# 🕵️ Bug Investigation Protocol

**Objective:** Find root cause and assess impact. **DO NOT auto-fix code.**

## 🚀 Execution Steps

### 1. Context Gathering
- Read error logs (if available)
- Read code at suspected location
- Trace data flow: UI → BLoC → UseCase → Repository

### 2. Root Cause Analysis
- Why did the error occur? (Logic error, Null pointer, Race condition, API change?)
- Verify hypothesis with evidence in code

### 3. Impact Analysis
- Which files/features are affected?
- Is data integrity compromised?
- How many users are impacted?

### 4. Report Generation
Follow this template:

```markdown
## 🐛 Bug Investigation Report

**Issue:** [Brief description]

**Root Cause:**
[Detailed explanation with code references]

**Affected Components:**
- File: `path/to/file.dart` (Line X-Y)
- Feature: [Feature name]

**Impact:**
- Severity: [Critical/High/Medium/Low]
- Users affected: [Estimate]

**Recommended Fix:**
[High-level approach - DO NOT implement]

**Next Steps:**
- [ ] User approves fix approach
- [ ] Execute via `/fix` workflow
```

## � Skill Integration

**Active skill:** `bug-investigator`

When this workflow is executed, AI automatically:
1. Loads `skills/bug-investigator/SKILL.md` methodology
2. Applies root cause analysis techniques from the skill
3. Generates report following skill's output format
4. Enforces "READ ONLY" constraints from skill documentation

No separate skill invocation needed - skill is applied inline.

## �💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **No auto-fix:** This workflow is investigation ONLY
- **Evidence-based:** All claims must reference code/logs
- **Neutral tone:** Report facts, not speculation
