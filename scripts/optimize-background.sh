#!/usr/bin/env bash
# Optimize background video for Remotion rendering
# Reduces file size and improves loading performance

set -euo pipefail

usage() {
  cat >&2 <<'EOF'
Usage:
  optimize-background.sh <input.mp4> [output.mp4] [options]

Options:
  --resolution <WxH>    Target resolution (default: 1080x1920 for vertical video)
  --fps <number>        Target frame rate (default: 30)
  --bitrate <value>     Target bitrate (default: 2M for good quality/size balance)
  --crf <value>         Constant Rate Factor, 18-28 (default: 23, lower=better quality)
  --preset <speed>      Encoding preset: ultrafast, fast, medium, slow (default: medium)

Examples:
  # Basic optimization (recommended)
  optimize-background.sh input.mp4

  # Custom output path
  optimize-background.sh input.mp4 output.mp4

  # Lower quality for faster loading
  optimize-background.sh input.mp4 --crf 28 --bitrate 1M

  # Horizontal video (landscape)
  optimize-background.sh input.mp4 --resolution 1920x1080

  # Maximum quality
  optimize-background.sh input.mp4 --crf 18 --bitrate 4M --preset slow

Recommended Settings by Use Case:
  - Fast loading (mobile-friendly):  --crf 28 --bitrate 1M
  - Balanced (default):              --crf 23 --bitrate 2M
  - High quality:                    --crf 20 --bitrate 3M
  - Maximum quality:                 --crf 18 --bitrate 4M

Output:
  - Optimized video saved to public/ directory
  - H.264 codec for best compatibility
  - Audio stripped (not needed for background)
EOF
  exit 2
}

if [[ "${1:-}" == "" || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
fi

# Check ffmpeg availability
if ! command -v ffmpeg &> /dev/null; then
  echo "❌ Error: ffmpeg not found" >&2
  echo "   Install: apt install ffmpeg (Ubuntu) or brew install ffmpeg (macOS)" >&2
  exit 1
fi

input="${1:-}"
output="${2:-public/background-optimized.mp4}"
shift 1
if [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-- ]]; then
  shift 1
fi

# Default options (optimized for Remotion)
resolution="1080x1920"  # Vertical video
fps="30"
bitrate="2M"
crf="23"
preset="medium"

# Parse options
while [[ $# -gt 0 ]]; do
  case "$1" in
    --resolution)
      resolution="${2:-}"
      shift 2
      ;;
    --fps)
      fps="${2:-}"
      shift 2
      ;;
    --bitrate)
      bitrate="${2:-}"
      shift 2
      ;;
    --crf)
      crf="${2:-}"
      shift 2
      ;;
    --preset)
      preset="${2:-}"
      shift 2
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      ;;
  esac
done

# Validate input
if [[ ! -f "$input" ]]; then
  echo "❌ Error: Input file not found: $input" >&2
  exit 1
fi

# Create output directory
mkdir -p "$(dirname "$output")"

# Get input video info
echo "📹 Analyzing input video..." >&2
input_size=$(du -h "$input" | cut -f1)
input_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input" 2>/dev/null || echo "unknown")
input_resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$input" 2>/dev/null || echo "unknown")

echo ""
echo "Input Video Info:"
echo "  File: $input"
echo "  Size: $input_size"
echo "  Duration: ${input_duration}s"
echo "  Resolution: $input_resolution"
echo ""

echo "Optimization Settings:"
echo "  Target resolution: $resolution"
echo "  Frame rate: ${fps} fps"
echo "  Bitrate: $bitrate"
echo "  CRF: $crf (quality)"
echo "  Preset: $preset (speed)"
echo ""

# Run ffmpeg optimization
echo "🔄 Optimizing video (this may take a while)..." >&2
echo "   Progress will be shown below..." >&2
echo ""

ffmpeg -i "$input" \
  -vf "scale=$resolution:force_original_aspect_ratio=decrease,pad=$resolution:(ow-iw)/2:(oh-ih)/2" \
  -r "$fps" \
  -c:v libx264 \
  -preset "$preset" \
  -crf "$crf" \
  -b:v "$bitrate" \
  -maxrate "${bitrate}" \
  -bufsize "$(echo "$bitrate" | sed 's/M/*2M/; s/K/*2K/')" \
  -pix_fmt yuv420p \
  -movflags +faststart \
  -an \
  -y \
  "$output" 2>&1 | grep -E "(frame=|size=|time=|speed=)" || true

# Check output
if [[ ! -f "$output" ]]; then
  echo "" >&2
  echo "❌ Optimization failed" >&2
  exit 1
fi

# Get output info
output_size=$(du -h "$output" | cut -f1)
output_duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$output" 2>/dev/null || echo "unknown")
output_resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$output" 2>/dev/null || echo "unknown")

# Calculate compression ratio
if [[ "$input_size" =~ ^([0-9.]+)([KMG]) ]] && [[ "$output_size" =~ ^([0-9.]+)([KMG]) ]]; then
  input_num="${BASH_REMATCH[1]}"
  input_unit="${BASH_REMATCH[2]}"
  output_num="${BASH_REMATCH[1]}"
  output_unit="${BASH_REMATCH[2]}"

  # Convert to MB for comparison
  case "$input_unit" in
    K) input_mb=$(echo "scale=2; $input_num / 1024" | bc) ;;
    M) input_mb=$input_num ;;
    G) input_mb=$(echo "scale=2; $input_num * 1024" | bc) ;;
  esac

  case "$output_unit" in
    K) output_mb=$(echo "scale=2; $output_num / 1024" | bc) ;;
    M) output_mb=$output_num ;;
    G) output_mb=$(echo "scale=2; $output_num * 1024" | bc) ;;
  esac

  if command -v bc &> /dev/null; then
    ratio=$(echo "scale=1; ($input_mb - $output_mb) / $input_mb * 100" | bc 2>/dev/null || echo "N/A")
  else
    ratio="N/A"
  fi
else
  ratio="N/A"
fi

echo ""
echo "✅ Optimization complete!"
echo ""
echo "Output Video Info:"
echo "  File: $output"
echo "  Size: $output_size (was $input_size)"
echo "  Compression: ${ratio}%"
echo "  Duration: ${output_duration}s"
echo "  Resolution: $output_resolution"
echo ""
echo "Next Steps:"
echo "  1. Test the optimized video in Remotion:"
echo "     pnpm exec remotion preview"
echo ""
echo "  2. If loading is still slow, try:"
echo "     - Lower bitrate: --bitrate 1M"
echo "     - Higher CRF: --crf 28 (lower quality, smaller file)"
echo "     - Faster preset: --preset fast"
echo ""
echo "  3. Update scenes-data.ts to use the optimized video:"
echo "     bgVideo: '$(basename "$output")'"
echo ""
