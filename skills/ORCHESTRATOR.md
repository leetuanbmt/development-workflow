---
name: skill-orchestrator
description: Quy tắc dispatch và kết hợp skills tự động dựa trên context
version: "2.4.0"
---

# 🎭 Skill Orchestrator

Hệ thống tự động dispatch và kết hợp skills dựa trên keywords và context của yêu cầu.

---

## 📋 Keyword Dispatch Rules

### High-Velocity & Construction
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `vibe`, `build`, `implement`, `tạo`, `mới` | vibecoder | - | 0 |
| `complete`, `trọn vẹn`, `full-stack` | vibecoder | - | 0 |
| `fast`, `nhanh`, `gấp` | vibecoder | - | 1 |

### Performance & Memory
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `leak`, `memory`, `dispose` | flutter-expert | code-reviewer | 1 |
| `jank`, `giật`, `lag`, `slow`, `chậm` | flutter-expert | - | 1 |
| `optimize`, `tối ưu`, `performance` | flutter-expert | - | 2 |

### Security
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `security`, `bảo mật`, `hack` | security-auditor | tech-lead | 1 |
| `token`, `auth`, `credential` | security-auditor | - | 2 |
| `api key`, `secret`, `sensitive` | security-auditor | - | 1 |

### Architecture & Design
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `architecture`, `kiến trúc`, `layer` | tech-lead | feature-architect | 1 |
| `design`, `thiết kế`, `pattern` | feature-architect | tech-lead | 2 |
| `refactor`, `clean code` | code-reviewer | flutter-expert | 2 |

### Data & API
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `api`, `json`, `endpoint`, `retrofit` | api-integrator | - | 1 |
| `database`, `drift`, `migration` | flutter-expert | - | 1 |
| `sync`, `offline`, `cache` | flutter-expert | api-integrator | 2 |

### Testing & Quality
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `test`, `coverage`, `mock` | test-engineer | - | 1 |
| `bug`, `lỗi`, `crash`, `error` | bug-investigator | flutter-expert | 1 |
| `review`, `check`, `kiểm tra` | code-reviewer | - | 2 |

### Documentation & UX
| Keywords | Primary Skill | Secondary | Priority |
|:--|:--|:--|:--:|
| `doc`, `tài liệu`, `readme` | technical-writer | - | 1 |
| `ui`, `ux`, `design system` | ui-ux-designer | - | 1 |
| `i18n`, `localization`, `dịch` | localization-expert | - | 1 |

---

## 🔗 Composite Skills

### 1. `full-review` (Review toàn diện)
```yaml
components:
  - code-reviewer      # Logic & Architecture
  - security-auditor   # Security scan
  - flutter-expert     # Performance check
execution: parallel    # Chạy đồng thời, merge kết quả
```

**Khi nào dùng:** Review PR, kiểm tra code trước merge

### 2. `implement-complete` (Implement E2E)
```yaml
components:
  - feature-architect  # Thiết kế trước
  - flutter-expert     # Code implementation
  - test-engineer      # Viết tests
execution: sequential  # Chạy tuần tự
```

**Khi nào dùng:** Implement feature mới hoàn chỉnh

### 3. `bug-analysis` (Debug sâu)
```yaml
components:
  - bug-investigator   # Tìm root cause
  - flutter-expert     # Deep technical analysis
execution: sequential
```

**Khi nào dùng:** Bug phức tạp cần phân tích kỹ thuật sâu

### 4. `onboard-analysis` (Phân tích cho người mới)
```yaml
components:
  - tech-lead          # Tổng quan kiến trúc
  - technical-writer   # Giải thích dễ hiểu
execution: sequential
```

**Khi nào dùng:** Giải thích code/feature cho dev mới

---

## 🎯 Dispatch Algorithm

```
1. SCAN: Tìm keywords trong yêu cầu user
2. MATCH: Tra cứu bảng Keyword Dispatch Rules
3. RANK: Sắp xếp theo Priority (1 = cao nhất)
4. SELECT:
   - Nếu có 1 match → Load primary skill
   - Nếu có nhiều match → Load all matched skills
   - Nếu có secondary → Load cả secondary
5. COMPOSITE: Nếu workflow yêu cầu composite → Load theo thứ tự execution
6. EXECUTE: Thực hiện với context từ tất cả skills loaded
```

---

## 💡 Hướng dẫn cho AI

### Khi nhận yêu cầu:
1. **Đọc ORCHESTRATOR.md** này trước
2. **Scan keywords** trong yêu cầu user
3. **Load skills** phù hợp theo dispatch rules
4. **Apply composite** nếu workflow yêu cầu

### Priority Resolution:
- Priority 1 skills luôn được load
- Priority 2 skills chỉ load nếu không có Priority 1 match
- Khi conflict, ưu tiên skill được đề cập explicit trong yêu cầu

### Báo cáo Skills Used:
Sau khi hoàn thành task, báo cáo:
```
🎭 Skills Used: [skill-1], [skill-2]
```
