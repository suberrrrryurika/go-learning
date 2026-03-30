# 第 14 章 - 标准库

**阶段**: 第 2 阶段 - 进阶  
**预计学习时长**: 4 小时  
**代码量**: 700 行  
**案例数**: 9 个

---

## 🎯 学习目标

1. 掌握常用标准库包的使用
2. 学会文件操作与 IO 处理
3. 理解 JSON 与 XML 编解码
4. 掌握 HTTP 客户端与服务器
5. 学会使用正则表达式

---

## 📚 理论讲解

### 一、常用标准库

| 包 | 用途 | 示例 |
|------|------|------|
| `fmt` | 格式化输入输出 | `fmt.Println()` |
| `os` | 操作系统功能 | `os.Open()` |
| `io` | IO 操作 | `io.Copy()` |
| `encoding/json` | JSON 编解码 | `json.Marshal()` |
| `net/http` | HTTP 协议 | `http.Get()` |
| `regexp` | 正则表达式 | `regexp.Compile()` |
| `strings` | 字符串操作 | `strings.Split()` |
| `time` | 时间处理 | `time.Now()` |

---

## 💻 实战案例

### 案例 1: 文件操作

```go
package main

import (
    "fmt"
    "os"
    "io/ioutil"
)

func main() {
    fmt.Println("=== 文件操作 ===")
    
    // 写入文件
    content := "Hello, Go!\n你好，Go 语言！"
    err := ioutil.WriteFile("test.txt", []byte(content), 0644)
    if err != nil {
        fmt.Printf("写入错误：%v\n", err)
        return
    }
    fmt.Println("✓ 文件已写入")
    
    // 读取文件
    data, err := ioutil.ReadFile("test.txt")
    if err != nil {
        fmt.Printf("读取错误：%v\n", err)
        return
    }
    fmt.Printf("✓ 读取内容：%s\n", string(data))
    
    // 文件信息
    info, err := os.Stat("test.txt")
    if err != nil {
        fmt.Printf("获取信息错误：%v\n", err)
        return
    }
    fmt.Printf("✓ 文件名：%s, 大小：%d 字节\n", info.Name(), info.Size())
    
    // 清理
    os.Remove("test.txt")
    fmt.Println("✓ 文件已删除")
}
```

**输出**:
```
=== 文件操作 ===
✓ 文件已写入
✓ 读取内容：Hello, Go!
你好，Go 语言！
✓ 文件名：test.txt, 大小：24 字节
✓ 文件已删除
```

---

### 案例 2: 文件读写流

```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    fmt.Println("=== 文件读写流 ===")
    
    // 创建文件
    file, err := os.Create("stream.txt")
    if err != nil {
        fmt.Printf("错误：%v\n", err)
        return
    }
    defer file.Close()
    
    // 带缓冲的写入
    writer := bufio.NewWriter(file)
    for i := 1; i <= 5; i++ {
        fmt.Fprintf(writer, "第 %d 行\n", i)
    }
    writer.Flush()
    fmt.Println("✓ 写入完成")
    
    // 读取文件
    file2, err := os.Open("stream.txt")
    if err != nil {
        fmt.Printf("错误：%v\n", err)
        return
    }
    defer file2.Close()
    
    // 逐行读取
    scanner := bufio.NewScanner(file2)
    fmt.Println("\n✓ 读取内容:")
    for scanner.Scan() {
        fmt.Println(scanner.Text())
    }
    
    // 清理
    os.Remove("stream.txt")
}
```

**输出**:
```
=== 文件读写流 ===
✓ 写入完成

✓ 读取内容:
第 1 行
第 2 行
第 3 行
第 4 行
第 5 行
```

---

### 案例 3: JSON 编解码

```go
package main

import (
    "encoding/json"
    "fmt"
)

type Person struct {
    Name string `json:"name"`
    Age  int    `json:"age"`
    City string `json:"city,omitempty"`
}

func main() {
    fmt.Println("=== JSON 编解码 ===")
    
    // 编码
    p := Person{Name: "张三", Age: 25, City: "北京"}
    data, err := json.Marshal(p)
    if err != nil {
        fmt.Printf("编码错误：%v\n", err)
        return
    }
    fmt.Printf("✓ JSON: %s\n", string(data))
    
    // 格式化输出
    pretty, _ := json.MarshalIndent(p, "", "  ")
    fmt.Printf("\n✓ 格式化:\n%s\n", string(pretty))
    
    // 解码
    jsonStr := `{"name":"李四","age":30}`
    var p2 Person
    err = json.Unmarshal([]byte(jsonStr), &p2)
    if err != nil {
        fmt.Printf("解码错误：%v\n", err)
        return
    }
    fmt.Printf("\n✓ 解码后：%+v\n", p2)
    
    // JSON 数组
    fmt.Println("\n=== JSON 数组 ===")
    people := []Person{
        {Name: "Alice", Age: 25},
        {Name: "Bob", Age: 30},
    }
    data, _ = json.Marshal(people)
    fmt.Printf("✓ 数组：%s\n", string(data))
}
```

**输出**:
```
=== JSON 编解码 ===
✓ JSON: {"name":"张三","age":25,"city":"北京"}

✓ 格式化:
{
  "name": "张三",
  "age": 25,
  "city": "北京"
}

✓ 解码后：{Name:李四 Age:30 City:}

=== JSON 数组 ===
✓ 数组：[{"name":"Alice","age":25},{"name":"Bob","age":30}]
```

---

### 案例 4: HTTP 客户端

```go
package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "time"
)

func main() {
    fmt.Println("=== HTTP 客户端 ===")
    
    // 简单 GET 请求
    resp, err := http.Get("https://httpbin.org/get")
    if err != nil {
        fmt.Printf("请求错误：%v\n", err)
        return
    }
    defer resp.Body.Close()
    
    body, _ := ioutil.ReadAll(resp.Body)
    fmt.Printf("✓ 状态码：%d\n", resp.StatusCode)
    fmt.Printf("✓ 响应长度：%d 字节\n", len(body))
    
    // 带超时的客户端
    fmt.Println("\n=== 带超时的客户端 ===")
    client := &http.Client{
        Timeout: 5 * time.Second,
    }
    
    req, _ := http.NewRequest("GET", "https://httpbin.org/delay/1", nil)
    resp, err = client.Do(req)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("✓ 请求成功：%d\n", resp.StatusCode)
        resp.Body.Close()
    }
    
    // POST 请求
    fmt.Println("\n=== POST 请求 ===")
    resp, err = http.Post(
        "https://httpbin.org/post",
        "application/json",
        nil,
    )
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    } else {
        fmt.Printf("✓ POST 成功：%d\n", resp.StatusCode)
        resp.Body.Close()
    }
}
```

**输出**:
```
=== HTTP 客户端 ===
✓ 状态码：200
✓ 响应长度：xxx 字节

=== 带超时的客户端 ===
✓ 请求成功：200

=== POST 请求 ===
✓ POST 成功：200
```

---

### 案例 5: HTTP 服务器

```go
package main

import (
    "fmt"
    "net/http"
)

// 处理器函数
func helloHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %s!", r.URL.Query().Get("name"))
}

// 处理器结构体
type Counter struct{}

func (c *Counter) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "访问次数：%d", 1)
}

func main() {
    fmt.Println("=== HTTP 服务器 ===")
    
    // 注册处理器
    http.HandleFunc("/hello", helloHandler)
    http.Handle("/counter", &Counter{})
    
    // 默认处理器
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "欢迎！访问路径：%s", r.URL.Path)
    })
    
    // 启动服务器
    fmt.Println("服务器启动在 :8080")
    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        fmt.Printf("错误：%v\n", err)
    }
}
```

**输出**:
```
=== HTTP 服务器 ===
服务器启动在 :8080
```

---

### 案例 6: 正则表达式

```go
package main

import (
    "fmt"
    "regexp"
)

func main() {
    fmt.Println("=== 正则表达式 ===")
    
    // 编译正则
    re := regexp.MustCompile(`\d+`)
    
    // 匹配
    text := "我有 3 个苹果和 5 个橙子"
    matches := re.FindAllString(text, -1)
    fmt.Printf("✓ 找到的数字：%v\n", matches)
    
    // 匹配邮箱
    fmt.Println("\n=== 邮箱匹配 ===")
    emailRe := regexp.MustCompile(`[\w.-]+@[\w.-]+\.\w+`)
    emails := emailRe.FindAllString(
        "联系邮箱：test@example.com 或 support@test.org",
        -1,
    )
    fmt.Printf("✓ 找到的邮箱：%v\n", emails)
    
    // 替换
    fmt.Println("\n=== 替换 ===")
    result := re.ReplaceAllString(text, "X")
    fmt.Printf("✓ 替换后：%s\n", result)
    
    // 分组匹配
    fmt.Println("\n=== 分组匹配 ===")
    phoneRe := regexp.MustCompile(`(\d{3,4})-(\d{7,8})`)
    matches2 := phoneRe.FindStringSubmatch("电话：010-12345678")
    for i, match := range matches2 {
        fmt.Printf("[%d] %s\n", i, match)
    }
}
```

**输出**:
```
=== 正则表达式 ===
✓ 找到的数字：[3 5]

=== 邮箱匹配 ===
✓ 找到的邮箱：[test@example.com support@test.org]

=== 替换 ===
✓ 替换后：我有 X 个苹果和 X 个橙子

=== 分组匹配 ===
[0] 010-12345678
[1] 010
[2] 12345678
```

---

### 案例 7: 字符串处理

```go
package main

import (
    "fmt"
    "strings"
)

func main() {
    fmt.Println("=== 字符串处理 ===")
    
    s := "  Hello, Go!  "
    
    // 修剪空格
    fmt.Printf("✓ 修剪：%q\n", strings.TrimSpace(s))
    
    // 大小写转换
    fmt.Printf("✓ 大写：%s\n", strings.ToUpper(s))
    fmt.Printf("✓ 小写：%s\n", strings.ToLower(s))
    
    // 查找
    fmt.Printf("✓ 包含 Go: %t\n", strings.Contains(s, "Go"))
    fmt.Printf("✓ 索引：%d\n", strings.Index(s, "Go"))
    
    // 分割
    fmt.Println("\n=== 分割 ===")
    parts := strings.Split("a,b,c,d", ",")
    fmt.Printf("✓ 分割：%v\n", parts)
    
    // 连接
    fmt.Println("\n=== 连接 ===")
    joined := strings.Join(parts, "-")
    fmt.Printf("✓ 连接：%s\n", joined)
    
    // 替换
    fmt.Println("\n=== 替换 ===")
    replaced := strings.Replace(s, "Go", "Golang", -1)
    fmt.Printf("✓ 替换：%s\n", replaced)
    
    // 重复
    fmt.Println("\n=== 重复 ===")
    repeated := strings.Repeat("Go ", 3)
    fmt.Printf("✓ 重复：%s\n", repeated)
}
```

**输出**:
```
=== 字符串处理 ===
✓ 修剪："Hello, Go!"
✓ 大写：  HELLO, GO!  
✓ 小写：  hello, go!  
✓ 包含 Go: true
✓ 索引：9

=== 分割 ===
✓ 分割：[a b c d]

=== 连接 ===
✓ 连接：a-b-c-d

=== 替换 ===
✓ 替换：  Hello, Golang!  

=== 重复 ===
✓ 重复：Go Go Go 
```

---

### 案例 8: 时间处理

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Println("=== 时间处理 ===")
    
    // 当前时间
    now := time.Now()
    fmt.Printf("✓ 当前时间：%s\n", now)
    fmt.Printf("✓ 年：%d, 月：%d, 日：%d\n", now.Year(), now.Month(), now.Day())
    fmt.Printf("✓ 时：%d, 分：%d, 秒：%d\n", now.Hour(), now.Minute(), now.Second())
    
    // 格式化
    fmt.Println("\n=== 格式化 ===")
    fmt.Printf("✓ RFC3339: %s\n", now.Format(time.RFC3339))
    fmt.Printf("✓ 自定义：%s\n", now.Format("2006-01-02 15:04:05"))
    
    // 解析
    fmt.Println("\n=== 解析 ===")
    t, _ := time.Parse("2006-01-02", "2024-01-15")
    fmt.Printf("✓ 解析结果：%s\n", t)
    
    // 时间计算
    fmt.Println("\n=== 时间计算 ===")
    tomorrow := now.AddDate(0, 0, 1)
    fmt.Printf("✓ 明天：%s\n", tomorrow.Format("2006-01-02"))
    
    // 时间差
    fmt.Println("\n=== 时间差 ===")
    diff := tomorrow.Sub(now)
    fmt.Printf("✓ 相差：%v\n", diff)
    fmt.Printf("✓ 相差小时：%v\n", diff.Hours())
    
    // 定时器
    fmt.Println("\n=== 定时器 ===")
    timer := time.NewTimer(1 * time.Second)
    <-timer.C
    fmt.Println("✓ 1 秒后触发")
}
```

**输出**:
```
=== 时间处理 ===
✓ 当前时间：2024-01-14 12:00:00
✓ 年：2024, 月：1, 日：14
✓ 时：12, 分：00, 秒：00

=== 格式化 ===
✓ RFC3339: 2024-01-14T12:00:00+08:00
✓ 自定义：2024-01-14 12:00:00

=== 解析 ===
✓ 解析结果：2024-01-15 00:00:00 +0000 UTC

=== 时间计算 ===
✓ 明天：2024-01-15

=== 时间差 ===
✓ 相差：24h0m0s
✓ 相差小时：24

=== 定时器 ===
✓ 1 秒后触发
```

---

### 案例 9: 综合应用 - 日志系统

```go
package main

import (
    "fmt"
    "log"
    "os"
    "time"
)

type Logger struct {
    infoLog  *log.Logger
    errorLog *log.Logger
}

func NewLogger(logFile string) (*Logger, error) {
    // 创建日志文件
    file, err := os.OpenFile(logFile, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
    if err != nil {
        return nil, err
    }
    
    return &Logger{
        infoLog:  log.New(file, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile),
        errorLog: log.New(file, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile),
    }, nil
}

func (l *Logger) Info(format string, v ...interface{}) {
    l.infoLog.Printf(format, v...)
}

func (l *Logger) Error(format string, v ...interface{}) {
    l.errorLog.Printf(format, v...)
}

func (l *Logger) Close() {
    // 实际应用中需要关闭文件
}

func main() {
    fmt.Println("=== 日志系统 ===")
    
    logger, err := NewLogger("app.log")
    if err != nil {
        fmt.Printf("创建日志错误：%v\n", err)
        return
    }
    defer logger.Close()
    
    // 记录日志
    logger.Info("应用程序启动")
    logger.Info("处理请求：%s", "/api/users")
    logger.Info("用户登录：%s", "alice")
    
    time.Sleep(100 * time.Millisecond)
    
    logger.Error("数据库连接失败：%s", "timeout")
    logger.Error("文件未找到：%s", "config.json")
    
    fmt.Println("✓ 日志已记录到 app.log")
    
    // 清理
    os.Remove("app.log")
}
```

**输出**:
```
=== 日志系统 ===
✓ 日志已记录到 app.log
```

---

## 📝 课后练习

1. 实现一个 JSON 配置文件读取器
2. 编写一个 HTTP 客户端，支持重试机制
3. 实现一个简单的 Web 爬虫
4. 使用正则表达式验证用户输入
5. 实现一个带日志轮转的日志系统

---

## ✅ 学习检查清单

- [ ] 掌握常用标准库包的使用
- [ ] 学会文件操作与 IO 处理
- [ ] 理解 JSON 与 XML 编解码
- [ ] 掌握 HTTP 客户端与服务器
- [ ] 学会使用正则表达式
- [ ] 完成所有 9 个案例

---

**上一章**: [第 13 章 - 并发编程](./chapter_13.md)  
**下一章**: [第 15 章 - 测试](./chapter_15.md)
