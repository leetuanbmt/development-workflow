---
description: "Start a new project or feature using Product Vision -> Blueprint workflow."
trigger: /start-task
version: "5.2.0"
skills:
  - product-manager
  - tech-lead
constraints:
  max_iterations: 5
  timeout_minutes: 30
  exit_on: ["Blueprint approved", "Contract signed"]
skill: product-manager
---

# 🚀 Start Task (Product Vision Mode)

**Objective:** Transform raw ideas into executable Blueprints using the "Vision First" methodology.

## 🔄 Execution Flow

### 1. Vision Extraction (The "Proactive Proposal")
*   **Analyze Input:** Read the user's request.
*   **Detect Project Type:** (Landing Page / SaaS / Dashboard / Blog / Portfolio / Custom).
*   **Generate Vision:** IMMEDIATELY propose a draft Vision based on the detected type (using `product-manager` skill).
    *   **Layout:** Suggested sections/screens.
    *   **Style:** Suggested aesthetic.
    *   **Tech Stack:** Recommended stack based on project context (or defaults).
*   **Ask for Context:** Ask 3-5 specific questions to refine the Vision (e.g., "Who is the target audience?", "What is the primary metric?").

### 2. Context Refinement
*   **Receive Context:** User answers the questions.
*   **Refine Vision:** Update the proposal based on user input.
*   **Verify:** Ask for confirmation before moving to the Blueprint phase.

### 3. Blueprint Design
*   **Generate Blueprint:** Create a detailed architectural plan including:
    *   **Modules & Flows:** How data moves.
    *   **File Structure:** Key directories and files.
    *   **Data Models:** Key entities.
*   **Generate Contract:** Define the Scope (In/Out) and Definition of Done (DoD).

### 4. Approval & Handover
*   **User Approval:** Wait for the user to type "APPROVED" or "AGREE".
*   **Generate Job Briefs:** Break down the Contract into atomic `JOB-XXX` briefs for the Coder (`vibecoder`).
*   **Next Step:** Suggest running `/vibe` with the generated briefs or the Job Brief ID.

## 🔌 Skill Integration

**Active skill:** `product-manager`

**How it works:**
1.  **Step 1 & 2:** Uses `product-manager` to access Product Templates and ask strategic questions.
2.  **Step 3:** Uses `tech-lead` (if needed) for deep technical architecture validation.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese** (unless requested otherwise).

*   **Be Proactive:** Do NOT ask "What do you want to build?". Say "I see you want a Landing Page. Here is a high-converting template. Does this fit?"
*   **Blueprint is Law:** Once the Blueprint is signed, do not change architecture during the build phase without a formal update.
