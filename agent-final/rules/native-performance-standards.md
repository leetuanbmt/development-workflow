---
description: Patterns for managing native memory (C/C++, Kotlin/Swift) in Flutter apps. Use when working with Camera, PDF, Image processing, or any Native plugin that exposes raw memory.
globs: lib/**/*.dart
alwaysApply: true
---

# Native Heap & Resource Management

Native plugins often allocate memory outside of the Dart VM heap. This memory is NOT automatically managed by Dart's Garbage Collector.

## 🏁 Native Triggers
- Using `camera` or `[PROJECT_NAME]_camera`.
- Using `pdf_viewer` or `PdfDocument`.
- Loading large `Uint8List` from files.
- Calling Java/Kotlin or Obj-C/Swift via `MethodChannel`.

## 📜 Mandatory Rules
1. **Explicit Disposal**: Any class that creates a `CameraController`, `PdfViewerController`, or similar MUST call its `dispose()` or `close()` method explicitly.
2. **Clear Buffers**: Large photo byte arrays (`Uint8List`) should be cleared (set to `null` or empty) as soon as they are no longer needed to free memory.
3. **Avoid Duplicates**: Do not keep multiple copies of the same image in memory. Use `Image.file` or `Image.memory` with `FilterQuality.low` or fixed cache dimensions (`cacheWidth`/`cacheHeight`) to reduce native memory pressure.
4. **Native-Side Cleanup**: If writing a native plugin, always implement a "destructor" or "close" method callable from Dart to free native C++ or GPU memory.

## ✅ Camera Example
```dart
// ❌ BAD: Leaking camera session
CameraController? _camera;
void onDispose() {
  _camera = null; // ❌ Doesn't stop native camera!
}

// ✅ GOOD: Proper native cleanup
CameraController? _camera;
void onDispose() async {
  await _camera?.dispose(); // ✅ Stops native session
  _camera = null;
}
```

## ✅ Image Cache Optimization
```dart
// ✅ GOOD: Resizes native image during decoding to save RAM
Image.file(
  file,
  cacheWidth: 300, // ✅ Resizes native buffer to 300px
  cacheHeight: 300,
)
```
