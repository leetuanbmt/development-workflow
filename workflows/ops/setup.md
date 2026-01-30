---
description: "Automatically detects Tech Stack, initializes Context, and Hydrates Workflows from Templates."
trigger: /setup
version: "4.3.0"
skills: 
  - tech-lead
constraints:
  max_iterations: 15
skill: tech-lead
---

# 🛠 Setup & Specialize Agent Environment

**Role:** Project Architect & System Configurator.
**Objective:** Analyze the project, define constants, and hydrate templates.

## 🔄 Execution Flow

### 1. Discovery (Scanning)
*   **Action:** Scan project for config files.
*   **Identify:** Language, Framework, Build Tool.

### 2. Define Configuration Constants
**AI must define these values based on the stack:**

| Constant | Description | Example (Flutter) | Example (Node) |
|:---|:---|:---|:---|
| `{{STACK_NAME}}` | Friendly Name | Flutter | Node.js (Express) |
| `{{CMD_TEST}}` | Test Command | `flutter test` | `npm test` |
| `{{CMD_BUILD}}` | Build Command | `flutter build apk` | `npm run build` |
| `{{CMD_LINT}}` | Lint Command | `flutter analyze` | `npm run lint` |
| `{{CMD_ROLLBACK}}` | Rollback Plan | `git revert...` | `git checkout...` |
| `{{LIB_TEST}}` | Test Framework | `flutter_test` | `Jest` |
| `{{LIB_MOCK}}` | Mocking Lib | `mocktail` | `jest.mock` |
| `{{FILE_VERSION}}`| Version File | `pubspec.yaml` | `package.json` |
| `{{FILE_ENV}}` | Env File | `.env` | `.env` |
| `{{DEPLOY_DEV_DESTINATION}}` | Dev Deploy Target | `Firebase App Dist` | `Vercel Preview` |
| `{{DEPLOY_PROD_DESTINATION}}` | Prod Deploy Target | `Google Play` | `Vercel Prod` |
| `{{STACK_ARCH_CHECK}}` | Arch Checklist | `BLoC/Cubit separation` | `Controller/Service separation` |
| `{{STACK_PERF_CHECK}}` | Perf Checklist | `Widget Rebuilds` | `Event Loop Blocking` |
| `{{STACK_SEC_CHECK}}` | Sec Checklist | `Proguard Rules` | `Helmet/CORS` |
| `{{COMMON_BUGS}}` | Bug Hints | `RenderFlex overflow` | `Unhandled Promise Rejection` |

### 3. Generate Context (`PROJECT.md`)
*   Create `.agent/memory/PROJECT.md` listing these constants for reference.

### 4. Expert Skill Generation
*   **Source:** `templates/skills/framework-expert.template.md`.
*   **Action:** Replace `{{STACK_NAME}}`, fill capabilities.
*   **Dest:** `.agent/skills/framework-expert/SKILL.md`.

### 5. Workflow Hydration (The Core Logic)
**Action:** Read templates, replace constants, and **SAVE TO .agent/workflows/**.

*   **Ops Workflows:**
    *   `templates/workflows/ops/deploy.template.md` -> `.agent/workflows/ops/deploy.md`
    *   `templates/workflows/ops/prepare-release.template.md` -> `.agent/workflows/ops/prepare-release.md`

*   **Core Workflows:**
    *   `templates/workflows/core/audit.template.md` -> `.agent/workflows/core/audit.md`
    *   `templates/workflows/core/fix.template.md` -> `.agent/workflows/core/fix.md`
    *   `templates/workflows/core/review.template.md` -> `.agent/workflows/core/review.md`
    *   `templates/workflows/core/investigate.template.md` -> `.agent/workflows/core/investigate.md`
    *   `templates/workflows/core/refactor.template.md` -> `.agent/workflows/core/refactor.md`

*   **Tech Workflows:**
    *   `templates/workflows/tech/write-test.template.md` -> `.agent/workflows/tech/write-test.md`

### 6. Finalize (IMPORTANT)
*   Run the sync script in **RUNTIME** mode to register the new workflows:
    ```bash
    bash scripts/sync.sh --runtime
    ```
*   **Report:** List the detected stack and configured commands.

## 📝 Output Template (Target: rules/01-project-context.md)

```markdown
---
trigger: always_on
description: Auto-generated technical context.
---

# 🌍 Project Context: [Project Name]

## 1. Tech Stack
*   **Stack:** {{STACK_NAME}}
*   **Version File:** {{FILE_VERSION}}

## 2. Hardcoded Commands
*   **Test:** `{{CMD_TEST}}`
*   **Build:** `{{CMD_BUILD}}`
*   **Lint:** `{{CMD_LINT}}`
```