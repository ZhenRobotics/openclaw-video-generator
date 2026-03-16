# 🐛 ClawHub CLI Bug 解决方案

## 问题描述

使用 `clawhub publish .` 时一直报错：
```
Error: SKILL.md required
```

即使 SKILL.md 文件明确存在于目录中。

## 根本原因

**相对路径 `.` 的解析问题**

当使用相对路径（如 `clawhub publish .`）时，CLI 的路径解析出现问题，导致无法正确找到 SKILL.md 文件。

## ✅ 解决方案

### 方案 1：使用绝对路径（推荐）

```bash
clawhub publish /absolute/path/to/skill-folder --slug video-generator --name "名称" --version 1.0.2
```

**示例**：
```bash
clawhub publish /home/justin/openclaw-video/openclaw-skill \
  --slug video-generator \
  --name "Video Generator - AI-Powered Video Creation" \
  --version 1.0.2 \
  --changelog "Your changelog"
```

### 方案 2：使用 $PWD 变量

```bash
cd /path/to/skill-folder
clawhub publish $PWD --slug video-generator --name "名称" --version 1.0.2
```

### 方案 3：从父目录发布

```bash
cd /parent/directory
clawhub publish ./skill-folder-name --slug video-generator --name "名称" --version 1.0.2
```

**注意**：使用 `./子目录` 格式，而不是单独的 `.`

## 🔍 技术细节

### 问题分析

通过深入调查 ClawHub CLI 源代码（v0.7.0），发现：

1. **文件扫描功能正常**：`listTextFiles()` 函数能正确找到 SKILL.md
2. **路径解析存在 bug**：当传入 `.` 时，路径解析出现问题
3. **绝对路径工作正常**：使用完整路径时功能正常

### 代码位置

错误发生在：
```
/node_modules/clawhub/dist/cli/commands/publish.js
```

相关代码：
```javascript
const folder = folderArg ? resolve(opts.workdir, folderArg) : null;
if (!folder) fail('Path required');

const filesOnDisk = await listTextFiles(folder);
if (!filesOnDisk.some((file) => {
  const lower = file.relPath.toLowerCase();
  return lower === 'skill.md' || lower === 'skills.md';
})) {
  fail('SKILL.md required');
}
```

问题在于 `resolve(opts.workdir, '.')` 的结果处理。

## 📊 测试结果

| 命令 | 状态 | 说明 |
|------|------|------|
| `clawhub publish .` | ❌ 失败 | SKILL.md required |
| `clawhub publish $PWD` | ✅ 成功 | 使用完整路径 |
| `clawhub publish /abs/path` | ✅ 成功 | 绝对路径 |
| `clawhub publish ./folder` | ✅ 成功 | 相对路径（但不是 `.`） |

## 🛠️ 创建发布脚本

为了避免每次手动输入绝对路径，创建一个发布脚本：

```bash
#!/bin/bash
# publish-skill.sh

SKILL_DIR="$(cd "$(dirname "$0")/openclaw-skill" && pwd)"

clawhub publish "$SKILL_DIR" \
  --slug video-generator \
  --name "Video Generator - AI-Powered Video Creation" \
  --version "$1" \
  --changelog "$2"
```

**使用**：
```bash
./publish-skill.sh 1.0.3 "Bug fixes and improvements"
```

## 📝 最佳实践

### 1. 始终使用绝对路径

```bash
# 获取绝对路径
SKILL_PATH="$(cd openclaw-skill && pwd)"

# 发布
clawhub publish "$SKILL_PATH" --slug video-generator --name "名称" --version 1.0.2
```

### 2. 创建 Makefile

```makefile
.PHONY: publish
publish:
	@clawhub publish $(shell pwd)/openclaw-skill \
		--slug video-generator \
		--name "Video Generator" \
		--version $(VERSION) \
		--changelog "$(CHANGELOG)"
```

**使用**：
```bash
make publish VERSION=1.0.2 CHANGELOG="Updates"
```

### 3. 使用 npm scripts

在 `package.json` 中：
```json
{
  "scripts": {
    "publish-skill": "clawhub publish $(pwd)/openclaw-skill --slug video-generator"
  }
}
```

**使用**：
```bash
npm run publish-skill -- --version 1.0.2 --name "名称"
```

## 🐛 已知问题

### ClawHub CLI v0.7.0

- ❌ `clawhub publish .` 不工作
- ❌ 某些相对路径解析错误
- ✅ 绝对路径工作正常
- ✅ 文件扫描功能正常

### 预期未来修复

该 bug 应该在未来版本中修复。届时相对路径 `.` 应该能正常工作。

## 📞 报告 Bug

如果您想帮助改进 ClawHub CLI，可以报告此 bug：

**GitHub Issues**：https://github.com/openclaw/clawhub/issues

**Bug 报告模板**：
```markdown
**Bug**: `clawhub publish .` fails with "SKILL.md required" even when file exists

**Environment**:
- clawhub version: 0.7.0
- Node.js: v22.22.0
- OS: Linux

**Steps to reproduce**:
1. Create folder with SKILL.md
2. cd into folder
3. Run: clawhub publish . --slug test --name "Test" --version 1.0.0

**Expected**: Publish succeeds
**Actual**: Error: SKILL.md required

**Workaround**: Use absolute path: `clawhub publish $(pwd) ...`
```

## ✅ 总结

- **问题**：相对路径 `.` 的 bug
- **解决**：使用绝对路径
- **已验证**：发布成功到 v1.0.2
- **状态**：问题已解决，skill 已更新

---

**日期**：2026-03-03
**ClawHub CLI 版本**：0.7.0
**解决方案**：使用绝对路径

**项目**：https://github.com/ZhenRobotics/openclaw-video
**ClawHub**：https://clawhub.ai/ZhenStaff/video-generator
