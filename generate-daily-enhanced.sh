#!/bin/bash
# Go 语言每日学习内容生成脚本（增强版）

WORKSPACE="/home/admin/.openclaw/workspace/go-learning"
DAILY_DIR="$WORKSPACE/daily"
DATE=$(date +%Y-%m-%d)

# 计算学习天数
START_DATE="2026-03-29"
START_EPOCH=$(date -d "$START_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
DAY_NUMBER=$(( (CURRENT_EPOCH - START_EPOCH) / 86400 + 1 ))

if [ $DAY_NUMBER -lt 1 ]; then
    DAY_NUMBER=1
fi

# 确定阶段
if [ $DAY_NUMBER -le 15 ]; then
    STAGE="基础"
    STAGE_EN="basic"
elif [ $DAY_NUMBER -le 30 ]; then
    STAGE="进阶"
    STAGE_EN="advanced"
elif [ $DAY_NUMBER -le 60 ]; then
    STAGE="实战"
    STAGE_EN="practice"
else
    STAGE="高级"
    STAGE_EN="expert"
fi

# 创建每日学习文件（增强版）
cat > "$DAILY_DIR/$DATE.md" << EOF
# 📅 Go 语言学习 - 第 $DAY_NUMBER 天

**日期**: $DATE  
**阶段**: 第$STAGE 阶段 - Go 语言$STAGE  
**学习天数**: 第$DAY_NUMBER 天 / 90 天  
**预计时间**: 3-4 小时

---

## 🎯 今日学习目标

### 核心内容
1. ✅ 学习主题知识点
2. ✅ 掌握核心概念
3. ✅ 完成代码示例
4. ✅ 实战练习项目
5. ✅ 理解最佳实践
6. ✅ 代码审查要点

---

## 📚 详细学习内容

### 1. 理论知识（45 分钟）

#### 概念讲解
\`\`\`
详细说明今日学习的主要概念
包括定义、特点、使用场景等
\`\`\`

#### 核心要点
- 要点 1：详细说明
- 要点 2：详细说明
- 要点 3：详细说明

#### 注意事项
⚠️ **重要**: 需要特别注意的地方
💡 **提示**: 实用小技巧
❌ **避免**: 常见错误

---

### 2. 代码示例（60 分钟）

#### 示例 1: 基础示例
\`\`\`go
package main

import "fmt"

func main() {
    // 今日学习的基础代码示例
    fmt.Println("基础示例代码")
    
    // 包含详细注释
    // 帮助理解每行代码
}
\`\`\`

**运行方式**:
\`\`\`bash
go run example1.go
\`\`\`

**输出结果**:
\`\`\`
基础示例代码
\`\`\`

#### 示例 2: 进阶示例
\`\`\`go
package main

import "fmt"

// 函数说明
func advancedExample() {
    // 进阶代码示例
    // 展示更复杂的用法
}

func main() {
    advancedExample()
}
\`\`\`

#### 示例 3: 完整项目
\`\`\`go
// 完整的实战项目代码
// 包含多个函数和模块
// 展示实际应用场景
\`\`\`

---

### 3. 实战练习（90 分钟）

#### 练习 1: 基础练习
\`\`\`go
// 任务：完成以下功能
// 要求：
// 1. 功能说明 1
// 2. 功能说明 2
// 3. 功能说明 3

package main

import "fmt"

func main() {
    // 在此完成练习
}
\`\`\`

#### 练习 2: 进阶练习
\`\`\`go
// 任务：实现更复杂的功能
// 难度：⭐⭐⭐
// 时间：30 分钟
\`\`\`

#### 练习 3: 综合项目
\`\`\`go
// 综合应用今日所学知识
// 完成一个完整的小项目
// 代码量：100-200 行
\`\`\`

---

## 💻 代码模板

### 模板 1: 标准结构
\`\`\`go
package main

import (
    "fmt"
)

func init() {
    // 初始化代码
}

func main() {
    // 主程序逻辑
}
\`\`\`

### 模板 2: 函数定义
\`\`\`go
// 函数名：功能说明
// 参数：param 参数说明
// 返回：返回值说明
func functionName(param string) (result int, err error) {
    // 函数实现
    return result, nil
}
\`\`\`

---

## 📖 扩展阅读

### 官方文档
- [Go 官方文档](https://go.dev/doc/)
- [Go 语言规范](https://go.dev/ref/spec)

### 教程资源
- [Go by Example](https://gobyexample.com/)
- [Tour of Go](https://go.dev/tour/)

### 相关文章
- [最佳实践文章链接]
- [技术博客文章]

---

## ✅ 今日检查清单

### 理论学习
- [ ] 理解核心概念
- [ ] 掌握关键知识点
- [ ] 了解应用场景

### 代码练习
- [ ] 完成示例 1
- [ ] 完成示例 2
- [ ] 完成示例 3
- [ ] 完成练习 1
- [ ] 完成练习 2
- [ ] 完成练习 3

### 复习总结
- [ ] 整理学习笔记
- [ ] 记录遇到的问题
- [ ] 总结解决方案

---

## 🎯 明日预告

**第 $((DAY_NUMBER + 1)) 天**: 下一个知识点

---

**预计学习时间**: 3-4 小时  
**代码量**: 约 300-500 行  
**练习数量**: 3-5 个项目

**学习建议**: 
1. 每个示例都要亲手敲一遍
2. 理解每行代码的作用
3. 尝试修改代码看效果
4. 完成所有练习题
5. 记录学习笔记
EOF

echo "已生成今日学习内容：$DAILY_DIR/$DATE.md"
echo "学习天数：第 $DAY_NUMBER 天"
echo "阶段：$STAGE"

# 更新 today.md
cat > "$WORKSPACE/today.md" << EOF
# 📚 今日 Go 学习内容

**日期**: $DATE  
**第 $DAY_NUMBER 天** - $STAGE 阶段

$(head -50 "$DAILY_DIR/$DATE.md")

...

[查看完整内容]($DAILY_DIR/$DATE.md)
EOF

echo "已更新：$WORKSPACE/today.md"
echo "✅ 生成完成"
