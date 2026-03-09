# 📋 Implementation Checklist - Quick Reference

**Status:** 📌 Ready to Implement  
**Priority:** High (Team adoption depends on this)

---

## 🚨 CRITICAL BLOCKERS (Do This First)

### [ ] 1. Onboarding Guide for Non-Tech Members

**What:** Create Vietnamese + English beginner guide  
**File:** `docs/GETTING_STARTED_NON_TECH.md`  
**Time:** 8 hours  
**Why:** 70% team abandons after day 1 due to complexity

**Checklist:**

- [ ] Write 3-section guide: "What", "How", "Examples"
- [ ] Add 5 screenshots showing real workflows
- [ ] Record 5-min video walkthrough (speak slow!)
- [ ] Include: Common mistakes + how to fix them
- [ ] Add FAQ: "What does 'hydrate' mean?"

---

### [ ] 2. Unified Documentation Hub

**What:** Replace scattered docs with single INDEX  
**File:** `docs/INDEX.md` (central menu)  
**Time:** 12 hours  
**Why:** Users currently need 3+ searches to find right workflow

**Checklist:**

- [ ] Create visual flowchart: "What's your goal?" → "Use this workflow"
- [ ] Organize by role: Non-tech / Developer / Architect / DevOps
- [ ] Reorganize all `.md` files with clear titles
- [ ] Add cross-references between related docs
- [ ] Vietnamese + English side-by-side

---

### [ ] 3. Improve Skill Selection UX

**What:** Replace keyword matching with interactive selection  
**Change:** `core/skills/ORCHESTRATOR.md` → Add confidence scoring  
**Time:** 6 hours  
**Why:** Currently 28% wrong skill selected

**Checklist:**

- [ ] Add top-3 skill suggestions with %-confidence
- [ ] Show "You said: [parsedinput]. I think: [Top 3 skills]"
- [ ] Let user confirm or choose different
- [ ] Log user choice to improve future accuracy
- [ ] Example:
  ```
  You: "Button broken on mobile"
  → I think: 75% bug-investigator, 15% frontend-architect, 10% code-reviewer
  → Pick one: [1] [2] [3] or type skill name
  ```

---

### [ ] 4. Multi-Skill Composition (Reduce Wasted Work)

**What:** Let workflows use 2-3 skills together  
**File:** `core/skills/SKILL_COMPOSER.md` (new)  
**Time:** 8 hours  
**Why:** Some tasks need multiple perspectives (e.g., "API slow" = performance + backend)

**Checklist:**

- [ ] Remove circular dependencies (bug-inv → code-rev → bug-inv = BLOCK)
- [ ] Create templates: "Common Combinations"
- [ ] Update `/start-task` to suggest skill combinations
- [ ] Example workflow frontmatter:
  ```yaml
  skills: [bug-investigator, code-reviewer, frontend-architect]
  skill_order: sequential # Run one after another, passing context
  ```

---

### [ ] 5. Implement Undo/Rollback Workflow

**What:** New `/undo` and `/rollback` workflows  
**Files:** `core/workflows/ops/undo.md`, `rollback.md`  
**Time:** 8 hours  
**Why:** No way to recover from bad deploy = risky for production

**Checklist:**

- [ ] `/undo` - Revert last workflow execution (uses git commit history)
- [ ] `/rollback [commit]` - Roll back to specific commit
- [ ] `/rollback-last-deploy` - Quick deploy rollback (common case)
- [ ] Safety check: Only allow rollback max 24h back
- [ ] Log all rollback events

---

## 🎯 PHASE 2: Multi-Project Safety (Weeks 3-4)

### [ ] 6. Test Multi-Project Deployment

**What:** Verify `make deploy` works safely across 2-3 projects  
**File:** `tests/integration/test_multi_project_deploy.sh` (new)  
**Time:** 10 hours  
**Why:** Feature exists (v5.4.1) but untested = risky

**Checklist:**

- [ ] Set up test environment with 2-3 fake projects
- [ ] Test scenarios:
  - [ ] Deploy skills to both projects
  - [ ] Deploy workflows to both projects
  - [ ] One project fails mid-deploy → rollback both
  - [ ] Version conflicts → fallback to compatible version
- [ ] Document assumptions & limitations
- [ ] Add CI/CD hook to run before production deploy

---

### [ ] 7. Framework-Expert Auto-Detection Safety

**What:** Improve stack detection robustness  
**File:** `scripts/detect_stack_with_validation.sh` (new)  
**Time:** 6 hours  
**Why:** Ambiguous projects (Node + Python) could pick wrong framework

**Checklist:**

- [ ] Detect multi-stack projects and ask which to prioritize
- [ ] Add manual override: `./sync.sh --stack=nodejs --force`
- [ ] Validate detected stack makes sense (e.g., if `package.json` + `.go` files, warn)
- [ ] Test with 5+ real projects to verify correctness
- [ ] Add recovery: If detection fails, default to manual prompt

---

### [ ] 8. Cache System Documentation & Control

**What:** Make `.pr_review_cache` visible and manageable  
**Files:** `docs/CACHING_STRATEGY.md` (new)  
**Time:** 5 hours  
**Why:** Users don't know if data is fresh

**Checklist:**

- [ ] Document what gets cached and when
- [ ] Add `make cache-clear` command (delete cache)
- [ ] Add `make cache-status` command (show cached items)
- [ ] Auto-invalidate if `.pr_review_cache` older than 1 hour
- [ ] Add to `.gitignore` if not already there

---

## ✨ PHASE 3: Polish (Weeks 5-6)

### [ ] 9. Interactive Setup Wizard

**What:** Replace verbose `./setup` with friendly wizard  
**File:** `scripts/setup_interactive.sh` (new)  
**Time:** 10 hours  
**Why:** Setup UX is confusing for non-tech members

**Checklist:**

- [ ] Ask exactly 3 questions:
  1. "What project type? (1) Node.js (2) Flutter (3) Python (4) Other"
  2. "Are there multiple projects? (Y/N)"
  3. "Do you want to enable security checks? (Y/N)"
- [ ] Show progress bar as setup runs
- [ ] Explain each step: "Detected Flutter... Generating flutter-expert..."
- [ ] Offer help links: "Need help? See [docs/WORKFLOWS_GUIDE.md]"
- [ ] Vietnamese option: `./setup --lang=vi`

---

### [ ] 10. Skill Composition Templates

**What:** Pre-built skill combinations for common scenarios  
**File:** `core/skills/COMPOSER_TEMPLATES.md` (new)  
**Time:** 8 hours  
**Why:** Asking "which skill?" is still causing decision paralysis

**Checklist:**

- [ ] Template: "New Feature" = [product-manager, tech-lead, frontend-architect]
- [ ] Template: "Bug Fix" = [bug-investigator, code-reviewer, test-engineer]
- [ ] Template: "Landing Page" = [copywriter, frontend-architect, product-manager]
- [ ] Template: "Performance" = [tech-lead, test-engineer]
- [ ] Template: "Security" = [security-auditor, code-reviewer]
- [ ] Make user selectable: `/start-task --template=new-feature`

---

### [ ] 11. Rollback Workflow Implementation

**What:** Code the `/undo` and `/rollback` commands  
**Time:** 8 hours  
**Why:** Requires workflow + safety checks + git integration

**Checklist:**

- [ ] Workflow: `/undo` (revert last AI-made change)
  - [ ] Get last commit message matching pattern "AI: ..."
  - [ ] Show diff to user
  - [ ] Confirm before reverting
- [ ] Workflow: `/rollback [commit-id]`
  - [ ] Validate commit ID exists
  - [ ] Show diff from current → target
  - [ ] Confirm before reverting
- [ ] Safety: Max rollback 24h (security policy)
- [ ] Audit trail: Log every rollback event

---

## 🏗️ PHASE 4: Scalability (Weeks 7-8)

### [ ] 12. Low-Tech Workflow Variants

**What:** Simplified versions of complex workflows  
**File:** `core/workflows/LOW_TECH_VARIANTS.md` (new)  
**Time:** 10 hours  
**Why:** Same workflow text overwhelms junior developers

**Checklist:**

- [ ] Create 2 versions per workflow: "Technical" vs "Simple"
- [ ] Simple version: < 5 steps, plain language, no jargon
- [ ] Collapsible sections for advanced options
- [ ] Example: `/fix` simple version:

  ```
  1. Describe the bug simply
  2. I'll find the problem
  3. I'll suggest a fix
  4. You approve = Done!

  [Advanced users: click to see technical details]
  ```

- [ ] Variant selector: `/fix --mode=simple` (vs `--mode=technical`)

---

### [ ] 13. Health Check System Expansion

**What:** Comprehensive system diagnostics  
**File:** `core/workflows/ops/health_check.md` (update existing `/doctor`)  
**Time:** 6 hours  
**Why:** Users debugging setup issues have no visibility

**Checklist:**

- [ ] Checks:
  - [ ] Is `.agent/` structure correct?
  - [ ] Are all skills linked?
  - [ ] Are TOML files valid?
  - [ ] Is git properly configured?
  - [ ] Are multi-project paths accessible?
- [ ] Output format:

  ```
  ✅ Skills linked (11/11)
  ⚠️  Project 2 unreachable (permission denied)
  ❌ TOML syntax error in .agent/COMMAND_CONFIG.toml

  Suggestions:
  - [ ] Fix: chmod +x project-2
  - [ ] Fix: Validate TOML at [docs link]
  ```

- [ ] Self-healing: suggest fixes automatically

---

### [ ] 14. Metrics & Analytics

**What:** Track workflow usage and success  
**File:** `scripts/generate_metrics.sh` (new)  
**Time:** 8 hours  
**Why:** Need visibility into what's actually being used

**Checklist:**

- [ ] Collect metrics:
  - [ ] Which workflows used most?
  - [ ] Success rate per workflow (%)
  - [ ] Avg time to complete
  - [ ] Failure reasons (most common)
  - [ ] Skill success rate (top-3 accurate skills)
- [ ] Output format: JSON (easy to visualize)
- [ ] Report: `make show-metrics` (weekly summary)
- [ ] Goal: Identify bottlenecks

---

### [ ] 15. Comprehensive Testing Suite

**What:** Validate each skill and workflow  
**File:** `tests/skill_validation_suite.sh` (new)  
**Time:** 10 hours  
**Why:** No way to know if system broken until production

**Checklist:**

- [ ] Test scenarios per skill:
  - [ ] Tech Lead: Can parse architecture correctly?
  - [ ] Code Reviewer: Can find edge case bugs?
  - [ ] Security Auditor: Can detect secrets?
  - [ ] Frontend Architect: UI recommendations sensible?
- [ ] CI/CD: Run before every deploy
- [ ] Report: Pass/Fail + warning signs
- [ ] Add to `make validate`

---

## 📊 Quick Progress Tracker

### After Each Phase, Measure:

```
Phase 1 (Week 1-2):
□ Team adoption: 25% → 40%
□ First-use success: 40% → 60%
□ Documentation searches: 5 → 2

Phase 2 (Week 3-4):
□ Multi-project deploys: 0 → tested (3+ projects)
□ Detection accuracy: 85% → 95%
□ Deploy failures: N/A → < 1%

Phase 3 (Week 5-6):
□ Setup time: 5 min → 2 min
□ Skill confusion rate: 28% → 10%
□ Workflow success: 65% → 85%

Phase 4 (Week 7-8):
□ Team adoption: 40% → 90%
□ Documentation satisfaction: 4/10 → 8/10
□ Production bugs: N/A → 0
```

---

## 🎁 What Each User Benefits From

### For Non-Tech Members:

```
Before:  "I don't understand how to use this"
After:   "This guided me step-by-step, super simple"
         ✓ Beginner onboarding (Checklist #1)
         ✓ Low-tech workflow variants (Checklist #12)
         ✓ Interactive setup (Checklist #9)
```

### For Developers:

```
Before:  "Wrong skill picked, wasted 20 min"
After:   "It asked what I meant, much better"
         ✓ Improved skill selection (Checklist #3)
         ✓ Multi-skill composition (Checklist #4)
         ✓ Skill templates (Checklist #10)
```

### For Tech Leads:

```
Before:  "How do I roll back if deploy fails?"
After:   "Just run /rollback, everything safe"
         ✓ Undo/roll back (Checklist #5)
         ✓ Multi-project tests (Checklist #6)
         ✓ Health check (Checklist #13)
```

### For DevOps/Architects:

```
Before:  "Is system working correctly?"
After:   "Full visibility of usage & health"
         ✓ Multi-project safety (Checklist #6-8)
         ✓ Health check system (Checklist #13)
         ✓ Metrics dashboard (Checklist #14)
```

---

## 📞 Questions to Ask When Implementing

1. **Skill Composition:**
   - Should skills run sequentially or in parallel?
   - How are context/outputs passed between skills?

2. **Low-Tech Variants:**
   - Do we need video tutorials for each variant?
   - Vietnamese translations critical or nice-to-have?

3. **Rollback Safety:**
   - Do we need approval from tech-lead for rollback?
   - Should 24h limit be configurable?

4. **Metrics:**
   - Where should metrics be stored? (Local file? Cloud DB?)
   - Privacy: Should we track user names or just workflows?

5. **Multi-Project:**
   - Which 2-3 projects should test with first?
   - How do handle version conflicts between projects?

---

**Estimated Total Effort:** 10 weeks (1 person) or 2-3 weeks (2 people)

**Recommended**: Parallelize Phase 1 + Phase 2 tasks if 2+ people available.
