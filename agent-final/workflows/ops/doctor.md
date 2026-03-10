---
description: "Check Agent environment health & sync status."
trigger: /doctor
version: "5.2.0"
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
   - **ACTION:** Execute `.agent/scripts/doctor.sh`
   - Script checks:
     - Required tools: `python3`, `git`, `make` (and stack specific tools)
     - **Security tools:** `git-secrets`, `trufflehog` (recommended for safety enforcement)
     - Sync status: Compare checksum/timestamp between `development-workflow/rules` and `.agent/memory`
     - Directory structure: Verify `.gemini`, `.agent` and symlinks exist

2. **Config Override Check (Recommended):**


    - Kiểm tra sự tồn tại của `memory/config.override.json`
    - Nếu thiếu, khuyến nghị sao chép mẫu và tuỳ chỉnh:
      ```bash
      cp .agent/memory/config.override.example.json .agent/memory/config.override.json
      vim memory/config.override.json
      ```

3. **Analyze Results:**

- Read script output
- If errors found (❌), explain root cause to user
- Suggest fix commands (e.g., `make sync`, `npm install`, `flutter pub get`)

4. **Auto-Fix (Optional):**

- If error is "Out of Sync", ask user if they want to run Sync now
- If agreed, execute `make sync`

5. **Smart Workflow Suggestions:**

- Script auto-analyzes context and suggests relevant workflows:
  - State Management changes → `/write-test`
  - Data layer changes → `/audit`
  - Presentation changes → `/review`
  - Recent bug fixes → `/write-test` (regression tests)
  - Uncommitted changes → `/review`

## 📝 Script Logic (Reference)

Script `doctor.sh` performs these checks:

```bash
# 1. Check Tools
check_tool "git"
check_tool "make"

# 2. Check Sync
compare_dirs "development-workflow/rules" ".agent/memory"
compare_dirs "development-workflow/skills" ".agent/skills"

# 3. Smart Suggestions
suggest_workflow  # Analyze git history & project patterns

# 4. Config override presence (recommended)
if [ ! -f "memory/config.override.json" ]; then
  echo "[WARN] Missing memory/config.override.json — you can copy the example:" >&2
  echo "       cp .agent/memory/config.override.example.json memory/config.override.json" >&2
fi
```

## ⚠️ Important Notes

- Always prefer running `make sync` if there's any doubt about consistency
- Suggestions based on last 5 commits - requires git history

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.

- Provide clear diagnostics in Vietnamese
- Suggest fixes in user-friendly language
- Explain script output in detail
