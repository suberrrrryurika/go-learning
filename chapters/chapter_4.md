# 📘 第 4 章 - 控制结构：条件语句

**预计学习时长**: 2.5 小时  
**难度**: ⭐⭐ 入门进阶  
**完成日期**: _待填写_

---

## 🎯 学习目标

1. ✅ 熟练掌握 if-else 条件语句的所有用法
2. ✅ 理解并应用 if 语句中的变量作用域
3. ✅ 掌握 switch 语句的灵活用法和最佳实践
4. ✅ 能够编写清晰、高效的分支逻辑代码

---

## 📚 核心原理

### if-else 条件语句

Go 语言的 if 语句特点：
1. **条件不需要括号**
2. **花括号必须**
3. **支持初始化语句**

```go
// 基本用法
if score >= 60 {
    fmt.Println("及格")
} else {
    fmt.Println("不及格")
}

// 带初始化语句
if x := getValue(); x > 0 {
    fmt.Println("正数")
}
// 注意：x 的作用域仅限于 if-else 块内
```

### switch 语句

Go 的 switch 更灵活：
1. **自动 break**（不需要显式写）
2. **支持多条件匹配**
3. **可以省略 expression**

```go
// 基本用法
switch day {
case "Monday":
    fmt.Println("周一")
case "Tuesday", "Wednesday":
    fmt.Println("周二或周三")  // 多值匹配
default:
    fmt.Println("其他")
}

// 无 expression（类似 if-else）
switch {
case score >= 90:
    fmt.Println("优秀")
case score >= 60:
    fmt.Println("及格")
}
```

---

## 💻 生产级代码示例

### 示例 1: 用户权限验证

```go
package main

import (
    "errors"
    "fmt"
    "time"
)

type UserRole int

const (
    Guest UserRole = iota
    Member
    Admin
)

type User struct {
    ID       int
    Name     string
    Role     UserRole
    IsActive bool
}

func checkPermission(user *User, action string) error {
    if user == nil {
        return errors.New("用户不存在")
    }
    
    if !user.IsActive {
        return errors.New("账号未激活")
    }
    
    switch action {
    case "read":
        return nil
    case "write":
        if user.Role >= Member {
            return nil
        }
    case "admin":
        if user.Role == Admin {
            return nil
        }
    }
    
    return errors.New("权限不足")
}

func main() {
    user := &User{
        ID:       1,
        Name:     "Alice",
        Role:     Member,
        IsActive: true,
    }
    
    if err := checkPermission(user, "write"); err != nil {
        fmt.Printf("❌ 失败：%v\n", err)
    } else {
        fmt.Println("✅ 成功")
    }
}
```

### 示例 2: HTTP 路由器

```go
package main

import (
    "fmt"
    "net/http"
    "strings"
)

func handler(w http.ResponseWriter, r *http.Request) {
    switch r.Method {
    case http.MethodGet:
        handleGet(w, r)
    case http.MethodPost:
        handlePost(w, r)
    default:
        http.Error(w, "不支持", 405)
    }
}

func handleGet(w http.ResponseWriter, r *http.Request) {
    switch {
    case r.URL.Path == "/api/users":
        fmt.Fprintln(w, "用户列表")
    case strings.HasPrefix(r.URL.Path, "/api/users/"):
        fmt.Fprintln(w, "用户详情")
    default:
        http.Error(w, "未找到", 404)
    }
}

func handlePost(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "创建用户")
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("服务器启动在 :8080")
    http.ListenAndServe(":8080", nil)
}
```

### 示例 3: 订单状态机

```go
package main

import "fmt"

type OrderStatus int

const (
    Created OrderStatus = iota
    Paid
    Shipped
    Delivered
)

func (s OrderStatus) String() string {
    names := []string{"已创建", "已支付", "已发货", "已送达"}
    return names[s]
}

type Order struct {
    ID     string
    Status OrderStatus
}

func (o *Order) Pay() error {
    if o.Status != Created {
        return fmt.Errorf("无效状态：%s", o.Status)
    }
    o.Status = Paid
    return nil
}

func (o *Order) Ship() error {
    if o.Status != Paid {
        return fmt.Errorf("无效状态：%s", o.Status)
    }
    o.Status = Shipped
    return nil
}

func main() {
    order := &Order{ID: "ORD-001", Status: Created}
    
    order.Pay()
    fmt.Printf("订单状态：%s\n", order.Status)
    
    order.Ship()
    fmt.Printf("订单状态：%s\n", order.Status)
}
```

---

## ⚠️ 常见坑点

### 1. if 初始化变量作用域

```go
// ❌ 错误
if x := 10; x > 0 {
    fmt.Println(x)
}
fmt.Println(x)  // 编译错误：x 未定义

// ✅ 正确
x := 10
if x > 0 {
    fmt.Println(x)
}
```

### 2. switch 不会自动穿透

```go
// Go 的 switch 默认 break
n := 1
switch n {
case 1:
    fmt.Println("1")  // 只输出这行
case 2:
    fmt.Println("2")
}

// 需要穿透时显式声明
switch n {
case 1:
    fmt.Println("1")
    fallthrough  // 显式穿透
case 2:
    fmt.Println("2")  // 现在会输出
}
```

### 3. 指针 nil 检查

```go
// ❌ 危险
func process(cfg *Config) {
    if cfg.Timeout > 10 {  // cfg 可能是 nil
        // ...
    }
}

// ✅ 正确
func process(cfg *Config) {
    if cfg == nil {
        return
    }
    if cfg.Timeout > 10 {
        // ...
    }
}
```

---

## ✅ 学习检查清单

- [ ] 掌握 if-else 所有用法
- [ ] 理解 if 初始化语句作用域
- [ ] 熟练使用 switch
- [ ] 理解自动 break 特性
- [ ] 完成所有代码练习

---

**恭喜完成第 4 章！** 🎉

**进度**: 4/90 (4%)
