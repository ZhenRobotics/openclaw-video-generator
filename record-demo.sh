#!/bin/bash
# 演示录制助手脚本

echo "═══════════════════════════════════════════════════════════════"
echo "  OpenClaw Video Generator - 演示录制"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📋 准备工作："
echo "1. 启动屏幕录制工具（Peek 或 SimpleScreenRecorder）"
echo "2. 调整录制区域到 800x600"
echo "3. 准备开始录制..."
echo ""
read -p "按 Enter 键继续..."

echo ""
echo "🎬 镜头 1/5: 展示脚本内容"
echo "─────────────────────────────────────────────────────────────"
cat demo-script.txt
echo ""
sleep 2

echo "🎬 镜头 2/5: 运行生成命令"
echo "─────────────────────────────────────────────────────────────"
echo "$ ./scripts/script-to-video.sh demo-script.txt"
echo ""
echo "⏳ 正在生成视频（大约需要 2-3 分钟）..."
echo ""

# 这里用户需要实际运行命令
echo "请在另一个终端运行："
echo "  cd ~/openclaw-video-generator"
echo "  ./scripts/script-to-video.sh demo-script.txt"
echo ""
read -p "生成完成后按 Enter 键继续..."

echo ""
echo "🎬 镜头 3/5: 检查输出文件"
echo "─────────────────────────────────────────────────────────────"
ls -lh out/demo-script.mp4
echo ""
sleep 2

echo "🎬 镜头 4/5: 播放视频"
echo "─────────────────────────────────────────────────────────────"
echo "$ xdg-open out/demo-script.mp4"
echo ""
echo "（视频应该会在默认播放器中打开）"
echo ""
sleep 2

echo ""
echo "✅ 录制完成！"
echo "─────────────────────────────────────────────────────────────"
echo "下一步："
echo "1. 停止屏幕录制"
echo "2. 保存为 demo.gif"
echo "3. 移动到 docs/ 目录："
echo "   mkdir -p docs"
echo "   mv ~/录制的文件.gif docs/demo.gif"
echo ""
echo "═══════════════════════════════════════════════════════════════"
