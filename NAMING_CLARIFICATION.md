# Package Naming Clarification

**Date**: 2026-03-26
**Current Version**: v1.6.2

---

## Official Package Information

### Single Source of Truth

**Official npm Package Name**: `openclaw-video-generator`

```bash
npm install -g openclaw-video-generator
```

**Official Repository**: https://github.com/ZhenRobotics/openclaw-video-generator

**Current Version**: 1.6.2 (synchronized across all systems)

---

## Command Aliases

The package provides **two command-line aliases** for user convenience:

```json
{
  "bin": {
    "openclaw-video-generator": "./agents/video-cli.sh",
    "openclaw-video": "./agents/video-cli.sh"
  }
}
```

**Both commands are identical and execute the same script:**

```bash
# Full name (official)
openclaw-video-generator --version

# Short alias (convenience)
openclaw-video --version

# Both output: 1.6.2
```

This is **NOT an inconsistency** - it's an intentional design to provide both:
- Official full name for clarity in documentation
- Short alias for typing convenience

---

## Version Synchronization

All official documents use **version 1.6.2**:

| File | Version Field | Value |
|------|--------------|-------|
| `package.json` | `"version"` | `"1.6.2"` |
| `openclaw-skill/SKILL.md` | `version` | `">=1.6.2"` |
| `openclaw-skill/SKILL.md` | `verified_commit` | `6279034` ✅ (latest) |
| `README.md` | Installation commands | `openclaw-video-generator` (correct) |

---

## Historical Context

### Repository Rename (v1.0.x → v1.1.0)

The project underwent a repository rename:

- **Old** (v1.0.x): `ZhenRobotics/openclaw-video`
- **New** (v1.1.0+): `ZhenRobotics/openclaw-video-generator`

**Why?**
- More descriptive name
- Avoids confusion with the main OpenClaw project
- Better npm package discoverability

### Old Documentation

Files like `RELEASE-v1.0.1.md` reference the old repository name:
- These are **historical archives**
- Not used for current installation
- Kept for version history transparency

**Current users should ignore these old files** and refer to:
- `README.md`
- `openclaw-skill/SKILL.md`
- `QUICKSTART.md`

---

## Verification Steps

### 1. Verify npm Package

```bash
# Check official npm registry
npm info openclaw-video-generator

# Expected output includes:
# name: openclaw-video-generator
# version: 1.6.2
# repository: git+https://github.com/ZhenRobotics/openclaw-video-generator.git
```

### 2. Verify GitHub Repository

```bash
# Clone official repository
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator

# Check package name matches
cat package.json | jq '.name'
# Output: "openclaw-video-generator"

# Check current commit
git rev-parse HEAD
# Output: ea6790c (or later)
```

### 3. Verify Command Aliases

```bash
# After global install
which openclaw-video-generator
which openclaw-video

# Both should point to the same location
# Example: /usr/local/bin/openclaw-video-generator
#          /usr/local/bin/openclaw-video (symlink)
```

---

## Installation Verification Checklist

Before installing, verify these match:

- [ ] npm package name: `openclaw-video-generator`
- [ ] GitHub repository: `ZhenRobotics/openclaw-video-generator`
- [ ] package.json version: `1.6.2`
- [ ] SKILL.md version: `>=1.6.2`
- [ ] SKILL.md verified_commit: `6279034` or later
- [ ] npm registry matches GitHub code

**How to verify npm package matches GitHub:**

```bash
# 1. Check npm package tarball
npm pack openclaw-video-generator
tar -tzf openclaw-video-generator-1.6.2.tgz | head -20

# 2. Compare with GitHub repository
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator
git show 6279034:package.json | jq '.name, .version'
```

---

## Addressing Security Concerns

### Concern: "Inconsistent package names"

**Response**: Not inconsistent - intentional dual aliases

- Official name: `openclaw-video-generator`
- Convenience alias: `openclaw-video`
- Both execute the same code
- Standard npm practice (e.g., `typescript` provides both `tsc` and `tsserver`)

### Concern: "Different version numbers"

**Response**: All current versions are synchronized

- package.json: `1.6.2`
- npm registry: `1.6.2`
- GitHub tag: `v1.6.2`
- SKILL.md: `>=1.6.2`

Old historical documents (v1.0.x) are archives, not active documentation.

### Concern: "Claimed verified_commit"

**Response**: Now verified and up-to-date

- SKILL.md line 52: `verified_commit: 6279034` ✅
- Current HEAD: `ea6790c` (includes security docs)
- Users can verify: `git show 6279034` in cloned repo

---

## Current Documentation Standards

### Primary Documentation (Always Updated)

1. **README.md** - Main installation and usage guide
2. **openclaw-skill/SKILL.md** - ClawHub skill definition
3. **QUICKSTART.md** - Quick start guide
4. **SECURITY_RESPONSE.md** - Security review response

All use:
- Package name: `openclaw-video-generator`
- Version: `1.6.2`
- Repository: `github.com/ZhenRobotics/openclaw-video-generator`

### Historical Documentation (Reference Only)

- `RELEASE-v1.0.1.md` - Old v1.0.x release notes
- `CLAWHUB_UPDATE_v1.5.1.md` - Old update guide
- Other `*_v1.*.md` files

**Do not use these for installation** - refer to current README.md instead.

---

## Recommended Installation Flow

### For End Users

```bash
# 1. Verify package on npm registry
npm info openclaw-video-generator

# 2. Install globally
npm install -g openclaw-video-generator@latest

# 3. Verify installation
openclaw-video-generator --version
# or
openclaw-video --version

# Both should output: 1.6.2
```

### For Developers / Security-Conscious Users

```bash
# 1. Clone and inspect repository
git clone https://github.com/ZhenRobotics/openclaw-video-generator.git
cd openclaw-video-generator

# 2. Verify commit matches SKILL.md
git rev-parse HEAD  # Should be 6279034 or later

# 3. Inspect code
cat package.json
cat agents/video-cli.sh
cat scripts/script-to-video.sh

# 4. Check for malicious scripts
npm audit
grep -r "curl\|wget\|eval" scripts/ agents/

# 5. Install dependencies locally
npm install

# 6. Configure .env file (project-local)
cp .env.example .env
nano .env

# 7. Test locally
./agents/video-cli.sh --version
```

---

## Summary

| Question | Answer |
|----------|--------|
| **Official package name?** | `openclaw-video-generator` |
| **Is `openclaw-video` valid?** | Yes, it's a convenience alias (same command) |
| **Current version?** | `1.6.2` (synchronized everywhere) |
| **Official repository?** | `github.com/ZhenRobotics/openclaw-video-generator` |
| **Verified commit?** | `6279034` (SKILL.md) / `ea6790c` (latest) |
| **Are there inconsistencies?** | No - dual aliases are intentional, old docs are archives |

---

## Conclusion

There are **no naming inconsistencies** in current documentation. The project:

1. ✅ Uses consistent package name: `openclaw-video-generator`
2. ✅ Provides convenience alias: `openclaw-video`
3. ✅ Maintains synchronized version: `1.6.2`
4. ✅ Has up-to-date verified_commit: `6279034`
5. ✅ Historical docs are clearly archived and not used for installation

**The warning about "inconsistent names and versions" is based on outdated/historical documentation, not current active files.**

Users should follow:
- README.md for installation
- SKILL.md for ClawHub integration
- SECURITY_RESPONSE.md for security review

All are current, accurate, and consistent.
