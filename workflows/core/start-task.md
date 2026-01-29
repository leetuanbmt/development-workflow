---
description: "Start new task with Auditor-grade analysis and planning."
trigger: /start-task
version: "3.0.0"
skills:
  - tech-lead
  - feature-architect
constraints:
  max_iterations: 3
  timeout_minutes: 20
  exit_on: ["Plan approved", "User declined"]
---

# 🚀 Start Task (Auditor Edition)

**Objective:** Transform raw requests into actionable plans.

## 🔄 Execution Flow

### 1. Context & Memory Loading
- **Memory Scan:** Check `.agent/memory/knowledge_base.md` for relevant lessons
- **Project Context:** Read `.agent/memory/PROJECT.md` to understand project goals

### 2. Mode Selection
Based on request, AI suggests one of 3 modes:
- **🔥 Hotfix:** Urgent bug fix. Skip detailed specs, focus on Fix & Verify.
- **🏗️ Feature:** New feature. Requires detailed plan (Layering, API, UI).
- **🧪 Prototype:** Experimentation. Fast code, accept technical debt (but must isolate).

### 3. Strategic Planning
AI must present a plan with 3 parts:
- **🎯 Objective:** What is the end goal? (Definition of Done).
- **⚠️ Risks & Constraints:** Any risks regarding architecture, performance, or security?
- **📋 Implementation Steps:** Specific action items (as a checklist).

### 4. User Confirmation
- Wait for Auditor (User) to approve the plan
- If approved → Move to execution (using `/fix`, `/implement`, etc.)

## 🔌 Skill Integration

This workflow automatically activates these skills based on task type:

- **tech-lead:** Strategic decisions, architecture guidance
- **feature-architect:** Feature design, layer breakdown

**Auto-activation rules:**
- If task involves "new feature" → Use `feature-architect` for design
- If task involves "refactoring" or "architecture" → Use `tech-lead` for guidance
- If task is "bug fix" → Delegate to `/fix` workflow with `bug-investigator`

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **No role-playing:** Skip the "Team Meeting Simulation". Act as a senior technical assistant reporting directly to the CTO.
- **Critical thinking:** If user's request is vague, ask clarifying questions instead of guessing.
