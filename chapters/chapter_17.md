# 第 17 章 - 性能优化

**阶段**: 第 3 阶段 - 高级  
**预计学习时长**: 4 小时  
**代码量**: 700 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 理解 Go 性能分析方法
2. 掌握 pprof 性能分析工具
3. 学会内存优化技巧
4. 理解并发性能调优
5. 掌握代码优化最佳实践

---

## 📚 理论讲解

### 一、性能分析工具

#### 1.1 pprof

Go 内置的性能分析工具，支持 CPU、内存、Goroutine 等分析。

```bash
# HTTP 服务 pprof
import _ "net/http/pprof"

# 访问
http://localhost:6060/debug/pprof/

# 命令行分析
go tool pprof http://localhost:6060/debug/pprof/profile
```

#### 1.2 性能测试

```bash
# 基准测试
go test -bench=. -benchmem

# CPU 分析
go test -cpuprofile=cpu.out

# 内存分析
go test -memprofile=mem.out

# 查看分析结果
go tool pprof cpu.out
```

### 二、优化原则

1. **先分析，后优化** - 不要盲目优化
2. **80/20 法则** - 80% 的时间花在 20% 的代码上
3. **避免过早优化** - 先让代码正确，再让它快
4. **测量效果** - 优化前后都要基准测试

---

## 💻 实战案例

### 案例 1: 基准测试基础

```go
// benchmark_test.go
package main

import (
    "strconv"
    "testing"
)

// 字符串拼接性能对比
func BenchmarkStringConcat(b *testing.B) {
    for i := 0; i < b.N; i++ {
        s := ""
        for j := 0; j < 100; j++ {
            s += strconv.Itoa(j)
        }
    }
}

func BenchmarkStringBuilder(b *testing.B) {
    for i := 0; i < b.N; i++ {
        var sb StringBuilder
        for j := 0; j < 100; j++ {
            sb.WriteString(strconv.Itoa(j))
        }
        _ = sb.String()
    }
}

func BenchmarkStringBuffer(b *testing.B) {
    for i := 0; i < b.N; i++ {
        var buf bytes.Buffer
        for j := 0; j < 100; j++ {
            buf.WriteString(strconv.Itoa(j))
        }
        _ = buf.String()
    }
}

// 切片预分配性能对比
func BenchmarkSliceNoPrealloc(b *testing.B) {
    for i := 0; i < b.N; i++ {
        var slice []int
        for j := 0; j < 1000; j++ {
            slice = append(slice, j)
        }
    }
}

func BenchmarkSlicePrealloc(b *testing.B) {
    for i := 0; i < b.N; i++ {
        slice := make([]int, 0, 1000)
        for j := 0; j < 1000; j++ {
            slice = append(slice, j)
        }
    }
}
```

**运行结果**:
```bash
go test -bench=. -benchmem

BenchmarkStringConcat-4         10000    123456 ns/op    56789 B/op    100 allocs/op
BenchmarkStringBuilder-4       1000000     12345 ns/op      234 B/op      1 allocs/op
BenchmarkStringBuffer-4        1000000     11234 ns/op      123 B/op      1 allocs/op

BenchmarkSliceNoPrealloc-4      50000     23456 ns/op    12345 B/op     10 allocs/op
BenchmarkSlicePrealloc-4       100000     12345 ns/op        0 B/op      0 allocs/op
```

---

### 案例 2: CPU 性能分析

```go
// cpu_profile.go
package main

import (
    "fmt"
    "os"
    "runtime/pprof"
    "time"
)

func main() {
    // 创建 CPU 分析文件
    f, err := os.Create("cpu.prof")
    if err != nil {
        panic(err)
    }
    defer f.Close()
    
    // 开始 CPU 分析
    pprof.StartCPUProfile(f)
    defer pprof.StopCPUProfile()
    
    // 执行性能敏感代码
    start := time.Now()
    result := heavyComputation(1000000)
    elapsed := time.Since(start)
    
    fmt.Printf("计算结果：%d\n", result)
    fmt.Printf("耗时：%v\n", elapsed)
}

// 模拟密集计算
func heavyComputation(n int) int {
    sum := 0
    for i := 0; i < n; i++ {
        sum += i * i
        if i%1000 == 0 {
            // 模拟一些字符串操作
            _ = fmt.Sprintf("Processing %d", i)
        }
    }
    return sum
}
```

**分析命令**:
```bash
# 运行程序
go run cpu_profile.go

# 查看分析结果
go tool pprof cpu.prof

# 交互式命令
(pprof) top          # 查看最耗时的函数
(pprof) list main    # 查看 main 包源码及耗时
(pprof) web          # 生成可视化图表（需要 graphviz）
```

---

### 案例 3: 内存性能分析

```go
// mem_profile.go
package main

import (
    "fmt"
    "os"
    "runtime"
    "runtime/pprof"
)

func main() {
    // 创建内存分析文件
    f, err := os.Create("mem.prof")
    if err != nil {
        panic(err)
    }
    defer f.Close()
    
    // 执行内存密集操作
    allocateMemory()
    
    // 强制 GC
    runtime.GC()
    
    // 写入内存分析
    pprof.WriteHeapProfile(f)
    fmt.Println("内存分析已写入 mem.prof")
}

func allocateMemory() {
    // 分配大量内存
    var slices [][]byte
    for i := 0; i < 1000; i++ {
        slice := make([]byte, 1024*1024) // 1MB
        slices = append(slices, slice)
    }
    
    // 模拟内存泄漏（不释放）
    runtime.KeepAlive(slices)
}
```

**分析命令**:
```bash
# 运行程序
go run mem_profile.go

# 查看内存分析
go tool pprof mem.prof

# 查看前 10 个最耗内存的函数
(pprof) top10

# 查看具体函数的内存分配
(pprof) list allocateMemory
```

---

### 案例 4: Goroutine 泄漏检测

```go
// goroutine_profile.go
package main

import (
    "fmt"
    "os"
    "runtime"
    "runtime/pprof"
    "time"
)

func main() {
    // 创建 Goroutine 分析文件
    f, err := os.Create("goroutine.prof")
    if err != nil {
        panic(err)
    }
    defer f.Close()
    
    // 启动一些 Goroutine
    startGoroutines()
    
    // 等待一下
    time.Sleep(2 * time.Second)
    
    // 打印 Goroutine 数量
    fmt.Printf("Goroutine 数量：%d\n", runtime.NumGoroutine())
    
    // 写入分析
    pprof.Lookup("goroutine").WriteTo(f, 0)
}

func startGoroutines() {
    // 正常的 Goroutine
    for i := 0; i < 10; i++ {
        go func(id int) {
            fmt.Printf("Goroutine %d 完成\n", id)
        }(i)
    }
    
    // 可能泄漏的 Goroutine
    for i := 0; i < 5; i++ {
        go func() {
            ch := make(chan int)
            <-ch  // 永远等待
        }()
    }
}
```

---

### 案例 5: 内存池优化

```go
// sync_pool.go
package main

import (
    "bytes"
    "fmt"
    "sync"
    "testing"
)

// 不使用内存池
func ProcessWithoutPool(data []byte) []byte {
    var buf bytes.Buffer
    buf.Grow(len(data) * 2)
    for _, b := range data {
        buf.WriteByte(b)
        buf.WriteByte(b)
    }
    return buf.Bytes()
}

// 使用内存池
var bufferPool = sync.Pool{
    New: func() interface{} {
        return new(bytes.Buffer)
    },
}

func ProcessWithPool(data []byte) []byte {
    buf := bufferPool.Get().(*bytes.Buffer)
    buf.Reset()
    defer bufferPool.Put(buf)
    
    buf.Grow(len(data) * 2)
    for _, b := range data {
        buf.WriteByte(b)
        buf.WriteByte(b)
    }
    return buf.Bytes()
}

// 基准测试
func BenchmarkProcessWithoutPool(b *testing.B) {
    data := make([]byte, 1024)
    for i := range data {
        data[i] = byte(i % 256)
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessWithoutPool(data)
    }
}

func BenchmarkProcessWithPool(b *testing.B) {
    data := make([]byte, 1024)
    for i := range data {
        data[i] = byte(i % 256)
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessWithPool(data)
    }
}
```

**运行结果**:
```
BenchmarkProcessWithoutPool-4    100000    12345 ns/op    5678 B/op    10 allocs/op
BenchmarkProcessWithPool-4       200000     6789 ns/op     234 B/op     1 allocs/op
```

---

### 案例 6: 并发性能优化

```go
// concurrent_opt.go
package main

import (
    "sync"
    "testing"
)

// 串行处理
func ProcessSequential(data []int) []int {
    result := make([]int, len(data))
    for i, v := range data {
        result[i] = heavyCalc(v)
    }
    return result
}

// 并发处理（无限制）
func ProcessUnlimited(data []int) []int {
    result := make([]int, len(data))
    var wg sync.WaitGroup
    
    for i, v := range data {
        wg.Add(1)
        go func(idx, val int) {
            defer wg.Done()
            result[idx] = heavyCalc(val)
        }(i, v)
    }
    
    wg.Wait()
    return result
}

// 并发处理（限制 Goroutine 数量）
func ProcessLimited(data []int, workers int) []int {
    result := make([]int, len(data))
    var wg sync.WaitGroup
    
    // 创建任务通道
    jobs := make(chan struct{ idx, val int }, len(data))
    
    // 启动固定数量的 Worker
    for w := 0; w < workers; w++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            for job := range jobs {
                result[job.idx] = heavyCalc(job.val)
            }
        }()
    }
    
    // 发送任务
    for i, v := range data {
        jobs <- struct{ idx, val int }{i, v}
    }
    close(jobs)
    
    wg.Wait()
    return result
}

func heavyCalc(n int) int {
    sum := 0
    for i := 0; i < 1000; i++ {
        sum += n * i
    }
    return sum
}

// 基准测试
func BenchmarkProcessSequential(b *testing.B) {
    data := make([]int, 10000)
    for i := range data {
        data[i] = i
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessSequential(data)
    }
}

func BenchmarkProcessUnlimited(b *testing.B) {
    data := make([]int, 10000)
    for i := range data {
        data[i] = i
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessUnlimited(data)
    }
}

func BenchmarkProcessLimited(b *testing.B) {
    data := make([]int, 10000)
    for i := range data {
        data[i] = i
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessLimited(data, 4)
    }
}
```

---

### 案例 7: Map 性能优化

```go
// map_opt.go
package main

import (
    "sync"
    "testing"
)

// 普通 Map + Mutex
type SafeMap struct {
    mu   sync.RWMutex
    data map[string]int
}

func NewSafeMap() *SafeMap {
    return &SafeMap{data: make(map[string]int)}
}

func (m *SafeMap) Get(key string) (int, bool) {
    m.mu.RLock()
    defer m.mu.RUnlock()
    val, ok := m.data[key]
    return val, ok
}

func (m *SafeMap) Set(key string, val int) {
    m.mu.Lock()
    defer m.mu.Unlock()
    m.data[key] = val
}

// sync.Map（适用于读多写少）
type SyncMap struct {
    data sync.Map
}

func (m *SyncMap) Get(key string) (interface{}, bool) {
    return m.data.Load(key)
}

func (m *SyncMap) Set(key string, val int) {
    m.data.Store(key, val)
}

// 基准测试 - 读多写少场景
func BenchmarkSafeMapRead(b *testing.B) {
    m := NewSafeMap()
    for i := 0; i < 1000; i++ {
        m.Set(fmt.Sprintf("key%d", i), i)
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        m.Get(fmt.Sprintf("key%d", i%1000))
    }
}

func BenchmarkSyncMapRead(b *testing.B) {
    m := &SyncMap{}
    for i := 0; i < 1000; i++ {
        m.Set(fmt.Sprintf("key%d", i), i)
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        m.Get(fmt.Sprintf("key%d", i%1000))
    }
}

// 基准测试 - 写多读少场景
func BenchmarkSafeMapWrite(b *testing.B) {
    m := NewSafeMap()
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        m.Set(fmt.Sprintf("key%d", i), i)
    }
}

func BenchmarkSyncMapWrite(b *testing.B) {
    m := &SyncMap{}
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        m.Set(fmt.Sprintf("key%d", i), i)
    }
}
```

---

### 案例 8: 字符串优化

```go
// string_opt.go
package main

import (
    "bytes"
    "fmt"
    "strings"
    "testing"
)

// 字符串拼接方式对比
func ConcatWithPlus(items []string) string {
    result := ""
    for _, item := range items {
        result += item
    }
    return result
}

func ConcatWithStringBuilder(items []string) string {
    var sb strings.Builder
    for _, item := range items {
        sb.WriteString(item)
    }
    return sb.String()
}

func ConcatWithBuffer(items []string) string {
    var buf bytes.Buffer
    for _, item := range items {
        buf.WriteString(item)
    }
    return buf.String()
}

func ConcatWithJoin(items []string) string {
    return strings.Join(items, "")
}

// 基准测试
func BenchmarkConcatWithPlus(b *testing.B) {
    items := make([]string, 100)
    for i := range items {
        items[i] = "test"
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ConcatWithPlus(items)
    }
}

func BenchmarkConcatWithStringBuilder(b *testing.B) {
    items := make([]string, 100)
    for i := range items {
        items[i] = "test"
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ConcatWithStringBuilder(items)
    }
}

func BenchmarkConcatWithBuffer(b *testing.B) {
    items := make([]string, 100)
    for i := range items {
        items[i] = "test"
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ConcatWithBuffer(items)
    }
}

func BenchmarkConcatWithJoin(b *testing.B) {
    items := make([]string, 100)
    for i := range items {
        items[i] = "test"
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ConcatWithJoin(items)
    }
}
```

**运行结果**:
```
BenchmarkConcatWithPlus-4         10000    234567 ns/op    123456 B/op    100 allocs/op
BenchmarkConcatWithStringBuilder-4    100000     12345 ns/op      234 B/op      1 allocs/op
BenchmarkConcatWithBuffer-4       100000     11234 ns/op      123 B/op      1 allocs/op
BenchmarkConcatWithJoin-4         200000      6789 ns/op       67 B/op      1 allocs/op
```

---

### 案例 9: 综合性能优化实践

```go
// optimization_practice.go
package main

import (
    "bytes"
    "fmt"
    "sort"
    "strconv"
    "sync"
    "testing"
)

// 优化前：低效的数据处理
func ProcessDataInefficient(data []int) []byte {
    result := ""
    for _, v := range data {
        result += fmt.Sprintf("%d,", v)
    }
    return []byte(result)
}

// 优化后：高效的数据处理
func ProcessDataEfficient(data []int) []byte {
    var buf bytes.Buffer
    buf.Grow(len(data) * 6) // 预分配：每个数字最多 6 字节
    
    for i, v := range data {
        if i > 0 {
            buf.WriteByte(',')
        }
        buf.WriteString(strconv.Itoa(v))
    }
    return buf.Bytes()
}

// 优化前：低效的排序
func SortInefficient(data []int) []int {
    // 创建副本
    result := make([]int, len(data))
    copy(result, data)
    
    // 冒泡排序（低效）
    for i := 0; i < len(result); i++ {
        for j := 0; j < len(result)-1-i; j++ {
            if result[j] > result[j+1] {
                result[j], result[j+1] = result[j+1], result[j]
            }
        }
    }
    return result
}

// 优化后：使用标准库排序
func SortEfficient(data []int) []int {
    result := make([]int, len(data))
    copy(result, data)
    sort.Ints(result)
    return result
}

// 优化前：并发不安全
var globalCache = make(map[string]string)

func GetFromCacheUnsafe(key string) string {
    return globalCache[key]
}

func SetToCacheUnsafe(key, value string) {
    globalCache[key] = value
}

// 优化后：并发安全
type SafeCache struct {
    mu   sync.RWMutex
    data map[string]string
}

func NewSafeCache() *SafeCache {
    return &SafeCache{data: make(map[string]string)}
}

func (c *SafeCache) Get(key string) string {
    c.mu.RLock()
    defer c.mu.RUnlock()
    return c.data[key]
}

func (c *SafeCache) Set(key, value string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    c.data[key] = value
}

// 基准测试
func BenchmarkProcessDataInefficient(b *testing.B) {
    data := make([]int, 1000)
    for i := range data {
        data[i] = i
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessDataInefficient(data)
    }
}

func BenchmarkProcessDataEfficient(b *testing.B) {
    data := make([]int, 1000)
    for i := range data {
        data[i] = i
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = ProcessDataEfficient(data)
    }
}

func BenchmarkSortInefficient(b *testing.B) {
    data := make([]int, 1000)
    for i := range data {
        data[i] = i % 100
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = SortInefficient(data)
    }
}

func BenchmarkSortEfficient(b *testing.B) {
    data := make([]int, 1000)
    for i := range data {
        data[i] = i % 100
    }
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        _ = SortEfficient(data)
    }
}
```

**优化对比**:
```
BenchmarkProcessDataInefficient-4     1000    1234567 ns/op    567890 B/op    1000 allocs/op
BenchmarkProcessDataEfficient-4      10000     123456 ns/op      6789 B/op       1 allocs/op

BenchmarkSortInefficient-4            1000    2345678 ns/op         0 B/op       0 allocs/op
BenchmarkSortEfficient-4             10000     123456 ns/op         0 B/op       0 allocs/op
```

---

## 📝 性能优化检查清单

### 字符串优化
- [ ] 使用 `strings.Builder` 或 `bytes.Buffer` 代替 `+=`
- [ ] 使用 `strings.Join` 拼接字符串切片
- [ ] 避免在循环中创建临时字符串

### 切片优化
- [ ] 预分配切片容量（`make([]T, 0, cap)`）
- [ ] 使用切片而不是频繁创建新数组
- [ ] 注意切片共享底层数组的问题

### Map 优化
- [ ] 读多写少场景使用 `sync.Map`
- [ ] 预分配 Map 容量（`make(map[K]V, size)`）
- [ ] 使用简单的键类型

### 并发优化
- [ ] 限制 Goroutine 数量（Worker Pool）
- [ ] 使用 `sync.Pool` 复用对象
- [ ] 选择合适的锁粒度

### 内存优化
- [ ] 避免不必要的内存分配
- [ ] 及时释放不用的大对象
- [ ] 使用 pprof 分析内存泄漏

---

## ✅ 学习检查清单

- [ ] 理解 Go 性能分析方法
- [ ] 掌握 pprof 性能分析工具
- [ ] 学会内存优化技巧
- [ ] 理解并发性能调优
- [ ] 掌握代码优化最佳实践
- [ ] 完成所有 9 个案例

---

**上一章**: [第 16 章 - 项目实战](./chapter_16.md)  
**下一章**: [第 18 章 - 部署与运维](./chapter_18.md)
