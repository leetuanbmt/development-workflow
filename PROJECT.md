# 🌍 Project Context: Gemini CLI Development Workflow

> **Type:** AI Agent Framework / Meta-CLI
> **Core Philosophy:** Auditor-First, Context-Aware, Self-Configuring.

## 1. Overview
This repository contains the **Brain (Knowledge Base)** and **Nervous System (Workflows)** for the Gemini CLI Agent. It is designed to be **Universal** - capable of adapting to any tech stack (Flutter, Node.js, Python, Rust, Go) through a dynamic setup process.

## 2. Architecture: "The Factory Pattern"
Instead of hardcoding rules for every language, we use a **Template & Hydration** architecture:

*   **`templates/`**: Contains generic logic with placeholders (e.g., `{{CMD_TEST}}`, `{{STACK_NAME}}`).
*   **`workflows/ops/setup.md`**: The "Compiler" that scans the target project, detects the stack, and fills in the templates.
*   **`.agent/`**: The runtime environment where the "hydrated" (customized) workflows and skills live.

## 3. Key Components
*   **Core Workflows:** `audit`, `review`, `fix`, `refactor` (Stack-aware logic).
*   **Ops Workflows:** `setup` (The initializer), `deploy`, `release`.
*   **Skills:**
    *   *Generic:* `tech-lead`, `code-reviewer`.
    *   *Dynamic:* `framework-expert` (Auto-generated based on detected stack).

## 4. Tech Stack (For this repo)
*   **Scripting:** Bash (Sync logic), Python (Helper scripts).
*   **Knowledge Format:** Markdown (System Instructions).
*   **Configuration:** TOML (Gemini CLI Commands).

## 5. Development Guidelines
*   **Never Hardcode:** Do not write "Flutter" or "Node" inside `templates/`. Use `{{STACK_NAME}}`.
*   **Conventions:** All placeholders must follow `{{KEY_NAME}}` format.
*   **Sync:** Always run `bash scripts/sync.sh` after modifying core templates.