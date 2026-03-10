# Example: Review Report (Performance & Security Focus)

## 🎯 Review Target
- **Feature:** Authentication Flow
- **Files:** `auth_bloc.dart`, `login_screen.dart`, `auth_repository.dart`

## 🔴 Critical Issues (Must Fix)

### 1. Memory Leak in `login_screen.dart`
- **Location:** Line 45
- **Problem:** `TextEditingController` được khởi tạo nhưng không bao giờ được `dispose`.
- **Impact:** Rò rỉ bộ nhớ mỗi khi user vào màn hình login.
- **Fix:** Override `dispose()` và gọi `controller.dispose()`.

### 2. Hardcoded Secrets in `auth_repository.dart`
- **Location:** Line 12
- **Problem:** `apiKey = "xyz-123"` đang hardcode.
- **Impact:** Rủi ro bảo mật nghiêm trọng nếu lộ source code.
- **Fix:** Chuyển vào `Env` class và `.env` file.

## 🟡 Major Issues (Should Fix)

### 3. Unnecessary Rebuilds
- **Location:** `login_screen.dart` Line 80
- **Problem:** Dùng `BlocBuilder` bao quanh toàn bộ `Scaffold`.
- **Impact:** Rebuild toàn màn hình khi state thay đổi nhỏ (vd: validation error).
- **Fix:** Chỉ wrap widget cần thiết (vd: ErrorText, Button) hoặc dùng `BlocSelector`.

## 🟢 Suggestions (Nice to have)

- Đặt tên biến: `func1` -> `performLogin` cho rõ nghĩa.
- Dùng `const` constructor cho `SizedBox(height: 10)`.

---

## ✅ DoD Checklist
- [x] Lint Passed
- [ ] Clean Arch (Vi phạm ở Repository import UI model)
- [x] Unit Tests
