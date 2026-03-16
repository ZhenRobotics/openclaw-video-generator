#!/bin/bash
# Quick publish script for openclaw-video-generator v1.2.0

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📦 Publishing openclaw-video-generator v1.2.0 to npm"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd ~/openclaw-video-generator

echo "Step 1: Logging in to npm..."
npm login

if [ $? -ne 0 ]; then
    echo "❌ Login failed"
    exit 1
fi

echo ""
echo "Step 2: Publishing..."
npm publish

if [ $? -eq 0 ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  ✅ Successfully published!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Verifying..."
    sleep 2
    npm view openclaw-video-generator version
    echo ""
    echo "📦 Package page:"
    echo "   https://www.npmjs.com/package/openclaw-video-generator"
    echo ""
    echo "🧪 Test install:"
    echo "   npm install -g openclaw-video-generator@1.2.0"
    echo ""
else
    echo ""
    echo "❌ Publish failed"
    exit 1
fi
