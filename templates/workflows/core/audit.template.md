---
description: "Audit code from multiple perspectives (Architecture, Security, Performance)."
trigger: /audit
version: "2.2.0"
skills:
  - code-reviewer
  - tech-lead
constraints:
  max_iterations: 3
  timeout_minutes: 25
  exit_on: ["Audit report generated"]
skill: tech-lead
---

# 🕵️ Unified Audit Mode ({{STACK_NAME}})

**Objective:** Deep analysis of code/feature using **{{STACK_NAME}}** best practices.

## 🎯 Aspect Detection

| Aspect | Focus | {{STACK_NAME}} Specifics |
|:---|:---|:---|
| `architecture` | Clean Arch | {{STACK_ARCH_CHECK}} |
| `performance` | Optimization | {{STACK_PERF_CHECK}} |
| `security` | Vulnerabilities | {{STACK_SEC_CHECK}} |
| `general` | Logic | Standard Logic |

## 🚀 Execution Flow

### 1. Deep Investigation
Run aspect-specific checks:

**Architecture Audit:**
- Layer separation.
- Check for **{{STACK_ARCH_CHECK}}**.

**Performance Audit:**
- Big O analysis.
- Check for **{{STACK_PERF_CHECK}}**.

### 2. Report & Recommendations
Generate report flagging critical issues.

## 💡 AI Guidelines
- **Evidence-based:** Reference specific code locations.
- **Context:** Use `framework-expert` skill for deep {{STACK_NAME}} insights.
