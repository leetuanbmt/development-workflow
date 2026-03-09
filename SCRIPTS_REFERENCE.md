# 🛠️ Scripts & Configuration Reference

**Document:** Quick guide to new scripts and YAML config  
**Version:** 1.0  
**Last Updated:** March 9, 2026

---

## 📁 Files Created

| File                                      | Type   | Purpose                                                               |
| :---------------------------------------- | :----- | :-------------------------------------------------------------------- |
| `config.yaml`                             | YAML   | Central configuration (language, options, settings)                   |
| `scripts/setup_interactive.sh`            | Bash   | Interactive setup wizard for non-tech users                           |
| `scripts/detect_stack_with_validation.sh` | Bash   | Tech stack detection with validation                                  |
| `scripts/skill_confidence_scorer.py`      | Python | AI-powered skill selection with confidence scoring                    |
| `scripts/cache_manager.sh`                | Bash   | Cache status, clear, invalidate, cleanup                              |
| `Makefile`                                | Make   | Updated with new targets (make setup-wizard, make cache-status, etc.) |

---

## 🚀 Quick Start

### 1. Interactive Setup (Wizard)

```bash
# Vietnamese wizard (recommended for non-tech)
make setup-wizard

# English wizard
make setup-wizard-en

# Or direct script
./scripts/setup_interactive.sh --lang=vi
./scripts/setup_interactive.sh --lang=en
```

**What it does:**

- ✅ Asks 3 simple questions (project type, multi-project, security)
- ✅ Shows progress bar
- ✅ Auto-detects stack
- ✅ Updates config.yaml
- ✅ Runs setup automatically

---

### 2. Stack Detection with Validation

```bash
# Detect stack (with caching)
make detect-stack

# Force re-detect
bash ./scripts/detect_stack_with_validation.sh --force

# Output as JSON (for scripting)
make detect-stack-json

# Or direct
./scripts/detect_stack_with_validation.sh --json --force
```

**Features:**

- 🎯 Auto-detect: Node.js, Flutter, Python, Go, Rust, Ruby, Django, Rails, Java, .NET
- ✅ Confidence scoring
- 🚨 Detects ambiguous cases (2+ stacks)
- 💾 Caching (expires after 1 hour)
- 🛡️ Validation with suggestions

**Output example:**

```
Primary Stack: nodejs
Confidence: 85%
All Detected: nodejs, python (detected but lower priority)
```

---

### 3. Skill Confidence Scorer (AI-Powered)

```bash
# Interactive mode
make score-skills

# Score specific task
make score-skill task="Button broken on mobile"

# Or direct
./scripts/skill_confidence_scorer.py "I found a null pointer bug"
./scripts/skill_confidence_scorer.py --interactive
./scripts/skill_confidence_scorer.py --json
./scripts/skill_confidence_scorer.py --csv
```

**Features:**

- 🎯 Semantic understanding (not just keyword matching)
- 💯 Top-3 skills with confidence % (0-100)
- 🧠 Pattern matching + context boosting
- 📊 Multiple output formats (text, JSON, CSV)
- 🔄 Interactive mode for exploration

**Output example:**

```
You said: "Button broken on mobile"
Top suggestions:

  [1] 🎯 bug-investigator      75%
      Find root cause bug analysis
      Matched: bug_match, pattern_match

  [2] ⚠️  frontend-architect    45%
      UI/UX design, responsive, animation

  [3] ❓ code-reviewer         20%
      Quality gates, code review
```

---

### 4. Cache Management

```bash
# Check cache status
make cache-status

# Clear cache (all files)
make cache-clear-all

# Clear specific pattern
make cache-clear pattern="pr_review"

# Invalidate cache older than 1 hour
make cache-invalidate age=1h

# Auto-cleanup (invalidate old + respect size limit from config)
make cache-cleanup
```

**Features:**

- 📦 View cache contents & size
- 🗑️ Selective or full deletion
- ⏰ Time-based invalidation (1h, 30m, etc.)
- 📏 Size limit enforcement (configured in config.yaml)
- 🧹 Auto-cleanup with smart defaults

**Output example:**

```
Cache Contents:

  File                                      Size       Age
  ==============================================================
  pr_review_cache_abc123.json              4.2KB      2h ago
  stack_detection_cache.json               1.1KB      5m ago

Summary:
  Files: 2
  Total Size: 5.3KB / 100MB
  Status: ✅ OK (0% full)
```

---

## ⚙️ Configuration (config.yaml)

All settings in one place:

```yaml
# Language & Output
language: vi # vi, en, es, pt
output:
  format: console # console, json, markdown, html
  verbose: true
  colors: true

# Setup & Detection
setup:
  auto_detect_stack: true
  prompt_on_ambiguous: true
  cache_detection: true
  default_stack: nodejs

# Skill Selection
skills:
  enable_confidence_scoring: true
  suggest_top_n: 3
  allow_manual_override: true
  enable_composition: true

# Deployment
deployment:
  auto_backup_before_deploy: true
  rollback_window_hours: 24
  require_approval: false
  test_before_deploy: true
  parallel_deploy: true

# Cache
cache:
  enabled: true
  location: ./.agent/.cache
  auto_invalidate_hours: 1
  max_size_mb: 100

# Logging & Metrics
logging:
  level: info
  file: ./.agent/logs/workflow.log
  rotation_mb: 10
  keep_days: 30

metrics:
  enabled: true
  track_usage: true
  track_success_rate: true
  report_frequency: weekly

# Security
security:
  require_audit_before_ship: true
  scan_for_secrets: true
  require_test_coverage: 80

# UI/UX
ui:
  theme: auto
  show_progress_bar: true
  interactive_mode: true
  confirmation_required: true
```

---

## 🔧 Detailed Script Documentation

### setup_interactive.sh

**Purpose:** Beginner-friendly wizard (replaces complex CLI flags)

**Usage:**

```bash
./scripts/setup_interactive.sh
./scripts/setup_interactive.sh --lang=vi
./scripts/setup_interactive.sh --lang=en --non-interactive
```

**Questions Asked:**

1. "What type of project? (1) Node.js (2) Flutter (3) Python (4) Other"
2. "Do you manage multiple projects? (Y/N)"
3. "Enable security checks? (Y/N)"

**Output:**

- Updates `config.yaml` with answers
- Runs `./sync.sh` with detected stack
- Shows completion message with help links

**Key Features:**

- ✅ Auto-detects stack
- ✅ Progress bar (3/3)
- ✅ Vietnamese + English support
- ✅ Help links in output
- ✅ Non-interactive mode for CI/CD

---

### detect_stack_with_validation.sh

**Purpose:** Robust tech stack detection with validation

**Supports:**

- Node.js (package.json, package-lock.json, tsconfig.json)
- Flutter (pubspec.yaml, pubspec.lock)
- Python (requirements.txt, setup.py, pyproject.toml, venv/)
- Go (go.mod, go.sum)
- Rust (Cargo.toml, Cargo.lock)
- Ruby (Gemfile, Rakefile)
- Django (manage.py)
- Rails (config/rails_env.rb)
- Java (pom.xml, build.gradle)
- .NET (\*.csproj)

**Scoring:**

- Primary detector (30 pts): e.g., package.json for Node
- Secondary indicators (10-20 pts each): lock files, configs
- Confidence score: 0-100%

**Caching:**

- Stores detection in `.agent/.stack_detection_cache`
- Expires after 1 hour
- Force refresh: `--force`

**Output formats:**

- Text: Human-readable with colors
- JSON: For scripting integration
  ```json
  {
    "primary": "nodejs",
    "detected": ["nodejs", "python"],
    "confidence": 85
  }
  ```

---

### skill_confidence_scorer.py

**Purpose:** AI-powered skill selection (semantic, not keyword-based)

**Algorithm:**

```
Scoring:
├─ Keyword match (30 pts) - Does input contain skill keywords?
├─ Pattern match (40 pts) - Regex patterns (bug=error|crash|issue)
├─ Context boost (20 pts) - Contextual clues (production, urgent)
├─ Normalize (0-100)
└─ Sort & return top-3
```

**Skills Supported:**

- bug-investigator
- code-reviewer
- frontend-architect
- tech-lead
- security-auditor
- test-engineer
- product-manager
- copywriter
- vibecoder

**Output Formats:**

```bash
# Text (default, colored)
./scripts/skill_confidence_scorer.py "find memory leak"

# JSON (for scripting)
./scripts/skill_confidence_scorer.py --json "find memory leak"

# CSV (for reporting)
./scripts/skill_confidence_scorer.py --csv "find memory leak"

# Interactive mode
./scripts/skill_confidence_scorer.py --interactive
```

**Example Output (Text):**

```
You said: API response slow on production

Top suggestions:

  [1] 🎯 tech-lead               95%
      Architecture & performance analysis

  [2] ⚠️  security-auditor        40%
      Security & vulnerability checks

  [3] ❓ code-reviewer           25%
      Code quality & edge cases

═══════════════════════════════════
```

---

### cache_manager.sh

**Purpose:** View, clear, and manage cache system

**Commands:**

```bash
# Show what's cached
./scripts/cache_manager.sh status

# Delete all cache
./scripts/cache_manager.sh clear

# Delete by pattern
./scripts/cache_manager.sh clear --pattern="pr_review"

# Delete cache older than 1 hour
./scripts/cache_manager.sh invalidate --age=1h

# Auto-cleanup (respects config.yaml settings)
./scripts/cache_manager.sh cleanup

# Dry-run (show what would delete, don't delete)
./scripts/cache_manager.sh clear --dry-run
```

**Output (status):**

```
Cache Contents:

  File                              Size       Age
  ===========================================================
  pr_review_cache_abc123.json      4.2KB      2h ago
  skill_selection_cache.json       2.1KB      30m ago

Summary:
  Files: 2
  Total Size: 6.3KB / 100MB
  Status: ✅ OK (0% full)
```

---

## 🚀 Workflow Integration

### Recommended Setup Sequence

```bash
# 1. First time setup (interactive wizard)
make setup-wizard
# → Answers 3 questions, auto-detects stack

# 2. Detect stack separately (if needed)
make detect-stack
# → Validates stack detection

# 3. Run skill scorer for a task
make score-skill task="Add login form"
# → Shows top 3 skills (e.g., frontend-architect 85%)

# 4. Monitor cache
make cache-status
# → Checks cache size and age

# 5. Clean cache as needed
make cache-cleanup
# → Auto-invalidate old + respect size limit
```

---

## 📊 API Quick Reference

### Bash Scripts

```bash
# Setup interactive
./scripts/setup_interactive.sh
  Options: --lang=vi/en, --non-interactive, --stack=<type>

# Stack detection
./scripts/detect_stack_with_validation.sh
  Options: --json, --force, --error-on-ambiguous

# Cache management
./scripts/cache_manager.sh <cmd>
  Commands: status, clear, invalidate, cleanup
  Options: --pattern=<regex>, --age=<spec>, --dry-run
```

### Python Scripts

```bash
# Skill scorer
python3 ./scripts/skill_confidence_scorer.py <input>
  Options: --json, --csv, --interactive, --top-n=<number>
```

### Make Targets

```bash
# Setup
make setup-wizard
make setup-wizard-en
make detect-stack
make detect-stack-json

# Skills
make score-skills        # interactive
make score-skill task=...

# Cache
make cache-status
make cache-clear [pattern=...]
make cache-cleanup
```

---

## 📈 Metrics & Logging

All operations logged to `.agent/logs/workflow.log`:

```
2026-03-09 10:30:45 INFO [setup_interactive.sh] User selected: nodejs, multi_project=true, security=true
2026-03-09 10:31:12 INFO [detect_stack] Detection: nodejs (confidence=85%)
2026-03-09 10:31:15 INFO [skill_scorer] Input: "Button broken on mobile" → bug-investigator (75%), frontend-architect (45%)
2026-03-09 10:32:00 INFO [cache_manager] Cleanup: 5 files deleted, 15.2MB freed
```

Metrics available at: `make show-metrics` (future)

---

## ✅ Implementation Checklist

- [x] config.yaml created with all settings
- [x] setup_interactive.sh - Working wizard
- [x] detect_stack_with_validation.sh - Stack detection
- [x] skill_confidence_scorer.py - AI skill selection
- [x] cache_manager.sh - Cache management
- [x] Makefile updated with new targets
- [ ] Scripts tested with 2+ team members (next)
- [ ] Video tutorials recorded (next)
- [ ] Documentation links added to GETTING_STARTED (next)

---

## 💡 Tips & Troubleshooting

### Q: Scripts not executable?

```bash
chmod +x scripts/*.sh
```

### Q: Python script not working?

```bash
# Check Python version
python3 --version  # Need 3.9+

# Or use through make
make score-skills
```

### Q: Cache location wrong?

```bash
# Edit config.yaml
cache:
  location: /custom/path/.cache
```

### Q: Want to disable auto-cache?

```yaml
# config.yaml
cache:
  enabled: false
```

---

**Next Steps:**

1. Run `make setup-wizard` to start
2. Test `make score-skills` for skill selection
3. Check `make cache-status` for cache info
4. Read feedback from team members
5. Iterate based on usage patterns

Good luck! 🚀
