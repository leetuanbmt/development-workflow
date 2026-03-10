---
description: Ensures proper resource cleanup for controllers, streams, and native objects to prevent memory leaks.
globs: lib/**/*.dart
alwaysApply: true
---

# Resource Disposal Standards

All classes that manage lifecycled resources (Controllers, Streams, Sink, Animation) MUST implement proper cleanup.

## 🏁 Triggers
- Adding a `Controller` (TextEditing, Scroll, Animation, Camera).
- Calling `.listen()` on a `Stream`.
- Working with `Timer` or `FocusNode`.

## 📜 Mandatory Rules
1. **Always Override Dispose**: Any `StatefulWidget` or `Bloc`/`Cubit` that holds a controller or subscription MUST override `dispose()` or `close()`.
2. **Call Super**: Always call `super.dispose()` or `super.close()` at the END of the method.
3. **Cancel Subscriptions**: Every `StreamSubscription` created MUST be canceled explicitly.
4. **Dispose Controllers**: Every `Controller` object MUST be disposed.

## ❌ BAD
```dart
class _MyState extends State<MyWidget> {
  final _scrollController = ScrollController();
  // No dispose() method!
}
```

## ✅ GOOD
```dart
class _MyState extends State<MyWidget> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // ✅ Cleanup
    super.dispose(); // ✅ Mandatory
  }
}
```

## ✅ BLoC Example
```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  late final StreamSubscription _prefSub;

  MyBloc() : super(...) {
    _prefSub = _otherStream.listen(...);
  }

  @override
  Future<void> close() {
    _prefSub.cancel(); // ✅ Cleanup
    return super.close(); // ✅ Mandatory
  }
}
```
