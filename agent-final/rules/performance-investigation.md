---
description: Patterns for investigating memory leaks, OOM crashes, and performance bottlenecks in the Flutter app. Use when working with resource-intensive components (Camera, PDF, Large Images) or when investigating crashes/lag.
globs: lib/**/*.dart
alwaysApply: true
---

# Performance & Memory Rules

This rule provides persistent guidance for identifying and preventing performance issues and memory leaks.

## 🏁 Investigation Triggers
- User reports "crash", "sluggishness", "lag", or "OOM".
- Working with `CameraController`, `PdfViewer`, or large list/images.
- Editing a `StatefulWidget` or `BLoC`.

## 🛠 Required Investigation Actions
1. **Resource Audit**: Check for missing `dispose()` or `cancel()` calls.
2. **Context Leak Check**: Verify `if (!mounted)` is used before `BuildContext` operations in async blocks.
3. **Heavy Component Review**: Ensure large assets (Photos, PDFs) are not held in memory beyond their lifecycle.
4. **Memory Profiling**: If unsure, guide the user to take a heap snapshot via Flutter DevTools.

## 🔴 Memory Leak Examples & Fixes

### Missing Controller Disposal
```dart
// ❌ BAD: Memory leak
class _MyState extends State<MyWidget> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) => TextField(controller: _controller);
}

// ✅ GOOD: Resource cleaned up
class _MyState extends State<MyWidget> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Uncanceled Stream Subscription
```dart
// ❌ BAD: Subscription lives forever
_stream.listen((data) { ... });

// ✅ GOOD: Subscription canceled on dispose
late StreamSubscription _sub;
@override
void initState() {
  _sub = _stream.listen((data) { ... });
}
@override
void dispose() {
  _sub.cancel();
  super.dispose();
}
```

## ⚡ Performance Optimization
- Use `const` constructors wherever possible.
- Use `ListView.builder` for lists (never `ListView(children: ...)` for dynamic data).
- Use `Isolate.run()` for heavy JSON parsing or data processing.

> [!TIP]
> Always verify fixes using `flutter run --profile` and Monitoring the **Memory** tab in DevTools.
