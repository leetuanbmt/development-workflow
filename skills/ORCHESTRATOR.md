---
name: skill-orchestrator
description: Dispatch rules đơn giản cho 8 core skills
version: "3.0.0"
---

# 🎭 Skill Orchestrator (Simplified)

Dispatch skill dựa trên keyword đơn giản. Không composite mặc định.

---

## 📋 Dispatch Rules

| Pattern | Skill | Priority |
|:---|:---|:---:|
| `bug`, `lỗi`, `crash`, `error`, `stacktrace` | `bug-investigator` | 1 |
| `review`, `check`, `kiểm tra`, `PR` | `code-reviewer` | 1 |
| `performance`, `slow`, `leak`, `memory`, `jank` | `flutter-expert` | 1 |
| `security`, `hack`, `token`, `secret`, `api key` | `security-auditor` | 1 |
| `design`, `thiết kế`, `feature`, `architecture` | `feature-architect` | 2 |
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

## 💡 Usage

AI tự động dispatch dựa trên request. User không cần chỉ định skill.

```
User: "Review file này"     → code-reviewer
User: "Tại sao app crash?"  → bug-investigator  
User: "App chạy chậm quá"   → flutter-expert
```

---

## 📦 Active Skills (8)

| Skill | Focus |
|:---|:---|
| `bug-investigator` | Root cause analysis, debugging |
| `code-reviewer` | Code quality, architecture check |
| `flutter-expert` | Performance, memory, Flutter specifics |
| `feature-architect` | Feature design, layer breakdown |
| `tech-lead` | Architecture decisions, mentoring |
| `test-engineer` | Unit/Widget/Integration tests |
| `security-auditor` | Vulnerabilities, secrets scan |
| `vibecoder` | Fast implementation, full-stack |

---

*Deprecated skills archived in `skills/_deprecated/`*
