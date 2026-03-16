# Release v1.4.1 - Fix OpenClaw Agent TTS Parameter Contamination

## 🐛 Bug Fix

**Critical fix for OpenClaw agent integration**: Aliyun and Tencent TTS providers now work correctly when called through the agent pipeline.

### Problem

When using openclaw-video-generator through OpenClaw's agent interface (`agents/video-cli.sh` or `generate-for-openclaw.sh`):

- Aliyun TTS would always fail and fallback to OpenAI
- Tencent TTS would exhibit the same behavior
- Direct calls to `scripts/tts-generate.sh` worked fine
- Error logs showed text contaminated with JSON metadata like `,timeout:30000}`

**Root Cause**: OpenClaw's agent framework appends execution metadata to text parameters, which was passed directly to TTS providers, causing validation failures.

### Solution

Added intelligent text cleaning in `agents/tools.ts`:

1. **Detects and removes JSON metadata** patterns (`,timeout:XXX}`, `,maxTokens:XXX}`, etc.)
2. **Uses temporary file** for safe parameter passing, avoiding shell escaping issues
3. **Logs cleaning operations** for transparency and debugging

### Code Changes

**Before**:
```typescript
const cmd = `cd ${WORK_DIR} && ./scripts/tts-generate.sh "${text.replace(/"/g, '\\"')}" ...`;
```

**After**:
```typescript
// Clean text: remove JSON metadata
let cleanText = text.trim()
  .replace(/,\s*(timeout|maxTokens|temperature|metadata)[:\s]*[^}]*}?\s*$/gi, '')
  .replace(/[,}\s]+$/, '').trim();

// Write to temp file for safe passing
const tmpFile = path.join(AUDIO_DIR, `.tmp-text-${Date.now()}.txt`);
fs.writeFileSync(tmpFile, cleanText, 'utf-8');

// Safe command execution
const cmd = `bash -c 'cd "${WORK_DIR}" && "${scriptPath}" "$(<"${tmpFile}")" ...'`;
```

## ✅ Testing

### Automated Tests

Created `test-tts-cleanup.js` with 5 test cases:

```bash
$ node test-tts-cleanup.js
🧪 Testing TTS text cleanup function

Test 1: ✅ PASS - Normal text (no metadata)
Test 2: ✅ PASS - Text with ",timeout:30000}"
Test 3: ✅ PASS - Text with ", timeout: 30000 }"
Test 4: ✅ PASS - Text with ",maxTokens:1000}"
Test 5: ✅ PASS - Normal Chinese text

📊 Results: 5/5 tests passed
```

### End-to-End Verification

**Before v1.4.1**:
```bash
$ agents/video-cli.sh generate "你好，世界"
🔄 Trying provider: aliyun
❌ Provider 'aliyun' failed, trying next...
🔄 Trying provider: openai
✅ Used provider: openai  # Unwanted fallback
```

**After v1.4.1**:
```bash
$ agents/video-cli.sh generate "你好，世界"
🔄 Trying provider: aliyun
✅ Used provider: aliyun  # Direct success!
```

## 📦 Installation

```bash
# Update existing installation
npm update -g openclaw-video-generator

# Or fresh install
npm install -g openclaw-video-generator
```

## 🔧 Configuration

No configuration changes required. If you have working Aliyun/Tencent credentials:

```bash
export ALIYUN_ACCESS_KEY_ID="your-id"
export ALIYUN_ACCESS_KEY_SECRET="your-secret"
export ALIYUN_APP_KEY="your-app-key"
```

They will now work correctly through the agent pipeline.

## 🎯 Impact

- ✅ **Fixes**: Aliyun/Tencent providers now work in agent pipeline
- ✅ **Backward Compatible**: Normal text (without metadata) works exactly as before
- ✅ **No Breaking Changes**: All existing functionality preserved
- ✅ **Better Logging**: Shows when text cleaning occurs for transparency

## 📊 Statistics

- **Files Changed**: 3 files
- **Insertions**: 225 lines
- **Deletions**: 10 lines
- **New Test Suite**: test-tts-cleanup.js (5 test cases)

## 🙏 Migration from v1.4.0

Simply update to v1.4.1:

```bash
npm update -g openclaw-video-generator
```

No configuration or workflow changes needed.

## 🔗 Links

- **npm**: https://www.npmjs.com/package/openclaw-video-generator
- **GitHub**: https://github.com/ZhenRobotics/openclaw-video-generator
- **Issues**: https://github.com/ZhenRobotics/openclaw-video-generator/issues
- **Detailed Fix Documentation**: See OPENCLAW_AGENT_FIX.md

## 📝 Related Issues

- Fixes Aliyun TTS failures in OpenClaw agent pipeline
- Fixes Tencent TTS failures in OpenClaw agent pipeline
- Resolves "Not implemented yet" fallback errors when providers are actually configured

---

**Full Changelog**: https://github.com/ZhenRobotics/openclaw-video-generator/compare/v1.4.0...v1.4.1
