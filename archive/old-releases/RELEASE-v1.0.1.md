# Release v1.0.1 - ClawHub Skill 优化

## 🎯 改进

### ClawHub Skill 重大优化

- ✅ **通用路径**: 使用 `~/openclaw-video/` 替代硬编码路径
- ✅ **完整安装指南**: 分步安装说明，支持多种方式
- ✅ **改进 Agent 说明**: 明确的触发条件和使用示例
- ✅ **故障排查指南**: 详细的问题诊断和解决方案
- ✅ **Agent 行为准则**: 清晰的 Do/Don't 列表
- ✅ **快速安装脚本**: 新增 `install.sh` 一键安装
- ✅ **README 更新**: 添加 ClawHub 安装方式

### 文件更新

- `openclaw-skill/SKILL.md` - 完全重写，更专业和易用
- `README.md` - 添加 ClawHub 安装选项
- `install.sh` - 新增快速安装脚本
- `OPTIMIZATION.md` - 详细的优化说明

### ClawHub Skill

📦 安装: `clawhub install video-generator`

🔗 链接: https://clawhub.ai/ZhenStaff/video-generator

### 安装

```bash
# 通过 ClawHub
clawhub install video-generator
git clone https://github.com/ZhenRobotics/openclaw-video.git ~/openclaw-video
cd ~/openclaw-video && ./install.sh

# 或直接从 GitHub
git clone https://github.com/ZhenRobotics/openclaw-video.git
cd openclaw-video && ./install.sh
```

### 快速开始

```bash
./generate-for-openclaw.sh "你的视频脚本"
```

---

**Full Changelog**: https://github.com/ZhenRobotics/openclaw-video/compare/v1.0.0...v1.0.1
