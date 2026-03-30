# 第 2 章 - 变量与数据类型

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 2.5 小时  
**代码量**: 400 行  
**案例数**: 6 个

---

## 🎯 学习目标

1. 掌握 Go 语言的 8 种基本数据类型
2. 理解变量声明的多种方式
3. 学会类型转换和类型推断
4. 掌握常量的定义与使用
5. 理解零值的概念

---

## 📚 理论讲解

### 一、基本数据类型

Go 语言有 8 种基本数据类型：

#### 1.1 整数类型

| 类型 | 大小 | 范围 |
|------|------|------|
| `int8` | 8 位 | -128 ~ 127 |
| `int16` | 16 位 | -32768 ~ 32767 |
| `int32` | 32 位 | -2³¹ ~ 2³¹-1 |
| `int64` | 64 位 | -2⁶³ ~ 2⁶³-1 |
| `uint8` | 8 位 | 0 ~ 255 |
| `uint16` | 16 位 | 0 ~ 65535 |
| `uint32` | 32 位 | 0 ~ 2³²-1 |
| `uint64` | 64 位 | 0 ~ 2⁶⁴-1 |

**特殊类型**:
- `int`: 根据平台变化（32 位或 64 位）
- `uint`: 无符号版本
- `uintptr`: 用于指针运算

#### 1.2 浮点类型

| 类型 | 大小 | 精度 |
|------|------|------|
| `float32` | 32 位 | 约 6 位有效数字 |
| `float64` | 64 位 | 约 15 位有效数字 |

#### 1.3 其他基本类型

- `bool`: 布尔类型（`true` 或 `false`）
- `string`: 字符串类型（不可变）
- `byte`: `uint8` 的别名，用于 ASCII 字符
- `rune`: `int32` 的别名，用于 Unicode 字符

---

## 💻 实战案例

### 案例 1: 变量声明的多种方式

```go
package main

import "fmt"

func main() {
    // 方式 1: 完整声明（指定类型）
    var name string = "Alice"
    var age int = 25
    
    // 方式 2: 类型推断（省略类型）
    var city = "Beijing"
    var score = 95.5
    
    // 方式 3: 短变量声明（最常用）
    country := "China"
    height := 175.5
    
    // 方式 4: 多变量声明
    var x, y, z int = 1, 2, 3
    a, b := 10, 20
    
    // 方式 5: 混合类型声明
    var (
        firstName string = "John"
        lastName  = "Doe"
        age2      int = 30
    )
    
    fmt.Println("=== 变量声明演示 ===")
    fmt.Printf("name: %s, 类型：%T\n", name, name)
    fmt.Printf("age: %d, 类型：%T\n", age, age)
    fmt.Printf("city: %s, 类型：%T\n", city, city)
    fmt.Printf("score: %.2f, 类型：%T\n", score, score)
    fmt.Printf("country: %s, 类型：%T\n", country, country)
    fmt.Printf("x, y, z: %d, %d, %d\n", x, y, z)
    fmt.Printf("firstName: %s, lastName: %s, age2: %d\n", 
        firstName, lastName, age2)
}
```

**输出**:
```
=== 变量声明演示 ===
name: Alice, 类型：string
age: 25, 类型：int
city: Beijing, 类型：string
score: 95.50, 类型：float64
country: China, 类型：string
x, y, z: 1, 2, 3
firstName: John, lastName: Doe, age2: 30
```

---

### 案例 2: 数据类型详解

```go
package main

import "fmt"

func main() {
    // 整数类型
    var int8Val int8 = 127
    var int16Val int16 = 32767
    var int32Val int32 = 2147483647
    var int64Val int64 = 9223372036854775807
    
    // 无符号整数
    var uint8Val uint8 = 255
    var uint64Val uint64 = 18446744073709551615
    
    // 浮点类型
    var float32Val float32 = 3.14159
    var float64Val float64 = 3.141592653589793
    
    // 布尔类型
    var isTrue bool = true
    var isFalse bool = false
    
    // 字符串类型
    var greeting string = "Hello, Go!"
    var multiline string = `这是
多行
字符串`
    
    // 字节和符文
    var byteVal byte = 'A'      // 65
    var runeVal rune = '中'     // 20013
    
    fmt.Println("=== 整数类型 ===")
    fmt.Printf("int8: %d (范围：-128~127)\n", int8Val)
    fmt.Printf("int64: %d\n", int64Val)
    fmt.Printf("uint8: %d (范围：0~255)\n", uint8Val)
    
    fmt.Println("\n=== 浮点类型 ===")
    fmt.Printf("float32: %.7f\n", float32Val)
    fmt.Printf("float64: %.15f\n", float64Val)
    
    fmt.Println("\n=== 布尔类型 ===")
    fmt.Printf("true: %t, false: %t\n", isTrue, isFalse)
    fmt.Printf("5 > 3 = %t\n", 5 > 3)
    
    fmt.Println("\n=== 字符串类型 ===")
    fmt.Printf("greeting: %s\n", greeting)
    fmt.Printf("multiline:\n%s\n", multiline)
    
    fmt.Println("\n=== 字节和符文 ===")
    fmt.Printf("byte 'A': %d (ASCII)\n", byteVal)
    fmt.Printf("rune '中': %d (Unicode)\n", runeVal)
    fmt.Printf("字符：%c\n", runeVal)
}
```

**输出**:
```
=== 整数类型 ===
int8: 127 (范围：-128~127)
int64: 9223372036854775807
uint8: 255 (范围：0~255)

=== 浮点类型 ===
float32: 3.1415901
float64: 3.141592653589793

=== 布尔类型 ===
true: true, false: false
5 > 3 = true

=== 字符串类型 ===
greeting: Hello, Go!
multiline:
这是
多行
字符串

=== 字节和符文 ===
byte 'A': 65 (ASCII)
rune '中': 20013 (Unicode)
字符：中
```

---

### 案例 3: 类型转换

```go
package main

import (
    "fmt"
    "strconv"
)

func main() {
    // 显式类型转换（必须，Go 不支持隐式转换）
    var intVal int = 42
    var floatVal float64 = float64(intVal)
    var int8Val int8 = int8(intVal)
    
    fmt.Println("=== 数值类型转换 ===")
    fmt.Printf("int -> float64: %d -> %.2f\n", intVal, floatVal)
    fmt.Printf("int -> int8: %d -> %d\n", intVal, int8Val)
    
    // 浮点数转整数（截断小数部分）
    var pi float64 = 3.14159
    var piInt int = int(pi)
    fmt.Printf("float64 -> int: %.5f -> %d\n", pi, piInt)
    
    // 字符串转数字
    fmt.Println("\n=== 字符串转数字 ===")
    strNum := "123"
    num, err := strconv.Atoi(strNum)
    if err != nil {
        fmt.Println("转换失败:", err)
    } else {
        fmt.Printf("string -> int: \"%s\" -> %d\n", strNum, num)
    }
    
    strFloat := "3.14"
    floatNum, err := strconv.ParseFloat(strFloat, 64)
    if err != nil {
        fmt.Println("转换失败:", err)
    } else {
        fmt.Printf("string -> float64: \"%s\" -> %.2f\n", strFloat, floatNum)
    }
    
    // 数字转字符串
    fmt.Println("\n=== 数字转字符串 ===")
    num2 := 456
    str2 := strconv.Itoa(num2)
    fmt.Printf("int -> string: %d -> \"%s\"\n", num2, str2)
    
    floatNum2 := 2.718
    str3 := strconv.FormatFloat(floatNum2, 'f', 2, 64)
    fmt.Printf("float64 -> string: %.3f -> \"%s\"\n", floatNum2, str3)
    
    // 溢出演示
    fmt.Println("\n=== 溢出演示 ===")
    var bigInt int = 1000
    var smallInt int8 = int8(bigInt) // 溢出！
    fmt.Printf("int(1000) -> int8: %d (溢出)\n", smallInt)
}
```

**输出**:
```
=== 数值类型转换 ===
int -> float64: 42 -> 42.00
int -> int8: 42 -> 42
float64 -> int: 3.14159 -> 3

=== 字符串转数字 ===
string -> int: "123" -> 123
string -> float64: "3.14" -> 3.14

=== 数字转字符串 ===
int -> string: 456 -> "456"
float64 -> string: 2.718 -> "2.72"

=== 溢出演示 ===
int(1000) -> int8: -24 (溢出)
```

---

### 案例 4: 零值演示

```go
package main

import "fmt"

func main() {
    // 声明但未初始化的变量会有零值
    var intVal int
    var floatVal float64
    var boolVal bool
    var strVal string
    var intPtr *int
    
    fmt.Println("=== 零值演示 ===")
    fmt.Printf("int 零值: %d\n", intVal)           // 0
    fmt.Printf("float64 零值: %.2f\n", floatVal)   // 0.00
    fmt.Printf("bool 零值: %t\n", boolVal)         // false
    fmt.Printf("string 零值: \"%s\"\n", strVal)    // "" (空字符串)
    fmt.Printf("pointer 零值: %v\n", intPtr)       // <nil>
    
    // 零值的实际意义
    fmt.Println("\n=== 零值的实际应用 ===")
    
    // 计数器从 0 开始
    var count int  // 默认为 0
    count++
    fmt.Printf("计数器初始值：%d, 自增后：%d\n", 0, count)
    
    // 标志位默认为 false
    var isLoggedIn bool  // 默认为 false
    fmt.Printf("登录状态：%t (未登录)\n", isLoggedIn)
    
    // 字符串默认为空
    var userName string  // 默认为 ""
    if userName == "" {
        fmt.Println("用户名为空，需要设置")
    }
}
```

**输出**:
```
=== 零值演示 ===
int 零值：0
float64 零值：0.00
bool 零值：false
string 零值：""
pointer 零值：<nil>

=== 零值的实际应用 ===
计数器初始值：0, 自增后：1
登录状态：false (未登录)
用户名为空，需要设置
```

---

### 案例 5: 常量定义

```go
package main

import (
    "fmt"
    "math"
)

// 全局常量
const Pi = 3.141592653589793
const E = 2.718281828459045

// 使用 iota 枚举
const (
    Sunday = iota  // 0
    Monday         // 1
    Tuesday        // 2
    Wednesday      // 3
    Thursday       // 4
    Friday         // 5
    Saturday       // 6
)

// 带值的枚举
const (
    StatusOK       = 200
    StatusNotFound = 404
    StatusError    = 500
)

func main() {
    // 局部常量
    const appName = "MyApp"
    const version = "1.0.0"
    
    fmt.Println("=== 常量演示 ===")
    fmt.Printf("Pi = %.15f\n", Pi)
    fmt.Printf("E = %.15f\n", E)
    fmt.Printf("math.Pi = %.15f (标准库)\n", math.Pi)
    
    fmt.Println("\n=== 星期枚举 ===")
    days := []string{"Sunday", "Monday", "Tuesday", "Wednesday", 
                    "Thursday", "Friday", "Saturday"}
    fmt.Printf("Today is %s (第 %d 天)\n", days[Monday], Monday)
    
    fmt.Println("\n=== HTTP 状态码 ===")
    fmt.Printf("OK: %d\n", StatusOK)
    fmt.Printf("Not Found: %d\n", StatusNotFound)
    fmt.Printf("Error: %d\n", StatusError)
    
    fmt.Println("\n=== 应用信息 ===")
    fmt.Printf("应用：%s v%s\n", appName, version)
    
    // 常量不能修改（会编译错误）
    // Pi = 3.14  // ❌ 编译错误：cannot assign to Pi
}
```

**输出**:
```
=== 常量演示 ===
Pi = 3.141592653589793
E = 2.718281828459045
math.Pi = 3.141592653589793 (标准库)

=== 星期枚举 ===
Today is Monday (第 1 天)

=== HTTP 状态码 ===
OK: 200
Not Found: 404
Error: 500

=== 应用信息 ===
应用：MyApp v1.0.0
```

---

### 案例 6: 综合应用 - 学生信息管理系统

```go
package main

import "fmt"

// 学生结构
type Student struct {
    ID       int
    Name     string
    Age      int
    Score    float64
    Grade    string
    IsPassed bool
}

func main() {
    // 创建学生信息
    var student1 Student
    student1.ID = 1
    student1.Name = "张三"
    student1.Age = 18
    student1.Score = 85.5
    student1.Grade = "A"
    student1.IsPassed = true
    
    // 使用短变量声明
    student2 := Student{
        ID:       2,
        Name:     "李四",
        Age:      19,
        Score:    92.0,
        Grade:    "A+",
        IsPassed: true,
    }
    
    // 使用零值
    var student3 Student  // 所有字段都是零值
    student3.ID = 3
    student3.Name = "王五"
    
    fmt.Println("=== 学生信息管理系统 ===")
    fmt.Println()
    
    // 打印学生 1
    fmt.Println("【学生 1】")
    fmt.Printf("学号：%d\n", student1.ID)
    fmt.Printf("姓名：%s\n", student1.Name)
    fmt.Printf("年龄：%d\n", student1.Age)
    fmt.Printf("分数：%.2f\n", student1.Score)
    fmt.Printf("等级：%s\n", student1.Grade)
    fmt.Printf("是否及格：%t\n", student1.IsPassed)
    fmt.Println()
    
    // 打印学生 2
    fmt.Println("【学生 2】")
    fmt.Printf("学号：%d\n", student2.ID)
    fmt.Printf("姓名：%s\n", student2.Name)
    fmt.Printf("年龄：%d\n", student2.Age)
    fmt.Printf("分数：%.2f\n", student2.Score)
    fmt.Printf("等级：%s\n", student2.Grade)
    fmt.Printf("是否及格：%t\n", student2.IsPassed)
    fmt.Println()
    
    // 打印学生 3（演示零值）
    fmt.Println("【学生 3】")
    fmt.Printf("学号：%d\n", student3.ID)
    fmt.Printf("姓名：%s\n", student3.Name)
    fmt.Printf("年龄：%d (零值)\n", student3.Age)
    fmt.Printf("分数：%.2f (零值)\n", student3.Score)
    fmt.Printf("等级：%s (零值)\n", student3.Grade)
    fmt.Printf("是否及格：%t (零值)\n", student3.IsPassed)
    
    // 计算平均分
    avgScore := (student1.Score + student2.Score + student3.Score) / 3
    fmt.Println()
    fmt.Println("=== 统计信息 ===")
    fmt.Printf("平均分：%.2f\n", avgScore)
    fmt.Printf("总人数：%d\n", 3)
}
```

**输出**:
```
=== 学生信息管理系统 ===

【学生 1】
学号：1
姓名：张三
年龄：18
分数：85.50
等级：A
是否及格：true

【学生 2】
学号：2
姓名：李四
年龄：19
分数：92.00
等级：A+
是否及格：true

【学生 3】
学号：3
姓名：王五
年龄：0 (零值)
分数：0.00 (零值)
等级： (零值)
是否及格：false (零值)

=== 统计信息 ===
平均分：59.17
总人数：3
```

---

## 📝 课后练习

1. 声明不同类型的变量并打印它们的类型
2. 练习各种类型转换（int ↔ float ↔ string）
3. 使用 iota 创建一个月份枚举
4. 编写一个程序，演示所有基本类型的零值
5. 创建一个包含多个常量的配置文件

---

## ✅ 学习检查清单

- [ ] 掌握 8 种基本数据类型
- [ ] 理解变量声明的 5 种方式
- [ ] 会进行类型转换
- [ ] 理解零值的概念
- [ ] 掌握常量和 iota 的使用
- [ ] 完成所有 6 个案例

---

**上一章**: [第 1 章 - 环境搭建与第一个 Go 程序](./chapter_1.md)  
**下一章**: [第 3 章 - 运算符与控制结构](./chapter_3.md)
