# 🌩️ 部署到 Cloudflare Pages

## 方法一：GitHub 自动部署（推荐）

### 1. 推送到 GitHub

```bash
cd /home/admin/.openclaw/workspace/go-learning
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/go-learning.git
git push -u origin main
```

### 2. 在 Cloudflare Dashboard 配置

1. 登录 [Cloudflare Dashboard](https://dash.cloudflare.com)
2. 进入 **Workers & Pages**
3. 点击 **Create application** → **Pages**
4. 选择 **Connect to Git**
5. 选择 `go-learning` 仓库
6. 配置构建设置：
   - **Production branch**: `main`
   - **Build command**: 留空（静态网站）
   - **Build output directory**: `/`
7. 点击 **Save and Deploy**

### 3. 自动部署

每次 push 到 `main` 分支都会自动部署！

---

## 方法二：Wrangler CLI 部署

### 1. 安装 Wrangler

```bash
npm install -g wrangler
```

### 2. 登录 Cloudflare

```bash
wrangler login
```

### 3. 创建项目

```bash
wrangler pages project create go-learning
```

### 4. 部署

```bash
cd /home/admin/.openclaw/workspace/go-learning
wrangler pages deploy . --project-name=go-learning
```

---

## 方法三：Cloudflare R2 + Workers（高级）

### 1. 创建 R2 Bucket

```bash
wrangler r2 bucket create go-learning-site
```

### 2. 上传文件

```bash
wrangler r2 object put index.html --bucket=go-learning-site
wrangler r2 object put today.md --bucket=go-learning-site
# ... 上传其他文件
```

### 3. 配置 Workers 路由

创建 `worker.js`：
```javascript
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;
    
    // 从 R2 获取文件
    const object = await env.BUCKET.get(path || 'index.html');
    
    if (!object) {
      return new Response('Not Found', { status: 404 });
    }
    
    return new Response(object.body, {
      headers: {
        'Content-Type': object.httpMetadata?.contentType || 'text/html',
      },
    });
  }
};
```

---

## 🌐 自定义域名

### 在 Cloudflare Dashboard 配置：

1. 进入 Pages 项目
2. 点击 **Custom domains**
3. 添加你的域名
4. Cloudflare 自动配置 DNS 和 SSL

---

## ⚡ 自动化部署脚本

### 创建 `.github/workflows/deploy.yml`：

```yaml
name: Deploy to Cloudflare Pages

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 0 * * *'  # 每天午夜更新

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Generate daily content
        run: bash generate-daily.sh
      
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          command: pages deploy . --project-name=go-learning
```

---

## 🔧 环境变量

在 Cloudflare Pages Dashboard 设置：

- `TZ`: `Asia/Shanghai`
- `NODE_VERSION`: `18`

---

## 📊 部署后的 URL

部署成功后，你会获得：
- **Preview URL**: `https://go-learning-xxxx.pages.dev`
- **Custom Domain**: `https://your-domain.com`（如果配置）

---

## ✅ 验证部署

访问部署后的 URL，检查：
- ✅ 首页正常显示
- ✅ 学习进度正确
- ✅ 今日学习内容显示
- ✅ 响应式布局正常
- ✅ 所有链接可用

---

## 🚀 优化建议

### 1. 启用缓存
```
Cache-Control: public, max-age=3600
```

### 2. 压缩文件
```bash
gzip -k index.html
```

### 3. 使用 CDN
Cloudflare 自动提供全球 CDN

### 4. 启用分析
在 Cloudflare Dashboard 启用 **Web Analytics**

---

## 📝 日常更新

### 自动更新（推荐）
GitHub Actions 每天 8 点自动：
1. 生成当日学习内容
2. 提交到仓库
3. 触发 Cloudflare 自动部署

### 手动更新
```bash
# 生成今日内容
bash generate-daily.sh

# 提交并推送
git add .
git commit -m "Update daily content"
git push
```

Cloudflare Pages 会自动重新部署！

---

**部署时间**: 约 5-10 分钟  
**托管费用**: 免费（Cloudflare Pages 免费额度足够）  
**CDN**: 全球加速  
**SSL**: 自动 HTTPS
