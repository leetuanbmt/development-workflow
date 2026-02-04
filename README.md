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

| Command | Description | Stack-Awareness |
|:---|:---|:---|
| **/setup** | **Start Here.** Auto-detects stack & configures agent. | 🌟 Core |
| **/start-task** | Plan a new feature or bug fix. | ✅ Yes |
| **/audit** | Deep code analysis (Arch, Security, Perf). | ✅ Yes |
| **/fix** | Systematic bug fixing (Investigate -> Plan -> Fix). | ✅ Yes |
| **/review** | Code review for PRs or local changes. | ✅ Yes |
| **/deploy** | Build & Deploy with safety checks. | ✅ Yes |
| **/doctor** | Check agent health and project sync status. | ❌ No |

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