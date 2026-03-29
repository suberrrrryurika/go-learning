# 🚀 GitHub 部署步骤

## ⚠️ 需要手动操作

由于 GitHub 需要认证，请按以下步骤操作：

---

## 步骤 1：在 GitHub 创建仓库

1. **访问 GitHub**
   - 登录：https://github.com/yurika
   - 点击右上角 **+** → **New repository**

2. **创建仓库**
   ```
   Repository name: go-learning
   Description: Go 语言学习平台 - 90 天从入门到精通
   Visibility: Public (公开)
   ✅ Initialize this repository with a README (不要勾选！)
   ```

3. **点击 "Create repository"**

---

## 步骤 2：推送代码

### 方法 A：使用 HTTPS（推荐）

```bash
cd /home/admin/.openclaw/workspace/go-learning

# 设置远程仓库
git remote add origin https://github.com/yurika/go-learning.git

# 推送代码
git branch -M main
git push -u origin main
```

**推送时会提示输入**：
- Username: `yurika`
- Password: [GitHub Personal Access Token](https://github.com/settings/tokens)

### 方法 B：使用 SSH

```bash
# 生成 SSH key（如果没有）
ssh-keygen -t ed25519 -C "yurikapromax@gmail.com"

# 添加 SSH key 到 GitHub
# 访问：https://github.com/settings/keys
# 复制 ~/.ssh/id_ed25519.pub 的内容

# 设置远程仓库
git remote add origin git@github.com:yurika/go-learning.git

# 推送
git push -u origin main
```

---

## 步骤 3：在 Cloudflare 配置 Pages

1. **访问 Cloudflare Dashboard**
   - 登录：https://dash.cloudflare.com
   - 进入 **Workers & Pages**

2. **创建 Pages 项目**
   - 点击 **Create application**
   - 选择 **Pages** 标签
   - 点击 **Connect to Git**

3. **选择仓库**
   - 找到 `yurika/go-learning`
   - 点击它

4. **配置构建**
   ```
   Production branch: main
   Build command: (留空)
   Build output directory: /
   ```

5. **点击 "Save and Deploy"**

---

## 步骤 4：配置自动部署（GitHub Actions）

### 4.1 获取 Cloudflare API Token

1. **访问**: https://dash.cloudflare.com/profile/api-tokens
2. **点击**: Create Token
3. **选择**: Edit Cloudflare Workers 模板
4. **权限**:
   - Account.Cloudflare Pages: Edit
   - Account.Account Settings: Read
5. **点击**: Continue to summary
6. **点击**: Create Token
7. **复制 Token**（只显示一次！）

### 4.2 在 GitHub 设置 Secrets

1. **访问**: https://github.com/yurika/go-learning/settings/secrets/actions
2. **添加 Repository secrets**:
   ```
   Name: CLOUDFLARE_API_TOKEN
   Value: [刚才复制的 Token]
   
   Name: CLOUDFLARE_ACCOUNT_ID
   Value: [在 Cloudflare Dashboard 右侧边栏找到]
   ```

### 4.3 启用 GitHub Actions

1. **访问**: https://github.com/yurika/go-learning/actions
2. **点击**: "I understand my workflows, go ahead and enable them"
3. **自动部署已启用！**

---

## ✅ 验证部署

### 检查 GitHub 推送
```bash
cd /home/admin/.openclaw/workspace/go-learning
git status
git log --oneline
```

### 检查 Cloudflare 部署
访问：https://dash.cloudflare.com → Workers & Pages → go-learning

部署成功后会获得 URL：
```
https://go-learning.pages.dev
```

---

## 🔧 日常使用

### 自动更新
- **每天 8:00** GitHub Actions 自动运行
- 生成当日学习内容
- 自动提交并部署
- Cloudflare 自动重新部署

### 手动更新
```bash
# 修改内容后
cd /home/admin/.openclaw/workspace/go-learning
git add .
git commit -m "更新内容"
git push
```

Cloudflare 会自动重新部署！

---

## 📊 部署后的 URL

- **Cloudflare Pages**: `https://go-learning-xxxx.pages.dev`
- **自定义域名**: 可在 Pages 设置中配置

---

## ⚠️ 常见问题

### Q: GitHub 推送失败
**A**: 使用 Personal Access Token 代替密码
- 生成 Token: https://github.com/settings/tokens
- 权限：repo (全部勾选)

### Q: Cloudflare 部署失败
**A**: 检查：
- GitHub Actions 是否启用
- Secrets 是否正确配置
- 构建日志查看错误

### Q: 内容未更新
**A**: 
- 检查 GitHub Actions 日志
- 手动触发 workflow
- 查看 /tmp/go-learning-cron.log

---

**部署时间**: 5-10 分钟  
**状态**: ⏳ 等待推送
