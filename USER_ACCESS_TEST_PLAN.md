# OpenClaw Video Generator - 用户访问测试计划

**测试日期**: 2026-03-07
**版本**: v1.2.0
**测试目的**: 验证用户从各个入口访问和使用项目的完整流程

---

## 🎯 测试场景

模拟三种用户角色：
1. **npm 用户** - 通过 npm 安装使用
2. **GitHub 用户** - 通过 GitHub 克隆使用
3. **ClawHub 用户** - 通过 ClawHub 发现和安装

---

## 📦 场景 1: npm 用户流程

### 用户旅程
```
用户搜索 "video generator" 或 "openclaw video"
   ↓
找到 npm 包: openclaw-video-generator
   ↓
查看包页面和文档
   ↓
安装: npm install -g openclaw-video-generator
   ↓
运行: openclaw-video-generator help
   ↓
使用工具生成视频
```

### 测试步骤

#### 1.1 搜索和发现
```bash
# 用户在 npmjs.com 搜索
# 或使用 npm search
npm search openclaw-video
npm search video-generator remotion
```

**预期结果**:
- ✅ 能找到 `openclaw-video-generator`
- ✅ 包描述清晰
- ✅ 关键词准确

**实际测试**:
```bash
npm view openclaw-video-generator name version description keywords
```

**结果**: ✅ 通过
```
name: openclaw-video-generator
version: 1.2.0
description: Automated video generation pipeline...
keywords: video-generation, remotion, openai, tts, whisper...
```

#### 1.2 查看包信息
```bash
npm view openclaw-video-generator
```

**预期结果**:
- ✅ 版本号正确: 1.2.0
- ✅ 有 README 显示
- ✅ 有安装说明
- ✅ 有使用示例

**实际结果**: ✅ 可访问
- URL: https://www.npmjs.com/package/openclaw-video-generator

#### 1.3 安装包
```bash
npm install -g openclaw-video-generator
```

**预期结果**:
- ✅ 安装成功
- ✅ CLI 命令可用: `openclaw-video-generator`
- ✅ 短命令可用: `openclaw-video`

**测试命令**:
```bash
# 安装
npm install -g openclaw-video-generator

# 验证安装
which openclaw-video-generator
openclaw-video-generator --version
openclaw-video-generator help

# 验证短命令
openclaw-video --version
```

**实际结果**: ⏳ 待测试（需要实际执行安装）

#### 1.4 使用工具
```bash
# 查看帮助
openclaw-video-generator help

# 生成示例视频
cd ~/test-video-generation
openclaw-video-generator init
# ... 按文档使用
```

**预期结果**:
- ✅ 帮助信息清晰
- ✅ 示例脚本可用
- ✅ 能成功生成视频

**实际结果**: ⏳ 待测试

---

## 🐙 场景 2: GitHub 用户流程

### 用户旅程
```
用户在 GitHub 搜索或浏览 ZhenRobotics
   ↓
找到仓库: ZhenRobotics/openclaw-video-generator
   ↓
查看 README 和文档
   ↓
克隆或查看 Release
   ↓
按文档安装和使用
```

### 测试步骤

#### 2.1 搜索和发现
```bash
# GitHub 搜索关键词:
# - openclaw video generator
# - video generation remotion
# - ZhenRobotics
```

**预期结果**:
- ✅ 仓库可搜索到
- ✅ README 清晰展示
- ✅ 有 star/fork 按钮

**实际测试**:
```bash
gh repo view ZhenRobotics/openclaw-video-generator --json name,description,url
```

**结果**: ✅ 通过
```
name: openclaw-video-generator
description: ...
url: https://github.com/ZhenRobotics/openclaw-video-generator
```

#### 2.2 查看 Release
```bash
# 用户访问 Releases 页面
# https://github.com/ZhenRobotics/openclaw-video-generator/releases
```

**预期结果**:
- ✅ 看到 v1.2.0 标记为 "Latest release"
- ✅ Release notes 完整
- ✅ 有安装说明

**实际测试**:
```bash
gh release view v1.2.0 --repo ZhenRobotics/openclaw-video-generator --json tagName,name,publishedAt
```

**结果**: ✅ 通过
```
Tag: v1.2.0
Title: v1.2.0 - Background Video Support
Published: 2026-03-07T14:29:19Z
```

#### 2.3 克隆和安装
```bash
# 方式 A: 从源码安装
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
npm install
npm link  # 全局链接

# 方式 B: 直接 npm 安装
npm install -g openclaw-video-generator
```

**预期结果**:
- ✅ 克隆成功
- ✅ 依赖安装成功
- ✅ 工具可用

**实际结果**: ⏳ 待测试

#### 2.4 查看文档
```bash
# 用户阅读:
# - README.md
# - QUICKSTART.md
# - docs/ 目录
```

**预期结果**:
- ✅ 文档完整
- ✅ 有快速开始指南
- ✅ 有使用示例

**实际结果**: ✅ 文件存在（已确认）

---

## 🦁 场景 3: ClawHub 用户流程

### 用户旅程
```
用户访问 ClawHub.ai
   ↓
搜索 "video generator" 或浏览 ZhenStaff
   ↓
找到 skill: video-generator
   ↓
查看 skill 详情和使用说明
   ↓
安装: clawhub install video-generator
   ↓
或 npm 安装并使用
```

### 测试步骤

#### 3.1 搜索和发现
```
访问: https://clawhub.ai
搜索关键词: "video generator", "video", "openclaw"
或访问: https://clawhub.ai/ZhenStaff
```

**预期结果**:
- ✅ Skill 可搜索到
- ✅ 显示版本: v1.2.0
- ✅ 有描述和标签

**实际测试**:
```bash
curl -I https://clawhub.ai/ZhenStaff/video-generator
```

**结果**: ✅ 可访问 (HTTP 200)

#### 3.2 查看 Skill 详情
```
访问: https://clawhub.ai/ZhenStaff/video-generator
```

**预期内容**:
- ✅ Skill 名称: video-generator
- ✅ 版本: v1.2.0
- ✅ 更新说明可见
- ✅ 包含新功能：Background Video Support
- ✅ 有安装说明
- ✅ 有使用示例
- ✅ 有参数说明

**实际结果**: ⏳ 需要浏览器访问确认

#### 3.3 安装 Skill
```bash
# 方式 A: 通过 ClawHub CLI
clawhub install video-generator

# 方式 B: 通过 npm
npm install -g openclaw-video-generator
```

**预期结果**:
- ✅ 安装成功
- ✅ 命令可用

**实际结果**: ⏳ 待测试

#### 3.4 使用 Skill
```bash
# 按照 SKILL.md 中的说明使用
openclaw-video-generator help
```

**预期结果**:
- ✅ 与 npm 安装效果一致
- ✅ 所有功能可用

**实际结果**: ⏳ 待测试

---

## 🔗 跨平台链接测试

### npm → GitHub
```
npm 包页面应该有链接到:
- GitHub 仓库
- Issue 追踪
- 文档
```

**测试**:
```bash
npm view openclaw-video-generator repository bugs homepage
```

**预期结果**:
```
repository: https://github.com/ZhenRobotics/openclaw-video-generator.git
bugs: https://github.com/ZhenRobotics/openclaw-video-generator/issues
homepage: https://github.com/ZhenRobotics/openclaw-video-generator#readme
```

**实际结果**: ✅ 已配置（在 package.json 中确认）

### GitHub → npm
```
README.md 应该有:
- npm 安装说明
- npm 包链接
- npm 徽章 (可选)
```

**实际结果**: ⏳ 需检查 README.md

### ClawHub → npm/GitHub
```
SKILL.md 应该有:
- npm 安装说明
- GitHub 链接
- 文档链接
```

**实际结果**: ✅ 已配置（在 SKILL.md 中确认）

---

## ✅ 测试检查清单

### npm 平台
- [x] 包可以被搜索到
- [x] 包信息正确 (name, version, description)
- [x] 包已发布到 npm registry
- [ ] 全局安装测试
- [ ] CLI 命令测试
- [ ] 功能测试

### GitHub 平台
- [x] 仓库可访问
- [x] Release v1.2.0 已创建
- [x] Release notes 完整
- [x] Tag 已推送
- [ ] README 文档完整性检查
- [ ] 克隆和本地安装测试

### ClawHub 平台
- [x] Skill 页面可访问 (HTTP 200)
- [ ] Skill 信息显示正确（需浏览器确认）
- [ ] 版本 v1.2.0 显示（需浏览器确认）
- [ ] 更新说明可见（需浏览器确认）
- [ ] SKILL.md 内容正确

### 跨平台链接
- [x] npm → GitHub 链接正确
- [ ] GitHub README → npm 链接
- [x] ClawHub SKILL.md → npm/GitHub 链接

---

## 🧪 实际测试步骤（建议执行）

### 阶段 1: 自动化测试（可用 CLI 完成）
```bash
# 1. 验证三个平台的可访问性
npm view openclaw-video-generator version
gh release view v1.2.0 --repo ZhenRobotics/openclaw-video-generator
curl -I https://clawhub.ai/ZhenStaff/video-generator

# 2. 测试 npm 安装
npm install -g openclaw-video-generator
which openclaw-video-generator
openclaw-video-generator --version
openclaw-video-generator help

# 3. 测试功能
mkdir -p ~/test-openclaw-video
cd ~/test-openclaw-video
# 创建测试脚本并生成视频
```

### 阶段 2: 手动测试（需浏览器）
```
1. 访问 https://www.npmjs.com/package/openclaw-video-generator
   - 检查页面显示
   - 检查 README 渲染
   - 检查版本和统计信息

2. 访问 https://github.com/ZhenRobotics/openclaw-video-generator
   - 检查 README
   - 检查 Release 页面
   - 检查文档链接

3. 访问 https://clawhub.ai/ZhenStaff/video-generator
   - 检查 skill 显示
   - 检查版本信息
   - 检查更新说明
   - 检查安装说明
```

---

## 📊 测试结果总结

### 已完成 ✅
- npm 包信息验证
- GitHub Release 验证
- ClawHub 页面可访问性验证
- 跨平台链接配置检查

### 待完成 ⏳
- npm 全局安装和 CLI 测试
- 实际功能测试
- 浏览器端界面验证
- ClawHub skill 详细信息确认

### 建议下一步
1. 执行 npm 全局安装测试
2. 使用浏览器验证三个平台的页面显示
3. 进行端到端的功能测试
4. 收集用户反馈

---

**测试负责人**: Claude + Justin
**测试状态**: 部分完成，等待全面测试
**下次更新**: 执行完整安装和功能测试后
