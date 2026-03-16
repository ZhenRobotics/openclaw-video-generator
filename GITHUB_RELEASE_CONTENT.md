# GitHub Release Content - v1.2.0

直接复制粘贴到 GitHub Release 页面

---

## Title (Release Title)

```
v1.2.0 - Background Video Support
```

---

## Description (Release Body)

```markdown
## 🎉 Background Video Support

The biggest feature in this release - you can now add custom background videos to your generated content!

### ✨ Key Features

- 🖼️ **Custom Background Videos** - Add any MP4 video as background
- 🎨 **Opacity Control** - Adjust background transparency (0-1)
- 🌈 **Overlay Customization** - Custom overlay colors for better text visibility
- 🔄 **Automatic Loop** - Background videos loop seamlessly
- 📦 **Auto File Management** - Videos automatically copied to `public/` directory

### 🚀 Quick Start

```bash
./scripts/script-to-video.sh scripts/my-script.txt \
  --voice nova \
  --speed 1.15 \
  --bg-video /path/to/background.mp4 \
  --bg-opacity 0.4
```

### 📊 Recommended Settings

| Use Case | Opacity | Overlay Color |
|----------|---------|---------------|
| Text-focused | 0.2-0.3 | `rgba(0, 0, 0, 0.7)` |
| Balanced | 0.4-0.5 | `rgba(10, 10, 15, 0.6)` ⭐ |
| Visual-focused | 0.6-0.8 | `rgba(0, 0, 0, 0.4)` |

### 🔧 New Command-Line Parameters

- `--bg-video <path>` - Path to background video file
- `--bg-opacity <0-1>` - Background opacity (default: 0.3)
- `--bg-overlay <color>` - Overlay color (default: rgba(10,10,15,0.6))

### 🔄 Migration from v1.1.0

**No breaking changes!** All existing workflows continue to work. The background video feature is optional and can be enabled by adding `--bg-video` parameter.

### 📦 What's Changed

**Full Changelog**: https://github.com/ZhenRobotics/openclaw-video-generator/compare/v1.1.0...v1.2.0

- ✨ Added background video support with opacity control
- 🎨 Added background overlay customization
- 🔧 Extended command-line parameters
- 📝 Updated documentation with usage examples
- 📦 **Package name changed** to `openclaw-video-generator` (aligned with repository name)
- ✅ Full integration testing completed

### 📝 Documentation

- [Release Notes](https://github.com/ZhenRobotics/openclaw-video-generator/blob/main/RELEASE_NOTES_v1.2.0.md)
- [README](https://github.com/ZhenRobotics/openclaw-video-generator/blob/main/README.md)
- [Skill Guide](https://github.com/ZhenRobotics/openclaw-video-generator/blob/main/openclaw-skill/SKILL.md)

### 📦 Installation

```bash
# From npm
npm install -g openclaw-video-generator

# From GitHub
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
npm install
```

### 🎯 Usage

```bash
openclaw-video-generator help
# or use the short alias
openclaw-video help
```

---

**Happy video creating with backgrounds! 🎬✨**
```

---

## Settings

- ✅ Tag: v1.2.0 (should be auto-selected)
- ✅ Target: main
- ✅ Set as the latest release: **Check this box**
- ⬜ Set as a pre-release: **Leave unchecked**

---

## Quick Link

Create release: https://github.com/ZhenRobotics/openclaw-video-generator/releases/new?tag=v1.2.0
