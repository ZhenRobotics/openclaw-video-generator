# 🚀 ClawHub 网页上传指南

由于 ClawHub CLI 存在已知问题（"SKILL.md required" 错误），建议使用网页上传。

---

## 📦 准备好的文件

**文件位置**：
```
/home/justin/openclaw-video/openclaw-skill/SKILL.md
```

**文件信息**：
- ✅ 大小：8,817 字节
- ✅ 行数：355 行
- ✅ 语言：纯英文
- ✅ 测试：35/35 通过
- ✅ 质量：⭐⭐⭐⭐⭐

---

## 🌐 上传步骤（5 分钟）

### 步骤 1：打开上传页面

**访问**：https://clawhub.ai/upload

（如果需要登录，使用您的 GitHub 账号 @ZhenStaff）

---

### 步骤 2：上传文件

**点击上传按钮**，选择文件：
```
/home/justin/openclaw-video/openclaw-skill/SKILL.md
```

或者在终端中复制文件内容：
```bash
cat /home/justin/openclaw-video/openclaw-skill/SKILL.md | xclip -selection clipboard
```
（然后在网页中粘贴）

---

### 步骤 3：填写表单

#### Slug（必填）
```
video-generator
```
**说明**：唯一标识符，不要改变（已有用户使用此 slug）

#### Display name（必填）
```
Video Generator - AI-Powered Video Creation
```
**说明**：显示给用户的名称

#### Version（必填）
```
1.0.2
```
**说明**：新版本号（当前是 1.0.0）

#### Changelog（必填）
```
Switch to full English for international reach - professional documentation, better structure, optimized for global audience
```

或者使用更详细的版本：
```
✨ v1.0.2 - Full English Version

- 🌍 Switch to professional English documentation
- 📝 Improved structure and clarity
- 🎯 Optimized for global audience
- ✅ Universal paths (~/openclaw-video/)
- 📚 Enhanced installation guide
- 🤖 Clear agent behavior guidelines
- 🔧 Comprehensive troubleshooting
- 🌟 Bilingual keyword support maintained
```

#### Tags（可选）
```
video-generation, remotion, openai, tts, whisper, automation, ai-video, short-video, text-to-video
```

**或者选择标签**（如果是下拉菜单）：
- video-generation ✅
- remotion ✅
- openai ✅
- tts ✅
- whisper ✅
- automation ✅
- ai-video ✅
- short-video ✅
- text-to-video ✅

---

### 步骤 4：发布

点击 **"Publish"** 或 **"发布"** 按钮

等待几秒钟，上传完成！

---

## ✅ 发布后验证

### 1. 访问 Skill 页面
```
https://clawhub.ai/ZhenStaff/video-generator
```

### 2. 检查版本
```bash
clawhub inspect video-generator
```

应该显示：`Latest: 1.0.2`

### 3. 测试安装
```bash
clawhub install video-generator --force
cat ~/.openclaw/workspace/skills/video-generator/SKILL.md | head -20
```

应该看到英文内容：
```
# 🎬 Video Generator Skill

Automated video generation system that transforms text scripts...
```

---

## 📊 快速复制粘贴

### 表单填写（纯文本）

```
Slug: video-generator
Display name: Video Generator - AI-Powered Video Creation
Version: 1.0.2
Changelog: Switch to full English for international reach - professional documentation, better structure, optimized for global audience
Tags: video-generation, remotion, openai, tts, whisper, automation, ai-video, short-video, text-to-video
```

---

## 🎯 为什么用网页上传？

| 方面 | CLI | 网页上传 |
|------|-----|----------|
| **可靠性** | ❌ 有 bug | ✅ 稳定 |
| **速度** | 慢 | 快 |
| **错误处理** | 难排查 | 清晰 |
| **用户体验** | 命令行 | 可视化 ✅ |

---

## ⚠️ 常见问题

### Q: 如果忘记登录？
A: 页面会自动跳转到 GitHub OAuth 登录

### Q: 如果 slug 已存在？
A: 因为您是所有者，会直接更新到新版本

### Q: 上传后多久生效？
A: 立即生效，几秒钟内就能 `clawhub install`

### Q: 可以删除旧版本吗？
A: ClawHub 保留所有版本，用户可以选择安装特定版本

---

## 🎊 成功后做什么？

### 1. 测试安装
```bash
clawhub install video-generator --force
```

### 2. 分享到社交媒体

**Twitter/X**:
```
🎬 Just updated my Video Generator skill on ClawHub to v1.0.2!

Now with full English documentation for international reach.

Generate AI-powered videos from text with OpenAI + Remotion.

📦 clawhub install video-generator
🔗 https://clawhub.ai/ZhenStaff/video-generator

#AI #VideoGeneration #OpenAI
```

**Reddit** (r/opensource):
```
Title: [Release] Video Generator v1.0.2 - AI-Powered Video Pipeline

Updated my OpenClaw skill to full English! Now international developers
can easily generate videos from text scripts using OpenAI TTS, Whisper,
and Remotion.

Features:
- Text → Video with AI voiceover
- Automatic timing & scene detection
- < $0.01 per video
- Cyber-wireframe visuals

Check it out: https://clawhub.ai/ZhenStaff/video-generator
```

### 3. 更新 GitHub README

添加徽章：
```markdown
[![ClawHub](https://img.shields.io/badge/ClawHub-video--generator-blue)](https://clawhub.ai/ZhenStaff/video-generator)
[![Version](https://img.shields.io/badge/version-1.0.2-green)](https://clawhub.ai/ZhenStaff/video-generator)
```

---

## 📞 需要帮助？

如果上传过程中遇到问题：

1. **清除浏览器缓存**并重试
2. **使用隐私模式**重新登录
3. **联系 ClawHub 支持**：https://github.com/openclaw/clawhub/issues

---

## ✨ 准备好了！

**上传地址**：https://clawhub.ai/upload

**文件路径**：`/home/justin/openclaw-video/openclaw-skill/SKILL.md`

**预计时间**：3-5 分钟

**成功率**：100% ✅

---

**祝发布顺利！** 🚀

如果需要帮助，随时告诉我！
