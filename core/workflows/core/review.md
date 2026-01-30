---
description: "Review code, PR, or Git changes. Auto-detect context and mode."
trigger: /review
version: "2.0.0"
skills:
  - code-reviewer
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Report generated"]
skill: code-reviewer
---

# 🧐 Unified Code Review

**Objective:** Quality check code in a single workflow. Auto-detect context.

## 🎯 Mode Detection (Automatic)

| Context | Mode | Trigger |
|:---|:---|:---|
| File path specified | `code` | Review specific file |
| Uncommitted changes exist | `changes` | `git diff HEAD` |
| Branch/PR reference exists | `pr` | `git diff origin/main` |

## 🚀 Execution Steps

### 1. Context Detection
- Check for uncommitted changes
- Identify target files/branch
- Select appropriate review mode

### 2. Code Analysis
Run checks based on mode:

**For `code` mode:**
- Architecture compliance (Clean Arch, Layer separation)
- Code smells (duplicati
on, complexity)
- Naming conventions

**For `changes` mode:**
- What changed and why?
- Breaking changes?
- Backward compatibility check

**For `pr` mode:**
- All of above +
- Commit message quality
- Migration scripts (if DB changed)

### 3. Report Generation
```markdown
## 📊 Code Review Report

**Mode:** [code/changes/pr]
**Files reviewed:** X files

### ✅ Strengths
- [List good practices found]

### ⚠️ Issues Found
| Severity | File | Line | Issue |
|:---|:---|---:|:---|
| High | path/to/file | 42 | [Description] |

### 💡 Recommendations
- [Actionable suggestions]

**Overall:** [APPROVED / NEEDS WORK / BLOCKED]
```

## 🔌 Skill Integration

**Active skill:** `code-reviewer`

Automatically loads code review checklist and standards from `skills/code-reviewer/SKILL.md`.

**Applied techniques:**
- Context-aware review (understands business logic first)
- Architecture compliance checking
- Golden Rule: "Understand First" methodology

Review depth and focus adapts based on detected mode (code/changes/pr).

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Context-aware:** Adjust depth based on mode
- **Constructive:** Suggest improvements, not just criticisms
- **Prioritize:** Flag critical issues first
