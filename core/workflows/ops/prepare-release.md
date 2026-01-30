---
description: "Release Engineering: Build, Test, and Audit before Production."
trigger: /prepare-release
version: "3.0.0"
skills: []
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Release ready", "Validation failed"]
---

# 🚀 Production Release Protocol

**Objective:** "Zero Critical Bugs" in Production environment.

## 🔄 Execution Flow

### 1. Pre-Flight Check
- **Version Audit:** Compare `pubspec.yaml` with latest git tag
 **Changelog Audit:** Ensure all new features are documented
- **Environment Audit:** Does production `.env` contain real keys? (NEVER commit keys to git)

### 2. Automated Validation
- Run validation pipeline:
  ```bash
  make clean && make gen
  flutter analyze --no-fatal-infos
  flutter test
  ```
- If any command fails → **ABORT RELEASE**

### 3. Manual Sanity Check (Smoke Test)
- Auditor (User) must confirm manual testing on real device:
  - [ ] App installable
  - [ ] Launches without crash
  - [ ] Login successful
  - [ ] Most critical feature works correctly

### 4. Build & Tag
- Suggest build command: `flutter build apk/ipa --release --obfuscate`
- Suggest git tag command: `git tag -a v1.0.0 -m "Release v1.0.0"`

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **Security:** Remind user to verify `proguard-rules.pro` (Android) if using code obfuscation
- **Assets:** Remind user to optimize images/icons to reduce app size