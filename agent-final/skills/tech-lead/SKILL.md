---
name: "tech-lead"
description: "Technical leadership, strategy, and complex problem solving."
inputs:
  - name: "problem"
    type: "text"
    desc: "Technical problem or architectural challenge"
  - name: "constraints"
    type: "text"
    desc: "Project constraints"
outputs:
  - name: "decision"
    type: "markdown"
    desc: "Technical Decision (ADR)"
  - name: "guideline"
    type: "markdown"
    desc: "Implementation guidelines"
---

# Tech Lead Skill

Senior technical leadership for architectural decisions and team guidance.

## 🚀 When to use
- Strategic technical decisions
- Architecture compliance enforcement
- Code standard definition
- Team mentoring needs

## 🛑 When NOT to use
- Simple bug fixes (use `bug-investigator`)
- Routine code review (use `code-reviewer`)
- Implementation tasks (use specific technical skills)

## 💡 Core Capabilities

### 1. Technical Strategy ([PROJECT_NAME] Context)
- **Stack Enforcement:** Strictly enforce the existing stack (Flutter, Clean Architecture 3-layers, `flutter_bloc`, `injectable`, `drift`, `retrofit`, `auto_route`). Do NOT propose alternative macro-architectures.
- **Architecture patterns selection:** Decide how new features fit into the defined Data/Domain/Presentation setup.
- **Technical roadmap planning:** Plan migrations, package updates, or DB schema changes.

### 2. Code Standards
- Define coding conventions
- Establish best practices
- Review architecture designs

### 3. Problem Solving
- Complex technical challenges
- Architecture trade-offs
- Performance vs maintainability balance

### 4. Team Guidance
- Mentor junior developers
- Knowledge sharing
- Technical documentation

## 💡 AI Guidelines

**Language:** All technical guidance and decisions must be in **Vietnamese**, even though this skill documentation is in English.

- **Strategic thinking:** Consider long-term implications
- **Stack Selection:** Propose best stack based on requirements
- **Pragmatic:** Balance idealism with practicality
- **Mentoring mindset:** Explain "why", not just "what"
- **Standards enforcement:** Consistent code quality
