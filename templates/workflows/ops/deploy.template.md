---
description: "Build and deploy application to environments (Dev/Staging/Production)."
trigger: /deploy
version: "3.0.0"
skills:
  - tech-lead
constraints:
  max_iterations: 3
  timeout_minutes: 15
  exit_on: ["Deploy complete", "Rollback executed", "User cancelled"]
---

# 🚀 Deploy Application (Stack: {{STACK_NAME}})

**Objective:** Guide safe build and deploy process with version control and rollback plan.

## ⚠️ Prerequisites

> [!IMPORTANT]
> Before deploying, ensure `/prepare-release` checklist is complete.

**Required checks:**
- [ ] Code merged to target branch.
- [ ] All tests passed (CI/CD check).
- [ ] Version bumped.
- [ ] CHANGELOG.md updated.

## 🚀 Deployment Steps

### 1. Build Application

**Target Command:** `{{CMD_BUILD}}`

*User Action:* Execute the build command above.

### 2. Verify Build Artifacts
- [ ] File size reasonable (no sudden increase).
- [ ] Version number matches the tag.
- [ ] Environment variables injected correctly.

### 3. Upload & Distribute ({{STACK_NAME}} Specific)

**Action:** Upload the built artifact to the appropriate registry/store.

*   **Dev/Staging:** {{DEPLOY_DEV_DESTINATION}}
*   **Production:** {{DEPLOY_PROD_DESTINATION}}

### 4. Post-Deploy Verification
- [ ] App/Site accessible.
- [ ] Smoke test main features.
- [ ] Check crash logs.

## 🔄 Rollback Plan

**Command:** `{{CMD_ROLLBACK}}` (or git revert)

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Strictness:** Do not proceed if `{{CMD_BUILD}}` fails.
- **Safety:** Always verify artifacts before uploading.
