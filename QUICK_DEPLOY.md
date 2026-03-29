# 🚀 GitHub + Cloudflare 快速部署

## ✅ SSH 密钥已生成！

---

## 步骤 1️⃣：添加 SSH 密钥到 GitHub

### 复制下面的公钥：
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIcuuzXjQaRwVS3Trz8fayeoKkWG8BL2QsTdn2cdl0Gk yurikapromax@gmail.com
```

### 操作步骤：
1. **访问**: https://github.com/settings/keys
2. **点击**: "New SSH key"
3. **填写**:
   - Title: `OpenClaw Server`
   - Key type: `Authentication Key`
   - Key: [粘贴上面的公钥]
4. **点击**: "Add SSH key"

---

## 步骤 2️⃣：在 GitHub 创建仓库

### 访问：https://github.com/new

```
Repository name: go-learning
Description: Go 语言学习平台 - 90 天从入门到精通
✅ Public (公开)
❌ 不要勾选 "Initialize with README"
```

**点击 "Create repository"**

---

## 步骤 3️⃣：推送代码（自动）

复制并执行以下命令：

```bash
cd /home/admin/.openclaw/workspace/go-learning

# 设置 SSH 远程仓库
git remote add origin git@github.com:yurika/go-learning.git

# 重命名分支
git branch -M main

# 推送代码
git push -u origin main
```

**如果提示确认指纹，输入：yes**

---

## 步骤 4️⃣：Cloudflare Pages 配置

### 4.1 访问 Cloudflare
https://dash.cloudflare.com → Workers & Pages

### 4.2 创建 Pages 项目
1. **点击**: "Create application"
2. **选择**: "Pages" 标签
3. **点击**: "Connect to Git"
4. **选择仓库**: `yurika/go-learning`
5. **配置**:
   ```
   Production branch: main
   Build command: (留空)
   Build output directory: /
   ```
6. **点击**: "Save and Deploy"

---

## 步骤 5️⃣：配置自动部署（可选）

### 获取 Cloudflare Account ID
访问：https://dash.cloudflare.com
右侧边栏找到 **Account ID**，复制保存

### 获取 Cloudflare API Token
1. 访问：https://dash.cloudflare.com/profile/api-tokens
2. 点击 "Create Token"
3. 选择 "Edit Cloudflare Workers" 模板
4. 权限确认：
   - Account.Cloudflare Pages: Edit
   - Account.Account Settings: Read
5. 点击 "Continue to summary"
6. 点击 "Create Token"
7. **复制 Token**（只显示一次！）

### 在 GitHub 设置 Secrets
访问：https://github.com/yurika/go-learning/settings/secrets/actions/new

添加两个 secrets：
```
Name: CLOUDFLARE_API_TOKEN
Value: [刚才复制的 Token]

Name: CLOUDFLARE_ACCOUNT_ID
Value: [你的 Account ID]
```

---

## ✅ 验证部署

### GitHub 推送成功
访问：https://github.com/yurika/go-learning

### Cloudflare 部署成功
访问：https://dash.cloudflare.com → Workers & Pages → go-learning

部署成功后获得 URL：
```
https://go-learning.pages.dev
```

---

## 📊 自动化配置

### 每日 8 点自动更新
GitHub Actions 已配置在 `.github/workflows/deploy.yml`

**自动执行**：
1. 生成当日学习内容
2. 提交到仓库
3. 触发 Cloudflare 部署

### 手动更新
```bash
cd /home/admin/.openclaw/workspace/go-learning
git add .
git commit -m "更新内容"
git push
```

---

## 🔧 故障排查

### SSH 连接失败
```bash
# 测试 SSH 连接
ssh -T git@github.com
```

### 推送失败
```bash
# 检查远程仓库
git remote -v

# 重新设置
git remote set-url origin git@github.com:yurika/go-learning.git
```

### Cloudflare 部署失败
- 检查 GitHub Actions 日志
- 确认 Secrets 配置正确
- 查看构建输出目录

---

## 📝 快速命令

```bash
# 查看部署状态
cd /home/admin/.openclaw/workspace/go-learning
git status
git log --oneline

# 手动生成今日内容
bash generate-daily.sh

# 查看 Cron 日志
tail -f /tmp/go-learning-cron.log
```

---

**预计完成时间**: 5-10 分钟  
**难度**: ⭐⭐☆☆☆  
**费用**: 免费
