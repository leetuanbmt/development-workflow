#!/bin/bash
# Script kiểm tra vi phạm Clean Architecture trong dự án Flutter
# Usage: ./$(basename $(dirname $(dirname $0)))/scripts/check_arch.sh [path/to/lib]

set -e

LIB_PATH="${1:-lib}"
VIOLATIONS_FOUND=0

echo "🔍 Checking Clean Architecture violations in: $LIB_PATH"
echo "=================================================="

# Rule 1: Domain không được import Data layer
echo ""
echo "📌 Rule 1: Domain layer must not import Data layer"
DOMAIN_DATA=$(grep -rn "import.*data/" "$LIB_PATH"/features/*/domain 2>/dev/null || true)
if [ -n "$DOMAIN_DATA" ]; then
    echo "❌ VIOLATION: Domain imports Data"
    echo "$DOMAIN_DATA"
    VIOLATIONS_FOUND=$((VIOLATIONS_FOUND + 1))
else
    echo "✅ Pass"
fi

# Rule 2: Domain không được import Presentation layer
echo ""
echo "📌 Rule 2: Domain layer must not import Presentation layer"
DOMAIN_PRES=$(grep -rn "import.*presentation/" "$LIB_PATH"/features/*/domain 2>/dev/null || true)
if [ -n "$DOMAIN_PRES" ]; then
    echo "❌ VIOLATION: Domain imports Presentation"
    echo "$DOMAIN_PRES"
    VIOLATIONS_FOUND=$((VIOLATIONS_FOUND + 1))
else
    echo "✅ Pass"
fi

# Rule 3: Domain không được import Flutter (trừ foundation.dart cho annotations)
echo ""
echo "📌 Rule 3: Domain layer must be Pure Dart (no Flutter imports)"
DOMAIN_FLUTTER=$(grep -rn "import 'package:flutter/" "$LIB_PATH"/features/*/domain 2>/dev/null | grep -v "foundation.dart" || true)
if [ -n "$DOMAIN_FLUTTER" ]; then
    echo "❌ VIOLATION: Domain imports Flutter"
    echo "$DOMAIN_FLUTTER"
    VIOLATIONS_FOUND=$((VIOLATIONS_FOUND + 1))
else
    echo "✅ Pass"
fi

# Rule 4: Presentation không được import Data layer trực tiếp
echo ""
echo "📌 Rule 4: Presentation layer must not import Data layer directly"
PRES_DATA=$(grep -rn "import.*\/data\/" "$LIB_PATH"/features/*/presentation 2>/dev/null | grep -v "_state\|_event" || true)
if [ -n "$PRES_DATA" ]; then
    echo "⚠️  WARNING: Presentation might import Data layer"
    echo "$PRES_DATA"
    echo "(Please verify manually - some may be false positives)"
else
    echo "✅ Pass"
fi

# Summary
echo ""
echo "=================================================="
if [ $VIOLATIONS_FOUND -eq 0 ]; then
    echo "✅ All architecture checks passed!"
    exit 0
else
    echo "❌ Found $VIOLATIONS_FOUND violation(s). Please fix before committing."
    exit 1
fi
