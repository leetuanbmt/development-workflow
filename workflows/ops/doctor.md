---
description: "Check Agent environment health & sync status."
trigger: /doctor
version: "1.2.0"
skills:
  - tech-lead
constraints:
  max_iterations: 2
  timeout_minutes: 10
  exit_on: ["Check complete", "Auto-fix executed"]
skill: tech-lead
---

# 🏥 Doctor Check (Environment & Sync Diagnostic)

**Objective:** Verify Agent environment integrity, sync status, and required tools. Detect "Out of Sync" or missing dependencies.

## 🚀 Execution Steps

1. **Run Diagnostic Script:**
   - **ACTION:** Execute `scripts/doctor.sh` (relative to workflow root).
   - Script checks:
     - **Core Tools:** `python3`, `git`.
     - **Project Tools:** Detects and checks presence of `flutter`, `node`, `npm`, `yarn`, `go`, `cargo`, `pip`, etc. based on project type.
     - **Sync Status:** Compare checksum/timestamp between repo rules and `.agent/memory`.
     - **Directory Structure:** Verify `.gemini`, `.agent` and symlinks exist.

2. **Analyze Results:**
   - Read script output.
   - If errors found (❌), explain root cause to user.
   - Suggest fix commands (e.g., `make sync`, `npm install`, `flutter pub get`, `pip install -r requirements.txt`).

3. **Auto-Fix (Optional):**
   - If error is "Out of Sync", ask user if they want to run Sync now.
   - If agreed, execute the sync command.

4. **Smart Workflow Suggestions:**
   - Analyze context and suggest relevant workflows:
     - **Logic/Backend:** `/write-test`
     - **Architecture/Structure:** `/audit`
     - **UI/Frontend:** `/review`
     - **Recent Bugs:** `/write-test` (regression tests)
     - **Uncommitted Changes:** `/review`

## 📝 Script Logic (Reference)

Script `doctor.sh` performs these checks:

```bash
# 1. Check Core Tools
check_tool "git"
check_tool "python3"

# 2. Check Project Specific Tools (Auto-detected)
# if flutter project -> check_tool "flutter"
# if node project -> check_tool "node"

# 3. Check Sync
compare_dirs "core/rules" ".agent/memory"
compare_dirs "core/skills" ".agent/skills"

# 4. Smart Suggestions
suggest_workflow  # Analyze git history & project patterns
```

## ⚠️ Important Notes
- Always prefer running the project's sync command if there's any doubt about consistency.
- Suggestions based on last 5 commits - requires git history.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- Provide clear diagnostics.
- Suggest fixes in user-friendly language.
- Explain script output in detail.
