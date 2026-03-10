---
description: "Review code, UI/UX, or PR changes. Auto-detect context and mode."
trigger: /review
version: "5.4.0"
skills:
  - code-reviewer
  - frontend-architect
  - defensive-coder
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Report generated"]
skill: code-reviewer
---

# 🧐 Unified Review (Code & UI/UX)

**Objective:** Quality check code and user experience in a single workflow. Auto-detect context.

## 🎯 Mode Detection (Automatic)

| Context | Mode | Trigger |
|:---|:---|:---|
| File path specified | `code` | Review specific file |
| Uncommitted changes exist | `changes` | `git diff HEAD` |
| Branch/PR reference exists | `pr` | `git diff origin/main` |

## 🚀 Execution Steps

### 1. Context Detection & Scoping (Smart Mode)

**Step 1.1: Identify User Intent**
*   **Case 1: Review Uncommitted Changes** (Trigger: "review code", "review my changes")
    *   **Action:** DO NOT run `create_pr_diff.sh`. 
    *   **Command:** Run `git diff HEAD -- . ':(exclude)*.lock' ':(exclude)*.g.dart' ':(exclude)*.freezed.dart' > pr_changes.diff`
*   **Case 2: Review Specific File(s)** (Trigger: "review file X")
    *   **Action:** DO NOT run `create_pr_diff.sh`. 
    *   **Command:** Run `git diff HEAD -- <file> > pr_changes.diff` (or just read the file if requested).
*   **Case 3: Review Full Branch/PR** (Trigger: "review PR", "review against develop")
    *   **Action:** Run `.agent/skills/code-reviewer/scripts/create_pr_diff.sh [-b base_if_user_specified] -y`
    *   **Info:** Script auto-detects merge-base and caches result in `.pr_review_cache`.

**Step 1.2: General Info**
*   Output: `pr_changes.diff` (filtered, ready for analysis)

**Step 1.4: Confirm Scope**
*   Read first 50 lines of diff to understand scope.
*   Output: "Reviewing X files against [detected_base]. Merge point: [commit_hash]"

### 2. Analysis & Audit
Run checks based on scope:

**Technical Audit (all modes):**
*   Architecture compliance (Clean Arch).
*   Logic errors and Edge cases.
*   Security (Hardcoded secrets).

**Project-Specific Audit ([PROJECT_NAME]):**
*   **State Management (BLoC):** Verify `freezed` is used for Events/States. Verify UI only listens to States and dispatches Events.
*   **Routing & Auth:** Ensure critical routes use `SessionTimeOutGuard`. Ensure SharedData handlers don't alter state improperly when on LoginScreen.
*   **Native Memory:** Check for proper `dispose()` calls on `CameraController`, `PdfViewerController`, or large `Image.memory` buffers.

**Business Logic Audit (New - v5.4.0):**
*   **State Machine:** Verify valid state transitions (e.g., Loading -> Success/Error).
*   **Permissions:** Check if role-based access control (RBAC) is enforced.
*   **Invariants:** Ensure core business rules are not violated.


**Frontend/UI Audit (Context-Aware):**
*   **Web:**
    *   **Aesthetics:** distinctive typography, spacing, CSS variables.
    *   **Accessibility:** semantic HTML, contrast ratios.
*   **Mobile (Flutter):**
    *   **Widgets:** Use `SafeArea`, avoid hardcoded pixel values (use logical pixels/screen %).
    *   **Touch Targets:** Buttons must be >= 44x44px.
    *   **Platform:** Check for iOS/Android specific behaviors (Back button, Dialogs).
*   **Motion (All):** Verify easing and durations.


**Performance Audit (Speed & Efficiency):**
*   **Complexity:** Flag nested loops O(n^2) or expensive computations in hot paths.
*   **IO/Network:** Ensure non-blocking I/O (await properly used).
*   **Rendering (Frontend):** Check for excessive re-renders, large lists without virtualization.
*   **Memory:** Check for unclosed subscriptions, listeners, or timers.

**Observability Audit (New - v5.4.0):**
*   **Logging:** Ensure structured logging for State changes and Errors.
*   **Context:** Logs must include `userId`, `requestId` or relevant correlation IDs.
*   **Metrics:** Check if critical user flows emit success/failure metrics.



### 3. Edge Case & Defensive Audit (CRITICAL - v5.3.1) 🛡️

**Skill Activation:** `defensive-coder`

**Objective:** Ensure code handles ALL abnormal scenarios gracefully.

#### Step 3.1: Auto-Fail Pattern Detection

Scan code for CRITICAL failures (auto-REJECT if found):

```typescript
// 🚫 BLOCK MERGE if detected:
user.name                    // No null check
await api.call()             // No try-catch
items[0]                     // No length check
JSON.parse(data)             // No validation
fetch(url)                   // No timeout
localStorage.set()           // No quota check
file.write()                 // No finally cleanup
```

**Action:** If ANY pattern found → Set status to **BLOCKED**, generate fix examples.

#### Step 3.2: Edge Case Checklist Audit

Verify coverage of 5 categories (from DOD.md):

**📋 Input Validation:**
- [ ] Null/undefined checks before property access
- [ ] Empty array/string checks before iteration
- [ ] Type validation for user inputs
- [ ] Boundary value handling (0, -1, MAX)

**🌐 Network & External:**
- [ ] Timeout on all API calls (default 30s)
- [ ] Retry logic with exponential backoff
- [ ] Offline/network error handling
- [ ] Response schema validation

**💾 Resource Management:**
- [ ] Finally blocks for cleanup
- [ ] Memory limit handling (pagination)
- [ ] Permission error handling
- [ ] Concurrent access protection

**🔐 Security:**
- [ ] Auth check before operations
- [ ] Rate limiting handling
- [ ] Input sanitization (SQL/XSS prevention)

**🖱️ User Behavior:**
- [ ] Double-click prevention
- [ ] Loading states for >500ms operations
- [ ] Error retry mechanisms

#### Step 3.3: Defensive Pattern Scoring

**Green (Pass):** 4+ categories covered  
**Yellow (Warn):** 2-3 categories covered  
**Red (Block):** 0-1 category covered

**Output Example:**
```markdown
### 🛡️ Edge Case Coverage: 🟡 YELLOW (3/5)

| Category | Status | Issues |
|:---|:---:|:---|
| Input Validation | ✅ | Good null checks |
| Network | ❌ | No timeout on API calls (line 45, 67) |
| Resources | ✅ | Finally blocks present |
| Security | ❌ | No auth check in deleteUser() |
| UI Behavior | ✅ | Loading states implemented |

**Critical Gaps:**
1. Add timeout to `fetchUserData()` (line 45)
2. Add auth check before `deleteUser()` (line 120)

**Recommendation:** Fix 2 critical gaps before merge.
```

### 4. Report Generation
```markdown
## 📊 Unified Review Report

**Mode:** [code/changes/pr]
**Files reviewed:** X files

### 📊 Issue Summary
| Severity | Count |
|:---|:---:|
| 🔴 Critical | 0 |
| 🟠 Major | 0 |
| 🟡 Minor | 0 |

### ✅ Strengths

*   [Good practices found]

### 🚨 Critical Issues
| Severity | Category | File:Line | Issue | Suggestion |
|:---|:---|:---|:---|:---|
| High | Technical | file.ts:12 | Logic error | Fix X |
| High | UI/UX | style.css:5 | Low contrast | Use hsl(...) |

### 💡 Recommendations
*   [Actionable improvement suggestions]

**Overall:** [APPROVED / NEEDS WORK / BLOCKED]
```

## 🔌 Skill Integration

**Active skills:** `code-reviewer`, `frontend-architect`

**How it works:**
1.  **Code Logic:** Uses `code-reviewer` for business rules and architecture.
2.  **UI/UX Quality:** Uses `frontend-architect` to audit aesthetics, typography, and motion.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**.

*   **Be Multi-disciplinary:** Don't just look at the code logic. If a button has a hardcoded hex color, flag it as a UI debt.
*   **Constructive Feedback:** Show "Better Code" examples for both logic and styling.

### ⚠️ CRITICAL: Base Branch Detection

**DO NOT:**
- ❌ Hardcode `-b develop` or `-b main` in script calls
- ❌ Assume base branch without checking user's request
- ❌ Override script's auto-detection unless user explicitly requests

**DO:**
- ✅ Parse user request for branch mentions: "review against release/v2.0"
- ✅ Let script auto-detect if user doesn't specify
- ✅ Show detected base branch in output for transparency
- ✅ Trust the merge-base algorithm (it finds the true branch point)

**Example User Requests:**
- "Review PR" → Run script WITHOUT `-b` flag (auto-detect)
- "Review against develop" → Run script WITH `-b origin/develop`
- "Review this branch" → Run script WITHOUT `-b` flag (auto-detect)

