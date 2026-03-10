# Framework Templates Guide

**Version:** 1.0.0  
**Purpose:** Document all reusable templates and how to fill them out per project

---

## 1. Templates Overview

All project-specific files are generated from templates with **placeholder tokens** (format: `{{PLACEHOLDER}}`). The `/setup` workflow auto-generates these by detecting project stack and asking clarifying questions.

### Template Directory Structure

```
agent-final/templates/
├── memory/                              # Project knowledge base templates
│   ├── PROJECT.template.md             # Project overview
│   ├── ARCHITECTURE.template.md        # Tech architecture & design patterns
│   ├── CODE_STYLE.template.md          # Coding conventions
│   ├── CONVENTIONS.template.md         # Git, API, DB, file conventions
│   ├── GLOSSARY.template.md            # Domain & technical terminology
│   ├── TESTING_STRATEGY.template.md    # QA approach & test types
│   ├── QA_PROCESS.template.md          # Quality metrics & auditing
│   ├── DOD.template.md                 # Definition of Done checklist
│   └── AUDITOR_MODE.template.md        # Multi-aspect audit guidelines
├── rules/                               # Architecture & governance rules
│   ├── project-context.template.md     # Project context rules
│   └── architecture-rules.template.md  # Architecture enforcement rules
├── workflow.template.md                # Workflow definition template
└── skill-template/
    └── skill.template.md               # Skill definition template
```

### Memory vs Rules vs Overrides

| File Type            | Where                         | When Generated             | Override?                |
| -------------------- | ----------------------------- | -------------------------- | ------------------------ |
| **Memory**           | `memory/`                     | By `/setup`                | ✅ Edit after generation |
| **Rules**            | `rules/`                      | By `/setup` from templates | ✅ Edit as needed        |
| **Config Overrides** | `memory/config.override.json` | Manual (copy example)      | ✅ Customize per project |

---

## 2. Memory Templates

### 2.1 PROJECT.template.md

**Purpose:** Single source of truth for project context (team, business, stack)

**Placeholders:**

| Placeholder               | Example                       | When Filled                     |
| ------------------------- | ----------------------------- | ------------------------------- |
| `{{PROJECT_NAME}}`        | "Kansuke Photo"               | Auto-detected from folder/git   |
| `{{PROJECT_DESCRIPTION}}` | "AI-powered photo management" | User input in `/setup`          |
| `{{DATE}}`                | "2026-03-10"                  | Auto-filled                     |
| `{{TECH_STACK}}`          | "Flutter + Firebase + Drift"  | Auto-detected from pubspec.yaml |
| `{{ACTIVE_USERS}}`        | "50,000+"                     | User input in `/setup`          |
| `{{SETUP_COMMAND}}`       | "flutter pub get"             | Auto-detected or user input     |
| `{{RUN_DEV_COMMAND}}`     | "flutter run"                 | Auto-detected from stack        |
| `{{TEAM_SIZE}}`           | "3"                           | User input in `/setup`          |
| `{{RELEASE_CYCLE}}`       | "2 weeks"                     | User input                      |
| `{{CRITICAL_SLA}}`        | "99.5% availability"          | User input                      |

**Generated:** When `/setup` runs, creates `memory/PROJECT.md`

**Example Output:**

````markdown
# Kansuke Photo - Project Context

**Name:** Kansuke Photo
**Description:** AI-powered photo management app
**Tech Stack:** Flutter + Firebase + Drift
**Team Size:** 3 developers
**Release Cycle:** 2 weeks

## Development Commands

Setup Project:

```bash
flutter pub get
```
````

Run Dev Server:

```bash
flutter run
```

````

---

### 2.2 ARCHITECTURE.template.md

**Purpose:** Technical architecture decisions, patterns, and layer designs

**Key Sections:**
1. Folder structure and organization
2. Architecture pattern (Clean, MVP, MVVM, etc.)
3. Design patterns (Repository, DI, State Management)
4. API architecture & endpoints
5. Database schema
6. Key dependencies
7. Build & compilation process
8. Performance targets
9. Security practices

**Placeholders to Fill:**

| Placeholder | Type | Example |
|-------------|------|---------|
| `{{PROJECT_NAME}}` | String | "Kansuke Photo" |
| `{{ARCHITECTURE_PATTERN}}` | String | "Clean Architecture" |
| `{{STATE_MANAGEMENT}}` | String | "BLoC" |
| `{{API_BASE_URL}}` | URL | "https://api.example.com" |
| `{{LOCAL_DB_TECH}}` | String | "Drift" |
| `{{AUTH_METHOD}}` | String | "JWT Bearer Token" |
| `{{BUNDLE_SIZE_TARGET}}` | Size | "50MB" |
| `{{OPTIMIZATION_TECHNIQUES}}` | Array | ["Tree shaking", "Code splitting"] |

**Generated:** By `/setup` after architecture questions

---

### 2.3 CODE_STYLE.template.md

**Purpose:** Coding standards, naming conventions, formatting rules

**Sections:**
1. Naming conventions (classes, functions, variables, files)
2. Formatting rules (indentation, line length, spacing)
3. Import organization
4. Comments & documentation style
5. Return statements & error handling
6. Collections & data structures
7. Async/concurrency patterns
8. Testing conventions
9. Linting & static analysis
10. Accessibility & i18n
11. Quick reference commands

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{PRIMARY_LANGUAGE}}` | "Dart" |
| `{{FRAMEWORK}}` | "Flutter" |
| `{{CLASS_NAMING_CONVENTION}}` | "PascalCase" |
| `{{VARIABLE_NAMING_CONVENTION}}` | "camelCase" |
| `{{INDENT_SIZE}}` | "2" |
| `{{MAX_LINE_LENGTH}}` | "80" |
| `{{FORMAT_TOOL}}` | "dartfmt" |
| `{{LINTER_TOOL}}` | "flutter analyze" |
| `{{STATE_MANAGEMENT}}` | "BLoC" |

**Generated:** After code style questions in `/setup`

---

### 2.4 TESTING_STRATEGY.template.md

**Purpose:** QA approach, test types, coverage targets, testing tools

**Sections:**
1. Testing pyramid (unit/integration/E2E ratio)
2. Unit test approach and structure
3. Integration test scope
4. Widget/component test strategy
5. E2E test coverage
6. Coverage requirements by layer
7. Test data and fixtures
8. Mocking & stubbing strategy
9. Flaky test handling
10. CI/CD integration
11. Performance testing
12. Quick commands

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{COVERAGE_TARGET}}` | "80" |
| `{{UNIT_COVERAGE}}` | "90" |
| `{{MOCKING_LIBRARY}}` | "Mockito" |
| `{{TEST_FRAMEWORK}}` | "flutter_test" |
| `{{E2E_TEST_TOOL}}` | "integration_test" |
| `{{UNIT_TEST_RUN_COMMAND}}` | "flutter test" |

**Generated:** By `/setup` from test framework detection

---

### 2.5 CONVENTIONS.template.md

**Purpose:** Git, API, database, environment, and file naming conventions

**Sections:**
1. Git conventions (branches, commits, PRs)
2. Folder & file organization
3. API naming (endpoints, fields)
4. Database column conventions
5. Environment configuration
6. Error/exception naming
7. Logging conventions
8. Date/time conventions
9. String & resource management
10. Version numbering

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{FEATURE_NAME}}` | "add-infinite-scroll" |
| `{{COMMIT_MESSAGE_TEMPLATE}}` | "feat: add infinite scroll" |
| `{{TABLE_NAMING}}` | "snake_case_plural" |
| `{{API_ENDPOINT_PATTERN}}` | "/api/v1/resources" |
| `{{ENV_FILE_LOCATIONS}}` | ".env, .env.local" |
| `{{VERSION_FORMAT}}` | "MAJOR.MINOR.PATCH" |

**Generated:** By `/setup` based on stack & user input

---

### 2.6 GLOSSARY.template.md

**Purpose:** Shared terminology across team (domain & technical terms)

**Sections:**
1. Domain terms (business terminology)
2. Technical terms (architecture concepts)
3. API terms
4. Acronyms
5. Role-based terminology
6. Feature-specific terms

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{DOMAIN_TERM_1}}` | "Album" |
| `{{DOMAIN_TERM_1_DEF}}` | "Collection of photos" |
| `{{CUSTOM_ACRONYM_1}}` | "DDD" |
| `{{CUSTOM_ACRONYM_1_FULL}}` | "Domain-Driven Design" |

**Generated:** By `/setup`, team maintains during project

---

### 2.7 QA_PROCESS.template.md

**Purpose:** Quality assurance procedures, metrics, testing workflow, release process

**Sections:**
1. Quality metrics & targets
2. Testing workflow (pre-commit, pre-push, pre-merge)
3. Code review checklist
4. Bug severity & SLA
5. Regression testing
6. Performance testing
7. Accessibility auditing
8. Security auditing
9. Device/platform testing
10. Release QA & post-release monitoring

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{COVERAGE_TARGET}}` | "80" |
| `{{CRITICAL_SLA}}` | "4 hours" |
| `{{CRITICAL_DEF}}` | "App crash or data loss" |
| `{{A11Y_STANDARD}}` | "WCAG 2.1 AA" |
| `{{PERF_TARGET}}` | "2000ms" |

**Generated:** By `/setup` from QA questions

---

### 2.8 DOD.template.md (Definition of Done)

**Purpose:** Comprehensive checklist for feature completion across all aspects

**Sections:**
1. Engineering excellence (code quality, testing, architecture)
2. Product requirements (functionality, UX)
3. Performance & optimization
4. Security & compliance
5. Testing before release
6. Documentation & handoff
7. Deployment readiness
8. Post-release monitoring

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{COVERAGE_MIN}}` | "70" |
| `{{LINT_COMMAND}}` | "flutter analyze" |
| `{{A11Y_STANDARD}}` | "WCAG 2.1 AA" |
| `{{SUPPORTED_PLATFORMS}}` | "iOS 12+, Android 5+" |
| `{{MEMORY_TARGET}}` | "256MB" |

**Generated:** By `/setup` from quality requirements

---

### 2.9 AUDITOR_MODE.template.md

**Purpose:** Guidelines for auditing code/features from multiple perspectives (architecture, security, performance, quality, testing, A11Y)

**Sections:**
1. Architecture audit checklist
2. Security audit checklist
3. Performance audit checklist
4. Code quality audit checklist
5. Testing coverage audit
6. Accessibility (A11Y) audit
7. Audit frequency matrix
8. Tools & commands quick reference

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{ARCH_ANALYSIS_CMD}}` | "dart pub run dart_code_metrics:metrics" |
| `{{SECURITY_SCAN_CMD}}` | "dart run security_check" |
| `{{PERF_PROFILE_CMD}}` | "flutter run --profile" |
| `{{A11Y_CHECK_CMD}}` | "flutter_test accessibility_test.dart" |

**Generated:** By `/setup` & workflow choices

---

## 3. Rules Templates

### 3.1 project-context.template.md

**Purpose:** Project context rules (auto-generated from PROJECT.template.md)

**Content:** Mirrors PROJECT.md but formatted as "rules" that constrain all workflows

**Generated Location:** `rules/01-project-context.md` (or `memory/rules/01-project-context.md`)

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{PROJECT_NAME}}` | "Kansuke Photo" |
| `{{BUSINESS_DOMAIN}}` | "Media & Photography" |
| `{{TECH_STACK}}` | "Flutter, Firebase, Drift" |
| `{{SETUP_COMMAND}}` | "flutter pub get" |
| `{{RUN_DEV_COMMAND}}` | "flutter run" |

**Generated:** By `/setup` workflow

---

### 3.2 architecture-rules.template.md

**Purpose:** Strict architecture enforcement rules (layers, dependencies, patterns)

**Content:**
- Layer diagram & dependency flow
- Layer-specific rules (Domain, Data, Presentation)
- Code generation requirements
- DI framework rules
- Error handling strategy
- State management rules
- Testing architecture
- API integration rules
- Database conventions
- Performance rules
- Code review checklist
- Common pitfalls & fixes

**Key Placeholders:**

| Placeholder | Example |
|-------------|---------|
| `{{ARCHITECTURE_PATTERN}}` | "Clean Architecture" |
| `{{FRAMEWORK_NAME}}` | "Flutter" |
| `{{STATE_MANAGEMENT}}` | "BLoC" |
| `{{DI_FRAMEWORK}}` | "get_it" |
| `{{CODE_GEN_TOOL}}` | "build_runner" |
| `{{CODE_GEN_COMMAND}}` | "flutter pub run build_runner build" |

**Generated:** By `/setup` but should be reviewed & customized per project

---

## 4. Workflow & Skill Templates

### 4.1 workflow.template.md

**Purpose:** Template for creating new workflows

**Structure:**
```yaml
---
description: "Clear description of workflow purpose"
trigger: /<command>
version: "1.0.0"
skills:
  - <primary-skill>
constraints:
  max_iterations: 1
  timeout_minutes: 30
---

# 🚀 Workflow Name
...
````

**Key Sections:**

1. YAML frontmatter (description, trigger, version, skills, constraints)
2. Execution flow diagram
3. Input & output schemas (JSON)
4. Step-by-step instructions
5. Config reading instructions

**Used For:** Creating new workflows following standard format

---

### 4.2 skill.template.md

**Purpose:** Template for creating new custom skills

**Structure:**

````markdown
# Skill Name

Version: 1.0.0
Purpose: Clear statement of what skill does

## Responsibilities

- ...

## Input Contract

```json
{...}
```
````

## Output Contract

```json
{...}
```

## Success Criteria

- ...

````

**Used For:** Extending framework with project-specific skills

---

## 5. How to Fill Out Templates

### Option A: Automatic (via `/setup` Workflow)

```bash
# Initialize project - auto-detects stack & asks questions
/setup

# This generates memory/*.md and rules/*.md automatically
````

**What `/setup` does:**

1. Scans project (pubspec.yaml, package.json, etc.)
2. Asks clarifying questions (team size, business domain, etc.)
3. Auto-fills placeholder tokens
4. Writes PROJECT.md, ARCHITECTURE.md, CODE_STYLE.md, etc. to `memory/`
5. Writes project context rules to `rules/01-project-context.md`

### Option B: Manual (Copy Template & Edit)

```bash
# 1. Copy template
cp agent-final/templates/memory/PROJECT.template.md memory/PROJECT.md

# 2. Find & replace placeholders
vim memory/PROJECT.md
# Replace:
# {{PROJECT_NAME}} → "My App"
# {{DATE}} → "2026-03-10"
# {{TECH_STACK}} → "Flutter + Firebase"
# ... (fill all {{PLACEHOLDERS}})

# 3. Save & commit
git add memory/PROJECT.md
git commit -m "docs: initialize PROJECT.md"
```

---

## 6. Placeholder Naming Convention

All placeholders follow `{{UPPERCASE_WITH_UNDERSCORES}}` format.

### Categories:

**Project-Level:**

```
{{PROJECT_NAME}}
{{PROJECT_DESCRIPTION}}
{{DATE}}
{{TEAM_SIZE}}
```

**Technology Stack:**

```
{{PRIMARY_LANGUAGE}}
{{FRAMEWORK}}
{{STATE_MANAGEMENT}}
{{DATABASE_TYPE}}
```

**Commands & Tools:**

```
{{SETUP_COMMAND}}
{{RUN_DEV_COMMAND}}
{{BUILD_COMMAND}}
{{TEST_COMMAND}}
{{LINT_COMMAND}}
{{FORMAT_COMMAND}}
{{CODE_GEN_COMMAND}}
```

**Metrics & Targets:**

```
{{COVERAGE_TARGET}}
{{PERFORMANCE_BASELINE}}
{{MEMORY_TARGET}}
{{BUNDLE_SIZE_TARGET}}
```

---

## 7. Template Usage Examples

### Example 1: Fill Out PROJECT.md for Flutter App

```bash
# Copy template
cp templates/memory/PROJECT.template.md memory/PROJECT.md

# Edit and fill placeholders
# {{PROJECT_NAME}} → "Kansuke Photo"
# {{TECH_STACK}} → "Flutter + Firebase + Drift"
# {{TEAM_SIZE}} → "3"
# {{SETUP_COMMAND}} → "flutter pub get"
# {{RUN_DEV_COMMAND}} → "flutter run"
# {{BUILD_COMMAND}} → "flutter build apk"
# {{TEST_COMMAND}} → "flutter test"

git add memory/PROJECT.md
git commit -m "docs: initialize PROJECT.md for Kansuke"
```

### Example 2: Generate ARCHITECTURE.md via `/setup`

```bash
/setup
# AI: "What's your architecture pattern?" → "Clean Architecture"
# AI: "State management?" → "BLoC"
# AI: "Database?" → "Drift"
# AI: "DI framework?" → "get_it"
# ...

# Outputs: memory/ARCHITECTURE.md with all placeholders filled
```

---

## 8. Maintenance

### When Templates Change

1. **Update** `agent-final/templates/*.template.md`
2. **For new projects:** Use updated template via `/setup`
3. **For existing projects:** Manually merge changes if significant

### Team Alignment

- **Project Lead:** Maintains template accuracy
- **Tech Lead:** Ensures architecture rules updated
- **Team:** Follows template standards when creating new docs

---

## 9. Quick Reference

| Template              | Purpose                | Generated By               | Override After?        |
| --------------------- | ---------------------- | -------------------------- | ---------------------- |
| PROJECT               | Project overview       | `/setup`                   | ✅ Yes                 |
| ARCHITECTURE          | Tech design            | `/setup` + manual review   | ✅ Yes                 |
| CODE_STYLE            | Coding standards       | `/setup`                   | ✅ Review periodically |
| CONVENTIONS           | Git/API/DB conventions | `/setup`                   | ✅ Refine as needed    |
| GLOSSARY              | Terminology            | `/setup`                   | ✅ Team maintains      |
| TESTING_STRATEGY      | QA approach            | `/setup`                   | ✅ Adjust per sprint   |
| QA_PROCESS            | Quality metrics        | `/setup`                   | ✅ Update SLAs         |
| DOD                   | Definition of Done     | `/setup`                   | ✅ Refine per project  |
| AUDITOR_MODE          | Audit guidelines       | `/setup`                   | ✅ Customize aspects   |
| project-context.rules | Project rules          | `/setup` from PROJECT      | ✅ Review              |
| architecture-rules    | Architecture rules     | `/setup` from ARCHITECTURE | ✅ Strict enforcement  |

---

## 10. Troubleshooting

### Problem: Template has wrong placeholder

**Solution:**

```bash
# Search for placeholder
grep -r "{{WRONG_PLACEHOLDER}}" memory/ rules/

# Replace with correct one
sed -i 's/{{WRONG_PLACEHOLDER}}/{{CORRECT_PLACEHOLDER}}/g' memory/*.md
```

### Problem: Forgot to fill a placeholder

**Solution:**

```bash
# Find unfilled placeholders
grep -r "{{[A-Z_]*}}" memory/ rules/

# Fill them manually
vim <file.md>
```

### Problem: Template doesn't match project

**Solution:**

```bash
# Re-run setup with --force-regenerate
/setup --force-regenerate

# Or manually update template copy
cp agent-final/templates/memory/ARCHITECTURE.template.md agent-final/templates/memory/ARCHITECTURE.template.md.bak
vim memory/ARCHITECTURE.md
```
