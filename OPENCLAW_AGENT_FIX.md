# OpenClaw Agent TTS Fix - v1.4.1

## Problem

When using the video generator through OpenClaw's agent interface, Aliyun TTS would fail with "Not implemented yet" error and fallback to OpenAI, even though:
- Aliyun TTS worked fine when called directly via `scripts/tts-generate.sh`
- Environment variables were correctly configured
- The issue only occurred in the agent pipeline

## Root Cause

The `agents/tools.ts` file was receiving text with JSON metadata appended by OpenClaw's agent framework:

```
"Your script text,timeout:30000}"
```

This contaminated text was passed directly to Aliyun TTS, causing validation failures.

## Solution

Added text cleaning logic in `agents/tools.ts` → `generate_tts()`:

1. **Remove JSON metadata patterns**: Strips `,timeout:XXX}`, `,maxTokens:XXX}`, etc.
2. **Use temporary file**: Writes cleaned text to file to avoid shell escaping issues
3. **Safe command execution**: Uses Bash's `$(<file)` syntax for reliable text reading

### Code Changes

**Before (Line 54)**:
```typescript
const cmd = `cd ${WORK_DIR} && ./scripts/tts-generate.sh "${text.replace(/"/g, '\\"')}" --out "${audioPath}" --voice ${voice} --speed ${speed}`;
```

**After**:
```typescript
// Clean text: remove JSON metadata
let cleanText = text.trim()
  .replace(/,\s*(timeout|maxTokens|temperature|metadata)[:\s]*[^}]*}?\s*$/gi, '')
  .replace(/[,}\s]+$/, '').trim();

// Write to temp file
const tmpFile = path.join(AUDIO_DIR, `.tmp-text-${Date.now()}.txt`);
fs.writeFileSync(tmpFile, cleanText, 'utf-8');

// Safe command with file input
const cmd = `bash -c 'cd "${WORK_DIR}" && "${scriptPath}" "$(<"${tmpFile}")" --out "${audioPath}" --voice "${voice}" --speed "${speed}"'`;
```

## Testing

### Test Script
Run `node test-tts-cleanup.js` to verify text cleaning logic:

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

### End-to-End Test

1. **Direct TTS call** (already working):
   ```bash
   scripts/tts-generate.sh "你好，世界" --out test.mp3 --provider aliyun
   # ✅ Works
   ```

2. **Through agent** (now fixed):
   ```bash
   agents/video-cli.sh generate "你好，世界"
   # ✅ Works - uses Aliyun without fallback
   ```

3. **Through OpenClaw** (target scenario):
   ```bash
   generate-for-openclaw.sh "你好，世界"
   # ✅ Works - Aliyun TTS succeeds
   ```

## Impact

- **Before**: Aliyun/Tencent providers always failed in agent pipeline → fallback to OpenAI
- **After**: All providers work correctly through agent pipeline
- **Backward Compatible**: Normal text (without metadata) works exactly as before

## Version

This fix will be included in **v1.4.1** (patch release).

## Related Files

- `agents/tools.ts` - Main fix location
- `test-tts-cleanup.js` - Test script for text cleaning
- `scripts/tts-generate.sh` - TTS entry point (unchanged)
- `scripts/providers/tts/aliyun.sh` - Aliyun provider (unchanged)

---

**Date**: 2026-03-12
**Issue**: OpenClaw agent adds JSON metadata to text, breaking TTS providers
**Fix**: Text cleaning + safe file-based parameter passing
**Status**: ✅ Tested and verified
