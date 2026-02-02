---
name: skill-orchestrator
description: Dispatch rules đơn giản cho 11 core skills
version: "4.0.0"
---

# 🎭 Skill Orchestrator (Simplified)

Dispatch skill dựa trên keyword đơn giản. Không composite mặc định.

---

## 📋 Dispatch Rules

| Pattern | Skill | Priority |
|:---|:---|:---:|
| `start`, `vision`, `product`, `idea`, `plan` | `product-manager` | 1 |
| `ui`, `ux`, `design`, `css`, `tailwind`, `style`, `frontend` | `frontend-architect` | 1 |
| `copy`, `text`, `content`, `writing`, `headline`, `cta` | `copywriter` | 1 |
| `bug`, `lỗi`, `crash`, `error`, `stacktrace` | `bug-investigator` | 1 |
| `review`, `check`, `kiểm tra`, `PR` | `code-reviewer` | 1 |
| `performance`, `slow`, `leak`, `memory` | `tech-lead` | 1 |
| `security`, `hack`, `token`, `secret`, `api key` | `security-auditor` | 1 |
| `design`, `thiết kế`, `feature`, `architecture` | `tech-lead` | 2 |
| `test`, `coverage`, `mock` | `test-engineer` | 2 |
| `vibe`, `fast`, `nhanh`, `implement` | `vibecoder` | 1 |
| (default - no match) | `code-reviewer` | 3 |

---

## 🎯 Algorithm

```
1. SCAN keywords trong user request
2. MATCH với bảng trên (first match wins)
3. LOAD skill tương ứng
4. EXECUTE với context từ skill đó
```

---

## 🚫 Anti-Loop Rules

1. **No self-reference:** Skill A không được gọi lại Skill A
2. **No circular:** bug-investigator → code-reviewer → bug-investigator = BLOCKED
3. **Max depth:** Tối đa 2 skills per request
4. **Timeout:** 30 phút per workflow

---

## 💡 How to Invoke Skills

### Automatic Invocation (Recommended)

When workflow frontmatter contains `skills: [skill-name]`, AI should:

1. **Read skill documentation** first: `view_file("skills/{skill-name}/SKILL.md")`
2. **Follow skill guidelines** exactly as documented
3. **Apply skill perspective** to current task
4. **Execute skill instructions** inline (no separate tool call needed)

**Example:**
```yaml
# In workflow frontmatter:
skills:
  - bug-investigator
  - code-reviewer
```

**AI behavior:**
1. Read `skills/bug-investigator/SKILL.md`
2. Apply bug investigation methodology
3. Generate report following skill's output format
4. Switch to `code-reviewer` perspective for validation

### Manual Invocation (Fallback)

User can explicitly request: "Use bug-investigator skill to analyze this error"

**AI should:**
1. Acknowledge: "Activating bug-investigator skill..."
2. Load skill: `view_file("skills/bug-investigator/SKILL.md")`
3. Execute with skill's context and constraints

---

## 🔄 Skill Chaining

Workflows can chain multiple skills sequentially:

```
/investigate (bug-investigator) → Report
      ↓
/fix (bug-investigator + code-reviewer) → Implementation → Verification
```

**Rules:**
- Max 2 skills per workflow execution
- Skills execute in order listed in frontmatter
- Each skill's output feeds into next skill's context

---

## 🎯 Context Inheritance

Skills inherit context from:
1. **Workflow:** Current workflow's objectives and constraints
2. **User request:** Original task description
3. **Codebase:** Files/features being worked on
4. **Previous skills:** Output from earlier skills in chain

```

---

## 📦 Active Skills (11)

| Skill | Focus |
|:---|:---|
| `product-manager` | Product vision, context, blueprint |
| `frontend-architect` | UI/UX, design systems, motion |
| `copywriter` | UX writing, marketing copy |
| `bug-investigator` | Root cause analysis, debugging |
| `code-reviewer` | Code quality, architecture check |
| `tech-lead` | Architecture decisions, mentoring, optimization |
| `test-engineer` | Unit/Integration tests |
| `security-auditor` | Vulnerabilities, secrets scan |
| `vibecoder` | Fast implementation, full-stack |

---

*Deprecated skills archived in `skills/_deprecated/`*
