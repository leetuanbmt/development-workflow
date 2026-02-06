# 🧠 Gemini CLI: AI-Native Development Workflow

An intelligent, context-aware workflow engine for Gemini CLI. It transforms a standard LLM into a **Senior Technical Lead** & **QA Architect** that adapts to *your* specific project.

---

## 🚀 Key Features

### 1. 🧬 Universal Stack Support (New in v4.0)
Works with **ANY** technology stack.
*   **Flutter?** It auto-detects `pubspec.yaml`, installs `flutter-expert`, and configures `flutter test`.
*   **Node.js?** It sees `package.json`, installs `node-expert`, and binds `npm run test`.
*   **Rust/Go/Python?** It auto-generates expert skills and pipelines for them instantly.

### 2. 🛡️ Auditor-First Mindset
The AI never commits code silently. It operates in **Audit Mode**:
*   **Plan > Code:** AI must propose a plan and get approval.
*   **Verify > Trust:** Every fix includes mandatory verification steps.
*   **Safety Net:** Automated rollbacks and pre-flight checks.

### 3. 🏭 Template-Based Architecture
We use a "Hydration" process to customize workflows:
*   `deploy.template.md` (`{{CMD_BUILD}}`)  ➡️  `/setup`  ➡️  `deploy.md` (`npm run build`)

### 4. 🚀 Vibe Coding & Agent Skills (New in v4.1)
*   **Vibe Coding:** High-throughput implementation (2000+ lines) with self-correction and automated safety hooks.
*   **Agent Skills:** 10+ core expert skills (Tech Lead, Security Auditor, etc.) that auto-activate based on task context.
*   **Verification Loop:** A mandatory 4-phase quality gate (Syntax, Logic, Integration, Security) for all code changes.

---

## 📦 Installation & Setup

### 1. Sync the Environment
Run this in your project root to link the brain to your agent:
```bash
./development-workflow/scripts/sync.sh
```

### 2. Initialize & Specialize
Run the magic command inside Gemini CLI:
```text
/setup
```
**What happens next?**
1.  Agent scans your codebase.
2.  Detects your Tech Stack (e.g., "Next.js").
3.  **Generates** a custom `framework-expert` skill for Next.js.
4.  **Rewrites** all workflows (`/fix`, `/test`, `/deploy`) to use your specific commands (`npm`, `jest`, etc.).

---

## 🛠 Available Workflows

### 🎯 Quick Reference Table

| Command | Use When | Output |
|:---|:---|:---|
| **/setup** | First time setup or stack change | Configured agent + custom skills |
| **/start-task** | Starting new feature/project | Blueprint + Job briefs |
| **/fix** | Bug needs systematic fix | Root cause fix + tests |
| **/investigate** | Need to understand bug cause | Investigation report (NO fix) |
| **/review** | Before merge or commit | Quality report with scores |
| **/audit** | Deep analysis needed | Multi-aspect audit report |
| **/refactor** | Code needs restructuring | Safe refactoring plan |
| **/vibe** | High-speed implementation | Complete feature (2000+ lines) |
| **/deploy** | Ready to ship | Deployed to target env |
| **/doctor** | Agent acting weird | Health check report |
| **/write-test** | Need test coverage | Unit/Widget/Integration tests |
| **/integrate-api** | New API endpoint | Model + Entity + Mapper |
| **/manage-db** | Database schema change | Migration files |
| **/prepare-release** | Pre-production checklist | Release audit report |
| **/document** | Need docs/diagrams | Architecture/Flow/API docs |

---

### 📚 Detailed Scenarios

#### 🌟 Core Workflows

<details>
<summary><strong>/setup</strong> - Initialize Agent for Your Stack</summary>

**When to use:**
- First time using this workflow system
- Switching to a different tech stack
- After major dependency updates

**Example scenario:**
```text
You: /setup

AI: 
🔍 Detected Tech Stack: Flutter 3.19.0
📦 Generating flutter-expert skill...
⚙️  Hydrating workflows with:
    - CMD_TEST: flutter test
    - CMD_BUILD: flutter build apk
    - CMD_LINT: flutter analyze
✅ Setup complete! Available commands: /fix, /test, /deploy
```

**What happens:**
1. Scans `pubspec.yaml`, `package.json`, etc.
2. Creates custom `framework-expert` skill
3. Rewrites all workflows with your commands
4. Syncs configuration to `.gemini/`

</details>

<details>
<summary><strong>/start-task</strong> - Plan New Feature/Project</summary>

**When to use:**
- Starting a new feature
- Building a new project from scratch
- Need architectural blueprint

**Example scenario:**
```text
You: Tôi cần build trang Landing Page cho startup AI

AI:
🎨 Vision Draft:
- Layout: Hero + Features + Pricing + CTA
- Style: Glassmorphism + Dark mode + Gradient accents
- Stack: Next.js 14 + Tailwind + Framer Motion

❓ Context Questions:
1. Target audience: B2B hay B2C?
2. Primary metric: Lead gen hay Direct sale?
3. Có cần multilingual không?

[After your answers...]

📋 Blueprint Generated:
- Modules: Hero, Features, Pricing, Contact
- Data Models: Lead, PricingPlan
- File Structure: /app, /components, /lib

✅ Contract: 5 screens, 3 API endpoints, 2 weeks
Type "APPROVED" to generate Job Briefs for /vibe
```

**Output:** Blueprint + Contract + Job Briefs

</details>

<details>
<summary><strong>/fix</strong> - Systematic Bug Fixing</summary>

**When to use:**
- Bug is reproducible
- Need root cause fix (not quick patch)
- Want verification included

**Example scenario:**
```text
You: /fix
Camera preview bị crash khi rotate device

AI:
🔍 Investigation (2 min):
- Stacktrace: NullPointerException in CameraController.dispose()
- Root Cause: Lifecycle not handling orientation change
- Affected: camera_page.dart line 145

📋 Fix Plan:
Files: camera_page.dart, camera_controller.dart
Approach: Add didChangeAppLifecycleState listener
Risks: May affect battery usage
Testing: Rotate test on 3 devices

⏸️  WAITING FOR APPROVAL...

You: ok

AI:
✅ Fix applied
🧪 Running: flutter test test/camera_test.dart
✅ All tests passed (12/12)
📱 Manual test: Rotate device 10 times - No crash
```

**Output:** Root cause fix + Tests + Verification

</details>

<details>
<summary><strong>/investigate</strong> - Bug Analysis Only</summary>

**When to use:**
- Need to understand bug before fixing
- Want detailed analysis report
- Planning complex fix strategy

**Example scenario:**
```text
You: /investigate
Upload photos fail randomly (30% rate)

AI:
📊 Investigation Report:

Root Cause Analysis:
1. Network timeout (15s) too short for large files
2. No retry mechanism on 5xx errors
3. Memory spike when processing 10+ photos

Evidence:
- Logs show "SocketException" in 28% cases
- Heap dump: 450MB spike during batch upload
- Server returns 503 during peak hours

Recommendation:
- Increase timeout to 60s
- Add exponential backoff retry
- Implement chunked upload for >5MB files

⚠️  This is ANALYSIS ONLY. Run /fix to implement.
```

**Output:** Investigation report (NO code changes)

</details>

<details>
<summary><strong>/review</strong> - Code Quality Check</summary>

**When to use:**
- Before committing changes
- Reviewing Pull Request
- Quality gate before merge

**Example scenario:**
```text
You: /review origin/feature/login

AI:
🔄 Fetching latest code from origin...
🔍 Smart Scope: 5 changed files (ignored 12 generated files)

📊 Review Report:

✅ Strengths:
- Clean Architecture followed
- Good null safety

🚨 Critical Issues:
| Severity | File:Line | Issue | Fix |
|:---|:---|:---|:---|
| High | button.dart:23 | Hardcoded #FF5733 | Use hsl(12, 95%, 60%) |
| High | api.dart:45 | No timeout | Add .timeout(30s) |
| Medium | list.dart:12 | No empty check | Add if(items.isEmpty) |

🛡️ Edge Case Coverage: 🟡 YELLOW (3/5)
- ❌ No network timeout
- ❌ No auth check in deleteUser()

**Overall: NEEDS WORK** (Fix 2 critical issues)
```

**Output:** Quality report with actionable fixes

</details>

<details>
<summary><strong>/audit</strong> - Deep Multi-Aspect Analysis</summary>

**When to use:**
- Pre-production review
- Security assessment needed
- Performance optimization required

**Example scenario:**
```text
You: /audit security

AI:
🔐 Security Audit Report:

Critical Vulnerabilities:
1. SQL Injection risk in search_query.dart:34
   - Current: "SELECT * FROM users WHERE name='$input'"
   - Fix: Use parameterized queries

2. Hardcoded API key in config.dart:12
   - Move to .env file + add to .gitignore

3. No rate limiting on /api/upload
   - Add: express-rate-limit (100 req/15min)

Medium Risks:
- CORS allows all origins (*)
- JWT token never expires

Score: 🔴 45/100 (BLOCK PRODUCTION)
```

**Output:** Aspect-specific audit (Security/Arch/Perf)

</details>

<details>
<summary><strong>/refactor</strong> - Safe Code Restructuring</summary>

**When to use:**
- Code smells detected
- Need to improve maintainability
- Extract reusable components

**Example scenario:**
```text
You: /refactor
Extract authentication logic from all pages

AI:
📋 Refactoring Plan:

Target: 8 files with duplicated auth logic
Strategy: Extract to AuthService + AuthGuard

Changes:
1. Create: lib/core/auth/auth_service.dart
2. Create: lib/core/auth/auth_guard.dart
3. Modify: 8 page files (remove 120 lines each)

Safety:
- All existing tests will pass
- No API contract changes
- Backward compatible

⏸️  APPROVE to proceed?

You: yes

AI:
✅ Refactoring complete
🧪 Tests: 45/45 passed
📊 Code reduction: -960 lines
```

**Output:** Refactored code + Tests still passing

</details>

<details>
<summary><strong>/vibe</strong> - High-Speed Implementation</summary>

**When to use:**
- Have clear Job Brief
- Need complete feature fast
- Trust AI for full implementation

**Example scenario:**
```text
You: /vibe JOB-003

AI:
🚀 Vibecoder Mode: Activated
📋 Job: Implement User Profile Screen

[Generates 2000+ lines in one shot:]
✅ profile_page.dart (450 lines)
✅ profile_bloc.dart (320 lines)
✅ profile_state.dart (180 lines)
✅ profile_event.dart (150 lines)
✅ profile_repository.dart (280 lines)
✅ profile_test.dart (620 lines)

🛡️ Defensive checks applied:
- Null safety on all user fields
- Network timeout (30s)
- Loading states
- Error boundaries

🧪 Self-verification:
✅ Syntax: 0 errors
✅ Tests: 24/24 passed
✅ Security: No secrets exposed

Ready for review!
```

**Output:** Complete feature with tests

</details>

#### ⚙️ Operational Workflows

<details>
<summary><strong>/deploy</strong> - Build & Deploy</summary>

**When to use:**
- Ready to deploy to Dev/Staging/Prod
- Need automated deployment
- Want safety checks before deploy

**Example scenario:**
```text
You: /deploy staging

AI:
🚀 Deployment Pipeline: Staging

Pre-flight Checks:
✅ All tests passed (156/156)
✅ No uncommitted changes
✅ Branch: feature/user-profile
⚠️  Warning: 2 TODO comments found

Build:
🔨 Running: flutter build apk --release
✅ Build successful (2m 34s)
📦 Size: 24.5 MB (within 30MB limit)

Deploy:
🚀 Uploading to Firebase App Distribution...
✅ Deployed to: staging-v1.2.3
🔗 URL: https://staging.app.com

Smoke Test:
✅ App launches
✅ Login works
✅ API health check passed
```

**Output:** Deployed app + Health check

</details>

<details>
<summary><strong>/doctor</strong> - Health Check</summary>

**When to use:**
- Agent behaving unexpectedly
- After system updates
- Periodic maintenance check

**Example scenario:**
```text
You: /doctor

AI:
🏥 Agent Health Check

Environment:
✅ .gemini/ directory exists
✅ Workflows synced (15/15)
✅ Skills loaded (11/11)
⚠️  PROJECT.md outdated (last update: 30 days ago)

Dependencies:
✅ Git version: 2.39.0
✅ Flutter: 3.19.0
❌ Node.js: NOT FOUND (required for some workflows)

Recommendations:
1. Install Node.js 18+ for /deploy workflow
2. Run /setup to refresh PROJECT.md

Overall: 🟡 HEALTHY (1 warning)
```

**Output:** Health report + Fix suggestions

</details>

<details>
<summary><strong>/prepare-release</strong> - Pre-Production Checklist</summary>

**When to use:**
- Before production release
- Need comprehensive audit
- Want release confidence score

**Example scenario:**
```text
You: /prepare-release v2.0.0

AI:
📋 Release Readiness Audit

Build Quality:
✅ All tests passed (234/234)
✅ Code coverage: 87% (target: 80%)
✅ No critical bugs

Security:
✅ No secrets in code
✅ Dependencies up-to-date
⚠️  1 medium vulnerability in lodash@4.17.20

Performance:
✅ App size: 28MB (< 30MB)
✅ Cold start: 1.2s (< 2s)
❌ Memory leak detected in ImageCache

Compliance:
✅ Privacy policy updated
✅ Terms of service reviewed
✅ GDPR compliant

Score: 🟡 82/100 (APPROVED with warnings)

Action Items:
1. Fix memory leak in ImageCache
2. Update lodash to 4.17.21

Approve release? (yes/no)
```

**Output:** Release audit + Go/No-Go decision

</details>

#### 🔧 Technical Workflows

<details>
<summary><strong>/write-test</strong> - Generate Tests</summary>

**When to use:**
- Need test coverage
- TDD approach
- Regression test needed

**Example scenario:**
```text
You: /write-test lib/features/auth/login_bloc.dart

AI:
🧪 Test Strategy: Bloc Testing

Generated Tests:
✅ login_bloc_test.dart (18 test cases)

Coverage:
- Happy path: Login success
- Error cases: Wrong password, Network error
- Edge cases: Empty input, Special characters
- State transitions: Initial -> Loading -> Success

Running tests...
✅ 18/18 passed

Code coverage: 95% (login_bloc.dart)
```

**Output:** Test files + Coverage report

</details>

<details>
<summary><strong>/integrate-api</strong> - API Integration</summary>

**When to use:**
- New API endpoint to integrate
- Need Clean Architecture layers
- Want type-safe models

**Example scenario:**
```text
You: /integrate-api
POST /api/users/profile
Response: {"user_id": 123, "full_name": "John", "avatar_url": null}

AI:
📋 Code Generation Plan:

1. user_profile_model.dart (Data Layer)
2. user_profile_entity.dart (Domain Layer)
3. user_profile_mapper.dart (Mapper)

Generated Code:
✅ Null safety: avatar_url is String?
✅ Naming: user_id -> userId (camelCase)
✅ Mapper: null avatar -> default placeholder

Verification:
- Does full_name allow empty string? (Y/N)
- Should null avatar map to "" or keep null?

You: Y, keep null

AI: ✅ Code updated. Ready to use!
```

**Output:** Model + Entity + Mapper

</details>

<details>
<summary><strong>/manage-db</strong> - Database Management</summary>

**When to use:**
- Schema changes needed
- Migration required
- Data integrity concerns

**Example scenario:**
```text
You: /manage-db
Add "email_verified" column to users table

AI:
🗄️ Migration Plan:

Safety Checks:
✅ Backup strategy: Auto-backup before migration
⚠️  Impact: 10,000 existing users

Migration:
1. Add column: email_verified BOOLEAN DEFAULT false
2. Backfill: Set true for users with verified_at IS NOT NULL
3. Add index: CREATE INDEX idx_email_verified ON users(email_verified)

Rollback Plan:
- DROP COLUMN email_verified

Estimated time: 2 minutes
Approve? (yes/no)

You: yes

AI:
✅ Migration applied
✅ 10,000 rows updated
✅ Index created
```

**Output:** Migration files + Execution

</details>

<details>
<summary><strong>/document</strong> - Generate Documentation</summary>

**When to use:**
- Need architecture diagrams
- API documentation required
- Onboarding new developers

**Example scenario:**
```text
You: /document architecture

AI:
📚 Documentation Generated:

1. ARCHITECTURE.md
   - System overview
   - Layer diagram (Presentation -> Domain -> Data)
   - Module dependencies

2. FLOW_DIAGRAMS.md
   - User authentication flow
   - Data sync flow
   - Error handling flow

3. API_REFERENCE.md
   - All endpoints documented
   - Request/Response examples
   - Error codes

Saved to: .agent/memory/
```

**Output:** Markdown docs + Diagrams

</details>

---

### 🎓 Learning Path

**New to the system?** Follow this sequence:

1. **Start:** `/setup` - Configure your environment
2. **Learn:** `/doctor` - Verify everything works
3. **Plan:** `/start-task` - Create your first blueprint
4. **Build:** `/vibe` - Implement the feature
5. **Check:** `/review` - Quality gate
6. **Ship:** `/deploy` - Deploy to staging

**Daily workflow:**
```text
Morning: /doctor (health check)
Feature: /start-task -> /vibe -> /write-test
Bug: /investigate -> /fix
Before commit: /review
Before deploy: /prepare-release -> /deploy
```

---

## 📂 Project Structure

```text
development-workflow/
├── templates/           # 🧩 Universal Logic (with {{PLACEHOLDERS}})
│   ├── skills/          # Expert skill templates
│   └── workflows/       # Workflow templates (deploy, test, fix...)
├── workflows/           # ⚙️ The Engine (setup.md, etc.)
├── skills/              # 🧠 Core Skills (Tech Lead, Reviewer)
├── core/                # 📜 Rules & Conventions
└── scripts/             # 🔧 Sync & Maintenance utilities
```

## 🤝 Contributing

1.  **Do not hardcode:** If adding a new workflow, use `{{PLACEHOLDERS}}`.
2.  **Update `setup.md`:** If adding a new placeholder, update the hydration logic in `workflows/ops/setup.md`.
3.  **Test:** Run `./scripts/doctor.sh` to verify integrity.