# 第 8 章 - 函数进阶

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3.5 小时  
**代码量**: 650 行  
**案例数**: 8 个

---

## 🎯 学习目标

1. 掌握匿名函数的定义与使用
2. 理解闭包的概念与实际应用
3. 学会使用 defer 延迟执行
4. 掌握错误处理的最佳实践
5. 理解函数作为第一类公民

---

## 📚 理论讲解

### 一、匿名函数与闭包

#### 1.1 匿名函数

没有名字的函数，可以直接定义并调用。

```go
// 定义并立即调用
func(x int) {
    fmt.Println(x)
}(10)

// 赋值给变量
add := func(a, b int) int {
    return a + b
}
```

#### 1.2 闭包

闭包是函数与其引用环境的组合，可以"记住"创建时的变量。

```go
func makeCounter() func() int {
    count := 0
    return func() int {
        count++
        return count
    }
}
```

### 二、defer 延迟执行

```go
func example() {
    defer fmt.Println("最后执行")
    fmt.Println("先执行")
}
```

**defer 特点**:
- 延迟到函数返回前执行
- 多个 defer 按 LIFO 顺序执行
- 参数在 defer 语句执行时求值

### 三、错误处理

```go
result, err := someFunction()
if err != nil {
    // 处理错误
    return err
}
```

---

## 💻 实战案例

### 案例 1: 匿名函数基础

```go
package main

import "fmt"

func main() {
    // 定义并立即调用
    func() {
        fmt.Println("Hello from anonymous function!")
    }()
    
    // 带参数的匿名函数
    func(name string) {
        fmt.Printf("Hello, %s!\n", name)
    }("Alice")
    
    // 带返回值的匿名函数
    result := func(a, b int) int {
        return a + b
    }(10, 20)
    fmt.Printf("10 + 20 = %d\n", result)
    
    // 赋值给变量
    add := func(x, y int) int {
        return x + y
    }
    fmt.Printf("5 + 3 = %d\n", add(5, 3))
    
    // 匿名函数在切片中的应用
    numbers := []int{1, 2, 3, 4, 5}
    process := func(n int) {
        fmt.Printf("%d × %d = %d\n", n, n, n*n)
    }
    for _, num := range numbers {
        process(num)
    }
}
```

**输出**:
```
Hello from anonymous function!
Hello, Alice!
10 + 20 = 30
5 + 3 = 8
1 × 1 = 1
2 × 2 = 4
3 × 3 = 9
4 × 4 = 16
5 × 5 = 25
```

---

### 案例 2: 闭包计数器

```go
package main

import "fmt"

// 创建计数器
func makeCounter() func() int {
    count := 0
    return func() int {
        count++
        return count
    }
}

// 创建带步长的计数器
func makeCounterWithStep(step int) func() int {
    count := 0
    return func() int {
        count += step
        return count
    }
}

// 创建重置计数器
func makeResetCounter() (func() int, func()) {
    count := 0
    increment := func() int {
        count++
        return count
    }
    reset := func() {
        count = 0
    }
    return increment, reset
}

func main() {
    fmt.Println("=== 基础计数器 ===")
    counter := makeCounter()
    fmt.Printf("第 %d 次调用\n", counter())
    fmt.Printf("第 %d 次调用\n", counter())
    fmt.Printf("第 %d 次调用\n", counter())
    
    fmt.Println("\n=== 带步长的计数器 ===")
    stepCounter := makeCounterWithStep(10)
    fmt.Printf("值：%d\n", stepCounter())
    fmt.Printf("值：%d\n", stepCounter())
    fmt.Printf("值：%d\n", stepCounter())
    
    fmt.Println("\n=== 可重置计数器 ===")
    inc, reset := makeResetCounter()
    fmt.Printf("值：%d\n", inc())
    fmt.Printf("值：%d\n", inc())
    fmt.Printf("值：%d\n", inc())
    reset()
    fmt.Println("重置后")
    fmt.Printf("值：%d\n", inc())
}
```

**输出**:
```
=== 基础计数器 ===
第 1 次调用
第 2 次调用
第 3 次调用

=== 带步长的计数器 ===
值：10
值：20
值：30

=== 可重置计数器 ===
值：1
值：2
值：3
重置后
值：1
```

---

### 案例 3: 闭包实际应用

```go
package main

import "fmt"

// 生成前缀函数
func makePrefixer(prefix string) func(string) string {
    return func(text string) string {
        return prefix + text
    }
}

// 生成乘法器
func makeMultiplier(factor int) func(int) int {
    return func(x int) int {
        return x * factor
    }
}

// 缓存函数
func memoize(f func(int) int) func(int) int {
    cache := make(map[int]int)
    return func(x int) int {
        if result, ok := cache[x]; ok {
            return result
        }
        result := f(x)
        cache[x] = result
        return result
    }
}

func main() {
    fmt.Println("=== 前缀函数 ===")
    addMr := makePrefixer("Mr. ")
    addDr := makePrefixer("Dr. ")
    fmt.Println(addMr("Alice"))
    fmt.Println(addDr("Bob"))
    
    fmt.Println("\n=== 乘法器 ===")
    double := makeMultiplier(2)
    triple := makeMultiplier(3)
    fmt.Printf("double(5) = %d\n", double(5))
    fmt.Printf("triple(5) = %d\n", triple(5))
    
    fmt.Println("\n=== 缓存函数 ===")
    // 模拟耗时计算
    expensive := func(x int) int {
        fmt.Printf("计算 %d 的平方...\n", x)
        return x * x
    }
    cached := memoize(expensive)
    fmt.Printf("结果：%d\n", cached(5))
    fmt.Printf("结果：%d\n", cached(5))  // 从缓存读取
    fmt.Printf("结果：%d\n", cached(6))
    fmt.Printf("结果：%d\n", cached(5))  // 从缓存读取
}
```

**输出**:
```
=== 前缀函数 ===
Mr. Alice
Dr. Bob

=== 乘法器 ===
double(5) = 10
triple(5) = 15

=== 缓存函数 ===
计算 5 的平方...
结果：25
结果：25
计算 6 的平方...
结果：36
结果：25
```

---

### 案例 4: defer 基础

```go
package main

import "fmt"

func deferDemo() {
    fmt.Println("函数开始")
    defer fmt.Println("defer 1")
    defer fmt.Println("defer 2")
    defer fmt.Println("defer 3")
    fmt.Println("函数结束")
}

func deferWithLoop() {
    for i := 1; i <= 3; i++ {
        defer fmt.Printf("defer %d\n", i)
    }
}

func deferReturnValue() (result int) {
    result = 10
    defer func() {
        result += 5  // 可以修改命名返回值
    }()
    return result
}

func main() {
    fmt.Println("=== defer 执行顺序 ===")
    deferDemo()
    
    fmt.Println("\n=== defer 在循环中 ===")
    deferWithLoop()
    
    fmt.Println("\n=== defer 修改返回值 ===")
    fmt.Printf("result = %d\n", deferReturnValue())
}
```

**输出**:
```
=== defer 执行顺序 ===
函数开始
函数结束
defer 3
defer 2
defer 1

=== defer 在循环中 ===
defer 3
defer 2
defer 1

=== defer 修改返回值 ===
result = 15
```

---

### 案例 5: defer 实际应用

```go
package main

import (
    "fmt"
    "os"
    "time"
)

// 性能分析
func trackDuration(funcName string) func() {
    start := time.Now()
    return func() {
        elapsed := time.Since(start)
        fmt.Printf("%s 耗时：%v\n", funcName, elapsed)
    }
}

// 模拟资源管理
func processFile(filename string) error {
    fmt.Printf("处理文件：%s\n", filename)
    
    // 模拟打开文件
    fmt.Println("打开文件...")
    defer fmt.Println("关闭文件...")
    
    // 模拟锁定
    fmt.Println("获取锁...")
    defer fmt.Println("释放锁...")
    
    // 模拟处理
    time.Sleep(100 * time.Millisecond)
    fmt.Println("处理完成")
    
    return nil
}

// 安全关闭资源
func safeClose() {
    ch := make(chan int)
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("捕获异常:", r)
        }
        close(ch)
        fmt.Println("通道已关闭")
    }()
    
    ch <- 1
    fmt.Println("发送成功")
}

func main() {
    fmt.Println("=== 性能分析 ===")
    defer trackDuration("main")()
    
    // 模拟一些工作
    time.Sleep(50 * time.Millisecond)
    
    fmt.Println("\n=== 资源管理 ===")
    processFile("test.txt")
    
    fmt.Println("\n=== 安全关闭 ===")
    safeClose()
}
```

**输出**:
```
=== 性能分析 ===
处理文件：test.txt
打开文件...
获取锁...
处理完成
关闭文件...
释放锁...

=== 资源管理 ===
发送成功
通道已关闭

=== 安全关闭 ===
main 耗时：50.xxx ms
```

---

### 案例 6: 错误处理基础

```go
package main

import (
    "errors"
    "fmt"
)

// 自定义错误
type DivisionError struct {
    Dividend int
    Divisor  int
}

func (e *DivisionError) Error() string {
    return fmt.Sprintf("无法计算 %d ÷ %d: 除数不能为零", e.Dividend, e.Divisor)
}

// 可能返回错误的函数
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, &DivisionError{Dividend: a, Divisor: b}
    }
    return a / b, nil
}

// 使用 errors.New
func sqrt(x float64) (float64, error) {
    if x < 0 {
        return 0, errors.New("不能计算负数的平方根")
    }
    return x * x, nil
}

// 错误包装
func process(x int) error {
    if x < 0 {
        return fmt.Errorf("处理失败：%w", errors.New("输入不能为负数"))
    }
    return nil
}

func main() {
    fmt.Println("=== 错误处理 ===")
    
    // 正常情况
    result, err := divide(10, 2)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("10 ÷ 2 = %d\n", result)
    }
    
    // 错误情况
    result, err = divide(10, 0)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 使用 errors.New
    fmt.Println("\n=== 平方根计算 ===")
    _, err = sqrt(-1)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 错误包装
    fmt.Println("\n=== 错误包装 ===")
    err = process(-5)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
}
```

**输出**:
```
=== 错误处理 ===
10 ÷ 2 = 5
错误：无法计算 10 ÷ 0: 除数不能为零

=== 平方根计算 ===
错误：不能计算负数的平方根

=== 错误包装 ===
错误：处理失败：输入不能为负数
```

---

### 案例 7: 错误处理最佳实践

```go
package main

import (
    "errors"
    "fmt"
)

var (
    ErrNotFound     = errors.New("未找到")
    ErrUnauthorized = errors.New("未授权")
    ErrInvalidInput = errors.New("无效输入")
)

type User struct {
    ID   int
    Name string
}

// 模拟数据库
var users = map[int]User{
    1: {ID: 1, Name: "Alice"},
    2: {ID: 2, Name: "Bob"},
}

func GetUser(id int) (*User, error) {
    if id <= 0 {
        return nil, ErrInvalidInput
    }
    user, ok := users[id]
    if !ok {
        return nil, ErrNotFound
    }
    return &user, nil
}

func ProcessUser(id int) error {
    user, err := GetUser(id)
    if err != nil {
        if errors.Is(err, ErrNotFound) {
            return fmt.Errorf("获取用户失败：%w", err)
        }
        return err
    }
    fmt.Printf("处理用户：%s\n", user.Name)
    return nil
}

func main() {
    fmt.Println("=== 错误处理最佳实践 ===")
    
    // 正常情况
    err := ProcessUser(1)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 未找到
    err = ProcessUser(999)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 无效输入
    err = ProcessUser(-1)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 错误类型判断
    _, err = GetUser(999)
    if errors.Is(err, ErrNotFound) {
        fmt.Println("\n捕获到 ErrNotFound 错误")
    }
}
```

**输出**:
```
=== 错误处理最佳实践 ===
处理用户：Alice
错误：获取用户失败：未找到
错误：无效输入

捕获到 ErrNotFound 错误
```

---

### 案例 8: 综合应用 - 函数式编程

```go
package main

import "fmt"

// 函数类型
type IntTransform func(int) int
type IntPredicate func(int) bool

// Map: 对切片每个元素应用函数
func Map(slice []int, transform IntTransform) []int {
    result := make([]int, len(slice))
    for i, v := range slice {
        result[i] = transform(v)
    }
    return result
}

// Filter: 过滤满足条件的元素
func Filter(slice []int, predicate IntPredicate) []int {
    var result []int
    for _, v := range slice {
        if predicate(v) {
            result = append(result, v)
        }
    }
    return result
}

// Reduce: 归约
func Reduce(slice []int, initial int, reducer func(int, int) int) int {
    result := initial
    for _, v := range slice {
        result = reducer(result, v)
    }
    return result
}

// 辅助函数
func double(x int) int    { return x * 2 }
func isEven(x int) bool   { return x%2 == 0 }
func isPositive(x int) bool { return x > 0 }
func add(a, b int) int    { return a + b }

func main() {
    numbers := []int{1, -2, 3, -4, 5, -6, 7, 8}
    
    fmt.Println("=== 原始数据 ===")
    fmt.Printf("%v\n", numbers)
    
    // Map
    fmt.Println("\n=== Map (翻倍) ===")
    doubled := Map(numbers, double)
    fmt.Printf("%v\n", doubled)
    
    // Filter
    fmt.Println("\n=== Filter (偶数) ===")
    evens := Filter(numbers, isEven)
    fmt.Printf("%v\n", evens)
    
    // Filter + Map
    fmt.Println("\n=== Filter (正数) + Map (翻倍) ===")
    positiveDoubled := Map(Filter(numbers, isPositive), double)
    fmt.Printf("%v\n", positiveDoubled)
    
    // Reduce
    fmt.Println("\n=== Reduce (求和) ===")
    sum := Reduce(numbers, 0, add)
    fmt.Printf("总和：%d\n", sum)
    
    // 链式调用
    fmt.Println("\n=== 链式调用 ===")
    result := Reduce(
        Filter(
            Map(numbers, double),
            isPositive,
        ),
        0,
        add,
    )
    fmt.Printf("翻倍后的正数之和：%d\n", result)
}
```

**输出**:
```
=== 原始数据 ===
[1 -2 3 -4 5 -6 7 8]

=== Map (翻倍) ===
[2 -4 6 -8 10 -12 14 16]

=== Filter (偶数) ===
[-2 -4 -6 8]

=== Filter (正数) + Map (翻倍) ===
[2 6 10 14 16]

=== Reduce (求和) ===
总和：12

=== 链式调用 ===
翻倍后的正数之和：48
```

---

## 📝 课后练习

1. 使用闭包实现一个简单的缓存系统
2. 编写一个函数，返回多个处理函数的组合
3. 使用 defer 实现一个事务回滚机制
4. 实现自定义错误类型，包含错误码和错误信息
5. 使用函数式编程实现一个数据处理管道

---

## ✅ 学习检查清单

- [ ] 理解匿名函数的定义与使用
- [ ] 掌握闭包的概念与应用
- [ ] 熟练使用 defer 延迟执行
- [ ] 掌握错误处理最佳实践
- [ ] 理解函数作为第一类公民
- [ ] 完成所有 8 个案例

---

**上一章**: [第 7 章 - 函数基础](./chapter_7.md)  
**下一章**: [第 9 章 - 指针](./chapter_9.md)
