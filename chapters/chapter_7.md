# 第 7 章 - 函数基础

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3 小时  
**代码量**: 600 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 理解函数的定义与调用方式
2. 掌握参数传递的机制
3. 学会使用多返回值和命名返回值
4. 掌握可变参数的使用
5. 理解值传递和引用传递的区别

---

## 📚 理论讲解

### 一、函数基础

#### 1.1 函数定义

```go
func 函数名 (参数 1 类型，参数 2 类型) (返回值类型 1, 返回值类型 2) {
    // 函数体
    return 值 1, 值 2
}
```

#### 1.2 函数特点

- 函数是第一类公民（可以作为参数、返回值）
- 支持多返回值
- 支持命名返回值
- 支持可变参数
- 只有值传递（没有引用传递）

### 二、参数传递

**Go 语言只有值传递**：
- 基本类型：传递值的拷贝
- 切片、Map：传递引用类型的拷贝（仍指向同一底层数据）
- 指针：传递指针的拷贝

---

## 💻 实战案例

### 案例 1: 基础函数

```go
package main

import "fmt"

// 无参数无返回值
func sayHello() {
    fmt.Println("Hello, Go!")
}

// 有参数无返回值
func greet(name string) {
    fmt.Printf("Hello, %s!\n", name)
}

// 有参数有返回值
func add(a, b int) int {
    return a + b
}

// 多返回值
func divide(a, b int) (int, int) {
    return a / b, a % b
}

func main() {
    sayHello()
    greet("Alice")
    
    result := add(10, 20)
    fmt.Printf("10 + 20 = %d\n", result)
    
    q, r := divide(17, 5)
    fmt.Printf("17 ÷ 5 = %d ... %d\n", q, r)
}
```

**输出**:
```
Hello, Go!
Hello, Alice!
10 + 20 = 20
17 ÷ 5 = 3 ... 2
```

---

### 案例 2: 命名返回值

```go
package main

import "fmt"

// 命名返回值
func rectangle(length, width float64) (area, perimeter float64) {
    area = length * width
    perimeter = 2 * (length + width)
    return  // 自动返回 area 和 perimeter
}

// 带命名返回值的复杂计算
func stats(numbers []int) (sum, avg, max, min int) {
    if len(numbers) == 0 {
        return
    }
    
    sum = 0
    max = numbers[0]
    min = numbers[0]
    
    for _, n := range numbers {
        sum += n
        if n > max {
            max = n
        }
        if n < min {
            min = n
        }
    }
    avg = sum / len(numbers)
    return
}

func main() {
    a, p := rectangle(5.0, 3.0)
    fmt.Printf("面积：%.2f, 周长：%.2f\n", a, p)
    
    nums := []int{10, 20, 30, 40, 50}
    sum, avg, max, min := stats(nums)
    fmt.Printf("和：%d, 平均：%d, 最大：%d, 最小：%d\n", sum, avg, max, min)
}
```

**输出**:
```
面积：15.00, 周长：16.00
和：150, 平均：30, 最大：50, 最小：10
```

---

### 案例 3: 可变参数

```go
package main

import "fmt"

// 可变参数
func sum(numbers ...int) int {
    total := 0
    for _, num := range numbers {
        total += num
    }
    return total
}

// 混合参数
func format(prefix string, numbers ...int) string {
    result := prefix + ": "
    for i, num := range numbers {
        if i > 0 {
            result += ", "
        }
        result += fmt.Sprintf("%d", num)
    }
    return result
}

// 展开切片
func average(numbers ...float64) float64 {
    if len(numbers) == 0 {
        return 0
    }
    sum := 0.0
    for _, num := range numbers {
        sum += num
    }
    return sum / float64(len(numbers))
}

func main() {
    fmt.Println("=== 可变参数 ===")
    fmt.Printf("sum(1, 2, 3) = %d\n", sum(1, 2, 3))
    fmt.Printf("sum(10, 20, 30, 40) = %d\n", sum(10, 20, 30, 40))
    fmt.Printf("sum() = %d\n", sum())
    
    fmt.Println("\n=== 混合参数 ===")
    fmt.Println(format("数字", 1, 2, 3, 4, 5))
    fmt.Println(format("成绩", 85, 90, 78, 92))
    
    fmt.Println("\n=== 展开切片 ===")
    scores := []float64{85.5, 90.0, 78.5, 92.0}
    fmt.Printf("平均分：%.2f\n", average(scores...))
}
```

**输出**:
```
=== 可变参数 ===
sum(1, 2, 3) = 6
sum(10, 20, 30, 40) = 100
sum() = 0

=== 混合参数 ===
数字：1, 2, 3, 4, 5
成绩：85, 90, 78, 92

=== 展开切片 ===
平均分：86.50
```

---

### 案例 4: 值传递 vs 引用传递

```go
package main

import "fmt"

// 值传递 - 修改不影响原值
func modifyByValue(x int) {
    x = 100
    fmt.Printf("函数内：x = %d\n", x)
}

// 指针传递 - 修改影响原值
func modifyByPointer(x *int) {
    *x = 100
    fmt.Printf("函数内：*x = %d\n", *x)
}

// 切片传递 - 引用类型
func modifySlice(slice []int) {
    slice[0] = 999
    fmt.Printf("函数内：slice = %v\n", slice)
}

// Map 传递 - 引用类型
func modifyMap(m map[string]int) {
    m["new"] = 100
    fmt.Printf("函数内：m = %v\n", m)
}

func main() {
    // 值传递
    fmt.Println("=== 值传递 ===")
    a := 10
    modifyByValue(a)
    fmt.Printf("调用后：a = %d\n\n", a)
    
    // 指针传递
    fmt.Println("=== 指针传递 ===")
    b := 10
    modifyByPointer(&b)
    fmt.Printf("调用后：b = %d\n\n", b)
    
    // 切片传递
    fmt.Println("=== 切片传递 ===")
    s := []int{1, 2, 3}
    fmt.Printf("调用前：s = %v\n", s)
    modifySlice(s)
    fmt.Printf("调用后：s = %v\n\n", s)
    
    // Map 传递
    fmt.Println("=== Map 传递 ===")
    m := map[string]int{"a": 1}
    fmt.Printf("调用前：m = %v\n", m)
    modifyMap(m)
    fmt.Printf("调用后：m = %v\n", m)
}
```

**输出**:
```
=== 值传递 ===
函数内：x = 100
调用后：a = 10

=== 指针传递 ===
函数内：*x = 100
调用后：b = 100

=== 切片传递 ===
调用前：s = [1 2 3]
函数内：slice = [999 2 3]
调用后：s = [999 2 3]

=== Map 传递 ===
调用前：m = map[a:1]
函数内：m = map[a:1 new:100]
调用后：m = map[a:1 new:100]
```

---

### 案例 5: 递归函数

```go
package main

import "fmt"

// 阶乘
func factorial(n int) int {
    if n <= 1 {
        return 1
    }
    return n * factorial(n-1)
}

// 斐波那契
func fibonacci(n int) int {
    if n <= 1 {
        return n
    }
    return fibonacci(n-1) + fibonacci(n-2)
}

// 递归求和
func recursiveSum(n int) int {
    if n == 0 {
        return 0
    }
    return n + recursiveSum(n-1)
}

// 递归计算幂
func power(base, exp int) int {
    if exp == 0 {
        return 1
    }
    return base * power(base, exp-1)
}

func main() {
    fmt.Println("=== 阶乘 ===")
    for i := 1; i <= 10; i++ {
        fmt.Printf("%d! = %d\n", i, factorial(i))
    }
    
    fmt.Println("\n=== 斐波那契 ===")
    fmt.Println("前 15 项:")
    for i := 0; i < 15; i++ {
        fmt.Printf("%d ", fibonacci(i))
    }
    fmt.Println()
    
    fmt.Println("\n=== 递归求和 ===")
    fmt.Printf("1+2+...+100 = %d\n", recursiveSum(100))
    
    fmt.Println("\n=== 幂运算 ===")
    fmt.Printf("2^10 = %d\n", power(2, 10))
    fmt.Printf("3^4 = %d\n", power(3, 4))
}
```

**输出**:
```
=== 阶乘 ===
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
6! = 720
7! = 5040
8! = 40320
9! = 362880
10! = 3628800

=== 斐波那契 ===
前 15 项:
0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 

=== 递归求和 ===
1+2+...+100 = 5050

=== 幂运算 ===
2^10 = 1024
3^4 = 81
```

---

### 案例 6: 工具函数库

```go
package main

import "fmt"

// 最大值
func Max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

// 最小值
func Min(a, b int) int {
    if a < b {
        return a
    }
    return b
}

// 绝对值
func Abs(x int) int {
    if x < 0 {
        return -x
    }
    return x
}

// 交换
func Swap(a, b int) (int, int) {
    return b, a
}

// 判断奇偶
func IsEven(n int) bool {
    return n%2 == 0
}

// 判断质数
func IsPrime(n int) bool {
    if n <= 1 {
        return false
    }
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            return false
        }
    }
    return true
}

func main() {
    fmt.Println("=== 工具函数演示 ===")
    fmt.Printf("Max(10, 20) = %d\n", Max(10, 20))
    fmt.Printf("Min(10, 20) = %d\n", Min(10, 20))
    fmt.Printf("Abs(-5) = %d\n", Abs(-5))
    
    x, y := 100, 200
    x, y = Swap(x, y)
    fmt.Printf("Swap 后：x=%d, y=%d\n", x, y)
    
    fmt.Printf("\nIsEven(10) = %t\n", IsEven(10))
    fmt.Printf("IsEven(7) = %t\n", IsEven(7))
    
    fmt.Println("\n100 以内的质数:")
    for i := 1; i <= 100; i++ {
        if IsPrime(i) {
            fmt.Printf("%d ", i)
        }
    }
    fmt.Println()
}
```

**输出**:
```
=== 工具函数演示 ===
Max(10, 20) = 20
Min(10, 20) = 10
Abs(-5) = 5
Swap 后：x=200, y=100

IsEven(10) = true
IsEven(7) = false

100 以内的质数:
2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97 
```

---

### 案例 7: 数学计算器

```go
package main

import (
    "fmt"
    "math"
)

func add(a, b float64) float64    { return a + b }
func subtract(a, b float64) float64 { return a - b }
func multiply(a, b float64) float64 { return a * b }
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("除数不能为零")
    }
    return a / b, nil
}
func power(base, exp float64) float64 { return math.Pow(base, exp) }
func sqrt(x float64) (float64, error) {
    if x < 0 {
        return 0, fmt.Errorf("不能计算负数的平方根")
    }
    return math.Sqrt(x), nil
}

func main() {
    fmt.Println("=== 简易计算器 ===")
    
    a, b := 10.0, 5.0
    fmt.Printf("%.2f + %.2f = %.2f\n", a, b, add(a, b))
    fmt.Printf("%.2f - %.2f = %.2f\n", a, b, subtract(a, b))
    fmt.Printf("%.2f × %.2f = %.2f\n", a, b, multiply(a, b))
    
    result, err := divide(a, b)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("%.2f ÷ %.2f = %.2f\n", a, b, result)
    }
    
    fmt.Printf("\n2^10 = %.2f\n", power(2, 10))
    
    root, err := sqrt(144)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("√144 = %.2f\n", root)
    }
}
```

**输出**:
```
=== 简易计算器 ===
10.00 + 5.00 = 15.00
10.00 - 5.00 = 5.00
10.00 × 5.00 = 50.00
10.00 ÷ 5.00 = 2.00

2^10 = 1024.00
√144 = 12.00
```

---

### 案例 8: 字符串处理函数

```go
package main

import (
    "fmt"
    "strings"
    "unicode"
)

// 反转字符串
func reverse(s string) string {
    runes := []rune(s)
    for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
        runes[i], runes[j] = runes[j], runes[i]
    }
    return string(runes)
}

// 判断回文
func isPalindrome(s string) bool {
    s = strings.ToLower(s)
    var cleaned strings.Builder
    for _, r := range s {
        if unicode.IsLetter(r) || unicode.IsNumber(r) {
            cleaned.WriteRune(r)
        }
    }
    cleanedStr := cleaned.String()
    return cleanedStr == reverse(cleanedStr)
}

// 统计字符
func countChars(s string) map[rune]int {
    freq := make(map[rune]int)
    for _, r := range s {
        freq[r]++
    }
    return freq
}

// 首字母大写
func titleCase(s string) string {
    words := strings.Fields(s)
    for i, word := range words {
        if len(word) > 0 {
            words[i] = strings.ToUpper(string(word[0])) + strings.ToLower(word[1:])
        }
    }
    return strings.Join(words, " ")
}

func main() {
    fmt.Println("=== 字符串处理 ===")
    
    fmt.Printf("reverse('Hello') = %s\n", reverse("Hello"))
    fmt.Printf("reverse('世界') = %s\n", reverse("世界"))
    
    fmt.Println("\n=== 回文判断 ===")
    tests := []string{"A man a plan a canal Panama", "hello", "上海自来水来自海上"}
    for _, test := range tests {
        fmt.Printf("%q 是回文吗？%t\n", test, isPalindrome(test))
    }
    
    fmt.Println("\n=== 字符统计 ===")
    freq := countChars("hello")
    for ch, count := range freq {
        fmt.Printf("'%c': %d 次\n", ch, count)
    }
    
    fmt.Println("\n=== 首字母大写 ===")
    fmt.Printf("titleCase('hello world') = %s\n", titleCase("hello world"))
}
```

**输出**:
```
=== 字符串处理 ===
reverse('Hello') = olleH
reverse('世界') = 界世

=== 回文判断 ===
"A man a plan a canal Panama" 是回文吗？true
"hello" 是回文吗？false
"上海自来水来自海上" 是回文吗？true

=== 字符统计 ===
'h': 1 次
'e': 1 次
'l': 2 次
'o': 1 次

=== 首字母大写 ===
titleCase('hello world') = Hello World
```

---

### 案例 9: 综合应用 - 学生管理系统

```go
package main

import "fmt"

type Student struct {
    ID     int
    Name   string
    Scores []int
}

func NewStudent(id int, name string, scores ...int) Student {
    return Student{ID: id, Name: name, Scores: scores}
}

func (s *Student) AddScore(score int) {
    s.Scores = append(s.Scores, score)
}

func (s *Student) Average() float64 {
    if len(s.Scores) == 0 {
        return 0
    }
    sum := 0
    for _, score := range s.Scores {
        sum += score
    }
    return float64(sum) / float64(len(s.Scores))
}

func (s *Student) MaxScore() int {
    if len(s.Scores) == 0 {
        return 0
    }
    max := s.Scores[0]
    for _, score := range s.Scores[1:] {
        if score > max {
            max = score
        }
    }
    return max
}

func (s *Student) MinScore() int {
    if len(s.Scores) == 0 {
        return 0
    }
    min := s.Scores[0]
    for _, score := range s.Scores[1:] {
        if score < min {
            min = score
        }
    }
    return min
}

func (s *Student) String() string {
    return fmt.Sprintf("Student{ID:%d, Name:%s, Avg:%.2f}", 
        s.ID, s.Name, s.Average())
}

func main() {
    // 创建学生
    s1 := NewStudent(1, "张三", 85, 90, 78)
    s2 := NewStudent(2, "李四", 92, 88, 95)
    
    fmt.Println("=== 学生信息 ===")
    fmt.Println(s1)
    fmt.Println(s2)
    
    // 添加成绩
    s1.AddScore(92)
    fmt.Printf("\n张三添加成绩后：%v\n", s1)
    
    // 详细统计
    fmt.Println("\n=== 张三成绩统计 ===")
    fmt.Printf("平均分：%.2f\n", s1.Average())
    fmt.Printf("最高分：%d\n", s1.MaxScore())
    fmt.Printf("最低分：%d\n", s1.MinScore())
}
```

**输出**:
```
=== 学生信息 ===
Student{ID:1, Name:张三，Avg:84.33}
Student{ID:2, Name:李四，Avg:91.67}

张三添加成绩后：Student{ID:1, Name:张三，Avg:86.25}

=== 张三成绩统计 ===
平均分：86.25
最高分：92
最低分：78
```

---

## 📝 课后练习

1. 编写一个函数，计算两个数的最大公约数
2. 实现一个函数，判断一个年份是否为闰年
3. 编写函数，将整数转换为罗马数字
4. 实现一个简单的加密/解密函数
5. 编写函数，计算圆的面积和周长

---

## ✅ 学习检查清单

- [ ] 理解函数定义语法
- [ ] 掌握多返回值用法
- [ ] 会使用命名返回值
- [ ] 理解可变参数
- [ ] 区分值传递和引用传递
- [ ] 能编写递归函数
- [ ] 完成所有 9 个案例

---

**上一章**: [第 6 章 - Map 集合](./chapter_6.md)  
**下一章**: [第 8 章 - 函数进阶](./chapter_8.md)
