---
description: "Review code, UI/UX, or PR changes. Auto-detect context and mode."
trigger: /review
version: "5.3.1"
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

### 1. Context Detection & Scoping (Crucial)
*   **Refresh Refs:** If checking a PR or branch, **ALWAYS** run `git fetch origin` first.
*   **Identify Parent Branch (Base):**
    *   AI MUST detect the branch point to avoid comparing against the wrong base.
    *   **Heuristic 1:** `git show-branch -a | grep '\*' | grep -v "\[$(git rev-parse --abbrev-ref HEAD)\]" | head -n1`
    *   **Heuristic 2:** `git log --oneline --decorate --simplify-by-decoration -n 5` (Look for the first branch head above the current branch).
    *   **Heuristic 3:** If on a feature branch, check against `origin/main`, `origin/master`, or `origin/develop` (preferred order).
*   **Set Variables:**
    *   `FEATURE_BRANCH`: Current branch.
    *   `BASE_BRANCH`: Detected parent branch.
*   **Verification (Fallback):**
    *   If heuristics fail or results are ambiguous (e.g., diff > 20 files), **STOP and ASK**:
        > "Cannot determine base branch with high confidence. Comparing against `origin/main` shows 50+ changed files. Please specify the correct base branch (e.g., origin/develop)."

*   **Identify Changed Files:**
    *   *Uncommitted:* `git diff --name-only HEAD`
    *   *Branch/PR:* `git diff --name-only $BASE_BRANCH...$FEATURE_BRANCH`
*   **Filter Scope (Token Saver):**
    *   **Exclude:** `*.lock`, `*.g.dart`, `*.freezed.dart`, `assets/*`, `*.min.js`, `*.map`, `node_modules/*`, `vendor/*`, `dist/*`
    *   **Focus:** ONLY read files in the filtered list.
*   **Confirm Scope:** Output: "Comparing `$FEATURE_BRANCH` vs `$BASE_BRANCH`. Found X changed files."

### 2. Analysis & Audit
Run checks based on scope:

**Technical Audit (all modes):**
*   Architecture compliance (Clean Arch).
*   Logic errors and Edge cases.
*   Security (Hardcoded secrets).

**Frontend/UI Audit (if UI files detected):**
*   **Aesthetics:** Check for distinctive typography and spacing (no generic slop).
*   **Design Tokens:** Ensure use of CSS variables/hsl() instead of hardcoded hex.
*   **Accessibility:** Check contrast ratios (≥4.5:1) and focus indicators.
*   **Motion:** Verify easing and durations for animations.

**Performance Audit (Speed & Efficiency):**
*   **Complexity:** Flag nested loops O(n^2) or expensive computations in hot paths.
*   **IO/Network:** Ensure non-blocking I/O (await properly used).
*   **Rendering (Frontend):** Check for excessive re-renders, large lists without virtualization.
*   **Memory:** Check for unclosed subscriptions, listeners, or timers.


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
