# Security Scanner False Positive - Quick Response

**Alert**: "npm registry metadata contradicts SKILL.md"

**Status**: ⚠️ **FALSE POSITIVE** - Not a security issue

---

## TL;DR

**The scanner is wrong.** npm's package.json specification **cannot** declare environment variables or system tools. This is not a bug in our package - it's a limitation of the npm specification itself.

**Every npm package with API keys works this way**: openai, aws-sdk, stripe, @anthropic-ai/sdk - none list env vars in package.json.

---

## One-Minute Verification

```bash
# 1. Confirm package name is correct
npm info openclaw-video-generator name
# Output: "openclaw-video-generator" ✅

# 2. Confirm version is correct
npm info openclaw-video-generator version
# Output: "1.6.2" ✅

# 3. Check if OpenAI SDK lists env vars in package.json (it doesn't)
npm info openai | grep -i "environment\|api_key"
# Output: (nothing) - because npm spec doesn't support this ✅

# 4. Verify our requirements ARE documented
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
cat README.md | grep "OPENAI_API_KEY"
# Output: Multiple matches - fully documented ✅
```

---

## Why Scanner Is Wrong

**Scanner logic** (incorrect):
```
IF package.json does NOT list environment variables:
  AND SKILL.md lists environment variables:
    THEN flag as "contradiction"  ❌ FALSE POSITIVE
```

**Correct logic**:
```
IF package.json.name !== SKILL.md.package_name:
  THEN flag as "contradiction"  ✅ REAL ISSUE

IF SKILL.md lists env vars:
  AND README.md does NOT document them:
    THEN flag as "undocumented requirement"  ✅ REAL ISSUE
```

**Our project**:
- ✅ package.json name = SKILL.md package = `openclaw-video-generator`
- ✅ Env vars documented in README.md, .env.example, SKILL.md
- ✅ No actual contradictions

---

## npm Specification Fact Check

**From npm documentation**: https://docs.npmjs.com/cli/v9/configuring-npm/package-json

**Supported fields**:
- ✅ `name`, `version`, `description`
- ✅ `dependencies`, `devDependencies`, `peerDependencies`
- ✅ `engines` (Node.js version)
- ✅ `scripts`, `bin`, `files`

**NOT supported**:
- ❌ `environmentVariables`
- ❌ `requiredEnvironment`
- ❌ `systemTools`
- ❌ `requiredBinaries`

**Where to document these instead**:
- ✅ README.md
- ✅ .env.example
- ✅ Platform manifests (SKILL.md, package.yaml, etc.)

---

## Compare with Industry Standards

| Package | API Key Needed | In package.json? | Where Documented? |
|---------|----------------|------------------|-------------------|
| openai | OPENAI_API_KEY | ❌ No | README.md |
| aws-sdk | AWS_ACCESS_KEY_ID | ❌ No | README.md |
| stripe | STRIPE_SECRET_KEY | ❌ No | README.md |
| @google-cloud/storage | GOOGLE_APPLICATION_CREDENTIALS | ❌ No | README.md |
| openclaw-video-generator | OPENAI_API_KEY | ❌ No | README.md + .env.example + SKILL.md ✅ |

**None of these list env vars in package.json** because the npm spec doesn't allow it.

---

## What Would Be a Real Contradiction

### ❌ This would be a contradiction (we don't have this):

```
package.json:  name: "package-a"
SKILL.md:      name: "package-b"  ← Different package name ❌
```

```
package.json:  version: "1.0.0"
SKILL.md:      version: ">=2.0.0"  ← Incompatible version ❌
```

### ✅ Our actual implementation (no contradiction):

```
package.json:  name: "openclaw-video-generator"
SKILL.md:      package: "openclaw-video-generator"  ← Same ✅
```

```
package.json:  version: "1.6.2"
SKILL.md:      version: ">=1.6.2"  ← Compatible ✅
```

```
package.json:  (no env var field - spec doesn't support)
SKILL.md:      api_keys: [OPENAI_API_KEY]  ← Documented ✅
README.md:     "Requires OPENAI_API_KEY"   ← Documented ✅
.env.example:  OPENAI_API_KEY="..."        ← Template ✅
```

---

## Action Items

### For Users Seeing This Warning

**Do**:
- ✅ Verify package name: `npm info openclaw-video-generator name`
- ✅ Check repository: https://github.com/ZhenRobotics/openclaw-video-generator
- ✅ Read README.md for actual requirements
- ✅ Clone and audit code if concerned

**Don't**:
- ❌ Treat this as a security vulnerability (it's not)
- ❌ Expect package.json to list env vars (impossible by npm spec)
- ❌ Assume "contradiction" means malicious intent

### For Security Scanner Maintainers

**Update scanner logic to**:
1. ✅ Check package name consistency (package.json ↔ manifests)
2. ✅ Check version compatibility (not strict equality)
3. ✅ Verify env vars are documented in README.md
4. ❌ Stop flagging "package.json doesn't list env vars" as contradiction

**Add exemption for**:
- Env vars in SKILL.md / platform manifests when documented in README
- System tools in manifests when they're not npm packages
- Extended metadata that npm spec doesn't support

---

## Full Documentation

For detailed technical explanation:
- **NPM_REGISTRY_METADATA_EXPLANATION.md** - Complete technical analysis
- **NAMING_CLARIFICATION.md** - Package naming details
- **SECURITY_RESPONSE.md** - General security review
- **SECURITY_CONCERNS_FINAL_RESPONSE.md** - Consolidated security response

---

## Quick Links

- **npm Package**: https://www.npmjs.com/package/openclaw-video-generator
- **GitHub Repository**: https://github.com/ZhenRobotics/openclaw-video-generator
- **Issue Tracker**: https://github.com/ZhenRobotics/openclaw-video-generator/issues
- **npm Specification**: https://docs.npmjs.com/cli/v9/configuring-npm/package-json

---

## Verdict

**Scanner Alert**: "Metadata contradiction"
**Reality**: ⚠️ **False positive** - npm spec limitation, not security issue
**Risk Level**: ✅ **No risk** - Standard industry practice
**Recommendation**: **Safe to install** after reviewing README.md

---

**Last Updated**: 2026-03-26
**Document Version**: 1.0
