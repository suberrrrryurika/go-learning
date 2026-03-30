# 第 10 章 - 结构体

**阶段**: 第 1 阶段 - 基础  
**预计学习时长**: 3.5 小时  
**代码量**: 600 行  
**案例数**: 8 个

---

## 🎯 学习目标

1. 理解结构体的定义与使用
2. 掌握结构体字段的访问与修改
3. 学会使用匿名字段和嵌入
4. 理解结构体比较与赋值
5. 掌握结构体与方法的关系

---

## 📚 理论讲解

### 一、结构体基础

#### 1.1 什么是结构体

结构体是**自定义的复合数据类型**，可以包含多个不同类型的字段。

```go
type Person struct {
    Name string
    Age  int
    City string
}
```

#### 1.2 创建结构体实例

```go
// 方式 1: 字面量
p1 := Person{Name: "Alice", Age: 25, City: "Beijing"}

// 方式 2: 按顺序（不推荐）
p2 := Person{"Bob", 30, "Shanghai"}

// 方式 3: 部分字段
p3 := Person{Name: "Carol"}  // 其他字段为零值

// 方式 4: new
p4 := new(Person)
p4.Name = "David"
```

### 二、匿名字段与嵌入

```go
type Animal struct {
    Name string
    Age  int
}

type Dog struct {
    Animal  // 嵌入，自动提升字段
    Breed string
}
```

---

## 💻 实战案例

### 案例 1: 结构体基础

```go
package main

import "fmt"

// 定义结构体
type Person struct {
    Name string
    Age  int
    City string
}

func main() {
    // 创建实例
    p1 := Person{Name: "Alice", Age: 25, City: "Beijing"}
    p2 := Person{"Bob", 30, "Shanghai"}
    p3 := Person{Name: "Carol"}  // 部分字段
    
    fmt.Println("=== 结构体实例 ===")
    fmt.Printf("p1: %+v\n", p1)
    fmt.Printf("p2: %+v\n", p2)
    fmt.Printf("p3: %+v\n", p3)
    
    // 访问字段
    fmt.Println("\n=== 访问字段 ===")
    fmt.Printf("p1.Name: %s\n", p1.Name)
    fmt.Printf("p1.Age: %d\n", p1.Age)
    
    // 修改字段
    fmt.Println("\n=== 修改字段 ===")
    p1.Age = 26
    fmt.Printf("修改后 p1: %+v\n", p1)
    
    // 零值
    fmt.Println("\n=== 零值 ===")
    var p4 Person
    fmt.Printf("p4: %+v\n", p4)
    fmt.Printf("p4.Name: %q\n", p4.Name)
    fmt.Printf("p4.Age: %d\n", p4.Age)
}
```

**输出**:
```
=== 结构体实例 ===
p1: {Name:Alice Age:25 City:Beijing}
p2: {Name:Bob Age:30 City:Shanghai}
p3: {Name:Carol Age:0 City:}

=== 访问字段 ===
p1.Name: Alice
p1.Age: 25

=== 修改字段 ===
修改后 p1: {Name:Alice Age:26 City:Beijing}

=== 零值 ===
p4: {Name: Age:0 City:}
p4.Name: ""
p4.Age: 0
```

---

### 案例 2: 结构体指针

```go
package main

import "fmt"

type Person struct {
    Name string
    Age  int
}

func main() {
    // 创建结构体指针
    p1 := &Person{Name: "Alice", Age: 25}
    p2 := new(Person)
    p2.Name = "Bob"
    
    fmt.Println("=== 结构体指针 ===")
    fmt.Printf("p1: %v\n", p1)
    fmt.Printf("*p1: %v\n", *p1)
    fmt.Printf("p1.Name: %s\n", p1.Name)  // 自动解引用
    
    // 修改
    fmt.Println("\n=== 修改字段 ===")
    p1.Age = 26
    fmt.Printf("修改后 p1: %+v\n", p1)
    
    // 指针 vs 值
    fmt.Println("\n=== 指针 vs 值 ===")
    v := Person{Name: "Carol", Age: 30}
    pv := &v
    
    fmt.Printf("v.Age: %d\n", v.Age)
    pv.Age = 31
    fmt.Printf("修改后 v.Age: %d\n", v.Age)
}
```

**输出**:
```
=== 结构体指针 ===
p1: &{Alice 25}
*p1: {Alice 25}
p1.Name: Alice

=== 修改字段 ===
修改后 p1: &{Alice 26}

=== 指针 vs 值 ===
v.Age: 30
修改后 v.Age: 31
```

---

### 案例 3: 结构体赋值与比较

```go
package main

import "fmt"

type Person struct {
    Name string
    Age  int
}

func main() {
    // 结构体赋值（值拷贝）
    fmt.Println("=== 结构体赋值 ===")
    p1 := Person{Name: "Alice", Age: 25}
    p2 := p1  // 拷贝
    p2.Name = "Bob"
    
    fmt.Printf("p1: %+v\n", p1)
    fmt.Printf("p2: %+v\n", p2)
    
    // 结构体比较
    fmt.Println("\n=== 结构体比较 ===")
    p3 := Person{Name: "Alice", Age: 25}
    p4 := Person{Name: "Alice", Age: 25}
    p5 := Person{Name: "Bob", Age: 25}
    
    fmt.Printf("p1 == p3: %t\n", p1 == p3)
    fmt.Printf("p3 == p4: %t\n", p3 == p4)
    fmt.Printf("p3 == p5: %t\n", p3 == p5)
    
    // 指针比较
    fmt.Println("\n=== 指针比较 ===")
    pp1 := &p1
    pp2 := &p1
    pp3 := &p3
    
    fmt.Printf("pp1 == pp2: %t\n", pp1 == pp2)
    fmt.Printf("pp1 == pp3: %t\n", pp1 == pp3)
}
```

**输出**:
```
=== 结构体赋值 ===
p1: {Name:Alice Age:25}
p2: {Name:Bob Age:25}

=== 结构体比较 ===
p1 == p3: true
p3 == p4: true
p3 == p5: false

=== 指针比较 ===
pp1 == pp2: true
pp1 == pp3: false
```

---

### 案例 4: 匿名字段与嵌入

```go
package main

import "fmt"

// 基础结构体
type Animal struct {
    Name string
    Age  int
}

type Dog struct {
    Animal  // 嵌入
    Breed string
}

type Cat struct {
    Animal  // 嵌入
    Color string
}

func main() {
    // 创建嵌入结构体
    dog := Dog{
        Animal: Animal{Name: "旺财", Age: 3},
        Breed:  "金毛",
    }
    
    cat := Cat{
        Animal: Animal{Name: "咪咪", Age: 2},
        Color:  "白色",
    }
    
    fmt.Println("=== 访问嵌入字段 ===")
    fmt.Printf("dog.Name: %s (自动提升)\n", dog.Name)
    fmt.Printf("dog.Breed: %s\n", dog.Breed)
    fmt.Printf("cat.Name: %s\n", cat.Name)
    fmt.Printf("cat.Color: %s\n", cat.Color)
    
    // 访问完整嵌入结构体
    fmt.Println("\n=== 访问完整嵌入 ===")
    fmt.Printf("dog.Animal: %+v\n", dog.Animal)
    fmt.Printf("cat.Animal: %+v\n", cat.Animal)
    
    // 修改嵌入字段
    fmt.Println("\n=== 修改嵌入字段 ===")
    dog.Name = "大黄"
    dog.Age = 4
    fmt.Printf("修改后 dog: %+v\n", dog)
}
```

**输出**:
```
=== 访问嵌入字段 ===
dog.Name: 旺财 (自动提升)
dog.Breed: 金毛
cat.Name: 咪咪
cat.Color: 白色

=== 访问完整嵌入 ===
dog.Animal: {Name:旺财 Age:3}
cat.Animal: {Name:咪咪 Age:2}

=== 修改嵌入字段 ===
修改后 dog: {Animal:{Name:大黄 Age:4} Breed:金毛}
```

---

### 案例 5: 结构体标签

```go
package main

import (
    "encoding/json"
    "fmt"
    "reflect"
)

type User struct {
    ID       int    `json:"id"`
    Name     string `json:"name"`
    Email    string `json:"email,omitempty"`
    Password string `json:"-"`  // 不导出
}

func main() {
    user := User{
        ID:       1,
        Name:     "Alice",
        Email:    "alice@example.com",
        Password: "secret123",
    }
    
    // JSON 序列化
    fmt.Println("=== JSON 序列化 ===")
    data, _ := json.Marshal(user)
    fmt.Printf("JSON: %s\n", string(data))
    
    // JSON 反序列化
    fmt.Println("\n=== JSON 反序列化 ===")
    jsonStr := `{"id":2,"name":"Bob","email":"bob@example.com"}`
    var user2 User
    json.Unmarshal([]byte(jsonStr), &user2)
    fmt.Printf("user2: %+v\n", user2)
    
    // 反射获取标签
    fmt.Println("\n=== 反射获取标签 ===")
    t := reflect.TypeOf(user)
    for i := 0; i < t.NumField(); i++ {
        field := t.Field(i)
        jsonTag := field.Tag.Get("json")
        fmt.Printf("%s: %s\n", field.Name, jsonTag)
    }
}
```

**输出**:
```
=== JSON 序列化 ===
JSON: {"id":1,"name":"Alice","email":"alice@example.com"}

=== JSON 反序列化 ===
user2: {ID:2 Name:Bob Email:bob@example.com Password:}

=== 反射获取标签 ===
ID: id
Name: name
Email: email,omitempty
Password: -
```

---

### 案例 6: 构造函数模式

```go
package main

import "fmt"

type Rectangle struct {
    Width  float64
    Height float64
}

// 构造函数
func NewRectangle(width, height float64) *Rectangle {
    return &Rectangle{
        Width:  width,
        Height: height,
    }
}

// 带验证的构造函数
func NewRectangleValidated(width, height float64) (*Rectangle, error) {
    if width <= 0 || height <= 0 {
        return nil, fmt.Errorf("宽度和高度必须大于 0")
    }
    return &Rectangle{Width: width, Height: height}, nil
}

// 方法
func (r *Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r *Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

func (r *Rectangle) Scale(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

func main() {
    // 使用构造函数
    fmt.Println("=== 构造函数 ===")
    r1 := NewRectangle(10, 5)
    fmt.Printf("r1: %+v\n", r1)
    fmt.Printf("面积：%.2f\n", r1.Area())
    fmt.Printf("周长：%.2f\n", r1.Perimeter())
    
    // 带验证的构造函数
    fmt.Println("\n=== 验证构造函数 ===")
    r2, err := NewRectangleValidated(10, 5)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("r2: %+v\n", r2)
    }
    
    _, err = NewRectangleValidated(-10, 5)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 方法调用
    fmt.Println("\n=== 方法调用 ===")
    r1.Scale(2)
    fmt.Printf("放大后 r1: %+v\n", r1)
    fmt.Printf("新面积：%.2f\n", r1.Area())
}
```

**输出**:
```
=== 构造函数 ===
r1: &{Width:10 Height:5}
面积：50.00
周长：30.00

=== 验证构造函数 ===
r2: &{Width:10 Height:5}
错误：宽度和高度必须大于 0

=== 方法调用 ===
放大后 r1: &{Width:20 Height:10}
新面积：200.00
```

---

### 案例 7: 嵌套结构体

```go
package main

import "fmt"

type Address struct {
    Street  string
    City    string
    ZipCode string
}

type Contact struct {
    Email string
    Phone string
}

type Employee struct {
    ID      int
    Name    string
    Address Address  // 嵌套
    Contact Contact  // 嵌套
    Salary  float64
}

func main() {
    emp := Employee{
        ID:   1,
        Name: "Alice",
        Address: Address{
            Street:  "中关村大街 1 号",
            City:    "北京",
            ZipCode: "100080",
        },
        Contact: Contact{
            Email: "alice@example.com",
            Phone: "138-0000-0000",
        },
        Salary: 10000,
    }
    
    fmt.Println("=== 访问嵌套字段 ===")
    fmt.Printf("姓名：%s\n", emp.Name)
    fmt.Printf("城市：%s\n", emp.Address.City)
    fmt.Printf("邮箱：%s\n", emp.Contact.Email)
    
    // 修改嵌套字段
    fmt.Println("\n=== 修改嵌套字段 ===")
    emp.Address.City = "上海"
    emp.Contact.Phone = "139-0000-0000"
    fmt.Printf("新城市：%s\n", emp.Address.City)
    fmt.Printf("新电话：%s\n", emp.Contact.Phone)
    
    // 打印完整结构
    fmt.Println("\n=== 完整信息 ===")
    fmt.Printf("%+v\n", emp)
}
```

**输出**:
```
=== 访问嵌套字段 ===
姓名：Alice
城市：北京
邮箱：alice@example.com

=== 修改嵌套字段 ===
新城市：上海
新电话：139-0000-0000

=== 完整信息 ===
{ID:1 Name:Alice Address:{Street:中关村大街 1 号 City:上海 ZipCode:100080} Contact:{Email:alice@example.com Phone:139-0000-0000} Salary:10000}
```

---

### 案例 8: 综合应用 - 图书管理系统

```go
package main

import (
    "fmt"
    "time"
)

type Book struct {
    ID        int
    Title     string
    Author    string
    ISBN      string
    Published time.Time
    Available bool
}

type Member struct {
    ID           int
    Name         string
    BorrowedBooks []int  // 借阅的图书 ID
    JoinDate     time.Time
}

type Library struct {
    Books   map[int]*Book
    Members map[int]*Member
}

func NewLibrary() *Library {
    return &Library{
        Books:   make(map[int]*Book),
        Members: make(map[int]*Member),
    }
}

func (l *Library) AddBook(book *Book) {
    l.Books[book.ID] = book
}

func (l *Library) AddMember(member *Member) {
    l.Members[member.ID] = member
}

func (l *Library) BorrowBook(memberID, bookID int) error {
    member, ok := l.Members[memberID]
    if !ok {
        return fmt.Errorf("会员不存在")
    }
    
    book, ok := l.Books[bookID]
    if !ok {
        return fmt.Errorf("图书不存在")
    }
    
    if !book.Available {
        return fmt.Errorf("图书已被借出")
    }
    
    book.Available = false
    member.BorrowedBooks = append(member.BorrowedBooks, bookID)
    return nil
}

func (l *Library) ReturnBook(memberID, bookID int) error {
    book, ok := l.Books[bookID]
    if !ok {
        return fmt.Errorf("图书不存在")
    }
    
    book.Available = true
    
    member, ok := l.Members[memberID]
    if !ok {
        return fmt.Errorf("会员不存在")
    }
    
    // 从借阅列表移除
    for i, id := range member.BorrowedBooks {
        if id == bookID {
            member.BorrowedBooks = append(member.BorrowedBooks[:i], member.BorrowedBooks[i+1:]...)
            break
        }
    }
    return nil
}

func (l *Library) ListAvailableBooks() {
    fmt.Println("\n=== 可借阅图书 ===")
    for _, book := range l.Books {
        if book.Available {
            fmt.Printf("《%s》by %s (ISBN: %s)\n", 
                book.Title, book.Author, book.ISBN)
        }
    }
}

func main() {
    library := NewLibrary()
    
    // 添加图书
    library.AddBook(&Book{ID: 1, Title: "Go 语言编程", Author: "张三", ISBN: "978-7-001", Published: time.Now(), Available: true})
    library.AddBook(&Book{ID: 2, Title: "Python 入门", Author: "李四", ISBN: "978-7-002", Published: time.Now(), Available: true})
    library.AddBook(&Book{ID: 3, Title: "Java 实战", Author: "王五", ISBN: "978-7-003", Published: time.Now(), Available: true})
    
    // 添加会员
    library.AddMember(&Member{ID: 1, Name: "Alice", JoinDate: time.Now()})
    library.AddMember(&Member{ID: 2, Name: "Bob", JoinDate: time.Now()})
    
    // 列出可借阅图书
    library.ListAvailableBooks()
    
    // 借阅
    fmt.Println("\n=== 借阅图书 ===")
    err := library.BorrowBook(1, 1)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Println("Alice 借阅了《Go 语言编程》")
    }
    
    // 再次借阅同一本书
    err = library.BorrowBook(2, 1)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
    
    // 列出可借阅图书
    library.ListAvailableBooks()
    
    // 归还
    fmt.Println("\n=== 归还图书 ===")
    err = library.ReturnBook(1, 1)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Println("Alice 归还了《Go 语言编程》")
    }
    
    library.ListAvailableBooks()
}
```

**输出**:
```
=== 可借阅图书 ===
《Go 语言编程》by 张三 (ISBN: 978-7-001)
《Python 入门》by 李四 (ISBN: 978-7-002)
《Java 实战》by 王五 (ISBN: 978-7-003)

=== 借阅图书 ===
Alice 借阅了《Go 语言编程》
错误：图书已被借出

=== 可借阅图书 ===
《Python 入门》by 李四 (ISBN: 978-7-002)
《Java 实战》by 王五 (ISBN: 978-7-003)

=== 归还图书 ===
Alice 归还了《Go 语言编程》

=== 可借阅图书 ===
《Go 语言编程》by 张三 (ISBN: 978-7-001)
《Python 入门》by 李四 (ISBN: 978-7-002)
《Java 实战》by 王五 (ISBN: 978-7-003)
```

---

## 📝 课后练习

1. 定义一个表示学生的结构体，包含姓名、年龄、成绩字段
2. 实现一个方法，计算学生的平均成绩
3. 使用嵌入创建一个管理员结构体（基于用户结构体）
4. 实现一个结构体池（对象池）模式
5. 使用结构体标签实现 XML 序列化

---

## ✅ 学习检查清单

- [ ] 理解结构体的定义与使用
- [ ] 掌握结构体字段的访问与修改
- [ ] 学会使用匿名字段和嵌入
- [ ] 理解结构体比较与赋值
- [ ] 掌握结构体与方法的关系
- [ ] 完成所有 8 个案例

---

**上一章**: [第 9 章 - 指针](./chapter_9.md)  
**下一章**: [第 11 章 - 方法](./chapter_11.md)
