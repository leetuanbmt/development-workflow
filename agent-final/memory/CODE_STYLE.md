# Code Style & Conventions

> ⚠️ **Update the "Project-Specific" sections after running `/init`.**

**Version:** 1.0.0
**Status:** Production Guide
**Language:** [PROJECT_LANGUAGE — e.g., Dart / TypeScript / Python]

---

## Naming Conventions

### Files & Directories

```
✅ CORRECT: snake_case for files and folders (adjust per language convention)
src/features/auth/
  ├── data/remote_auth_data_source.[ext]
  ├── domain/auth_entity.[ext]
  └── presentation/auth_bloc.[ext]

❌ WRONG: Mixed case file names
  └── RemoteAuthDataSource.[ext]
```

> **Language override:** Use the naming convention of your language:
> - Dart/Python → `snake_case` files
> - TypeScript/JavaScript → `camelCase` or `kebab-case` files
> - Java/Kotlin → `PascalCase` files

### Classes & Types

```
✅ PascalCase for class names (universal)
class AuthService { }
class GetUserUseCase { }
abstract class UserRepository { }

❌ camelCase or snake_case for class names
class authService { }
class get_user_use_case { }
```

### Variables & Functions

```
✅ camelCase for variables and functions (most languages)
int currentPage = 1;
List<User> activeUsers = [];
Future<void> fetchUsers() async { }
bool isLoading = false;
String? optionalValue;

✅ SCREAMING_SNAKE_CASE for constants
const MAX_RETRY_COUNT = 3;
const API_TIMEOUT_SECONDS = 30;
```

### Booleans

```
✅ Question-form names
bool isLoading = false;
bool hasPermission = true;
bool canEdit = false;

❌ Ambiguous names
bool flag = false;
bool status = true;
bool data = false;
```

---

## Code Quality Rules

### Function Rules

| Rule | Standard |
|------|----------|
| **Size** | Max 20–30 lines per function |
| **Single purpose** | Does ONE thing only |
| **Arguments** | Max 3 arguments; prefer config objects for more |
| **Side effects** | Must be explicit and documented |

### Class Rules

| Rule | Standard |
|------|----------|
| **Single Responsibility** | One reason to change |
| **Size** | Max 150–200 lines (excluding generated code) |
| **Dependencies** | Injected, not instantiated inside |

### Comments

```
✅ GOOD: Comments explain WHY, not WHAT
// Retry logic: API returns 429 on rate limit with 30s cooldown
await Future.delayed(Duration(seconds: 30));

❌ BAD: Comments that repeat the code
// Increment counter by 1
counter++;
```

---

## Project-Specific Conventions

> **Fill in after `/init` scans your codebase.**

### State Management Pattern

```
// [Your state management pattern and conventions go here]
// e.g., BLoC, Redux, Riverpod, MobX, etc.
// Filled in by /init based on detected packages
```

### Error Handling Pattern

```
// [Your error handling approach]
// e.g., Result<T> type, exceptions, Either<L,R>, etc.
// Filled in by /init
```

### API Communication Pattern

```
// [Your API layer conventions]
// e.g., Retrofit annotations, Axios interceptors, fetch wrappers
// Filled in by /init based on detected HTTP client
```

---

## Forbidden Patterns

| Pattern | Why | Alternative |
|---------|-----|-------------|
| Hardcoded secrets/keys | Security risk | Environment config |
| `TODO` without ticket | Lost work | `TODO([TICKET-123]): description` |
| Commented-out code | Noise | Delete it; git has history |
| Magic numbers | Unreadable | Named constants |
| Deep nesting (>3 levels) | Cognitive load | Early returns / extraction |

---

## Formatting

> These are enforced by the linter. Run `[lint command]` before every commit.

- **Indentation:** [spaces/tabs, count]
- **Line length:** [max characters, e.g., 80 or 120]
- **Trailing commas:** [required in function calls? yes/no]
- **Quotes:** [single vs double, e.g., single quotes preferred]

---

## Pre-commit Checklist

Before creating a PR, verify:

- [ ] `[lint command]` passes with 0 warnings
- [ ] `[test command]` passes with ≥[COVERAGE_THRESHOLD]% coverage
- [ ] No `print()` / `console.log()` / debug statements left
- [ ] No hardcoded secrets, URLs, or magic strings
- [ ] New public functions have doc comments
