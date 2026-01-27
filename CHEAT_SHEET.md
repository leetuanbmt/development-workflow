# ⚡ Quick Reference - AI Development Workflow

> Bảng tra cứu nhanh các lệnh và quy tắc thường dùng

## 🎯 Workflow Commands

### Core Workflows
| Command | Mục đích | Mode |
|:--|:--|:--:|
| `/start-task [desc]` | Bắt đầu mọi task | All |
| `/implement-feature` | Thêm tính năng | Standard |
| `/investigate` | Điều tra bug | - |
| `/fix` | Sửa bug sau investigate | Hotfix |
| `/review-code` | Review code | - |

### Specification & Design
| Command | Mục đích |
|:--|:--|
| `/write-spec` | Viết User Stories |
| `/design-feature` | Thiết kế kiến trúc |
| `/write-adr` | Ghi quyết định kiến trúc |

### Quality & Testing
| Command | Mục đích |
|:--|:--|
| `/review-pr` | Review Pull Request |
| `/write-test` | Tạo unit/widget tests |
| `/audit-architecture` | Kiểm tra Clean Arch |

### Operations
| Command | Mục đích |
|:--|:--|
| `/deploy` | Build & Deploy app |
| `/prepare-release` | Checklist trước release |
| `/setup-agent` | Cấu hình AI context |
| `/onboard-dev` | Hướng dẫn dev mới |

---

## 🛠️ Make Commands

```bash
make setup        # Cài đặt môi trường
make run-dev      # Chạy app development
make gen          # Generate code (Freezed, Drift)
make lint         # Check code style
make test         # Run all tests
make build-dev    # Build APK/IPA dev
```

---

## 🏗️ Clean Architecture Layers

```
lib/features/{feature}/
├── domain/          # Business Logic (Pure Dart)
│   ├── entities/
│   ├── repositories/  # Interfaces only
│   └── usecases/
├── data/            # Data Access
│   ├── models/
│   ├── datasources/
│   └── repositories/  # Implementation
└── presentation/    # UI
    ├── bloc/
    ├── pages/
    └── widgets/
```

**Rules:**
- ❌ Domain KHÔNG import Flutter/Data
- ❌ Presentation KHÔNG import Data
- ✅ Data implements Domain interfaces

---

## 📋 BLoC State Pattern

```dart
// ✅ Unified State (Recommended)
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState({
    @Default(Status.initial) Status status,
    @Default([]) List<Item> items,
    String? errorMessage,
  }) = _FeatureState;
}

enum Status { initial, loading, success, error }
```

---

## 🔢 Key Rules

| Rule | Value |
|:--|:--|
| Max lines per file | 150 |
| Code Gen trigger | Entity, Model, Route changes |
| Test coverage target | 80% |

---

## 🏷️ Commit Convention

```
feat: Add new feature
fix: Bug fix
refactor: Code cleanup
docs: Documentation
test: Add tests
chore: Maintenance
```

---

## 📞 Emergency Commands

```bash
# Khi build fail
make clean && make gen

# Khi code gen conflict
rm -rf **/*.g.dart **/*.freezed.dart
make gen

# Reset to clean state
git stash && git checkout develop
```
