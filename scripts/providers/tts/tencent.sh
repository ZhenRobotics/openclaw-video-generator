#!/usr/bin/env bash
# Tencent TTS Provider

set -euo pipefail

# Input: text, output_file, voice, speed
text="${1:-}"
output="${2:-}"
voice="${3:-${TENCENT_TTS_VOICE:-0}}"  # 0: 女声, 1: 男声
speed="${4:-1.0}"

if [[ -z "$text" || -z "$output" ]]; then
  echo "Usage: tencent.sh <text> <output_file> [voice] [speed]" >&2
  exit 1
fi

if [[ -z "${TENCENT_SECRET_ID:-}" || -z "${TENCENT_SECRET_KEY:-}" ]]; then
  echo "Error: TENCENT_SECRET_ID or TENCENT_SECRET_KEY not set" >&2
  exit 1
fi

mkdir -p "$(dirname "$output")"

# 调用 Python 实现
python_script="$(dirname "$0")/tencent_tts_simple.py"

if [[ ! -f "$python_script" ]]; then
  echo "❌ Tencent TTS: Python script not found: $python_script" >&2
  exit 1
fi

# 检查 Python 3
if ! command -v python3 &> /dev/null; then
  echo "❌ Tencent TTS: python3 not found" >&2
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
    echo "⚠️  Tencent TTS: Attempt $i failed, retrying..." >&2
    sleep 2
  fi
done

echo "❌ Tencent TTS: Failed after $max_retries attempts" >&2
exit 1
