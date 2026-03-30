# 第 1 章 - 环境搭建与第一个 Go 程序

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 2 小时  
**代码量**: 300 行  
**案例数**: 5 个

---

## 🎯 学习目标

1. 安装 Go 开发环境
2. 配置 GOPATH 和 GOMOD
3. 编写并运行第一个 Go 程序
4. 理解 Go 语言的基本特点

---

## 📚 理论讲解

### 一、Go 语言简介

#### 1.1 Go 语言历史

Go 语言由 Google 于 2007 年开始设计，2009 年正式发布。设计者是 Robert Griesemer、Rob Pike 和 Ken Thompson（Unix 和 C 语言之父）。

**设计目标**:
- 编译速度快
- 执行效率高
- 语法简洁易读
- 并发支持优秀

#### 1.2 Go 语言特点

**简洁性**:
- 只有 25 个关键字
- 代码可读性强
- 学习曲线平缓

**高效性**:
- 编译速度快，接近 C/C++
- 运行效率高，有垃圾回收
- 并发模型优秀（goroutine）

**实用性**:
- 标准库丰富，开箱即用
- 工具链完善（go fmt、go test 等）
- 社区活跃，生态繁荣

---

## 💻 实战案例

### 案例 1: Hello World

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, Go!")
}
```

**运行方式**:
```bash
# 保存为 main.go，然后运行
go run main.go

# 输出
Hello, Go!
```

**代码解析**:
- `package main`: 声明包名，main 包是程序入口
- `import "fmt"`: 导入格式化输出包
- `func main()`: 主函数，程序入口点
- `fmt.Println()`: 打印输出并换行

---

### 案例 2: 变量声明与使用

```go
package main

import "fmt"

func main() {
    // 方式 1: 显式声明
    var name string = "Alice"
    var age int = 25
    
    // 方式 2: 短变量声明（推荐）
    city := "Beijing"
    score := 95.5
    
    // 方式 3: 多变量声明
    var x, y int = 10, 20
    
    // 方式 4: 类型推断
    var z = 30
    
    fmt.Println("姓名:", name)
    fmt.Println("年龄:", age)
    fmt.Println("城市:", city)
    fmt.Println("分数:", score)
    fmt.Println("x + y =", x + y)
    fmt.Println("z =", z)
}
```

**输出**:
```
姓名：Alice
年龄：25
城市：Beijing
分数：95.5
x + y = 30
z = 30
```

---

### 案例 3: 用户交互

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "strings"
)

func main() {
    fmt.Println("=== 欢迎使用 Go 程序 ===")
    fmt.Println()
    
    // 读取用户输入
    reader := bufio.NewReader(os.Stdin)
    
    fmt.Print("请输入你的名字：")
    name, _ := reader.ReadString('\n')
    name = strings.TrimSpace(name)
    
    fmt.Print("请输入你的年龄：")
    age, _ := reader.ReadString('\n')
    age = strings.TrimSpace(age)
    
    fmt.Println()
    fmt.Println("=== 个人信息 ===")
    fmt.Printf("你好，%s！你今年 %s 岁。\n", name, age)
    fmt.Println("欢迎学习 Go 语言！")
}
```

**输出**:
```
=== 欢迎使用 Go 程序 ===

请输入你的名字：张三
请输入你的年龄：25

=== 个人信息 ===
你好，张三！你今年 25 岁。
欢迎学习 Go 语言！
```

---

### 案例 4: 简单计算器

```go
package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

func main() {
    reader := bufio.NewReader(os.Stdin)
    
    fmt.Println("=== 简易计算器 ===")
    fmt.Println()
    
    // 读取第一个数字
    fmt.Print("请输入第一个数字：")
    num1Str, _ := reader.ReadString('\n')
    num1Str = strings.TrimSpace(num1Str)
    num1, _ := strconv.ParseFloat(num1Str, 64)
    
    // 读取第二个数字
    fmt.Print("请输入第二个数字：")
    num2Str, _ := reader.ReadString('\n')
    num2Str = strings.TrimSpace(num2Str)
    num2, _ := strconv.ParseFloat(num2Str, 64)
    
    // 计算并输出结果
    fmt.Println()
    fmt.Println("=== 计算结果 ===")
    fmt.Printf("%.2f + %.2f = %.2f\n", num1, num2, num1+num2)
    fmt.Printf("%.2f - %.2f = %.2f\n", num1, num2, num1-num2)
    fmt.Printf("%.2f × %.2f = %.2f\n", num1, num2, num1*num2)
    
    if num2 != 0 {
        fmt.Printf("%.2f ÷ %.2f = %.2f\n", num1, num2, num1/num2)
    } else {
        fmt.Println("除数不能为零")
    }
}
```

**输出**:
```
=== 简易计算器 ===

请输入第一个数字：10
请输入第二个数字：5

=== 计算结果 ===
10.00 + 5.00 = 15.00
10.00 - 5.00 = 5.00
10.00 × 5.00 = 50.00
10.00 ÷ 5.00 = 2.00
```

---

### 案例 5: 个人信息卡片

```go
package main

import "fmt"

func main() {
    // 个人信息
    name := "李四"
    age := 28
    city := "上海"
    hobby := "编程"
    github := "https://github.com/lisi"
    
    // 打印卡片
    fmt.Println("╔══════════════════════════════════╗")
    fmt.Println("║       个人信息卡片               ║")
    fmt.Println("╠══════════════════════════════════╣")
    fmt.Printf("║ 姓名：%-24s ║\n", name)
    fmt.Printf("║ 年龄：%-24d ║\n", age)
    fmt.Printf("║ 城市：%-24s ║\n", city)
    fmt.Printf("║ 爱好：%-24s ║\n", hobby)
    fmt.Printf("║ GitHub: %-23s ║\n", github)
    fmt.Println("╚══════════════════════════════════╝")
}
```

**输出**:
```
╔══════════════════════════════════╗
║       个人信息卡片               ║
╠══════════════════════════════════╣
║ 姓名：李四                       ║
║ 年龄：28                         ║
║ 城市：上海                       ║
║ 爱好：编程                       ║
║ GitHub: https://github.com/lisi ║
╚══════════════════════════════════╝
```

---

## 🛠️ 环境搭建指南

### 安装 Go（以 Linux 为例）

```bash
# 1. 下载 Go（以 1.21 版本为例）
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz

# 2. 解压到 /usr/local
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

# 3. 配置环境变量
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# 4. 验证安装
go version
```

### 配置 GOPATH 和 GOMOD

```bash
# 创建 GOPATH 目录
mkdir -p ~/go/{bin,pkg,src}

# 配置环境变量
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc

# 启用 Go Modules（Go 1.11+ 默认启用）
export GO111MODULE=on

# 重新加载配置
source ~/.bashrc
```

---

## 📝 课后练习

1. 安装 Go 环境并验证（`go version`）
2. 编写 Hello World 程序并运行
3. 编写一个程序，输出你的个人信息
4. 实现一个简单的问候程序，根据输入的名字输出问候语
5. 尝试修改计算器，支持更多运算（如取余、幂运算）

---

## ✅ 学习检查清单

- [ ] 成功安装 Go 环境
- [ ] 理解 Go 语言的特点
- [ ] 掌握变量声明的多种方式
- [ ] 完成所有 5 个案例
- [ ] 独立完成课后练习

---

## 📖 扩展阅读

1. [Go 官方文档](https://golang.org/doc/)
2. [Go by Example](https://gobyexample.com/)
3. [Effective Go](https://golang.org/doc/effective_go.html)
4. [Go 语言中文网](https://studygolang.com/)

---

**下一章**: [第 2 章 - 变量与数据类型](./chapter_2.md)
