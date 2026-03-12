# Troubleshooting Guide | 故障排除指南

Common issues and solutions for openclaw-video-generator.

## Quick Links

- [Background Video Timeout](#background-video-timeout) ⚠️ **Most Common**
- [TTS Provider Failures](#tts-provider-failures)
- [OpenClaw Agent Issues](#openclaw-agent-issues)
- [Rendering Errors](#rendering-errors)
- [Installation Problems](#installation-problems)

---

## Background Video Timeout

### Problem

```
Error: Html5Video loading timeout (28s exceeded)
delayRender timeout - video failed to load
```

### Cause

Background video file is too large or uses inefficient encoding, causing Remotion to timeout while loading.

### Solution

**Quick Fix**:
```bash
# Optimize your background video
./scripts/optimize-background.sh your-video.mp4

# Use the optimized version
openclaw-video-generator script.txt --bg-video background-optimized.mp4
```

**Detailed Steps**:

1. **Check file size**:
   ```bash
   ls -lh public/background.mp4
   # Should be <50 MB for best results
   ```

2. **Optimize the video**:
   ```bash
   # Default optimization (recommended)
   ./scripts/optimize-background.sh input.mp4

   # Fast loading (smaller file)
   ./scripts/optimize-background.sh input.mp4 --crf 28 --bitrate 1M

   # High quality
   ./scripts/optimize-background.sh input.mp4 --crf 20 --bitrate 3M
   ```

3. **Test in Remotion**:
   ```bash
   pnpm exec remotion preview
   ```

### Best Practices

✅ **Recommended Settings**:
- Resolution: 1080x1920 (vertical)
- Frame Rate: 30 fps
- Bitrate: 2-3 Mbps
- File Size: <50 MB
- Codec: H.264 (libx264)

❌ **Avoid**:
- 4K resolution (overkill)
- Bitrate >5 Mbps
- File size >100 MB
- Exotic codecs (VP9, AV1)

**Full Guide**: See [docs/BACKGROUND_VIDEO.md](docs/BACKGROUND_VIDEO.md)

---

## TTS Provider Failures

### Problem

```
❌ Provider 'aliyun' failed, trying next...
🔄 Trying provider: openai
✅ Used provider: openai
```

### Cause 1: Missing Credentials

**Solution**:
```bash
# Check if credentials are set
echo $ALIYUN_ACCESS_KEY_ID
echo $ALIYUN_ACCESS_KEY_SECRET
echo $ALIYUN_APP_KEY

# Set credentials
export ALIYUN_ACCESS_KEY_ID="your-id"
export ALIYUN_ACCESS_KEY_SECRET="your-secret"
export ALIYUN_APP_KEY="your-app-key"
```

### Cause 2: Text Contamination (OpenClaw Agent)

If using through OpenClaw agent and providers keep failing:

**Already Fixed in v1.4.1** ✅

Update to latest version:
```bash
npm update -g openclaw-video-generator
```

If still having issues:
```bash
# Test TTS directly
./scripts/tts-generate.sh "测试文本" --provider aliyun --out test.mp3

# If direct test works but agent fails, report an issue
```

### Cause 3: Network Issues

**Solution**:
```bash
# Test connectivity
curl -I https://nls-gateway.cn-shanghai.aliyuncs.com

# Use different provider
export TTS_PROVIDERS="openai,aliyun,azure"

# Or force specific provider
openclaw-video-generator script.txt --provider openai
```

---

## OpenClaw Agent Issues

### Problem 1: Agent Not Found

```
bash: openclaw-video-generator: command not found
```

**Solution**:
```bash
# Install globally
npm install -g openclaw-video-generator

# Or use local path
cd /path/to/openclaw-video-generator
./agents/video-cli.sh generate "your text"
```

### Problem 2: Agent Hangs

```
[TTS] Generating speech...
(no response)
```

**Solution**:
```bash
# Check API key
echo $OPENAI_API_KEY

# Test providers
./scripts/test-providers.sh

# Use verbose mode
DEBUG=* openclaw-video-generator script.txt
```

### Problem 3: Parameter Errors

```
Error: Unknown option --bg-video
```

**Solution**:
```bash
# Update to latest version (v1.4.1+)
npm update -g openclaw-video-generator

# Check version
openclaw-video-generator --version

# Use correct syntax
openclaw-video-generator script.txt --bg-video file.mp4 --bg-opacity 0.7
```

---

## Rendering Errors

### Problem 1: Black Screen

**Causes & Solutions**:

1. **No background video set**:
   ```bash
   # Add background
   openclaw-video-generator script.txt --bg-video background.mp4
   ```

2. **Opacity too low**:
   ```bash
   # Increase opacity
   openclaw-video-generator script.txt --bg-opacity 0.7
   ```

3. **Video file missing**:
   ```bash
   # Check file exists
   ls -la public/background.mp4
   ```

### Problem 2: Text Not Visible

**Solution**:
```bash
# Adjust overlay for better contrast
openclaw-video-generator script.txt \
  --bg-opacity 0.6 \
  --bg-overlay "rgba(10, 10, 15, 0.5)"
```

### Problem 3: Audio/Video Desync

**Already Fixed in v1.3.1** ✅

If still having issues:
```bash
# Update to latest version
npm update -g openclaw-video-generator

# Or report issue with details
```

### Problem 4: Remotion Render Fails

```
Error: Failed to render video
```

**Solution**:
```bash
# Check logs
pnpm exec remotion render Main out/video.mp4 2>&1 | tee render.log

# Try with lower concurrency
Config.setConcurrency(2);  # in remotion.config.ts

# Clear cache
rm -rf node_modules/.cache/remotion
```

---

## Installation Problems

### Problem 1: npm Install Fails

```
npm ERR! code EACCES
npm ERR! permission denied
```

**Solution**:
```bash
# Use global install with proper permissions
npm install -g openclaw-video-generator --unsafe-perm

# Or use without sudo
npm config set prefix ~/.npm-global
export PATH=~/.npm-global/bin:$PATH
npm install -g openclaw-video-generator
```

### Problem 2: pnpm Not Found

```
bash: pnpm: command not found
```

**Solution**:
```bash
# Install pnpm
npm install -g pnpm

# Or use npm instead
npm install
npm run dev
```

### Problem 3: Python Dependencies Missing

```
❌ Aliyun TTS: python3 not found
```

**Solution**:
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip

# macOS
brew install python3

# Install Python packages
pip3 install requests
```

### Problem 4: ffmpeg Not Found

```
Error: ffmpeg not found
```

**Solution**:
```bash
# Ubuntu/Debian
sudo apt install ffmpeg

# macOS
brew install ffmpeg

# Windows (use WSL or download from ffmpeg.org)
```

---

## Performance Issues

### Slow Rendering

**Solutions**:

1. **Increase concurrency**:
   ```typescript
   // remotion.config.ts
   Config.setConcurrency(8);  // Increase from 6
   ```

2. **Use faster preset**:
   ```bash
   ./scripts/optimize-background.sh video.mp4 --preset fast
   ```

3. **Lower resolution**:
   ```bash
   ./scripts/optimize-background.sh video.mp4 --resolution 720x1280
   ```

### High Memory Usage

**Solutions**:

1. **Reduce concurrency**:
   ```typescript
   Config.setConcurrency(2);
   ```

2. **Close other applications**

3. **Use smaller background video**:
   ```bash
   ./scripts/optimize-background.sh video.mp4 --bitrate 1M
   ```

---

## Getting Help

### Before Reporting Issues

1. **Update to latest version**:
   ```bash
   npm update -g openclaw-video-generator
   openclaw-video-generator --version
   ```

2. **Check documentation**:
   - [README.md](README.md)
   - [docs/BACKGROUND_VIDEO.md](docs/BACKGROUND_VIDEO.md)
   - [docs/FAQ.md](docs/FAQ.md)

3. **Enable debug mode**:
   ```bash
   DEBUG=* openclaw-video-generator script.txt 2>&1 | tee debug.log
   ```

### Reporting Issues

When creating an issue, include:

```
## Environment
- OS: (Ubuntu 22.04 / macOS 13 / Windows 11)
- Node version: (node --version)
- Package version: (openclaw-video-generator --version)
- Provider: (OpenAI / Aliyun / Azure / Tencent)

## Problem
[Clear description of the issue]

## Steps to Reproduce
1. ...
2. ...
3. ...

## Expected Behavior
[What you expected to happen]

## Actual Behavior
[What actually happened]

## Logs
[Paste relevant error messages or logs]

## Additional Context
[Any other relevant information]
```

**Submit at**: https://github.com/ZhenRobotics/openclaw-video-generator/issues

---

## Quick Reference

### Common Commands

```bash
# Optimize background video
./scripts/optimize-background.sh video.mp4

# Test TTS providers
./scripts/test-providers.sh

# Generate video
openclaw-video-generator script.txt

# With background
openclaw-video-generator script.txt --bg-video bg.mp4 --bg-opacity 0.7

# Preview in Remotion
pnpm exec remotion preview

# Check version
openclaw-video-generator --version
```

### Environment Variables

```bash
# OpenAI (Default)
export OPENAI_API_KEY="sk-..."

# Aliyun
export ALIYUN_ACCESS_KEY_ID="..."
export ALIYUN_ACCESS_KEY_SECRET="..."
export ALIYUN_APP_KEY="..."

# Azure
export AZURE_SPEECH_KEY="..."
export AZURE_SPEECH_REGION="..."

# Tencent
export TENCENT_SECRET_ID="..."
export TENCENT_SECRET_KEY="..."
export TENCENT_APP_ID="..."

# Provider Priority
export TTS_PROVIDERS="aliyun,openai,azure,tencent"
export ASR_PROVIDERS="openai,aliyun,azure,tencent"
```

---

**Last Updated**: 2026-03-12
**Version**: v1.4.1
