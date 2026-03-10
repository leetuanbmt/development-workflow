---
description: "Implementation mode: Fast, high-throughput coding using Vibecoder skill."
trigger: /vibe
version: "5.2.0"
skills:
  - vibecoder
  - code-reviewer
---

# 🚀 Vibe Implementation (Heavy Lifting)

**Objective:** Execute the Job Briefs from `/start-task` using high-throughput coding and self-correction.

## 🔄 Execution Flow

### 1. Context Loading
*   **Analyze Job Briefs:** Read the `JOB-XXX` briefs generated in the previous step.
*   **Context Discovery:** Scan the relevant files and dependencies using `vibecoder`'s discovery logic.
*   **Pre-flight Check:** Run safety checks (secrets, critical files).

### 2. Heavy Implementation
*   **Multi-layer Coding:** Implement Data → Domain → Presentation layers in a single flow.
*   **Self-Correction:** Fix compilation or logic errors immediately during the process.
*   **Incremental Verification:** Run syntax/test checks after each major block.

### 3. Verification & Handover
*   **Final Audit:** Check against DOD (Definition of Done).
*   **Handover Report:** Generate the PR Summary and Verification results.

## 🔌 Skill Integration

**Active skill:** `vibecoder`

**How it works:**
1.  **Direct Execution:** Trigger the large context output and "Antigravity" mode.
2.  **Safety Gate:** `code-reviewer` validates the final logic before completion.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**.

*   **Go Big:** Don't be afraid to rewrite or create large modules.
*   **Error Recovery:** If you fail 2 times, stop and ask the Auditor for guidance.
*   **No Slop:** Ensure premium aesthetics and clean architecture.
