#!/usr/bin/env bash
# Aliyun TTS Provider

set -euo pipefail

# Input: text, output_file, voice, speed
text="${1:-}"
output="${2:-}"
voice="${3:-${ALIYUN_TTS_VOICE:-Aibao}}"
speed="${4:-1.0}"

if [[ -z "$text" || -z "$output" ]]; then
  echo "Usage: aliyun.sh <text> <output_file> [voice] [speed]" >&2
  exit 1
fi

if [[ -z "${ALIYUN_ACCESS_KEY_ID:-}" || -z "${ALIYUN_ACCESS_KEY_SECRET:-}" || -z "${ALIYUN_APP_KEY:-}" ]]; then
  echo "Error: ALIYUN_ACCESS_KEY_ID, ALIYUN_ACCESS_KEY_SECRET, or ALIYUN_APP_KEY not set" >&2
  exit 1
fi

mkdir -p "$(dirname "$output")"

# 调用 Python 实现（简化版，只需 requests 库）
python_script="$(dirname "$0")/aliyun_tts_fixed.py"

if [[ ! -f "$python_script" ]]; then
  echo "❌ Aliyun TTS: Python script not found: $python_script" >&2
  exit 1
fi

# 检查 Python 3
if ! command -v python3 &> /dev/null; then
  echo "❌ Aliyun TTS: python3 not found" >&2
  echo "   Install: apt install python3 (Ubuntu) or brew install python3 (macOS)" >&2
  exit 1
fi

# 调用 Python 脚本并重试
max_retries=3
for i in $(seq 1 $max_retries); do
  if python3 "$python_script" "$text" "$output" "$voice" "$speed" 2>&1; then
    if [[ -f "$output" && -s "$output" ]]; then
      exit 0
    fi
  fi

  if [[ $i -lt $max_retries ]]; then
    echo "⚠️  Aliyun TTS: Attempt $i failed, retrying..." >&2
    sleep 2
  fi
done

echo "❌ Aliyun TTS: Failed after $max_retries attempts" >&2
exit 1
