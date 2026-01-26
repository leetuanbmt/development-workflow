# 🚀 Quick Reference - AI Development Workflow

## Lệnh thường dùng

| Lệnh | Mục đích |
|:---|:---|
| `/start-task [yêu cầu]` | Bắt đầu task mới (Master Workflow) |
| `/implement-feature` | Triển khai tính năng |
| `/investigate` | Điều tra và fix bug |
| `/review-code` | Review code theo DoD |
| `/review-pr` | Review Pull Request |

## Chế độ vận hành

```
/start-task [yêu cầu] --mode hotfix      # Sửa lỗi gấp
/start-task [yêu cầu] --mode standard    # Full quy trình
/start-task [yêu cầu] --mode prototype   # POC nhanh
```

## Code Generation

```bash
make gen        # Build một lần
make gen-watch  # Watch mode
make lint       # Kiểm tra lint
make test       # Chạy test
```

## Cấu trúc Feature (Clean Architecture)

```
lib/features/[feature_name]/
├── domain/          # Pure Dart: Entities, UseCases
├── data/            # DTOs, Repository Impl
└── presentation/    # UI, BLoC
```

## DoD Checklist

- [ ] Clean Architecture: 3 layers
- [ ] Lint pass: `make lint`
- [ ] Tests: Unit + Bloc
- [ ] UI States: Loading/Error/Success/Empty
- [ ] I18n: Không hardcode string
