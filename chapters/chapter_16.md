# 第 16 章 - 项目实战

**阶段**: 第 2 阶段 - 进阶  
**预计学习时长**: 5 小时  
**代码量**: 800 行  
**案例数**: 1 个综合项目

---

## 🎯 学习目标

1. 综合运用前面所学知识
2. 掌握项目结构与组织
3. 学会设计与实现完整应用
4. 理解 RESTful API 设计
5. 掌握数据库操作与持久化

---

## 📚 项目概述

本章将实现一个完整的 **RESTful API 博客系统**，包含以下功能：

- 用户注册与登录（JWT 认证）
- 文章 CRUD 操作
- 评论系统
- 标签分类
- 数据持久化（SQLite）

---

## 💻 项目结构

```
blog-api/
├── main.go              # 程序入口
├── go.mod               # 模块定义
├── go.sum               # 依赖锁定
├── config/
│   └── config.go        # 配置管理
├── models/
│   ├── user.go          # 用户模型
│   ├── post.go          # 文章模型
│   └── comment.go       # 评论模型
├── handlers/
│   ├── auth.go          # 认证处理器
│   ├── post.go          # 文章处理器
│   └── comment.go       # 评论处理器
├── middleware/
│   └── auth.go          # JWT 中间件
├── database/
│   └── database.go      # 数据库连接
└── utils/
    └── jwt.go           # JWT 工具
```

---

## 实战案例：博客 API 系统

### 1. 项目初始化

```go
// go.mod
module blog-api

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/golang-jwt/jwt/v5 v5.0.0
    golang.org/x/crypto v0.14.0
    gorm.io/driver/sqlite v1.5.4
    gorm.io/gorm v1.25.5
)
```

```go
// main.go
package main

import (
    "log"
    "blog-api/config"
    "blog-api/database"
    "blog-api/handlers"
    "blog-api/middleware"
    "github.com/gin-gonic/gin"
)

func main() {
    // 初始化配置
    cfg := config.Load()
    
    // 初始化数据库
    db, err := database.Init(cfg.DatabaseURL)
    if err != nil {
        log.Fatalf("数据库初始化失败：%v", err)
    }
    
    // 自动迁移
    database.Migrate(db)
    
    // 创建 Gin 路由
    r := gin.Default()
    
    // 注册路由
    setupRoutes(r, db)
    
    // 启动服务器
    log.Printf("服务器启动在 :%s", cfg.Port)
    r.Run(":" + cfg.Port)
}

func setupRoutes(r *gin.Engine, db *gorm.DB) {
    // 健康检查
    r.GET("/health", func(c *gin.Context) {
        c.JSON(200, gin.H{"status": "ok"})
    })
    
    // 认证路由
    auth := r.Group("/api/auth")
    {
        auth.POST("/register", handlers.Register(db))
        auth.POST("/login", handlers.Login(db))
    }
    
    // 需要认证的路由
    protected := r.Group("/api")
    protected.Use(middleware.JWTAuth())
    {
        // 文章路由
        posts := protected.Group("/posts")
        {
            posts.GET("", handlers.ListPosts(db))
            posts.POST("", handlers.CreatePost(db))
            posts.GET("/:id", handlers.GetPost(db))
            posts.PUT("/:id", handlers.UpdatePost(db))
            posts.DELETE("/:id", handlers.DeletePost(db))
            
            // 评论路由
            posts.GET("/:id/comments", handlers.ListComments(db))
            posts.POST("/:id/comments", handlers.CreateComment(db))
        }
        
        // 用户路由
        protected.GET("/me", handlers.GetCurrentUser(db))
    }
}
```

---

### 2. 配置管理

```go
// config/config.go
package config

import (
    "os"
)

type Config struct {
    Port        string
    DatabaseURL string
    JWTSecret   string
}

func Load() *Config {
    return &Config{
        Port:        getEnv("PORT", "8080"),
        DatabaseURL: getEnv("DATABASE_URL", "blog.db"),
        JWTSecret:   getEnv("JWT_SECRET", "your-secret-key"),
    }
}

func getEnv(key, defaultValue string) string {
    if value := os.Getenv(key); value != "" {
        return value
    }
    return defaultValue
}
```

---

### 3. 数据库层

```go
// database/database.go
package database

import (
    "gorm.io/gorm"
    "gorm.io/driver/sqlite"
    "blog-api/models"
)

func Init(dbPath string) (*gorm.DB, error) {
    db, err := gorm.Open(sqlite.Open(dbPath), &gorm.Config{})
    if err != nil {
        return nil, err
    }
    return db, nil
}

func Migrate(db *gorm.DB) error {
    return db.AutoMigrate(
        &models.User{},
        &models.Post{},
        &models.Comment{},
        &models.Tag{},
    )
}
```

```go
// models/user.go
package models

import (
    "time"
    "golang.org/x/crypto/bcrypt"
)

type User struct {
    ID        uint      `gorm:"primaryKey" json:"id"`
    Username  string    `gorm:"uniqueIndex;size:50" json:"username"`
    Email     string    `gorm:"uniqueIndex;size:100" json:"email"`
    Password  string    `gorm:"size:255" json:"-"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
    Posts     []Post    `gorm:"foreignKey:AuthorID" json:"posts,omitempty"`
}

// 哈希密码
func (u *User) SetPassword(password string) error {
    hash, err := bcrypt.GenerateFromPassword([]byte(password), 12)
    if err != nil {
        return err
    }
    u.Password = string(hash)
    return nil
}

// 验证密码
func (u *User) CheckPassword(password string) bool {
    err := bcrypt.CompareHashAndPassword([]byte(u.Password), []byte(password))
    return err == nil
}
```

```go
// models/post.go
package models

import "time"

type Post struct {
    ID        uint      `gorm:"primaryKey" json:"id"`
    Title     string    `gorm:"size:200" json:"title"`
    Content   string    `gorm:"type:text" json:"content"`
    AuthorID  uint      `json:"author_id"`
    Author    User      `gorm:"foreignKey:AuthorID" json:"author,omitempty"`
    Tags      []Tag     `gorm:"many2many:post_tags;" json:"tags,omitempty"`
    Comments  []Comment `gorm:"foreignKey:PostID" json:"comments,omitempty"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}
```

```go
// models/comment.go
package models

import "time"

type Comment struct {
    ID        uint      `gorm:"primaryKey" json:"id"`
    Content   string    `gorm:"type:text" json:"content"`
    PostID    uint      `json:"post_id"`
    AuthorID  uint      `json:"author_id"`
    Author    User      `gorm:"foreignKey:AuthorID" json:"author,omitempty"`
    CreatedAt time.Time `json:"created_at"`
}
```

```go
// models/tag.go
package models

type Tag struct {
    ID   uint   `gorm:"primaryKey" json:"id"`
    Name string `gorm:"uniqueIndex;size:50" json:"name"`
}
```

---

### 4. JWT 工具

```go
// utils/jwt.go
package utils

import (
    "errors"
    "time"
    "github.com/golang-jwt/jwt/v5"
)

var (
    ErrInvalidToken = errors.New("invalid token")
    ErrExpiredToken = errors.New("token expired")
)

type Claims struct {
    UserID   uint   `json:"user_id"`
    Username string `json:"username"`
    jwt.RegisteredClaims
}

func GenerateToken(userID uint, username, secret string) (string, error) {
    claims := Claims{
        UserID:   userID,
        Username: username,
        RegisteredClaims: jwt.RegisteredClaims{
            ExpiresAt: jwt.NewNumericDate(time.Now().Add(24 * time.Hour)),
            IssuedAt:  jwt.NewNumericDate(time.Now()),
        },
    }
    
    token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
    return token.SignedString([]byte(secret))
}

func ParseToken(tokenString, secret string) (*Claims, error) {
    token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
        return []byte(secret), nil
    })
    
    if err != nil {
        return nil, ErrInvalidToken
    }
    
    claims, ok := token.Claims.(*Claims)
    if !ok || !token.Valid {
        return nil, ErrInvalidToken
    }
    
    if claims.ExpiresAt.Before(time.Now()) {
        return nil, ErrExpiredToken
    }
    
    return claims, nil
}
```

---

### 5. 中间件

```go
// middleware/auth.go
package middleware

import (
    "net/http"
    "blog-api/utils"
    "github.com/gin-gonic/gin"
    "os"
)

func JWTAuth() gin.HandlerFunc {
    return func(c *gin.Context) {
        authHeader := c.GetHeader("Authorization")
        if authHeader == "" {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "missing authorization header"})
            c.Abort()
            return
        }
        
        // 提取 Token
        tokenString := authHeader[7:] // 去掉 "Bearer "
        
        // 解析 Token
        claims, err := utils.ParseToken(tokenString, os.Getenv("JWT_SECRET"))
        if err != nil {
            c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
            c.Abort()
            return
        }
        
        // 将用户信息存入上下文
        c.Set("user_id", claims.UserID)
        c.Set("username", claims.Username)
        c.Next()
    }
}
```

---

### 6. 认证处理器

```go
// handlers/auth.go
package handlers

import (
    "net/http"
    "blog-api/models"
    "blog-api/utils"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
    "os"
)

type RegisterInput struct {
    Username string `json:"username" binding:"required"`
    Email    string `json:"email" binding:"required,email"`
    Password string `json:"password" binding:"required,min=6"`
}

type LoginInput struct {
    Email    string `json:"email" binding:"required,email"`
    Password string `json:"password" binding:"required"`
}

func Register(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var input RegisterInput
        if err := c.ShouldBindJSON(&input); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }
        
        // 检查用户是否存在
        var existingUser models.User
        if db.Where("username = ? OR email = ?", input.Username, input.Email).First(&existingUser).Error == nil {
            c.JSON(http.StatusConflict, gin.H{"error": "username or email already exists"})
            return
        }
        
        // 创建用户
        user := models.User{
            Username: input.Username,
            Email:    input.Email,
        }
        if err := user.SetPassword(input.Password); err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to hash password"})
            return
        }
        
        if err := db.Create(&user).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create user"})
            return
        }
        
        // 生成 Token
        token, err := utils.GenerateToken(user.ID, user.Username, os.Getenv("JWT_SECRET"))
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
            return
        }
        
        c.JSON(http.StatusCreated, gin.H{
            "message": "user created successfully",
            "token":   token,
            "user": gin.H{
                "id":       user.ID,
                "username": user.Username,
                "email":    user.Email,
            },
        })
    }
}

func Login(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var input LoginInput
        if err := c.ShouldBindJSON(&input); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }
        
        // 查找用户
        var user models.User
        if err := db.Where("email = ?", input.Email).First(&user).Error; err != nil {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
            return
        }
        
        // 验证密码
        if !user.CheckPassword(input.Password) {
            c.JSON(http.StatusUnauthorized, gin.H{"error": "invalid credentials"})
            return
        }
        
        // 生成 Token
        token, err := utils.GenerateToken(user.ID, user.Username, os.Getenv("JWT_SECRET"))
        if err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to generate token"})
            return
        }
        
        c.JSON(http.StatusOK, gin.H{
            "message": "login successful",
            "token":   token,
            "user": gin.H{
                "id":       user.ID,
                "username": user.Username,
                "email":    user.Email,
            },
        })
    }
}

func GetCurrentUser(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        userID, _ := c.Get("user_id")
        
        var user models.User
        if err := db.First(&user, userID).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "user not found"})
            return
        }
        
        c.JSON(http.StatusOK, gin.H{
            "id":       user.ID,
            "username": user.Username,
            "email":    user.Email,
        })
    }
}
```

---

### 7. 文章处理器

```go
// handlers/post.go
package handlers

import (
    "net/http"
    "strconv"
    "blog-api/models"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

type CreatePostInput struct {
    Title   string `json:"title" binding:"required"`
    Content string `json:"content" binding:"required"`
    Tags    []string `json:"tags"`
}

func ListPosts(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var posts []models.Post
        page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
        pageSize, _ := strconv.Atoi(c.DefaultQuery("page_size", "10"))
        
        offset := (page - 1) * pageSize
        
        db.Preload("Author").Preload("Tags").
            Offset(offset).Limit(pageSize).
            Order("created_at DESC").
            Find(&posts)
        
        c.JSON(http.StatusOK, gin.H{"posts": posts})
    }
}

func CreatePost(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var input CreatePostInput
        if err := c.ShouldBindJSON(&input); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }
        
        userID, _ := c.Get("user_id")
        
        post := models.Post{
            Title:    input.Title,
            Content:  input.Content,
            AuthorID: userID.(uint),
        }
        
        // 处理标签
        for _, tagName := range input.Tags {
            var tag models.Tag
            db.FirstOrCreate(&tag, models.Tag{Name: tagName})
            post.Tags = append(post.Tags, tag)
        }
        
        if err := db.Create(&post).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create post"})
            return
        }
        
        db.Preload("Author").Preload("Tags").First(&post, post.ID)
        c.JSON(http.StatusCreated, gin.H{"post": post})
    }
}

func GetPost(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id := c.Param("id")
        
        var post models.Post
        if err := db.Preload("Author").Preload("Tags").Preload("Comments.Author").First(&post, id).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "post not found"})
            return
        }
        
        c.JSON(http.StatusOK, gin.H{"post": post})
    }
}

func UpdatePost(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id := c.Param("id")
        userID, _ := c.Get("user_id")
        
        var post models.Post
        if err := db.First(&post, id).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "post not found"})
            return
        }
        
        // 检查作者权限
        if post.AuthorID != userID.(uint) {
            c.JSON(http.StatusForbidden, gin.H{"error": "not authorized"})
            return
        }
        
        var input CreatePostInput
        if err := c.ShouldBindJSON(&input); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }
        
        post.Title = input.Title
        post.Content = input.Content
        
        db.Save(&post)
        c.JSON(http.StatusOK, gin.H{"post": post})
    }
}

func DeletePost(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        id := c.Param("id")
        userID, _ := c.Get("user_id")
        
        var post models.Post
        if err := db.First(&post, id).Error; err != nil {
            c.JSON(http.StatusNotFound, gin.H{"error": "post not found"})
            return
        }
        
        // 检查作者权限
        if post.AuthorID != userID.(uint) {
            c.JSON(http.StatusForbidden, gin.H{"error": "not authorized"})
            return
        }
        
        db.Delete(&post)
        c.JSON(http.StatusOK, gin.H{"message": "post deleted"})
    }
}
```

---

### 8. 评论处理器

```go
// handlers/comment.go
package handlers

import (
    "net/http"
    "blog-api/models"
    "github.com/gin-gonic/gin"
    "gorm.io/gorm"
)

type CreateCommentInput struct {
    Content string `json:"content" binding:"required"`
}

func ListComments(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        postID := c.Param("id")
        
        var comments []models.Comment
        db.Where("post_id = ?", postID).
            Preload("Author").
            Order("created_at ASC").
            Find(&comments)
        
        c.JSON(http.StatusOK, gin.H{"comments": comments})
    }
}

func CreateComment(db *gorm.DB) gin.HandlerFunc {
    return func(c *gin.Context) {
        var input CreateCommentInput
        if err := c.ShouldBindJSON(&input); err != nil {
            c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
            return
        }
        
        postID := c.Param("id")
        userID, _ := c.Get("user_id")
        
        comment := models.Comment{
            Content:  input.Content,
            PostID:   parseUint(postID),
            AuthorID: userID.(uint),
        }
        
        if err := db.Create(&comment).Error; err != nil {
            c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create comment"})
            return
        }
        
        db.Preload("Author").First(&comment, comment.ID)
        c.JSON(http.StatusCreated, gin.H{"comment": comment})
    }
}

func parseUint(s string) uint {
    var result uint
    fmt.Sscan(s, &result)
    return result
}
```

---

### 9. API 使用示例

```bash
# 注册
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"alice","email":"alice@example.com","password":"123456"}'

# 登录
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"123456"}'

# 创建文章（需要 Token）
curl -X POST http://localhost:8080/api/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"title":"My First Post","content":"Hello World!","tags":["go","blog"]}'

# 获取文章列表
curl http://localhost:8080/api/posts

# 获取单篇文章
curl http://localhost:8080/api/posts/1

# 添加评论
curl -X POST http://localhost:8080/api/posts/1/comments \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"content":"Great post!"}'

# 更新文章
curl -X PUT http://localhost:8080/api/posts/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"title":"Updated Title","content":"Updated Content"}'

# 删除文章
curl -X DELETE http://localhost:8080/api/posts/1 \
  -H "Authorization: Bearer <TOKEN>"
```

---

## 📝 课后练习

1. 添加文章搜索功能
2. 实现用户个人资料编辑
3. 添加文章点赞功能
4. 实现评论回复功能
5. 添加管理员角色和权限控制

---

## ✅ 学习检查清单

- [ ] 理解项目结构与组织
- [ ] 掌握 RESTful API 设计
- [ ] 学会使用 Gin 框架
- [ ] 理解 JWT 认证流程
- [ ] 掌握 GORM 数据库操作
- [ ] 完成整个博客系统

---

**上一章**: [第 15 章 - 测试](./chapter_15.md)  
**下一章**: [第 17 章 - 性能优化](./chapter_17.md)
