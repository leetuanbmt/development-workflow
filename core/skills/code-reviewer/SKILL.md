---
name: "code-reviewer"
description: "Context-aware code review based on business logic and conventions."
inputs:
  - name: "diff"
    type: "diff"
    desc: "Git diff or code changes"
  - name: "context"
    type: "file"
    desc: "Related files for context"
outputs:
  - name: "review_report"
    type: "markdown"
    desc: "Review report (Critical/Major/Minor)"
---

# Code Review Skill

Use this skill when you need to check code quality, ensure compliance with Clean Architecture, State Management Patterns and project business rules. Activate when detecting: "review code", "check logic", "inspect PR", "audit architecture".

## 🚀 When to use
- When new code is written and needs correctness verification
- When ensuring code follows Clean Architecture (Domain/Data/Presentation)
- When reviewing for potential logic errors or edge cases
- When checking naming consistency and directory structure

## 🛑 When NOT to use
- Don't use for writing new code from scratch (use `tech-lead` or implementation skill)
- Don't use for writing technical documentation (use `technical-writer`)
- Don't use for investigating existing bugs (use `bug-investigator`)

## 💡 Example Triggers
- "Review this code in repository implementation file for me"


- "Check if logic in this State Manager violates layer rules"
- "Audit this PR, pay attention to network error handling"
- "Verify if newly created file follows project conventions"

## 🧠 Golden Rule: Understand First

Before making any comments, you must answer 3 questions:
1. **Intent:** What business problem is this code trying to solve?
2. **Data Flow:** Where does data come from (DB/API) and how is it displayed?
3. **Architecture:** Does it follow dependency rules? (Domain doesn't depend on Data)

## 📋 Review Checklist

### 1. Architecture Compliance
- [ ] Layer separation clear (Data/Domain/Presentation)?
- [ ] No circular dependencies?
- [ ] Domain layer pure (no external dependencies)?

### 2. Business Logic
- [ ] Logic matches Spec?
- [ ] Edge cases handled?
- [ ] Input validation present?

### 3. Code Quality
- [ ] Meaningful variable/function names?
- [ ] Functions short and focused?
- [ ] No code duplication?

### 4. Error Handling
- [ ] Network errors handled properly?
- [ ] User-friendly error messages?
- [ ] Grace degradation when failures occur?

### 5. Testing
- [ ] Critical logic covered by tests?
- [ ] Test cases include edge cases?

## 💡 AI Guidelines

**Language:** All code review reports and feedback must be in **Vietnamese**, even though this skill documentation is in English.

- **Be constructive:** Suggest improvements, don't just criticize
- **Prioritize:** Flag critical issues first (security, data loss)
- **Context-aware:** Understand business requirements before commenting
- **Example-driven:** Show better code examples when suggesting changes
- **Consistent:** Apply same standards across entire codebase

## 📤 Output Format

```markdown
## 🔍 Code Review Report

**File:** [path/to/file.ext]

### ✅ Strengths
- [List good practices]

### ⚠️ Issues Found
| Severity | Line | Issue | Suggestion |
|:---|---:|:---|:---|
| High | 42 | Null safety issue | Add null check |

### 💡 Recommendations
- [Improvement suggestions]

**Overall:** [APPROVED / NEEDS REVISION / BLOCKED]
```
