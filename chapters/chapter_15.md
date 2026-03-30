# 第 15 章 - 测试

**阶段**: 第 2 阶段 - 进阶  
**预计学习时长**: 3.5 小时  
**代码量**: 650 行  
**案例数**: 8 个

---

## 🎯 学习目标

1. 理解 Go 测试框架
2. 掌握表格驱动测试
3. 学会编写基准测试
4. 理解测试覆盖率
5. 掌握 Mock 与依赖注入

---

## 📚 理论讲解

### 一、测试基础

#### 1.1 测试文件

Go 测试文件以 `_test.go` 结尾，使用 `testing` 包。

```go
// calculator.go
func Add(a, b int) int {
    return a + b
}

// calculator_test.go
func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("期望 5, 得到 %d", result)
    }
}
```

#### 1.2 测试命令

```bash
# 运行所有测试
go test

# 详细输出
go test -v

# 运行特定测试
go test -run TestAdd

# 测试覆盖率
go test -cover

# 基准测试
go test -bench=.

# 覆盖率报告
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

---

## 💻 实战案例

### 案例 1: 基础测试

```go
// calculator.go
package main

func Add(a, b int) int {
    return a + b
}

func Subtract(a, b int) int {
    return a - b
}

func Multiply(a, b int) int {
    return a * b
}

func Divide(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("除数不能为零")
    }
    return a / b, nil
}
```

```go
// calculator_test.go
package main

import (
    "testing"
)

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    if result != 5 {
        t.Errorf("Add(2, 3) 期望 5, 得到 %d", result)
    }
}

func TestSubtract(t *testing.T) {
    result := Subtract(5, 3)
    if result != 2 {
        t.Errorf("Subtract(5, 3) 期望 2, 得到 %d", result)
    }
}

func TestMultiply(t *testing.T) {
    result := Multiply(4, 3)
    if result != 12 {
        t.Errorf("Multiply(4, 3) 期望 12, 得到 %d", result)
    }
}

func TestDivide(t *testing.T) {
    result, err := Divide(10, 2)
    if err != nil {
        t.Errorf("Divide(10, 2) 不应有错误：%v", err)
    }
    if result != 5 {
        t.Errorf("Divide(10, 2) 期望 5, 得到 %d", result)
    }
}

func TestDivideByZero(t *testing.T) {
    _, err := Divide(10, 0)
    if err == nil {
        t.Error("Divide(10, 0) 应该返回错误")
    }
}
```

**运行测试**:
```bash
go test -v
```

**输出**:
```
=== RUN   TestAdd
--- PASS: TestAdd (0.00s)
=== RUN   TestSubtract
--- PASS: TestSubtract (0.00s)
=== RUN   TestMultiply
--- PASS: TestMultiply (0.00s)
=== RUN   TestDivide
--- PASS: TestDivide (0.00s)
=== RUN   TestDivideByZero
--- PASS: TestDivideByZero (0.00s)
PASS
ok      calculator    0.001s
```

---

### 案例 2: 表格驱动测试

```go
// calculator_test.go
package main

import "testing"

func TestAddTable(t *testing.T) {
    tests := []struct {
        name     string
        a        int
        b        int
        expected int
    }{
        {"正数", 2, 3, 5},
        {"负数", -2, -3, -5},
        {"一正一负", 5, -3, 2},
        {"零", 0, 0, 0},
        {"大数", 1000000, 2000000, 3000000},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := Add(tt.a, tt.b)
            if result != tt.expected {
                t.Errorf("Add(%d, %d) 期望 %d, 得到 %d",
                    tt.a, tt.b, tt.expected, result)
            }
        })
    }
}

func TestDivideTable(t *testing.T) {
    tests := []struct {
        name     string
        a        int
        b        int
        expected int
        hasErr   bool
    }{
        {"正常", 10, 2, 5, false},
        {"余数", 7, 2, 3, false},
        {"除零", 10, 0, 0, true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result, err := Divide(tt.a, tt.b)
            if tt.hasErr {
                if err == nil {
                    t.Error("期望有错误，但未得到")
                }
            } else {
                if err != nil {
                    t.Errorf("不期望有错误：%v", err)
                }
                if result != tt.expected {
                    t.Errorf("期望 %d, 得到 %d", tt.expected, result)
                }
            }
        })
    }
}
```

**输出**:
```
=== RUN   TestAddTable
=== RUN   TestAddTable/正数
=== RUN   TestAddTable/负数
=== RUN   TestAddTable/一正一负
=== RUN   TestAddTable/零
=== RUN   TestAddTable/大数
--- PASS: TestAddTable (0.00s)
    --- PASS: TestAddTable/正数 (0.00s)
    --- PASS: TestAddTable/负数 (0.00s)
    --- PASS: TestAddTable/一正一负 (0.00s)
    --- PASS: TestAddTable/零 (0.00s)
    --- PASS: TestAddTable/大数 (0.00s)
```

---

### 案例 3: 测试辅助函数

```go
// test_helpers.go
package main

import "testing"

// 辅助函数：比较两个切片
func assertSliceEqual(t *testing.T, expected, actual []int) {
    t.Helper()  // 标记为辅助函数
    
    if len(expected) != len(actual) {
        t.Errorf("长度不匹配：期望 %d, 得到 %d",
            len(expected), len(actual))
        return
    }
    
    for i := range expected {
        if expected[i] != actual[i] {
            t.Errorf("索引 %d: 期望 %d, 得到 %d",
                i, expected[i], actual[i])
        }
    }
}

// 辅助函数：比较浮点数
func assertFloatEqual(t *testing.T, expected, actual, tolerance float64) {
    t.Helper()
    
    diff := expected - actual
    if diff < 0 {
        diff = -diff
    }
    if diff > tolerance {
        t.Errorf("期望 %.4f, 得到 %.4f, 差异 %.4f",
            expected, actual, diff)
    }
}
```

```go
// slice_test.go
package main

import "testing"

func SumSlice(slice []int) int {
    sum := 0
    for _, v := range slice {
        sum += v
    }
    return sum
}

func TestSumSlice(t *testing.T) {
    tests := []struct {
        name     string
        input    []int
        expected int
    }{
        {"空切片", []int{}, 0},
        {"单元素", []int{5}, 5},
        {"多元素", []int{1, 2, 3, 4, 5}, 15},
        {"负数", []int{-1, -2, -3}, -6},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := SumSlice(tt.input)
            if result != tt.expected {
                t.Errorf("SumSlice(%v) 期望 %d, 得到 %d",
                    tt.input, tt.expected, result)
            }
        })
    }
}
```

---

### 案例 4: 基准测试

```go
// benchmark_test.go
package main

import "testing"

// 普通求和
func SumNormal(slice []int) int {
    sum := 0
    for _, v := range slice {
        sum += v
    }
    return sum
}

// 基准测试
func BenchmarkSumNormal(b *testing.B) {
    slice := make([]int, 1000)
    for i := range slice {
        slice[i] = i
    }
    
    b.ResetTimer()  // 重置计时器
    for i := 0; i < b.N; i++ {
        SumNormal(slice)
    }
}

// 不同大小的基准测试
func BenchmarkSum100(b *testing.B) {
    slice := make([]int, 100)
    for i := 0; i < b.N; i++ {
        SumNormal(slice)
    }
}

func BenchmarkSum1000(b *testing.B) {
    slice := make([]int, 1000)
    for i := 0; i < b.N; i++ {
        SumNormal(slice)
    }
}

func BenchmarkSum10000(b *testing.B) {
    slice := make([]int, 10000)
    for i := 0; i < b.N; i++ {
        SumNormal(slice)
    }
}

// 并行基准测试
func BenchmarkSumParallel(b *testing.B) {
    slice := make([]int, 10000)
    for i := range slice {
        slice[i] = i
    }
    
    b.RunParallel(func(pb *testing.PB) {
        for pb.Next() {
            SumNormal(slice)
        }
    })
}
```

**运行基准测试**:
```bash
go test -bench=. -benchmem
```

**输出**:
```
goos: linux
goarch: amd64
BenchmarkSumNormal-4        100000    12345 ns/op
BenchmarkSum100-4           500000     2345 ns/op
BenchmarkSum1000-4          100000    12345 ns/op
BenchmarkSum10000-4          10000   123456 ns/op
BenchmarkSumParallel-4      200000     6789 ns/op
PASS
```

---

### 案例 5: 测试覆盖率

```go
// user.go
package main

type User struct {
    Name  string
    Email string
    Age   int
}

func NewUser(name, email string, age int) (*User, error) {
    if name == "" {
        return nil, &ValidationError{"name cannot be empty"}
    }
    if email == "" {
        return nil, &ValidationError{"email cannot be empty"}
    }
    if age < 0 || age > 150 {
        return nil, &ValidationError{"invalid age"}
    }
    return &User{Name: name, Email: email, Age: age}, nil
}

type ValidationError struct {
    Message string
}

func (e *ValidationError) Error() string {
    return e.Message
}

func (u *User) IsAdult() bool {
    return u.Age >= 18
}

func (u *User) GetInfo() string {
    return u.Name + " (" + u.Email + ")"
}
```

```go
// user_test.go
package main

import "testing"

func TestNewUser(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        email   string
        age     int
        wantErr bool
    }{
        {"有效用户", "Alice", "alice@example.com", 25, false},
        {"空名字", "", "alice@example.com", 25, true},
        {"空邮箱", "Alice", "", 25, true},
        {"负年龄", "Alice", "alice@example.com", -1, true},
        {"年龄过大", "Alice", "alice@example.com", 200, true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            user, err := NewUser(tt.input, tt.email, tt.age)
            if tt.wantErr {
                if err == nil {
                    t.Error("期望有错误，但未得到")
                }
            } else {
                if err != nil {
                    t.Errorf("不期望有错误：%v", err)
                }
                if user == nil {
                    t.Error("期望返回用户，但为 nil")
                }
            }
        })
    }
}

func TestIsAdult(t *testing.T) {
    tests := []struct {
        age      int
        expected bool
    }{
        {17, false},
        {18, true},
        {25, true},
        {65, true},
    }
    
    for _, tt := range tests {
        user := &User{Age: tt.age}
        if user.IsAdult() != tt.expected {
            t.Errorf("Age %d: 期望 %t", tt.age, tt.expected)
        }
    }
}
```

**运行覆盖率测试**:
```bash
# 查看覆盖率
go test -cover

# 生成覆盖率报告
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

**输出**:
```
PASS
coverage: 85.7% of statements
ok      user    0.002s
```

---

### 案例 6: Mock 与依赖注入

```go
// database.go
package main

type Database interface {
    GetUser(id int) (*User, error)
    SaveUser(user *User) error
}

type UserService struct {
    db Database
}

func NewUserService(db Database) *UserService {
    return &UserService{db: db}
}

func (s *UserService) Register(name, email string, age int) error {
    user, err := NewUser(name, email, age)
    if err != nil {
        return err
    }
    return s.db.SaveUser(user)
}

func (s *UserService) GetUserInfo(id int) (string, error) {
    user, err := s.db.GetUser(id)
    if err != nil {
        return "", err
    }
    return user.GetInfo(), nil
}
```

```go
// mock_test.go
package main

import "testing"

// Mock Database
type MockDB struct {
    users map[int]*User
}

func NewMockDB() *MockDB {
    return &MockDB{users: make(map[int]*User)}
}

func (m *MockDB) GetUser(id int) (*User, error) {
    user, ok := m.users[id]
    if !ok {
        return nil, &ValidationError{"user not found"}
    }
    return user, nil
}

func (m *MockDB) SaveUser(user *User) error {
    id := len(m.users) + 1
    m.users[id] = user
    return nil
}

// 测试
func TestUserServiceRegister(t *testing.T) {
    db := NewMockDB()
    service := NewUserService(db)
    
    err := service.Register("Alice", "alice@example.com", 25)
    if err != nil {
        t.Errorf("注册失败：%v", err)
    }
    
    // 验证
    if len(db.users) != 1 {
        t.Errorf("期望 1 个用户，得到 %d", len(db.users))
    }
}

func TestUserServiceGetUserInfo(t *testing.T) {
    db := NewMockDB()
    service := NewUserService(db)
    
    // 先注册用户
    service.Register("Bob", "bob@example.com", 30)
    
    // 获取用户信息
    info, err := service.GetUserInfo(1)
    if err != nil {
        t.Errorf("获取用户失败：%v", err)
    }
    
    expected := "Bob (bob@example.com)"
    if info != expected {
        t.Errorf("期望 %s, 得到 %s", expected, info)
    }
}
```

---

### 案例 7: 子测试与清理

```go
// cleanup_test.go
package main

import (
    "os"
    "testing"
)

func TestFileOperations(t *testing.T) {
    // Setup
    filename := "test_file.txt"
    
    t.Cleanup(func() {
        // 清理：删除测试文件
        os.Remove(filename)
    })
    
    t.Run("CreateFile", func(t *testing.T) {
        file, err := os.Create(filename)
        if err != nil {
            t.Fatalf("创建文件失败：%v", err)
        }
        defer file.Close()
        
        _, err = file.WriteString("test content")
        if err != nil {
            t.Errorf("写入失败：%v", err)
        }
    })
    
    t.Run("ReadFile", func(t *testing.T) {
        data, err := os.ReadFile(filename)
        if err != nil {
            t.Fatalf("读取文件失败：%v", err)
        }
        
        expected := "test content"
        if string(data) != expected {
            t.Errorf("期望 %s, 得到 %s", expected, string(data))
        }
    })
    
    t.Run("FileExists", func(t *testing.T) {
        _, err := os.Stat(filename)
        if err != nil {
            t.Errorf("文件应该存在：%v", err)
        }
    })
}
```

---

### 案例 8: 综合应用 - 完整测试套件

```go
// bank.go
package main

type Account struct {
    id      int
    owner   string
    balance float64
}

type Bank struct {
    accounts map[int]*Account
    nextID   int
}

func NewBank() *Bank {
    return &Bank{
        accounts: make(map[int]*Account),
        nextID:   1,
    }
}

func (b *Bank) CreateAccount(owner string, initialBalance float64) (*Account, error) {
    if initialBalance < 0 {
        return nil, &ValidationError{"initial balance cannot be negative"}
    }
    
    account := &Account{
        id:      b.nextID,
        owner:   owner,
        balance: initialBalance,
    }
    b.accounts[account.id] = account
    b.nextID++
    return account, nil
}

func (b *Bank) Deposit(accountID int, amount float64) error {
    account, ok := b.accounts[accountID]
    if !ok {
        return &ValidationError{"account not found"}
    }
    if amount <= 0 {
        return &ValidationError{"deposit amount must be positive"}
    }
    account.balance += amount
    return nil
}

func (b *Bank) Withdraw(accountID int, amount float64) error {
    account, ok := b.accounts[accountID]
    if !ok {
        return &ValidationError{"account not found"}
    }
    if amount <= 0 {
        return &ValidationError{"withdraw amount must be positive"}
    }
    if amount > account.balance {
        return &ValidationError{"insufficient balance"}
    }
    account.balance -= amount
    return nil
}

func (b *Bank) GetBalance(accountID int) (float64, error) {
    account, ok := b.accounts[accountID]
    if !ok {
        return 0, &ValidationError{"account not found"}
    }
    return account.balance, nil
}

func (b *Bank) Transfer(fromID, toID int, amount float64) error {
    if err := b.Withdraw(fromID, amount); err != nil {
        return err
    }
    if err := b.Deposit(toID, amount); err != nil {
        // 回滚
        b.Deposit(fromID, amount)
        return err
    }
    return nil
}
```

```go
// bank_test.go
package main

import (
    "testing"
)

func TestBankCreateAccount(t *testing.T) {
    bank := NewBank()
    
    t.Run("成功创建", func(t *testing.T) {
        account, err := bank.CreateAccount("Alice", 1000)
        if err != nil {
            t.Fatalf("创建失败：%v", err)
        }
        if account.owner != "Alice" {
            t.Errorf("期望 owner Alice, 得到 %s", account.owner)
        }
        if account.balance != 1000 {
            t.Errorf("期望 balance 1000, 得到 %f", account.balance)
        }
    })
    
    t.Run("负初始余额", func(t *testing.T) {
        _, err := bank.CreateAccount("Bob", -100)
        if err == nil {
            t.Error("期望有错误")
        }
    })
}

func TestBankDeposit(t *testing.T) {
    bank := NewBank()
    account, _ := bank.CreateAccount("Alice", 1000)
    
    err := bank.Deposit(account.id, 500)
    if err != nil {
        t.Fatalf("存款失败：%v", err)
    }
    
    balance, _ := bank.GetBalance(account.id)
    if balance != 1500 {
        t.Errorf("期望余额 1500, 得到 %f", balance)
    }
}

func TestBankWithdraw(t *testing.T) {
    bank := NewBank()
    account, _ := bank.CreateAccount("Alice", 1000)
    
    t.Run("成功取款", func(t *testing.T) {
        err := bank.Withdraw(account.id, 300)
        if err != nil {
            t.Fatalf("取款失败：%v", err)
        }
        
        balance, _ := bank.GetBalance(account.id)
        if balance != 700 {
            t.Errorf("期望余额 700, 得到 %f", balance)
        }
    })
    
    t.Run("余额不足", func(t *testing.T) {
        err := bank.Withdraw(account.id, 10000)
        if err == nil {
            t.Error("期望有错误")
        }
    })
}

func TestBankTransfer(t *testing.T) {
    bank := NewBank()
    account1, _ := bank.CreateAccount("Alice", 1000)
    account2, _ := bank.CreateAccount("Bob", 500)
    
    err := bank.Transfer(account1.id, account2.id, 200)
    if err != nil {
        t.Fatalf("转账失败：%v", err)
    }
    
    balance1, _ := bank.GetBalance(account1.id)
    balance2, _ := bank.GetBalance(account2.id)
    
    if balance1 != 800 {
        t.Errorf("Alice 期望余额 800, 得到 %f", balance1)
    }
    if balance2 != 700 {
        t.Errorf("Bob 期望余额 700, 得到 %f", balance2)
    }
}

// 基准测试
func BenchmarkBankCreateAccount(b *testing.B) {
    bank := NewBank()
    for i := 0; i < b.N; i++ {
        bank.CreateAccount("User", 1000)
    }
}

func BenchmarkBankTransfer(b *testing.B) {
    bank := NewBank()
    account1, _ := bank.CreateAccount("User1", 10000)
    account2, _ := bank.CreateAccount("User2", 10000)
    
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        bank.Transfer(account1.id, account2.id, 1)
    }
}
```

**运行完整测试**:
```bash
# 运行所有测试
go test -v ./...

# 查看覆盖率
go test -cover ./...

# 基准测试
go test -bench=. -benchmem
```

---

## 📝 课后练习

1. 为一个字符串处理函数编写完整的测试套件
2. 实现一个 Mock HTTP 客户端进行测试
3. 编写基准测试比较不同算法的性能
4. 使用表格驱动测试重构现有测试
5. 实现一个带测试覆盖率的完整项目

---

## ✅ 学习检查清单

- [ ] 理解 Go 测试框架
- [ ] 掌握表格驱动测试
- [ ] 学会编写基准测试
- [ ] 理解测试覆盖率
- [ ] 掌握 Mock 与依赖注入
- [ ] 完成所有 8 个案例

---

**上一章**: [第 14 章 - 标准库](./chapter_14.md)  
**下一章**: [第 16 章 - 项目实战](./chapter_16.md)
