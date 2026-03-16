# ClawHub 上传指南 - v1.3.1

**上传时间**: 2026-03-11
**版本**: v1.3.1
**类型**: Bug Fix Release

---

## 📂 上传文件夹

**位置**: `/home/justin/openclaw-video-generator/clawhub-upload-bilingual/`

**包含文件**:
- ✅ `skill.md` (16KB) - Skill 定义文件（中英双语）
- ✅ `readme.md` (12KB) - 用户文档（中英双语）

**验证通过**:
- ✅ 文件数量：2 个（符合要求）
- ✅ 文件名格式：小写 skill.md + readme.md
- ✅ 语言：中英双语
- ✅ 版本号：v1.3.1
- ✅ Commit hash：763a861

---

## 🌐 上传步骤

### 步骤 1: 访问上传页面

```
https://clawhub.ai/upload
```

### 步骤 2: 上传文件

**方式 A: 上传整个文件夹（推荐）**
```bash
# 拖拽此文件夹到浏览器上传区域
/home/justin/openclaw-video-generator/clawhub-upload-bilingual/
```

**方式 B: 分别上传文件**
1. 上传 `clawhub-upload-bilingual/skill.md`
2. 上传 `clawhub-upload-bilingual/readme.md`

### 步骤 3: 填写更新信息

| 字段 | 内容 |
|------|------|
| **Version** | `v1.3.1` |
| **Release Date** | `2026-03-11` |
| **Change Type** | `Bug Fix` |
| **Skill Name** | `video-generator` |
| **Organization** | `ZhenStaff` |

### 步骤 4: 更新说明（中英双语）

**English:**
```markdown
## v1.3.1 - Critical Bug Fixes

### Fixed Issues
1. Fixed Aliyun ASR timestamp sync issue (error reduced from -75% to 0%)
2. Added smart text segmentation for Aliyun ASR (improved from 1 to 6+ segments)
3. Fixed OpenAI Whisper data format bug

### Installation
npm install -g openclaw-video-generator@1.3.1

### Usage
openclaw-video-generator script.txt --voice Aibao --speed 1.15

### Compatibility
✅ No breaking changes, backward compatible with v1.3.0

### Upgrade Recommendation
Strongly recommended for users using Aliyun services
```

**中文：**
```markdown
## v1.3.1 - 重要 Bug 修复

### 修复内容
1. 修复阿里云 ASR 时间戳同步问题（误差从 -75% 降至 0%）
2. 为阿里云 ASR 添加智能文本分段（从 1 个片段提升到 6+ 个）
3. 修复 OpenAI Whisper 数据格式问题

### 安装
npm install -g openclaw-video-generator@1.3.1

### 使用
openclaw-video-generator script.txt --voice Aibao --speed 1.15

### 兼容性
✅ 无破坏性变更，向后兼容 v1.3.0

### 升级建议
强烈推荐使用阿里云服务的用户升级
```

---

## ✅ 上传后验证

### 访问 Skill 页面

```
https://clawhub.ai/ZhenStaff/video-generator
```

### 检查清单

- [ ] 版本号显示为 v1.3.1
- [ ] 更新日期显示为 2026-03-11
- [ ] 更新说明包含 Bug 修复内容
- [ ] 中英双语内容显示正常
- [ ] 安装命令正确
- [ ] GitHub 链接正确

---

## 📊 关键修复说明

### 修复 1: 阿里云 ASR 时间戳同步

**问题**:
- 音频时长 19.62 秒，时间戳只有 4.90 秒
- 误差 -75%，语音快字幕慢，严重不同步

**修复**:
- 使用 ffprobe 精确检测音频时长
- 误差降至 0%
- 语音和字幕完美对齐

**文件**: `scripts/providers/asr/aliyun_asr_fixed.py`

### 修复 2: 智能分段算法

**问题**:
- 阿里云 ASR 只返回 1 个 segment
- 所有字幕同时显示，效果单调

**修复**:
- 按中文标点符号智能分割
- 根据字符数比例估算时间戳
- 生成 6+ segments

**效果**:
- 文字逐句显示，流畅自然
- 场景自动切换

### 修复 3: OpenAI Whisper 数据格式

**问题**:
- 保存完整 Whisper 响应而非 segments 数组
- 导致场景生成失败

**修复**:
- 使用 jq 提取 segments 数组
- 只保存必要的 start/end/text 字段

**文件**: `scripts/providers/asr/openai.sh`

---

## 🔗 相关链接

### 已完成
- ✅ GitHub Repo: https://github.com/ZhenRobotics/openclaw-video-generator
- ✅ Git Tag v1.3.1: https://github.com/ZhenRobotics/openclaw-video-generator/releases/tag/v1.3.1
- ✅ Commit 763a861: https://github.com/ZhenRobotics/openclaw-video-generator/commit/763a861

### 待完成
- ⏳ npm: https://www.npmjs.com/package/openclaw-video-generator (网络错误，待重试)
- ⏳ GitHub Release: https://github.com/ZhenRobotics/openclaw-video-generator/releases
- 📋 ClawHub: https://clawhub.ai/ZhenStaff/video-generator (准备上传)

---

## 📝 快速复制内容

### 更新标题（中英双语）
```
v1.3.1 - Critical Bug Fixes | 重要 Bug 修复
```

### 简短描述
```
Fixed Aliyun ASR timestamp sync (0% error), added smart segmentation (6+ segments), improved subtitle display.
修复阿里云 ASR 时间戳同步（0% 误差），添加智能分段（6+ 片段），改善字幕显示。
```

### 标签（如需要）
```
bug-fix, aliyun, timestamp-sync, smart-segmentation, v1.3.1
```

---

**准备完成**: ✅
**可以立即上传**: 是
**预计上传时间**: 2-3 分钟

---

**文档生成时间**: 2026-03-11 13:35
**维护者**: ZhenStaff
