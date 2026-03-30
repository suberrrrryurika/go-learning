# 第 6 章 - Map 集合

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 2.5 小时  
**代码量**: 500 行  
**案例数**: 7 个

---

## 🎯 学习目标

1. 理解 Map 的定义与特性
2. 掌握 Map 的创建、初始化方式
3. 熟练使用 Map 的增删改查操作
4. 学会遍历 Map 的多种方法
5. 理解 Map 与切片的区别和应用场景
6. 掌握嵌套 Map 的使用

---

## 📚 理论讲解

### 一、Map 基础概念

#### 1.1 什么是 Map

Map 是一种**无序的键值对集合**，通过键（key）可以快速访问对应的值（value）。

**Map 的特点**:
- **键值对存储**: 每个元素由键和值组成
- **键唯一**: 同一个 Map 中键不能重复
- **无序性**: 遍历顺序不固定（Go 1.3+ 随机化）
- **引用类型**: Map 是引用类型，传递的是引用
- **动态增长**: 自动扩容，无需指定大小

**常见用途**:
- 字典/词典
- 缓存系统
- 配置管理
- 数据索引
- 计数统计

#### 1.2 Map 的声明与初始化

```go
// 方式 1: 使用 make 创建
var m1 map[string]int
m1 = make(map[string]int)

// 方式 2: make 时指定初始容量
m2 := make(map[string]int, 100)

// 方式 3: 字面量初始化
m3 := map[string]int{
    "Alice": 25,
    "Bob":   30,
    "Carol": 28,
}

// 方式 4: 空 Map
m4 := map[string]int{}
```

⚠️ **重要**: 声明但未初始化的 Map 是 `nil`，不能直接赋值，需要先 `make`！

```go
var m map[string]int  // m 是 nil
m["key"] = 1          // ❌ panic: assignment to entry in nil map

m = make(map[string]int)
m["key"] = 1          // ✅ 正确
```

---

## 💻 实战案例

### 案例 1: Map 基础操作

```go
package main

import "fmt"

func main() {
    // 创建 Map
    scores := make(map[string]int)
    
    // 添加元素
    scores["Alice"] = 95
    scores["Bob"] = 87
    scores["Carol"] = 92
    
    fmt.Println("=== 初始成绩 ===")
    fmt.Println(scores)
    
    // 查询元素
    fmt.Println("\n=== 查询成绩 ===")
    fmt.Printf("Alice: %d\n", scores["Alice"])
    fmt.Printf("Bob: %d\n", scores["Bob"])
    
    // 修改元素
    scores["Alice"] = 98
    fmt.Println("\n=== 修改后 ===")
    fmt.Printf("Alice: %d\n", scores["Alice"])
    
    // 删除元素
    delete(scores, "Bob")
    fmt.Println("\n=== 删除 Bob 后 ===")
    fmt.Println(scores)
    
    // 获取 Map 长度
    fmt.Printf("\n学生数量：%d\n", len(scores))
}
```

**输出**:
```
=== 初始成绩 ===
map[Alice:95 Bob:87 Carol:92]

=== 查询成绩 ===
Alice: 95
Bob: 87

=== 修改后 ===
Alice: 98

=== 删除 Bob 后 ===
map[Alice:98 Carol:92]

学生数量：2
```

---

### 案例 2: 检查键是否存在

```go
package main

import "fmt"

func main() {
    ages := map[string]int{
        "Alice": 25,
        "Bob":   30,
    }
    
    // 方式 1: 直接访问（零值危险）
    fmt.Println("=== 直接访问 ===")
    fmt.Printf("Alice: %d\n", ages["Alice"])  // 25
    fmt.Printf("Carol: %d\n", ages["Carol"])  // 0 (零值！)
    
    // 方式 2: 双值赋值（推荐）
    fmt.Println("\n=== 双值赋值检查 ===")
    if age, ok := ages["Alice"]; ok {
        fmt.Printf("Alice 存在，年龄：%d\n", age)
    } else {
        fmt.Println("Alice 不存在")
    }
    
    if age, ok := ages["Carol"]; ok {
        fmt.Printf("Carol 存在，年龄：%d\n", age)
    } else {
        fmt.Println("Carol 不存在")
    }
    
    // 方式 3: 只检查存在性
    fmt.Println("\n=== 只检查存在性 ===")
    if _, exists := ages["Bob"]; exists {
        fmt.Println("Bob 在 Map 中")
    }
}
```

**输出**:
```
=== 直接访问 ===
Alice: 25
Carol: 0

=== 双值赋值检查 ===
Alice 存在，年龄：25
Carol 不存在

=== 只检查存在性 ===
Bob 在 Map 中
```

---

### 案例 3: 词频统计

```go
package main

import (
    "fmt"
    "strings"
)

// 统计单词出现频率
func wordFrequency(text string) map[string]int {
    freq := make(map[string]int)
    
    // 转换为小写并分割
    words := strings.Fields(strings.ToLower(text))
    
    for _, word := range words {
        // 去除标点符号
        word = strings.Trim(word, ".,!?;:\"'")
        if word != "" {
            freq[word]++
        }
    }
    
    return freq
}

func main() {
    text := `Go is an open source programming language.
    Go makes it easy to build simple, reliable, and efficient software.
    Go is statically typed and produces compiled machine code.`
    
    freq := wordFrequency(text)
    
    fmt.Println("=== 词频统计 ===")
    for word, count := range freq {
        fmt.Printf("%-10s: %d\n", word, count)
    }
    
    // 找出出现次数最多的词
    fmt.Println("\n=== 高频词汇 ===")
    for word, count := range freq {
        if count >= 2 {
            fmt.Printf("%-10s: %d 次\n", word, count)
        }
    }
}
```

**输出**:
```
=== 词频统计 ===
go          : 3
is          : 2
an          : 1
open        : 1
source      : 1
programming : 1
language    : 1
makes       : 1
it          : 1
easy        : 1
to          : 1
build       : 1
simple      : 1
reliable    : 1
and         : 2
efficient   : 1
software    : 1
statically  : 1
typed       : 1
produces    : 1
compiled    : 1
machine     : 1
code        : 1

=== 高频词汇 ===
go          : 3 次
is          : 2 次
and         : 2 次
```

---

### 案例 4: 电话簿管理系统

```go
package main

import (
    "fmt"
    "sort"
)

type Contact struct {
    Name  string
    Phone string
    Email string
}

type PhoneBook map[string]Contact

func main() {
    book := make(PhoneBook)
    
    // 添加联系人
    book["Alice"] = Contact{
        Name:  "Alice Smith",
        Phone: "138-0001-0001",
        Email: "alice@example.com",
    }
    book["Bob"] = Contact{
        Name:  "Bob Johnson",
        Phone: "138-0002-0002",
        Email: "bob@example.com",
    }
    book["Carol"] = Contact{
        Name:  "Carol Williams",
        Phone: "138-0003-0003",
        Email: "carol@example.com",
    }
    
    // 查询联系人
    fmt.Println("=== 查询联系人 ===")
    if contact, ok := book["Alice"]; ok {
        fmt.Printf("姓名：%s\n", contact.Name)
        fmt.Printf("电话：%s\n", contact.Phone)
        fmt.Printf("邮箱：%s\n", contact.Email)
    }
    
    // 遍历所有联系人
    fmt.Println("\n=== 所有联系人 ===")
    
    // 按名字排序
    var names []string
    for name := range book {
        names = append(names, name)
    }
    sort.Strings(names)
    
    for _, name := range names {
        contact := book[name]
        fmt.Printf("%-8s | %-20s | %-15s\n", 
            name, contact.Name, contact.Phone)
    }
    
    // 删除联系人
    delete(book, "Bob")
    fmt.Println("\n=== 删除 Bob 后 ===")
    fmt.Printf("剩余联系人：%d\n", len(book))
}
```

**输出**:
```
=== 查询联系人 ===
姓名：Alice Smith
电话：138-0001-0001
邮箱：alice@example.com

=== 所有联系人 ===
Alice    | Alice Smith          | 138-0001-0001
Bob      | Bob Johnson          | 138-0002-0002
Carol    | Carol Williams       | 138-0003-0003

=== 删除 Bob 后 ===
剩余联系人：2
```

---

### 案例 5: 配置管理器

```go
package main

import (
    "fmt"
    "os"
)

// 配置类型
type Config map[string]interface{}

func main() {
    // 创建配置
    config := Config{
        "app_name":    "MyApp",
        "version":     "1.0.0",
        "debug":       true,
        "max_conn":    100,
        "timeout":     30.5,
        "allowed_ips": []string{"127.0.0.1", "192.168.1.1"},
    }
    
    // 读取配置
    fmt.Println("=== 读取配置 ===")
    fmt.Printf("应用名称：%v\n", config["app_name"])
    fmt.Printf("版本号：%v\n", config["version"])
    fmt.Printf("调试模式：%v\n", config["debug"])
    fmt.Printf("最大连接：%v\n", config["max_conn"])
    
    // 类型断言
    fmt.Println("\n=== 类型断言 ===")
    if name, ok := config["app_name"].(string); ok {
        fmt.Printf("应用名称 (string): %s\n", name)
    }
    
    if debug, ok := config["debug"].(bool); ok {
        if debug {
            fmt.Println("调试模式已启用")
        }
    }
    
    // 修改配置
    config["version"] = "1.1.0"
    config["new_feature"] = "enabled"
    
    // 删除配置
    delete(config, "timeout")
    
    // 检查配置是否存在
    fmt.Println("\n=== 配置检查 ===")
    keys := []string{"version", "timeout", "new_feature"}
    for _, key := range keys {
        if _, exists := config[key]; exists {
            fmt.Printf("✓ %s 存在\n", key)
        } else {
            fmt.Printf("✗ %s 不存在\n", key)
        }
    }
    
    // 模拟从环境变量读取
    fmt.Println("\n=== 环境变量覆盖 ===")
    if envDebug := os.Getenv("DEBUG"); envDebug != "" {
        config["debug"] = envDebug == "true"
        fmt.Printf("DEBUG 环境变量：%s\n", envDebug)
    }
}
```

**输出**:
```
=== 读取配置 ===
应用名称：MyApp
版本号：1.0.0
调试模式：true
最大连接：100

=== 类型断言 ===
应用名称 (string): MyApp
调试模式已启用

=== 配置检查 ===
✓ version 存在
✗ timeout 不存在
✓ new_feature 存在

=== 环境变量覆盖 ===
```

---

### 案例 6: 缓存系统

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

// 线程安全的缓存
type Cache struct {
    mu    sync.RWMutex
    items map[string]CacheItem
}

type CacheItem struct {
    Value      interface{}
    Expiration time.Time
}

func NewCache() *Cache {
    return &Cache{
        items: make(map[string]CacheItem),
    }
}

func (c *Cache) Set(key string, value interface{}, duration time.Duration) {
    c.mu.Lock()
    defer c.mu.Unlock()
    
    c.items[key] = CacheItem{
        Value:      value,
        Expiration: time.Now().Add(duration),
    }
}

func (c *Cache) Get(key string) (interface{}, bool) {
    c.mu.RLock()
    defer c.mu.RUnlock()
    
    item, exists := c.items[key]
    if !exists {
        return nil, false
    }
    
    // 检查是否过期
    if time.Now().After(item.Expiration) {
        return nil, false
    }
    
    return item.Value, true
}

func (c *Cache) Delete(key string) {
    c.mu.Lock()
    defer c.mu.Unlock()
    delete(c.items, key)
}

func (c *Cache) Clean() int {
    c.mu.Lock()
    defer c.mu.Unlock()
    
    count := 0
    now := time.Now()
    for key, item := range c.items {
        if now.After(item.Expiration) {
            delete(c.items, key)
            count++
        }
    }
    return count
}

func main() {
    cache := NewCache()
    
    // 添加缓存项
    cache.Set("user:1", "Alice", 5*time.Second)
    cache.Set("user:2", "Bob", 10*time.Second)
    cache.Set("config", "production", 30*time.Second)
    
    // 读取缓存
    fmt.Println("=== 读取缓存 ===")
    if value, ok := cache.Get("user:1"); ok {
        fmt.Printf("user:1 = %v\n", value)
    }
    
    if value, ok := cache.Get("user:2"); ok {
        fmt.Printf("user:2 = %v\n", value)
    }
    
    // 等待过期
    fmt.Println("\n=== 等待 6 秒后 ===")
    time.Sleep(6 * time.Second)
    
    if value, ok := cache.Get("user:1"); ok {
        fmt.Printf("user:1 = %v\n", value)
    } else {
        fmt.Println("user:1 已过期")
    }
    
    if value, ok := cache.Get("user:2"); ok {
        fmt.Printf("user:2 = %v\n", value)
    }
    
    // 清理过期项
    cleaned := cache.Clean()
    fmt.Printf("\n清理了 %d 个过期项\n", cleaned)
}
```

**输出**:
```
=== 读取缓存 ===
user:1 = Alice
user:2 = Bob

=== 等待 6 秒后 ===
user:1 已过期
user:2 = Bob

清理了 1 个过期项
```

---

### 案例 7: 用户权限管理系统

```go
package main

import (
    "fmt"
    "sort"
)

// 权限系统
type Permission string

const (
    READ    Permission = "read"
    WRITE   Permission = "write"
    DELETE  Permission = "delete"
    ADMIN   Permission = "admin"
)

type User struct {
    ID          int
    Name        string
    Permissions []Permission
}

type PermissionSystem map[int]User

func main() {
    system := make(PermissionSystem)
    
    // 添加用户
    system[1] = User{
        ID:          1,
        Name:        "Alice",
        Permissions: []Permission{READ, WRITE},
    }
    system[2] = User{
        ID:          2,
        Name:        "Bob",
        Permissions: []Permission{READ},
    }
    system[3] = User{
        ID:          3,
        Name:        "Carol",
        Permissions: []Permission{READ, WRITE, DELETE, ADMIN},
    }
    
    // 检查权限
    fmt.Println("=== 权限检查 ===")
    checkPermission(system, 1, WRITE)
    checkPermission(system, 1, ADMIN)
    checkPermission(system, 3, ADMIN)
    
    // 列出所有用户及其权限
    fmt.Println("\n=== 用户权限列表 ===")
    var ids []int
    for id := range system {
        ids = append(ids, id)
    }
    sort.Ints(ids)
    
    for _, id := range ids {
        user := system[id]
        fmt.Printf("%-8s (ID:%d): %v\n", 
            user.Name, user.ID, user.Permissions)
    }
    
    // 查找具有特定权限的用户
    fmt.Println("\n=== 具有 WRITE 权限的用户 ===")
    for _, user := range system {
        if hasPermission(user, WRITE) {
            fmt.Printf("✓ %s\n", user.Name)
        }
    }
    
    // 删除用户
    delete(system, 2)
    fmt.Printf("\n删除 Bob 后，剩余用户：%d\n", len(system))
}

func hasPermission(user User, perm Permission) bool {
    for _, p := range user.Permissions {
        if p == perm {
            return true
        }
    }
    return false
}

func checkPermission(system PermissionSystem, userID int, perm Permission) {
    user, exists := system[userID]
    if !exists {
        fmt.Printf("用户 %d 不存在\n", userID)
        return
    }
    
    if hasPermission(user, perm) {
        fmt.Printf("✓ %s 拥有 %s 权限\n", user.Name, perm)
    } else {
        fmt.Printf("✗ %s 没有 %s 权限\n", user.Name, perm)
    }
}
```

**输出**:
```
=== 权限检查 ===
✓ Alice 拥有 write 权限
✗ Alice 没有 admin 权限
✓ Carol 拥有 admin 权限

=== 用户权限列表 ===
Alice    (ID:1): [read write]
Bob      (ID:2): [read]
Carol    (ID:3): [read write delete admin]

=== 具有 WRITE 权限的用户 ===
✓ Alice
✓ Carol

删除 Bob 后，剩余用户：2
```

---

## 📝 课后练习

1. 实现一个 Map 反转函数（键值互换）
2. 实现两个 Map 的合并函数
3. 编写一个函数，找出 Map 中值最大的键
4. 实现一个简单的 JSON 解析器（将 JSON 解析为 nested map）

---

## ✅ 学习检查清单

- [ ] 理解 Map 的声明与初始化
- [ ] 掌握 Map 的增删改查
- [ ] 会用双值赋值检查键存在性
- [ ] 理解 Map 的遍历方式
- [ ] 区分 Map 与切片的使用场景
- [ ] 掌握嵌套 Map 的使用
- [ ] 完成所有 7 个案例

---

**上一章**: [第 5 章 - 循环结构](./chapter_5.md)  
**下一章**: [第 7 章 - 函数基础](./chapter_7.md)
