---
name: reverse-engineer-user-stories
description: Analyze a specific feature directory and reverse-engineer its business logic into standard User Stories. Use when the user asks to reverse-engineer a feature, extract user stories from code, or document business logic from an existing directory.
---

# Reverse Engineer User Stories

## Role
Act as a Technical Product Manager. Your task is to analyze a specific feature directory and reverse-engineer its business logic into standard User Stories.

## Instructions

1. **Target Feature:** Identify the target feature directory (e.g., `lib/features/auth`).
2. **Deep Scan:** 
   - Read the UI/Pages to understand what the user sees and clicks.
   - Read the BLoC/ViewModel to understand the state changes (Loading, Success, Error).
   - Read the Domain UseCases to understand the exact business rules.
3. **Generate User Stories:** Write down the features in Agile format:
   - *As a [User/Role], I want to [Action], so that [Value/Benefit].*
   - List the Acceptance Criteria (AC) based on the validations and error handling found in the code (e.g., "Must show error if password is < 8 chars").
4. **Identify Pain Points (Optional):** Note any missing edge cases or illogical flows you detect during the scan.

## Output Format
Create or update a markdown file named `USER_STORIES.md` inside the target feature's directory (e.g., `lib/features/auth/USER_STORIES.md`) or inside `.agent/memory/features/`.
Format it cleanly so it can be used for future debugging context.
