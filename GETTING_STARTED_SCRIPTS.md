# 🗺️ Navigation Guide - What to Read & When

**Version:** 1.0  
**For:** Anyone getting started with new scripts/config  
**Time to read:** 5 minutes

---

## 🎯 I am... (Pick Your Role)

### 👨‍💻 I'm a Developer - I Just Want to Start

```
1. Read this file (5 min) ← You are here
2. Run: make setup-wizard (2 min)
3. Run: make score-skills (1 min to explore)
4. Done! System ready to use ✅
```

**Next:** See "How to Use Each Script" below

---

### 👥 I'm a Manager - I Need Overview

```
1. Read: DELIVERY_SUMMARY.md (10 min)
   ↓ Understand what was built, cost-benefit
2. Read: This file, "Why These Scripts" section (5 min)
3. Run: make help (1 min to see commands)
4. Share SCRIPTS_REFERENCE.md with team
```

**Question:** "Is this production-ready?" → Yes, Phase 1 testing needed

---

### 🏗️ I'm an Architect - I Need Details

```
1. Read: DELIVERY_SUMMARY.md - Technical details (15 min)
2. Read: SCRIPTS_REFERENCE.md - Full documentation (20 min)
3. Review: config.yaml - Settings architecture (10 min)
4. Review: Source code (.sh, .py files) (30 min)
5. Run: ./test_scripts_quickstart.sh (2 min validation)
```

**Question:** "Can I integrate with our CI/CD?" → Yes, see examples in SCRIPTS_REFERENCE.md

---

### 🎓 I'm a New Team Member

```
1. Read: This file (5 min)
2. Run: make setup-wizard (2 min, interactive guide)
3. Watch: Video tutorial (when available)
4. Ask: Questions in team Slack
5. You're ready!
```

**Pro Tip:** If confused, run `make help` anytime

---

### 🔧 I'm DevOps - I Need to Deploy This

```
1. Read: DELIVERY_SUMMARY.md - Integration section (10 min)
2. Review: config.yaml - All settings (15 min)
3. Review: Makefile additions (5 min)
4. Test: ./test_scripts_quickstart.sh (2 min)
5. Deploy: Add to CI/CD pipeline (30 min)
```

**Checklist:** See DELIVERY_SUMMARY.md → "Phase 3: Integration Testing"

---

## 📚 Files Guide (Cheat Sheet)

| File                           | Purpose                          | Read When             | Time  |
| :----------------------------- | :------------------------------- | :-------------------- | :---: |
| **This file**                  | Navigation guide                 | First (start here)    | 5min  |
| **DELIVERY_SUMMARY.md**        | What was built, how to test, ROI | Understanding project | 15min |
| **SCRIPTS_REFERENCE.md**       | Detailed docs for each script    | Using specific tools  | 20min |
| **config.yaml**                | All settings in one place        | Configuring system    | 5min  |
| **test_scripts_quickstart.sh** | Verify everything works          | Before deployment     | 2min  |

### Scripts to Review

| Script                            | Purpose              | Review When             | Time  |
| :-------------------------------- | :------------------- | :---------------------- | :---: |
| `setup_interactive.sh`            | Wizard for beginners | Understanding UX        | 5min  |
| `detect_stack_with_validation.sh` | Stack detection      | Learning flow           | 5min  |
| `skill_confidence_scorer.py`      | Skill selection      | Understanding algorithm | 10min |
| `cache_manager.sh`                | Cache control        | Learning features       | 5min  |

---

## 🚀 How to Use Each Script

### 1️⃣ Interactive Setup (setup_interactive.sh)

**Purpose:** Get non-tech users setup in < 2 minutes

**For:** First-time users, new team members

**Usage:**

```bash
make setup-wizard
```

**What happens:**

1. Asks 3 simple questions (project type, multi-project, security)
2. Auto-detects stack
3. Shows progress (3/3)
4. Updates config.yaml
5. Says "Done!"

**Read more:** SCRIPTS_REFERENCE.md → "setup_interactive.sh section"

---

### 2️⃣ Stack Detection (detect_stack_with_validation.sh)

**Purpose:** Automatically detect tech stack with confidence scoring

**For:** Detecting what framework/language project uses

**Usage:**

```bash
# Simple
make detect-stack

# Advanced - JSON output for scripting
make detect-stack-json
```

**Output:**

```
Primary Stack: nodejs
Confidence: 85%
All Detected: nodejs, python
```

**Read more:** SCRIPTS_REFERENCE.md → "detect_stack_with_validation.sh section"

---

### 3️⃣ Skill Selection (skill_confidence_scorer.py)

**Purpose:** AI-powered skill selection with confidence %

**For:** Deciding which AI skill to use for your task

**Usage:**

```bash
# Interactive mode
make score-skills

# Score a specific task
make score-skill task="Fix null pointer bug"

# JSON output
python3 scripts/skill_confidence_scorer.py --json "your task"
```

**Output:**

```
You said: Fix null pointer bug

[1] 🎯 bug-investigator    95%
[2] ⚠️  code-reviewer       25%
```

**Read more:** SCRIPTS_REFERENCE.md → "skill_confidence_scorer.py section"

---

### 4️⃣ Cache Management (cache_manager.sh)

**Purpose:** View, clear, and manage cache system

**For:** Seeing what's cached, freeing space, troubleshooting

**Usage:**

```bash
# See cache status
make cache-status

# Clear cache
make cache-clear-all

# Clean by pattern
make cache-clear pattern="pr_review"

# Auto-cleanup
make cache-cleanup
```

**Output:**

```
Cache Contents:
  pr_review_cache.json    4.2KB    2h ago
  skill_cache.json        1.1KB    30m ago

Status: ✅ OK (0% full)
```

**Read more:** SCRIPTS_REFERENCE.md → "cache_manager.sh section"

---

## 🎯 Common Workflows

### Workflow A: New Team Member Onboarding

```
Day 1:
  1. Clone/download workflow repository
  2. cd development-workflow
  3. make setup-wizard (answers 3 questions)
  4. make score-skills (see what skills do)

Day 2:
  1. Run /fix workflow (see system in action)
  2. Ask team questions on Slack
  3. Ready to contribute! ✅
```

---

### Workflow B: Tech Lead Evaluation

```
0. Read DELIVERY_SUMMARY.md (cost-benefit analysis)
1. make help (see what's available)
2. make detect-stack (see detection quality)
3. make score-skill task=... (test skill selection)
4. make cache-status (check cache implementation)
5. Run test_scripts_quickstart.sh (verify quality)
6. Make go/no-go decision
```

---

### Workflow C: DevOps Integration with CI/CD

```
1. Review config.yaml (understand settings)
2. Copy setup_interactive.sh to CI/CD templates
3. Add to pipeline:
   - setup_interactive.sh --non-interactive --stack=nodejs
   - detect_stack_with_validation.sh --json
   - skill_confidence_scorer.py "parse github issue"
4. Parse JSON output from scripts
5. Make decisions based on results
```

---

## ❓ FAQ - Quick Answers

### Q: Where do I start?

**A:** Run `make setup-wizard` - it will guide you through everything

### Q: What if I forget the commands?

**A:** Run `make help` anytime - lists all available commands

### Q: How do I use this with Gemini CLI?

**A:** See SCRIPTS_REFERENCE.md → "Workflow Integration" section

### Q: Can I customize settings?

**A:** Yes! Edit `config.yaml` - all settings documented there

### Q: Why are these scripts better than descriptions?

**A:** They actually work! No need to implement, just run them

### Q: Is this production-ready?

**A:** 95% yes - recommend Phase 1 team testing first (1 week)

### Q: What if script fails?

**A:** Run `./script.sh --help` for options, or check SCRIPTS_REFERENCE.md

### Q: How do I report bugs?

**A:** Share output with Slack + link to DELIVERY_SUMMARY.md issue section

---

## 📊 Decision Tree (What To Do Now?)

```
START
  ↓
  "Am I just starting?"
    → YES: Run 'make setup-wizard' ✓
    → NO: Continue
  ↓
  "Do I need to diagnose an issue?"
    → YES: Run 'make detect-stack' or 'make cache-status' ✓
    → NO: Continue
  ↓
  "Do I want to understand architecture?"
    → YES: Read DELIVERY_SUMMARY.md ✓
    → NO: Continue
  ↓
  "Do I need to integrate/deploy?"
    → YES: Read SCRIPTS_REFERENCE.md + config.yaml ✓
    → NO: Read specific script section in SCRIPTS_REFERENCE.md ✓
```

---

## ✅ Before You Start - Checklist

- [ ] You have bash installed (`bash --version`)
- [ ] You have Python3 (`python3 --version`)
- [ ] You can run make commands (`make --version`)
- [ ] You've read this file (you are here)
- [ ] You're in development-workflow root directory (`ls Makefile`)

**If any failed:** Set up your environment first, see QUICK_START.md

---

## 🎓 Learning Path (Recommended)

### Level 1: Beginner (30 min)

1. Run `make setup-wizard` (2 min) - Follow prompts
2. Read this file (5 min) - Understand structure
3. Run `make help` (1 min) - See what's possible
4. Read SCRIPTS_REFERENCE.md intro (10 min) - Get context
5. Try one script: `make score-skills` (2 min) - Get comfortable

**Result:** Can use basic system, know where help is

---

### Level 2: Intermediate (1 hour)

1. Read SCRIPTS_REFERENCE.md fully (30 min) - All details
2. Review config.yaml with comments (10 min) - Understand settings
3. Run each script once (20 min) - Hands-on practice
4. Try JSON output modes (5 min) - Advanced usage

**Result:** Can customize, help others, understand flow

---

### Level 3: Advanced (2+ hours)

1. Read DELIVERY_SUMMARY.md technical details (20 min)
2. Review source code in detail (30 min)
3. Plan CI/CD integration (20 min)
4. Run full test suite (10 min)
5. Set up monitoring/metrics (20+ min)

**Result:** Can deploy, maintain, contribute improvements

---

## 🎯 Quick Links

| Need           | Link                           |  Time  |
| :------------- | :----------------------------- | :----: |
| Setup now      | `make setup-wizard`            | 2 min  |
| Understand all | DELIVERY_SUMMARY.md            | 15 min |
| Full reference | SCRIPTS_REFERENCE.md           | 20 min |
| Verify works   | `./test_scripts_quickstart.sh` | 2 min  |
| Customize      | config.yaml                    | 5 min  |
| See commands   | `make help`                    | 1 min  |

---

## 🚀 Ready? Start Here

### For Everyone:

```bash
cd /Users/tuanvm/Documents/development-workflow
make help           # See all commands
make setup-wizard   # Start interactive wizard
```

### For Developers:

```bash
make setup-wizard    # Get started
make score-skills    # Explore skills
cat SCRIPTS_REFERENCE.md  # Learn details
```

### For Managers:

```bash
cat DELIVERY_SUMMARY.md   # Understanding project
cat config.yaml           # See settings
./test_scripts_quickstart.sh  # Verify quality
```

### For DevOps:

```bash
cat config.yaml           # Settings architecture
cat SCRIPTS_REFERENCE.md  # Integration section
./test_scripts_quickstart.sh   # Run tests
```

---

## 📞 Need Help?

1. **"How do I...?"** → Search `make help` output
2. **"I forgot..."** → Read SCRIPTS_REFERENCE.md relevant section
3. **"It failed!"** → Run script with `--help`, check error message
4. **"Tell me everything"** → Read DELIVERY_SUMMARY.md + SCRIPTS_REFERENCE.md
5. **"More questions"** → Ask team/tech-lead with link to these docs

---

**Version:** 1.0  
**Last Updated:** March 9, 2026  
**Status:** ✅ Complete & Ready

**Next Step:** Make setup-wizard → Enjoy! 🎉
