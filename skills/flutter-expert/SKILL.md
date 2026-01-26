---
name: flutter-expert
description: Chuyên gia kỹ thuật Flutter & BLoC. Tối ưu hiệu năng (Performance), xử lý Memory Leak, Concurrency, Jank, và Review Code chuyên sâu.
---

# Flutter & BLoC Expert Skill (Kansuke Edition)

Sử dụng Skill này khi gặp các vấn đề kỹ thuật sâu (Deep Tech) trong Flutter như: Tối ưu hiệu năng (Performance), rò rỉ bộ nhớ (Memory Leak), xử lý đa luồng (Concurrency), hoặc debug các lỗi phức tạp liên quan đến vòng đời Widget/BLoC. Kích hoạt khi có từ khóa: "leak", "jank", "giật lag", "chậm", "optimize", "tối ưu", "bloc stream", "isolate".

## 🚀 When to use
- Khi cần tìm và sửa **Memory Leak** (quên dispose Controller, Stream subscription).
- Khi ứng dụng bị **Jank** (giật lag) khi cuộn list hoặc animation.
- Khi cần xử lý các tác vụ nặng (Heavy computation) bằng **Isolates** để không chặn UI thread.
- Khi logic **BLoC/Cubit** quá phức tạp, cần refactor sang mô hình Reactive (`rxdart`, `bloc_concurrency`).
- Khi debug các lỗi liên quan đến **RenderObject**, **BuildContext** (unsafe context usage).

## 🛑 When NOT to use
- Không dùng để code màn hình UI đơn giản (dùng `ui-ux-designer`).
- Không dùng để sửa lỗi logic nghiệp vụ cơ bản (dùng `bug-investigator` hoặc `code-reviewer`).
- Không dùng để viết tài liệu (dùng `technical-writer`).

## 💡 Example Triggers
- "Kiểm tra xem file `kotei_screen.dart` có bị memory leak không?"
- "Tại sao list view này cuộn bị giật? Tối ưu giúp mình."
- "Refactor lại logic search này dùng `debounce` để đỡ gọi API nhiều lần."
- "Debug lỗi 'Looking up a deactivated widget's ancestor'."

## 🧠 Phạm vi Chuyên môn

### 1. Advanced BLoC & State Management
- **Concurrency:** Sử dụng thành thạo `bloc_concurrency` (`droppable`, `restartable`, `sequential`).
- **Stream Manipulation:** Hiểu sâu về `rxdart`, `StreamTransformer`, `subscription`.
- **State Optimization:** Tối ưu hóa việc rebuild với `buildWhen`, `select`, và `Equatable`/`Freezed`.

### 2. Flutter Internals & Performance
- **Render Loop:** Hiểu rõ 3 cây: Widget Tree, Element Tree, RenderObject Tree.
- **Optimization:** `RepaintBoundary`, `const` constructors, `cacheExtent`.
- **Memory Safety:** Luôn kiểm tra việc `dispose` Timer, Controller, StreamSubscription.

### 3. Debugging & Tooling
- **DevTools:** Sử dụng Memory Profiler, Performance Overlay.

## 💡 Chỉ dẫn cho AI
- **Code Gen Checkpoint (QUAN TRỌNG):** Nếu thay đổi code liên quan đến `json_serializable`, `retrofit`, `freezed`, `drift` -> Dừng lại yêu cầu User chạy `make gen`.
- Ưu tiên giải pháp tối ưu bộ nhớ (Memory Efficient) hơn là code ngắn gọn.
- Luôn kiểm tra `mounted` trước khi `setState` hoặc dùng `context` trong async method.
