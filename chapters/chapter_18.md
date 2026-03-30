# 第 18 章 - 部署与运维

**阶段**: 第 3 阶段 - 高级  
**预计学习时长**: 4 小时  
**代码量**: 700 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 掌握 Go 程序编译与打包
2. 理解 Docker 容器化部署
3. 学会配置管理与环境变量
4. 掌握日志与监控
5. 理解 CI/CD 流程

---

## 📚 理论讲解

### 一、编译与打包

#### 1.1 交叉编译

```bash
# Linux AMD64
GOOS=linux GOARCH=amd64 go build -o app

# Windows AMD64
GOOS=windows GOARCH=amd64 go build -o app.exe

# macOS ARM64
GOOS=darwin GOARCH=arm64 go build -o app
```

#### 1.2 编译优化

```bash
# 去除调试信息（减小二进制大小）
go build -ldflags="-s -w" -o app

# 静态链接
CGO_ENABLED=0 go build -ldflags="-s -w" -o app
```

### 二、Docker 部署

#### 2.1 多阶段构建

```dockerfile
# 构建阶段
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o app

# 运行阶段
FROM alpine:latest
COPY --from=builder /app/app /app
CMD ["/app"]
```

---

## 💻 实战案例

### 案例 1: 编译优化

```bash
#!/bin/bash
# build.sh

# 设置版本信息
VERSION=$(git describe --tags --always)
BUILD_TIME=$(date -u '+%Y-%m-%d_%H:%M:%S')
GIT_COMMIT=$(git rev-parse --short HEAD)

# 编译参数
LDFLAGS="-s -w"
LDFLAGS+=" -X main.Version=${VERSION}"
LDFLAGS+=" -X main.BuildTime=${BUILD_TIME}"
LDFLAGS+=" -X main.GitCommit=${GIT_COMMIT}"

# 交叉编译
echo "Building for Linux AMD64..."
GOOS=linux GOARCH=amd64 go build -ldflags="$LDFLAGS" -o app-linux-amd64

echo "Building for macOS ARM64..."
GOOS=darwin GOARCH=arm64 go build -ldflags="$LDFLAGS" -o app-darwin-arm64

echo "Building for Windows AMD64..."
GOOS=windows GOARCH=amd64 go build -ldflags="$LDFLAGS" -o app-windows-amd64.exe

echo "Build complete!"
ls -lh app-*
```

```go
// main.go - 版本信息
package main

import (
    "fmt"
    "os"
)

var (
    Version   = "dev"
    BuildTime = "unknown"
    GitCommit = "unknown"
)

func main() {
    if len(os.Args) > 1 && os.Args[1] == "--version" {
        fmt.Printf("Version: %s\n", Version)
        fmt.Printf("Build Time: %s\n", BuildTime)
        fmt.Printf("Git Commit: %s\n", GitCommit)
        os.Exit(0)
    }
    
    // 主程序逻辑
    fmt.Println("Application started...")
}
```

---

### 案例 2: Docker 基础部署

```dockerfile
# Dockerfile
FROM golang:1.21-alpine AS builder

# 安装必要工具
RUN apk add --no-cache git

# 设置工作目录
WORKDIR /app

# 复制 go.mod 和 go.sum（利用缓存）
COPY go.mod go.sum ./
RUN go mod download

# 复制源代码
COPY . .

# 编译（静态链接）
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app

# 最终镜像
FROM alpine:latest

# 安装 CA 证书（用于 HTTPS 请求）
RUN apk --no-cache add ca-certificates

# 创建非 root 用户
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -D appuser

WORKDIR /app
COPY --from=builder /app/app .
COPY --from=builder /app/config.yaml .

# 切换到非 root 用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget -q --spider http://localhost:8080/health || exit 1

# 启动命令
CMD ["./app"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - PORT=8080
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
      - LOG_LEVEL=info
    depends_on:
      - db
    restart: unless-stopped
    volumes:
      - ./logs:/app/logs

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  postgres_data:
```

---

### 案例 3: 配置管理

```go
// config/config.go
package config

import (
    "encoding/json"
    "os"
)

type Config struct {
    Server   ServerConfig   `json:"server"`
    Database DatabaseConfig `json:"database"`
    Log      LogConfig      `json:"log"`
}

type ServerConfig struct {
    Port         string `json:"port" env:"PORT" default:"8080"`
    ReadTimeout  int    `json:"read_timeout" default:"30"`
    WriteTimeout int    `json:"write_timeout" default:"30"`
}

type DatabaseConfig struct {
    URL        string `json:"url" env:"DATABASE_URL"`
    MaxOpenConns int  `json:"max_open_conns" default:"25"`
    MaxIdleConns int  `json:"max_idle_conns" default:"5"`
}

type LogConfig struct {
    Level  string `json:"level" env:"LOG_LEVEL" default:"info"`
    Format string `json:"format" default:"json"`
}

// 从文件加载配置
func LoadFromFile(path string) (*Config, error) {
    data, err := os.ReadFile(path)
    if err != nil {
        return nil, err
    }
    
    var cfg Config
    if err := json.Unmarshal(data, &cfg); err != nil {
        return nil, err
    }
    
    return &cfg, nil
}

// 从环境变量加载配置
func LoadFromEnv() *Config {
    cfg := &Config{
        Server: ServerConfig{
            Port: getEnv("PORT", "8080"),
        },
        Database: DatabaseConfig{
            URL: getEnv("DATABASE_URL", ""),
        },
        Log: LogConfig{
            Level: getEnv("LOG_LEVEL", "info"),
        },
    }
    return cfg
}

func getEnv(key, defaultVal string) string {
    if val := os.Getenv(key); val != "" {
        return val
    }
    return defaultVal
}
```

```yaml
# config.yaml
server:
  port: "8080"
  read_timeout: 30
  write_timeout: 30

database:
  url: "postgres://user:pass@localhost:5432/mydb"
  max_open_conns: 25
  max_idle_conns: 5

log:
  level: "info"
  format: "json"
```

---

### 案例 4: 结构化日志

```go
// logger/logger.go
package logger

import (
    "io"
    "log/slog"
    "os"
    "path/filepath"
)

type Logger struct {
    *slog.Logger
}

func NewLogger(level, format, filename string) (*Logger, error) {
    var writer io.Writer
    var err error
    
    if filename != "" {
        // 确保目录存在
        dir := filepath.Dir(filename)
        if err := os.MkdirAll(dir, 0755); err != nil {
            return nil, err
        }
        
        // 文件输出（带轮转）
        writer, err = os.OpenFile(filename, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
        if err != nil {
            return nil, err
        }
    } else {
        writer = os.Stdout
    }
    
    // 解析日志级别
    var logLevel slog.Level
    switch level {
    case "debug":
        logLevel = slog.LevelDebug
    case "info":
        logLevel = slog.LevelInfo
    case "warn":
        logLevel = slog.LevelWarn
    case "error":
        logLevel = slog.LevelError
    default:
        logLevel = slog.LevelInfo
    }
    
    // 创建处理器
    var handler slog.Handler
    if format == "json" {
        handler = slog.NewJSONHandler(writer, &slog.HandlerOptions{
            Level: logLevel,
        })
    } else {
        handler = slog.NewTextHandler(writer, &slog.HandlerOptions{
            Level: logLevel,
        })
    }
    
    return &Logger{
        Logger: slog.New(handler),
    }, nil
}

// 辅助方法
func (l *Logger) WithError(err error) *slog.Logger {
    return l.Logger.With("error", err.Error())
}

func (l *Logger) WithRequestID(id string) *slog.Logger {
    return l.Logger.With("request_id", id)
}
```

```go
// main.go - 使用日志
package main

import (
    "blog-api/logger"
    "context"
    "github.com/google/uuid"
)

func main() {
    // 初始化日志
    log, err := logger.NewLogger("info", "json", "logs/app.log")
    if err != nil {
        panic(err)
    }
    
    // 记录启动信息
    log.Info("Application starting",
        "version", "1.0.0",
        "port", 8080,
    )
    
    // 模拟请求处理
    requestID := uuid.New().String()
    reqLog := log.WithRequestID(requestID)
    
    reqLog.Info("Handling request", "path", "/api/users")
    
    // 记录错误
    if err := someOperation(); err != nil {
        reqLog.WithError(err).Error("Operation failed")
    }
    
    reqLog.Info("Request completed", "duration_ms", 123)
}

func someOperation() error {
    return nil
}
```

---

### 案例 5: 健康检查

```go
// handlers/health.go
package handlers

import (
    "context"
    "database/sql"
    "encoding/json"
    "net/http"
    "time"
)

type HealthStatus struct {
    Status    string            `json:"status"`
    Timestamp time.Time         `json:"timestamp"`
    Checks    map[string]Check  `json:"checks"`
}

type Check struct {
    Status  string `json:"status"`
    Message string `json:"message,omitempty"`
}

func HealthHandler(db *sql.DB) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        status := HealthStatus{
            Status:    "healthy",
            Timestamp: time.Now(),
            Checks:    make(map[string]Check),
        }
        
        // 检查数据库
        if db != nil {
            ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
            defer cancel()
            
            if err := db.PingContext(ctx); err != nil {
                status.Checks["database"] = Check{
                    Status:  "unhealthy",
                    Message: err.Error(),
                }
                status.Status = "unhealthy"
            } else {
                status.Checks["database"] = Check{Status: "healthy"}
            }
        }
        
        // 设置状态码
        if status.Status == "unhealthy" {
            w.WriteHeader(http.StatusServiceUnavailable)
        }
        
        w.Header().Set("Content-Type", "application/json")
        json.NewEncoder(w).Encode(status)
    }
}
```

```go
// middleware/recovery.go
package middleware

import (
    "log/slog"
    "net/http"
    "runtime/debug"
)

func Recovery(log *slog.Logger) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            defer func() {
                if err := recover(); err != nil {
                    log.Error("Panic recovered",
                        "error", err,
                        "stack", string(debug.Stack()),
                        "path", r.URL.Path,
                    )
                    http.Error(w, "Internal Server Error", http.StatusInternalServerError)
                }
            }()
            next.ServeHTTP(w, r)
        })
    }
}
```

---

### 案例 6: 优雅关闭

```go
// graceful_shutdown.go
package main

import (
    "context"
    "log/slog"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"
)

type Server struct {
    httpServer *http.Server
    logger     *slog.Logger
}

func NewServer(addr string, handler http.Handler, log *slog.Logger) *Server {
    return &Server{
        httpServer: &http.Server{
            Addr:         addr,
            Handler:      handler,
            ReadTimeout:  30 * time.Second,
            WriteTimeout: 30 * time.Second,
            IdleTimeout:  60 * time.Second,
        },
        logger: log,
    }
}

func (s *Server) Start() error {
    s.logger.Info("Starting server", "addr", s.httpServer.Addr)
    return s.httpServer.ListenAndServe()
}

func (s *Server) Shutdown(timeout time.Duration) error {
    s.logger.Info("Shutting down server...")
    
    ctx, cancel := context.WithTimeout(context.Background(), timeout)
    defer cancel()
    
    if err := s.httpServer.Shutdown(ctx); err != nil {
        s.logger.Error("Server shutdown error", "error", err)
        return err
    }
    
    s.logger.Info("Server stopped")
    return nil
}

func main() {
    log := slog.New(slog.NewJSONHandler(os.Stdout, nil))
    
    // 创建服务器
    mux := http.NewServeMux()
    mux.HandleFunc("/health", healthHandler)
    mux.HandleFunc("/", mainHandler)
    
    server := NewServer(":8080", mux, log)
    
    // 启动服务器（在 Goroutine 中）
    go func() {
        if err := server.Start(); err != http.ErrServerClosed {
            log.Error("Server error", "error", err)
            os.Exit(1)
        }
    }()
    
    // 等待中断信号
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit
    
    // 优雅关闭
    if err := server.Shutdown(30 * time.Second); err != nil {
        log.Error("Graceful shutdown failed", "error", err)
        os.Exit(1)
    }
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("OK"))
}

func mainHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("Hello, World!"))
}
```

---

### 案例 7: Prometheus 监控

```go
// metrics/metrics.go
package metrics

import (
    "github.com/prometheus/client_golang/prometheus"
    "github.com/prometheus/client_golang/prometheus/promhttp"
    "net/http"
)

var (
    // HTTP 请求指标
    HTTPRequestsTotal = prometheus.NewCounterVec(
        prometheus.CounterOpts{
            Name: "http_requests_total",
            Help: "Total number of HTTP requests",
        },
        []string{"method", "path", "status"},
    )
    
    // HTTP 请求延迟
    HTTPRequestDuration = prometheus.NewHistogramVec(
        prometheus.HistogramOpts{
            Name:    "http_request_duration_seconds",
            Help:    "HTTP request duration in seconds",
            Buckets: prometheus.DefBuckets,
        },
        []string{"method", "path"},
    )
    
    // 活跃连接数
    ActiveConnections = prometheus.NewGauge(
        prometheus.GaugeOpts{
            Name: "active_connections",
            Help: "Number of active connections",
        },
    )
)

func Init() {
    // 注册指标
    prometheus.MustRegister(HTTPRequestsTotal)
    prometheus.MustRegister(HTTPRequestDuration)
    prometheus.MustRegister(ActiveConnections)
}

func Handler() http.Handler {
    return promhttp.Handler()
}
```

```go
// middleware/metrics.go
package middleware

import (
    "blog-api/metrics"
    "net/http"
    "strconv"
    "time"
)

type responseWriter struct {
    http.ResponseWriter
    statusCode int
}

func (rw *responseWriter) WriteHeader(code int) {
    rw.statusCode = code
    rw.ResponseWriter.WriteHeader(code)
}

func Metrics(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        start := time.Now()
        
        rw := &responseWriter{
            ResponseWriter: w,
            statusCode:     http.StatusOK,
        }
        
        next.ServeHTTP(rw, r)
        
        duration := time.Since(start).Seconds()
        
        // 记录指标
        metrics.HTTPRequestsTotal.WithLabelValues(
            r.Method,
            r.URL.Path,
            strconv.Itoa(rw.statusCode),
        ).Inc()
        
        metrics.HTTPRequestDuration.WithLabelValues(
            r.Method,
            r.URL.Path,
        ).Observe(duration)
    })
}
```

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'app'
    static_configs:
      - targets: ['localhost:8080']
    metrics_path: /metrics
```

---

### 案例 8: CI/CD 配置

```yaml
# .github/workflows/ci.yml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'
      
      - name: Cache Go modules
        uses: actions/cache@v3
        with:
          path: ~/go/pkg/mod
          key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
      
      - name: Install dependencies
        run: go mod download
      
      - name: Run tests
        run: go test -v -cover ./...
      
      - name: Build
        run: go build -v ./...

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/app:latest
            ${{ secrets.DOCKER_USERNAME }}/app:${{ github.sha }}
          cache-from: type=registry,ref=${{ secrets.DOCKER_USERNAME }}/app:buildcache
          cache-to: type=registry,ref=${{ secrets.DOCKER_USERNAME }}/app:buildcache,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # 添加实际部署命令
```

---

### 案例 9: 完整部署脚本

```bash
#!/bin/bash
# deploy.sh

set -e

# 配置
APP_NAME="blog-api"
VERSION=$(git describe --tags --always)
DOCKER_USER="your-docker-username"
REGISTRY="docker.io"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查依赖
check_dependencies() {
    log_info "Checking dependencies..."
    
    for cmd in docker git go; do
        if ! command -v $cmd &> /dev/null; then
            log_error "$cmd is not installed"
            exit 1
        fi
    done
    
    log_info "All dependencies are installed"
}

# 运行测试
run_tests() {
    log_info "Running tests..."
    go test -v -cover ./...
    log_info "Tests passed"
}

# 构建二进制
build_binary() {
    log_info "Building binary..."
    
    LDFLAGS="-s -w"
    LDFLAGS+=" -X main.Version=${VERSION}"
    
    CGO_ENABLED=0 GOOS=linux go build \
        -ldflags="$LDFLAGS" \
        -o bin/${APP_NAME}
    
    log_info "Binary built: bin/${APP_NAME}"
}

# 构建 Docker 镜像
build_image() {
    log_info "Building Docker image..."
    
    docker build \
        -t ${REGISTRY}/${DOCKER_USER}/${APP_NAME}:${VERSION} \
        -t ${REGISTRY}/${DOCKER_USER}/${APP_NAME}:latest \
        .
    
    log_info "Docker image built"
}

# 推送镜像
push_image() {
    log_info "Pushing Docker image..."
    
    docker push ${REGISTRY}/${DOCKER_USER}/${APP_NAME}:${VERSION}
    docker push ${REGISTRY}/${DOCKER_USER}/${APP_NAME}:latest
    
    log_info "Docker image pushed"
}

# 部署到服务器
deploy() {
    log_info "Deploying to server..."
    
    # 这里可以是 kubectl、docker-compose 或其他部署命令
    # 示例：docker-compose
    # docker-compose pull
    # docker-compose up -d
    
    log_info "Deployment complete"
}

# 主流程
main() {
    log_info "Starting deployment pipeline for ${APP_NAME} v${VERSION}"
    
    check_dependencies
    run_tests
    build_binary
    build_image
    push_image
    deploy
    
    log_info "Deployment pipeline completed successfully!"
}

main "$@"
```

```yaml
# kubernetes/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blog-api
  labels:
    app: blog-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: blog-api
  template:
    metadata:
      labels:
        app: blog-api
    spec:
      containers:
        - name: blog-api
          image: your-docker-username/blog-api:latest
          ports:
            - containerPort: 8080
          env:
            - name: PORT
              value: "8080"
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: db-secret
                  key: url
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "256Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: blog-api
spec:
  selector:
    app: blog-api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
```

---

## 📝 部署检查清单

### 编译打包
- [ ] 交叉编译目标平台
- [ ] 去除调试信息（-ldflags="-s -w"）
- [ ] 嵌入版本信息
- [ ] 静态链接（CGO_ENABLED=0）

### Docker 部署
- [ ] 多阶段构建
- [ ] 非 root 用户运行
- [ ] 健康检查配置
- [ ] 最小化基础镜像（alpine）

### 配置管理
- [ ] 环境变量优先
- [ ] 配置文件作为默认值
- [ ] 敏感信息使用 Secret
- [ ] 不同环境不同配置

### 日志监控
- [ ] 结构化日志（JSON）
- [ ] 日志级别可配置
- [ ] Prometheus 指标
- [ ] 分布式追踪（可选）

### CI/CD
- [ ] 自动化测试
- [ ] 自动化构建
- [ ] 自动化部署
- [ ] 回滚机制

---

## ✅ 学习检查清单

- [ ] 掌握 Go 程序编译与打包
- [ ] 理解 Docker 容器化部署
- [ ] 学会配置管理与环境变量
- [ ] 掌握日志与监控
- [ ] 理解 CI/CD 流程
- [ ] 完成所有 9 个案例

---

**上一章**: [第 17 章 - 性能优化](./chapter_17.md)  
**下一章**: [第 19 章 - 微服务架构](./chapter_19.md)
