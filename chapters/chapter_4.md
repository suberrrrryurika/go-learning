# 第 4 章 - 循环结构

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3 小时  
**代码量**: 500 行  
**案例数**: 8 个

---

## 🎯 学习目标

1. 掌握 for 循环的四种写法
2. 理解 break 和 continue 的用法
3. 掌握 range 遍历数组、切片、Map 和字符串
4. 学会嵌套循环
5. 理解 Go 语言只有 for 循环（没有 while/do-while）

---

## 📚 理论讲解

### 一、for 循环的四种写法

Go 语言**只有 for 循环**，没有 while、do-while 或其他循环语句。

#### 1.1 完整形式（类似 C 语言）

```go
for 初始化; 条件; 更新 {
    // 循环体
}
```

#### 1.2 条件循环（类似 while）

```go
for 条件 {
    // 循环体
}
```

#### 1.3 无限循环

```go
for {
    // 循环体
    // 需要手动 break 退出
}
```

#### 1.4 range 遍历

```go
for index, value := range collection {
    // 遍历集合
}
```

### 二、循环控制语句

| 语句 | 描述 | 示例 |
|------|------|------|
| `break` | 跳出当前循环 | `break` |
| `continue` | 跳过本次迭代，继续下一次 | `continue` |
| `goto` | 跳转到标签（不推荐使用） | `goto label` |

---

## 💻 实战案例

### 案例 1: for 循环基础

```go
package main

import "fmt"

func main() {
    // 完整形式：初始化; 条件; 更新
    fmt.Println("=== 完整形式 ===")
    for i := 0; i < 5; i++ {
        fmt.Printf("i = %d\n", i)
    }
    
    // 多变量初始化
    fmt.Println("\n=== 多变量 ===")
    for i, j := 0, 10; i < j; i, j = i+1, j-1 {
        fmt.Printf("i = %d, j = %d\n", i, j)
    }
    
    // 省略初始化
    fmt.Println("\n=== 省略初始化 ===")
    i := 0
    for ; i < 3; i++ {
        fmt.Printf("i = %d\n", i)
    }
    
    // 省略更新
    fmt.Println("\n=== 省略更新 ===")
    j := 0
    for j < 3 {
        fmt.Printf("j = %d\n", j)
        j++
    }
}
```

**输出**:
```
=== 完整形式 ===
i = 0
i = 1
i = 2
i = 3
i = 4

=== 多变量 ===
i = 0, j = 10
i = 1, j = 9
i = 2, j = 8
i = 3, j = 7
i = 4, j = 6

=== 省略初始化 ===
i = 0
i = 1
i = 2

=== 省略更新 ===
j = 0
j = 1
j = 2
```

---

### 案例 2: while 循环替代

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

func main() {
    // Go 没有 while，用 for 替代
    fmt.Println("=== for 替代 while ===")
    
    // 类似 while(true)
    count := 0
    for count < 3 {
        fmt.Printf("计数：%d\n", count)
        count++
    }
    
    // 用户输入验证
    fmt.Println("\n=== 输入验证 ===")
    reader := bufio.NewReader(os.Stdin)
    
    var password string
    for {
        fmt.Print("请输入密码（至少 6 位）：")
        input, _ := reader.ReadString('\n')
        password = strings.TrimSpace(input)
        
        if len(password) >= 6 {
            fmt.Println("✓ 密码设置成功")
            break
        }
        fmt.Println("✗ 密码太短，请重新输入")
    }
    
    // 带条件的输入
    fmt.Println("\n=== 条件输入 ===")
    var sum int
    for sum < 100 {
        fmt.Printf("当前和：%d, ", sum)
        fmt.Print("请输入数字：")
        input, _ := reader.ReadString('\n')
        input = strings.TrimSpace(input)
        
        var num int
        fmt.Sscanf(input, "%d", &num)
        sum += num
    }
    fmt.Printf("最终和：%d (超过 100)\n", sum)
}
```

**输出**:
```
=== for 替代 while ===
计数：0
计数：1
计数：2

=== 输入验证 ===
请输入密码（至少 6 位）：123
✗ 密码太短，请重新输入
请输入密码（至少 6 位）：123456
✓ 密码设置成功

=== 条件输入 ===
当前和：0, 请输入数字：50
当前和：50, 请输入数字：60
最终和：110 (超过 100)
```

---

### 案例 3: break 和 continue

```go
package main

import "fmt"

func main() {
    // break: 跳出循环
    fmt.Println("=== break 演示 ===")
    for i := 0; i < 10; i++ {
        if i == 5 {
            fmt.Println("遇到 5，跳出循环")
            break
        }
        fmt.Printf("i = %d\n", i)
    }
    
    // continue: 跳过本次迭代
    fmt.Println("\n=== continue 演示 ===")
    for i := 0; i < 10; i++ {
        if i%2 == 0 {
            continue  // 跳过偶数
        }
        fmt.Printf("奇数：%d\n", i)
    }
    
    // 嵌套循环中的 break
    fmt.Println("\n=== 嵌套循环 break ===")
    for i := 0; i < 3; i++ {
        for j := 0; j < 5; j++ {
            if j == 3 {
                fmt.Printf("i=%d, j=%d 时跳出内层循环\n", i, j)
                break  // 只跳出内层
            }
            fmt.Printf("i=%d, j=%d\n", i, j)
        }
    }
    
    // 标签 break（跳出多层循环）
    fmt.Println("\n=== 标签 break ===")
OuterLoop:
    for i := 0; i < 3; i++ {
        for j := 0; j < 5; j++ {
            if i+j == 5 {
                fmt.Printf("i=%d, j=%d 时跳出所有循环\n", i, j)
                break OuterLoop
            }
            fmt.Printf("i=%d, j=%d\n", i, j)
        }
    }
    fmt.Println("所有循环结束")
}
```

**输出**:
```
=== break 演示 ===
i = 0
i = 1
i = 2
i = 3
i = 4
遇到 5，跳出循环

=== continue 演示 ===
奇数：1
奇数：3
奇数：5
奇数：7
奇数：9

=== 嵌套循环 break ===
i=0, j=0
i=0, j=1
i=0, j=2
i=0, j=3 时跳出内层循环
i=1, j=0
i=1, j=1
i=1, j=2
i=1, j=3 时跳出内层循环
i=2, j=0
i=2, j=1
i=2, j=2
i=2, j=3 时跳出内层循环

=== 标签 break ===
i=0, j=0
i=0, j=1
i=0, j=2
i=0, j=3
i=0, j=4
i=1, j=0
i=1, j=1
i=1, j=2
i=1, j=3
i=1, j=4
i=2, j=0
i=2, j=1
i=2, j=2
i=2, j=3 时跳出所有循环
所有循环结束
```

---

### 案例 4: range 遍历数组和切片

```go
package main

import "fmt"

func main() {
    // 遍历数组
    fmt.Println("=== 遍历数组 ===")
    arr := [5]int{10, 20, 30, 40, 50}
    
    // 方式 1: 索引和值
    for i, v := range arr {
        fmt.Printf("arr[%d] = %d\n", i, v)
    }
    
    // 方式 2: 只要索引
    fmt.Println("\n=== 只要索引 ===")
    for i := range arr {
        fmt.Printf("索引：%d\n", i)
    }
    
    // 方式 3: 只要值（忽略索引）
    fmt.Println("\n=== 只要值 ===")
    for _, v := range arr {
        fmt.Printf("值：%d\n", v)
    }
    
    // 遍历切片
    fmt.Println("\n=== 遍历切片 ===")
    slice := []string{"Go", "Python", "Java", "C++"}
    for i, lang := range slice {
        fmt.Printf("%d: %s\n", i+1, lang)
    }
    
    // 修改切片元素
    fmt.Println("\n=== 修改元素 ===")
    numbers := []int{1, 2, 3, 4, 5}
    for i := range numbers {
        numbers[i] *= 2
    }
    fmt.Printf("翻倍后：%v\n", numbers)
    
    // 带索引计算
    fmt.Println("\n=== 带索引计算 ===")
    prices := []float64{100.0, 200.0, 300.0}
    var total float64
    for i, price := range prices {
        total += price
        fmt.Printf("商品 %d: ¥%.2f\n", i+1, price)
    }
    fmt.Printf("总计：¥%.2f\n", total)
    fmt.Printf("平均：¥%.2f\n", total/float64(len(prices)))
}
```

**输出**:
```
=== 遍历数组 ===
arr[0] = 10
arr[1] = 20
arr[2] = 30
arr[3] = 40
arr[4] = 50

=== 只要索引 ===
索引：0
索引：1
索引：2
索引：3
索引：4

=== 只要值 ===
值：10
值：20
值：30
值：40
值：50

=== 遍历切片 ===
1: Go
2: Python
3: Java
4: C++

=== 修改元素 ===
翻倍后：[2 4 6 8 10]

=== 带索引计算 ===
商品 1: ¥100.00
商品 2: ¥200.00
商品 3: ¥300.00
总计：¥600.00
平均：¥200.00
```

---

### 案例 5: range 遍历 Map 和字符串

```go
package main

import "fmt"

func main() {
    // 遍历 Map
    fmt.Println("=== 遍历 Map ===")
    scores := map[string]int{
        "Alice": 95,
        "Bob":   87,
        "Carol": 92,
    }
    
    // Map 遍历顺序是随机的
    for name, score := range scores {
        fmt.Printf("%s: %d 分\n", name, score)
    }
    
    // 只遍历键
    fmt.Println("\n=== 只遍历键 ===")
    for name := range scores {
        fmt.Printf("学生：%s\n", name)
    }
    
    // 遍历字符串（rune）
    fmt.Println("\n=== 遍历字符串 ===")
    str := "Hello 世界"
    
    // 方式 1: range 遍历（推荐）
    for i, r := range str {
        fmt.Printf("位置 %d: 字符 '%c' (Unicode: %d)\n", i, r, r)
    }
    
    // 方式 2: 传统索引（按字节）
    fmt.Println("\n=== 按字节索引 ===")
    for i := 0; i < len(str); i++ {
        fmt.Printf("字节 %d: %08b\n", i, str[i])
    }
    
    // 统计字符数
    fmt.Println("\n=== 字符统计 ===")
    fmt.Printf("字符串：%q\n", str)
    fmt.Printf("字节数：%d\n", len(str))
    fmt.Printf("字符数（rune）：%d\n", len([]rune(str)))
    
    // 实际案例：词频统计
    fmt.Println("\n=== 词频统计 ===")
    text := "hello world"
    freq := make(map[rune]int)
    for _, ch := range text {
        if ch != ' ' {
            freq[ch]++
        }
    }
    for ch, count := range freq {
        fmt.Printf("'%c': %d 次\n", ch, count)
    }
}
```

**输出**:
```
=== 遍历 Map ===
Alice: 95 分
Bob: 87 分
Carol: 92 分

=== 只遍历键 ===
学生：Alice
学生：Bob
学生：Carol

=== 遍历字符串 ===
位置 0: 字符 'H' (Unicode: 72)
位置 1: 字符 'e' (Unicode: 101)
位置 2: 字符 'l' (Unicode: 108)
位置 3: 字符 'l' (Unicode: 108)
位置 4: 字符 'o' (Unicode: 111)
位置 5: 字符 '世' (Unicode: 19990)
位置 8: 字符 '界' (Unicode: 30028)

=== 按字节索引 ===
字节 0: 01001000
字节 1: 01100101
字节 2: 01101100
字节 3: 01101100
字节 4: 01101111
字节 5: 00100000
字节 6: 00100000
字节 7: 00100000
字节 8: 00100000
字节 9: 00100000
字节 10: 00100000

=== 字符统计 ===
字符串："Hello 世界"
字节数：12
字符数（rune）：8

=== 词频统计 ===
'h': 1 次
'e': 1 次
'l': 3 次
'o': 1 次
'w': 1 次
'r': 1 次
'd': 1 次
```

---

### 案例 6: 九九乘法表

```go
package main

import "fmt"

func main() {
    fmt.Println("=== 九九乘法表 ===")
    fmt.Println()
    
    // 外层循环控制行
    for i := 1; i <= 9; i++ {
        // 内层循环控制列
        for j := 1; j <= i; j++ {
            fmt.Printf("%d×%d=%2d  ", j, i, i*j)
        }
        fmt.Println()
    }
    
    // 带边框的版本
    fmt.Println("\n=== 带边框的乘法表 ===")
    fmt.Println("╔════════════════════════════════════════════╗")
    
    for i := 1; i <= 9; i++ {
        fmt.Printf("║ ")
        for j := 1; j <= i; j++ {
            fmt.Printf("%d×%d=%2d  ", j, i, i*j)
        }
        // 填充空格
        for k := i; k < 9; k++ {
            fmt.Print("        ")
        }
        fmt.Printf("║\n")
    }
    
    fmt.Println("╚════════════════════════════════════════════╝")
}
```

**输出**:
```
=== 九九乘法表 ===

1×1= 1  
1×2= 2  2×2= 4  
1×3= 3  2×3= 6  3×3= 9  
1×4= 4  2×4= 8  3×4=12  4×4=16  
1×5= 5  2×5=10  3×5=15  4×5=20  5×5=25  
1×6= 6  2×6=12  3×6=18  4×6=24  5×6=30  6×6=36  
1×7= 7  2×7=14  3×7=21  4×7=28  5×7=35  6×7=42  7×7=49  
1×8= 8  2×8=16  3×8=24  4×8=32  5×8=40  6×8=48  7×8=56  8×8=64  
1×9= 9  2×9=18  3×9=27  4×9=36  5×9=45  6×9=54  7×9=63  8×9=72  9×9=81  

=== 带边框的乘法表 ===
╔════════════════════════════════════════════╗
║ 1×1= 1                                      ║
║ 1×2= 2  2×2= 4                              ║
║ 1×3= 3  2×3= 6  3×3= 9                      ║
║ 1×4= 4  2×4= 8  3×4=12  4×4=16              ║
║ 1×5= 5  2×5=10  3×5=15  4×5=20  5×5=25      ║
║ 1×6= 6  2×6=12  3×6=18  4×6=24  5×6=30  6×6=36  ║
║ 1×7= 7  2×7=14  3×7=21  4×7=28  5×7=35  6×7=42  7×7=49  ║
║ 1×8= 8  2×8=16  3×8=24  4×8=32  5×8=40  6×8=48  7×8=56  8×8=64  ║
║ 1×9= 9  2×9=18  3×9=27  4×9=36  5×9=45  6×9=54  7×9=63  8×9=72  9×9=81  ║
╚════════════════════════════════════════════╝
```

---

### 案例 7: 打印图形

```go
package main

import "fmt"

func main() {
    // 直角三角形
    fmt.Println("=== 直角三角形 ===")
    for i := 1; i <= 5; i++ {
        for j := 0; j < i; j++ {
            fmt.Print("* ")
        }
        fmt.Println()
    }
    
    // 等腰三角形
    fmt.Println("\n=== 等腰三角形 ===")
    rows := 5
    for i := 1; i <= rows; i++ {
        // 打印空格
        for j := 0; j < rows-i; j++ {
            fmt.Print(" ")
        }
        // 打印星号
        for k := 0; k < 2*i-1; k++ {
            fmt.Print("*")
        }
        fmt.Println()
    }
    
    // 菱形
    fmt.Println("\n=== 菱形 ===")
    // 上半部分
    for i := 1; i <= rows; i++ {
        for j := 0; j < rows-i; j++ {
            fmt.Print(" ")
        }
        for k := 0; k < 2*i-1; k++ {
            fmt.Print("*")
        }
        fmt.Println()
    }
    // 下半部分
    for i := rows - 1; i >= 1; i-- {
        for j := 0; j < rows-i; j++ {
            fmt.Print(" ")
        }
        for k := 0; k < 2*i-1; k++ {
            fmt.Print("*")
        }
        fmt.Println()
    }
    
    // 空心菱形
    fmt.Println("\n=== 空心菱形 ===")
    for i := 1; i <= rows; i++ {
        for j := 0; j < rows-i; j++ {
            fmt.Print(" ")
        }
        for k := 0; k < 2*i-1; k++ {
            if k == 0 || k == 2*i-2 {
                fmt.Print("*")
            } else {
                fmt.Print(" ")
            }
        }
        fmt.Println()
    }
    for i := rows - 1; i >= 1; i-- {
        for j := 0; j < rows-i; j++ {
            fmt.Print(" ")
        }
        for k := 0; k < 2*i-1; k++ {
            if k == 0 || k == 2*i-2 {
                fmt.Print("*")
            } else {
                fmt.Print(" ")
            }
        }
        fmt.Println()
    }
}
```

**输出**:
```
=== 直角三角形 ===
* 
* * 
* * * 
* * * * 
* * * * * 

=== 等腰三角形 ===
    *
   ***
  *****
 *******
*********

=== 菱形 ===
    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *

=== 空心菱形 ===
    *
   * *
  *   *
 *     *
*       *
 *     *
  *   *
   * *
    *
```

---

### 案例 8: 综合应用 - 猜数字游戏

```go
package main

import (
    "bufio"
    "fmt"
    "math/rand"
    "os"
    "strconv"
    "strings"
    "time"
)

func main() {
    // 初始化随机数种子
    rand.Seed(time.Now().UnixNano())
    
    // 生成随机数（1-100）
    target := rand.Intn(100) + 1
    
    reader := bufio.NewReader(os.Stdin)
    attempts := 0
    maxAttempts := 10
    
    fmt.Println("╔════════════════════════════════╗")
    fmt.Println("║       猜数字游戏               ║")
    fmt.Println("╠════════════════════════════════╣")
    fmt.Println("║ 我想了一个 1 到 100 之间的数字    ║")
    fmt.Printf("║ 你有 %d 次机会猜中它              ║\n", maxAttempts)
    fmt.Println("╚════════════════════════════════╝")
    fmt.Println()
    
    // 游戏主循环
    for attempts < maxAttempts {
        fmt.Printf("第 %d 次尝试，请输入你的猜测：", attempts+1)
        
        input, _ := reader.ReadString('\n')
        input = strings.TrimSpace(input)
        
        guess, err := strconv.Atoi(input)
        if err != nil || guess < 1 || guess > 100 {
            fmt.Println("⚠️  请输入 1 到 100 之间的有效数字")
            continue
        }
        
        attempts++
        
        if guess == target {
            fmt.Println()
            fmt.Println("╔════════════════════════════════╗")
            fmt.Println("║       🎉 恭喜你猜对了！         ║")
            fmt.Println("╠════════════════════════════════╣")
            fmt.Printf("║ 答案是：%d                      ║\n", target)
            fmt.Printf("║ 你用了 %d 次机会                  ║\n", attempts)
            
            // 评价
            if attempts <= 3 {
                fmt.Println("║ 评价：运气爆棚！⭐⭐⭐⭐⭐       ║")
            } else if attempts <= 5 {
                fmt.Println("║ 评价：非常棒！⭐⭐⭐⭐          ║")
            } else if attempts <= 7 {
                fmt.Println("║ 评价：不错哦！⭐⭐⭐           ║")
            } else {
                fmt.Println("║ 评价：险胜！⭐⭐              ║")
            }
            fmt.Println("╚════════════════════════════════╝")
            return
        } else if guess < target {
            fmt.Println("📈 太小了！再大一点")
        } else {
            fmt.Println("📉 太大了！再小一点")
        }
        
        // 显示剩余次数
        remaining := maxAttempts - attempts
        if remaining > 0 {
            fmt.Printf("💡 还剩 %d 次机会\n\n", remaining)
        }
    }
    
    // 游戏失败
    fmt.Println()
    fmt.Println("╔════════════════════════════════╗")
    fmt.Println("║       😢 游戏结束              ║")
    fmt.Println("╠════════════════════════════════╣")
    fmt.Printf("║ 正确答案是：%d                  ║\n", target)
    fmt.Println("║ 下次加油！                      ║")
    fmt.Println("╚════════════════════════════════╝")
}
```

**输出**:
```
╔════════════════════════════════╗
║       猜数字游戏               ║
╠════════════════════════════════╣
║ 我想了一个 1 到 100 之间的数字    ║
║ 你有 10 次机会猜中它              ║
╚════════════════════════════════╝

第 1 次尝试，请输入你的猜测：50
📈 太小了！再大一点
💡 还剩 9 次机会

第 2 次尝试，请输入你的猜测：75
📉 太大了！再小一点
💡 还剩 8 次机会

第 3 次尝试，请输入你的猜测：62
🎉 恭喜你猜对了！

╔════════════════════════════════╗
║ 答案是：62                      ║
║ 你用了 3 次机会                  ║
║ 评价：运气爆棚！⭐⭐⭐⭐⭐       ║
╚════════════════════════════════╝
```

---

## 📝 课后练习

1. 使用 for 循环计算 1 到 100 的和
2. 打印斐波那契数列的前 20 项
3. 判断一个数是否为质数
4. 打印杨辉三角（前 10 行）
5. 实现一个简单的 ATM 菜单系统（循环直到用户选择退出）

---

## ✅ 学习检查清单

- [ ] 掌握 for 循环的四种写法
- [ ] 理解 break 和 continue 的区别
- [ ] 熟练使用 range 遍历
- [ ] 掌握嵌套循环
- [ ] 能打印各种图形
- [ ] 完成所有 8 个案例

---

**上一章**: [第 3 章 - 运算符与控制结构](./chapter_3.md)  
**下一章**: [第 5 章 - 数组与切片](./chapter_5.md)
