#!/usr/bin/env bash
# Extract timestamps from audio using OpenAI Whisper API
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage:
  whisper-timestamps.sh <audio-file> [--out /path/to/timestamps.json]

Example:
  whisper-timestamps.sh audio.mp3
  whisper-timestamps.sh audio.mp3 --out timestamps.json

Output format:
  [
    {"start": 0.0, "end": 3.46, "text": "三家巨头同一天说了一件事"},
    {"start": 3.46, "end": 5.90, "text": "微软说Copilot已经能写掉90%的代码"},
    ...
  ]
EOF
  exit 2
}

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi

in="${1:-}"
shift || true

out=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --out)
      out="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      ;;
  esac
done

if [[ ! -f "$in" ]]; then
  echo "File not found: $in" >&2
  exit 1
fi

if [[ "${OPENAI_API_KEY:-}" == "" ]]; then
  echo "Missing OPENAI_API_KEY" >&2
  exit 1
fi

if [[ "$out" == "" ]]; then
  base="${in%.*}"
  out="${base}-timestamps.json"
fi

mkdir -p "$(dirname "$out")"

# Call OpenAI Whisper API with verbose_json format to get timestamps
# Specify language=zh for Chinese to ensure accurate transcription
echo "Transcribing with timestamps (Chinese)..." >&2
# Use custom API base if set, otherwise use OpenAI
api_base="${OPENAI_API_BASE:-https://api.openai.com/v1}"

# Retry logic for unstable networks
max_retries=3
retry_count=0
tmp_response="/tmp/whisper_response_$$.json"

while [[ $retry_count -lt $max_retries ]]; do
  if curl -sS "${api_base}/audio/transcriptions" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Accept: application/json" \
    -F "file=@${in}" \
    -F "model=whisper-1" \
    -F "language=zh" \
    -F "response_format=verbose_json" \
    -F "timestamp_granularities[]=segment" \
    > "$tmp_response" 2>&1; then

    # Check if response is valid JSON with segments
    if jq -e '.segments' "$tmp_response" > /dev/null 2>&1; then
      jq '[.segments[] | {start: .start, end: .end, text: .text}]' "$tmp_response" > "$out"
      rm -f "$tmp_response"
      break
    fi
  fi

  retry_count=$((retry_count + 1))
  if [[ $retry_count -lt $max_retries ]]; then
    echo "⚠️  Attempt $retry_count failed, retrying in 3s..." >&2
    sleep 3
  fi
done

if [[ $retry_count -eq $max_retries ]]; then
  echo "❌ Failed after $max_retries attempts" >&2
  rm -f "$tmp_response"
  exit 1
fi

echo "Timestamps saved to: $out" >&2
echo "$out"
