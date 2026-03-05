#!/bin/bash
# OpenClaw 视频生成包装脚本
# 用法: ./generate-for-openclaw.sh "你的脚本内容"

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 加载环境变量（如果 .env 文件存在）
if [ -f .env ]; then
    echo "📦 Loading configuration from .env..."
    set -a
    source .env
    set +a
fi

# 检查 API Key
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ 错误：OPENAI_API_KEY 未设置" >&2
    echo "" >&2
    echo "请设置环境变量或创建 .env 文件：" >&2
    echo "  1. 复制 .env 文件模板" >&2
    echo "  2. 填入你的 API 密钥" >&2
    echo "  3. 重新运行此脚本" >&2
    echo "" >&2
    echo "或者直接设置环境变量：" >&2
    echo "  export OPENAI_API_KEY='your-key-here'" >&2
    exit 1
fi

# 检查参数
if [ -z "$1" ]; then
    echo "错误：请提供脚本内容" >&2
    echo "用法: $0 \"你的脚本内容\"" >&2
    exit 1
fi

# 运行视频生成
echo "🎬 开始生成视频..."
echo "📝 脚本: $1"
echo "🔑 API: ${OPENAI_API_BASE:-https://api.openai.com/v1}"
echo ""

./agents/video-cli.sh generate "$1"

# 显示结果
if [ -f out/generated.mp4 ]; then
    echo ""
    echo "✅ 视频生成成功！"
    echo "📹 文件位置: $SCRIPT_DIR/out/generated.mp4"
    echo "📊 文件大小: $(du -h out/generated.mp4 | cut -f1)"
    echo ""
    echo "查看视频: mpv $SCRIPT_DIR/out/generated.mp4"
else
    echo ""
    echo "❌ 视频生成失败，请检查错误信息" >&2
    exit 1
fi
