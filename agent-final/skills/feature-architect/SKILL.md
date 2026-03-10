---
name: "feature-architect"
description: "Feature architecture design. Decomposes requirements into Clean Architecture layers."
inputs:
  - name: "requirement"
    type: "text"
    desc: "Business Requirement (User Story)"
outputs:
  - name: "architecture_plan"
    type: "markdown"
    desc: "Layer diagram and file structure"
  - name: "data_flow"
    type: "markdown"
    desc: "Data flow description"
---

# Feature Architect Skill (Generic)

Design feature architecture following Clean Architecture principles. Transform vague requirements into clear technical specifications.

## 🚀 When to use
- New feature development
- Refactoring existing features
- Architecture decision needed
- API integration planning

## 🛑 When NOT to use
- Bug fixing (use `bug-investigator`)
- Code review (use `code-reviewer`)
- Performance tuning (use stack-specific expert)

## 💡 Core Capabilities

### 1. Requirements Analysis
- Break down user stories into technical tasks
- Identify data models and entities
- Plan API contracts

### 2. Layer Design ([PROJECT_NAME] Context)
- **Data Layer:** `retrofit` API Clients, `drift` Local DB, Repository Impls, DTOs.
- **Domain Layer:** Entities (`freezed`), Repository Interfaces, Use Cases.
- **Presentation Layer:** `flutter_bloc` (Cubit/BLoC with `freezed` events/states), view logic, `auto_route` navigation.

### 3. Dependency Planning
- Define interfaces between layers
- Plan dependency injection
- Design error handling strategy

## 📋 Deliverables

### Implementation Plan
```markdown
## Feature: [Name]

### Data Layer
- Models/DTOs: [List]
- Repository Interface: [Name]
- Data Sources: [Local/Remote]

### Domain Layer
- Entities: [List]
- Use Cases: [List]

### Presentation Layer
- State Management: [Strategy]
- UI Components: [List]

### Testing Strategy
- [Test approach]
```

## 💡 AI Guidelines

**Language:** All architectural designs and plans must be in **English**.

- **Clean Architecture first:** Always follow dependency rule
- **SOLID principles:** Apply in design decisions
- **Testability:** Design for easy testing
- **Scalability:** Consider future extensions
