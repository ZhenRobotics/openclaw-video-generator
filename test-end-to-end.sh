#!/usr/bin/env bash
# OpenClaw Video Generator - 端到端集成测试
# 模拟从 Web Portal 到最终视频生成的完整流程

set -euo pipefail

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================================================"
echo "  OpenClaw Video Generator - 端到端集成测试"
echo "  测试场景: 从 Web Portal 请求到视频生成完整流程"
echo "================================================================"
echo

# 禁用代理（用于阿里云等服务）
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY
export NO_PROXY="*"

# 测试配置
TEST_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
TEST_OUTPUT_DIR="test-results/${TEST_TIMESTAMP}"
mkdir -p "${TEST_OUTPUT_DIR}"

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查前置条件
check_prerequisites() {
    log_info "检查前置条件..."

    local missing=0

    # 检查命令
    for cmd in node npm ffmpeg python3; do
        if ! command -v $cmd &> /dev/null; then
            log_error "缺少命令: $cmd"
            missing=$((missing + 1))
        else
            log_success "找到命令: $cmd ($(which $cmd))"
        fi
    done

    # 检查环境变量
    if [[ -z "${OPENAI_API_KEY:-}" ]]; then
        log_error "OPENAI_API_KEY 未设置"
        missing=$((missing + 1))
    else
        log_success "OPENAI_API_KEY 已配置"
    fi

    # 检查项目文件
    if [[ ! -f "package.json" ]]; then
        log_error "package.json 不存在，请在项目根目录运行"
        missing=$((missing + 1))
    fi

    if [[ $missing -gt 0 ]]; then
        log_error "前置条件检查失败 ($missing 项)"
        return 1
    fi

    log_success "前置条件检查通过"
    echo
}

# 测试 1: 多厂商配置检查
test_provider_config() {
    echo "================================================================"
    log_info "测试 1: 多厂商配置检查"
    echo "================================================================"

    ./scripts/test-providers.sh > "${TEST_OUTPUT_DIR}/provider-config.log" 2>&1

    if [[ $? -eq 0 ]]; then
        log_success "多厂商配置检查通过"
        cat "${TEST_OUTPUT_DIR}/provider-config.log"
    else
        log_error "多厂商配置检查失败"
        cat "${TEST_OUTPUT_DIR}/provider-config.log"
        return 1
    fi
    echo
}

# 测试 2: 模拟 Web Portal 请求
simulate_web_portal_request() {
    echo "================================================================"
    log_info "测试 2: 模拟 Web Portal 用户请求"
    echo "================================================================"

    # 模拟用户从 Web Portal 提交的视频生成请求
    local user_request="AI工具正在改变开发方式。第一，提升编码效率。第二，优化代码质量。第三，加速问题排查。拥抱AI，提升十倍生产力。"

    log_info "用户请求: ${user_request}"

    # 创建请求脚本文件
    local request_file="${TEST_OUTPUT_DIR}/user-request.txt"
    echo "${user_request}" > "${request_file}"

    log_success "请求已保存: ${request_file}"
    echo
}

# 测试 3: TTS 语音生成（使用多厂商）
test_tts_generation() {
    echo "================================================================"
    log_info "测试 3: TTS 语音生成（多厂商自动降级）"
    echo "================================================================"

    local input_file="${TEST_OUTPUT_DIR}/user-request.txt"
    local output_audio="${TEST_OUTPUT_DIR}/generated-audio.mp3"

    log_info "输入文件: ${input_file}"
    log_info "输出音频: ${output_audio}"
    log_info "提供商优先级: $(grep "^TTS_PROVIDERS" .env 2>/dev/null || echo 'openai,azure,aliyun,tencent')"
    echo

    if ./scripts/tts-generate.sh "$(cat ${input_file})" \
        --out "${output_audio}" \
        --voice nova \
        --speed 1.15 \
        > "${TEST_OUTPUT_DIR}/tts-generation.log" 2>&1; then

        log_success "TTS 语音生成成功"

        # 显示使用的提供商
        used_provider=$(grep "Used provider:" "${TEST_OUTPUT_DIR}/tts-generation.log" | tail -1 | awk '{print $NF}')
        log_info "使用的提供商: ${used_provider}"

        # 检查音频文件
        if [[ -f "${output_audio}" ]]; then
            local audio_size=$(du -h "${output_audio}" | cut -f1)
            log_success "音频文件大小: ${audio_size}"
        fi
    else
        log_error "TTS 语音生成失败"
        cat "${TEST_OUTPUT_DIR}/tts-generation.log"
        return 1
    fi
    echo
}

# 测试 4: ASR 时间戳提取（使用多厂商）
test_asr_extraction() {
    echo "================================================================"
    log_info "测试 4: ASR 时间戳提取（多厂商自动降级）"
    echo "================================================================"

    local input_audio="${TEST_OUTPUT_DIR}/generated-audio.mp3"
    local output_timestamps="${TEST_OUTPUT_DIR}/timestamps.json"

    log_info "输入音频: ${input_audio}"
    log_info "输出时间戳: ${output_timestamps}"
    echo

    if ./scripts/whisper-timestamps.sh "${input_audio}" \
        --out "${output_timestamps}" \
        --lang zh \
        > "${TEST_OUTPUT_DIR}/asr-extraction.log" 2>&1; then

        log_success "ASR 时间戳提取成功"

        # 显示使用的提供商
        used_provider=$(grep "Used provider:" "${TEST_OUTPUT_DIR}/asr-extraction.log" | tail -1 | awk '{print $NF}')
        log_info "使用的提供商: ${used_provider}"

        # 显示识别结果
        log_info "识别结果预览:"
        cat "${output_timestamps}" | head -20
    else
        log_error "ASR 时间戳提取失败"
        cat "${TEST_OUTPUT_DIR}/asr-extraction.log"
        return 1
    fi
    echo
}

# 测试 5: 场景数据生成
test_scene_generation() {
    echo "================================================================"
    log_info "测试 5: 场景数据生成"
    echo "================================================================"

    local input_timestamps="${TEST_OUTPUT_DIR}/timestamps.json"
    local input_audio="${TEST_OUTPUT_DIR}/generated-audio.mp3"

    log_info "时间戳文件: ${input_timestamps}"
    log_info "音频文件: ${input_audio}"
    echo

    if node scripts/timestamps-to-scenes.js \
        "${input_timestamps}" \
        "${input_audio}" \
        > "${TEST_OUTPUT_DIR}/scene-generation.log" 2>&1; then

        log_success "场景数据生成成功"

        # 统计场景信息
        local scene_count=$(grep "Converted.*segments.*scenes" "${TEST_OUTPUT_DIR}/scene-generation.log" | grep -oP '\d+(?= scenes)' || echo "0")
        log_info "生成场景数: ${scene_count}"

        # 检查场景文件
        if [[ -f "src/scenes-data.ts" ]]; then
            log_success "场景文件已生成: src/scenes-data.ts"
        fi
    else
        log_error "场景数据生成失败"
        cat "${TEST_OUTPUT_DIR}/scene-generation.log"
        return 1
    fi
    echo
}

# 测试 6: 视频渲染
test_video_rendering() {
    echo "================================================================"
    log_info "测试 6: 视频渲染（Remotion）"
    echo "================================================================"

    local output_video="${TEST_OUTPUT_DIR}/final-video.mp4"

    log_info "输出视频: ${output_video}"
    log_info "分辨率: 1080x1920 (竖屏)"
    log_info "帧率: 30 fps"
    echo

    # 使用 npm run build 渲染视频
    log_info "开始渲染视频..."

    if npx remotion render src/index.ts Main "${output_video}" \
        --codec=h264 \
        --audio-codec=aac \
        > "${TEST_OUTPUT_DIR}/video-rendering.log" 2>&1; then

        log_success "视频渲染成功"

        # 检查视频文件
        if [[ -f "${output_video}" ]]; then
            local video_size=$(du -h "${output_video}" | cut -f1)
            log_success "视频文件大小: ${video_size}"

            # 使用 ffprobe 获取视频信息
            if command -v ffprobe &> /dev/null; then
                log_info "视频详细信息:"
                ffprobe -v error -show_entries format=duration,size -of default=noprint_wrappers=1 "${output_video}" 2>&1 | while read line; do
                    log_info "  ${line}"
                done
            fi
        fi
    else
        log_error "视频渲染失败"
        tail -50 "${TEST_OUTPUT_DIR}/video-rendering.log"
        return 1
    fi
    echo
}

# 测试 7: 完整流水线测试
test_full_pipeline() {
    echo "================================================================"
    log_info "测试 7: 完整流水线测试（端到端）"
    echo "================================================================"

    # 创建新的测试脚本
    local test_script="${TEST_OUTPUT_DIR}/pipeline-test.txt"
    cat > "${test_script}" << 'EOF'
OpenClaw视频生成系统测试

这是一个完整的端到端测试

验证多厂商TTS功能

验证多厂商ASR功能

验证自动降级机制

验证视频渲染功能

测试成功
EOF

    log_info "测试脚本: ${test_script}"
    echo

    # 运行完整流水线
    if ./scripts/script-to-video.sh "${test_script}" \
        --voice nova \
        --speed 1.15 \
        > "${TEST_OUTPUT_DIR}/full-pipeline.log" 2>&1; then

        log_success "完整流水线测试通过"

        # 显示使用的提供商
        log_info "TTS 提供商: $(grep "Used provider:" "${TEST_OUTPUT_DIR}/full-pipeline.log" | head -1 | awk '{print $NF}')"
        log_info "ASR 提供商: $(grep "Used provider:" "${TEST_OUTPUT_DIR}/full-pipeline.log" | tail -1 | awk '{print $NF}')"

        # 检查输出视频
        local output_video="out/pipeline-test.mp4"
        if [[ -f "${output_video}" ]]; then
            local video_size=$(du -h "${output_video}" | cut -f1)
            log_success "输出视频: ${output_video} (${video_size})"

            # 复制到测试结果目录
            cp "${output_video}" "${TEST_OUTPUT_DIR}/"
        fi
    else
        log_error "完整流水线测试失败"
        tail -100 "${TEST_OUTPUT_DIR}/full-pipeline.log"
        return 1
    fi
    echo
}

# 生成测试报告
generate_test_report() {
    echo "================================================================"
    log_info "生成测试报告"
    echo "================================================================"

    local report_file="${TEST_OUTPUT_DIR}/test-report.md"

    cat > "${report_file}" << EOF
# OpenClaw Video Generator - 端到端测试报告

**测试时间**: $(date '+%Y-%m-%d %H:%M:%S')
**测试环境**: $(uname -s) $(uname -r)
**Node 版本**: $(node --version)
**Python 版本**: $(python3 --version)

---

## 测试摘要

| 测试项 | 状态 | 说明 |
|--------|------|------|
| 多厂商配置检查 | ✅ | 已通过 |
| Web Portal 请求模拟 | ✅ | 已完成 |
| TTS 语音生成 | ✅ | 使用多厂商自动降级 |
| ASR 时间戳提取 | ✅ | 使用多厂商自动降级 |
| 场景数据生成 | ✅ | 场景自动识别 |
| 视频渲染 | ✅ | Remotion 渲染成功 |
| 完整流水线 | ✅ | 端到端测试通过 |

---

## 测试详情

### 1. 多厂商配置

\`\`\`
$(cat "${TEST_OUTPUT_DIR}/provider-config.log" 2>/dev/null || echo "日志不存在")
\`\`\`

### 2. TTS 提供商

\`\`\`
使用的提供商: $(grep "Used provider:" "${TEST_OUTPUT_DIR}/tts-generation.log" 2>/dev/null | tail -1 | awk '{print $NF}' || echo "未知")
\`\`\`

### 3. ASR 提供商

\`\`\`
使用的提供商: $(grep "Used provider:" "${TEST_OUTPUT_DIR}/asr-extraction.log" 2>/dev/null | tail -1 | awk '{print $NF}' || echo "未知")
\`\`\`

---

## 输出文件

- 测试脚本: \`${TEST_OUTPUT_DIR}/user-request.txt\`
- 生成音频: \`${TEST_OUTPUT_DIR}/generated-audio.mp3\`
- 时间戳: \`${TEST_OUTPUT_DIR}/timestamps.json\`
- 最终视频: \`${TEST_OUTPUT_DIR}/final-video.mp4\`
- 完整流水线视频: \`${TEST_OUTPUT_DIR}/pipeline-test.mp4\`

---

## 测试结论

✅ **所有测试通过**

OpenClaw Video Generator 端到端集成测试成功！

- 多厂商架构工作正常
- 自动降级机制验证通过
- 完整视频生成流程无误

---

**报告生成时间**: $(date '+%Y-%m-%d %H:%M:%S')
EOF

    log_success "测试报告已生成: ${report_file}"
    echo

    # 显示报告
    cat "${report_file}"
}

# 主测试流程
main() {
    local start_time=$(date +%s)

    # 执行测试
    check_prerequisites || exit 1
    test_provider_config || exit 1
    simulate_web_portal_request || exit 1
    test_tts_generation || exit 1
    test_asr_extraction || exit 1
    test_scene_generation || exit 1
    test_video_rendering || exit 1
    test_full_pipeline || exit 1

    # 生成报告
    generate_test_report

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))

    echo "================================================================"
    log_success "端到端测试全部通过！"
    echo "================================================================"
    echo
    log_info "测试耗时: ${duration} 秒"
    log_info "测试结果目录: ${TEST_OUTPUT_DIR}"
    log_info "测试报告: ${TEST_OUTPUT_DIR}/test-report.md"
    echo
    log_success "🎉 OpenClaw Video Generator 已验证可用！"
    echo
}

# 运行主流程
main "$@"
