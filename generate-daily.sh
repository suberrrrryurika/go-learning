#!/bin/bash
# Go 语言每日学习内容生成脚本

WORKSPACE="/home/admin/.openclaw/workspace/go-learning"
DAILY_DIR="$WORKSPACE/daily"
DATE=$(date +%Y-%m-%d)
DAY_OF_YEAR=$(date +%j)

# 计算当前学习天数（从 1 开始）
# 假设从 2026-03-29 开始学习
START_DATE="2026-03-29"
START_EPOCH=$(date -d "$START_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
DAY_NUMBER=$(( (CURRENT_EPOCH - START_EPOCH) / 86400 + 1 ))

# 确保 day_number 至少为 1
if [ $DAY_NUMBER -lt 1 ]; then
    DAY_NUMBER=1
fi

# 根据天数确定阶段和内容
if [ $DAY_NUMBER -le 15 ]; then
    STAGE="基础"
    STAGE_NAME="Go 语言基础"
elif [ $DAY_NUMBER -le 30 ]; then
    STAGE="进阶"
    STAGE_NAME="Go 语言进阶"
elif [ $DAY_NUMBER -le 60 ]; then
    STAGE="实战"
    STAGE_NAME="后台开发实战"
else
    STAGE="高级"
    STAGE_NAME="高级专题"
fi

# 创建每日学习文件
cat > "$DAILY_DIR/$DATE.md" << EOF
# 📅 Go 语言学习 - 第 $DAY_NUMBER 天

**日期**: $DATE  
**阶段**: 第$STAGE 阶段 - $STAGE_NAME  
**学习天数**: 第$DAY_NUMBER 天 / 90 天

---

## 🎯 今日学习目标

EOF

# 根据天数添加具体学习内容
case $DAY_NUMBER in
    1)
        cat >> "$DAILY_DIR/$DATE.md" << 'EOF'
### 主题：Go 语言简介与环境搭建

#### 学习内容
1. 了解 Go 语言的历史和特点
2. 安装 Go 开发环境（Linux/Mac/Windows）
3. 配置 GOPATH 和 GOMOD
4. 编写第一个 Hello World 程序
5. 学习使用 go run 和 go build 命令

#### 实践任务
- [ ] 安装 Go 1.21+ 版本
- [ ] 配置环境变量
- [ ] 创建 hello.go 文件
- [ ] 运行并编译程序
- [ ] 理解 go.mod 文件

#### 代码示例
```go
package main

import "fmt"

func main() {
    fmt.Println("Hello, Go!")
}
```

#### 参考资源
- Go 官网下载：https://go.dev/dl/
- Go 语言规范：https://go.dev/ref/spec
EOF
        ;;
    2)
        cat >> "$DAILY_DIR/$DATE.md" << 'EOF'
### 主题：变量与数据类型

#### 学习内容
1. 变量声明与初始化
2. 基本数据类型（int, float, string, bool）
3. 常量定义
4. 类型转换
5. 零值概念

#### 实践任务
- [ ] 练习各种变量声明方式
- [ ] 理解类型推断
- [ ] 掌握类型转换
- [ ] 了解零值

#### 代码示例
```go
package main

import "fmt"

func main() {
    // 变量声明
    var name string = "Go"
    age := 10  // 类型推断
    
    // 常量
    const Pi = 3.14159
    
    // 类型转换
    var a int = 10
    var b float64 = float64(a)
    
    fmt.Println(name, age, Pi, b)
}
```
EOF
        ;;
    3)
        cat >> "$DAILY_DIR/$DATE.md" << 'EOF'
### 主题：运算符与控制结构

#### 学习内容
1. 算术、关系、逻辑运算符
2. if-else 条件语句
3. switch 语句
4. fallthrough 关键字

#### 实践任务
- [ ] 练习所有运算符
- [ ] 编写条件判断程序
- [ ] 使用 switch 实现多分支
- [ ] 理解 fallthrough

#### 代码示例
```go
package main

import "fmt"

func main() {
    // if-else
    score := 85
    if score >= 90 {
        fmt.Println("优秀")
    } else if score >= 60 {
        fmt.Println("及格")
    } else {
        fmt.Println("不及格")
    }
    
    // switch
    day := 3
    switch day {
    case 1, 2, 3, 4, 5:
        fmt.Println("工作日")
    case 6, 7:
        fmt.Println("周末")
    }
}
```
EOF
        ;;
    *)
        cat >> "$DAILY_DIR/$DATE.md" << EOF
### 主题：第 $DAY_NUMBER 天学习内容

#### 学习内容
请参考学习路线文档的第 $DAY_NUMBER 天内容

#### 实践任务
- [ ] 阅读相关文档
- [ ] 编写示例代码
- [ ] 完成练习题
- [ ] 总结学习笔记

#### 代码示例
```go
package main

import "fmt"

func main() {
    fmt.Println("开始第 $DAY_NUMBER 天的学习！")
}
```

#### 备注
详细内容请参考 \`docs/learning-path.md\` 文件
EOF
        ;;
esac

# 添加通用部分
cat >> "$DAILY_DIR/$DATE.md" << EOF

---

## 📝 学习笔记

（在此记录学习笔记和心得）

---

## ❓ 遇到问题

（在此记录遇到的问题和解决方案）

---

## ✅ 完成打卡

- [ ] 完成今日学习内容
- [ ] 编写代码示例
- [ ] 完成练习题
- [ ] 记录学习笔记

---

**明日预告**: 第 $((DAY_NUMBER + 1)) 天 - 继续学习 $STAGE_NAME

**学习格言**: "千里之行，始于足下" - 每天进步一点点！
EOF

echo "已生成今日学习内容：$DAILY_DIR/$DATE.md"
echo "学习天数：第 $DAY_NUMBER 天"
echo "阶段：$STAGE_NAME"

# 更新今日学习内容到主页
cat > "$WORKSPACE/today.md" << EOF
# 📚 今日 Go 学习内容

**日期**: $DATE  
**第 $DAY_NUMBER 天** - $STAGE_NAME

$(cat "$DAILY_DIR/$DATE.md" | head -50)

...

[查看完整内容]($DAILY_DIR/$DATE.md)
EOF

echo "已更新今日学习：$WORKSPACE/today.md"
