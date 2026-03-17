#!/bin/bash

# OpenClaw Video Generator - Premium Styles Test Script

echo "=================================="
echo "Premium Styles Test - Quick Start"
echo "=================================="
echo ""

# Step 1: Backup current scenes-data.ts
if [ -f "src/scenes-data.ts" ]; then
  echo "📦 Backing up current scenes-data.ts..."
  cp src/scenes-data.ts src/scenes-data.backup.ts
  echo "✅ Backup created: src/scenes-data.backup.ts"
  echo ""
fi

# Step 2: Use premium test configuration
echo "🔄 Switching to premium test configuration..."
cp src/scenes-data-premium-test.ts src/scenes-data.ts
echo "✅ Using: src/scenes-data-premium-test.ts"
echo ""

# Step 3: Generate test video
echo "🎬 Generating premium styles test video..."
echo "   This will showcase all 5 new premium styles"
echo ""

./scripts/script-to-video.sh scripts/premium-styles-test.txt \
  --voice nova \
  --speed 1.1

# Check if generation succeeded
if [ $? -eq 0 ]; then
  echo ""
  echo "=================================="
  echo "✅ Premium Styles Test Complete!"
  echo "=================================="
  echo ""
  echo "📹 Video generated: out/premium-styles-test.mp4"
  echo ""
  echo "Preview the video:"
  echo "  mpv out/premium-styles-test.mp4"
  echo ""
  echo "Restore original scenes-data.ts:"
  echo "  mv src/scenes-data.backup.ts src/scenes-data.ts"
  echo ""
else
  echo ""
  echo "❌ Video generation failed"
  echo "Check the error messages above"
  echo ""
  
  # Restore backup
  if [ -f "src/scenes-data.backup.ts" ]; then
    echo "🔄 Restoring original scenes-data.ts..."
    mv src/scenes-data.backup.ts src/scenes-data.ts
    echo "✅ Original configuration restored"
  fi
fi

