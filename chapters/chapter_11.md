# 第 11 章 - 方法

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3.5 小时  
**代码量**: 650 行  
**案例数**: 8 个

---

## 🎯 学习目标

1. 理解方法的定义与调用
2. 掌握值接收者与指针接收者的区别
3. 学会使用嵌入类型的方法
4. 理解方法集的概念
5. 掌握封装与信息隐藏

---

## 📚 理论讲解

### 一、方法基础

#### 1.1 什么是方法

方法是**带有接收者的函数**，接收者可以是结构体或其他自定义类型。

```go
type Person struct {
    Name string
}

// 方法定义
func (p Person) SayHello() {
    fmt.Printf("Hello, I'm %s\n", p.Name)
}
```

#### 1.2 接收者类型

| 类型 | 语法 | 特点 |
|------|------|------|
| 值接收者 | `func (t T) Method()` | 接收值的拷贝，不修改原值 |
| 指针接收者 | `func (t *T) Method()` | 可以修改原值，避免拷贝 |

### 二、方法集

- 类型 `T` 的方法集包含所有值接收者方法
- 类型 `*T` 的方法集包含值接收者和指针接收者方法

---

## 💻 实战案例

### 案例 1: 方法基础

```go
package main

import "fmt"

type Person struct {
    Name string
    Age  int
}

// 值接收者方法
func (p Person) SayHello() {
    fmt.Printf("Hello, I'm %s\n", p.Name)
}

// 带参数方法
func (p Person) Greet(name string) {
    fmt.Printf("Hello, %s! I'm %s\n", name, p.Name)
}

// 返回值方法
func (p Person) GetInfo() string {
    return fmt.Sprintf("%s, %d years old", p.Name, p.Age)
}

func main() {
    p := Person{Name: "Alice", Age: 25}
    
    fmt.Println("=== 方法调用 ===")
    p.SayHello()
    p.Greet("Bob")
    fmt.Println(p.GetInfo())
    
    // 指针也可以调用值接收者方法
    fmt.Println("\n=== 指针调用 ===")
    pp := &p
    pp.SayHello()  // 自动解引用
}
```

**输出**:
```
=== 方法调用 ===
Hello, I'm Alice
Hello, Bob! I'm Alice
Alice, 25 years old

=== 指针调用 ===
Hello, I'm Alice
```

---

### 案例 2: 值接收者 vs 指针接收者

```go
package main

import "fmt"

type Counter struct {
    count int
}

// 值接收者 - 不修改原值
func (c Counter) IncrementByValue() {
    c.count++
    fmt.Printf("值接收者内：%d\n", c.count)
}

// 指针接收者 - 修改原值
func (c *Counter) IncrementByPointer() {
    c.count++
    fmt.Printf("指针接收者内：%d\n", c.count)
}

// 获取计数值
func (c Counter) GetCount() int {
    return c.count
}

func main() {
    c := Counter{count: 0}
    
    fmt.Println("=== 值接收者 ===")
    c.IncrementByValue()
    fmt.Printf("调用后：%d\n\n", c.GetCount())
    
    fmt.Println("=== 指针接收者 ===")
    c.IncrementByPointer()
    fmt.Printf("调用后：%d\n\n", c.GetCount())
    
    c.IncrementByPointer()
    c.IncrementByPointer()
    fmt.Printf("最终计数：%d\n", c.GetCount())
}
```

**输出**:
```
=== 值接收者 ===
值接收者内：1
调用后：0

=== 指针接收者 ===
指针接收者内：1
调用后：1

最终计数：3
```

---

### 案例 3: 何时使用指针接收者

```go
package main

import "fmt"

type LargeStruct struct {
    Data [1000]int
    Name string
}

// 不推荐：大结构体值拷贝
func (l LargeStruct) ProcessByValue() {
    // 拷贝整个结构体
}

// 推荐：指针接收者
func (l *LargeStruct) ProcessByPointer() {
    // 只传递指针
}

// 需要修改时必须用指针接收者
func (l *LargeStruct) SetName(name string) {
    l.Name = name
}

// 只读可以用值接收者
func (l LargeStruct) GetName() string {
    return l.Name
}

// 内置类型方法
type IntSlice []int

func (s IntSlice) Sum() int {
    total := 0
    for _, v := range s {
        total += v
    }
    return total
}

func (s IntSlice) Double() {
    for i := range s {
        s[i] *= 2
    }
}

func main() {
    l := LargeStruct{Name: "Original"}
    l.SetName("Modified")
    fmt.Printf("Name: %s\n", l.GetName())
    
    fmt.Println("\n=== 切片方法 ===")
    s := IntSlice{1, 2, 3, 4, 5}
    fmt.Printf("Sum: %d\n", s.Sum())
    s.Double()
    fmt.Printf("Double: %v\n", s)
}
```

**输出**:
```
Name: Modified

=== 切片方法 ===
Sum: 15
Double: [2 4 6 8 10]
```

---

### 案例 4: 方法链式调用

```go
package main

import "fmt"

type Builder struct {
    result string
}

func NewBuilder() *Builder {
    return &Builder{result: ""}
}

func (b *Builder) Append(s string) *Builder {
    b.result += s
    return b  // 返回自身，支持链式调用
}

func (b *Builder) Prefix(s string) *Builder {
    b.result = s + b.result
    return b
}

func (b *Builder) Upper() *Builder {
    b.result = strings.ToUpper(b.result)
    return b
}

func (b *Builder) Build() string {
    return b.result
}

func main() {
    import "strings"
    
    result := NewBuilder().
        Append("Hello").
        Append(" ").
        Append("World").
        Prefix("> ").
        Upper().
        Build()
    
    fmt.Println(result)
}
```

---

### 案例 5: 嵌入类型的方法

```go
package main

import "fmt"

type Animal struct {
    Name string
}

func (a Animal) Speak() {
    fmt.Println("Some sound")
}

func (a Animal) GetName() string {
    return a.Name
}

type Dog struct {
    Animal  // 嵌入
    Breed string
}

// 覆盖嵌入类型的方法
func (d Dog) Speak() {
    fmt.Println("Woof! Woof!")
}

type Cat struct {
    Animal  // 嵌入
    Color string
}

func (c Cat) Speak() {
    fmt.Println("Meow~")
}

func main() {
    dog := Dog{
        Animal: Animal{Name: "旺财"},
        Breed:  "金毛",
    }
    
    cat := Cat{
        Animal: Animal{Name: "咪咪"},
        Color:  "白色",
    }
    
    fmt.Println("=== 调用嵌入方法 ===")
    fmt.Printf("dog.GetName(): %s\n", dog.GetName())
    fmt.Printf("cat.GetName(): %s\n", cat.GetName())
    
    fmt.Println("\n=== 调用覆盖方法 ===")
    dog.Speak()
    cat.Speak()
    
    fmt.Println("\n=== 调用原始方法 ===")
    dog.Animal.Speak()  // 调用 Animal 的 Speak
}
```

**输出**:
```
=== 调用嵌入方法 ===
dog.GetName(): 旺财
cat.GetName(): 咪咪

=== 调用覆盖方法 ===
Woof! Woof!
Meow~

=== 调用原始方法 ===
Some sound
```

---

### 案例 6: 封装与信息隐藏

```go
package main

import "fmt"

// 银行账户
type BankAccount struct {
    balance float64  // 小写，包外不可访问
    owner   string
}

// 构造函数
func NewBankAccount(owner string, initialBalance float64) *BankAccount {
    if initialBalance < 0 {
        initialBalance = 0
    }
    return &BankAccount{
        balance: initialBalance,
        owner:   owner,
    }
}

// Getter
func (a *BankAccount) GetBalance() float64 {
    return a.balance
}

func (a *BankAccount) GetOwner() string {
    return a.owner
}

// 存款
func (a *BankAccount) Deposit(amount float64) error {
    if amount <= 0 {
        return fmt.Errorf("存款金额必须大于 0")
    }
    a.balance += amount
    return nil
}

// 取款
func (a *BankAccount) Withdraw(amount float64) error {
    if amount <= 0 {
        return fmt.Errorf("取款金额必须大于 0")
    }
    if amount > a.balance {
        return fmt.Errorf("余额不足")
    }
    a.balance -= amount
    return nil
}

// 转账
func (a *BankAccount) Transfer(to *BankAccount, amount float64) error {
    if err := a.Withdraw(amount); err != nil {
        return err
    }
    if err := to.Deposit(amount); err != nil {
        a.balance += amount  // 回滚
        return err
    }
    return nil
}

func main() {
    // 创建账户
    alice := NewBankAccount("Alice", 1000)
    bob := NewBankAccount("Bob", 500)
    
    fmt.Println("=== 初始状态 ===")
    fmt.Printf("Alice: ¥%.2f\n", alice.GetBalance())
    fmt.Printf("Bob: ¥%.2f\n", bob.GetBalance())
    
    // 存款
    fmt.Println("\n=== 存款 ===")
    alice.Deposit(500)
    fmt.Printf("Alice 存款后：¥%.2f\n", alice.GetBalance())
    
    // 取款
    fmt.Println("\n=== 取款 ===")
    bob.Withdraw(200)
    fmt.Printf("Bob 取款后：¥%.2f\n", bob.GetBalance())
    
    // 转账
    fmt.Println("\n=== 转账 ===")
    alice.Transfer(bob, 300)
    fmt.Printf("Alice 转账后：¥%.2f\n", alice.GetBalance())
    fmt.Printf("Bob 收款后：¥%.2f\n", bob.GetBalance())
    
    // 错误处理
    fmt.Println("\n=== 错误处理 ===")
    err := alice.Withdraw(10000)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
}
```

**输出**:
```
=== 初始状态 ===
Alice: ¥1000.00
Bob: ¥500.00

=== 存款 ===
Alice 存款后：¥1500.00

=== 取款 ===
Bob 取款后：¥300.00

=== 转账 ===
Alice 转账后：¥1200.00
Bob 收款后：¥600.00

=== 错误处理 ===
错误：余额不足
```

---

### 案例 7: 方法集演示

```go
package main

import "fmt"

type Speaker interface {
    Speak()
}

type Person struct {
    Name string
}

// 值接收者方法
func (p Person) Speak() {
    fmt.Printf("Hello, I'm %s\n", p.Name)
}

// 指针接收者方法
func (p *Person) SetName(name string) {
    p.Name = name
}

func main() {
    p := Person{Name: "Alice"}
    
    // Person 值可以调用 Speak
    var s1 Speaker = p  // ✓
    s1.Speak()
    
    // Person 指针也可以调用 Speak（自动解引用）
    var s2 Speaker = &p  // ✓
    s2.Speak()
    
    // 演示方法集
    fmt.Println("\n=== 方法集 ===")
    fmt.Println("Person 的方法集：Speak()")
    fmt.Println("*Person 的方法集：Speak(), SetName()")
    
    // 修改名字
    p.SetName("Bob")
    fmt.Printf("\n修改后名字：%s\n", p.Name)
}
```

**输出**:
```
Hello, I'm Alice
Hello, I'm Alice

=== 方法集 ===
Person 的方法集：Speak()
*Person 的方法集：Speak(), SetName()

修改后名字：Bob
```

---

### 案例 8: 综合应用 - 学生管理系统

```go
package main

import (
    "fmt"
    "strings"
)

type Student struct {
    id     int
    name   string
    scores []float64
}

func NewStudent(id int, name string) *Student {
    return &Student{
        id:     id,
        name:   name,
        scores: make([]float64, 0),
    }
}

func (s *Student) AddScore(score float64) {
    if score >= 0 && score <= 100 {
        s.scores = append(s.scores, score)
    }
}

func (s *Student) GetAverage() float64 {
    if len(s.scores) == 0 {
        return 0
    }
    sum := 0.0
    for _, score := range s.scores {
        sum += score
    }
    return sum / float64(len(s.scores))
}

func (s *Student) GetMaxScore() float64 {
    if len(s.scores) == 0 {
        return 0
    }
    max := s.scores[0]
    for _, score := range s.scores[1:] {
        if score > max {
            max = score
        }
    }
    return max
}

func (s *Student) GetMinScore() float64 {
    if len(s.scores) == 0 {
        return 0
    }
    min := s.scores[0]
    for _, score := range s.scores[1:] {
        if score < min {
            min = score
        }
    }
    return min
}

func (s *Student) GetGrade() string {
    avg := s.GetAverage()
    switch {
    case avg >= 90:
        return "A"
    case avg >= 80:
        return "B"
    case avg >= 70:
        return "C"
    case avg >= 60:
        return "D"
    default:
        return "F"
    }
}

func (s *Student) GetReport() string {
    var sb strings.Builder
    sb.WriteString(fmt.Sprintf("学生：%s (ID: %d)\n", s.name, s.id))
    sb.WriteString(fmt.Sprintf("成绩：%v\n", s.scores))
    sb.WriteString(fmt.Sprintf("平均分：%.2f\n", s.GetAverage()))
    sb.WriteString(fmt.Sprintf("最高分：%.2f\n", s.GetMaxScore()))
    sb.WriteString(fmt.Sprintf("最低分：%.2f\n", s.GetMinScore()))
    sb.WriteString(fmt.Sprintf("等级：%s\n", s.GetGrade()))
    return sb.String()
}

type Class struct {
    name     string
    students []*Student
}

func NewClass(name string) *Class {
    return &Class{
        name:     name,
        students: make([]*Student, 0),
    }
}

func (c *Class) AddStudent(s *Student) {
    c.students = append(c.students, s)
}

func (c *Class) GetClassAverage() float64 {
    if len(c.students) == 0 {
        return 0
    }
    sum := 0.0
    for _, s := range c.students {
        sum += s.GetAverage()
    }
    return sum / float64(len(c.students))
}

func (c *Class) GetTopStudent() *Student {
    if len(c.students) == 0 {
        return nil
    }
    top := c.students[0]
    for _, s := range c.students[1:] {
        if s.GetAverage() > top.GetAverage() {
            top = s
        }
    }
    return top
}

func main() {
    class := NewClass("三年二班")
    
    // 添加学生
    s1 := NewStudent(1, "张三")
    s1.AddScore(85)
    s1.AddScore(90)
    s1.AddScore(78)
    
    s2 := NewStudent(2, "李四")
    s2.AddScore(92)
    s2.AddScore(88)
    s2.AddScore(95)
    
    s3 := NewStudent(3, "王五")
    s3.AddScore(78)
    s3.AddScore(82)
    s3.AddScore(85)
    
    class.AddStudent(s1)
    class.AddStudent(s2)
    class.AddStudent(s3)
    
    // 输出报告
    fmt.Println("=== 学生报告 ===")
    for _, s := range class.students {
        fmt.Println(s.GetReport())
    }
    
    // 班级统计
    fmt.Println("=== 班级统计 ===")
    fmt.Printf("班级：%s\n", class.name)
    fmt.Printf("人数：%d\n", len(class.students))
    fmt.Printf("班级平均分：%.2f\n", class.GetClassAverage())
    
    top := class.GetTopStudent()
    if top != nil {
        fmt.Printf("第一名：%s (平均分：%.2f)\n", 
            top.name, top.GetAverage())
    }
}
```

**输出**:
```
=== 学生报告 ===
学生：张三 (ID: 1)
成绩：[85 90 78]
平均分：84.33
最高分：90.00
最低分：78.00
等级：B

学生：李四 (ID: 2)
成绩：[92 88 95]
平均分：91.67
最高分：95.00
最低分：88.00
等级：A

学生：王五 (ID: 3)
成绩：[78 82 85]
平均分：81.67
最高分：85.00
最低分：78.00
等级：B

=== 班级统计 ===
班级：三年二班
人数：3
班级平均分：85.89
第一名：李四 (平均分：91.67)
```

---

## 📝 课后练习

1. 为 Rectangle 结构体实现 Area() 和 Perimeter() 方法
2. 实现一个栈数据结构，包含 Push、Pop、Peek 方法
3. 使用指针接收者实现一个计数器（支持 Reset）
4. 实现一个字符串处理器，支持链式调用
5. 为银行账户添加利息计算方法

---

## ✅ 学习检查清单

- [ ] 理解方法的定义与调用
- [ ] 掌握值接收者与指针接收者的区别
- [ ] 学会使用嵌入类型的方法
- [ ] 理解方法集的概念
- [ ] 掌握封装与信息隐藏
- [ ] 完成所有 8 个案例

---

**上一章**: [第 10 章 - 结构体](./chapter_10.md)  
**下一章**: [第 12 章 - 接口](./chapter_12.md)
