---
name: feature-architect
description: Feature architecture design expert. Break down requirements into layers (Data/Domain/Presentation) and create implementation plans.
---

# Feature Architect Skill

Design feature architecture following Clean Architecture principles. Transform vague requirements into clear technical specifications.

## 🚀 When to use
- New feature development
- Refactoring existing features
- Architecture decision needed
- API integration planning

## 🛑 When NOT to use
- Bug fixing (use `bug-investigator`)
- Code review (use `code-reviewer`)
- Performance tuning (use `flutter-expert`)

## 💡 Core Capabilities

### 1. Requirements Analysis
- Break down user stories into technical tasks
- Identify data models and entities
- Plan API contracts

### 2. Layer Design
- **Data Layer:** Models, Repositories, Data Sources
- **Domain Layer:** Entities, Use Cases, Business Logic
- **Presentation Layer:** BLoC, UI, Widgets

### 3. Dependency Planning
- Define interfaces between layers
- Plan dependency injection
- Design error handling strategy

## 📋 Deliverables

### Implementation Plan
```markdown
## Feature: [Name]

### Data Layer
- Models: [List]
- Repository: [Interface]
- Data Sources: [Local/Remote]

### Domain Layer
- Entities: [List]
- Use Cases: [List]

### Presentation Layer
- BLoC: [Events/States]
- UI: [Screens/Widgets]

### Dependencies
- [Package requirements]

### Testing Strategy
- [Test approach]
```

## 💡 AI Guidelines

**Language:** All architectural designs and plans must be in **Vietnamese**, even though this skill documentation is in English.

- **Clean Architecture first:** Always follow dependency rule
- **SOLID principles:** Apply in design decisions
- **Testability:** Design for easy testing
- **Scalability:** Consider future extensions
