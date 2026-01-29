---
description: "Check Agent environment health & sync status."
trigger: /doctor
version: "1.0.0"
skills: []
constraints:
  max_iterations: 2
  timeout_minutes: 10
  exit_on: ["Check complete", "Auto-fix executed"]
---

# 🏥 Doctor Check (Environment & Sync Diagnostic)

**Objective:** Verify Agent environment integrity, sync status, and required tools. Detect "Out of Sync" or missing dependencies.

## 🚀 Execution Steps

1. **Run Diagnostic Script:**
   - **ACTION:** Execute `development-workflow/scripts/doctor.sh`
   - Script checks:
     - Required tools: `python3`, `melos`, `flutter`
     - Sync status: Compare checksum/timestamp between `development-workflow/rules` and `.agent/memory`
     - Directory structure: Verify `.gemini`, `.agent` and symlinks exist

2. **Analyze Results:**
   - Read script output
   - If errors found (❌), explain root cause to user
   - Suggest fix commands (e.g., `make sync`, `flutter pub get`)

3. **Auto-Fix (Optional):**
   - If error is "Out of Sync", ask user if they want to run Sync now
   - If agreed, execute `make sync`

4. **Smart Workflow Suggestions:**
   - Script auto-analyzes context and suggests relevant workflows:
     - BLoC/Cubit changes → `/write-test`
     - Data layer changes → `/audit`
     - Presentation changes → `/review`
     - Recent bug fixes → `/write-test` (regression tests)
     - Uncommitted changes → `/review`

## 📝 Script Logic (Reference)

Script `doctor.sh` performs these checks:

```bash
# 1. Check Tools
check_tool "flutter"
check_tool "melos"

# 2. Check Sync
compare_dirs "development-workflow/rules" ".agent/memory"
compare_dirs "development-workflow/skills" ".agent/skills"

# 3. Smart Suggestions
suggest_workflow  # Analyze git history & project patterns
```

## ⚠️ Important Notes
- Always prefer running `make sync` if there's any doubt about consistency
- Suggestions based on last 5 commits - requires git history

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- Provide clear diagnostics in Vietnamese
- Suggest fixes in user-friendly language
- Explain script output in detail
