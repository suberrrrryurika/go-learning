# 📘 第 5 章 - 数组与切片：灵活的数据集合

**预计学习时长**: 3 小时  
**难度**: ⭐⭐⭐ 核心基础  
**完成日期**: _待填写_

---

## 🎯 学习目标

1. ✅ 理解数组和切片的区别与联系
2. ✅ 掌握切片的创建、扩容和底层原理
3. ✅ 熟练使用常见的切片操作
4. ✅ 理解切片作为函数参数时的行为

---

## 📚 核心原理

### 数组 (Array)

数组是**固定长度**的同类型元素集合：

```go
// 声明方式
var arr [5]int              // [0 0 0 0 0]
arr2 := [3]int{1, 2, 3}     // [1 2 3]
arr3 := [...]int{1, 2, 3, 4} // [1 2 3 4] 自动推断长度

// 二维数组
matrix := [2][3]int{
    {1, 2, 3},
    {4, 5, 6},
}
```

**数组特点**：
- 长度固定，不可变
- 值类型，赋值会拷贝整个数组
- 实际开发中很少直接使用

### 切片 (Slice)

切片是**动态数组**，更灵活：

```go
// 创建方式
s1 := []int{1, 2, 3}           // 字面量
s2 := make([]int, 5)           // 长度 5，值全 0
s3 := make([]int, 3, 10)       // 长度 3，容量 10

// 从数组/切片截取
arr := [5]int{1, 2, 3, 4, 5}
s4 := arr[1:4]                 // [2 3 4]
s5 := arr[:3]                  // [1 2 3]
s6 := arr[2:]                  // [3 4 5]
```

**切片三要素**：
```go
s := []int{1, 2, 3, 4, 5}
len(s)  // 5 - 长度
cap(s)  // 5 - 容量
s[0]    // 1 - 访问元素
```

### 切片扩容机制

当 `append` 超出容量时自动扩容：

```go
s := make([]int, 3, 5)  // len=3, cap=5
s = append(s, 4)        // len=4, cap=5
s = append(s, 5)        // len=5, cap=5
s = append(s, 6)        // len=6, cap=10 扩容！

// 扩容规则（Go 1.18+）:
// - cap < 256: 翻倍
// - cap >= 256: 增长 25%
```

---

## 💻 生产级代码示例

### 示例 1: 批量数据处理

```go
package main

import "fmt"

// 批量处理用户 ID
func processUserIDs(ids []int64) []string {
    results := make([]string, 0, len(ids))  // 预分配容量
    
    for _, id := range ids {
        results = append(results, fmt.Sprintf("user_%d", id))
    }
    
    return results
}

func main() {
    ids := []int64{1001, 1002, 1003, 1004, 1005}
    users := processUserIDs(ids)
    
    for _, u := range users {
        fmt.Println(u)
    }
}
```

### 示例 2: 切片过滤

```go
package main

import "fmt"

// 过滤活跃用户
func filterActive(users []User) []User {
    result := make([]User, 0, len(users))
    
    for _, u := range users {
        if u.IsActive {
            result = append(result, u)
        }
    }
    
    return result
}

type User struct {
    ID       int
    Name     string
    IsActive bool
}

func main() {
    users := []User{
        {1, "Alice", true},
        {2, "Bob", false},
        {3, "Charlie", true},
    }
    
    active := filterActive(users)
    fmt.Printf("活跃用户：%d\n", len(active))
}
```

### 示例 3: 切片去重

```go
package main

import "fmt"

func unique(ints []int) []int {
    seen := make(map[int]bool)
    result := make([]int, 0, len(ints))
    
    for _, n := range ints {
        if !seen[n] {
            seen[n] = true
            result = append(result, n)
        }
    }
    
    return result
}

func main() {
    nums := []int{1, 2, 2, 3, 3, 3, 4}
    unique := unique(nums)
    fmt.Println(unique)  // [1 2 3 4]
}
```

### 示例 4: 分块处理大数据

```go
package main

import "fmt"

// 将大切片分块处理
func chunk(data []int, size int) [][]int {
    var chunks [][]int
    
    for i := 0; i < len(data); i += size {
        end := i + size
        if end > len(data) {
            end = len(data)
        }
        chunks = append(chunks, data[i:end])
    }
    
    return chunks
}

func main() {
    data := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    chunks := chunk(data, 3)
    
    for i, c := range chunks {
        fmt.Printf("块 %d: %v\n", i+1, c)
    }
}
```

---

## ⚠️ 常见坑点

### 1. 切片共享底层数组

```go
// ❌ 危险：修改会影响原切片
s1 := []int{1, 2, 3, 4, 5}
s2 := s1[2:4]      // [3 4]
s2[0] = 99
fmt.Println(s1)    // [1 2 99 4 5] 原切片被修改！

// ✅ 正确：使用 copy
s1 := []int{1, 2, 3, 4, 5}
s2 := make([]int, len(s1[2:4]))
copy(s2, s1[2:4])
s2[0] = 99
fmt.Println(s1)    // [1 2 3 4 5] 原切片不变
```

### 2. 内存泄漏风险

```go
// ❌ 危险：大数组不释放
func getFirst100(data []byte) []byte {
    return data[:100]  // 只用了 100 字节，但整个 data 不释放
}

// ✅ 正确：复制需要的部分
func getFirst100(data []byte) []byte {
    result := make([]byte, 100)
    copy(result, data[:100])
    return result
}
```

### 3. append 不修改原切片

```go
// ❌ 错误
func add(s []int, v int) {
    s = append(s, v)  // 只修改了局部变量
}

// ✅ 正确
func add(s []int, v int) []int {
    return append(s, v)
}

// 调用
s = add(s, 10)
```

### 4. 容量陷阱

```go
s := make([]int, 3, 10)
s = append(s, 4)  // OK
s = append(s, 5)  // OK
s = append(s, 6)  // OK
s = append(s, 7)  // OK
s = append(s, 8)  // OK, cap=10 用完
s = append(s, 9)  // 扩容！cap 变成 20
```

---

## ✅ 学习检查清单

- [ ] 理解数组和切片的区别
- [ ] 掌握切片的创建和截取
- [ ] 理解 len 和 cap
- [ ] 熟练使用 append
- [ ] 理解切片扩容机制
- [ ] 掌握切片作为函数参数的行为
- [ ] 完成所有代码练习

---

## 🔗 相关资源

- [Go 官方博客：切片用法](https://go.dev/blog/slices-intro)
- [Go 切片：用法和内部原理](https://blog.golang.org/slices)

---

**恭喜完成第 5 章！** 🎉

**进度**: 5/90 (5.5%)

**下一章**: 第 6 章 - Map：键值对数据结构
