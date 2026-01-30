---
description: "Manage Database schema safely, focusing on Migration and Data Integrity."
trigger: /manage-db
version: "3.1.0"
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
- **Audit:** Before adding columns/tables, check if it affects existing Queries (DAOs/Repositories)?
- **Constraint Check:** New column has `NOT NULL`? If yes, what's the `defaultValue`?

### 2. Implementation Steps
1. **Modify Schema:** Edit the schema definition (Entity/Table class, Prisma schema, etc.).
2. **Generate:** Run code generation tools (e.g., `make gen`, `prisma generate`, `room compiler`).
3. **Migration Logic:**
   - Create migration script/file.
   - **REQUIRED:** Use the ORM/DB's standard migration tool (Drift, Room, Prisma, TypeORM, Alembic). Avoid raw SQL manual execution if possible.

### 3. Verification (Safety First)
- **Test Migration:**
  - AI must suggest (or write) a small test case to verify migration from version N to N+1.
- **Sanity Check:**
  - Run app to ensure no crash when accessing the Database.

## 🔌 Skill Integration

**Active skills:** `tech-lead`, `test-engineer`

**Skill roles:**
- **tech-lead:** Database schema expertise, ORM-specific knowledge.
- **test-engineer:** Migration testing strategy, data integrity verification.

**Application:**
- Step 1: `tech-lead` analyzes impact.
- Step 2: `tech-lead` guides implementation.
- Step 3: `test-engineer` designs verification tests.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Warning:** If User plans to delete a column/table, warn 3 times about data loss.
- **Version Control:** Always remind user to increment schema version if applicable.
