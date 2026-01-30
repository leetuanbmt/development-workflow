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

# 🚀 Production Release Protocol

**Objective:** "Zero Critical Bugs" in Production environment.

## 🔄 Execution Flow

### 1. Pre-Flight Check
- **Version Audit:** Compare version in config (`pubspec.yaml`, `package.json`, `pom.xml`, etc.) with latest git tag.
- **Changelog Audit:** Ensure all new features are documented.
- **Environment Audit:** Does production `.env` (or secrets manager) contain real keys? (NEVER commit keys to git).

### 2. Automated Validation
**AI Action:** Detect Tech Stack and run appropriate validation pipeline.

*Examples:*
*   **Flutter:** `flutter analyze`, `flutter test`
*   **Node.js:** `npm run lint`, `npm run test`
*   **Python:** `ruff check`, `pytest`
*   **Go:** `go vet`, `go test ./...`

- If any command fails → **ABORT RELEASE**.

### 3. Manual Sanity Check (Smoke Test)
- Auditor (User) must confirm manual testing on real environment:
  - [ ] App installable / Site loads / API responds.
  - [ ] Launches without crash.
  - [ ] Critical flows (Login, Payment, Core Feature) work correctly.

### 4. Build & Tag
- Suggest build command appropriate for the stack (e.g., `flutter build appbundle`, `npm run build`, `docker build`).
- Suggest git tag command: `git tag -a v1.0.0 -m "Release v1.0.0"`.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **English**.
- **Security:** Remind user to verify code obfuscation/minification (Proguard, Terser, etc.).
- **Assets:** Remind user to optimize images/icons/bundles.
- **Dry Run:** Suggest a dry run of the build if possible.