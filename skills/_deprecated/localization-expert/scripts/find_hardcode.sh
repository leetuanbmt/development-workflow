#!/bin/bash
# Script tìm kiếm các chuỗi String bị hardcode trong thư mục lib/
# Bỏ qua các file .g.dart, .freezed.dart và các dòng print/log

echo "🔍 Đang quét tìm Hardcoded Strings trong UI..."

grep -rE "Text\(['\"]" $1 \
  | grep -v ".g.dart" \
  | grep -v ".freezed.dart" \
  | grep -v "package:" \
  | grep -v "import" \
  | grep -v "//"

echo "⚠️  Lưu ý: Kết quả trên có thể chứa cả các key hợp lệ. Hãy kiểm tra kỹ."
