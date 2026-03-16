# GitHub Release 创建指南

## ✅ Git Tag 已创建并推送

- **Tag:** v1.2.0
- **推送状态:** ✅ 已推送到 origin

---

## 📝 手动创建 GitHub Release 步骤

### 方式 1: 通过 GitHub 网页界面（推荐）

1. **访问仓库 Releases 页面**

   打开浏览器访问：
   ```
   https://github.com/ZhenRobotics/openclaw-video-generator-generator/releases/new
   ```

2. **选择 Tag**

   - 在 "Choose a tag" 下拉框中选择 `v1.2.0`
   - 或输入 `v1.2.0`（应该自动识别已存在的 tag）

3. **填写 Release 信息**

   **Release Title:**
   ```
   v1.2.0 - Background Video Support
   ```

   **Description:** （复制下面的内容）
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

   - ✨ Added background video support with opacity control
   - 🎨 Added background overlay customization
   - 🔧 Extended command-line parameters
   - 📝 Updated documentation with usage examples
   - ✅ Full integration testing completed

   ### 📝 Full Release Notes

   See [RELEASE_NOTES_v1.2.0.md](https://github.com/ZhenRobotics/openclaw-video-generator-generator/blob/main/RELEASE_NOTES_v1.2.0.md) for complete details.

   ### 🔗 Resources

   - **Documentation**: [README.md](https://github.com/ZhenRobotics/openclaw-video-generator-generator/blob/main/README.md)
   - **Skill Guide**: [SKILL.md](https://github.com/ZhenRobotics/openclaw-video-generator-generator/blob/main/openclaw-skill/SKILL.md)
   - **npm Package**: `npm install -g openclaw-video-generator`

   ---

   **Happy video creating with backgrounds! 🎬✨**
   ```

4. **设置 Release 选项**

   - ✅ 勾选 "Set as the latest release"
   - ⬜ 不勾选 "Set as a pre-release"（这是正式版本）

5. **发布**

   点击绿色的 "Publish release" 按钮

---

### 方式 2: 直接访问已推送的 Tag

1. **访问 Tag 页面**
   ```
   https://github.com/ZhenRobotics/openclaw-video-generator-generator/releases/tag/v1.2.0
   ```

2. **点击 "Create release from tag"**

3. **按照方式 1 的步骤 3-5 完成**

---

### 方式 3: 使用 gh CLI（如果安装）

如果你安装了 GitHub CLI：

```bash
gh release create v1.2.0 \
  --title "v1.2.0 - Background Video Support" \
  --notes-file RELEASE_NOTES_v1.2.0.md
```

**安装 gh CLI:**
```bash
# Ubuntu/Debian
sudo apt install gh

# 或从 https://cli.github.com/ 下载
```

---

## 📋 Release Checklist

创建 Release 后，确认：

- ✅ Tag `v1.2.0` 已创建并推送
- ⬜ GitHub Release 已发布
- ⬜ Release 标题正确
- ⬜ Release 描述完整
- ⬜ 标记为 "Latest release"
- ⬜ 不是 pre-release

---

## 🔗 快速链接

**创建 Release:**
https://github.com/ZhenRobotics/openclaw-video-generator-generator/releases/new?tag=v1.2.0

**查看所有 Releases:**
https://github.com/ZhenRobotics/openclaw-video-generator-generator/releases

**仓库主页:**
https://github.com/ZhenRobotics/openclaw-video-generator-generator

---

## 📦 后续步骤（可选）

### 发布到 npm

如果需要更新 npm 包：

```bash
# 确认版本号正确
cat package.json | grep version

# 登录 npm（如果需要）
npm login

# 发布
npm publish

# 验证
npm view openclaw-video-generator version
```

### 更新 ClawHub

如果需要更新 ClawHub Skill：

1. 访问 https://clawhub.ai
2. 登录账号
3. 找到 video-generator skill
4. 上传更新的 `openclaw-skill/SKILL.md`
5. 发布更新

---

**完成后，v1.2.0 将对所有用户可用！🚀**
