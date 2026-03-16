# v1.2.0 发布检查清单

**版本:** 1.2.0
**发布日期:** 2026-03-07
**功能:** 背景视频支持

---

## ✅ 已完成的工作

### 1. 代码和功能
- [x] 背景视频功能实现
- [x] 命令行参数支持（--bg-video, --bg-opacity, --bg-overlay）
- [x] 类型定义扩展
- [x] 渲染组件更新
- [x] 完整集成测试通过

### 2. 文档
- [x] README.md 更新
- [x] openclaw-skill/SKILL.md 更新
- [x] RELEASE_NOTES_v1.2.0.md 创建
- [x] BACKGROUND_VIDEO_FEATURE.md 创建
- [x] GITHUB_RELEASE_GUIDE.md 创建
- [x] NPM_PUBLISH_GUIDE.md 创建
- [x] CLAWHUB_UPDATE_v1.2.0.md 创建

### 3. 版本控制
- [x] 版本号更新到 1.2.0
- [x] Git 提交完成（2 个提交）
  - e4f9e55: ✨ Add background video support (v1.2.0)
  - 536a201: 🔧 Update repository URLs and npm package config
- [x] 推送到远程仓库
- [x] Git Tag v1.2.0 创建并推送

### 4. 配置文件
- [x] package.json 更新（版本和仓库 URL）
- [x] .npmignore 优化

---

## ⏳ 待完成的工作

### 1. GitHub Release 📝 **需要手动操作**

**优先级:** 🔥 高

**步骤:**
1. 访问: https://github.com/ZhenRobotics/openclaw-video-generator/releases/new?tag=v1.2.0
2. 填写 Release 信息:
   - **Title:** `v1.2.0 - Background Video Support`
   - **Description:** 参考 `GITHUB_RELEASE_GUIDE.md` 中的内容
3. 勾选 "Set as the latest release"
4. 点击 "Publish release"

**参考文档:** `GITHUB_RELEASE_GUIDE.md`

**验证:**
- [ ] Release 已发布
- [ ] 显示为 "Latest release"
- [ ] 描述完整准确

---

### 2. npm 发布 📦 **需要手动操作**

**优先级:** 🔥 高

**步骤:**
1. 登录 npm:
   ```bash
   npm login
   ```

2. 验证登录:
   ```bash
   npm whoami
   ```

3. 最终检查:
   ```bash
   npm pack --dry-run
   ```

4. 发布:
   ```bash
   npm publish
   ```

5. 验证:
   ```bash
   npm view openclaw-video version
   npm info openclaw-video
   ```

**参考文档:** `NPM_PUBLISH_GUIDE.md`

**可选 - 减小包大小:**
```bash
# 删除测试文件（可选，会减小约 1 MB）
rm -f public/example-script.mp3
rm -f public/generated.mp3
rm -f public/test-background.mp4
```

**验证:**
- [ ] npm 发布成功
- [ ] 版本号显示 1.2.0
- [ ] npm 页面更新
- [ ] 可以全局安装: `npm install -g openclaw-video@1.2.0`
- [ ] CLI 工具正常: `openclaw-video help`

---

### 3. ClawHub Skill 更新 🎯 **需要手动操作**

**优先级:** 🟡 中

**步骤:**
1. 登录 ClawHub: https://clawhub.ai/login

2. 找到 skill: https://clawhub.ai/ZhenStaff/video-generator

3. 上传更新的 SKILL.md:
   - 文件路径: `openclaw-skill/SKILL.md`

4. 设置版本:
   - Version Tag: `v1.2.0`
   - Release Date: `2026-03-07`

5. 填写更新说明（参考 `CLAWHUB_UPDATE_v1.2.0.md`）

6. 发布更新

**参考文档:** `CLAWHUB_UPDATE_v1.2.0.md`

**验证:**
- [ ] ClawHub skill 已更新
- [ ] 版本显示 v1.2.0
- [ ] 新特性描述准确
- [ ] 可以安装: `clawhub install video-generator`

---

## 📊 发布后验证

### GitHub
- [ ] Release 页面显示 v1.2.0
- [ ] Tag 存在
- [ ] 最新提交包含正确的更改

### npm
- [ ] https://www.npmjs.com/package/openclaw-video 显示 1.2.0
- [ ] README 正确显示
- [ ] 关键词和描述准确
- [ ] 下载链接有效

### ClawHub
- [ ] Skill 页面更新
- [ ] 版本号正确
- [ ] 文档完整

### 功能测试
```bash
# 安装测试
npm install -g openclaw-video@1.2.0

# CLI 测试
openclaw-video help

# 背景视频功能测试
cd ~/openclaw-video-generator
./scripts/script-to-video.sh scripts/example-script.txt \
  --bg-video /path/to/test.mp4 \
  --bg-opacity 0.4
```

---

## 📢 发布公告（可选）

### 社交媒体
在以下平台发布更新公告:
- [ ] Twitter/X
- [ ] LinkedIn
- [ ] 相关技术社区
- [ ] 项目博客

**公告模板:**
```
🎉 OpenClaw Video v1.2.0 发布！

✨ 新功能：背景视频支持
- 为生成的视频添加自定义背景
- 完全可控的透明度和遮罩
- 一行命令即可使用

npm install -g openclaw-video@1.2.0

了解更多: https://github.com/ZhenRobotics/openclaw-video-generator

#AI #VideoGeneration #Remotion #OpenAI
```

### 项目文档
- [ ] 更新项目主页（如果有）
- [ ] 添加示例视频演示
- [ ] 更新使用教程

---

## 🔗 重要链接

**GitHub:**
- 仓库: https://github.com/ZhenRobotics/openclaw-video-generator
- Releases: https://github.com/ZhenRobotics/openclaw-video-generator/releases
- Issues: https://github.com/ZhenRobotics/openclaw-video-generator/issues

**npm:**
- 包页面: https://www.npmjs.com/package/openclaw-video

**ClawHub:**
- Skill 页面: https://clawhub.ai/ZhenStaff/video-generator

**本地文档:**
- `GITHUB_RELEASE_GUIDE.md` - GitHub Release 指南
- `NPM_PUBLISH_GUIDE.md` - npm 发布指南
- `CLAWHUB_UPDATE_v1.2.0.md` - ClawHub 更新指南
- `RELEASE_NOTES_v1.2.0.md` - 完整发布说明
- `BACKGROUND_VIDEO_FEATURE.md` - 功能实现总结

---

## 📝 下次发布改进

记录本次发布过程中的经验：

**做得好的地方:**
- 完整的功能测试
- 详细的文档更新
- 清晰的提交历史

**可以改进的地方:**
- [ ] 自动化发布流程（CI/CD）
- [ ] 自动生成 Changelog
- [ ] 集成测试自动化

---

## ✅ 发布完成确认

当所有步骤完成后，填写:

- **GitHub Release 发布时间:** __________
- **npm 发布时间:** __________
- **ClawHub 更新时间:** __________
- **发布人:** __________
- **验证状态:** ☐ 全部通过

---

**当前状态:**
- ✅ 代码完成
- ✅ Git 推送完成
- ⏳ 等待手动发布: GitHub Release, npm, ClawHub

**下一步:** 按照本清单完成 3 个平台的手动发布操作。

---

**祝发布顺利！** 🎉🚀
