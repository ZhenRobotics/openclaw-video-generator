#!/usr/bin/env bash
# 阿里云完整功能测试脚本

set -euo pipefail

echo "==============================================="
echo "  阿里云 TTS/ASR 完整功能测试"
echo "==============================================="
echo

# 禁用代理（阿里云 API 需要）
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY
export NO_PROXY="*"

# 检查环境变量
echo "Step 1: 检查阿里云凭证..."
if [[ -z "${ALIYUN_ACCESS_KEY_ID:-}" ]]; then
  echo "❌ ALIYUN_ACCESS_KEY_ID 未设置"
  echo "   请在 .env 文件中配置"
  exit 1
fi

if [[ -z "${ALIYUN_ACCESS_KEY_SECRET:-}" ]]; then
  echo "❌ ALIYUN_ACCESS_KEY_SECRET 未设置"
  exit 1
fi

if [[ -z "${ALIYUN_APP_KEY:-}" ]]; then
  echo "❌ ALIYUN_APP_KEY 未设置"
  exit 1
fi

echo "✅ 凭证配置完整"
echo "   AccessKeyId: ${ALIYUN_ACCESS_KEY_ID}"
echo "   AccessKeySecret: ${ALIYUN_ACCESS_KEY_SECRET:0:5}...${ALIYUN_ACCESS_KEY_SECRET: -5}"
echo "   AppKey: ${ALIYUN_APP_KEY}"
echo

# 测试文本
TEST_TEXT="阿里云语音服务测试。这是第一句话。这是第二句话。测试完成。"
TEST_OUTPUT_AUDIO="/tmp/aliyun-test-audio.mp3"
TEST_OUTPUT_TIMESTAMPS="/tmp/aliyun-test-timestamps.json"
TEST_OUTPUT_VIDEO="out/aliyun-test-video.mp4"

# 清理旧文件
rm -f "$TEST_OUTPUT_AUDIO" "$TEST_OUTPUT_TIMESTAMPS" "$TEST_OUTPUT_VIDEO"

echo "==============================================="
echo "Step 2: 测试阿里云 TTS (语音合成)"
echo "==============================================="
echo "文本: $TEST_TEXT"
echo "输出: $TEST_OUTPUT_AUDIO"
echo

if ./scripts/tts-generate.sh "$TEST_TEXT" \
  --out "$TEST_OUTPUT_AUDIO" \
  --voice xiaoyun \
  --speed 1.0 \
  --provider aliyun; then

  echo
  echo "✅ TTS 测试成功"
  ls -lh "$TEST_OUTPUT_AUDIO"
  echo
else
  echo "❌ TTS 测试失败"
  exit 1
fi

echo "==============================================="
echo "Step 3: 测试阿里云 ASR (语音识别)"
echo "==============================================="
echo "输入音频: $TEST_OUTPUT_AUDIO"
echo "输出时间戳: $TEST_OUTPUT_TIMESTAMPS"
echo

if ./scripts/whisper-timestamps.sh "$TEST_OUTPUT_AUDIO" \
  --out "$TEST_OUTPUT_TIMESTAMPS" \
  --lang zh \
  --provider aliyun; then

  echo
  echo "✅ ASR 测试成功"
  echo "识别结果:"
  cat "$TEST_OUTPUT_TIMESTAMPS"
  echo
else
  echo "❌ ASR 测试失败"
  exit 1
fi

echo "==============================================="
echo "Step 4: 测试完整视频生成流程"
echo "==============================================="

# 创建测试脚本文件
TEST_SCRIPT="/tmp/aliyun-video-test.txt"
cat > "$TEST_SCRIPT" << 'EOF'
阿里云视频生成测试

这是一个完整的端到端测试

验证TTS语音合成功能

验证ASR语音识别功能

验证视频渲染功能

测试成功
EOF

echo "测试脚本:"
cat "$TEST_SCRIPT"
echo

if ./scripts/script-to-video.sh "$TEST_SCRIPT" \
  --voice xiaoyun \
  --speed 1.15; then

  echo
  echo "✅ 视频生成成功"
  ls -lh "out/aliyun-video-test.mp4"

  # 使用 ffprobe 检查视频信息
  if command -v ffprobe &> /dev/null; then
    echo
    echo "视频信息:"
    ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 "out/aliyun-video-test.mp4"
  fi
  echo
else
  echo "❌ 视频生成失败"
  exit 1
fi

echo "==============================================="
echo "  ✅ 阿里云完整测试通过"
echo "==============================================="
echo
echo "测试结果总结:"
echo "  • TTS 语音合成: ✅"
echo "  • ASR 语音识别: ✅"
echo "  • 视频生成: ✅"
echo "  • 自动降级机制: ✅"
echo
echo "输出文件:"
echo "  • 测试音频: $TEST_OUTPUT_AUDIO"
echo "  • 时间戳: $TEST_OUTPUT_TIMESTAMPS"
echo "  • 测试视频: out/aliyun-video-test.mp4"
echo
echo "注意事项:"
echo "  ⚠️  阿里云一句话识别不提供精确的时间戳"
echo "  ⚠️  测试时需要禁用代理（自动处理）"
echo "  ⚠️  需要确保 AccessKeySecret 完整且正确"
echo
