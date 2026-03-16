# ClawHub Update Content - v1.2.0

上传到 ClawHub 的更新内容

---

## Changelog (更新说明)

复制以下内容到 ClawHub 的更新说明框：

```markdown
## v1.2.0 - Background Video Support (2026-03-07)

### 🎉 新功能

现在可以为生成的视频添加自定义背景视频！

### ✨ 主要特性

- 🖼️ **自定义背景视频** - 支持任意 MP4 视频作为背景
- 🎨 **透明度控制** - 0-1 范围精确调节背景可见度
- 🌈 **遮罩层自定义** - 自定义遮罩颜色，确保文字清晰可读
- 🔄 **自动循环播放** - 背景视频无缝衔接
- 📦 **文件自动管理** - 视频文件自动复制到项目目录

### 🚀 快速使用

```bash
./scripts/script-to-video.sh scripts/my-script.txt \
  --bg-video /path/to/background.mp4 \
  --bg-opacity 0.4
```

### 📊 推荐配置

| 用途 | 透明度 | 说明 |
|------|--------|------|
| 文字为主 | 0.2-0.3 | 背景若隐若现 |
| 平衡效果 | 0.4-0.5 | 推荐设置 ⭐ |
| 背景突出 | 0.6-0.8 | 背景较明显 |

### 🔧 新增参数

- `--bg-video <path>` - 背景视频文件路径
- `--bg-opacity <0-1>` - 背景透明度（默认：0.3）
- `--bg-overlay <color>` - 遮罩颜色（默认：rgba(10,10,15,0.6)）

### 📦 npm 包更新

包名已更新为 `openclaw-video-generator`（与 GitHub 仓库名保持一致）

**安装：**
```bash
npm install -g openclaw-video-generator
```

**使用：**
```bash
openclaw-video-generator help
# 或使用简短别名
openclaw-video help
```

### 🔄 兼容性

✅ **无破坏性变更** - 所有现有功能保持兼容
✅ 背景视频为可选功能
✅ 默认行为不变

### 📚 文档

- GitHub: https://github.com/ZhenRobotics/openclaw-video-generator
- npm: https://www.npmjs.com/package/openclaw-video-generator
- 完整发布说明: [RELEASE_NOTES_v1.2.0.md](https://github.com/ZhenRobotics/openclaw-video-generator/blob/main/RELEASE_NOTES_v1.2.0.md)
```

---

## 上传 SKILL.md

文件位置: `openclaw-skill/SKILL.md`

**注意：** SKILL.md 已经更新到 v1.2.0，包含：
- 新版本号信息
- 背景视频功能说明
- 更新的使用示例
- npm 包名更新

---

## 版本设置

- **Version Tag**: v1.2.0
- **Release Date**: 2026-03-07
- **Change Type**: Feature Release

---

## Quick Link

ClawHub Skill 页面: https://clawhub.ai/ZhenStaff/video-generator
