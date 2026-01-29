---
description: "Manage Database schema with Drift safely, focusing on Migration and Data Integrity."
trigger: /manage-db
version: "3.0.0"
skills:
  - flutter-expert
  - test-engineer
constraints:
  max_iterations: 4
  timeout_minutes: 25
  exit_on: ["Migration complete", "Tests passed"]
---

# 🗄️ Safe Database Management

**Objective:** Change DB schema without losing user data.

## 🔄 Execution Flow

### 1. Schema Impact Analysis
- **Audit:** Before adding columns/tables, check if it affects existing Queries (`DAOs`)?
- **Constraint Check:** New column has `NOT NULL`? If yes, what's the `defaultValue`?

### 2. Implementation Steps
1. **Modify Table:** Edit `.dart` file defining the table
2. **Generate:** Run `make gen` (or project equivalent)
3. **Migration Logic:**
   - Write code in `migration` block of `AppDatabase`
   - **REQUIRED:** Must use Drift's `addColumn`, `createTable` commands, NOT raw SQL unless absolutely necessary

### 3. Verification (Safety First)
- **Test Migration:**
  - AI must suggest (or write) a small test case to verify migration from version N to N+1
- **Sanity Check:**
  - Run app to ensure no crash when opening Database

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Warning:** If User plans to delete column (Delete Column), warn 3 times about data loss
- **Version Control:** Always remind user to increment `schemaVersion`