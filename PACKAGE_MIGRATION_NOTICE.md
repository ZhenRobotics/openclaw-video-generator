# Package Migration Notice

## ⚠️ Important: Package Renamed

**Old package** (deprecated): `openclaw-video` (versions 1.0.0, 1.1.0)
**New package** (current): `openclaw-video-generator` (version 1.6.2+)

---

## For Users

### If you have the old package installed:

```bash
# Uninstall old package
npm uninstall -g openclaw-video

# Install new package
npm install -g openclaw-video-generator@1.6.2
```

### Verification

```bash
# Check installed version
openclaw-video-generator --version
# Should output: 1.6.2

# Verify package name
npm list -g openclaw-video-generator
# Should show openclaw-video-generator@1.6.2
```

---

## For Contributors

### Why the rename?

The package was renamed from `openclaw-video` to `openclaw-video-generator` to:
1. Better reflect its purpose (automated video generation)
2. Avoid confusion with other openclaw packages
3. Follow npm naming conventions

### Timeline

- **2026-03-04**: `openclaw-video@1.0.0` published
- **2026-03-05**: `openclaw-video@1.1.0` published
- **2026-03-25**: Renamed to `openclaw-video-generator@1.6.2`
- **2026-03-27**: Old package deprecated on npm

### Old package status

The `openclaw-video` package on npm has been **deprecated** with a message pointing to the new package name.

---

## Technical Details

### npm Registry

**Old package**:
- Name: `openclaw-video`
- Versions: 1.0.0, 1.1.0
- Status: **Deprecated**
- Message: "Package renamed to openclaw-video-generator. Please use: npm install openclaw-video-generator"

**New package**:
- Name: `openclaw-video-generator`
- Current version: 1.6.2
- Repository: https://github.com/ZhenRobotics/openclaw-video-generator
- Registry: https://www.npmjs.com/package/openclaw-video-generator

### Repository

The GitHub repository has always been at:
- https://github.com/ZhenRobotics/openclaw-video-generator

### Documentation

All documentation now references `openclaw-video-generator`. Old release notes mentioning `openclaw-video` have been archived in `archive/old-releases/`.

---

## Questions?

If you encounter issues with the migration, please file an issue at:
https://github.com/ZhenRobotics/openclaw-video-generator/issues
