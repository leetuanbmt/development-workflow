---
description: "Automatically detects Tech Stack, initializes Context, and Hydrates Workflows from Templates."
trigger: /setup
version: "4.2.0"
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
*   **Check:** `stacks/<stack>/skills/framework-expert` (for curated skills).
*   **Fallback:** Generate from `templates/skills/framework-expert.template.md`.
    *   Replace `{{STACK_NAME}}` with detected stack.
    *   Fill in capabilities.
    *   Save to `.agent/skills/framework-expert/SKILL.md`.

### 5. Workflow Hydration (The Core Logic)
**Action:** Read templates, replace constants, and save to active workflows.

*   **Ops Workflows:**
    *   `deploy.md`: Replace `{{CMD_BUILD}}`, `{{DEPLOY_...}}`.
    *   `prepare-release.md`: Replace `{{CMD_LINT}}`, `{{CMD_TEST}}`, `{{FILE_VERSION}}`.

*   **Core Workflows:**
    *   `audit.md`: Replace `{{STACK_ARCH_CHECK}}`, `{{STACK_PERF_CHECK}}`, `{{STACK_SEC_CHECK}}`.
    *   `fix.md`: Replace `{{COMMON_BUGS}}`, `{{CMD_TEST}}`, `{{LIB_TEST}}`.
    *   `review.md`: Replace `{{CMD_LINT}}`, `{{STACK_ARCH_CHECK}}`.
    *   `investigate.md`: Replace `{{COMMON_BUGS}}`, `{{FILE_VERSION}}`.
    *   `refactor.md`: Replace `{{CMD_TEST}}`, `{{STACK_ARCH_CHECK}}`.

*   **Tech Workflows:**
    *   `write-test.md`: Replace `{{LIB_TEST}}`, `{{LIB_MOCK}}`.

### 6. Finalize
*   Run `bash scripts/sync.sh`.
*   **Report:** List the detected stack and the configured commands.

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
