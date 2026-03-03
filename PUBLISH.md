# 📦 OpenClaw Video 发布指南

本指南介绍如何将 OpenClaw Video Skill 发布到各个知名平台。

## 🎯 推荐发布平台

### 1. npm Registry (强烈推荐)

npm 是最大的 JavaScript 包管理器，适合发布 Node.js 工具和库。

#### 准备工作

```bash
# 1. 注册 npm 账号（如果还没有）
# 访问 https://www.npmjs.com/signup

# 2. 登录 npm
npm login

# 3. 验证登录状态
npm whoami
```

#### 发布步骤

```bash
# 1. 确保所有更改已提交
git status

# 2. 运行测试（如果有）
npm test

# 3. 发布到 npm
npm publish

# 成功后，任何人都可以通过以下命令安装：
# npm install -g openclaw-video
```

#### 更新版本

```bash
# 更新补丁版本 (1.0.0 -> 1.0.1)
npm version patch

# 更新次要版本 (1.0.0 -> 1.1.0)
npm version minor

# 更新主要版本 (1.0.0 -> 2.0.0)
npm version major

# 推送更改并发布
git push && git push --tags
npm publish
```

---

### 2. GitHub Marketplace

将项目作为 GitHub Action 或 CLI 工具发布。

#### 准备工作

1. 确保项目已推送到 GitHub
2. 添加清晰的 README 和文档
3. 创建 Releases

#### 创建 Release

```bash
# 使用 GitHub CLI
gh release create v1.0.0 \
  --title "OpenClaw Video v1.0.0" \
  --notes "首次发布：完整的视频生成流水线" \
  --generate-notes

# 或手动在 GitHub 网站创建：
# https://github.com/ZhenRobotics/openclaw-video/releases/new
```

#### 添加 Topics 提高可见性

在 GitHub 仓库页面添加以下 topics：
- `video-generation`
- `remotion`
- `openai`
- `automation`
- `ai-tools`
- `tts`
- `whisper`

---

### 3. Anthropic MCP (Model Context Protocol)

如果想作为 Claude 的 MCP Server 发布，需要创建 MCP 配置。

#### 创建 MCP Server 配置

创建 `mcp-config.json`:

```json
{
  "mcpServers": {
    "openclaw-video": {
      "command": "node",
      "args": ["agents/video-agent.ts"],
      "env": {
        "OPENAI_API_KEY": "${OPENAI_API_KEY}"
      }
    }
  }
}
```

#### 提交到 MCP Registry

访问 Anthropic 的 MCP 目录并提交您的 Server：
- https://github.com/anthropics/mcp-servers

---

### 4. 社区平台

#### Product Hunt

适合产品发布和推广：
1. 访问 https://www.producthunt.com/posts/new
2. 创建产品页面
3. 准备：
   - 产品名称：OpenClaw Video
   - 标语：AI-Powered Video Generation Pipeline
   - 描述：详细介绍功能和优势
   - 演示视频或截图
   - 链接到 GitHub 仓库

#### Indie Hackers

适合独立开发者社区：
1. 访问 https://www.indiehackers.com/
2. 发布 Post 介绍项目
3. 分享技术细节和开发历程

#### Reddit

相关 Subreddit：
- r/opensource
- r/javascript
- r/remotion
- r/AI
- r/SideProject

#### Twitter/X

使用标签：
- #VideoGeneration
- #OpenAI
- #Remotion
- #AITools
- #OpenSource

---

## 📝 发布前检查清单

### 必需项

- [ ] README.md 完整且清晰
- [ ] package.json 包含正确信息
- [ ] LICENSE 文件已添加
- [ ] .gitignore 排除敏感文件
- [ ] 所有文档已更新
- [ ] 示例和演示可用

### 推荐项

- [ ] CHANGELOG.md 记录变更
- [ ] CONTRIBUTING.md 贡献指南
- [ ] 演示视频或 GIF
- [ ] 详细的使用文档
- [ ] API 文档（如果适用）
- [ ] 测试覆盖（如果适用）

### 安全检查

- [ ] 删除所有 API Keys
- [ ] 删除敏感信息
- [ ] 检查 .gitignore 配置
- [ ] 审查所有文件内容

---

## 🚀 快速发布流程

### 选项 A: 只发布到 npm

```bash
# 1. 更新版本
npm version patch

# 2. 提交更改
git add .
git commit -m "Prepare for npm publish"
git push

# 3. 发布到 npm
npm publish

# 完成！✨
```

### 选项 B: 同时发布到 npm 和 GitHub

```bash
# 1. 更新版本并创建 tag
npm version patch

# 2. 推送到 GitHub
git push && git push --tags

# 3. 创建 GitHub Release
gh release create v1.0.1 --generate-notes

# 4. 发布到 npm
npm publish

# 完成！✨
```

---

## 📊 发布后推广

### 1. 更新 README.md 添加徽章

```markdown
![npm version](https://img.shields.io/npm/v/openclaw-video)
![npm downloads](https://img.shields.io/npm/dm/openclaw-video)
![GitHub stars](https://img.shields.io/github/stars/ZhenRobotics/openclaw-video)
![License](https://img.shields.io/github/license/ZhenRobotics/openclaw-video)
```

### 2. 创建演示内容

- 录制使用演示视频
- 创建教程文章
- 制作 GIF 演示
- 准备案例研究

### 3. 社区参与

- 回复 Issues 和 PR
- 参与相关讨论
- 分享使用案例
- 收集用户反馈

---

## 🔧 维护和更新

### 定期更新

```bash
# 1. 修复 bug 或添加功能
# 2. 更新版本号
npm version patch  # 或 minor/major

# 3. 更新 CHANGELOG.md
# 4. 提交并推送
git push && git push --tags

# 5. 创建 Release
gh release create v1.0.2 --generate-notes

# 6. 发布更新
npm publish
```

### 监控指标

- npm 下载量：https://npm-stat.com/charts.html?package=openclaw-video
- GitHub Stars 和 Forks
- Issues 和 Pull Requests
- 用户反馈

---

## 📞 需要帮助？

如果在发布过程中遇到问题：

1. **npm 相关**：https://docs.npmjs.com/
2. **GitHub Releases**：https://docs.github.com/en/repositories/releasing-projects-on-github
3. **MCP Servers**：https://github.com/anthropics/mcp-servers

---

## 🎉 完成！

发布后，您的项目将：
- ✅ 在 npm 上可搜索和安装
- ✅ 在 GitHub 上可发现
- ✅ 被社区使用和改进

记得定期更新和维护您的项目！🚀
