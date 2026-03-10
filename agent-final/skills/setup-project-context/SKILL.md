---
name: setup-project-context
description: Autonomously initialize a project's AI context by mapping structure, tracing flow, and generating memory artifacts.
---
# Skill: Setup Project Context

## Trigger Keywords
`setup context`, `initialize project`, `audit structure`, `create memory`, `project sync`

## Workflow
This skill executes a mandatory three-phase initialization plan.

### Phase 1: Structure Audit
- Read configuration files (`pubspec.yaml`, `package.json`, etc.) to identify the tech stack.
- Analyze the root and `lib/` (or `src/`) directories to recognize the architectural pattern.
- Locate main entry points.

### Phase 2: Logic & Flow Tracing
- Map out the top 3-5 core business features.
- Trace the application startup sequence starting from the entry point.
- Identify the data flow, state management, and routing solutions.

### Phase 3: Memory Generation
- Generate `PROJECT.md` outlining the app's purpose, target audience, and key features.
- Generate `ARCHITECTURE.md` detailing the tech stack, directory structure, and architectural rules.
- Generate `GLOSSARY.md` (optional) to list domain-specific terminology.
- Save all these files directly into the `.agent/memory/` directory.

## Rules & Constraints
- **Tool Usage:** Always use specific reading tools (`view_file`, `list_dir`) rather than generic shell commands (`cat`, `ls`).
- **Hallucination Prevention:** Do not guess tech stacks or architectures. Ground all findings in explicit config files and directory structures found in the workspace.
- **Incremental Reading:** Read files incrementally if they are large; rely on `grep_search` and `view_file` boundaries. Do not skip phases; they must be executed sequentially.
