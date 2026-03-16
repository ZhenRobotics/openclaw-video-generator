# ClawHub Skill 更新指南 - v1.2.0

## 📦 Skill 信息

**Skill 名称:** video-generator
**当前版本:** v1.1.0
**新版本:** v1.2.0
**ClawHub 链接:** https://clawhub.ai/ZhenStaff/video-generator

---

## 🎉 v1.2.0 新特性

### ✨ 背景视频支持

这是 v1.2.0 的核心功能：用户现在可以为生成的视频添加自定义背景视频！

**新增功能:**
- 🖼️ 自定义背景视频支持
- 🎨 背景透明度控制（0-1）
- 🌈 遮罩层颜色自定义
- 🔄 背景视频自动循环
- 📦 文件自动管理

**新增参数:**
- `--bg-video <path>` - 背景视频文件路径
- `--bg-opacity <0-1>` - 背景透明度（默认：0.3）
- `--bg-overlay <color>` - 遮罩颜色（默认：rgba(10, 10, 15, 0.6)）

---

## 🔄 更新步骤

### 步骤 1: 登录 ClawHub

访问并登录: https://clawhub.ai/login

### 步骤 2: 找到你的 Skill

1. 进入你的个人主页/工作台
2. 找到 `video-generator` skill
3. 点击 "编辑" 或 "更新"

### 步骤 3: 更新 SKILL.md

上传更新后的 skill 定义文件:

**文件位置:** `openclaw-skill/SKILL.md`

**关键更新内容:**
- 版本历史更新到 v1.2.0
- 新增背景视频功能说明
- 更新使用示例
- 更新配置选项

### 步骤 4: 更新版本标签

在 ClawHub 界面中：
- **Version Tag:** 设置为 `v1.2.0`
- **Release Date:** 2026-03-07
- **Change Type:** Feature Release

### 步骤 5: 更新描述（可选）

在 skill 描述中添加新特性亮点:

```
v1.2.0 新增：
✨ 背景视频支持 - 为你的视频添加自定义背景
🎨 透明度和遮罩控制 - 完美平衡背景和文字
🔄 自动循环播放 - 无缝背景效果
```

### 步骤 6: 发布更新

点击 "发布" 或 "更新" 按钮，确认发布。

---

## 📝 更新说明（Changelog）

建议在 ClawHub 的更新说明中包含以下内容:

```markdown
## v1.2.0 - Background Video Support (2026-03-07)

### 🎉 新功能

#### 背景视频支持
现在可以为生成的视频添加自定义背景视频！通过简单的命令行参数即可实现：

```bash
./scripts/script-to-video.sh scripts/my-script.txt \
  --bg-video /path/to/background.mp4 \
  --bg-opacity 0.4
```

### ✨ 特性详情

- **自定义背景视频**: 支持任意 MP4 视频作为背景
- **透明度控制**: 0-1 范围可调，完美平衡背景和内容
- **遮罩层自定义**: 自定义遮罩颜色，确保文字清晰可读
- **自动循环**: 背景视频无缝循环播放
- **文件自动管理**: 视频文件自动复制到项目目录

### 🚀 使用示例

**基础用法:**
```bash
~/openclaw-video/generate-for-openclaw.sh "视频脚本内容"
```

**带背景视频:**
```bash
cd ~/openclaw-video && ./scripts/script-to-video.sh scripts/script.txt \
  --bg-video /path/to/background.mp4 \
  --bg-opacity 0.4
```

### 📊 推荐配置

| 用途 | 透明度 | 说明 |
|------|--------|------|
| 文字为主 | 0.2-0.3 | 背景若隐若现 |
| 平衡效果 | 0.4-0.5 | 推荐设置 ⭐ |
| 背景突出 | 0.6-0.8 | 背景较明显 |

### 🔄 兼容性

✅ **无破坏性变更** - 所有现有功能保持兼容
✅ 背景视频为可选功能
✅ 默认行为不变

### 📚 文档

完整文档请参考：
- GitHub: https://github.com/ZhenRobotics/openclaw-video-generator
- README.md 已更新
- RELEASE_NOTES_v1.2.0.md 包含详细说明
```

---

## 🎯 Agent 触发规则更新（可选）

如果 ClawHub 支持触发规则配置，可以添加：

**新增触发关键词:**
- "background video"
- "背景视频"
- "add background"
- "添加背景"
- "custom background"

**示例用户请求:**
- "Generate video with a tech background"
- "生成带背景视频的内容"
- "Add a cityscape background to my video"

---

## 📋 更新检查清单

发布前确认:

- [ ] 已登录 ClawHub
- [ ] SKILL.md 文件已更新到 v1.2.0
- [ ] 版本标签设置为 v1.2.0
- [ ] 更新说明/Changelog 已填写
- [ ] 新特性描述完整
- [ ] 使用示例准确
- [ ] 点击发布/更新按钮
- [ ] 验证更新是否在线可见

发布后验证:

- [ ] ClawHub 页面显示 v1.2.0
- [ ] 新特性在描述中可见
- [ ] SKILL.md 内容正确显示
- [ ] 用户可以查看更新日志
- [ ] skill 可以正常安装 `clawhub install video-generator`

---

## 🔗 相关链接

- **ClawHub Skill 页面**: https://clawhub.ai/ZhenStaff/video-generator
- **GitHub 仓库**: https://github.com/ZhenRobotics/openclaw-video-generator
- **npm 包**: https://www.npmjs.com/package/openclaw-video
- **文档**: README.md, openclaw-skill/SKILL.md

---

## 💡 营销建议

在社交媒体/社区推广时可以强调：

**主要卖点:**
- 🎬 "一键添加背景视频到你的 AI 生成内容"
- 🎨 "完全可控的背景透明度和视觉效果"
- ⚡ "零配置，命令行参数即可使用"
- 🔄 "与现有流水线完美集成"

**适用场景:**
- 技术教程视频（科技感背景）
- 产品演示（产品相关背景）
- 营销内容（品牌视觉背景）
- 故事类视频（场景氛围背景）

---

## 🐛 常见问题

### Q: 如何在 ClawHub 上传大文件？
**A:** SKILL.md 是纯文本，不涉及大文件。如果需要上传示例视频，建议放在 GitHub 仓库的 release 中，然后在 SKILL.md 中引用链接。

### Q: 更新后旧版本用户会怎样？
**A:** ClawHub 通常支持版本管理。旧版本用户可以：
- 继续使用旧版本
- 选择升级到新版本
- 查看 changelog 决定是否更新

### Q: 如何测试 skill 更新？
**A:** 在 ClawHub 上，通常有预览/测试功能。建议先在测试环境验证后再正式发布。

---

## 📞 获取帮助

如果在更新过程中遇到问题：

1. **ClawHub 文档**: https://clawhub.ai/docs
2. **ClawHub 支持**: 通过平台内的支持渠道
3. **GitHub Issues**: https://github.com/ZhenRobotics/openclaw-video-generator/issues

---

**准备就绪，可以更新 ClawHub Skill！** 🚀
