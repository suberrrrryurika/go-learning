# 第 19 章 - 微服务架构

**阶段**: 第 3 阶段 - 高级  
**预计学习时长**: 5 小时  
**代码量**: 800 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 理解微服务架构概念
2. 掌握 gRPC 通信协议
3. 学会服务发现与注册
4. 理解负载均衡策略
5. 掌握熔断器与限流

---

## 📚 理论讲解

### 一、微服务架构

#### 1.1 核心概念

微服务架构是将单一应用拆分为**一组小型服务**的架构风格。

**特点**:
- 每个服务运行在独立进程中
- 服务间通过轻量级协议通信（HTTP/gRPC）
- 围绕业务能力组织
- 独立部署、独立扩展

#### 1.2 服务通信

| 协议 | 特点 | 场景 |
|------|------|------|
| HTTP/REST | 简单、通用 | 公开 API、浏览器客户端 |
| gRPC | 高效、强类型 | 内部服务通信 |
| Message Queue | 异步、解耦 | 事件驱动、削峰填谷 |

### 二、服务发现

#### 2.1 注册与发现

```
服务提供者 → 注册中心 ← 服务消费者
     ↑                        ↑
   注册                      发现
```

**常见方案**:
- Consul
- etcd
- Eureka
- Nacos

---

## 💻 实战案例

### 案例 1: gRPC 基础

```protobuf
// proto/user.proto
syntax = "proto3";

package user;

option go_package = "blog-api/proto";

// 用户服务
service UserService {
    rpc GetUser(GetUserRequest) returns (User);
    rpc CreateUser(CreateUserRequest) returns (User);
    rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
}

message User {
    int32 id = 1;
    string username = 2;
    string email = 3;
    int32 age = 4;
}

message GetUserRequest {
    int32 id = 1;
}

message CreateUserRequest {
    string username = 1;
    string email = 2;
    int32 age = 3;
}

message ListUsersRequest {
    int32 page = 1;
    int32 page_size = 2;
}

message ListUsersResponse {
    repeated User users = 1;
    int32 total = 2;
}
```

```bash
# 生成 Go 代码
protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    proto/user.proto
```

```go
// server/user_server.go
package server

import (
    "context"
    "blog-api/proto"
)

type UserServiceServer struct {
    proto.UnimplementedUserServiceServer
    users map[int32]*proto.User
    nextID int32
}

func NewUserServiceServer() *UserServiceServer {
    return &UserServiceServer{
        users: make(map[int32]*proto.User),
        nextID: 1,
    }
}

func (s *UserServiceServer) GetUser(ctx context.Context, req *proto.GetUserRequest) (*proto.User, error) {
    user, ok := s.users[req.Id]
    if !ok {
        return nil, status.Error(codes.NotFound, "user not found")
    }
    return user, nil
}

func (s *UserServiceServer) CreateUser(ctx context.Context, req *proto.CreateUserRequest) (*proto.User, error) {
    user := &proto.User{
        Id: s.nextID,
        Username: req.Username,
        Email: req.Email,
        Age: req.Age,
    }
    s.users[user.Id] = user
    s.nextID++
    return user, nil
}

func (s *UserServiceServer) ListUsers(ctx context.Context, req *proto.ListUsersRequest) (*proto.ListUsersResponse, error) {
    var users []*proto.User
    for _, user := range s.users {
        users = append(users, user)
    }
    return &proto.ListUsersResponse{
        Users: users,
        Total: int32(len(users)),
    }, nil
}
```

```go
// main.go - gRPC 服务器
package main

import (
    "blog-api/server"
    "blog-api/proto"
    "google.golang.org/grpc"
    "log"
    "net"
)

func main() {
    lis, err := net.Listen("tcp", ":50051")
    if err != nil {
        log.Fatalf("Failed to listen: %v", err)
    }
    
    s := grpc.NewServer()
    proto.RegisterUserServiceServer(s, server.NewUserServiceServer())
    
    log.Println("gRPC server starting on :50051")
    if err := s.Serve(lis); err != nil {
        log.Fatalf("Failed to serve: %v", err)
    }
}
```

---

### 案例 2: gRPC 客户端

```go
// client/user_client.go
package client

import (
    "context"
    "blog-api/proto"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
)

type UserClient struct {
    conn proto.UserServiceClient
}

func NewUserClient(addr string) (*UserClient, error) {
    conn, err := grpc.Dial(addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
    if err != nil {
        return nil, err
    }
    
    return &UserClient{
        conn: proto.NewUserServiceClient(conn),
    }, nil
}

func (c *UserClient) GetUser(id int32) (*proto.User, error) {
    return c.conn.GetUser(context.Background(), &proto.GetUserRequest{Id: id})
}

func (c *UserClient) CreateUser(username, email string, age int32) (*proto.User, error) {
    return c.conn.CreateUser(context.Background(), &proto.CreateUserRequest{
        Username: username,
        Email: email,
        Age: age,
    })
}

func (c *UserClient) ListUsers() (*proto.ListUsersResponse, error) {
    return c.conn.ListUsers(context.Background(), &proto.ListUsersRequest{})
}
```

```go
// main.go - 使用客户端
package main

import (
    "blog-api/client"
    "fmt"
)

func main() {
    client, err := client.NewUserClient("localhost:50051")
    if err != nil {
        panic(err)
    }
    
    // 创建用户
    user, err := client.CreateUser("alice", "alice@example.com", 25)
    if err != nil {
        panic(err)
    }
    fmt.Printf("Created user: %+v\n", user)
    
    // 获取用户
    user, err = client.GetUser(user.Id)
    if err != nil {
        panic(err)
    }
    fmt.Printf("Got user: %+v\n", user)
    
    // 列出用户
    resp, err := client.ListUsers()
    if err != nil {
        panic(err)
    }
    fmt.Printf("Total users: %d\n", resp.Total)
}
```

---

### 案例 3: 服务注册与发现

```go
// registry/registry.go
package registry

import (
    "sync"
    "time"
)

type ServiceInstance struct {
    ID        string
    Name      string
    Address   string
    Port      int
    HealthURL string
    LastSeen  time.Time
}

type Registry struct {
    mu       sync.RWMutex
    services map[string]map[string]*ServiceInstance
}

func NewRegistry() *Registry {
    return &Registry{
        services: make(map[string]map[string]*ServiceInstance),
    }
}

func (r *Registry) Register(instance *ServiceInstance) error {
    r.mu.Lock()
    defer r.mu.Unlock()
    
    if _, ok := r.services[instance.Name]; !ok {
        r.services[instance.Name] = make(map[string]*ServiceInstance)
    }
    
    instance.LastSeen = time.Now()
    r.services[instance.Name][instance.ID] = instance
    return nil
}

func (r *Registry) Deregister(name, id string) error {
    r.mu.Lock()
    defer r.mu.Unlock()
    
    if services, ok := r.services[name]; ok {
        delete(services, id)
    }
    return nil
}

func (r *Registry) Discover(name string) ([]*ServiceInstance, error) {
    r.mu.RLock()
    defer r.mu.RUnlock()
    
    services, ok := r.services[name]
    if !ok {
        return []*ServiceInstance{}, nil
    }
    
    var instances []*ServiceInstance
    for _, instance := range services {
        // 过滤掉超过 30 秒未心跳的实例
        if time.Since(instance.LastSeen) < 30*time.Second {
            instances = append(instances, instance)
        }
    }
    return instances, nil
}

func (r *Registry) Heartbeat(name, id string) error {
    r.mu.Lock()
    defer r.mu.Unlock()
    
    if services, ok := r.services[name]; ok {
        if instance, ok := services[id]; ok {
            instance.LastSeen = time.Now()
        }
    }
    return nil
}
```

```go
// registry/http_server.go
package registry

import (
    "encoding/json"
    "net/http"
)

func (r *Registry) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    switch req.URL.Path {
    case "/register":
        r.handleRegister(w, req)
    case "/deregister":
        r.handleDeregister(w, req)
    case "/discover":
        r.handleDiscover(w, req)
    case "/heartbeat":
        r.handleHeartbeat(w, req)
    default:
        http.NotFound(w, req)
    }
}

func (r *Registry) handleRegister(w http.ResponseWriter, req *http.Request) {
    var instance ServiceInstance
    if err := json.NewDecoder(req.Body).Decode(&instance); err != nil {
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }
    
    if err := r.Register(&instance); err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    
    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

func (r *Registry) handleDiscover(w http.ResponseWriter, req *http.Request) {
    name := req.URL.Query().Get("name")
    instances, err := r.Discover(name)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    
    json.NewEncoder(w).Encode(instances)
}
```

---

### 案例 4: 客户端负载均衡

```go
// lb/load_balancer.go
package lb

import (
    "context"
    "google.golang.org/grpc"
    "google.golang.org/grpc/credentials/insecure"
    "math/rand"
    "sync"
)

type LoadBalancer struct {
    mu        sync.RWMutex
    instances []string
    strategy  string
}

func NewLoadBalancer(strategy string) *LoadBalancer {
    return &LoadBalancer{
        strategy: strategy,
        instances: make([]string, 0),
    }
}

func (lb *LoadBalancer) UpdateInstances(instances []string) {
    lb.mu.Lock()
    defer lb.mu.Unlock()
    lb.instances = instances
}

func (lb *LoadBalancer) GetConnection() (*grpc.ClientConn, error) {
    lb.mu.RLock()
    defer lb.mu.RUnlock()
    
    if len(lb.instances) == 0 {
        return nil, ErrNoInstances
    }
    
    var addr string
    switch lb.strategy {
    case "random":
        addr = lb.instances[rand.Intn(len(lb.instances))]
    case "round-robin":
        // 实现轮询逻辑
        addr = lb.instances[0]
    default:
        addr = lb.instances[0]
    }
    
    return grpc.Dial(addr, grpc.WithTransportCredentials(insecure.NewCredentials()))
}
```

```go
// lb/resolver.go
package lb

import (
    "google.golang.org/grpc/resolver"
)

type customResolver struct {
    cc resolver.ClientConn
}

func (r *customResolver) ResolveNow(options resolver.ResolveNowOptions) {}

func (r *customResolver) Close() {}

func NewBuilder() resolver.Builder {
    return &customBuilder{}
}

type customBuilder struct{}

func (b *customBuilder) Build(target resolver.Target, cc resolver.ClientConn, opts resolver.BuildOptions) (resolver.Resolver, error) {
    r := &customResolver{cc: cc}
    cc.UpdateState(resolver.State{
        Addresses: []resolver.Address{
            {Addr: "localhost:50051"},
            {Addr: "localhost:50052"},
            {Addr: "localhost:50053"},
        },
    })
    return r, nil
}

func (b *customBuilder) Scheme() string {
    return "custom"
}
```

---

### 案例 5: 熔断器模式

```go
// circuitbreaker/circuit_breaker.go
package circuitbreaker

import (
    "errors"
    "sync"
    "time"
)

type State int

const (
    StateClosed State = iota
    StateOpen
    StateHalfOpen
)

var (
    ErrCircuitOpen = errors.New("circuit breaker is open")
)

type CircuitBreaker struct {
    mu              sync.Mutex
    state           State
    failures        int
    successCount    int
    threshold       int
    timeout         time.Duration
    lastFailureTime time.Time
}

func NewCircuitBreaker(threshold int, timeout time.Duration) *CircuitBreaker {
    return &CircuitBreaker{
        state:     StateClosed,
        threshold: threshold,
        timeout:   timeout,
    }
}

func (cb *CircuitBreaker) Execute(fn func() error) error {
    cb.mu.Lock()
    
    if cb.state == StateOpen {
        if time.Since(cb.lastFailureTime) > cb.timeout {
            cb.state = StateHalfOpen
            cb.successCount = 0
        } else {
            cb.mu.Unlock()
            return ErrCircuitOpen
        }
    }
    
    cb.mu.Unlock()
    
    err := fn()
    
    cb.mu.Lock()
    defer cb.mu.Unlock()
    
    if err != nil {
        cb.failures++
        cb.lastFailureTime = time.Now()
        
        if cb.failures >= cb.threshold {
            cb.state = StateOpen
        }
        return err
    }
    
    if cb.state == StateHalfOpen {
        cb.successCount++
        if cb.successCount >= 3 {
            cb.state = StateClosed
            cb.failures = 0
        }
    }
    
    return nil
}

func (cb *CircuitBreaker) State() State {
    cb.mu.Lock()
    defer cb.mu.Unlock()
    return cb.state
}
```

```go
// middleware/circuit_breaker.go
package middleware

import (
    "blog-api/circuitbreaker"
    "context"
    "google.golang.org/grpc"
    "google.golang.org/grpc/codes"
    "google.golang.org/grpc/status"
    "time"
)

func CircuitBreakerMiddleware(cb *circuitbreaker.CircuitBreaker) grpc.UnaryClientInterceptor {
    return func(ctx context.Context, method string, req, reply interface{}, cc *grpc.ClientConn, invoker grpc.UnaryInvoker, opts ...grpc.CallOption) error {
        var err error
        
        err = cb.Execute(func() error {
            ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
            defer cancel()
            
            return invoker(ctx, method, req, reply, cc, opts...)
        })
        
        if err == circuitbreaker.ErrCircuitOpen {
            return status.Error(codes.Unavailable, "service temporarily unavailable")
        }
        
        return err
    }
}
```

---

### 案例 6: 限流器

```go
// ratelimit/rate_limiter.go
package ratelimit

import (
    "sync"
    "time"
)

type RateLimiter struct {
    mu         sync.Mutex
    tokens     int
    maxTokens  int
    refillRate int
    lastRefill time.Time
}

func NewRateLimiter(maxTokens, refillRate int) *RateLimiter {
    return &RateLimiter{
        tokens:     maxTokens,
        maxTokens:  maxTokens,
        refillRate: refillRate,
        lastRefill: time.Now(),
    }
}

func (rl *RateLimiter) Allow() bool {
    rl.mu.Lock()
    defer rl.mu.Unlock()
    
    // 补充令牌
    now := time.Now()
    elapsed := now.Sub(rl.lastRefill)
    tokensToAdd := int(elapsed.Seconds()) * rl.refillRate
    
    if tokensToAdd > 0 {
        rl.tokens = min(rl.tokens+tokensToAdd, rl.maxTokens)
        rl.lastRefill = now
    }
    
    // 消费令牌
    if rl.tokens > 0 {
        rl.tokens--
        return true
    }
    
    return false
}

func min(a, b int) int {
    if a < b {
        return a
    }
    return b
}
```

```go
// middleware/ratelimit.go
package middleware

import (
    "blog-api/ratelimit"
    "net/http"
)

func RateLimitMiddleware(limiter *ratelimit.RateLimiter) func(http.Handler) http.Handler {
    return func(next http.Handler) http.Handler {
        return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
            if !limiter.Allow() {
                http.Error(w, "Rate limit exceeded", http.StatusTooManyRequests)
                return
            }
            next.ServeHTTP(w, r)
        })
    }
}
```

---

### 案例 7: 分布式追踪

```go
// tracing/tracing.go
package tracing

import (
    "context"
    "github.com/google/uuid"
)

type TraceContext struct {
    TraceID   string
    SpanID    string
    ParentID  string
    Operation string
}

func StartSpan(ctx context.Context, operation string) (context.Context, *TraceContext) {
    traceID := uuid.New().String()
    spanID := uuid.New().String()
    
    traceCtx := &TraceContext{
        TraceID:   traceID,
        SpanID:    spanID,
        Operation: operation,
    }
    
    return context.WithValue(ctx, "trace", traceCtx), traceCtx
}

func StartChildSpan(ctx context.Context, operation string) (context.Context, *TraceContext) {
    parent, ok := ctx.Value("trace").(*TraceContext)
    if !ok {
        return StartSpan(ctx, operation)
    }
    
    spanID := uuid.New().String()
    traceCtx := &TraceContext{
        TraceID:   parent.TraceID,
        SpanID:    spanID,
        ParentID:  parent.SpanID,
        Operation: operation,
    }
    
    return context.WithValue(ctx, "trace", traceCtx), traceCtx
}

func (tc *TraceContext) Headers() map[string]string {
    return map[string]string{
        "X-Trace-ID":  tc.TraceID,
        "X-Span-ID":   tc.SpanID,
        "X-Parent-ID": tc.ParentID,
    }
}
```

```go
// middleware/tracing.go
package middleware

import (
    "blog-api/tracing"
    "net/http"
)

func TracingMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        // 从请求头获取追踪信息
        traceID := r.Header.Get("X-Trace-ID")
        spanID := r.Header.Get("X-Span-ID")
        
        ctx := r.Context()
        if traceID != "" {
            traceCtx := &tracing.TraceContext{
                TraceID:   traceID,
                SpanID:    spanID,
                Operation: r.URL.Path,
            }
            ctx = context.WithValue(ctx, "trace", traceCtx)
        }
        
        next.ServeHTTP(w, r.WithContext(ctx))
    })
}
```

---

### 案例 8: 服务网格 sidecar

```go
// sidecar/proxy.go
package sidecar

import (
    "context"
    "net/http"
    "net/http/httputil"
    "net/url"
    "time"
)

type Proxy struct {
    target      *url.URL
    reverseProxy *httputil.ReverseProxy
    timeout     time.Duration
}

func NewProxy(targetAddr string, timeout time.Duration) (*Proxy, error) {
    target, err := url.Parse(targetAddr)
    if err != nil {
        return nil, err
    }
    
    proxy := &Proxy{
        target:  target,
        timeout: timeout,
    }
    
    proxy.reverseProxy = httputil.NewSingleHostReverseProxy(target)
    
    // 自定义 Director
    originalDirector := proxy.reverseProxy.Director
    proxy.reverseProxy.Director = func(req *http.Request) {
        originalDirector(req)
        req.Host = target.Host
    }
    
    return proxy, nil
}

func (p *Proxy) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    // 添加超时
    ctx, cancel := context.WithTimeout(r.Context(), p.timeout)
    defer cancel()
    
    r = r.WithContext(ctx)
    p.reverseProxy.ServeHTTP(w, r)
}
```

```yaml
# kubernetes/sidecar.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-sidecar
spec:
  containers:
    - name: app
      image: your-app:latest
      ports:
        - containerPort: 8080
    
    - name: sidecar
      image: your-sidecar:latest
      ports:
        - containerPort: 9090
      env:
        - name: TARGET_ADDRESS
          value: "localhost:8080"
```

---

### 案例 9: 完整微服务示例

```go
// cmd/order-service/main.go
package main

import (
    "blog-api/circuitbreaker"
    "blog-api/middleware"
    "blog-api/ratelimit"
    "blog-api/tracing"
    "context"
    "fmt"
    "google.golang.org/grpc"
    "log/slog"
    "net"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"
)

func main() {
    // 初始化日志
    log := slog.New(slog.NewJSONHandler(os.Stdout, nil))
    
    // 初始化熔断器
    cb := circuitbreaker.NewCircuitBreaker(5, 30*time.Second)
    
    // 初始化限流器
    limiter := ratelimit.NewRateLimiter(100, 10)
    
    // 创建 gRPC 服务器
    grpcServer := grpc.NewServer(
        grpc.UnaryInterceptor(middleware.CircuitBreakerMiddleware(cb)),
    )
    
    // 注册服务
    // proto.RegisterOrderServiceServer(grpcServer, &OrderService{})
    
    // 启动 gRPC 服务器
    grpcLis, _ := net.Listen("tcp", ":50051")
    go func() {
        log.Info("gRPC server starting", "port", 50051)
        grpcServer.Serve(grpcLis)
    }()
    
    // 创建 HTTP 服务器
    mux := http.NewServeMux()
    mux.Handle("/", middleware.RateLimitMiddleware(limiter)(http.HandlerFunc(orderHandler)))
    mux.Handle("/health", http.HandlerFunc(healthHandler))
    mux.Handle("/metrics", middleware.TracingMiddleware(http.HandlerFunc(metricsHandler)))
    
    httpServer := &http.Server{
        Addr:         ":8080",
        Handler:      mux,
        ReadTimeout:  30 * time.Second,
        WriteTimeout: 30 * time.Second,
    }
    
    // 启动 HTTP 服务器
    go func() {
        log.Info("HTTP server starting", "port", 8080)
        httpServer.ListenAndServe()
    }()
    
    // 等待中断信号
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit
    
    // 优雅关闭
    log.Info("Shutting down servers...")
    
    ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
    defer cancel()
    
    httpServer.Shutdown(ctx)
    grpcServer.GracefulStop()
    
    log.Info("Servers stopped")
}

func orderHandler(w http.ResponseWriter, r *http.Request) {
    ctx, span := tracing.StartSpan(r.Context(), "order_handler")
    defer func() {
        log.Info("Order processed",
            "trace_id", span.TraceID,
            "span_id", span.SpanID,
        )
    }()
    
    _ = ctx
    fmt.Fprintf(w, "Order processed")
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    w.Write([]byte("OK"))
}

func metricsHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Metrics endpoint")
}
```

---

## 📝 微服务检查清单

### 服务通信
- [ ] 选择合适的通信协议（gRPC/HTTP）
- [ ] 定义清晰的 API 接口
- [ ] 实现超时和重试机制
- [ ] 处理服务间认证

### 服务发现
- [ ] 实现服务注册
- [ ] 实现服务发现
- [ ] 健康检查机制
- [ ] 服务摘除

### 负载均衡
- [ ] 选择合适的负载均衡策略
- [ ] 实现客户端负载均衡
- [ ] 处理服务实例变化

### 容错处理
- [ ] 实现熔断器
- [ ] 实现限流器
- [ ] 实现降级策略
- [ ] 实现重试机制

### 可观测性
- [ ] 结构化日志
- [ ] 分布式追踪
- [ ] 指标收集
- [ ] 告警系统

---

## ✅ 学习检查清单

- [ ] 理解微服务架构概念
- [ ] 掌握 gRPC 通信协议
- [ ] 学会服务发现与注册
- [ ] 理解负载均衡策略
- [ ] 掌握熔断器与限流
- [ ] 完成所有 9 个案例

---

**上一章**: [第 18 章 - 部署与运维](./chapter_18.md)  
**下一章**: [第 20 章 - 最佳实践](./chapter_20.md)
