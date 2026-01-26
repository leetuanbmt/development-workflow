#!/bin/bash
# Script dọn dẹp và chạy lại Code Generation an toàn

echo "🧹 Đang dọn dẹp file .g.dart và .freezed.dart cũ..."
find . -maxdepth 20 -name "*.g.dart" -delete
find . -maxdepth 20 -name "*.freezed.dart" -delete
find . -maxdepth 20 -name "*.gr.dart" -delete
find . -maxdepth 20 -name "*.config.dart" -delete

echo "🚀 Đang chạy build_runner (delete-conflicting-outputs)..."
dart run build_runner build --delete-conflicting-outputs

echo "✅ Đã cập nhật toàn bộ code sinh tự động!"
