# Release Notes - v1.2.0

**Release Date:** 2026-03-07

## 🎉 What's New

### ✨ Background Video Support

The biggest feature in this release - you can now add custom background videos to your generated content!

**Key Features:**
- 🖼️ **Custom Background Videos** - Add any MP4 video as background
- 🎨 **Opacity Control** - Adjust background transparency (0-1)
- 🌈 **Overlay Customization** - Custom overlay colors for better text visibility
- 🔄 **Automatic Loop** - Background videos loop seamlessly
- 📦 **Auto File Management** - Videos automatically copied to `public/` directory

### 🚀 Usage

**Command Line:**
```bash
./scripts/script-to-video.sh scripts/my-script.txt \
  --voice nova \
  --speed 1.15 \
  --bg-video /path/to/background.mp4 \
  --bg-opacity 0.4 \
  --bg-overlay "rgba(10, 10, 15, 0.6)"
```

**Scene Data Generation:**
```bash
node scripts/timestamps-to-scenes.js audio/timestamps.json \
  --bg-video background.mp4 \
  --bg-opacity 0.3
```

### 📊 Recommended Settings

| Use Case | Opacity | Overlay Color | Description |
|----------|---------|---------------|-------------|
| Text-focused | 0.2-0.3 | `rgba(0, 0, 0, 0.7)` | Background subtle, text very clear |
| Balanced | 0.4-0.5 | `rgba(10, 10, 15, 0.6)` | Good balance between background and text |
| Visual-focused | 0.6-0.8 | `rgba(0, 0, 0, 0.4)` | Background prominent, needs darker overlay |

## 🔧 Technical Changes

### Modified Files

1. **scripts/timestamps-to-scenes.js**
   - Added `--bg-video`, `--bg-opacity`, `--bg-overlay` parameters
   - Auto-copy background videos to `public/` directory
   - Generate background video config in `videoConfig`

2. **scripts/script-to-video.sh**
   - Added background video parameter support
   - Pass parameters through to scene generator
   - Display background info in pipeline output

3. **src/types.ts** (already supported)
   - `VideoConfig.bgVideo` - Global background video path
   - `VideoConfig.bgOpacity` - Global opacity setting
   - `SceneData.bgVideo` - Scene-specific background (overrides global)

4. **src/CyberWireframe.tsx** (already supported)
   - Render background video layer
   - Apply opacity and overlay
   - Loop and mute background video

5. **src/SceneRenderer.tsx** (already supported)
   - Support scene-specific backgrounds
   - Override global background per scene

### New Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `--bg-video` | string | - | Path to background video file |
| `--bg-opacity` | number | 0.3 | Background opacity (0-1) |
| `--bg-overlay` | string | rgba(10,10,15,0.6) | Overlay color for text visibility |

## 📝 Documentation Updates

- ✅ Updated README.md with background video section
- ✅ Updated SKILL.md with v1.2.0 features
- ✅ Added usage examples and recommendations
- ✅ Updated version in package.json

## ✅ Testing

Full integration testing completed:
- ✅ Generated test background video (ffmpeg)
- ✅ Scene data generation with background parameters
- ✅ Full pipeline video rendering
- ✅ Output video verification (1080x1920, 15s, 2.8MB)

**Test Command:**
```bash
./scripts/script-to-video.sh scripts/example-script.txt \
  --voice nova --speed 1.15 \
  --bg-video public/test-background.mp4 \
  --bg-opacity 0.4
```

**Test Output:**
- `out/test-with-background.mp4` (2.8 MB, 1080x1920, 15 seconds)
- Successfully rendered with background video at 0.4 opacity
- Text remains clearly visible with overlay

## 🔄 Migration Guide

### From v1.1.0 to v1.2.0

No breaking changes! All existing workflows continue to work.

**To use new background video feature:**

1. **Add to existing scripts:**
   ```bash
   ./scripts/script-to-video.sh your-script.txt \
     --bg-video /path/to/video.mp4 \
     --bg-opacity 0.4
   ```

2. **Manual configuration (optional):**
   ```typescript
   // In src/scenes-data.ts
   export const videoConfig = {
     // ... existing config
     bgVideo: 'background.mp4',
     bgOpacity: 0.4,
     bgOverlayColor: 'rgba(10, 10, 15, 0.6)',
   };
   ```

## 🐛 Bug Fixes

None - this is a feature release.

## 📦 Package Updates

```json
{
  "version": "1.2.0"
}
```

## 🙏 Acknowledgments

This feature was developed based on user feedback and tested extensively to ensure seamless integration with the existing pipeline.

## 📚 Next Steps

Explore the new background video feature:
1. Prepare or download a background video
2. Add `--bg-video` parameter to your generation command
3. Experiment with different opacity values
4. Customize overlay colors for your content style

## 🔗 Resources

- **GitHub**: https://github.com/ZhenRobotics/openclaw-video
- **Documentation**: README.md, openclaw-skill/SKILL.md
- **Issues**: https://github.com/ZhenRobotics/openclaw-video/issues

---

**Happy video creating with backgrounds! 🎬✨**
