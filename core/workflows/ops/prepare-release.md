---
description: "Release Engineering: Build, Test, and Audit before Production."
trigger: /prepare-release
version: "5.2.0"
skills:
  - tech-lead
  - security-auditor
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Release ready", "Validation failed"]
---

# 🚀 Production Release Protocol

**Objective:** "Zero Critical Bugs" in Production environment.

## 🔄 Execution Flow

### 1. Pre-Flight Check
- **Version Audit:** Compare Dependency Manifest (e.g., `pubspec.yaml`, `package.json`) with latest git tag
- **Changelog Audit:** Ensure all new features are documented
- **Environment Audit:** Does production environment config contain real keys? (NEVER commit keys to git)

### 2. Automated Validation
- Run validation pipeline:
  ```bash
  # Example:
  make clean && make build
  make analyze
  make test
  ```
- If any command fails → **ABORT RELEASE**

### 3. Manual Sanity Check (Smoke Test)
- Auditor (User) must confirm manual testing on real device:
  - [ ] App installable
  - [ ] Launches without crash
  - [ ] Login successful
  - [ ] Most critical feature works correctly

### 4. Build & Tag
- Suggest build command: `[Build Command] --release`
- Suggest git tag command: `git tag -a v1.0.0 -m "Release v1.0.0"`

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Security:** Remind user to verify obfuscation rules (if applicable)
- **Assets:** Remind user to optimize assets to reduce artifact size