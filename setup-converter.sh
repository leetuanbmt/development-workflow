#!/bin/bash
# Quick Setup Script for AI Provider Converter

# This script sets up the environment to use the converter

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "📦 Creating Python virtual environment..."
    python3 -m venv venv
    
    echo "📥 Installing PyYAML..."
    source venv/bin/activate
    pip install pyyaml > /dev/null 2>&1
    echo "✅ Virtual environment ready"
else
    echo "✅ Virtual environment already exists"
fi

# Activate venv
source venv/bin/activate

echo ""
echo "🎉 Environment activated!"
echo ""
echo "Usage:"
echo "  # Convert to Claude"
echo "  python3 agent-final/scripts/ai-provider-converter.py --to claude --project-root agent-final"
echo ""
echo "  # Convert to Gemini"
echo "  python3 agent-final/scripts/ai-provider-converter.py --to gemini --project-root agent-final"
echo ""
echo "  # Convert to Copilot"
echo "  python3 agent-final/scripts/ai-provider-converter.py --to copilot --project-root agent-final"
echo ""
echo "To deactivate venv later, run: deactivate"
echo ""
