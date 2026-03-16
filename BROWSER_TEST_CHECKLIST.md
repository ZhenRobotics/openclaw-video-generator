# 浏览器测试检查清单

**目的**: 验证三个平台的网页界面显示正确
**时间**: 约 10-15 分钟
**测试日期**: 2026-03-07

---

## 📦 测试 1: npm 包页面

### 访问链接
```
https://www.npmjs.com/package/openclaw-video-generator
```

### 检查项目

#### 基本信息
- [ ] 包名显示：`openclaw-video-generator`
- [ ] 版本显示：`1.2.0` 且标记为 "latest"
- [ ] 描述完整显示
- [ ] 关键词可见：video-generation, remotion, openai, tts, whisper

#### README 内容
- [ ] README 正确渲染（Markdown 格式）
- [ ] 有安装说明
- [ ] 有使用示例
- [ ] 有命令行参数说明
- [ ] 背景视频功能说明可见

#### 链接和信息
- [ ] GitHub 仓库链接正确
- [ ] Issues 链接正确
- [ ] 下载统计显示
- [ ] 最后发布时间：2026-03-07

#### 安装命令
确认页面显示：
```bash
npm install openclaw-video-generator
```
或
```bash
npm install -g openclaw-video-generator
```

**截图建议**:
- 包信息顶部
- README 的主要部分
- 安装说明部分

---

## 🐙 测试 2: GitHub 仓库页面

### 访问链接
```
https://github.com/ZhenRobotics/openclaw-video-generator
```

### 检查项目

#### 仓库首页
- [ ] 仓库名：`openclaw-video-generator`
- [ ] 描述显示且完整
- [ ] README 正确渲染
- [ ] 有 Topics/Tags 显示
- [ ] Star/Fork/Watch 按钮可见

#### README 内容
- [ ] 项目标题和徽章
- [ ] 功能列表
- [ ] 安装说明（包含 npm 和源码安装）
- [ ] 快速开始指南
- [ ] 背景视频功能说明
- [ ] 命令行参数文档
- [ ] 示例和截图

#### 文件结构
- [ ] `src/` 目录可见
- [ ] `scripts/` 目录可见
- [ ] `openclaw-skill/` 目录可见
- [ ] `README.md` 存在
- [ ] `QUICKSTART.md` 存在
- [ ] `package.json` 可查看

---

## 🎉 测试 3: GitHub Release 页面

### 访问链接
```
https://github.com/ZhenRobotics/openclaw-video-generator/releases
```

或直接访问 v1.2.0:
```
https://github.com/ZhenRobotics/openclaw-video-generator/releases/tag/v1.2.0
```

### 检查项目

#### Release 列表页
- [ ] v1.2.0 标记为 "Latest" (绿色标签)
- [ ] 发布日期显示：Mar 7, 2026
- [ ] Release 标题：`v1.2.0 - Background Video Support`

#### Release 详情页
- [ ] 标题正确显示
- [ ] 完整的 Release Notes 可见
- [ ] 包含以下章节：
  - [ ] 🎉 Background Video Support
  - [ ] ✨ Key Features
  - [ ] 🚀 Quick Start
  - [ ] 📊 Recommended Settings
  - [ ] 🔧 New Command-Line Parameters
  - [ ] 🔄 Migration from v1.1.0
  - [ ] 📦 What's Changed
  - [ ] 📝 Documentation
  - [ ] 📦 Installation
  - [ ] 🎯 Usage

#### 代码示例渲染
- [ ] Bash 代码块正确高亮
- [ ] 表格正确渲染
- [ ] Emoji 正确显示

#### 链接有效性
- [ ] "Full Changelog" 链接可点击
- [ ] 文档链接可点击
- [ ] npm 包链接可点击

**截图建议**:
- Release 列表页（显示 Latest 标签）
- Release Notes 的主要章节
- Key Features 部分

---

## 🦁 测试 4: ClawHub Skill 页面

### 访问链接
```
https://clawhub.ai/ZhenStaff/video-generator
```

### 检查项目

#### Skill 基本信息
- [ ] Skill 名称：`video-generator`
- [ ] 作者：`ZhenStaff`
- [ ] 版本显示：`v1.2.0`
- [ ] 更新日期：2026-03-07 或 Mar 7, 2026

#### 描述和说明
- [ ] Skill 描述完整显示
- [ ] 功能列表可见
- [ ] 安装说明清晰

#### Changelog/更新说明
- [ ] v1.2.0 更新说明可见
- [ ] 包含以下内容：
  - [ ] 🎉 新功能：背景视频支持
  - [ ] ✨ 主要特性列表
  - [ ] 🚀 快速使用示例
  - [ ] 📊 推荐配置表格
  - [ ] 🔧 新增参数说明
  - [ ] 🔄 兼容性说明
  - [ ] 📦 npm 包名更新说明
  - [ ] 📚 文档链接

#### 安装说明
确认显示以下安装方式：
```bash
npm install -g openclaw-video-generator
```
或
```bash
clawhub install video-generator
```

#### 使用说明
- [ ] 有命令行示例
- [ ] 有参数说明
- [ ] 有背景视频功能说明

#### 链接有效性
- [ ] GitHub 链接可点击
- [ ] npm 链接可点击
- [ ] 相关文档链接可点击

**截图建议**:
- Skill 顶部（名称、版本、作者）
- Changelog 部分
- 安装和使用说明

---

## 🔗 测试 5: 跨平台导航

### npm → GitHub
从 npm 包页面：
- [ ] 点击 GitHub repository 链接
- [ ] 确认跳转到正确的 GitHub 仓库
- [ ] 点击 Issues 链接
- [ ] 确认跳转到正确的 Issues 页面

### GitHub → npm
从 GitHub README：
- [ ] 找到 npm 安装说明
- [ ] 如果有 npm 链接，点击验证
- [ ] 包名 `openclaw-video-generator` 正确显示

### ClawHub → GitHub/npm
从 ClawHub skill 页面：
- [ ] 点击 GitHub 链接
- [ ] 确认跳转到 GitHub 仓库
- [ ] 点击 npm 链接（如有）
- [ ] 确认跳转到 npm 包页面

---

## 📱 移动端测试（可选）

### npm (mobile)
- [ ] 页面在手机上正常显示
- [ ] README 可滚动阅读
- [ ] 代码块可横向滚动

### GitHub (mobile)
- [ ] 仓库页面响应式布局
- [ ] README 在手机上可读
- [ ] Release Notes 显示正常

### ClawHub (mobile)
- [ ] Skill 页面在手机上可用
- [ ] 安装说明可见
- [ ] Changelog 可阅读

---

## 🎨 视觉质量检查

### 一致性
- [ ] 三个平台的项目描述一致
- [ ] 版本号在三个平台都是 1.2.0
- [ ] 功能描述一致
- [ ] 安装说明一致

### 格式和排版
- [ ] Markdown 格式正确渲染
- [ ] 代码块有语法高亮
- [ ] 表格对齐
- [ ] Emoji 正确显示
- [ ] 链接颜色和样式正常

### 专业性
- [ ] 没有拼写错误
- [ ] 没有格式错乱
- [ ] 图片（如有）正常加载
- [ ] 整体外观专业

---

## 📊 测试结果记录

### npm 包页面
- 访问状态: [ ] 正常 [ ] 有问题
- 问题描述: ___________________

### GitHub 仓库
- 访问状态: [ ] 正常 [ ] 有问题
- 问题描述: ___________________

### GitHub Release
- 访问状态: [ ] 正常 [ ] 有问题
- 问题描述: ___________________

### ClawHub Skill
- 访问状态: [ ] 正常 [ ] 有问题
- 问题描述: ___________________

---

## ✅ 总体评估

- [ ] 所有页面可访问
- [ ] 信息准确完整
- [ ] 链接都有效
- [ ] 格式渲染正确
- [ ] 用户体验良好

---

## 📝 测试结论

**测试通过**: [ ] 是 [ ] 否

**发现问题数**: _____

**需要修复的问题**:
1.
2.
3.

**建议改进**:
1.
2.
3.

---

**测试人**: ___________
**测试日期**: 2026-03-07
**测试时长**: _____ 分钟
**下次测试**: 下个版本发布后

---

## 💡 测试技巧

1. **使用隐身模式**: 避免缓存影响
2. **清除缓存**: 如果页面显示异常
3. **截图保存**: 记录关键页面
4. **记录问题**: 发现问题立即记录
5. **多浏览器**: Chrome, Firefox, Safari 都测试

---

**准备好了吗？开始测试吧！** 🚀
