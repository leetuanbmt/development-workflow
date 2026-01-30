---
description: "Create and maintain project documentation (Architecture, Flow, API)."
trigger: /document
version: "3.2.0"
skills:
  - tech-lead
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Documentation updated"]
---

# 📚 Living Documentation

**Objective:** "Living" Documentation - always updated alongside the code.

## 🔄 Execution Flow

### 1. Document Architecture
*   Use `codebase_investigator` (or `list_directory` + `read_file`) to map the current directory structure.
*   Analyze the relationships between modules/packages.
*   Update `.agent/memory/ARCHITECTURE.md` with the latest structure and high-level design.
*   Automatically detect new modules that are not yet documented.

### 2. Document Business Logic (Flow)
*   User selects a Feature (e.g., Auth, Checkout, Camera).
*   AI reads the relevant code and generates `mermaid` diagrams (Sequence Diagram, State Diagram, or Flowchart) describing the logic flow.
*   Save the documentation to `docs/features/<feature_name>.md`.

### 3. API & Data Model
*   Scan the codebase for API Endpoints (controllers, routes) and Data Models (entities, DTOs, schemas).
*   **For Backend:** List active API Endpoints (method, path, input/output).
*   **For Frontend/Mobile:** List Data Models and their mapping logic.
*   Update `docs/api/` or `docs/models/` as appropriate.

## 💡 AI Guidelines

**Language:** Documentation should be written in **English** (unless the user explicitly requests another language).
*   **Mermaid First:** Prioritize Mermaid diagrams over long textual descriptions.
*   **Context Links:** Always link to the actual code files in the documentation for easy reference.
*   **Keep it Sync:** Ensure the documentation reflects the *current* state of the code, not the planned state.