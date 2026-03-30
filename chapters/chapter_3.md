# 第 3 章 - 运算符与控制结构

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3 小时  
**代码量**: 450 行  
**案例数**: 7 个

---

## 🎯 学习目标

1. 掌握 Go 语言的所有运算符
2. 熟练使用 if-else 条件语句
3. 掌握 switch 语句的多种用法
4. 理解 Go 语言没有三元运算符
5. 能够编写复杂的条件逻辑

---

## 📚 理论讲解

### 一、运算符

#### 1.1 算术运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `+` | 加法 | `a + b` |
| `-` | 减法 | `a - b` |
| `*` | 乘法 | `a * b` |
| `/` | 除法 | `a / b` |
| `%` | 取余 | `a % b` |
| `++` | 自增 | `a++` |
| `--` | 自减 | `a--` |

#### 1.2 关系运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `==` | 等于 | `a == b` |
| `!=` | 不等于 | `a != b` |
| `>` | 大于 | `a > b` |
| `<` | 小于 | `a < b` |
| `>=` | 大于等于 | `a >= b` |
| `<=` | 小于等于 | `a <= b` |

#### 1.3 逻辑运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `&&` | 逻辑与 | `a && b` |
| `||` | 逻辑或 | `a || b` |
| `!` | 逻辑非 | `!a` |

#### 1.4 位运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `&` | 按位与 | `a & b` |
| `|` | 按位或 | `a | b` |
| `^` | 按位异或 | `a ^ b` |
| `&^` | 位清除 | `a &^ b` |
| `<<` | 左移 | `a << b` |
| `>>` | 右移 | `a >> b` |

#### 1.5 赋值运算符

| 运算符 | 描述 | 示例 |
|--------|------|------|
| `=` | 赋值 | `a = b` |
| `+=` | 加后赋值 | `a += b` |
| `-=` | 减后赋值 | `a -= b` |
| `*=` | 乘后赋值 | `a *= b` |
| `/=` | 除后赋值 | `a /= b` |
| `%=` | 余后赋值 | `a %= b` |

---

## 💻 实战案例

### 案例 1: 算术运算符大全

```go
package main

import "fmt"

func main() {
    var a int = 10
    var b int = 3
    
    fmt.Println("=== 算术运算符演示 ===")
    fmt.Printf("a = %d, b = %d\n\n", a, b)
    
    // 基本运算
    fmt.Printf("a + b = %d\n", a + b)
    fmt.Printf("a - b = %d\n", a - b)
    fmt.Printf("a * b = %d\n", a * b)
    fmt.Printf("a / b = %d (整数除法)\n", a / b)
    fmt.Printf("a %% b = %d (取余)\n", a % b)
    
    // 浮点数除法
    var fa float64 = 10.0
    var fb float64 = 3.0
    fmt.Printf("\n%.2f / %.2f = %.5f\n", fa, fb, fa/fb)
    
    // 自增自减
    var c int = 5
    fmt.Printf("\nc = %d\n", c)
    c++
    fmt.Printf("c++ 后：%d\n", c)
    c--
    fmt.Printf("c-- 后：%d\n", c)
    
    // 注意：Go 只有后置 ++/--，没有前置
    // ++c  // ❌ 编译错误
    // --c  // ❌ 编译错误
}
```

**输出**:
```
=== 算术运算符演示 ===
a = 10, b = 3

a + b = 13
a - b = 7
a * b = 30
a / b = 3 (整数除法)
a % b = 1 (取余)

10.00 / 3.00 = 3.33333

c = 5
c++ 后：6
c-- 后：5
```

---

### 案例 2: 关系与逻辑运算符

```go
package main

import "fmt"

func main() {
    var age int = 18
    var score float64 = 85.5
    var name string = "Alice"
    
    fmt.Println("=== 关系运算符 ===")
    fmt.Printf("age == 18: %t\n", age == 18)
    fmt.Printf("age != 18: %t\n", age != 18)
    fmt.Printf("age > 18: %t\n", age > 18)
    fmt.Printf("age >= 18: %t\n", age >= 18)
    fmt.Printf("age < 18: %t\n", age < 18)
    fmt.Printf("age <= 18: %t\n", age <= 18)
    
    fmt.Println("\n=== 逻辑运算符 ===")
    fmt.Printf("score >= 60 && score < 90: %t\n", score >= 60 && score < 90)
    fmt.Printf("score >= 90 || score < 60: %t\n", score >= 90 || score < 60)
    fmt.Printf("!(age < 18): %t\n", !(age < 18))
    
    fmt.Println("\n=== 字符串比较 ===")
    fmt.Printf("name == \"Alice\": %t\n", name == "Alice")
    fmt.Printf("name != \"Bob\": %t\n", name != "Bob")
    
    // 逻辑运算短路特性
    fmt.Println("\n=== 短路特性 ===")
    var x int = 5
    var y int = 10
    
    // && 短路：如果左边为 false，右边不执行
    result1 := (x > 10) && (y > 5)  // 左边 false，右边不检查
    fmt.Printf("(x > 10) && (y > 5) = %t\n", result1)
    
    // || 短路：如果左边为 true，右边不执行
    result2 := (x < 10) || (y > 100)  // 左边 true，右边不检查
    fmt.Printf("(x < 10) || (y > 100) = %t\n", result2)
}
```

**输出**:
```
=== 关系运算符 ===
age == 18: true
age != 18: false
age > 18: false
age >= 18: true
age < 18: false
age <= 18: true

=== 逻辑运算符 ===
score >= 60 && score < 90: true
score >= 90 || score < 60: false
!(age < 18): true

=== 字符串比较 ===
name == "Alice": true
name != "Bob": true

=== 短路特性 ===
(x > 10) && (y > 5) = false
(x < 10) || (y > 100) = true
```

---

### 案例 3: if-else 条件语句

```go
package main

import "fmt"

func main() {
    // 基础 if
    fmt.Println("=== 基础 if ===")
    age := 18
    if age >= 18 {
        fmt.Println("你已成年")
    }
    
    // if-else
    fmt.Println("\n=== if-else ===")
    score := 75
    if score >= 60 {
        fmt.Println("及格了！")
    } else {
        fmt.Println("不及格，继续加油！")
    }
    
    // if-else if-else
    fmt.Println("\n=== if-else if-else ===")
    grade := 85
    if grade >= 90 {
        fmt.Println("优秀 (A)")
    } else if grade >= 80 {
        fmt.Println("良好 (B)")
    } else if grade >= 70 {
        fmt.Println("中等 (C)")
    } else if grade >= 60 {
        fmt.Println("及格 (D)")
    } else {
        fmt.Println("不及格 (F)")
    }
    
    // if 带初始化语句
    fmt.Println("\n=== if 带初始化语句 ===")
    if num := 10; num > 5 {
        fmt.Printf("%d 大于 5\n", num)
    }
    // num 在这里不可用（作用域仅限于 if 块）
    
    // 嵌套 if
    fmt.Println("\n=== 嵌套 if ===")
    isMember := true
    balance := 1000.0
    
    if isMember {
        if balance > 500 {
            fmt.Println("VIP 会员，余额充足")
        } else {
            fmt.Println("VIP 会员，但余额不足")
        }
    } else {
        fmt.Println("非会员")
    }
}
```

**输出**:
```
=== 基础 if ===
你已成年

=== if-else ===
及格了！

=== if-else if-else ===
良好 (B)

=== if 带初始化语句 ===
10 大于 5

=== 嵌套 if ===
VIP 会员，余额充足
```

---

### 案例 4: switch 语句基础

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    // 基础 switch
    fmt.Println("=== 基础 switch ===")
    day := 3
    switch day {
    case 1:
        fmt.Println("星期一")
    case 2:
        fmt.Println("星期二")
    case 3:
        fmt.Println("星期三")
    case 4:
        fmt.Println("星期四")
    case 5:
        fmt.Println("星期五")
    case 6, 7:  // 多个值
        fmt.Println("周末")
    default:
        fmt.Println("无效的日期")
    }
    
    // switch 带初始化语句
    fmt.Println("\n=== switch 带初始化 ===")
    switch today := time.Now().Weekday(); today {
    case time.Saturday, time.Sunday:
        fmt.Println("今天是周末")
    default:
        fmt.Printf("今天是工作日 (%s)\n", today)
    }
    
    // 无条件 switch（替代 if-else）
    fmt.Println("\n=== 无条件 switch ===")
    hour := time.Now().Hour()
    switch {
    case hour < 6:
        fmt.Println("凌晨好")
    case hour < 12:
        fmt.Println("上午好")
    case hour < 18:
        fmt.Println("下午好")
    default:
        fmt.Println("晚上好")
    }
    
    // 字符串 switch
    fmt.Println("\n=== 字符串 switch ===")
    fruit := "apple"
    switch fruit {
    case "apple":
        fmt.Println("🍎 苹果")
    case "banana":
        fmt.Println("🍌 香蕉")
    case "orange":
        fmt.Println("🍊 橙子")
    default:
        fmt.Println("未知水果")
    }
}
```

**输出**:
```
=== 基础 switch ===
星期三

=== switch 带初始化 ===
今天是工作日 (Monday)

=== 无条件 switch ===
上午好

=== 字符串 switch ===
🍎 苹果
```

---

### 案例 5: switch 进阶用法

```go
package main

import "fmt"

func getGrade(score int) string {
    switch {
    case score >= 90:
        return "A"
    case score >= 80:
        return "B"
    case score >= 70:
        return "C"
    case score >= 60:
        return "D"
    default:
        return "F"
    }
}

func main() {
    // switch 返回值
    fmt.Println("=== switch 返回值 ===")
    scores := []int{95, 82, 75, 68, 45}
    
    for _, score := range scores {
        grade := getGrade(score)
        fmt.Printf("分数：%d, 等级：%s\n", score, grade)
    }
    
    // fallthrough（穿透）
    fmt.Println("\n=== fallthrough 穿透 ===")
    num := 1
    switch num {
    case 1:
        fmt.Println("数字 1")
        fallthrough  // 继续执行下一个 case
    case 2:
        fmt.Println("数字 2（因为 fallthrough）")
        fallthrough
    case 3:
        fmt.Println("数字 3（因为 fallthrough）")
    default:
        fmt.Println("结束")
    }
    
    // 类型 switch（后面会详细讲）
    fmt.Println("\n=== 类型 switch 预览 ===")
    var value interface{} = "Hello"
    switch v := value.(type) {
    case int:
        fmt.Printf("整数：%d\n", v)
    case string:
        fmt.Printf("字符串：%s\n", v)
    case float64:
        fmt.Printf("浮点数：%.2f\n", v)
    default:
        fmt.Printf("未知类型：%T\n", v)
    }
}
```

**输出**:
```
=== switch 返回值 ===
分数：95, 等级：A
分数：82, 等级：B
分数：75, 等级：C
分数：68, 等级：D
分数：45, 等级：F

=== fallthrough 穿透 ===
数字 1
数字 2（因为 fallthrough）
数字 3（因为 fallthrough）
结束

=== 类型 switch 预览 ===
字符串：Hello
```

---

### 案例 6: 位运算符详解

```go
package main

import "fmt"

func main() {
    var a uint8 = 12  // 0000 1100
    var b uint8 = 10  // 0000 1010
    
    fmt.Printf("a = %d (二进制：%%08b)\n", a)
    fmt.Printf("b = %d (二进制：%%08b)\n\n", b)
    
    // 按位与
    fmt.Println("=== 按位与 (&) ===")
    andResult := a & b
    fmt.Printf("a & b = %d\n", andResult)
    // 0000 1100
    // 0000 1010
    // --------
    // 0000 1000 = 8
    
    // 按位或
    fmt.Println("\n=== 按位或 (|) ===")
    orResult := a | b
    fmt.Printf("a | b = %d\n", orResult)
    // 0000 1100
    // 0000 1010
    // --------
    // 0000 1110 = 14
    
    // 按位异或
    fmt.Println("\n=== 按位异或 (^) ===")
    xorResult := a ^ b
    fmt.Printf("a ^ b = %d\n", xorResult)
    // 0000 1100
    // 0000 1010
    // --------
    // 0000 0110 = 6
    
    // 位清除
    fmt.Println("\n=== 位清除 (&^) ===")
    clearResult := a &^ b
    fmt.Printf("a &^ b = %d\n", clearResult)
    // 清除 a 中 b 为 1 的位
    // 0000 1100
    // 0000 1010
    // --------
    // 0000 0100 = 4
    
    // 左移右移
    fmt.Println("\n=== 左移右移 ===")
    var c uint8 = 4  // 0000 0100
    fmt.Printf("c = %d\n", c)
    fmt.Printf("c << 1 = %d (左移 1 位，相当于 ×2)\n", c<<1)
    fmt.Printf("c << 2 = %d (左移 2 位，相当于 ×4)\n", c<<2)
    fmt.Printf("c >> 1 = %d (右移 1 位，相当于 ÷2)\n", c>>1)
    
    // 实际应用：权限标志
    fmt.Println("\n=== 实际应用：权限标志 ===")
    const (
        Read   uint8 = 1 << iota  // 0001
        Write                     // 0010
        Execute                   // 0100
        Admin                     // 1000
    )
    
    userPerm := Read | Write  // 0011
    fmt.Printf("用户权限：%d (Read|Write)\n", userPerm)
    fmt.Printf("有读权限：%t\n", userPerm&Read != 0)
    fmt.Printf("有写权限：%t\n", userPerm&Write != 0)
    fmt.Printf("有执行权限：%t\n", userPerm&Execute != 0)
}
```

**输出**:
```
a = 12 (二进制：%!b(MISSING)
b = 10 (二进制：%!b(MISSING)

=== 按位与 (&) ===
a & b = 8

=== 按位或 (|) ===
a | b = 14

=== 按位异或 (^) ===
a ^ b = 6

=== 位清除 (&^) ===
a &^ b = 4

=== 左移右移 ===
c = 4
c << 1 = 8 (左移 1 位，相当于 ×2)
c << 2 = 16 (左移 2 位，相当于 ×4)
c >> 1 = 2 (右移 1 位，相当于 ÷2)

=== 实际应用：权限标志 ===
用户权限：3 (Read|Write)
有读权限：true
有写权限：true
有执行权限：false
```

---

### 案例 7: 综合应用 - 成绩评定系统

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

// 成绩等级
type Grade string

const (
    Excellent Grade = "A"
    Good      Grade = "B"
    Average   Grade = "C"
    Pass      Grade = "D"
    Fail      Grade = "F"
)

// 学生成绩
type StudentScore struct {
    Name     string
    Score    int
    Grade    Grade
    IsPassed bool
}

func getGrade(score int) Grade {
    switch {
    case score >= 90:
        return Excellent
    case score >= 80:
        return Good
    case score >= 70:
        return Average
    case score >= 60:
        return Pass
    default:
        return Fail
    }
}

func main() {
    reader := bufio.NewReader(os.Stdin)
    var students []StudentScore
    
    fmt.Println("=== 成绩评定系统 ===")
    fmt.Println()
    
    // 输入 3 个学生成绩
    for i := 1; i <= 3; i++ {
        fmt.Printf("【学生 %d】\n", i)
        
        fmt.Print("姓名：")
        name, _ := reader.ReadString('\n')
        name = strings.TrimSpace(name)
        
        fmt.Print("分数：")
        scoreStr, _ := reader.ReadString('\n')
        scoreStr = strings.TrimSpace(scoreStr)
        score, err := strconv.Atoi(scoreStr)
        
        if err != nil || score < 0 || score > 100 {
            fmt.Println("⚠️  分数无效，使用默认值 0")
            score = 0
        }
        
        grade := getGrade(score)
        isPassed := score >= 60
        
        students = append(students, StudentScore{
            Name:     name,
            Score:    score,
            Grade:    grade,
            IsPassed: isPassed,
        })
        fmt.Println()
    }
    
    // 输出结果
    fmt.Println("=== 成绩报告 ===")
    fmt.Println()
    
    var totalScore int
    var passCount int
    
    for _, s := range students {
        status := "✓ 及格"
        if !s.IsPassed {
            status = "✗ 不及格"
        } else {
            passCount++
        }
        totalScore += s.Score
        
        fmt.Printf("姓名：%s\n", s.Name)
        fmt.Printf("分数：%d\n", s.Score)
        fmt.Printf("等级：%s\n", s.Grade)
        fmt.Printf("状态：%s\n", status)
        fmt.Println(strings.Repeat("-", 30))
    }
    
    // 统计信息
    avgScore := float64(totalScore) / float64(len(students))
    passRate := float64(passCount) / float64(len(students)) * 100
    
    fmt.Println("\n=== 统计信息 ===")
    fmt.Printf("总人数：%d\n", len(students))
    fmt.Printf("平均分：%.2f\n", avgScore)
    fmt.Printf("及格人数：%d\n", passCount)
    fmt.Printf("及格率：%.2f%%\n", passRate)
}
```

**输出**:
```
=== 成绩评定系统 ===

【学生 1】
姓名：张三
分数：95

【学生 2】
姓名：李四
分数：78

【学生 3】
姓名：王五
分数：52

=== 成绩报告 ===

姓名：张三
分数：95
等级：A
状态：✓ 及格
------------------------------
姓名：李四
分数：78
等级：C
状态：✓ 及格
------------------------------
姓名：王五
分数：52
等级：F
状态：✗ 不及格
------------------------------

=== 统计信息 ===
总人数：3
平均分：75.00
及格人数：2
及格率：66.67%
```

---

## 📝 课后练习

1. 编写一个程序，判断一个年份是否为闰年
2. 实现一个简单的计算器（支持 +、-、×、÷）
3. 使用 switch 实现一个月份天数查询器
4. 编写一个程序，根据 BMI 指数判断健康状况
5. 实现一个用户登录验证系统（用户名 + 密码）

---

## ✅ 学习检查清单

- [ ] 掌握所有运算符类型
- [ ] 熟练使用 if-else 条件语句
- [ ] 掌握 switch 的多种用法
- [ ] 理解 Go 没有三元运算符
- [ ] 掌握位运算符的应用
- [ ] 完成所有 7 个案例

---

**上一章**: [第 2 章 - 变量与数据类型](./chapter_2.md)  
**下一章**: [第 4 章 - 循环结构](./chapter_4.md)
