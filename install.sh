#!/bin/bash
# OpenClaw Video - 快速安装脚本

set -e

echo "========================================="
echo "  OpenClaw Video - 快速安装"
echo "========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查 Node.js
echo "检查依赖..."
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js 未安装${NC}"
    echo "请先安装 Node.js >= 18: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js 版本太低 (当前: v$NODE_VERSION)${NC}"
    echo "需要 Node.js >= 18"
    exit 1
fi

echo -e "${GREEN}✓ Node.js $(node -v)${NC}"

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm 未安装${NC}"
    exit 1
fi

echo -e "${GREEN}✓ npm $(npm -v)${NC}"
echo ""

# 安装依赖
echo "安装项目依赖..."
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 依赖安装完成${NC}"
else
    echo -e "${RED}❌ 依赖安装失败${NC}"
    exit 1
fi

echo ""

# 检查 OpenAI API Key
echo "检查环境变量..."
if [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  OPENAI_API_KEY 未设置${NC}"
    echo ""
    echo "请设置您的 OpenAI API Key："
    echo ""
    echo "  export OPENAI_API_KEY=\"sk-your-key-here\""
    echo ""
    echo "或添加到 ~/.bashrc 或 ~/.zshrc 以永久保存："
    echo ""
    echo "  echo 'export OPENAI_API_KEY=\"sk-your-key-here\"' >> ~/.bashrc"
    echo ""
else
    echo -e "${GREEN}✓ OPENAI_API_KEY 已设置${NC}"
fi

echo ""
echo "========================================="
echo -e "${GREEN}✅ 安装完成！${NC}"
echo "========================================="
echo ""
echo "快速开始："
echo ""
echo "  # 生成视频（简单方式）"
echo "  ./generate-for-openclaw.sh \"你的脚本内容\""
echo ""
echo "  # 生成视频（CLI 方式）"
echo "  ./agents/video-cli.sh generate \"你的脚本内容\""
echo ""
echo "  # 查看帮助"
echo "  ./agents/video-cli.sh help"
echo ""
echo "  # 查看快速指南"
echo "  cat QUICKSTART.md"
echo ""
echo "更多文档："
echo "  - README.md - 完整文档"
echo "  - QUICKSTART.md - 快速开始指南"
echo "  - docs/ - 详细技术文档"
echo ""
echo "ClawHub Skill: https://clawhub.ai/ZhenStaff/video-generator"
echo "GitHub: https://github.com/ZhenRobotics/openclaw-video"
echo ""
