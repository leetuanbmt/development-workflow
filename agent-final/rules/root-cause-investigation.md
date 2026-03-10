---
trigger: always_on
description: Systematic root cause investigation process for Flutter/Clean Architecture bugs
globs: "**/*.dart"
---

# Root Cause Investigation Rule

Activate when user uses keywords: **investigate, điều tra, root cause, crash, không hoạt động, nguyên nhân, tại sao, why, lỗi, bug, error**.

## 🔍 Mandatory Investigation Steps (in order)

### Step 1 — Collect Evidence FIRST
Before forming any hypothesis, always collect:
- [ ] Error log / Stacktrace (exact line numbers)
- [ ] User-described behavior (expected vs. actual)
- [ ] Reproduction steps (when does it happen?)

**Never hypothesize before reading logs.**

### Step 2 — Trace the Clean Architecture Stack
Follow the data flow top-down to find the breaking layer:

```
UI (Page/Widget)
  → BLoC/Cubit (State/Event)
    → UseCase (if exists)
      → Repository Interface (Domain)
        → Repository Impl (Data)
          → DataSource (API / Drift DB / Cache)
```

Use `grep`/`codebase_search` to trace each handoff point.

### Step 3 — Pinpoint the Exact Cause
Identify ONE specific root cause (not symptoms):

| Category | Common Causes in this Project |
|----------|-------------------------------|
| **Null safety** | `.value!` without guard, `first` on empty list |
| **State lifecycle** | BLoC closed before event emitted, `emit()` after `close()` |
| **Async race** | `await` missing, parallel writes to same stream |
| **DI / Injectable** | Dependency not registered, wrong scope (`@singleton` vs `@lazySingleton`) |
| **AutoRoute** | Pop called on wrong context, missing route guard |
| **Drift (SQLite)** | Migration missing, wrong table/column name |
| **Retrofit / Dio** | Response model mismatch, wrong endpoint, missing interceptor |

### Step 4 — Assess Impact Scope

```
Severity: Critical (crash/blocker) | Major (feature broken) | Minor (UI glitch)
Affected screens: [list them]
Regression risk: High | Medium | Low
```

### Step 5 — Propose Fix (Suggestion Only)
- Describe the fix conceptually (code snippet if short)
- Suggest test case to prevent recurrence
- **Do NOT edit any files** during investigation — report only

---

## ❌ Anti-Patterns to Avoid

```dart
// ❌ NEVER assume cause without reading the stacktrace
// ❌ NEVER suggest "just try rebuilding" as root cause
// ❌ NEVER skip the data-flow trace for complex bugs
```

---

## 📋 Output Format (Required)

Every investigation must end with this structured report:

```markdown
## 🔍 Root Cause Analysis

### 1. Root Cause
**Cause:** [specific file, line, function]
**Mechanism:** [why this causes the bug — e.g., null dereference when X is Y]

### 2. Impact Scope
- **Severity:** Critical / Major / Minor
- **Affected:** [screens / features]
- **Regression risk:** [High/Medium/Low — what breaks if we fix this?]

### 3. Fix Approach
- **Solution:** [concrete approach]
- **Prevention:** [test case or refactoring to add]
```

> 📌 **Language:** Always write the investigation report in **Vietnamese** unless the user specifies otherwise.