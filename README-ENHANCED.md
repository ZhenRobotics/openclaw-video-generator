# 🎬 OpenClaw Video Generator

> **从文本到专业视频，3分钟完成，成本不到1分钱**

[![npm version](https://img.shields.io/npm/v/openclaw-video-generator.svg)](https://www.npmjs.com/package/openclaw-video-generator)
[![GitHub stars](https://img.shields.io/github/stars/ZhenRobotics/openclaw-video-generator.svg)](https://github.com/ZhenRobotics/openclaw-video-generator)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

基于 Remotion + OpenAI TTS 的完全自动化视频生成系统。提供文本脚本，自动生成配音、时间轴和专业视频。

**[查看演示](#demo)** • **[快速开始](#快速开始)** • **[文档](#文档)** • **[示例](#示例)**

---

## 🎥 演示

<!-- 这里放演示 GIF -->
![Demo](docs/demo.gif)

**3个步骤，3分钟完成**：输入文本 → 运行命令 → 获得视频

---

## ⚡ 快速开始

```bash
# 安装
npm install -g openclaw-video-generator@1.6.2

# 配置 API Key
export OPENAI_API_KEY="sk-your-key-here"

# 生成视频
echo "AI让开发变得更简单" > script.txt
openclaw-video-generator script.txt

# 完成！视频位于 out/script.mp4
```

**就这么简单。** 3分钟，$0.003，专业视频。

---

## 💰 成本对比

| 方法 | 时间 | 成本 | 质量 |
|------|------|------|------|
| **OpenClaw** | **3 分钟** | **$0.003** | **专业** |
| Fiverr 接单 | 2-3 天 | $50-200 | 不稳定 |
| 视频代理 | 1-2 周 | $500-2000 | 高 |
| 手动剪辑 | 2-4 小时 | 免费* | 学习曲线陡峭 |

*您的时间也是成本

---

## ✨ 核心特性

- 🎤 **多厂商 TTS** - OpenAI, Azure, 阿里云, 腾讯云（自动故障转移）
- ⏱️ **精确时间轴** - Whisper API 自动分段
- 🎬 **智能场景** - 6种场景类型自动识别
- 🎨 **赛博美学** - 线框动画、霓虹效果、专业设计
- 🖼️ **背景视频** - 自定义背景，可调透明度
- 🔒 **完全安全** - 本地渲染，零数据泄露
- 📦 **开源免费** - MIT 许可，完全可定制

---

## 🚀 使用场景

### 开发者
```bash
# 为所有 GitHub 项目生成演示视频
openclaw-video-generator project-demo.txt
```
**节省时间**: 从4小时视频剪辑到3分钟自动化

### 内容创作者
```bash
# 批量生成教程视频
for script in tutorials/*.txt; do
  openclaw-video-generator "$script"
done
```
**扩大规模**: 从每周2个视频到每天10个

### 营销人员
```bash
# 无限 A/B 测试广告
openclaw-video-generator ad-variant-1.txt
openclaw-video-generator ad-variant-2.txt
```
**降低成本**: 从每个广告$200到$0.003

---

## 📦 安装

### 方式 1：npm 全局安装（推荐）

```bash
npm install -g openclaw-video-generator@1.6.2

# 验证
openclaw-video-generator --version
```

### 方式 2：从源码安装

```bash
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
npm install
```

### 系统要求

- Node.js >= 18
- ffmpeg
- npm
- API Key（OpenAI/Azure/阿里云/腾讯云，选一个即可）

---

## 🔐 API Key 配置

**推荐方式**（.env 文件）:
```bash
cd ~/openclaw-video-generator
cat > .env << 'EOF'
OPENAI_API_KEY="sk-your-key-here"
