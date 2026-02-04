---
description: "Audit code from multiple perspectives. Auto-select aspect based on context."
trigger: /audit
version: "5.2.0"
skills:
  - code-reviewer
  - tech-lead
constraints:
  max_iterations: 3
  timeout_minutes: 25
  exit_on: ["Audit report generated", "Plan approved"]
skill: tech-lead
---

# 🕵️ Unified Audit Mode

**Objective:** Deep analysis of code/feature from multiple angles before making changes.

## 🎯 Aspect Detection (Automatic)

| Keywords | Aspect | Focus |
|:---|:---|:---|
| `architecture`, `layer`, `dependency` | `architecture` | Clean Arch compliance |
| `security`, `token`, `api key` | `security` | Vulnerabilities |
| `tracking`, `analytics`, `event` | `analytics` | Event tracking |
| (default) | `general` | Logic, edge cases |

## 🚀 Execution Flow

### 1. Aspect Selection
- Analyze user request for keywords
- Select primary audit aspect
- May combine multiple aspects if needed

### 2. Deep Investigation
Run aspect-specific checks:

**Architecture Audit:**
- Layer separation (Data/Domain/Presentation)
- Dependency rule violations
- Circular dependencies

**Security Audit:**
- Hardcoded secrets
- Insecure data handling
- Authentication/authorization issues

**Analytics Audit:**
- Missing tracking events
- Inconsistent event naming
- Privacy compliance

**General Audit:**
- Business logic correctness
- Edge case handling
- Performance bottlenecks

### 3. Report & Recommendations
```markdown
## 🔍 Audit Report

**Aspect:** [architecture/security/analytics/general]
**Scope:** [Files/features audited]

### 🚨 Critical Issues
- [Issues that must be fixed]

### ⚠️ Warnings
- [Issues that should be addressed]

### 💡 Recommendations
- [Improvement suggestions]

**Decision:** [PROCEED / NEEDS REVISION / BLOCKED]
```

## 🔌 Skill Integration

**Active skills:** `code-reviewer`, `tech-lead`

**Skill assignment by aspect:**
- **Architecture audit:** `tech-lead` (primary) + `code-reviewer` (validation)
- **Security audit:** `code-reviewer` with security focus
- **Analytics audit:** `code-reviewer` with tracking focus
- **General audit:** Both skills collaborate

AI selects and applies appropriate skill(s) based on detected audit aspect.

## 💡 AI Guidelines

**Language:** All responses and reports must be in **Vietnamese**, even though this workflow is written in English.
- **No auto-fix:** Audit mode is analysis only
- **Evidence-based:** Reference specific code locations
- **Risk assessment:** Categorize by severity
