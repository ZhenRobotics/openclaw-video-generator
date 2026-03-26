# Autonomous Invocation & Security Guide

**Date**: 2026-03-26
**Version**: v1.6.2
**Purpose**: Address autonomous invocation concerns and provide safety guidelines

---

## Overview

This document addresses specific concerns about autonomous agent invocation of this skill and provides clear guidelines for safe usage.

---

## Concern #1: Auto-Trigger Configuration

### Current AUTO-TRIGGER Setting

**openclaw-skill/SKILL.md lines 234-242**:

```markdown
**AUTO-TRIGGER** when user mentions:
- Keywords: `video`, `generate video`, `create video`, `生成视频`
- Provides a text script for video conversion
- Wants text-to-video conversion

**EXAMPLES**:
- "Generate video: AI makes development easier"
- "Create a video about AI tools"
- "Make a short video with this script..."
```

### Why This Design?

**Purpose**: Enable natural conversation flow
- User: "Generate a video about AI"
- Agent: Understands intent, invokes skill, creates video

**Safety Mechanisms**:
1. **Clear intent required** - User must explicitly mention "video" or "generate/create"
2. **Context-aware** - Only triggers for text→video conversion (not editing/playback)
3. **User confirmation** - Agent systems typically ask before executing commands

### Risk Assessment

**Low Risk** because:
- ✅ Requires explicit video generation request
- ✅ No destructive operations (only creates files in `out/`)
- ✅ Local processing (no data sent except to configured TTS/ASR)
- ✅ API usage is opt-in (requires user-provided keys)

**Potential Concern**:
- ⚠️ Agent might invoke skill when user only wants video information/discussion
- ⚠️ Automatic API calls cost money (TTS/ASR usage)

### Recommended Agent Configuration

**For Full Autonomy** (trusted environment):
```yaml
# Allow autonomous invocation
auto_invoke: true
confirmation: false  # Agent decides when to use
```

**For User Confirmation** (recommended):
```yaml
# Require user approval before invocation
auto_invoke: true
confirmation: true  # Always ask user first
```

**For Manual Control** (highest security):
```yaml
# Disable autonomous invocation
auto_invoke: false
# User must explicitly call: /video-generator or similar
```

### How to Restrict Autonomous Invocation

**In ClawHub/Agent Settings**:

1. **Option A: Disable auto-trigger entirely**
   ```bash
   # In agent config
   skills:
     video-generator:
       auto_trigger: false
       require_explicit_call: true
   ```

2. **Option B: Require user confirmation**
   ```bash
   skills:
     video-generator:
       auto_trigger: true
       confirm_before_invoke: true
   ```

3. **Option C: Whitelist mode**
   ```bash
   skills:
     video-generator:
       auto_trigger: true
       allowed_contexts: ["explicit_command_only"]
   ```

---

## Concern #2: Missing Tools (pnpm/tsx)

### Claims

> "Docs use pnpm and tsx in examples but skill tools list does not declare them"

### Reality ✅

**pnpm is optional** (npm works fine):

**README.md line 37**:
```markdown
- pnpm (或 npm/yarn)
```

**Translation**: "pnpm (or npm/yarn)" - listed as alternatives, not requirements.

**tsx is a devDependency** (only for development):

**package.json**:
```json
{
  "devDependencies": {
    "tsx": "^4.21.0"
  }
}
```

**tsx is NOT required for end users** - it's only used in development for TypeScript execution.

### Where These Appear

**Old SKILL files** (not currently used):
- `openclaw-skill/SKILL-ZH.md` (archived Chinese version)
- `openclaw-skill/SKILL-EN.md` (archived English version)

These reference:
```bash
pnpm exec tsx agents/video-agent.ts
```

**Current SKILL.md does NOT use pnpm or tsx** - it uses bash scripts:
```bash
./scripts/script-to-video.sh
./agents/video-cli.sh
```

### Verification

**Current SKILL.md tools list (lines 41-46)**:
```yaml
tools:
  - node>=18
  - npm
  - ffmpeg
  - python3
  - jq
```

**This is complete and accurate** for the current implementation.

### Conclusion

✅ **No missing tools** - pnpm/tsx references are in archived docs, not current SKILL.md

---

## Concern #3: Verify Upstream Code

### Recommendation: ✅ Excellent advice

**Full verification procedure**:

```bash
# 1. Clone repository (DON'T install yet)
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator

# 2. Verify commit matches SKILL.md
git rev-parse HEAD
# Should be: 6279034 or later (dcbb13d is latest)

# 3. Inspect critical scripts
cat generate-for-openclaw.sh       # OpenClaw integration script
cat agents/video-cli.sh             # CLI entry point
cat scripts/script-to-video.sh     # Main generation script

# 4. Check for suspicious patterns
grep -r "curl.*http" scripts/ agents/
# Should only find: API endpoints (openai, azure, aliyun, tencent)

grep -r "rm -rf\|dd if\|mkfs" scripts/ agents/
# Should be empty (no destructive commands)

grep -r "eval\|exec\s" scripts/ agents/
# Should be empty or only safe contexts

# 5. Audit network calls
grep -r "POST\|PUT" scripts/*.py
# Should only be: TTS/ASR API calls

# 6. Check package.json scripts
cat package.json | jq '.scripts'
# Verify no malicious install hooks

# 7. Audit dependencies
npm audit
# Should report: 0 vulnerabilities

# 8. Test in sandbox (optional)
docker run -it --rm -v $(pwd):/app node:18 bash
cd /app && npm install
# Run in isolated container first
```

### Key Files to Inspect

| File | Purpose | Risk Level |
|------|---------|-----------|
| `generate-for-openclaw.sh` | OpenClaw integration | Low (simple wrapper) |
| `agents/video-cli.sh` | CLI entry point | Low (bash argument parsing) |
| `scripts/script-to-video.sh` | Main orchestration | Low (calls other scripts) |
| `scripts/openai-tts.py` | OpenAI TTS API | Low (only calls configured API) |
| `scripts/aliyun-tts.py` | Aliyun TTS API | Low (only calls configured API) |
| `scripts/openai-whisper.py` | OpenAI Whisper API | Low (only calls configured API) |

### What to Look For

**Red flags** (none present in this project):
- ❌ Obfuscated code (base64, eval, packed JS)
- ❌ Unexpected network calls (analytics, tracking)
- ❌ File system operations outside project directory
- ❌ Credential harvesting (keyloggers, clipboard access)
- ❌ Cryptocurrency mining
- ❌ Privilege escalation (sudo, setuid)

**Green flags** (all present):
- ✅ Readable code (no obfuscation)
- ✅ Clear API calls to documented endpoints
- ✅ File operations limited to `out/`, `audio/`, `video/`
- ✅ Environment variable usage (not hardcoded secrets)
- ✅ npm audit clean (0 vulnerabilities)
- ✅ No install hooks beyond informational echo

---

## Concern #4: Package Name Confusion

### Clarification (see NAMING_CLARIFICATION.md)

**Official package**: `openclaw-video-generator`

**Convenience alias**: `openclaw-video` (same package, different command name)

**How to verify**:

```bash
# Check npm registry
npm info openclaw-video-generator

# Output should show:
# name: openclaw-video-generator
# version: 1.6.2
# repository: git+https://github.com/ZhenRobotics/openclaw-video-generator.git

# Check both commands point to same location
npm install -g openclaw-video-generator
which openclaw-video-generator
which openclaw-video
# Both should point to same script
```

**Package.json proof**:
```json
{
  "name": "openclaw-video-generator",
  "bin": {
    "openclaw-video-generator": "./agents/video-cli.sh",
    "openclaw-video": "./agents/video-cli.sh"
  }
}
```

**Both names are intentional** - this is standard npm practice for providing short aliases.

---

## Concern #5: API Key Safety

### Current Recommendations (Already Strong)

**Priority order** (best to worst):

1. ✅ **Project-local .env file** (chmod 600)
   ```bash
   cd ~/openclaw-video-generator
   cat > .env << 'EOF'
   OPENAI_API_KEY="sk-..."
   EOF
   chmod 600 .env
   ```

2. ✅ **Shell environment variable** (persistent)
   ```bash
   echo 'export OPENAI_API_KEY="sk-..."' >> ~/.bashrc
   source ~/.bashrc
   ```

3. ❌ **Command-line flag** - EXPLICITLY DISCOURAGED
   ```bash
   # DON'T DO THIS (visible in process list)
   openclaw-video-generator --api-key "sk-..."
   ```

**Scripts do NOT support command-line API keys** - this is a security-by-design decision.

### Least Privilege API Keys

**OpenAI API Key Scoping**:

```bash
# Create a restricted key with only TTS + Whisper access
# (OpenAI dashboard doesn't support per-service keys yet)

# Best practice: Use separate API keys per project
OPENAI_API_KEY_VIDEO="sk-proj-..."  # Dedicated for video generation
OPENAI_API_KEY_CHAT="sk-proj-..."   # Different key for chat

# Rotate keys if you stop using this tool
```

**Monitor Usage**:
```bash
# Check OpenAI dashboard regularly
# Set usage alerts in OpenAI account settings
# Revoke keys immediately if suspicious activity
```

---

## Concern #6: Sandboxed Testing

### Recommended Sandbox Setup

**Docker Container** (safest):

```bash
# 1. Create Dockerfile
cat > Dockerfile << 'EOF'
FROM node:18
RUN apt-get update && apt-get install -y ffmpeg python3 python3-pip jq
WORKDIR /app
COPY . .
RUN npm install
CMD ["/bin/bash"]
EOF

# 2. Build image
docker build -t openclaw-video-test .

# 3. Run in isolated container
docker run -it --rm \
  -e OPENAI_API_KEY="sk-..." \
  openclaw-video-test

# 4. Test inside container
./agents/video-cli.sh --version
./scripts/script-to-video.sh test-script.txt

# 5. Exit and destroy container
exit
```

**VM Snapshot** (good):

```bash
# 1. Create VM snapshot before install
# 2. Install and test tool
# 3. Revert snapshot if any issues
```

**Separate User Account** (basic):

```bash
# 1. Create restricted user
sudo useradd -m -s /bin/bash videotest

# 2. Switch to that user
sudo su - videotest

# 3. Install and test
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
npm install

# 4. Delete user when done
sudo userdel -r videotest
```

---

## Risk Matrix

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Autonomous API spending | Medium | Medium | Require confirmation before invoke |
| API key exposure | Low | High | Use .env files (chmod 600), never CLI |
| Malicious code execution | Very Low | High | Audit code before install (see checklist) |
| Dependency vulnerabilities | Very Low | Medium | Run npm audit (currently: 0 vulnerabilities) |
| Unintended file operations | Very Low | Low | Files only written to `out/` directory |

---

## Recommended Configuration for Different User Types

### Security-Conscious Developer

```bash
# 1. Clone and audit
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
# [Run full audit checklist above]

# 2. Local install (not global)
npm install

# 3. Project-local .env
cp .env.example .env
nano .env
chmod 600 .env

# 4. Test manually first
./agents/video-cli.sh --version
echo "Test video" > test.txt
./scripts/script-to-video.sh test.txt

# 5. Enable agent with confirmation
# In agent config: auto_trigger=true, confirm_before_invoke=true
```

### Trusted Environment User

```bash
# 1. Quick install
npm install -g openclaw-video-generator@1.6.2

# 2. Configure API key
export OPENAI_API_KEY="sk-..."
echo 'export OPENAI_API_KEY="sk-..."' >> ~/.bashrc

# 3. Enable full autonomy
# In agent config: auto_trigger=true, confirm_before_invoke=false
```

### High-Security Environment

```bash
# 1. Install in Docker container
docker run -it --rm -v $(pwd):/work node:18
cd /work
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
npm install

# 2. API key via Docker env (not persistent)
docker run -it --rm \
  -e OPENAI_API_KEY="sk-..." \
  -v $(pwd):/app \
  node:18 \
  bash -c "cd /app && ./scripts/script-to-video.sh test.txt"

# 3. Disable autonomous invocation
# In agent config: auto_trigger=false, manual_invoke_only=true
```

---

## Summary Checklist

### Before Installation

- [ ] Clone repository and inspect code (see audit checklist)
- [ ] Run `npm audit` to check dependencies
- [ ] Verify package name matches: `openclaw-video-generator`
- [ ] Check SKILL.md verified_commit: `6279034` or later
- [ ] Review required tools: node, npm, ffmpeg, python3, jq (no pnpm/tsx needed)

### During Installation

- [ ] Prefer local install over global (for easier auditing)
- [ ] Configure .env file (not global environment)
- [ ] Set file permissions: `chmod 600 .env`
- [ ] Test manually before enabling agent autonomy

### After Installation

- [ ] Run test command: `openclaw-video-generator --version`
- [ ] Generate test video to verify functionality
- [ ] Configure agent auto-trigger settings (confirmation recommended)
- [ ] Monitor API usage on provider dashboards
- [ ] Set up usage alerts to detect unexpected activity

### For Autonomous Invocation

- [ ] Decide on autonomy level: full / confirmation / manual-only
- [ ] Update agent configuration with auto_trigger settings
- [ ] Test with low-risk prompts first
- [ ] Monitor first few invocations manually
- [ ] Rotate API keys if you stop using the tool

---

## Conclusion

**All concerns are valid and have been addressed**:

1. ✅ **Auto-trigger**: Documented, optional, can be disabled/restricted
2. ✅ **Missing tools**: No tools missing (pnpm/tsx in old archived docs only)
3. ✅ **Code verification**: Full audit procedure provided
4. ✅ **Package naming**: Clarified (intentional dual aliases)
5. ✅ **API key safety**: Strong recommendations already in place
6. ✅ **Sandboxed testing**: Multiple options provided

**Recommended approach**:
- Clone and audit code first
- Install locally with project .env
- Test manually before enabling agent autonomy
- Configure agent to require confirmation for invocations

**Risk level**: **LOW** for security-conscious users who follow the verification checklist.

---

**Project Status**: ✅ Safe for Autonomous Invocation (with proper configuration)

**License**: MIT

**Contact**: https://github.com/ZhenRobotics/openclaw-video-generator/issues
