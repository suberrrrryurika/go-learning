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

---

## 📚 理论讲解

### 一、Map 基础

#### 1.1 什么是 Map

Map 是**无序的键值对集合**，通过键（key）可以快速访问对应的值（value）。

```go
// 声明方式
var m1 map[string]int              // 声明（nil，需要 make）
m2 := make(map[string]int)         // 创建
m3 := map[string]int{"a": 1}       // 字面量
```

**Map 特点**:
- 键唯一，不能重复
- 无序遍历（随机顺序）
- 引用类型
- 键必须是可比较类型

### 二、常用操作

```go
// 添加/修改
m["key"] = value

// 查询
val := m["key"]

// 检查键是否存在
val, ok := m["key"]

// 删除
delete(m, "key")

// 长度
len(m)
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
    fmt.Printf("scores: %v\n", scores)
    
    // 查询
    fmt.Println("\n=== 查询成绩 ===")
    fmt.Printf("Alice: %d\n", scores["Alice"])
    fmt.Printf("Bob: %d\n", scores["Bob"])
    
    // 修改
    scores["Alice"] = 98
    fmt.Printf("\n修改后 Alice: %d\n", scores["Alice"])
    
    // 删除
    delete(scores, "Bob")
    fmt.Printf("删除 Bob 后：%v\n", scores)
    
    // 长度
    fmt.Printf("学生数量：%d\n", len(scores))
}
```

**输出**:
```
=== 初始成绩 ===
scores: map[Alice:95 Bob:87 Carol:92]

=== 查询成绩 ===
Alice: 95
Bob: 87

修改后 Alice: 98
删除 Bob 后：map[Alice:98 Carol:92]
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
    
    // 直接访问（零值危险）
    fmt.Println("=== 直接访问 ===")
    fmt.Printf("Alice: %d\n", ages["Alice"])
    fmt.Printf("Carol: %d (零值)\n", ages["Carol"])
    
    // 双值赋值（推荐）
    fmt.Println("\n=== 双值赋值检查 ===")
    if age, ok := ages["Alice"]; ok {
        fmt.Printf("Alice 存在，年龄：%d\n", age)
    }
    
    if age, ok := ages["Carol"]; ok {
        fmt.Printf("Carol 存在，年龄：%d\n", age)
    } else {
        fmt.Println("Carol 不存在")
    }
    
    // 只检查存在性
    if _, exists := ages["Bob"]; exists {
        fmt.Println("\nBob 在 Map 中")
    }
}
```

**输出**:
```
=== 直接访问 ===
Alice: 25
Carol: 0 (零值)

=== 双值赋值检查 ===
Alice 存在，年龄：25
Carol 不存在

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

func wordFrequency(text string) map[string]int {
    freq := make(map[string]int)
    words := strings.Fields(strings.ToLower(text))
    
    for _, word := range words {
        word = strings.Trim(word, ".,!?;:\"'")
        if word != "" {
            freq[word]++
        }
    }
    return freq
}

func main() {
    text := `Go is an open source programming language.
    Go makes it easy to build simple and efficient software.`
    
    freq := wordFrequency(text)
    
    fmt.Println("=== 词频统计 ===")
    for word, count := range freq {
        fmt.Printf("%-10s: %d\n", word, count)
    }
    
    // 高频词汇
    fmt.Println("\n=== 高频词汇 (>=2 次) ===")
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
go          : 2
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
and         : 1
efficient   : 1
software    : 1

=== 高频词汇 (>=2 次) ===
go          : 2 次
is          : 2 次
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

func main() {
    book := make(map[string]Contact)
    
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
    
    // 查询
    fmt.Println("=== 查询联系人 ===")
    if contact, ok := book["Alice"]; ok {
        fmt.Printf("姓名：%s\n", contact.Name)
        fmt.Printf("电话：%s\n", contact.Phone)
    }
    
    // 遍历（排序）
    fmt.Println("\n=== 所有联系人 ===")
    var names []string
    for name := range book {
        names = append(names, name)
    }
    sort.Strings(names)
    
    for _, name := range names {
        contact := book[name]
        fmt.Printf("%-8s | %-20s\n", name, contact.Phone)
    }
}
```

**输出**:
```
=== 查询联系人 ===
姓名：Alice Smith
电话：138-0001-0001

=== 所有联系人 ===
Alice    | 138-0001-0001
Bob      | 138-0002-0002
```

---

### 案例 5: 配置管理器

```go
package main

import "fmt"

type Config map[string]interface{}

func main() {
    // 创建配置
    config := Config{
        "app_name": "MyApp",
        "version":  "1.0.0",
        "debug":    true,
        "max_conn": 100,
    }
    
    // 读取配置
    fmt.Println("=== 读取配置 ===")
    fmt.Printf("应用名称：%v\n", config["app_name"])
    fmt.Printf("版本号：%v\n", config["version"])
    fmt.Printf("调试模式：%v\n", config["debug"])
    
    // 类型断言
    fmt.Println("\n=== 类型断言 ===")
    if name, ok := config["app_name"].(string); ok {
        fmt.Printf("应用名称：%s\n", name)
    }
    
    if debug, ok := config["debug"].(bool); ok {
        if debug {
            fmt.Println("调试模式：已启用")
        }
    }
    
    // 修改配置
    config["version"] = "1.1.0"
    config["new_feature"] = "enabled"
    
    // 检查配置
    fmt.Println("\n=== 配置检查 ===")
    keys := []string{"version", "timeout", "new_feature"}
    for _, key := range keys {
        if _, exists := config[key]; exists {
            fmt.Printf("✓ %s 存在\n", key)
        } else {
            fmt.Printf("✗ %s 不存在\n", key)
        }
    }
}
```

**输出**:
```
=== 读取配置 ===
应用名称：MyApp
版本号：1.0.0
调试模式：true

=== 类型断言 ===
应用名称：MyApp
调试模式：已启用

=== 配置检查 ===
✓ version 存在
✗ timeout 不存在
✓ new_feature 存在
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

type Cache struct {
    mu    sync.RWMutex
    items map[string]CacheItem
}

type CacheItem struct {
    Value      interface{}
    Expiration time.Time
}

func NewCache() *Cache {
    return &Cache{items: make(map[string]CacheItem)}
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
    if !exists || time.Now().After(item.Expiration) {
        return nil, false
    }
    return item.Value, true
}

func main() {
    cache := NewCache()
    
    // 添加缓存
    cache.Set("user:1", "Alice", 5*time.Second)
    cache.Set("user:2", "Bob", 10*time.Second)
    
    // 读取缓存
    fmt.Println("=== 读取缓存 ===")
    if value, ok := cache.Get("user:1"); ok {
        fmt.Printf("user:1 = %v\n", value)
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
}
```

**输出**:
```
=== 读取缓存 ===
user:1 = Alice

=== 等待 6 秒后 ===
user:1 已过期
user:2 = Bob
```

---

### 案例 7: 用户权限管理

```go
package main

import "fmt"

type Permission string

const (
    READ   Permission = "read"
    WRITE  Permission = "write"
    DELETE Permission = "delete"
    ADMIN  Permission = "admin"
)

type User struct {
    ID          int
    Name        string
    Permissions []Permission
}

func hasPermission(user User, perm Permission) bool {
    for _, p := range user.Permissions {
        if p == perm {
            return true
        }
    }
    return false
}

func main() {
    // 创建用户
    users := map[int]User{
        1: {ID: 1, Name: "Alice", Permissions: []Permission{READ, WRITE}},
        2: {ID: 2, Name: "Bob", Permissions: []Permission{READ}},
        3: {ID: 3, Name: "Carol", Permissions: []Permission{READ, WRITE, DELETE, ADMIN}},
    }
    
    // 权限检查
    fmt.Println("=== 权限检查 ===")
    checkPermission(users, 1, WRITE)
    checkPermission(users, 1, ADMIN)
    checkPermission(users, 3, ADMIN)
    
    // 列出所有用户
    fmt.Println("\n=== 用户权限列表 ===")
    for id, user := range users {
        fmt.Printf("%-8s (ID:%d): %v\n", user.Name, id, user.Permissions)
    }
    
    // 查找具有 WRITE 权限的用户
    fmt.Println("\n=== 具有 WRITE 权限的用户 ===")
    for _, user := range users {
        if hasPermission(user, WRITE) {
            fmt.Printf("✓ %s\n", user.Name)
        }
    }
}

func checkPermission(users map[int]User, userID int, perm Permission) {
    user, exists := users[userID]
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
```

---

## 📝 课后练习

1. 实现一个 Map 反转函数（键值互换）
2. 实现两个 Map 的合并函数
3. 编写函数找出 Map 中值最大的键
4. 实现一个简单的缓存系统（带过期时间）

---

## ✅ 学习检查清单

- [ ] 理解 Map 的声明与初始化
- [ ] 掌握 Map 的增删改查
- [ ] 会用双值赋值检查键存在性
- [ ] 理解 Map 的遍历方式
- [ ] 掌握嵌套 Map 的使用
- [ ] 完成所有 7 个案例

---

**上一章**: [第 5 章 - 数组与切片](./chapter_5.md)  
**下一章**: [第 7 章 - 函数基础](./chapter_7.md)
