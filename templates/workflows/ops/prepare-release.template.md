---
description: "Release Engineering: Build, Test, and Audit before Production."
trigger: /prepare-release
version: "3.2.0"
skills:
  - tech-lead
  - security-auditor
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Release ready", "Validation failed"]
---

# 🚀 Production Release Protocol ({{STACK_NAME}})

**Objective:** "Zero Critical Bugs" in Production environment.

## 🔄 Execution Flow

### 1. Pre-Flight Check
- **Version Audit:** Check version file at `{{FILE_VERSION}}` vs git tag.
- **Changelog Audit:** Ensure all new features are documented.
- **Environment Audit:** Check `{{FILE_ENV}}` for exposed secrets.

### 2. Automated Validation
**AI Action:** Run the following validation commands:

1.  **Lint/Analyze:**
    ```bash
    {{CMD_LINT}}
    ```
2.  **Test:**
    ```bash
    {{CMD_TEST}}
    ```

- If any command fails → **ABORT RELEASE**.

### 3. Manual Sanity Check
- [ ] Application launches successfully.
- [ ] Critical flows work.

### 4. Build & Tag
- **Build Command:** `{{CMD_BUILD}}`
- **Tag Command:** `git tag -a vX.Y.Z -m "Release vX.Y.Z"`

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Validation:** Force the user to run `{{CMD_TEST}}` before approving.
