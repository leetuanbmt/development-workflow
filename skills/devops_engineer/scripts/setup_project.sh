#!/bin/bash
# Script để kiểm tra và cài đặt môi trường phát triển

echo "🔍 Đang kiểm tra môi trường..."

# Kiểm tra Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter chưa được cài đặt."
    exit 1
fi

# Kiểm tra Melos
if ! command -v melos &> /dev/null; then
    echo "📦 Đang cài đặt Melos..."
    dart pub global activate melos
fi

# Chạy make setup
echo "🛠️ Đang khởi tạo dự án (make setup)..."
make setup

echo "✅ Môi trường đã sẵn sàng!"
