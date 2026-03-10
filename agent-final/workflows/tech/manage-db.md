---
description: "Manage Database schema safely, focusing on Migration and Data Integrity."
trigger: /manage-db
version: "5.2.0"
skills:
  - tech-lead
  - test-engineer
constraints:
  max_iterations: 4
  timeout_minutes: 25
  exit_on: ["Migration complete", "Tests passed"]
skill: tech-lead
---

# 🗄️ Safe Database Management

**Objective:** Change DB schema without losing user data.

## 🔄 Execution Flow

### 1. Schema Impact Analysis
- **Audit:** Before adding columns/tables, check if it affects existing Queries (`DAOs`)?
- **Constraint Check:** New column has `NOT NULL`? If yes, what's the `defaultValue`?

### 2. Implementation Steps
1. **Modify Schema:** Edit `drift` schema definition (`@DataClassName` classes).
2. **Generate:** Remind user to run `dart run build_runner build -d`.
3. **Migration Logic:**
   - Update `schemaVersion` in the DB file.
   - **REQUIRED:** Add migration logic in `migration` -> `onUpgrade` -> `stepByStep`. Use safe methods (e.g., `addColumn`).

### 3. Verification (Safety First)
- **Test Migration:**
  - AI must suggest (or write) a small test case to verify migration from version N to N+1
- **Sanity Check:**
  - Run app to ensure no crash when opening Database

## 🔌 Skill Integration

**Active skills:** `flutter-expert`, `test-engineer`

**Skill roles:**
- **tech-lead:** Database schema expertise, ORM-specific knowledge
- **test-engineer:** Migration testing strategy, data integrity verification

**Application:**
- Step 1: `tech-lead` analyzes impact
- Step 2: `tech-lead` guides implementation
- Step 3: `test-engineer` designs verification tests

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Warning:** If User plans to delete column (Delete Column), warn 3 times about data loss
- **Version Control:** Always remind user to increment `schemaVersion`