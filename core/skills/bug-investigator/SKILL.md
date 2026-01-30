---
name: bug-investigator
description: Bug investigation and root cause analysis expert. Find root causes and propose sustainable bug fixes.
---

# Bug Investigator Skill

Use this skill when system encounters errors (crash, logic errors, incorrect UI display) and need to find root cause (Root Cause Analysis). Activate when detecting: "error", "bug", "crash", "not working", "stacktrace", "error log".

## 🚀 When to use
- When user reports behavior different from Spec
- When there's Error Log or Stacktrace from system
- When old feature suddenly breaks after new code update
- When need to analyze complex data flow to find breaking point

## 🛑 When NOT to use
- Don't use for reviewing new code (use `code-reviewer`)
- Don't use for designing new features (use `tech-lead` or specific architect skill)
- Don't use for performance optimization (use `tech-lead` or optimization skill)

## 💡 Example Triggers
- "Why does Kotei screen go blank when network is lost?"
- "Investigate this 'Null check operator used on a null value' error in this file"
- "App crashes when I click Save button, here's the error log..."
- "Find out why data isn't saving to Local DB"

## 🕵️ Investigation Methodology

### 1. Log Analysis
- Read error logs carefully
- Identify stacktrace and error line
- Check error type (NullPointerException, NetworkException, etc.)

### 2. Code Tracing
- Trace data flow: UI → State Management → UseCase → Repository → DataSource
- Identify where flow breaks
- Check state management (events, states, mutations)

### 3. Hypothesis Testing
- Ask "What if...": What if API returns null? What if network is slow?
- Check existing test cases for missed scenarios

## 📋 Investigation Report Structure

Investigation results must be presented clearly in 3 main parts:

### 1. Root Cause
- **Root Cause:** Pinpoint exactly which code, logic or configuration caused the error
- **Why:** Explain error mechanism (e.g., race condition, null reference, wrong business logic)

### 2. Impact Scope
- **Features:** Which features/screens are affected?
- **Severity:** Critical (Crash/Blocker) or Minor (UI Glitch)?
- **Propagation:** Risk of regression when fixing?

### 3. Fix Approach
- **Solution:** Propose clean fix following Clean Architecture
- **Code Change:** Snippet describing change (Suggestion)
- **Prevention:** Suggest test cases or refactoring to avoid recurrence

## 💡 AI Guidelines

**Language:** All investigation reports and analysis must be in **Vietnamese**, even though this skill documentation is in English.

- **NO CODE EDITING:** You are NOT ALLOWED to edit code files during investigation
- **READ ONLY:** Only use read tools (`read_file`, `search_file_content`, `glob`) to gather information
- **REPORT ONLY:** Your task ends when you submit the report. Bug fixing belongs to next step or different command
- Always check logs before hypothesizing
- When fixing bugs in State Management, pay attention to lifecycle and subscriptions
- Ensure bug fix doesn't break existing features (Regression checking)

## 🔌 Interface Definition

### Inputs
- **stacktrace** (text): Error log or Stacktrace
- **behavior** (text): User's description of error behavior

### Outputs
- **root_cause** (markdown): Root cause analysis
- **fix_plan** (markdown): Bug fix plan
