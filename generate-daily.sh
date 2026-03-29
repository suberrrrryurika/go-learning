#!/bin/bash
# 📚 Go 语言学习 - 每日内容生成脚本（增强版）
# 每天 8:00 自动执行，生成当日学习内容

set -e

WORKSPACE="/home/admin/.openclaw/workspace/go-learning"
DAILY_DIR="$WORKSPACE/daily"
START_DATE="2026-03-29"

# 计算今日是第几天
TODAY=$(date +%Y-%m-%d)
START_TS=$(date -d "$START_DATE" +%s)
TODAY_TS=$(date -d "$TODAY" +%s)
DAY_NUM=$(( (TODAY_TS - START_TS) / 86400 + 1 ))

# 限制在 90 天内
if [ $DAY_NUM -lt 1 ]; then
    DAY_NUM=1
elif [ $DAY_NUM -gt 90 ]; then
    DAY_NUM=90
fi

echo "📚 生成第 $DAY_NUM 天学习内容 ($TODAY)"

# 创建目录
mkdir -p "$DAILY_DIR"

# 计算阶段
if [ $DAY_NUM -le 15 ]; then
    STAGE=1
    STAGE_NAME="基础"
elif [ $DAY_NUM -le 30 ]; then
    STAGE=2
    STAGE_NAME="进阶"
elif [ $DAY_NUM -le 60 ]; then
    STAGE=3
    STAGE_NAME="实战"
else
    STAGE=4
    STAGE_NAME="高级"
fi

# 生成学习内容
cat > "$DAILY_DIR/${TODAY}.md" << EOF
# 📅 第 $DAY_NUM 天 - Go 语言学习

**日期**: $TODAY  
**阶段**: 第$STAGE 阶段 - $STAGE_NAME  
**预计时长**: 2-3 小时

---

## 🎯 今日学习目标

1. 掌握核心知识点
2. 完成代码示例
3. 实战练习项目
4. 记录学习笔记

---

## 📚 学习内容

### 1. 理论知识

#### 核心概念

Go 语言是一种静态类型、编译型的编程语言，由 Google 开发。

**主要特点**:
- 简洁的语法
- 内置并发支持 (goroutine)
- 快速的编译速度
- 强大的标准库
- 垃圾回收机制

#### 重点知识

1. **变量声明**: 使用 \`var\` 或 \`:=\` 简短声明
2. **数据类型**: 基本类型（int, float, string, bool）和复合类型（数组、切片、map）
3. **控制结构**: if-else, switch, for 循环
4. **函数**: 多返回值、命名返回值、可变参数
5. **错误处理**: error 类型，defer, panic, recover

---

### 2. 代码示例

#### 示例 1: Hello World

\`\`\`go
package main

import "fmt"

func main() {
    fmt.Println("Hello, 世界!")
    fmt.Println("第 $DAY_NUM 天学习")
}
\`\`\`

**运行**:
\`\`\`bash
go run main.go
\`\`\`

**输出**:
\`\`\`
Hello, 世界!
第 $DAY_NUM 天学习
\`\`\`

---

#### 示例 2: 变量与数据类型

\`\`\`go
package main

import "fmt"

func main() {
    // 变量声明
    var name string = "Go 语言"
    var version float64 = 1.21
    var isAwesome bool = true
    
    // 简短声明
    age := 10
    language := "Go"
    
    // 多变量声明
    var x, y, z int = 1, 2, 3
    
    fmt.Printf("名称：%s\\n", name)
    fmt.Printf("版本：%.2f\\n", version)
    fmt.Printf("很棒吗：%v\\n", isAwesome)
    fmt.Printf("年龄：%d\\n", age)
    fmt.Printf("语言：%s\\n", language)
    fmt.Printf("多变量：%d, %d, %d\\n", x, y, z)
}
\`\`\`

**输出**:
\`\`\`
名称：Go 语言
版本：1.21
很棒吗：true
年龄：10
语言：Go
多变量：1, 2, 3
\`\`\`

---

#### 示例 3: 函数与多返回值

\`\`\`go
package main

import "fmt"

// 多返回值函数
func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("除数不能为零")
    }
    return a / b, nil
}

// 命名返回值
func calc(a, b int) (sum int, diff int, product int) {
    sum = a + b
    diff = a - b
    product = a * b
    return
}

func main() {
    // 多返回值
    result, err := divide(10, 3)
    if err != nil {
        fmt.Printf("错误：%v\\n", err)
        return
    }
    fmt.Printf("10 / 3 = %.2f\\n", result)
    
    // 命名返回值
    s, d, p := calc(10, 5)
    fmt.Printf("和：%d, 差：%d, 积：%d\\n", s, d, p)
}
\`\`\`

**输出**:
\`\`\`
10 / 3 = 3.33
和：15, 差：5, 积：50
\`\`\`

---

### 3. 实战练习

#### 练习 1: 个人信息卡片

**要求**: 创建一个程序，显示个人信息

\`\`\`go
package main

import "fmt"

func main() {
    // TODO: 完成以下功能
    // 1. 声明姓名、年龄、城市变量
    // 2. 使用 fmt.Printf 格式化输出
    // 3. 输出格式：姓名：xxx, 年龄：xx, 城市：xxx
    
    // 在此编写代码
    
}
\`\`\`

**参考答案**:
\`\`\`go
package main

import "fmt"

func main() {
    name := "张三"
    age := 25
    city := "北京"
    
    fmt.Printf("姓名：%s, 年龄：%d, 城市：%s\\n", name, age, city)
}
\`\`\`

---

#### 练习 2: 简单计算器

**要求**: 实现加减乘除四则运算

\`\`\`go
package main

import "fmt"

// TODO: 实现以下函数
// func add(a, b int) int
// func subtract(a, b int) int
// func multiply(a, b int) int
// func divide(a, b int) (int, error)

func main() {
    a, b := 20, 5
    
    // 调用上述函数并输出结果
    
}
\`\`\`

**参考答案**:
\`\`\`go
package main

import (
    "errors"
    "fmt"
)

func add(a, b int) int {
    return a + b
}

func subtract(a, b int) int {
    return a - b
}

func multiply(a, b int) int {
    return a * b
}

func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, errors.New("除数不能为零")
    }
    return a / b, nil
}

func main() {
    a, b := 20, 5
    
    fmt.Printf("%d + %d = %d\\n", a, b, add(a, b))
    fmt.Printf("%d - %d = %d\\n", a, b, subtract(a, b))
    fmt.Printf("%d * %d = %d\\n", a, b, multiply(a, b))
    
    if result, err := divide(a, b); err == nil {
        fmt.Printf("%d / %d = %d\\n", a, b, result)
    }
}
\`\`\`

---

#### 练习 3: 温度转换器

**要求**: 摄氏度和华氏度互相转换

**公式**:
- 摄氏度转华氏度：F = C × 9/5 + 32
- 华氏度转摄氏度：C = (F - 32) × 5/9

\`\`\`go
package main

import "fmt"

// TODO: 实现转换函数
// func celsiusToFahrenheit(c float64) float64
// func fahrenheitToCelsius(f float64) float64

func main() {
    // 测试转换
    // 0°C = 32°F
    // 100°C = 212°F
    // 32°F = 0°C
    // 212°F = 100°C
}
\`\`\`

**参考答案**:
\`\`\`go
package main

import "fmt"

func celsiusToFahrenheit(c float64) float64 {
    return c * 9.0 / 5.0 + 32.0
}

func fahrenheitToCelsius(f float64) float64 {
    return (f - 32.0) * 5.0 / 9.0
}

func main() {
    fmt.Println("=== 温度转换器 ===")
    
    // 摄氏度转华氏度
    celsius := []float64{0, 25, 37, 100}
    for _, c := range celsius {
        f := celsiusToFahrenheit(c)
        fmt.Printf("%.1f°C = %.1f°F\\n", c, f)
    }
    
    fmt.Println()
    
    // 华氏度转摄氏度
    fahrenheit := []float64{32, 77, 98.6, 212}
    for _, f := range fahrenheit {
        c := fahrenheitToCelsius(f)
        fmt.Printf("%.1f°F = %.1f°C\\n", f, c)
    }
}
\`\`\`

---

## ✅ 今日检查清单

- [ ] 完成理论学习
- [ ] 阅读所有代码示例
- [ ] 完成练习 1: 个人信息卡片
- [ ] 完成练习 2: 简单计算器
- [ ] 完成练习 3: 温度转换器
- [ ] 记录学习笔记
- [ ] 提交代码到 GitHub

---

## 📖 扩展阅读

1. [Go 官方文档](https://golang.org/doc/)
2. [Go by Example](https://gobyexample.com/)
3. [Effective Go](https://golang.org/doc/effective_go.html)

---

## 💡 小贴士

1. **使用 gofmt**: 始终用 \`gofmt\` 格式化代码
2. **错误处理**: 不要忽略错误返回值
3. **命名规范**: 使用有意义的变量名
4. **注释**: 为复杂逻辑添加注释
5. **测试**: 为重要函数编写测试

---

**继续加油！明天学习第 $((DAY_NUM + 1)) 天内容！** 🚀
EOF

echo "✅ 已生成：$DAILY_DIR/${TODAY}.md"

# 更新 today.md 软链接
ln -sf "${TODAY}.md" "$DAILY_DIR/today.md"
echo "✅ 已更新 today.md 链接"

# 提交更改
cd "$WORKSPACE"
git add daily/${TODAY}.md
git commit -m "feat: 生成第 $DAY_NUM 天学习内容 ($TODAY)" || echo "⏭️ 无更改"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 第 $DAY_NUM 天学习内容已生成"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📄 文件位置：$DAILY_DIR/${TODAY}.md"
echo "🔗 访问链接：https://go-learning.pages.dev/learn.html?day=$DAY_NUM"
echo "⏰ 下次生成：明天 8:00"
echo ""
