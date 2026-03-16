#!/bin/bash
# npm 发布命令脚本 - v1.2.0
# 请按顺序执行以下命令

echo "=========================================="
echo "  npm 发布流程 - openclaw-video v1.2.0"
echo "=========================================="
echo ""

# 步骤 1: 登录
echo "步骤 1/5: 登录 npm"
echo "----------------------------------------"
echo "命令: npm login"
echo ""
echo "系统会提示你输入："
echo "  - Username: (你的 npm 用户名)"
echo "  - Password: (你的 npm 密码)"
echo "  - Email: (你的邮箱)"
echo "  - OTP: (如果启用了两步验证)"
echo ""
read -p "按 Enter 键执行 npm login..."
npm login

# 检查登录状态
if [ $? -ne 0 ]; then
    echo "❌ 登录失败，请检查凭据"
    exit 1
fi

echo ""
echo "✅ 登录成功！"
echo ""

# 步骤 2: 验证登录
echo "步骤 2/5: 验证登录状态"
echo "----------------------------------------"
npm whoami
if [ $? -ne 0 ]; then
    echo "❌ 验证失败"
    exit 1
fi
echo ""

# 步骤 3: 最终检查
echo "步骤 3/5: 检查包内容"
echo "----------------------------------------"
npm pack --dry-run | tail -20
echo ""

# 步骤 4: 确认发布
echo "步骤 4/5: 准备发布"
echo "----------------------------------------"
echo "包名: openclaw-video"
echo "版本: 1.2.0"
echo "仓库: https://github.com/ZhenRobotics/openclaw-video-generator"
echo ""
read -p "确认发布? (输入 yes 继续): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ 取消发布"
    exit 1
fi

# 步骤 5: 发布
echo ""
echo "步骤 5/5: 发布到 npm"
echo "----------------------------------------"
npm publish

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "  ✅ 发布成功！"
    echo "=========================================="
    echo ""

    # 验证
    echo "验证发布..."
    sleep 3
    npm view openclaw-video version
    npm view openclaw-video | head -20

    echo ""
    echo "🎉 openclaw-video v1.2.0 已成功发布到 npm！"
    echo ""
    echo "📦 npm 包页面:"
    echo "   https://www.npmjs.com/package/openclaw-video"
    echo ""
    echo "🧪 测试安装:"
    echo "   npm install -g openclaw-video@1.2.0"
    echo ""
else
    echo ""
    echo "❌ 发布失败，请查看错误信息"
    exit 1
fi
