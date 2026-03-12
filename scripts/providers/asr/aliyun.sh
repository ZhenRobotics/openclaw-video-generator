#!/usr/bin/env bash
# Aliyun ASR Provider

set -euo pipefail

# Input: audio_file, output_json
audio="${1:-}"
output="${2:-}"
language="${3:-zh}"

if [[ -z "$audio" || -z "$output" ]]; then
  echo "Usage: aliyun.sh <audio_file> <output_json> [language]" >&2
  exit 1
fi

if [[ ! -f "$audio" ]]; then
  echo "Error: Audio file not found: $audio" >&2
  exit 1
fi

if [[ -z "${ALIYUN_ACCESS_KEY_ID:-}" || -z "${ALIYUN_ACCESS_KEY_SECRET:-}" ]]; then
  echo "Error: ALIYUN_ACCESS_KEY_ID or ALIYUN_ACCESS_KEY_SECRET not set" >&2
  exit 1
fi

mkdir -p "$(dirname "$output")"

# 调用 Python 实现（使用一句话识别，不提供精确时间戳）
python_script="$(dirname "$0")/aliyun_asr_fixed.py"

if [[ ! -f "$python_script" ]]; then
  echo "❌ Aliyun ASR: Python script not found: $python_script" >&2
  exit 1
fi

# 检查 Python 3
if ! command -v python3 &> /dev/null; then
  echo "❌ Aliyun ASR: python3 not found" >&2
  echo "   Install: apt install python3 (Ubuntu) or brew install python3 (macOS)" >&2
  exit 1
fi

# 调用 Python 脚本并重试
max_retries=3
for i in $(seq 1 $max_retries); do
  if python3 "$python_script" "$audio" "$output" "$language" 2>&1; then
    if [[ -f "$output" && -s "$output" ]]; then
      exit 0
    fi
  fi

  if [[ $i -lt $max_retries ]]; then
    echo "⚠️  Aliyun ASR: Attempt $i failed, retrying..." >&2
    sleep 2
  fi
done

echo "❌ Aliyun ASR: Failed after $max_retries attempts" >&2
exit 1

# 注意: 阿里云一句话识别不提供时间戳
# 如需精确时间戳，请使用 OpenAI Whisper 或 Azure Speech
