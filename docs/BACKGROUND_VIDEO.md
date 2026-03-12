# Background Video Best Practices

This guide explains how to optimize background videos for use with openclaw-video-generator to avoid loading timeouts and ensure smooth rendering.

## Quick Fix for Timeout Issues

If you're getting **"Html5Video loading timeout"** errors:

1. **Optimize your video immediately**:
   ```bash
   ./scripts/optimize-background.sh your-video.mp4
   ```

2. **Use the optimized version**:
   ```bash
   openclaw-video-generator script.txt --bg-video background-optimized.mp4
   ```

3. **Test in Remotion**:
   ```bash
   pnpm exec remotion preview
   ```

## The Problem

When you add a background video to `public/background.mp4`, Remotion needs to:
1. Load the video file
2. Decode the video stream
3. Render it alongside your text animations

If the video is too large or uses inefficient encoding, this process can exceed Remotion's default 30-second timeout, causing `delayRender` timeout errors.

## Recommended Video Specifications

### Optimal Settings (Balanced)
```bash
Resolution:  1080x1920 (vertical) or 1920x1080 (horizontal)
Frame Rate:  30 fps
Codec:       H.264 (libx264)
Bitrate:     2-3 Mbps
CRF:         23
File Size:   <10 MB per minute
Duration:    <30 seconds (for short videos)
```

### Fast Loading (Mobile-Friendly)
```bash
Resolution:  720x1280 (vertical)
Bitrate:     1 Mbps
CRF:         28
File Size:   <5 MB per minute
```

### High Quality
```bash
Resolution:  1080x1920 (vertical)
Bitrate:     4 Mbps
CRF:         20
File Size:   <15 MB per minute
```

## Optimization Script Usage

### Basic Usage

```bash
# Optimize with default settings (recommended)
./scripts/optimize-background.sh input.mp4

# Specify output path
./scripts/optimize-background.sh input.mp4 public/my-background.mp4

# Fast loading (smaller file)
./scripts/optimize-background.sh input.mp4 --crf 28 --bitrate 1M

# High quality
./scripts/optimize-background.sh input.mp4 --crf 20 --bitrate 4M
```

### Advanced Options

```bash
# Custom resolution (horizontal video)
./scripts/optimize-background.sh input.mp4 --resolution 1920x1080

# Lower frame rate for smaller file
./scripts/optimize-background.sh input.mp4 --fps 24

# Fast encoding (lower quality but faster)
./scripts/optimize-background.sh input.mp4 --preset fast

# Maximum quality (slower encoding)
./scripts/optimize-background.sh input.mp4 --crf 18 --preset slow
```

### Understanding Parameters

**CRF (Constant Rate Factor)**:
- Range: 0-51 (lower = better quality)
- Recommended: 18-28
- 18: Nearly lossless (large files)
- 23: Default, good balance
- 28: Lower quality, smaller files

**Bitrate**:
- Controls average data rate
- 1M = 1 Mbps (fast loading)
- 2M = 2 Mbps (balanced)
- 4M = 4 Mbps (high quality)

**Preset**:
- ultrafast: Fastest encoding, largest file
- fast: Good speed, reasonable quality
- medium: Default, balanced
- slow: Best compression, takes longer

## Manual Optimization with ffmpeg

If you prefer manual control:

```bash
# Basic optimization (vertical video)
ffmpeg -i input.mp4 \
  -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" \
  -r 30 \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -b:v 2M \
  -maxrate 2M \
  -bufsize 4M \
  -pix_fmt yuv420p \
  -movflags +faststart \
  -an \
  public/background-optimized.mp4

# Horizontal video
ffmpeg -i input.mp4 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" \
  -r 30 \
  -c:v libx264 \
  -preset medium \
  -crf 23 \
  -b:v 2M \
  -maxrate 2M \
  -bufsize 4M \
  -pix_fmt yuv420p \
  -movflags +faststart \
  -an \
  public/background-optimized.mp4
```

### Key ffmpeg Flags Explained

- `-vf scale=...`: Resize and pad to target resolution
- `-r 30`: Set frame rate to 30 fps
- `-c:v libx264`: Use H.264 codec
- `-preset medium`: Encoding speed/quality balance
- `-crf 23`: Quality setting (lower = better)
- `-b:v 2M`: Target bitrate
- `-maxrate 2M`: Maximum bitrate
- `-bufsize 4M`: Buffer size (2x maxrate)
- `-pix_fmt yuv420p`: Color format (compatible)
- `-movflags +faststart`: Enable streaming (fast start)
- `-an`: Remove audio (not needed for background)

## Using Optimized Videos

### Option 1: CLI Flag
```bash
openclaw-video-generator script.txt \
  --bg-video background-optimized.mp4 \
  --bg-opacity 0.7
```

### Option 2: Update scenes-data.ts
```typescript
export const videoConfig = {
  fps: 30,
  width: 1080,
  height: 1920,
  durationInFrames: 552,
  audioPath: 'audio.mp3',
  bgVideo: 'background-optimized.mp4',  // ← Use optimized version
  bgOpacity: 0.7,
  bgOverlayColor: 'rgba(10, 10, 15, 0.25)',
};
```

### Option 3: Direct File Replacement
```bash
# Replace existing background
mv public/background.mp4 public/background-original.mp4
./scripts/optimize-background.sh public/background-original.mp4 public/background.mp4
```

## Troubleshooting

### Still Getting Timeout Errors?

1. **Check file size**:
   ```bash
   ls -lh public/background.mp4
   # Should be <50 MB for a 30-second video
   ```

2. **Increase timeout** (already configured in remotion.config.ts):
   ```typescript
   Config.setDelayRenderTimeoutInMilliseconds(60000); // 60 seconds
   ```

3. **Use lower quality**:
   ```bash
   ./scripts/optimize-background.sh input.mp4 --crf 28 --bitrate 1M
   ```

4. **Reduce video length**:
   ```bash
   # Trim to 20 seconds
   ffmpeg -i input.mp4 -t 20 -c copy trimmed.mp4
   ./scripts/optimize-background.sh trimmed.mp4
   ```

### Video Not Loading at All?

1. **Check file exists**:
   ```bash
   ls -la public/background.mp4
   ```

2. **Check file format**:
   ```bash
   ffprobe public/background.mp4
   # Should show: Video: h264, yuv420p
   ```

3. **Test in Remotion Studio**:
   ```bash
   pnpm exec remotion preview
   # Open browser and check for errors
   ```

### Black Screen or Flickering?

1. **Check opacity setting**:
   - Default: 0.7 (70% visible)
   - Too low: Video barely visible
   - Too high: Text hard to read

2. **Adjust overlay color**:
   ```bash
   # Darker overlay for better text visibility
   --bg-overlay "rgba(10, 10, 15, 0.5)"
   ```

3. **Check video loop**:
   - Videos automatically loop
   - Ensure seamless loop point for best effect

## Best Practices Summary

✅ **DO**:
- Use H.264 codec (libx264)
- Keep files under 50 MB
- Target 2-3 Mbps bitrate
- Use 30 fps for smooth playback
- Enable faststart flag
- Remove audio track
- Test in Remotion Studio first

❌ **DON'T**:
- Use 4K resolution (overkill for 1080x1920)
- Use high bitrate (>5 Mbps unnecessary)
- Include audio in background video
- Use exotic codecs (VP9, AV1)
- Skip optimization step

## Performance Impact

| Video Size | Load Time | Render Speed | Recommendation |
|------------|-----------|--------------|----------------|
| <10 MB     | <2s       | Fast         | ✅ Excellent   |
| 10-30 MB   | 2-5s      | Good         | ✅ Good        |
| 30-50 MB   | 5-10s     | Acceptable   | ⚠️  Optimize   |
| >50 MB     | >10s      | Slow         | ❌ Too large   |

## Examples

### Example 1: Optimize a Long Video

```bash
# Original: 200 MB, 2 minutes, 4K resolution
# Target: <30 MB, 1080p, good quality

./scripts/optimize-background.sh original.mp4 \
  --resolution 1080x1920 \
  --bitrate 2M \
  --crf 23

# Result: ~24 MB, loads in 3 seconds ✅
```

### Example 2: Mobile-Optimized

```bash
# For fast mobile loading
./scripts/optimize-background.sh original.mp4 \
  --resolution 720x1280 \
  --bitrate 1M \
  --crf 28 \
  --preset fast

# Result: ~8 MB, loads in <2 seconds ✅
```

### Example 3: Maximum Quality

```bash
# For high-quality final output
./scripts/optimize-background.sh original.mp4 \
  --resolution 1080x1920 \
  --bitrate 4M \
  --crf 18 \
  --preset slow

# Result: ~48 MB, excellent quality ✅
```

## Additional Resources

- **Remotion Video Documentation**: https://www.remotion.dev/docs/video
- **FFmpeg H.264 Encoding Guide**: https://trac.ffmpeg.org/wiki/Encode/H.264
- **Understanding CRF**: https://slhck.info/video/2017/02/24/crf-guide.html

## FAQ

**Q: Can I use animated GIFs as backgrounds?**
A: No. Convert to MP4 first:
```bash
ffmpeg -i input.gif output.mp4
./scripts/optimize-background.sh output.mp4
```

**Q: What about transparency/alpha channel?**
A: H.264 doesn't support transparency. Use solid backgrounds with overlay opacity instead.

**Q: Can I use multiple background videos?**
A: Not currently. Use a single looping video or create scene-specific backgrounds in SceneRenderer.

**Q: How do I create a seamless loop?**
A: Use video editing software (Adobe Premiere, DaVinci Resolve) or:
```bash
# Crossfade last 1 second with first 1 second
ffmpeg -i input.mp4 -filter_complex "zoompan=z='zoom+0.002':d=25*1:s=1080x1920" loop.mp4
```

---

**Need Help?** Open an issue at https://github.com/ZhenRobotics/openclaw-video-generator/issues
