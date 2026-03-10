# Core Behavior & Conventions

> **Always-on rules. AI reads this at the start of every session.**

---

## 1. Accuracy & Grounding

- **No hallucinations.** Never assume file paths, variable names, or logic. If unsure → ask.
- **All suggestions must be based on actual code** in the project, not generic patterns.
- **Verify before modifying.** Read the target file before editing it.

---

## 2. Atomic Execution Strategy

- **Divide & Conquer:** Never write an entire large feature in one response.
- **150-line rule:** If estimated output exceeds 150 lines, split into sub-tasks. Complete one layer (e.g., Domain), checkpoint with user, then proceed to next (Data, then Presentation).
- **Code Gen Checkpoint:** When trigger files change (e.g., `@freezed`, `@injectable`, `@RestApi` annotations), STOP and ask user to run `[code_gen_command]`. Only continue after user confirms.
- **Checkpoint after each file:** Pause to confirm status before the next significant change.

---

## 3. Proactive Memory

After every bug fix or significant discovery, AI must prompt:

> *"I noticed an important lesson: [X]. Should I save this to the Knowledge Base?"*

If user agrees → append structured entry to `memory/knowledge_base.md` (if it exists).

---

## 4. Team Simulation (Standard Mode)

For complex tasks, AI simulates a team discussion before coding:

```
🟢 START: /start-task [Task Name]
   Context: [Intent, Mode, relevant memory]

─────────────────────────────────

🗣️ Phase 1: Team Brainstorming

  🤖 Tech Lead (Moderator): Frames the problem, drives discussion
  🕵️ QA Lead: Risk assessment — "What could go wrong?"
  🏛️ Architect: Technical solution, library choices, patterns
  🧑‍💼 BA: User perspective, business value, edge cases
  🤖 Moderator (Conclusion): Confirms DoR status, next steps

─────────────────────────────────

🛑 Phase 2: Action Proposal
  - Summary of open questions
  - Recommended next command
  - Waiting for your input...
```

---

## 5. Skill Orchestration (Auto-Dispatch)

When receiving a request, AI must:

1. Scan keywords in user input
2. Match to ORCHESTRATOR dispatch table
3. Load the matched skill's SKILL.md
4. Apply skill perspective and guidelines
5. Report at end: `🎭 Skills used: [skill-name, ...]`

---

## 6. Language Policy

- **AI responses:** In the language configured in `memory/PROJECT.md` → `ai_response_language`
- **Code, variables, comments:** Always in English
- **Workflow commands:** Always in English (`/start-task`, `/implement-feature`, etc.)

---

## 7. DoR Gate (Standard Mode)

Before starting `/implement-feature`:

- [ ] Requirement clear (User Story + ≥3 Acceptance Criteria)
- [ ] Design/UI described (mockup, states, or detailed description)
- [ ] API contract documented (if feature calls external API)
- [ ] Assets available (icons, images, or placeholders agreed upon)

**If DoR not met → Refuse to code. Redirect to `/write-spec` or ask clarifying questions.**

---

## 8. Quality Non-Negotiables

These are never skipped regardless of mode:

- Lint must pass before any PR
- No hardcoded secrets or credentials ever
- Error states must be handled in every async operation
- `context.mounted` check after every async gap in Flutter widgets
