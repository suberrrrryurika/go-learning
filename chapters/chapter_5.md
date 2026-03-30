# 第 5 章 - 数组与切片

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3.5 小时  
**代码量**: 550 行  
**案例数**: 8 个

---

## 🎯 学习目标

1. 理解数组的定义与特性
2. 掌握切片的创建与操作
3. 熟练使用 append 和 copy 函数
4. 理解切片截取与底层数组共享
5. 掌握多维数组的使用

---

## 📚 理论讲解

### 一、数组

#### 1.1 数组的定义

数组是**固定长度**的同类型元素集合。

```go
// 声明方式
var arr [5]int              // 长度为 5 的整型数组
var arr2 [3]string          // 长度为 3 的字符串数组
arr3 := [4]int{1, 2, 3, 4}  // 初始化
arr4 := [...]int{1, 2, 3}   // 自动推断长度
```

**数组特点**:
- 长度固定，不可改变
- 值类型，赋值会拷贝整个数组
- 长度是类型的一部分（`[3]int` ≠ `[5]int`）

### 二、切片

#### 2.1 切片的定义

切片是**动态大小**的数组引用。

```go
// 创建方式
slice := []int{1, 2, 3}           // 字面量
slice2 := make([]int, 5)          // 长度 5，容量 5
slice3 := make([]int, 3, 5)       // 长度 3，容量 5
slice4 := arr[1:4]                // 从数组截取
```

**切片三要素**:
- **指针**: 指向底层数组
- **长度**: `len(slice)`
- **容量**: `cap(slice)`

#### 2.2 append 和 copy

```go
// append: 追加元素
slice = append(slice, 1, 2, 3)
slice = append(slice, otherSlice...)  // 追加另一个切片

// copy: 复制切片
copy(dest, src)  // 返回实际复制的元素个数
```

---

## 💻 实战案例

### 案例 1: 数组基础

```go
package main

import "fmt"

func main() {
    // 声明数组
    var arr1 [5]int
    arr2 := [3]int{1, 2, 3}
    arr3 := [...]int{10, 20, 30, 40}
    arr4 := [2]string{"Go", "Java"}
    
    fmt.Println("=== 数组声明 ===")
    fmt.Printf("arr1: %v (长度：%d)\n", arr1, len(arr1))
    fmt.Printf("arr2: %v (长度：%d)\n", arr2, len(arr2))
    fmt.Printf("arr3: %v (长度：%d)\n", arr3, len(arr3))
    fmt.Printf("arr4: %v (长度：%d)\n", arr4, len(arr4))
    
    // 访问和修改
    fmt.Println("\n=== 访问和修改 ===")
    arr2[0] = 100
    fmt.Printf("arr2[0] = %d\n", arr2[0])
    
    // 数组是值类型
    fmt.Println("\n=== 数组是值类型 ===")
    a := [3]int{1, 2, 3}
    b := a
    b[0] = 100
    fmt.Printf("a: %v\n", a)
    fmt.Printf("b: %v\n", b)
}
```

**输出**:
```
=== 数组声明 ===
arr1: [0 0 0 0 0] (长度：5)
arr2: [1 2 3] (长度：3)
arr3: [10 20 30 40] (长度：4)
arr4: [Go Java] (长度：2)

=== 访问和修改 ===
arr2[0] = 100

=== 数组是值类型 ===
a: [1 2 3]
b: [100 2 3]
```

---

### 案例 2: 切片创建与基本操作

```go
package main

import "fmt"

func main() {
    // 从数组创建切片
    arr := [5]int{10, 20, 30, 40, 50}
    slice1 := arr[1:4]
    slice2 := arr[:3]
    slice3 := arr[2:]
    
    fmt.Println("=== 从数组创建切片 ===")
    fmt.Printf("arr: %v\n", arr)
    fmt.Printf("arr[1:4]: %v\n", slice1)
    fmt.Printf("arr[:3]: %v\n", slice2)
    fmt.Printf("arr[2:]: %v\n", slice3)
    
    // 直接创建切片
    fmt.Println("\n=== 直接创建切片 ===")
    slice5 := []int{1, 2, 3, 4, 5}
    slice6 := make([]int, 5)
    slice7 := make([]int, 3, 5)
    
    fmt.Printf("slice5: %v (len=%d, cap=%d)\n", slice5, len(slice5), cap(slice5))
    fmt.Printf("slice6: %v (len=%d, cap=%d)\n", slice6, len(slice6), cap(slice6))
    fmt.Printf("slice7: %v (len=%d, cap=%d)\n", slice7, len(slice7), cap(slice7))
    
    // 切片是引用类型
    fmt.Println("\n=== 切片是引用类型 ===")
    original := []int{1, 2, 3}
    ref := original
    ref[0] = 999
    fmt.Printf("original: %v\n", original)
    fmt.Printf("ref: %v\n", ref)
}
```

**输出**:
```
=== 从数组创建切片 ===
arr: [10 20 30 40 50]
arr[1:4]: [20 30 40]
arr[:3]: [10 20 30]
arr[2:]: [30 40 50]

=== 直接创建切片 ===
slice5: [1 2 3 4 5] (len=5, cap=5)
slice6: [0 0 0 0 0] (len=5, cap=5)
slice7: [0 0 0] (len=3, cap=5)

=== 切片是引用类型 ===
original: [999 2 3]
ref: [999 2 3]
```

---

### 案例 3: append 追加元素

```go
package main

import "fmt"

func main() {
    slice := []int{1, 2, 3}
    slice = append(slice, 4, 5, 6)
    fmt.Printf("append 后：%v\n", slice)
    
    // 追加另一个切片
    other := []int{7, 8}
    slice = append(slice, other...)
    fmt.Printf("追加 other 后：%v\n", slice)
    
    // 容量变化
    s := make([]int, 0, 2)
    for i := 1; i <= 5; i++ {
        s = append(s, i)
        fmt.Printf("len=%d, cap=%d: %v\n", len(s), cap(s), s)
    }
}
```

**输出**:
```
append 后：[1 2 3 4 5 6]
追加 other 后：[1 2 3 4 5 6 7 8]
len=1, cap=2: [1]
len=2, cap=2: [1 2]
len=3, cap=4: [1 2 3]
len=4, cap=4: [1 2 3 4]
len=5, cap=8: [1 2 3 4 5]
```

---

### 案例 4: copy 复制切片

```go
package main

import "fmt"

func main() {
    src := []int{1, 2, 3, 4, 5}
    dst := make([]int, 5)
    
    n := copy(dst, src)
    fmt.Printf("复制了 %d 个元素\n", n)
    fmt.Printf("src: %v\n", src)
    fmt.Printf("dst: %v\n", dst)
    
    // 修改 dst 不影响 src
    dst[0] = 100
    fmt.Printf("\n修改 dst 后:\n")
    fmt.Printf("src: %v\n", src)
    fmt.Printf("dst: %v\n", dst)
}
```

**输出**:
```
复制了 5 个元素
src: [1 2 3 4 5]
dst: [1 2 3 4 5]

修改 dst 后:
src: [1 2 3 4 5]
dst: [100 2 3 4 5]
```

---

### 案例 5: 切片截取与底层数组共享

```go
package main

import "fmt"

func main() {
    arr := [5]int{10, 20, 30, 40, 50}
    slice1 := arr[1:4]
    
    fmt.Printf("arr: %v\n", arr)
    fmt.Printf("slice1: %v\n", slice1)
    
    // 修改 slice1 会影响 arr
    slice1[0] = 999
    fmt.Printf("\n修改 slice1[0] = 999 后:\n")
    fmt.Printf("arr: %v\n", arr)
    fmt.Printf("slice1: %v\n", slice1)
    
    // 限制容量
    data := []int{1, 2, 3, 4, 5}
    safe := data[2:5:5]
    fmt.Printf("\nsafe: %v (len=%d, cap=%d)\n", safe, len(safe), cap(safe))
    safe = append(safe, 200)
    fmt.Printf("append 200 后 safe: %v\n", safe)
    fmt.Printf("原数组 data: %v\n", data)
}
```

**输出**:
```
arr: [10 20 30 40 50]
slice1: [20 30 40]

修改 slice1[0] = 999 后:
arr: [10 999 30 40 50]
slice1: [999 30 40]

safe: [3 4 5] (len=3, cap=3)
append 200 后 safe: [3 4 5 200]
原数组 data: [1 2 3 4 5]
```

---

### 案例 6: 多维数组

```go
package main

import "fmt"

func main() {
    matrix := [2][3]int{
        {1, 2, 3},
        {4, 5, 6},
    }
    
    fmt.Println("=== 二维数组 ===")
    for i := 0; i < len(matrix); i++ {
        for j := 0; j < len(matrix[i]); j++ {
            fmt.Printf("matrix[%d][%d] = %d  ", i, j, matrix[i][j])
        }
        fmt.Println()
    }
    
    // 二维切片
    fmt.Println("\n=== 二维切片 ===")
    matrix2 := [][]int{
        {1, 2, 3},
        {4, 5},
        {6, 7, 8, 9},
    }
    for i, row := range matrix2 {
        fmt.Printf("第 %d 行：%v\n", i, row)
    }
}
```

**输出**:
```
=== 二维数组 ===
matrix[0][0] = 1  matrix[0][1] = 2  matrix[0][2] = 3  
matrix[1][0] = 4  matrix[1][1] = 5  matrix[1][2] = 6  

=== 二维切片 ===
第 0 行：[1 2 3]
第 1 行：[4 5]
第 2 行：[6 7 8 9]
```

---

### 案例 7: 学生成绩管理

```go
package main

import "fmt"

type Student struct {
    Name   string
    Scores []int
}

func average(scores []int) float64 {
    if len(scores) == 0 {
        return 0
    }
    sum := 0
    for _, score := range scores {
        sum += score
    }
    return float64(sum) / float64(len(scores))
}

func main() {
    students := []Student{
        {"张三", []int{85, 90, 78, 92, 88}},
        {"李四", []int{92, 88, 95, 89, 91}},
        {"王五", []int{78, 82, 85, 80, 79}},
    }
    
    fmt.Println("=== 学生成绩管理 ===")
    for _, s := range students {
        fmt.Printf("%s: 平均分 %.2f\n", s.Name, average(s.Scores))
    }
    
    // 添加新学生
    newStudent := Student{
        Name:   "赵六",
        Scores: []int{95, 98, 92, 96, 94},
    }
    students = append(students, newStudent)
    fmt.Printf("\n添加后总人数：%d\n", len(students))
}
```

**输出**:
```
=== 学生成绩管理 ===
张三：平均分 86.60
李四：平均分 91.00
王五：平均分 80.80

添加后总人数：4
```

---

### 案例 8: 待办事项列表

```go
package main

import "fmt"

type Todo struct {
    ID    int
    Title string
    Done  bool
}

type TodoList struct {
    items  []Todo
    nextID int
}

func NewTodoList() *TodoList {
    return &TodoList{items: make([]Todo, 0), nextID: 1}
}

func (t *TodoList) Add(title string) {
    todo := Todo{ID: t.nextID, Title: title, Done: false}
    t.items = append(t.items, todo)
    t.nextID++
    fmt.Printf("✓ 已添加 #%d: %s\n", todo.ID, todo.Title)
}

func (t *TodoList) Delete(id int) bool {
    for i, todo := range t.items {
        if todo.ID == id {
            t.items = append(t.items[:i], t.items[i+1:]...)
            fmt.Printf("✓ 已删除 #%d\n", id)
            return true
        }
    }
    return false
}

func (t *TodoList) Complete(id int) bool {
    for i := range t.items {
        if t.items[i].ID == id {
            t.items[i].Done = true
            fmt.Printf("✓ #%d 已完成\n", id)
            return true
        }
    }
    return false
}

func (t *TodoList) Show() {
    fmt.Println("\n=== 待办列表 ===")
    for _, todo := range t.items {
        status := "○"
        if todo.Done {
            status = "●"
        }
        fmt.Printf("[%s] #%d %s\n", status, todo.ID, todo.Title)
    }
}

func main() {
    list := NewTodoList()
    list.Add("学习数组")
    list.Add("学习切片")
    list.Add("完成练习")
    list.Complete(1)
    list.Show()
    list.Delete(2)
    list.Show()
}
```

**输出**:
```
✓ 已添加 #1: 学习数组
✓ 已添加 #2: 学习切片
✓ 已添加 #3: 完成练习
✓ #1 已完成

=== 待办列表 ===
[●] #1 学习数组
[○] #2 学习切片
[○] #3 完成练习
✓ 已删除 #2

=== 待办列表 ===
[●] #1 学习数组
[○] #3 完成练习
```

---

## 📝 课后练习

1. 创建一个数组并反转它的元素
2. 使用切片实现一个栈（push/pop 操作）
3. 编写函数合并两个有序切片
4. 实现一个函数，从切片中删除重复元素
5. 使用二维切片实现井字棋游戏棋盘

---

## ✅ 学习检查清单

- [ ] 理解数组与切片的区别
- [ ] 掌握 append 和 copy 的用法
- [ ] 理解切片底层数组共享
- [ ] 掌握多维数组/切片
- [ ] 完成所有 8 个案例

---

**上一章**: [第 4 章 - 循环结构](./chapter_4.md)  
**下一章**: [第 6 章 - Map 集合](./chapter_6.md)
