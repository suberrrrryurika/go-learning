#!/bin/bash
# 快速部署到 Cloudflare Pages

PROJECT_DIR="/home/admin/.openclaw/workspace/go-learning"
PROJECT_NAME="go-learning"

echo "🚀 Cloudflare Pages 部署脚本"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查 Wrangler 是否安装
if ! command -v wrangler &> /dev/null; then
    echo "❌ Wrangler 未安装，正在安装..."
    npm install -g wrangler
fi

# 检查是否登录
echo "📝 检查 Cloudflare 登录状态..."
if ! wrangler whoami &> /dev/null; then
    echo "🔐 请登录 Cloudflare..."
    wrangler login
fi

# 生成今日内容
echo "📅 生成今日学习内容..."
cd "$PROJECT_DIR"
bash generate-daily.sh

# 提交到 git
echo "💾 提交更改..."
git add .
git commit -m "Deploy $(date +%Y-%m-%d %H:%M)" || echo "没有更改需要提交"

# 部署到 Cloudflare Pages
echo "☁️ 部署到 Cloudflare Pages..."
wrangler pages deploy . --project-name="$PROJECT_NAME"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 部署完成！"
echo ""
echo "🌐 访问地址:"
echo "   https://$PROJECT_NAME.pages.dev"
echo ""
echo "📝 下次部署:"
echo "   wrangler pages deploy . --project-name=$PROJECT_NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
