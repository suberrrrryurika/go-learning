# 第 12 章 - 接口

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 4 小时  
**代码量**: 700 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 理解接口的定义与实现
2. 掌握接口的隐式实现
3. 学会使用空接口和类型断言
4. 理解接口组合与继承
5. 掌握接口的实际应用

---

## 📚 理论讲解

### 一、接口基础

#### 1.1 什么是接口

接口是**方法的集合**，定义了一组行为规范。

```go
type Speaker interface {
    Speak()
}
```

#### 1.2 隐式实现

Go 语言的接口是**隐式实现**的，不需要显式声明。

```go
type Person struct{}

func (p Person) Speak() {
    fmt.Println("Hello")
}

// Person 自动实现 Speaker 接口
var s Speaker = Person{}  // ✓
```

### 二、特殊接口

| 接口 | 说明 | 示例 |
|------|------|------|
| `interface{}` | 空接口，可存储任何类型 | `var v interface{}` |
| `error` | 错误接口 | `func() error` |
| `Stringer` | 字符串表示 | `fmt.Stringer` |

---

## 💻 实战案例

### 案例 1: 接口基础

```go
package main

import "fmt"

// 定义接口
type Speaker interface {
    Speak()
}

// 实现接口的结构体
type Person struct {
    Name string
}

func (p Person) Speak() {
    fmt.Printf("Hello, I'm %s\n", p.Name)
}

type Dog struct {
    Name string
}

func (d Dog) Speak() {
    fmt.Printf("%s: Woof! Woof!\n", d.Name)
}

// 使用接口作为参数
func MakeSpeak(s Speaker) {
    s.Speak()
}

func main() {
    p := Person{Name: "Alice"}
    d := Dog{Name: "旺财"}
    
    fmt.Println("=== 接口调用 ===")
    MakeSpeak(p)
    MakeSpeak(d)
    
    // 接口变量
    fmt.Println("\n=== 接口变量 ===")
    var s Speaker
    s = p
    s.Speak()
    s = d
    s.Speak()
}
```

**输出**:
```
=== 接口调用 ===
Hello, I'm Alice
旺财：Woof! Woof!

=== 接口变量 ===
Hello, I'm Alice
旺财：Woof! Woof!
```

---

### 案例 2: 多接口实现

```go
package main

import "fmt"

type Speaker interface {
    Speak()
}

type Mover interface {
    Move()
}

type Runner interface {
    Run()
}

// 实现多个接口
type SuperHero struct {
    Name string
}

func (s SuperHero) Speak() {
    fmt.Printf("%s: I'm a hero!\n", s.Name)
}

func (s SuperHero) Move() {
    fmt.Printf("%s is moving\n", s.Name)
}

func (s SuperHero) Run() {
    fmt.Printf("%s is running fast!\n", s.Name)
}

func main() {
    hero := SuperHero{Name: "Superman"}
    
    // 可以赋值给任何实现的接口
    var s Speaker = hero
    var m Mover = hero
    var r Runner = hero
    
    s.Speak()
    m.Move()
    r.Run()
}
```

**输出**:
```
Superman: I'm a hero!
Superman is moving
Superman is running fast!
```

---

### 案例 3: 接口组合

```go
package main

import "fmt"

type Flyer interface {
    Fly()
}

type Swimmer interface {
    Swim()
}

// 组合接口
type SuperAnimal interface {
    Flyer
    Swimmer
    Speak()
}

type Duck struct {
    Name string
}

func (d Duck) Fly() {
    fmt.Printf("%s is flying\n", d.Name)
}

func (d Duck) Swim() {
    fmt.Printf("%s is swimming\n", d.Name)
}

func (d Duck) Speak() {
    fmt.Printf("%s: Quack!\n", d.Name)
}

func main() {
    duck := Duck{Name: "唐老鸭"}
    
    //  Duck 实现 SuperAnimal 接口
    var sa SuperAnimal = duck
    sa.Fly()
    sa.Swim()
    sa.Speak()
}
```

**输出**:
```
唐老鸭 is flying
唐老鸭 is swimming
唐老鸭：Quack!
```

---

### 案例 4: 空接口

```go
package main

import "fmt"

// 空接口可以存储任何类型
func PrintAny(v interface{}) {
    fmt.Printf("值：%v, 类型：%T\n", v, v)
}

// 空接口切片
func PrintAll(items ...interface{}) {
    for i, item := range items {
        fmt.Printf("[%d] %v (类型：%T)\n", i, item, item)
    }
}

// 存储不同类型
func main() {
    fmt.Println("=== 空接口 ===")
    PrintAny(42)
    PrintAny("Hello")
    PrintAny(3.14)
    PrintAny(true)
    PrintAny([]int{1, 2, 3})
    
    fmt.Println("\n=== 空接口切片 ===")
    PrintAll(1, "two", 3.0, false)
    
    // 通用容器
    fmt.Println("\n=== 通用容器 ===")
    var container []interface{}
    container = append(container, 1)
    container = append(container, "hello")
    container = append(container, 3.14)
    
    for _, v := range container {
        fmt.Printf("%v (%T)\n", v, v)
    }
}
```

**输出**:
```
=== 空接口 ===
值：42, 类型：int
值：Hello, 类型：string
值：3.14, 类型：float64
值：true, 类型：bool
值：[1 2 3], 类型：[]int

=== 空接口切片 ===
[0] 1 (类型：int)
[1] two (类型：string)
[2] 3 (类型：float64)
[3] false (类型：bool)

=== 通用容器 ===
1 (int)
hello (string)
3.14 (float64)
```

---

### 案例 5: 类型断言

```go
package main

import "fmt"

func main() {
    var v interface{}
    
    // 存储不同类型
    v = 42
    v = "Hello"
    v = 3.14
    
    // 类型断言
    fmt.Println("=== 类型断言 ===")
    
    // 安全断言（双值）
    if str, ok := v.(string); ok {
        fmt.Printf("是字符串：%s\n", str)
    } else {
        fmt.Println("不是字符串")
    }
    
    // 直接断言（可能 panic）
    // num := v.(int)  // 如果 v 不是 int 会 panic
    
    // type switch
    fmt.Println("\n=== Type Switch ===")
    switch t := v.(type) {
    case int:
        fmt.Printf("整数：%d\n", t)
    case string:
        fmt.Printf("字符串：%s\n", t)
    case float64:
        fmt.Printf("浮点数：%.2f\n", t)
    default:
        fmt.Printf("未知类型：%T\n", t)
    }
}
```

**输出**:
```
=== 类型断言 ===
是字符串：Hello

=== Type Switch ===
字符串：Hello
```

---

### 案例 6: Stringer 接口

```go
package main

import (
    "fmt"
    "strings"
)

type Person struct {
    Name string
    Age  int
}

// 实现 fmt.Stringer 接口
func (p Person) String() string {
    return fmt.Sprintf("%s (%d 岁)", p.Name, p.Age)
}

type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) String() string {
    return fmt.Sprintf("Rectangle(%.2f x %.2f)", r.Width, r.Height)
}

type Team []string

func (t Team) String() string {
    return "Team: " + strings.Join([]string(t), ", ")
}

func main() {
    p := Person{Name: "张三", Age: 25}
    r := Rectangle{Width: 10, Height: 5}
    t := Team{"Alice", "Bob", "Carol"}
    
    fmt.Println("=== Stringer 接口 ===")
    fmt.Println(p)  // 自动调用 String()
    fmt.Println(r)
    fmt.Println(t)
    
    // 格式化输出
    fmt.Printf("\n=== 格式化 ===\n")
    fmt.Printf("%s\n", p)
    fmt.Printf("%v\n", r)
    fmt.Printf("%+v\n", t)
}
```

**输出**:
```
=== Stringer 接口 ===
张三 (25 岁)
Rectangle(10.00 x 5.00)
Team: Alice, Bob, Carol

=== 格式化 ===
张三 (25 岁)
Rectangle(10.00 x 5.00)
[Alice Bob Carol]
```

---

### 案例 7: 错误接口

```go
package main

import (
    "errors"
    "fmt"
)

// 自定义错误类型
type DivisionError struct {
    Dividend int
    Divisor  int
    Message  string
}

func (e *DivisionError) Error() string {
    return fmt.Sprintf("除法错误：%d ÷ %d - %s", 
        e.Dividend, e.Divisor, e.Message)
}

func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, &DivisionError{
            Dividend: a,
            Divisor:  b,
            Message:  "除数不能为零",
        }
    }
    return a / b, nil
}

// 包装错误
func process() error {
    _, err := divide(10, 0)
    if err != nil {
        return fmt.Errorf("处理失败：%w", err)
    }
    return nil
}

func main() {
    fmt.Println("=== 错误接口 ===")
    
    result, err := divide(10, 2)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("结果：%d\n", result)
    }
    
    _, err = divide(10, 0)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
        fmt.Printf("类型：%T\n", err)
    }
    
    // 错误包装
    fmt.Println("\n=== 错误包装 ===")
    err = process()
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
}
```

**输出**:
```
=== 错误接口 ===
结果：5
错误：除法错误：10 ÷ 0 - 除数不能为零
类型：*main.DivisionError

=== 错误包装 ===
错误：处理失败：除法错误：10 ÷ 0 - 除数不能为零
```

---

### 案例 8: 接口实际应用 - 形状计算

```go
package main

import (
    "fmt"
    "math"
)

// 形状接口
type Shape interface {
    Area() float64
    Perimeter() float64
}

// 圆形
type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.Radius
}

// 矩形
type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

// 三角形
type Triangle struct {
    A, B, C float64
}

func (t Triangle) Area() float64 {
    // 海伦公式
    s := (t.A + t.B + t.C) / 2
    return math.Sqrt(s * (s - t.A) * (s - t.B) * (s - t.C))
}

func (t Triangle) Perimeter() float64 {
    return t.A + t.B + t.C
}

// 计算总面积
func TotalArea(shapes []Shape) float64 {
    total := 0.0
    for _, shape := range shapes {
        total += shape.Area()
    }
    return total
}

// 打印形状信息
func PrintShapeInfo(shape Shape) {
    fmt.Printf("面积：%.2f, 周长：%.2f\n", 
        shape.Area(), shape.Perimeter())
}

func main() {
    shapes := []Shape{
        Circle{Radius: 5},
        Rectangle{Width: 10, Height: 5},
        Triangle{A: 3, B: 4, C: 5},
    }
    
    fmt.Println("=== 形状计算 ===")
    for i, shape := range shapes {
        fmt.Printf("\n形状 %d:\n", i+1)
        PrintShapeInfo(shape)
    }
    
    fmt.Printf("\n=== 总面积：%.2f ===\n", TotalArea(shapes))
}
```

**输出**:
```
=== 形状计算 ===

形状 1:
面积：78.54, 周长：31.42

形状 2:
面积：50.00, 周长：30.00

形状 3:
面积：6.00, 周长：12.00

=== 总面积：134.54 ===
```

---

### 案例 9: 综合应用 - 支付系统

```go
package main

import (
    "fmt"
    "time"
)

// 支付接口
type Payment interface {
    Pay(amount float64) error
    GetName() string
}

// 支付宝
type Alipay struct {
    Account string
}

func (a Alipay) GetName() string {
    return "支付宝"
}

func (a Alipay) Pay(amount float64) error {
    fmt.Printf("使用支付宝支付 ¥%.2f (账户：%s)\n", amount, a.Account)
    return nil
}

// 微信支付
type WechatPay struct {
    OpenID string
}

func (w WechatPay) GetName() string {
    return "微信支付"
}

func (w WechatPay) Pay(amount float64) error {
    fmt.Printf("使用微信支付 ¥%.2f (OpenID: %s)\n", amount, w.OpenID)
    return nil
}

// 银行卡
type BankCard struct {
    CardNumber string
}

func (b BankCard) GetName() string {
    return "银行卡"
}

func (b BankCard) Pay(amount float64) error {
    fmt.Printf("使用银行卡支付 ¥%.2f (卡号：%s)\n", 
        amount, b.CardNumber[len(b.CardNumber)-4:])
    return nil
}

// 订单
type Order struct {
    ID        int
    Amount    float64
    CreatedAt time.Time
}

// 支付处理
func ProcessOrder(order Order, payment Payment) error {
    fmt.Printf("\n=== 订单 #%d ===\n", order.ID)
    fmt.Printf("金额：¥%.2f\n", order.Amount)
    fmt.Printf("支付方式：%s\n", payment.GetName())
    
    return payment.Pay(order.Amount)
}

func main() {
    orders := []Order{
        {ID: 1, Amount: 99.00, CreatedAt: time.Now()},
        {ID: 2, Amount: 199.00, CreatedAt: time.Now()},
        {ID: 3, Amount: 299.00, CreatedAt: time.Now()},
    }
    
    payments := []Payment{
        Alipay{Account: "alice@example.com"},
        WechatPay{OpenID: "wx_123456"},
        BankCard{CardNumber: "6222021234567890123"},
    }
    
    fmt.Println("=== 支付系统 ===")
    for i, order := range orders {
        ProcessOrder(order, payments[i])
    }
}
```

**输出**:
```
=== 支付系统 ===

=== 订单 #1 ===
金额：¥99.00
支付方式：支付宝
使用支付宝支付 ¥99.00 (账户：alice@example.com)

=== 订单 #2 ===
金额：¥199.00
支付方式：微信支付
使用微信支付 ¥199.00 (OpenID: wx_123456)

=== 订单 #3 ===
金额：¥299.00
支付方式：银行卡
使用银行卡支付 ¥299.00 (卡号：0123)
```

---

## 📝 课后练习

1. 定义一个 Sorter 接口，实现整数切片和字符串切片的排序
2. 实现一个 Reader 和 Writer 接口，模拟文件读写
3. 使用空接口实现一个通用的 JSON 解析器
4. 实现一个 Observer 接口，模拟事件订阅系统
5. 为支付系统添加退款功能

---

## ✅ 学习检查清单

- [ ] 理解接口的定义与实现
- [ ] 掌握接口的隐式实现
- [ ] 学会使用空接口和类型断言
- [ ] 理解接口组合与继承
- [ ] 掌握接口的实际应用
- [ ] 完成所有 9 个案例

---

**上一章**: [第 11 章 - 方法](./chapter_11.md)  
**下一章**: [第 13 章 - 并发编程](./chapter_13.md)
