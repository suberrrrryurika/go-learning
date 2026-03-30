# 第 20 章 - 最佳实践

**阶段**: 第 1 阶段 - 基础完结  
**预计学习时长**: 4 小时  
**代码量**: 700 行  
**案例数**: 10 个

---

## 🎯 学习目标

1. 掌握 Go 代码规范与风格
2. 理解错误处理最佳实践
3. 学会并发安全编程
4. 掌握项目组织与结构
5. 理解常见陷阱与避免方法

---

## 📚 Go 代码规范

### 一、命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 包名 | 小写、简短、无下划线 | `encoding/json` |
| 变量 | 驼峰、首字母小写 | `userName`, `count` |
| 常量 | 驼峰、首字母大写 | `MaxRetries` |
| 函数 | 驼峰、首字母大写（导出） | `CalculateSum` |
| 类型 | 驼峰、首字母大写 | `UserProfile` |
| 接口 | 小写、-er 后缀 | `Reader`, `Writer` |

### 二、注释规范

```go
// 包注释（文件顶部）
// Package user provides user management functionality.
package user

// 函数注释（导出函数必须有）
// GetUser retrieves a user by ID.
// Returns an error if the user is not found.
func GetUser(id int) (*User, error)

// 类型注释
// User represents a system user.
type User struct {
    // ID is the unique identifier.
    ID int
    // Name is the user's display name.
    Name string
}
```

---

## 💻 实战案例

### 案例 1: 错误处理最佳实践

```go
// errors/errors.go
package errors

import (
    "fmt"
    "runtime"
)

// Error 带堆栈的错误
type Error struct {
    Code    string
    Message string
    Cause   error
    File    string
    Line    int
}

func (e *Error) Error() string {
    if e.Cause != nil {
        return fmt.Sprintf("%s: %v", e.Message, e.Cause)
    }
    return e.Message
}

func (e *Error) Unwrap() error {
    return e.Cause
}

// New 创建新错误
func New(code, message string) *Error {
    _, file, line, _ := runtime.Caller(1)
    return &Error{
        Code:    code,
        Message: message,
        File:    file,
        Line:    line,
    }
}

// Wrap 包装错误
func Wrap(err error, message string) *Error {
    _, file, line, _ := runtime.Caller(1)
    return &Error{
        Code:    "INTERNAL",
        Message: message,
        Cause:   err,
        File:    file,
        Line:    line,
    }
}

// Is 判断错误类型
func Is(err error, code string) bool {
    if e, ok := err.(*Error); ok {
        return e.Code == code
    }
    return false
}
```

```go
// user_service.go
package service

import (
    "blog-api/errors"
    "database/sql"
)

var (
    ErrUserNotFound     = errors.New("USER_NOT_FOUND", "user not found")
    ErrUserAlreadyExists = errors.New("USER_EXISTS", "user already exists")
    ErrInvalidEmail     = errors.New("INVALID_EMAIL", "invalid email address")
)

func GetUser(id int) (*User, error) {
    user, err := db.GetUserByID(id)
    if err == sql.ErrNoRows {
        return nil, ErrUserNotFound
    }
    if err != nil {
        return nil, errors.Wrap(err, "failed to get user")
    }
    return user, nil
}

// 错误处理模式
func ProcessUser(id int) error {
    user, err := GetUser(id)
    if err != nil {
        if errors.Is(err, "USER_NOT_FOUND") {
            // 特定错误处理
            return handleNotFound(id)
        }
        // 其他错误向上传播
        return err
    }
    
    // 正常处理
    return doSomething(user)
}
```

---

### 案例 2: 并发安全模式

```go
// safe/safe_map.go
package safe

import "sync"

// Map 线程安全的 Map
type Map[K comparable, V any] struct {
    mu   sync.RWMutex
    data map[K]V
}

func NewMap[K comparable, V any]() *Map[K, V] {
    return &Map[K, V]{
        data: make(map[K]V),
    }
}

func (m *Map[K, V]) Get(key K) (V, bool) {
    m.mu.RLock()
    defer m.mu.RUnlock()
    val, ok := m.data[key]
    return val, ok
}

func (m *Map[K, V]) Set(key K, val V) {
    m.mu.Lock()
    defer m.mu.Unlock()
    m.data[key] = val
}

func (m *Map[K, V]) Delete(key K) {
    m.mu.Lock()
    defer m.mu.Unlock()
    delete(m.data, key)
}

func (m *Map[K, V]) Range(f func(key K, val V) bool) {
    m.mu.RLock()
    defer m.mu.RUnlock()
    for k, v := range m.data {
        if !f(k, v) {
            return
        }
    }
}
```

```go
// safe/safe_counter.go
package safe

import (
    "sync"
    "sync/atomic"
)

// Counter 原子计数器
type Counter struct {
    value int64
}

func (c *Counter) Inc() int64 {
    return atomic.AddInt64(&c.value, 1)
}

func (c *Counter) Dec() int64 {
    return atomic.AddInt64(&c.value, -1)
}

func (c *Counter) Get() int64 {
    return atomic.LoadInt64(&c.value)
}

func (c *Counter) Set(val int64) {
    atomic.StoreInt64(&c.value, val)
}

// MutexCounter 互斥锁计数器（适合复杂操作）
type MutexCounter struct {
    mu    sync.Mutex
    value int64
}

func (c *MutexCounter) Add(delta int64) int64 {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value += delta
    return c.value
}

func (c *MutexCounter) GetAndReset() int64 {
    c.mu.Lock()
    defer c.mu.Unlock()
    val := c.value
    c.value = 0
    return val
}
```

---

### 案例 3: 上下文使用模式

```go
// context/context_patterns.go
package contextx

import (
    "context"
    "time"
)

// WithRetry 带重试的上下文
func WithRetry(ctx context.Context, maxRetries int, delay time.Duration) context.Context {
    return &retryContext{
        Context:    ctx,
        maxRetries: maxRetries,
        delay:      delay,
    }
}

type retryContext struct {
    context.Context
    maxRetries int
    delay      time.Duration
}

// DoWithRetry 执行带重试的操作
func DoWithRetry(ctx context.Context, fn func() error) error {
    var lastErr error
    for i := 0; i < 3; i++ {
        select {
        case <-ctx.Done():
            return ctx.Err()
        default:
            if err := fn(); err != nil {
                lastErr = err
                time.Sleep(100 * time.Millisecond)
                continue
            }
            return nil
        }
    }
    return lastErr
}

// WithTimeout 组合超时
func WithTimeout(parent context.Context, timeout time.Duration) (context.Context, context.CancelFunc) {
    return context.WithTimeout(parent, timeout)
}

// 取消传播
func WithCancelChain(parent context.Context) (context.Context, context.CancelFunc) {
    return context.WithCancel(parent)
}
```

```go
// 使用示例
func ProcessWithTimeout(ctx context.Context, data []byte) error {
    // 创建带超时的上下文
    ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
    defer cancel()
    
    // 创建结果通道
    resultCh := make(chan error, 1)
    
    go func() {
        resultCh <- doWork(data)
    }()
    
    select {
    case err := <-resultCh:
        return err
    case <-ctx.Done():
        return ctx.Err()
    }
}
```

---

### 案例 4: 接口设计模式

```go
// interface/interface_patterns.go
package interfacep

import "io"

// 小接口原则
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}

// 组合接口
type ReadWriter interface {
    Reader
    Writer
}

type ReadWriteCloser interface {
    Reader
    Writer
    Closer
}

// 接收接口，返回结构体
func NewProcessor(r io.Reader) *Processor {
    return &Processor{reader: r}
}

type Processor struct {
    reader io.Reader
}

func (p *Processor) Process() error {
    // 处理逻辑
    return nil
}

// 函数返回接口（隐藏实现）
func NewCache() Cache {
    return &memoryCache{data: make(map[string]interface{})}
}

type Cache interface {
    Get(key string) (interface{}, bool)
    Set(key string, val interface{})
    Delete(key string)
}

type memoryCache struct {
    data map[string]interface{}
}

func (c *memoryCache) Get(key string) (interface{}, bool) {
    val, ok := c.data[key]
    return val, ok
}

func (c *memoryCache) Set(key string, val interface{}) {
    c.data[key] = val
}

func (c *memoryCache) Delete(key string) {
    delete(c.data, key)
}
```

---

### 案例 5: 函数选项模式

```go
// options/options.go
package options

import (
    "time"
)

// Config 配置结构
type Config struct {
    Host     string
    Port     int
    Timeout  time.Duration
    Retries  int
    Debug    bool
}

// Option 函数选项类型
type Option func(*Config)

// WithHost 设置主机
func WithHost(host string) Option {
    return func(c *Config) {
        c.Host = host
    }
}

// WithPort 设置端口
func WithPort(port int) Option {
    return func(c *Config) {
        c.Port = port
    }
}

// WithTimeout 设置超时
func WithTimeout(timeout time.Duration) Option {
    return func(c *Config) {
        c.Timeout = timeout
    }
}

// WithRetries 设置重试次数
func WithRetries(retries int) Option {
    return func(c *Config) {
        c.Retries = retries
    }
}

// WithDebug 启用调试
func WithDebug(debug bool) Option {
    return func(c *Config) {
        c.Debug = debug
    }
}

// 默认配置
func DefaultConfig() *Config {
    return &Config{
        Host:    "localhost",
        Port:    8080,
        Timeout: 30 * time.Second,
        Retries: 3,
        Debug:   false,
    }
}

// NewClient 使用选项创建客户端
func NewClient(opts ...Option) (*Client, error) {
    cfg := DefaultConfig()
    for _, opt := range opts {
        opt(cfg)
    }
    
    return &Client{config: cfg}, nil
}

type Client struct {
    config *Config
}

// 使用示例
// client, err := NewClient(
//     WithHost("api.example.com"),
//     WithPort(443),
//     WithTimeout(60 * time.Second),
//     WithDebug(true),
// )
```

---

### 案例 6: 依赖注入模式

```go
// di/di.go
package di

import (
    "blog-api/database"
    "blog-api/handlers"
    "blog-api/service"
)

// Container 依赖容器
type Container struct {
    db      *database.DB
    userService *service.UserService
    postService *service.PostService
    userHandler *handlers.UserHandler
    postHandler *handlers.PostHandler
}

// NewContainer 创建容器
func NewContainer(dbURL string) (*Container, error) {
    // 创建数据库连接
    db, err := database.New(dbURL)
    if err != nil {
        return nil, err
    }
    
    return &Container{
        db: db,
    }, nil
}

// UserService 获取用户服务
func (c *Container) UserService() *service.UserService {
    if c.userService == nil {
        c.userService = service.NewUserService(c.db)
    }
    return c.userService
}

// PostService 获取文章服务
func (c *Container) PostService() *service.PostService {
    if c.postService == nil {
        c.postService = service.NewPostService(c.db)
    }
    return c.postService
}

// UserHandler 获取用户处理器
func (c *Container) UserHandler() *handlers.UserHandler {
    if c.userHandler == nil {
        c.userHandler = handlers.NewUserHandler(c.UserService())
    }
    return c.userHandler
}

// Close 关闭容器
func (c *Container) Close() error {
    return c.db.Close()
}
```

```go
// main.go
package main

import (
    "blog-api/di"
    "net/http"
)

func main() {
    // 创建依赖容器
    container, err := di.NewContainer("postgres://localhost/mydb")
    if err != nil {
        panic(err)
    }
    defer container.Close()
    
    // 设置路由
    mux := http.NewServeMux()
    
    // 从容器获取处理器
    userHandler := container.UserHandler()
    postHandler := container.PostHandler()
    
    mux.HandleFunc("/users", userHandler.List)
    mux.HandleFunc("/posts", postHandler.List)
    
    http.ListenAndServe(":8080", mux)
}
```

---

### 案例 7: 测试最佳实践

```go
// user_test.go
package user

import (
    "testing"
    "time"
)

// 表格驱动测试
func TestValidateEmail(t *testing.T) {
    tests := []struct {
        name  string
        email string
        want  bool
    }{
        {"valid", "test@example.com", true},
        {"invalid no @", "test.example.com", false},
        {"invalid no domain", "test@", false},
        {"empty", "", false},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got := ValidateEmail(tt.email)
            if got != tt.want {
                t.Errorf("ValidateEmail(%q) = %v, want %v", tt.email, got, tt.want)
            }
        })
    }
}

// 测试辅助函数
func setupTestDB(t *testing.T) *Database {
    t.Helper()
    
    db, err := NewTestDatabase()
    if err != nil {
        t.Fatalf("Failed to create test database: %v", err)
    }
    
    t.Cleanup(func() {
        db.Close()
    })
    
    return db
}

// 并发测试
func TestConcurrentAccess(t *testing.T) {
    cache := NewCache()
    
    // 启动多个 Goroutine
    done := make(chan bool)
    for i := 0; i < 10; i++ {
        go func() {
            for j := 0; j < 100; j++ {
                cache.Set("key", j)
                cache.Get("key")
            }
            done <- true
        }()
    }
    
    // 等待所有完成
    for i := 0; i < 10; i++ {
        <-done
    }
}

// 基准测试
func BenchmarkProcess(b *testing.B) {
    data := make([]byte, 1024)
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        Process(data)
    }
}

// 示例测试（文档）
func ExampleFormat() {
    result := Format("hello")
    fmt.Println(result)
    // Output: Hello
}
```

---

### 案例 8: 项目结构最佳实践

```
blog-api/
├── cmd/
│   └── blog-api/
│       └── main.go          # 程序入口
├── internal/
│   ├── config/              # 配置管理
│   ├── database/            # 数据库层
│   ├── handlers/            # HTTP 处理器
│   ├── middleware/          # 中间件
│   ├── models/              # 数据模型
│   ├── service/             # 业务逻辑
│   └── utils/               # 工具函数
├── pkg/
│   └── logger/              # 可复用包
├── api/
│   └── proto/               # Protobuf 定义
├── configs/
│   ├── config.yaml          # 配置文件
│   └── locales/             # 国际化
├── deployments/
│   ├── docker/
│   │   └── Dockerfile
│   └── k8s/
│       └── deployment.yaml
├── scripts/
│   ├── build.sh
│   └── deploy.sh
├── tests/
│   ├── integration/
│   └── e2e/
├── go.mod
├── go.sum
├── Makefile
├── README.md
└── .golangci.yml            # Lint 配置
```

```makefile
# Makefile
.PHONY: build test lint clean docker

# 变量
VERSION := $(shell git describe --tags --always)
BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
LDFLAGS := -ldflags="-s -w -X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

# 构建
build:
    CGO_ENABLED=0 go build ${LDFLAGS} -o bin/blog-api ./cmd/blog-api

# 测试
test:
    go test -v -race -cover ./...

# 覆盖率
coverage:
    go test -v -coverprofile=coverage.out ./...
    go tool cover -html=coverage.out -o coverage.html

# Lint
lint:
    golangci-lint run

# 格式化
fmt:
    go fmt ./...

# 清理
clean:
    rm -rf bin/
    go clean

# Docker
docker:
    docker build -t blog-api:${VERSION} .

# 运行
run: build
    ./bin/blog-api

# 帮助
help:
    @echo "Available targets:"
    @echo "  build    - Build the application"
    @echo "  test     - Run tests"
    @echo "  lint     - Run linter"
    @echo "  clean    - Clean build artifacts"
    @echo "  docker   - Build Docker image"
    @echo "  run      - Build and run"
```

---

### 案例 9: 常见陷阱与避免

```go
// pitfalls/pitfalls.go
package pitfalls

import (
    "sync"
    "time"
)

// 陷阱 1: 循环中的 Goroutine
func BadGoroutineLoop() {
    for i := 0; i < 5; i++ {
        go func() {
            println(i)  // 都输出 5
        }()
    }
}

func GoodGoroutineLoop() {
    for i := 0; i < 5; i++ {
        i := i  // 创建新变量
        go func() {
            println(i)  // 输出 0-4
        }()
    }
}

// 陷阱 2: 未关闭的 Channel
func BadChannel() {
    ch := make(chan int)
    go func() {
        ch <- 1
        ch <- 2
        // 忘记关闭
    }()
    
    for v := range ch {  // 会阻塞
        println(v)
    }
}

func GoodChannel() {
    ch := make(chan int)
    go func() {
        defer close(ch)  // 确保关闭
        ch <- 1
        ch <- 2
    }()
    
    for v := range ch {
        println(v)
    }
}

// 陷阱 3: 切片共享底层数组
func BadSlice() {
    data := []int{1, 2, 3, 4, 5}
    sub := data[1:3]
    sub[0] = 999  // 影响原切片
    println(data)  // [1 999 3 4 5]
}

func GoodSlice() {
    data := []int{1, 2, 3, 4, 5}
    sub := make([]int, len(data[1:3]))
    copy(sub, data[1:3])  // 复制
    sub[0] = 999
    println(data)  // [1 2 3 4 5]
}

// 陷阱 4: 忘记加锁
type BadCounter struct {
    value int
}

func (c *BadCounter) Inc() {
    c.value++  // 并发不安全
}

type GoodCounter struct {
    mu    sync.Mutex
    value int
}

func (c *GoodCounter) Inc() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

// 陷阱 5: 时间比较
func BadTimeCompare() {
    t1 := time.Now()
    t2 := t1.Add(time.Hour)
    
    if t2.Sub(t1) == time.Hour {  // 可能不相等
        println("equal")
    }
}

func GoodTimeCompare() {
    t1 := time.Now()
    t2 := t1.Add(time.Hour)
    
    if t2.Sub(t1) >= time.Hour {  // 使用 >=
        println("greater or equal")
    }
    
    // 或使用 Before/After
    if t2.After(t1) {
        println("after")
    }
}
```

---

### 案例 10: 代码审查清单

```markdown
# Go 代码审查清单

## 代码规范
- [ ] 遵循 go fmt 格式化
- [ ] 通过 golangci-lint 检查
- [ ] 包名简短且小写
- [ ] 导出标识符有注释
- [ ] 注释使用完整句子

## 错误处理
- [ ] 所有错误都被处理
- [ ] 不使用空白标识符忽略错误
- [ ] 错误信息清晰且有帮助
- [ ] 使用 errors.Is/As 判断错误
- [ ] 包装错误时添加上下文

## 并发安全
- [ ] 共享数据有适当的锁保护
- [ ] 使用 channel 进行通信
- [ ] Goroutine 不会泄漏
- [ ] Channel 正确关闭
- [ ] 使用 context 控制超时

## 性能
- [ ] 避免不必要的内存分配
- [ ] 使用预分配切片
- [ ] 字符串拼接使用 strings.Builder
- [ ] 大对象使用指针传递
- [ ] 热点代码有基准测试

## 测试
- [ ] 关键逻辑有单元测试
- [ ] 使用表格驱动测试
- [ ] 测试覆盖边界条件
- [ ] 测试并发安全
- [ ] 基准测试关键路径

## 安全
- [ ] 用户输入被验证
- [ ] SQL 使用参数化查询
- [ ] 敏感信息不打印日志
- [ ] 密码使用安全哈希
- [ ] 依赖版本已锁定
```

---

## 📝 Go 最佳实践总结

### 代码风格
- 遵循 `go fmt` 和 `go vet`
- 使用 `golangci-lint` 进行静态检查
- 保持函数短小（< 50 行）
- 一个文件不要太大（< 500 行）

### 错误处理
- 错误是值，正常处理
- 不要忽略错误
- 包装错误时添加上下文
- 定义可导出的错误变量

### 并发编程
- 不要通过共享内存通信
- 通过通信共享内存
- 使用 context 控制生命周期
- 注意 Goroutine 泄漏

### 接口设计
- 接口要小（1-3 个方法）
- 接收接口，返回结构体
- 不要过早抽象
- 让编译器工作

### 测试
- 表格驱动测试
- 并行测试 (`t.Parallel()`)
- 基准测试关键路径
- 测试覆盖率达到 80%+

---

## ✅ 学习检查清单

- [ ] 掌握 Go 代码规范与风格
- [ ] 理解错误处理最佳实践
- [ ] 学会并发安全编程
- [ ] 掌握项目组织与结构
- [ ] 理解常见陷阱与避免方法
- [ ] 完成所有 10 个案例

---

**上一章**: [第 19 章 - 微服务架构](./chapter_19.md)

---

## 🎉 第 1 阶段完成！

恭喜完成 Go 语言基础学习！你已经掌握了：

- ✅ 基础语法与数据类型
- ✅ 函数、方法、接口
- ✅ 并发编程（Goroutine、Channel）
- ✅ 标准库使用
- ✅ 测试与基准测试
- ✅ 项目实战（博客 API）
- ✅ 性能优化
- ✅ 部署与运维
- ✅ 微服务架构
- ✅ 最佳实践

**下一阶段**: 第 2 阶段 - 高级专题（第 21-30 章）
- Web 框架深入
- 数据库高级用法
- 消息队列
- 缓存系统
- 分布式系统
- 云原生开发
