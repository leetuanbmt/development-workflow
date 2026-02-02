---
description: "Review code, UI/UX, or PR changes. Auto-detect context and mode."
trigger: /review
version: "3.0.0"
skills:
  - code-reviewer
  - frontend-architect
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

### 1. Context Detection
*   Check for uncommitted changes.
*   Identify target files/branch.
*   **Analyze Scope:** Detect if changes involve UI (CSS, HTML, React/Flutter components).

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

### 3. Report Generation
```markdown
## 📊 Unified Review Report

**Mode:** [code/changes/pr]
**Files reviewed:** X files

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
