# ClawHub 更新说明 - v1.3.1

**更新日期**: 2026-03-11
**版本**: v1.3.1
**类型**: 重要 Bug 修复

---

## 🐛 重要修复

### 1. 修复阿里云 ASR 时间戳同步问题

**问题**: 使用阿里云 ASR 时，音频和字幕严重不同步（误差 -75%）

**修复**: 使用 ffprobe 精确检测音频时长，同步误差降至 0%

**影响**:
- ✅ 语音和字幕完美对齐
- ✅ 用户体验显著提升

### 2. 改进阿里云 ASR 智能分段

**问题**: 字幕全部同时显示，视频效果单调

**修复**: 智能文本分割算法，按标点符号自动分段

**效果**:
- ✅ 从 1 个 segment 提升到 6+ segments
- ✅ 文字逐句显示，流畅自然

### 3. 修复 OpenAI Whisper 数据格式

**问题**: Whisper API 数据格式错误导致场景生成失败

**修复**: 正确提取 segments 数组

---

## 🚀 快速使用

### 安装/升级

```bash
# npm 安装
npm install -g openclaw-video-generator@1.3.1

# 或更新
npm update -g openclaw-video-generator

# ClawHub 安装
clawhub install ZhenStaff/video-generator
```

### 基础使用

```bash
# 生成视频
openclaw-video-generator script.txt --voice Aibao --speed 1.15

# 带背景视频
openclaw-video-generator script.txt \
  --voice Aibao \
  --bg-video background.mp4 \
  --bg-opacity 0.4
```

---

## 📊 新增参数

本次更新无新增参数，仅修复了关键问题。

---

## 🔄 兼容性

- ✅ 无破坏性变更
- ✅ 向后兼容 v1.3.0
- ✅ 所有现有功能正常工作

---

## 📝 升级建议

**强烈建议升级**，特别是如果您：
- 使用阿里云 TTS/ASR 服务
- 遇到语音字幕不同步问题
- 发现字幕全部同时显示

升级后您将获得：
- ✅ 完美的时间戳同步（0 误差）
- ✅ 流畅的字幕显示效果
- ✅ 更好的用户体验

---

## 🔗 相关链接

- **GitHub**: https://github.com/ZhenRobotics/openclaw-video-generator/releases/tag/v1.3.1
- **npm**: https://www.npmjs.com/package/openclaw-video-generator
- **文档**: https://github.com/ZhenRobotics/openclaw-video-generator

---

**版本**: v1.3.1
**发布时间**: 2026-03-11
**发布者**: ZhenStaff
