# 🤝 Contributing Guidelines

Hướng dẫn đóng góp vào AI Development Workflow của dự án the project.

## 📋 Quy trình Đóng góp

### 1. Fork & Clone
```bash
git clone https://github.com/[your-fork]/development-workflow.git
cd development-workflow
```

### 2. Tạo Branch
```bash
git checkout -b feat/your-feature-name
# hoặc
git checkout -b fix/your-fix-name
```

### 3. Thực hiện Thay đổi
- Tuân thủ các quy tắc format bên dưới
- Chạy validation trước khi commit

### 4. Validate
```bash
./scripts/validate.sh
```

### 5. Commit & Push
```bash
git add .
git commit -m "feat: Add your feature description"
git push origin feat/your-feature-name
```

### 6. Tạo Pull Request
- Mô tả rõ thay đổi
- Link đến issue (nếu có)

---

## 📁 Cấu trúc Thư mục

```
development-workflow/
├── workflows/          # Các quy trình làm việc
├── skills/             # Chuyên môn theo vai trò
├── rules/              # Luật và conventions
├── scripts/            # Công cụ tự động hóa
├── memory/             # Knowledge base
├── README.md
├── CHANGELOG.md
├── VERSION
└── CONTRIBUTING.md
```

---

## 📝 Quy tắc Format

### Workflow Files (`workflows/*.md`)

**YAML Frontmatter bắt buộc:**
```yaml
---
description: "Mô tả ngắn gọn về workflow"
trigger: /command-name
version: "X.Y.Z"
skills:
  - skill-name-1
  - skill-name-2
---
```

**Nội dung:**
- Bắt đầu bằng heading H1 với emoji
- Có section "Mục tiêu" rõ ràng
- Có section "Các bước thực hiện"
- Có "Hướng dẫn cho AI" ở cuối

### Skill Files (`skills/*/SKILL.md`)

**YAML Frontmatter bắt buộc:**
```yaml
---
name: skill-name
description: Mô tả skill
---
```

**Sections nên có:**
- When to use
- When NOT to use
- Example Triggers
- Interface Definition (Inputs/Outputs)

### Knowledge Base Entries

Theo format chuẩn:
```markdown
### KB-XXX: [Title]
- **Tags:** `tag1`, `tag2`
- **Problem/Pattern/Rule:** [Mô tả]
- **Solution/Reason:** [Giải thích]
- **Discovered:** [Date hoặc Context]
```

---

## 🏷️ Commit Convention

| Prefix | Sử dụng khi |
|:--|:--|
| `feat:` | Thêm workflow/skill mới |
| `fix:` | Sửa lỗi trong workflow |
| `docs:` | Cập nhật documentation |
| `refactor:` | Cải thiện cấu trúc |
| `chore:` | Maintenance tasks |

---

## 🔢 Versioning

Tuân theo [Semantic Versioning](https://semver.org/):

- **MAJOR (X.0.0):** Breaking changes
- **MINOR (0.X.0):** Thêm tính năng mới
- **PATCH (0.0.X):** Bug fixes, typos

**Khi bump version:**
1. Cập nhật `VERSION` file
2. Cập nhật `CHANGELOG.md`
3. Cập nhật tất cả workflow frontmatter (dùng script)

---

## ✅ Checklist Trước khi PR

- [ ] `./scripts/validate.sh` passed
- [ ] Đã cập nhật CHANGELOG.md
- [ ] Đã test workflow thực tế (nếu có thể)
- [ ] Không có hardcoded paths
- [ ] Tuân thủ naming convention

---

## 💡 Ý tưởng Đóng góp

**Dễ:**
- Thêm examples cho skills
- Cải thiện documentation
- Thêm entries vào Knowledge Base

**Trung bình:**
- Thêm workflows mới
- Cải thiện scripts automation
- Thêm flowcharts cho workflows phức tạp

**Khó:**
- Thiết kế Skill Orchestrator
- Integration tests cho workflows
- Multi-project support

---

## 📊 Metrics Logging

Khi hoàn thành workflow quan trọng, update metrics để theo dõi hiệu suất:

### Log Workflow Usage

Thêm entry vào `memory/usage-patterns.md`:

```markdown
### [YYYY-MM-DD] /workflow-name
- **Outcome:** success | partial | blocked
- **Duration:** quick (<5min) | medium (5-30min) | long (>30min)
- **Context:** [Brief description]
- **Skills Used:** skill-1, skill-2
- **Blockers:** [If any]
- **Insights:** [Key learnings]
```

### Update Dashboard

Cuối mỗi tháng, aggregate data vào `memory/metrics.md`:
1. Tổng hợp workflow executions
2. Cập nhật leaderboard
3. Phân tích patterns và trends
4. Document actionable insights

---

## 📞 Liên hệ

Nếu có thắc mắc, vui lòng tạo Issue hoặc liên hệ maintainer.
