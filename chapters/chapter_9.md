# 第 9 章 - 指针

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3 小时  
**代码量**: 500 行  
**案例数**: 7 个

---

## 🎯 学习目标

1. 理解指针的概念与作用
2. 掌握指针的声明与使用
3. 理解指针与函数的关系
4. 掌握 new 和 make 的区别
5. 理解指针在数据结构中的应用

---

## 📚 理论讲解

### 一、指针基础

#### 1.1 什么是指针

指针是**存储变量内存地址**的变量。

```go
var x int = 10
var p *int = &x  // p 指向 x

fmt.Println(x)   // 10      - 值
fmt.Println(&x)  // 地址    - x 的地址
fmt.Println(p)   // 地址    - p 存储的地址
fmt.Println(*p)  // 10      - 解引用，获取 p 指向的值
```

#### 1.2 指针操作符

| 操作符 | 名称 | 示例 | 说明 |
|--------|------|------|------|
| `&` | 取地址 | `&x` | 获取变量 x 的地址 |
| `*` | 解引用 | `*p` | 获取指针 p 指向的值 |

### 二、new 和 make

| 函数 | 用途 | 返回类型 | 示例 |
|------|------|----------|------|
| `new(T)` | 分配内存，返回 `*T` | 指针 | `p := new(int)` |
| `make(T, args)` | 初始化切片/Map/通道 | T | `s := make([]int, 5)` |

---

## 💻 实战案例

### 案例 1: 指针基础

```go
package main

import "fmt"

func main() {
    // 声明变量
    var x int = 10
    
    // 声明指针
    var p *int = &x
    
    fmt.Println("=== 指针基础 ===")
    fmt.Printf("x 的值：%d\n", x)
    fmt.Printf("x 的地址：%p\n", &x)
    fmt.Printf("p 的值（存储的地址）：%p\n", p)
    fmt.Printf("p 指向的值：%d\n", *p)
    
    // 修改指针指向的值
    fmt.Println("\n=== 修改指针指向的值 ===")
    *p = 20
    fmt.Printf("修改后 x = %d\n", x)
    fmt.Printf("修改后 *p = %d\n", *p)
    
    // 修改指针本身
    fmt.Println("\n=== 修改指针本身 ===")
    y := 30
    p = &y
    fmt.Printf("p 现在指向：%d\n", *p)
    fmt.Printf("x 仍然是：%d\n", x)
    
    // 指针的零值
    fmt.Println("\n=== 指针的零值 ===")
    var nilPtr *int
    fmt.Printf("nilPtr = %v\n", nilPtr)
    fmt.Printf("nilPtr == nil: %t\n", nilPtr == nil)
}
```

**输出**:
```
=== 指针基础 ===
x 的值：10
x 的地址：0xc00001a098
p 的值（存储的地址）：0xc00001a098
p 指向的值：10

=== 修改指针指向的值 ===
修改后 x = 20
修改后 *p = 20

=== 修改指针本身 ===
p 现在指向：30
x 仍然是：20

=== 指针的零值 ===
nilPtr = <nil>
nilPtr == nil: true
```

---

### 案例 2: 指针与函数

```go
package main

import "fmt"

// 值传递 - 不修改原值
func modifyByValue(x int) {
    x = 100
    fmt.Printf("函数内 x = %d\n", x)
}

// 指针传递 - 修改原值
func modifyByPointer(x *int) {
    *x = 100
    fmt.Printf("函数内 *x = %d\n", *x)
}

// 返回指针
func createValue(val int) *int {
    return &val  // ⚠️ 危险！返回局部变量地址
}

// 正确返回指针
func createValueSafe(val int) *int {
    p := new(int)
    *p = val
    return p
}

// 交换两个数
func swap(a, b *int) {
    *a, *b = *b, *a
}

func main() {
    fmt.Println("=== 值传递 ===")
    x := 10
    modifyByValue(x)
    fmt.Printf("调用后 x = %d\n\n", x)
    
    fmt.Println("=== 指针传递 ===")
    y := 10
    modifyByPointer(&y)
    fmt.Printf("调用后 y = %d\n\n", y)
    
    fmt.Println("=== 返回指针 ===")
    p := createValueSafe(42)
    fmt.Printf("*p = %d\n\n", *p)
    
    fmt.Println("=== 交换两个数 ===")
    a, b := 100, 200
    fmt.Printf("交换前：a=%d, b=%d\n", a, b)
    swap(&a, &b)
    fmt.Printf("交换后：a=%d, b=%d\n", a, b)
}
```

**输出**:
```
=== 值传递 ===
函数内 x = 100
调用后 x = 10

=== 指针传递 ===
函数内 *x = 100
调用后 y = 100

=== 返回指针 ===
*p = 42

=== 交换两个数 ===
交换前：a=100, b=200
交换后：a=200, b=100
```

---

### 案例 3: new 和 make 的区别

```go
package main

import "fmt"

func main() {
    // new: 分配内存，返回指针，值为零值
    fmt.Println("=== new 演示 ===")
    p1 := new(int)
    p2 := new(string)
    p3 := new([]int)
    
    fmt.Printf("new(int): %v, *p1 = %d\n", p1, *p1)
    fmt.Printf("new(string): %v, *p2 = %q\n", p2, *p2)
    fmt.Printf("new([]int): %v, *p3 = %v\n", p3, *p3)
    
    // make: 初始化切片/Map/通道，返回类型本身
    fmt.Println("\n=== make 演示 ===")
    s1 := make([]int, 5)
    s2 := make([]string, 3, 10)
    m1 := make(map[string]int)
    ch := make(chan int)
    
    fmt.Printf("make([]int, 5): %v (len=%d)\n", s1, len(s1))
    fmt.Printf("make([]string, 3, 10): %v (len=%d, cap=%d)\n", s2, len(s2), cap(s2))
    fmt.Printf("make(map[string]int): %v\n", m1)
    fmt.Printf("make(chan int): %v\n", ch)
    
    // 对比
    fmt.Println("\n=== 对比 ===")
    var slice1 []int           // nil
    slice2 := make([]int, 5)   // [0 0 0 0 0]
    
    fmt.Printf("var slice []int: %v (nil=%t)\n", slice1, slice1 == nil)
    fmt.Printf("make([]int, 5): %v (nil=%t)\n", slice2, slice2 == nil)
}
```

**输出**:
```
=== new 演示 ===
new(int): 0xc00001a098, *p1 = 0
new(string): 0xc00001a0a0, *p2 = ""
new([]int): 0xc00007a018, *p3 = []

=== make 演示 ===
make([]int, 5): [0 0 0 0 0] (len=5)
make([]string, 3, 10): [   ] (len=3, cap=10)
make(map[string]int): map[]
make(chan int): 0xc00007c0e0

=== 对比 ===
var slice []int: [] (nil=true)
make([]int, 5): [0 0 0 0 0] (nil=false)
```

---

### 案例 4: 指针与数组

```go
package main

import "fmt"

func main() {
    // 数组名本身就是指针
    arr := [5]int{10, 20, 30, 40, 50}
    
    fmt.Println("=== 数组与指针 ===")
    fmt.Printf("arr: %v\n", arr)
    fmt.Printf("&arr[0]: %p\n", &arr[0])
    fmt.Printf("arr (数组名): %p\n", arr)
    
    // 指向数组的指针
    var p *[5]int = &arr
    fmt.Printf("\np = &arr: %p\n", p)
    fmt.Printf("*p: %v\n", *p)
    
    // 修改数组元素
    fmt.Println("\n=== 修改数组元素 ===")
    (*p)[0] = 100
    p[1] = 200  // 自动解引用
    fmt.Printf("修改后 arr: %v\n", arr)
    
    // 指针算术（Go 不支持指针算术）
    fmt.Println("\n=== 指针遍历 ===")
    for i := 0; i < len(arr); i++ {
        fmt.Printf("arr[%d] = %d\n", i, arr[i])
    }
}
```

**输出**:
```
=== 数组与指针 ===
arr: [10 20 30 40 50]
&arr[0]: 0xc00001a0c0
arr (数组名): 0xc00001a0c0

p = &arr: 0xc00001a0c0
*p: [10 20 30 40 50]

=== 修改数组元素 ===
修改后 arr: [100 200 30 40 50]

=== 指针遍历 ===
arr[0] = 100
arr[1] = 200
arr[2] = 30
arr[3] = 40
arr[4] = 50
```

---

### 案例 5: 指针与结构体

```go
package main

import "fmt"

type Person struct {
    Name string
    Age  int
}

func main() {
    // 创建结构体
    p1 := Person{Name: "Alice", Age: 25}
    
    // 指向结构体的指针
    var p2 *Person = &p1
    
    fmt.Println("=== 访问结构体字段 ===")
    fmt.Printf("p1.Name: %s\n", p1.Name)
    fmt.Printf("(*p2).Name: %s\n", (*p2).Name)
    fmt.Printf("p2.Name: %s (自动解引用)\n", p2.Name)
    
    // 修改字段
    fmt.Println("\n=== 修改字段 ===")
    p2.Age = 26
    fmt.Printf("修改后 p1.Age: %d\n", p1.Age)
    
    // new 创建结构体指针
    fmt.Println("\n=== new 创建结构体 ===")
    p3 := new(Person)
    p3.Name = "Bob"
    p3.Age = 30
    fmt.Printf("p3: %+v\n", p3)
    
    // 结构体字面量指针
    fmt.Println("\n=== 字面量指针 ===")
    p4 := &Person{Name: "Carol", Age: 28}
    fmt.Printf("p4: %+v\n", p4)
}
```

**输出**:
```
=== 访问结构体字段 ===
p1.Name: Alice
(*p2).Name: Alice
p2.Name: Alice (自动解引用)

=== 修改字段 ===
修改后 p1.Age: 26

=== new 创建结构体 ===
p3: &{Name:Bob Age:30}

=== 字面量指针 ===
p4: &{Name:Carol Age:28}
```

---

### 案例 6: 指针数组与数组指针

```go
package main

import "fmt"

func main() {
    // 指针数组：数组的元素是指针
    fmt.Println("=== 指针数组 ===")
    a, b, c := 1, 2, 3
    ptrArray := [3]*int{&a, &b, &c}
    
    fmt.Printf("ptrArray: %v\n", ptrArray)
    fmt.Printf("*ptrArray[0]: %d\n", *ptrArray[0])
    fmt.Printf("*ptrArray[1]: %d\n", *ptrArray[1])
    fmt.Printf("*ptrArray[2]: %d\n", *ptrArray[2])
    
    // 修改
    *ptrArray[0] = 100
    fmt.Printf("修改后 a = %d\n", a)
    
    // 数组指针：指向数组的指针
    fmt.Println("\n=== 数组指针 ===")
    arr := [5]int{10, 20, 30, 40, 50}
    arrPtr := &arr
    
    fmt.Printf("arrPtr: %p\n", arrPtr)
    fmt.Printf("*arrPtr: %v\n", *arrPtr)
    fmt.Printf("(*arrPtr)[0]: %d\n", (*arrPtr)[0])
    fmt.Printf("arrPtr[0]: %d (自动解引用)\n", arrPtr[0])
    
    // 修改
    arrPtr[0] = 1000
    fmt.Printf("修改后 arr: %v\n", arr)
}
```

**输出**:
```
=== 指针数组 ===
ptrArray: [0xc00001a0f0 0xc00001a0f8 0xc00001a100]
*ptrArray[0]: 1
*ptrArray[1]: 2
*ptrArray[2]: 3
修改后 a = 100

=== 数组指针 ===
arrPtr: 0xc00001a110
*arrPtr: [10 20 30 40 50]
(*arrPtr)[0]: 10
arrPtr[0]: 10 (自动解引用)
修改后 arr: [1000 20 30 40 50]
```

---

### 案例 7: 综合应用 - 链表

```go
package main

import "fmt"

// 链表节点
type Node struct {
    Value int
    Next  *Node
}

// 链表
type LinkedList struct {
    Head *Node
    Size int
}

// 创建新节点
func NewNode(value int) *Node {
    return &Node{Value: value}
}

// 创建链表
func NewLinkedList() *LinkedList {
    return &LinkedList{}
}

// 在头部插入
func (l *LinkedList) InsertHead(value int) {
    node := NewNode(value)
    node.Next = l.Head
    l.Head = node
    l.Size++
}

// 在尾部插入
func (l *LinkedList) InsertTail(value int) {
    node := NewNode(value)
    if l.Head == nil {
        l.Head = node
    } else {
        current := l.Head
        for current.Next != nil {
            current = current.Next
        }
        current.Next = node
    }
    l.Size++
}

// 删除节点
func (l *LinkedList) Delete(value int) bool {
    if l.Head == nil {
        return false
    }
    
    // 删除头节点
    if l.Head.Value == value {
        l.Head = l.Head.Next
        l.Size--
        return true
    }
    
    // 删除中间或尾部节点
    current := l.Head
    for current.Next != nil {
        if current.Next.Value == value {
            current.Next = current.Next.Next
            l.Size--
            return true
        }
        current = current.Next
    }
    return false
}

// 遍历链表
func (l *LinkedList) Traverse() {
    current := l.Head
    fmt.Print("链表：")
    for current != nil {
        fmt.Printf("%d", current.Value)
        if current.Next != nil {
            fmt.Print(" -> ")
        }
        current = current.Next
    }
    fmt.Println()
    fmt.Printf("大小：%d\n", l.Size)
}

// 查找节点
func (l *LinkedList) Find(value int) *Node {
    current := l.Head
    for current != nil {
        if current.Value == value {
            return current
        }
        current = current.Next
    }
    return nil
}

func main() {
    list := NewLinkedList()
    
    fmt.Println("=== 链表操作 ===")
    
    // 插入
    list.InsertTail(10)
    list.InsertTail(20)
    list.InsertTail(30)
    list.Traverse()
    
    // 头部插入
    fmt.Println("\n=== 头部插入 5 ===")
    list.InsertHead(5)
    list.Traverse()
    
    // 删除
    fmt.Println("\n=== 删除 20 ===")
    list.Delete(20)
    list.Traverse()
    
    // 查找
    fmt.Println("\n=== 查找 10 ===")
    node := list.Find(10)
    if node != nil {
        fmt.Printf("找到节点，值：%d\n", node.Value)
    } else {
        fmt.Println("未找到")
    }
}
```

**输出**:
```
=== 链表操作 ===
链表：10 -> 20 -> 30
大小：3

=== 头部插入 5 ===
链表：5 -> 10 -> 20 -> 30
大小：4

=== 删除 20 ===
链表：5 -> 10 -> 30
大小：3

=== 查找 10 ===
找到节点，值：10
```

---

## 📝 课后练习

1. 编写一个函数，使用指针交换两个变量的值
2. 实现一个双向链表
3. 编写函数，返回一个指向二维数组的指针
4. 使用指针实现一个简单的栈数据结构
5. 编写程序，演示指针的指针（**int）

---

## ✅ 学习检查清单

- [ ] 理解指针的概念与作用
- [ ] 掌握指针的声明与使用
- [ ] 理解指针与函数的关系
- [ ] 掌握 new 和 make 的区别
- [ ] 理解指针在数据结构中的应用
- [ ] 完成所有 7 个案例

---

**上一章**: [第 8 章 - 函数进阶](./chapter_8.md)  
**下一章**: [第 10 章 - 结构体](./chapter_10.md)
