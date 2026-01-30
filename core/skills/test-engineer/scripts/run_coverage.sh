#!/bin/bash
# Script chạy test và kiểm tra Code Coverage

echo "🧪 Đang chạy Unit Tests..."

# Chạy test và tạo file lcov.info
flutter test --coverage

# Nếu máy có lcov, tạo báo cáo HTML (tùy chọn)
if command -v genhtml &> /dev/null; then
    echo "📊 Đang tạo báo cáo HTML..."
    genhtml coverage/lcov.info -o coverage/html
    echo "✅ Báo cáo đã sẵn sàng tại: coverage/html/index.html"
else
    echo "⚠️ genhtml chưa được cài đặt. Chỉ có file coverage/lcov.info."
fi

# Hiển thị tóm tắt độ phủ
echo "📈 Tóm tắt độ phủ code:"
lcov --summary coverage/lcov.info
