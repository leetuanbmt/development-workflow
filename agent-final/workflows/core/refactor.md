---
description: "Safe code refactoring without breaking existing functionality."
trigger: /refactor
version: "5.2.0"
skills:
  - tech-lead
  - code-reviewer
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Refactor complete", "Tests passed"]
skill: code-reviewer
---

# ♻️ Safe Refactoring

**Objective:** Cleaner, more readable code while preserving behavior (Behavior Preserving).

## 🔄 Execution Flow

### 1. Analysis & Mapping
- **Dependency Graph:** Who calls this file? Which modules are affected by changes?
- **Smell Detection:** Identify specific issues (Code duplication, Long method, God class...).

### 2. Safety Net Strategy
- Check if Unit Tests exist
- If not, suggest:
  - Option A: Write tests first (Recommended).
  - Option B: Create Golden Master (Save current output for comparison).
  - Option C: Manual Checklist (If UI code is hard to test).

### 3. Incremental Execution
- Don't refactor an entire 1000-line file at once
- Break it down: Rename first → Extract Method next → Move Class last
- Verify after each small step

### 4. Final Review
- Use `/review` or `code-reviewer` skill to ensure new code follows Clean Code standards

## � Skill Integration

**Active skills:** `tech-lead`, `code-reviewer`

**Skill roles:**
- **tech-lead:** Strategic refactoring decisions, architecture guidance
- **code-reviewer:** Code quality validation, Clean Code compliance

**Step mapping:**
1. Analysis → `tech-lead` (dependency analysis, smell detection)
2. Safety Net → `code-reviewer` (test coverage check)
3. Execution → `tech-lead` (incremental approach)
4. Review → `code-reviewer` (final quality check)

## �💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Respect conventions:** Enforce Clean Architecture (UI must use BLoC, Data must map to Entities).
- **Don't change logic:** Refactor != Bug Fix. Don't try to fix bugs while refactoring (unless trivial and obvious)
