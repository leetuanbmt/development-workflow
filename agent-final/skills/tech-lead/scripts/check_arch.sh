#!/bin/bash
# Script kiểm tra vi phạm Clean Architecture
# Usage: ./check_arch.sh

EXIT_CODE=0

echo "🛡️ Đang kiểm tra tuân thủ Clean Architecture..."

# 1. Kiểm tra Domain Layer
# Domain không được import Data, Presentation hoặc Flutter (UI)
echo "🔍 Checking Domain Layer Integrity..."
DOMAIN_VIOLATIONS=$(grep -rE "import.*package:.*(features/.*/data|features/.*/presentation|package:flutter/)" lib/features/*/domain 2>/dev/null)

if [ ! -z "$DOMAIN_VIOLATIONS" ]; then
    echo "❌ VI PHẠM: Domain Layer đang import các tầng khác:"
    echo "$DOMAIN_VIOLATIONS"
    EXIT_CODE=1
else
    echo "✅ Domain Layer sạch sẽ."
fi

# 2. Kiểm tra Presentation Layer
# Presentation không được import Data (phải qua Domain)
echo "🔍 Checking Presentation Layer Integrity..."
UI_VIOLATIONS=$(grep -rE "import.*package:.*features/.*/data" lib/features/*/presentation 2>/dev/null)

if [ ! -z "$UI_VIOLATIONS" ]; then
    echo "❌ VI PHẠM: Presentation Layer đang gọi trực tiếp Data Layer:"
    echo "$UI_VIOLATIONS"
    EXIT_CODE=1
else
    echo "✅ Presentation Layer sạch sẽ."
fi

# 3. Kiểm tra Logic trong UI (Sơ bộ)
# Tìm các Widget dùng http package hoặc dio trực tiếp
echo "🔍 Checking Logic in UI..."
LOGIC_VIOLATIONS=$(grep -rE "import.*package:(dio|http)/" lib/features/*/presentation 2>/dev/null)

if [ ! -z "$LOGIC_VIOLATIONS" ]; then
    echo "⚠️ CẢNH BÁO: Có thể đang gọi Network trực tiếp từ UI:"
    echo "$LOGIC_VIOLATIONS"
else
    echo "✅ Không thấy gọi Network từ UI."
fi

if [ $EXIT_CODE -eq 0 ]; then
    echo "🎉 TUYỆT VỜI! Dự án tuân thủ đúng Clean Architecture."
else
    echo "🚫 Cần sửa các lỗi kiến trúc trên ngay lập tức."
fi

exit $EXIT_CODE
