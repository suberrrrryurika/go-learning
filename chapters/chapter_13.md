# 第 13 章 - 并发编程

**阶段**: 第 2 阶段 - 进阶  
**预计学习时长**: 4.5 小时  
**代码量**: 750 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 理解 Goroutine 的概念与使用
2. 掌握 Channel 的通信机制
3. 学会使用 select 多路复用
4. 理解 Worker Pool 模式
5. 掌握并发控制与同步

---

## 📚 理论讲解

### 一、Goroutine

#### 1.1 什么是 Goroutine

Goroutine 是 **Go 语言的轻量级线程**，由 Go 运行时管理。

```go
go func() {
    fmt.Println("运行在 Goroutine 中")
}()
```

**特点**:
- 启动开销小（几 KB 栈空间）
- 由 Go 运行时调度（M:N 模型）
- 通过 Channel 通信

### 二、Channel

#### 2.1 Channel 基础

Channel 是 **类型安全的管道**，用于 Goroutine 间通信。

```go
// 创建
ch := make(chan int)

// 发送
ch <- value

// 接收
value := <-ch

// 关闭
close(ch)
```

#### 2.2 Channel 类型

| 类型 | 语法 | 说明 |
|------|------|------|
| 无缓冲 | `make(chan T)` | 同步通信，发送会阻塞 |
| 有缓冲 | `make(chan T, n)` | 异步通信，缓冲区大小为 n |
| 只读 | `<-chan T` | 只能接收 |
| 只写 | `chan<- T` | 只能发送 |

---

## 💻 实战案例

### 案例 1: Goroutine 基础

```go
package main

import (
    "fmt"
    "time"
)

func worker(id int) {
    fmt.Printf("Worker %d 开始\n", id)
    time.Sleep(time.Second)
    fmt.Printf("Worker %d 结束\n", id)
}

func main() {
    fmt.Println("=== Goroutine 基础 ===")
    
    // 启动多个 Goroutine
    for i := 1; i <= 5; i++ {
        go worker(i)
    }
    
    // 等待 Goroutine 完成
    fmt.Println("等待完成...")
    time.Sleep(2 * time.Second)
    fmt.Println("所有任务完成")
}
```

**输出**:
```
=== Goroutine 基础 ===
Worker 1 开始
Worker 2 开始
Worker 3 开始
Worker 4 开始
Worker 5 开始
等待完成...
Worker 1 结束
Worker 2 结束
Worker 3 结束
Worker 4 结束
Worker 5 结束
所有任务完成
```

---

### 案例 2: 无缓冲 Channel

```go
package main

import "fmt"

func main() {
    fmt.Println("=== 无缓冲 Channel ===")
    
    ch := make(chan string)
    
    // 启动 Goroutine 发送数据
    go func() {
        ch <- "Hello from Goroutine!"
    }()
    
    // 主 Goroutine 接收数据
    msg := <-ch
    fmt.Println(msg)
    
    // 同步演示
    fmt.Println("\n=== 同步通信 ===")
    ch2 := make(chan int)
    
    go func() {
        fmt.Println("准备发送...")
        ch2 <- 42
        fmt.Println("已发送")
    }()
    
    fmt.Println("准备接收...")
    val := <-ch2
    fmt.Printf("接收到的值：%d\n", val)
}
```

**输出**:
```
=== 无缓冲 Channel ===
Hello from Goroutine!

=== 同步通信 ===
准备接收...
准备发送...
已发送
接收到的值：42
```

---

### 案例 3: 有缓冲 Channel

```go
package main

import "fmt"

func main() {
    fmt.Println("=== 有缓冲 Channel ===")
    
    // 创建缓冲 Channel
    ch := make(chan int, 3)
    
    // 发送不会阻塞（缓冲区未满）
    ch <- 1
    ch <- 2
    ch <- 3
    fmt.Println("已发送 3 个值")
    
    // 接收
    fmt.Printf("接收：%d\n", <-ch)
    fmt.Printf("接收：%d\n", <-ch)
    
    // 再发送
    ch <- 4
    ch <- 5
    fmt.Println("又发送了 2 个值")
    
    // 遍历 Channel
    fmt.Println("\n=== 遍历 Channel ===")
    close(ch)
    for v := range ch {
        fmt.Printf("收到：%d\n", v)
    }
}
```

**输出**:
```
=== 有缓冲 Channel ===
已发送 3 个值
接收：1
接收：2
又发送了 2 个值

=== 遍历 Channel ===
收到：3
收到：4
收到：5
```

---

### 案例 4: select 多路复用

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Println("=== select 多路复用 ===")
    
    ch1 := make(chan string)
    ch2 := make(chan string)
    
    // 启动两个发送者
    go func() {
        time.Sleep(time.Second)
        ch1 <- "来自 ch1"
    }()
    
    go func() {
        time.Sleep(2 * time.Second)
        ch2 <- "来自 ch2"
    }()
    
    // select 等待任意一个
    for i := 0; i < 2; i++ {
        select {
        case msg1 := <-ch1:
            fmt.Printf("收到：%s\n", msg1)
        case msg2 := <-ch2:
            fmt.Printf("收到：%s\n", msg2)
        }
    }
    
    // 带超时的 select
    fmt.Println("\n=== 超时处理 ===")
    ch3 := make(chan string)
    
    select {
    case msg := <-ch3:
        fmt.Println(msg)
    case <-time.After(time.Second):
        fmt.Println("超时！")
    }
    
    // default 分支（非阻塞）
    fmt.Println("\n=== 非阻塞尝试 ===")
    ch4 := make(chan int)
    
    select {
    case v := <-ch4:
        fmt.Printf("收到：%d\n", v)
    default:
        fmt.Println("没有数据可读")
    }
}
```

**输出**:
```
=== select 多路复用 ===
收到：来自 ch1
收到：来自 ch2

=== 超时处理 ===
超时！

=== 非阻塞尝试 ===
没有数据可读
```

---

### 案例 5: Worker Pool 模式

```go
package main

import (
    "fmt"
    "time"
)

// 任务
type Job struct {
    ID   int
    Data string
}

// 结果
type Result struct {
    JobID  int
    Output string
}

// Worker
func worker(id int, jobs <-chan Job, results chan<- Result) {
    for job := range jobs {
        fmt.Printf("Worker %d 处理任务 %d\n", id, job.ID)
        time.Sleep(500 * time.Millisecond)
        results <- Result{JobID: job.ID, Output: "完成"}
    }
}

func main() {
    fmt.Println("=== Worker Pool ===")
    
    const numWorkers = 3
    const numJobs = 10
    
    jobs := make(chan Job, numJobs)
    results := make(chan Result, numJobs)
    
    // 启动 Worker
    for w := 1; w <= numWorkers; w++ {
        go worker(w, jobs, results)
    }
    
    // 发送任务
    for j := 1; j <= numJobs; j++ {
        jobs <- Job{ID: j, Data: fmt.Sprintf("任务%d", j)}
    }
    close(jobs)
    
    // 收集结果
    for r := 1; r <= numJobs; r++ {
        result := <-results
        fmt.Printf("任务 %d: %s\n", result.JobID, result.Output)
    }
}
```

**输出**:
```
=== Worker Pool ===
Worker 1 处理任务 1
Worker 2 处理任务 2
Worker 3 处理任务 3
任务 1: 完成
任务 2: 完成
任务 3: 完成
Worker 1 处理任务 4
Worker 2 处理任务 5
Worker 3 处理任务 6
...
```

---

### 案例 6: 并发控制 - WaitGroup

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func worker(id int, wg *sync.WaitGroup) {
    defer wg.Done()
    
    fmt.Printf("Worker %d 开始\n", id)
    time.Sleep(time.Second)
    fmt.Printf("Worker %d 结束\n", id)
}

func main() {
    fmt.Println("=== WaitGroup ===")
    
    var wg sync.WaitGroup
    
    // 启动 5 个 Goroutine
    for i := 1; i <= 5; i++ {
        wg.Add(1)
        go worker(i, &wg)
    }
    
    // 等待所有完成
    wg.Wait()
    fmt.Println("所有 Worker 完成")
}
```

**输出**:
```
=== WaitGroup ===
Worker 1 开始
Worker 2 开始
Worker 3 开始
Worker 4 开始
Worker 5 开始
Worker 1 结束
Worker 2 结束
Worker 3 结束
Worker 4 结束
Worker 5 结束
所有 Worker 完成
```

---

### 案例 7: 互斥锁 - Mutex

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

type Counter struct {
    mu    sync.Mutex
    value int
}

func (c *Counter) Increment() {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.value++
}

func (c *Counter) Value() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    return c.value
}

func main() {
    fmt.Println("=== Mutex 互斥锁 ===")
    
    counter := &Counter{}
    var wg sync.WaitGroup
    
    // 100 个 Goroutine 同时增加
    for i := 0; i < 100; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            counter.Increment()
        }()
    }
    
    wg.Wait()
    fmt.Printf("最终值：%d\n", counter.Value())
    
    // 读写锁演示
    fmt.Println("\n=== RWMutex 读写锁 ===")
    
    rwmu := &sync.RWMutex{}
    
    // 多个读锁可以同时持有
    rwmu.RLock()
    rwmu.RLock()
    fmt.Println("两个读锁同时持有")
    rwmu.RUnlock()
    rwmu.RUnlock()
    
    // 写锁独占
    rwmu.Lock()
    fmt.Println("写锁持有（独占）")
    rwmu.Unlock()
}
```

**输出**:
```
=== Mutex 互斥锁 ===
最终值：100

=== RWMutex 读写锁 ===
两个读锁同时持有
写锁持有（独占）
```

---

### 案例 8: Context 取消

```go
package main

import (
    "context"
    "fmt"
    "time"
)

func worker(ctx context.Context, id int) {
    for {
        select {
        case <-ctx.Done():
            fmt.Printf("Worker %d 收到取消信号\n", id)
            return
        default:
            fmt.Printf("Worker %d 工作中...\n", id)
            time.Sleep(500 * time.Millisecond)
        }
    }
}

func main() {
    fmt.Println("=== Context 取消 ===")
    
    // 创建可取消的 Context
    ctx, cancel := context.WithCancel(context.Background())
    
    // 启动 Worker
    for i := 1; i <= 3; i++ {
        go worker(ctx, i)
    }
    
    // 3 秒后取消
    time.Sleep(3 * time.Second)
    cancel()
    
    // 等待退出
    time.Sleep(time.Second)
    fmt.Println("所有 Worker 已退出")
    
    // 带超时的 Context
    fmt.Println("\n=== Context 超时 ===")
    ctx2, cancel2 := context.WithTimeout(context.Background(), 2*time.Second)
    defer cancel2()
    
    go func() {
        <-ctx2.Done()
        fmt.Printf("超时原因：%v\n", ctx2.Err())
    }()
    
    time.Sleep(3 * time.Second)
}
```

**输出**:
```
=== Context 取消 ===
Worker 1 工作中...
Worker 2 工作中...
Worker 3 工作中...
Worker 1 收到取消信号
Worker 2 收到取消信号
Worker 3 收到取消信号
所有 Worker 已退出

=== Context 超时 ===
超时原因：context deadline exceeded
```

---

### 案例 9: 综合应用 - 并发爬虫

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

// 模拟爬取结果
type CrawlResult struct {
    URL     string
    Content string
    Error   error
}

// 模拟爬取函数
func crawl(url string, delay time.Duration) CrawlResult {
    time.Sleep(delay)
    return CrawlResult{
        URL:     url,
        Content: fmt.Sprintf("模拟内容 from %s", url),
    }
}

// 并发爬取
func concurrentCrawl(urls []string, workers int) []CrawlResult {
    var wg sync.WaitGroup
    urlChan := make(chan string, len(urls))
    resultChan := make(chan CrawlResult, len(urls))
    
    // 启动 Worker
    for i := 0; i < workers; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            for url := range urlChan {
                result := crawl(url, 500*time.Millisecond)
                resultChan <- result
            }
        }(i)
    }
    
    // 发送 URL
    for _, url := range urls {
        urlChan <- url
    }
    close(urlChan)
    
    // 等待完成
    go func() {
        wg.Wait()
        close(resultChan)
    }()
    
    // 收集结果
    var results []CrawlResult
    for result := range resultChan {
        results = append(results, result)
    }
    
    return results
}

func main() {
    fmt.Println("=== 并发爬虫 ===")
    
    urls := []string{
        "https://example.com/1",
        "https://example.com/2",
        "https://example.com/3",
        "https://example.com/4",
        "https://example.com/5",
    }
    
    start := time.Now()
    results := concurrentCrawl(urls, 3)
    elapsed := time.Since(start)
    
    fmt.Printf("\n爬取完成，用时：%v\n", elapsed)
    fmt.Printf("成功：%d 个页面\n", len(results))
    
    for _, r := range results {
        fmt.Printf("✓ %s\n", r.URL)
    }
}
```

**输出**:
```
=== 并发爬虫 ===

爬取完成，用时：约 1 秒
成功：5 个页面
✓ https://example.com/1
✓ https://example.com/2
✓ https://example.com/3
✓ https://example.com/4
✓ https://example.com/5
```

---

## 📝 课后练习

1. 实现一个并发安全的 Map
2. 使用 Goroutine 实现一个并发文件处理器
3. 实现一个带限流的爬虫
4. 使用 Channel 实现生产者 - 消费者模式
5. 实现一个并发排序算法

---

## ✅ 学习检查清单

- [ ] 理解 Goroutine 的概念与使用
- [ ] 掌握 Channel 的通信机制
- [ ] 学会使用 select 多路复用
- [ ] 理解 Worker Pool 模式
- [ ] 掌握并发控制与同步
- [ ] 完成所有 9 个案例

---

**上一章**: [第 12 章 - 接口](./chapter_12.md)  
**下一章**: [第 14 章 - 标准库](./chapter_14.md)
