---
description: "Start new feature or project: Vision → Blueprint → DoR → Contract. Outputs executable Blueprint for /implement-feature workflow with context passing."
trigger: /start-task
version: "6.0.0"
skills:
  - product-manager
  - tech-lead
constraints:
  max_iterations: 3
  timeout_minutes: 60
  exit_on:
    [
      "Blueprint approved by user",
      "User rejected vision",
      "Requirements too unclear",
    ]
  auto_approval_gate: "dor_completeness == 100%"
skill: product-manager
---

# 🚀 Start Task Workflow (Vision → Blueprint)

**Objective:** Transform raw ideas into approved Blueprint with Definition of Ready checklist, executable by `/implement-feature` workflow.

**Status:** Production-ready (v6.0.0)

---

## 📊 Execution Flow Overview

```
┌──────────────────────────────────────────┐
│ INPUT: Feature idea or raw requirement   │
│ Example: "Add infinite scroll to gallery"│
└────────────┬─────────────────────────────┘
             │
    ┌────────▼──────────┐
    │ STEP 1: VISION    │ (8-10 min)
    │ Draft + Ask Q's   │
    └────────┬──────────┘
             │
    ┌────────▼──────────────┐
    │ STEP 2: REFINEMENT    │ (5-8 min)
    │ Listen + Update       │
    └────────┬──────────────┘
             │
    ┌────────▼──────────────┐
    │ STEP 3: DESIGN        │ (10-15 min)
    │ Architect Blueprint   │
    └────────┬──────────────┘
             │
    ┌────────▼──────────────┐
    │ STEP 4: DoR CHECK     │ (5 min)
    │ Verify requirements   │
    └────────┬──────────────┘
             │
    ┌────────▼──────────────┐
    │ STEP 5: CONTRACT      │ (5 min)
    │ Scope + DoD           │
    └────────┬──────────────┘
             │
    ┌────────▼───────────────┐
    │ STEP 6: APPROVAL       │ ⏸️ (Wait user)
    │ "APPROVED" trigger     │
    └────────┬───────────────┘
             │
    ┌────────▼──────────────────┐
    │ OUTPUT: Blueprint ready   │
    │ for /implement-feature    │
    └───────────────────────────┘
```

---

## 📥 Input Schema

```json
{
  "type": "object",
  "required": ["requirement"],
  "properties": {
    "requirement": {
      "type": "string",
      "description": "Feature request or project idea (5-500 chars)",
      "example": "Add infinite scroll pagination to gallery"
    },
    "context": {
      "type": "object",
      "description": "Optional context",
      "properties": {
        "existing_feature": { "type": "string" },
        "priority": { "enum": ["critical", "high", "medium", "low"] },
        "deadline": { "type": "string", "example": "2026-03-20" },
        "constraints": { "type": "array" }
      }
    }
  }
}
```

---

## 📤 Output Schema (Blueprint for /implement-feature)

```json
{
  "type": "object",
  "required": [
    "feature_name",
    "description",
    "entities",
    "use_cases",
    "ui_screens"
  ],
  "properties": {
    "feature_name": { "type": "string" },
    "description": { "type": "string" },
    "priority": { "type": "string" },

    "entities": {
      "type": "array",
      "description": "Domain entities (for domain layer)",
      "items": {
        "properties": {
          "name": { "type": "string" },
          "attributes": { "type": "array", "items": { "type": "object" } },
          "validation_rules": { "type": "array" },
          "immutable": { "type": "boolean" }
        }
      }
    },

    "use_cases": {
      "type": "array",
      "description": "Business operations",
      "items": {
        "properties": {
          "name": { "type": "string" },
          "description": { "type": "string" },
          "inputs": { "type": "array" },
          "outputs": { "type": "array" },
          "error_cases": { "type": "array" }
        }
      }
    },

    "data_sources": {
      "type": "array",
      "description": "External data integration",
      "items": {
        "properties": {
          "name": { "type": "string" },
          "type": { "enum": ["retrofit", "drift", "local", "websocket"] },
          "endpoints": { "type": "array" },
          "request_schema": { "type": "object" },
          "response_schema": { "type": "object" },
          "error_codes": { "type": "array" }
        }
      }
    },

    "ui_screens": {
      "type": "array",
      "description": "Presentation components",
      "items": {
        "properties": {
          "name": { "type": "string" },
          "type": { "enum": ["page", "dialog", "widget"] },
          "states": { "type": "array" },
          "user_interactions": { "type": "array" },
          "design_link": { "type": "string" }
        }
      }
    },

    "state_management": {
      "type": "object",
      "properties": {
        "approach": { "enum": ["BLoC", "Riverpod", "GetX"] },
        "events": { "type": "array" },
        "states": { "type": "array" }
      }
    },

    "api_contract": {
      "type": "object",
      "description": "Documented API integration",
      "properties": {
        "base_url": { "type": "string" },
        "endpoints": { "type": "array" },
        "authentication": { "type": "string" },
        "rate_limiting": { "type": "string" }
      }
    },

    "dor": {
      "type": "object",
      "description": "Definition of Ready checklist",
      "properties": {
        "requirement_clear": { "type": "boolean" },
        "design_complete": { "type": "boolean" },
        "api_contract_documented": { "type": "boolean" },
        "assets_available": { "type": "boolean" },
        "all_met": { "type": "boolean" }
      }
    },

    "contract": {
      "type": "object",
      "description": "Scope and Definition of Done",
      "properties": {
        "in_scope": { "type": "array" },
        "out_of_scope": { "type": "array" },
        "dod": { "type": "array" },
        "estimated_effort": { "type": "string" }
      }
    },

    "approval_status": {
      "type": "string",
      "enum": ["draft", "pending_review", "approved", "rejected"],
      "description": "Approval status by user"
    }
  }
}
```

---

## 🔄 Step-by-Step Execution

### STEP 1: Vision Extraction (8-10 min) 💡

**Invoke:** `product-manager` skill

**Process:**

1. Analyze the user requirement
2. Detect feature type (CRUD, reporting, integration, optimization, etc.)
3. Propose draft Vision proactively (don't ask vague questions)
4. Ask 3-5 clarifying questions
5. Present in Vietnamese

**Outputs:**

```markdown
## 📝 Draft Vision: Gallery Infinite Scroll

### Feature Type

🔄 **UI/UX Enhancement** - Add pagination to existing feature

### Proposed Solution

Currently gallery loads all photos at once (performance issue).
Propose: Implement infinite scroll with pagination (50 photos/page)

**Key Features:**

- Lazy load photos as user scrolls
- Caching for offline support
- Loading indicators
- Error state with retry
- Pull-to-refresh

### Questions for You:

1️⃣ **Performance Target:**

- Target smooth scroll at 60fps?
- Maximum photos in memory?

2️⃣ **API Pagination:**

- Server already supports pagination?
- Response schema? (limit/offset vs cursor)

3️⃣ **Offline Behavior:**

- Cache older photos locally?
- Show "Load more" when offline?

4️⃣ **Accessibility:**

- Keyboard navigation needed?
- Screen reader support?

5️⃣ **Timeline:**

- Urgency? (Nice-to-have / Soon / Urgent)
```

---

### STEP 2: Context Refinement (5-8 min) 👂

**Process:**

1. Listen to user answers
2. Ask follow-up questions if needed
3. Update Vision based on feedback
4. Verify understanding

**Example user response:**

```
User: "Yes, API supports pagination with limit/offset.
      We want 60fps, cache offline, but accessibility not urgent.
      This is high priority - deadline Mar 20."
```

**Updated vision:**

```markdown
## ✅ Refined Vision

### Confirmed Details

✅ Pagination: limit/offset (50/page)
✅ Performance: Target 60fps smooth scroll
✅ Offline: Cache photos locally, show indicator
✅ Priority: 🔴 HIGH - Deadline Mar 20
✅ Accessibility: Not required for v1

### Architecture Decision

- State Management: BLoC (already using in project)
- Caching: Drift local DB + in-memory
- Networking: Retrofit + Dio
```

````

---

### STEP 3: Blueprint Design (10-15 min) 🏗️

**Invoke:** `tech-lead` skill (design mode) + `product-manager`

**Process:**
1. Design Domain Layer entities
2. Map business logic to Use Cases
3. Design API contract
4. Design Presentation layer (Pages, Widgets, BLoC)
5. Plan state management & events
6. Read ARCHITECTURE.md to verify alignment

**Outputs:**
```markdown
## 🏗️ Blueprint: Gallery Infinite Scroll

### Domain Layer (Business Logic)
**Entities:**
- `Photo` - id, url, createdAt, thumbnail, metadata
- `PhotoFilter` - limit, offset, sortBy

**Repositories (Interfaces):**
- `PhotoRepository.getPhotos(offset, limit)`
- Returns: List<Photo>

**UseCases:**
- `GetPhotosUseCase` - Business logic, validation, pagination
- `FetchMorePhotosUseCase` - Load next page

### Data Layer (External Integration)

**API Contract:**
````

GET /[aggregate_root]/{id}/photos?limit=50&offset=0
Authorization: Bearer {token}

Response (200):
{
"data": [
{ "id": "p1", "url": "...", "createdAt": "...", "metadata": {...} }
],
"pagination": {
"total": 1500,
"limit": 50,
"offset": 0,
"hasMore": true
}
}

Error Codes:

- 401: Unauthorized
- 403: Forbidden
- 429: Rate limited (retry after 30s)

```

**DataSources:**
- `PhotoRemoteDataSource` - Retrofit API client
- `PhotoLocalDataSource` - Drift for caching

**Models:**
- `PhotoDTO` - Matches API response structure

### Presentation Layer (UI)

**States (BLoC):**
- `PhotosInitial` - First load
- `PhotosLoading` - Fetching page
- `PhotosSuccess` - Display photos + hasMore flag
- `PhotosError` - Error message + retry button

**Events:**
- `FetchPhotos()` - Initial load
- `LoadMore()` - Pagination trigger

**Pages:**
- `GalleryPage` - Full screen gallery

**Widgets:**
- `PhotoCard` - Single photo card
- `PaginationIndicator` - Loading indicator at bottom

### State Management (BLoC)
```

FetchPhotos event
↓
Load first page (offset=0)
↓
Emit PhotosSuccess(photos, hasMore=true)
↓
User scrolls to bottom...
↓
LoadMore event
↓
Load next page (offset+=50)
↓
Emit PhotosSuccess(photos+newPhotos, hasMore=true/false)

```

### Estimated Effort
- Domain: 1 hour
- Data: 1.5 hours
- Presentation: 1 hour
- Tests: 1 hour
- **Total: ~4 hours** (1 day sprint)
```

---

### STEP 4: DoR Check (5 min) ✅

**Process:**

1. Verify all Definition of Ready criteria met
2. Ask for missing items if any
3. Document checklist

**Outputs:**

```markdown
## ✅ Definition of Ready Verification

### Requirements ✅

✅ User Story: "Infinite scroll gallery with pagination"
✅ Acceptance Criteria: 3 defined

1.  Scroll smooth 60fps
2.  Shows loading indicator
3.  Handles API errors gracefully

### Design ✅

✅ UI mockup: Figma link provided
✅ Wire frames: Page layout documented
✅ States: Initial, Loading, Success, Error

### API Contract ✅

✅ Endpoint: GET /[aggregate_root]/{id}/photos
✅ Parameters: limit, offset documented
✅ Response: Sample JSON provided
✅ Error codes: 401, 403, 429 documented

### Assets ✅

✅ Icons: Loading spinner, error icon (system icons OK)
✅ Images: Use placeholder until design photos available (✅ approved)

### Status: ✅ ALL DoR MET - Ready for implementation
```

---

### STEP 5: Contract (Scope + DoD) (5 min) 📋

**Process:**

1. Define what's IN scope
2. Define what's OUT of scope
3. Define Definition of Done criteria
4. Estimate effort

**Outputs:**

```markdown
## 📋 Contract: Gallery Infinite Scroll

### In Scope ✅

- [x] Infinite scroll pagination (50 photos/page)
- [x] Loading indicator at bottom
- [x] Error state with retry button
- [x] Offline cache (local DB)
- [x] Unit tests (domain + data layers)
- [x] Widget tests
- [x] 70%+ code coverage

### Out of Scope ❌

- [ ] Accessibility (keyboard nav, screen reader) - v2
- [ ] Advanced filtering / sorting - v2
- [ ] Analytics tracking - separate ticket
- [ ] Image optimization - handled by backend

### Definition of Done (DoD)

- [ ] Code follows Clean Architecture (3 layers)
- [ ] All tests pass (minimum 70% coverage)
- [ ] Linter passes (dart format, analysis)
- [ ] Code review approved
- [ ] Manual testing on iOS + Android
- [ ] Performance: Smooth 60fps scroll
- [ ] Error cases handled
- [ ] Offline mode works

### Estimated Effort

**Optimistic:** 3 hours
**Most Likely:** 4 hours
**Pessimistic:** 6 hours

**Timeline:** 1 day (include testing + review)
```

---

### STEP 6: Approval Gate (⏸️ Wait user)

**MANDATORY STOP POINT**

Present complete Blueprint and wait for user approval:

```
🏁 BLUEPRINT READY FOR APPROVAL

[Complete Blueprint displayed above]

Do you approve this Blueprint?

✅ Type "APPROVED" or "AGREE" to proceed → /implement-feature
❌ Type "REJECT" to revise
🔄 Type "MODIFY" to change specific sections
```

**User types:** "APPROVED" → Continue to Output  
**User types:** "REJECT" → Stop, ask for changes

---

## 📤 Final Output (After Approval)

When user approves, output complete context for `/implement-feature`:

```json
{
  "status": "approved",
  "blueprint": {
    "feature_name": "Gallery Infinite Scroll",
    "description": "Add lazy-loaded pagination to gallery feature",
    "priority": "high",

    "entities": [
      { "name": "Photo", "attributes": [...] }
    ],

    "use_cases": [
      { "name": "GetPhotosUseCase", "description": "..." }
    ],

    "data_sources": [
      { "name": "PhotoRemoteDataSource", "type": "retrofit", "endpoints": [...] }
    ],

    "ui_screens": [
      { "name": "GalleryPage", "states": ["Loading", "Success", "Error"] }
    ],

    "state_management": {
      "approach": "BLoC",
      "events": ["FetchPhotos", "LoadMore"]
    },

    "dor": {
      "requirement_clear": true,
      "design_complete": true,
      "api_contract_documented": true,
      "assets_available": true,
      "all_met": true
    },

    "contract": {
      "in_scope": [...],
      "out_of_scope": [...],
      "dod": [...],
      "estimated_effort": "4 hours"
    },

    "approval_status": "approved"
  },

  "next_action": {
    "workflow": "/implement-feature",
    "message": "✅ Blueprint approved! Ready to implement.\nRun: /implement-feature\n\nThe blueprint context is automatically passed."
  }
}
```

---

## 🔌 Skill Integration

### Step 1-2 → Invoke `product-manager`

```yaml
Input:
  requirement: raw user request

Process:
  - Extract feature type
  - Propose vision proactively
  - Ask clarifying questions

Output:
  vision: draft with Q&A
```

### Step 3 → Invoke `tech-lead` (Design mode)

```yaml
Input:
  refined_vision: from step 2
  architecture_context: ARCHITECTURE.md

Process:
  - Design domain layer
  - Design data layer
  - Design presentation layer

Output:
  blueprint: detailed design
```

---

## ⚠️ Error Handling

### If Vision Rejected (Step 1-2)

```
❌ USER: "No, this doesn't match what I need"

ACTION:
  1. Ask what's different
  2. Generate alternative vision
  3. Repeat step 1-2
```

### If DoR Not Met (Step 4)

```
❌ MISSING: API contract documentation

ACTION:
  1. List missing items
  2. Ask user to provide: "Please provide API spec or Swagger link"
  3. Wait for delivery
  4. Proceed when complete
```

### If User Rejects Blueprint (Step 6)

```
❌ USER: "Reject - too much scope"

ACTION:
  1. Ask what to remove
  2. Move items to "Out of Scope"
  3. Revise contract
  4. Re-present for approval
```

---

## 💡 AI Guidelines

**Language:** Vietnamese (unless user requests English)

**Philosophy:**

- 🎯 **Be Proactive** - Don't ask "What do you want?" → State "I see you want X, here's my proposal..."
- ✅ **Blueprint is Final** - Once approved, don't change without user sign-off
- 🏗️ **Respect Architecture** - Align with ARCHITECTURE.md always
- ⏸️ **Wait for Approval** - Never skip STEP 6 approval gate
- 📋 **Clear Contract** - DoR + DoD must be explicit

---

## 📝 Quick Reference: When to Use This Workflow

**Use `/start-task` when:**

- ✅ Starting a new feature
- ✅ Need to clarify requirements before coding
- ✅ Want documented Blueprint before implementation
- ✅ Team needs to understand scope before sprint

**Don't use `/start-task` when:**

- ❌ Bug needs fixing (use `/fix` instead)
- ❌ Quick hotfix < 30 minutes (use `/fix` directly)
- ❌ Refactoring existing code (use `/refactor` instead)

---

## ⏱️ Typical Duration

- Vision extraction: 8-10 min
- Refinement: 5-8 min
- Design: 10-15 min
- DoR check: 5 min
- Contract: 5 min
- Approval: 2 min (waiting for user)

**Total:** 35-45 minutes

**Next step after approval:** Run `/implement-feature` (Blueprint context automatically passed)
