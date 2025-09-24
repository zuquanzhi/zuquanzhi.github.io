---
title: 深入解析Go中Slice底层实现
categories: Golang
tags:
  - Golang
  - Slice
cover: 'https://www.loliapi.com/acg?29'
abbrlink: 59604
date: 2025-09-22 13:17:44
---

# 深入解析Go中Slice的底层实现

## 一、Slice的底层数据结构
切片是 Go 中的一种基本的数据结构，是对底层数组的一个动态、灵活的视图。使用这种结构可以用来管理数据集合。切片的设计想法是由动态数组概念而来，为了开发者可以更加方便的使一个数据结构可以自动增加和减少。但是切片本身并不是动态数据或者数组指针。

在golang runtime中，slice的实现并不是一个指针，而是一组结构体:
```golang
// runtime/slice.go 中的定义
type slice struct {
    array unsafe.Pointer // 指向底层数组的指针
    len   int            // 当前长度
    cap   int            // 容量（从起始位置到底层数组末尾的元素个数）
}
```
切片本身并不是动态数组或者数组指针。它内部实现的数据结构通过指针引用底层数组，设定相关属性将数据读写操作限定在指定的区域内。切片本身是一个只读对象，其工作机制类似数组指针的一种封装。

切片（slice）是对数组一个连续片段的引用，所以切片是一个引用类型（因此更类似于 C++ 中的 Vector 类型，或者 Python 中的 list 类型）。这个片段可以是整个数组，或者是由起始和终止索引标识的一些项的子集。需要注意的是，终止索引标识的项不包括在切片内。切片提供了一个与指向数组的动态窗口。

给定项的切片索引可能比相关数组的相同元素的索引小。和数组不同的是，切片的长度可以在运行时修改，最小为 0 最大为相关数组的长度：切片是一个长度可变的数组。

## 二、内存布局
假设我们有
```golang
arr := [6]int{0, 1, 2, 3, 4, 5}
s := arr[1:4] // s 指向 arr[1] 到 arr[3]
```
则内存布局如下：
```goalng
底层数组 arr:
索引:  0   1   2   3   4   5
值:   [0][1][2][3][4][5]
       ↑           ↑
       |___________|
           s 的范围（len=3）

s 的结构：
- array → 指向 arr[1] 的地址
- len   = 3
- cap   = 5 （因为从 arr[1] 到 arr[5] 共 5 个元素）
```

> **cap = len(arr) - start_index = 6 - 1 = 5**

---

## 三、关键操作的底层行为

### 1. 创建切片（字面量或 make）

```go
s := []int{10, 20, 30}
```

- Go 会在堆上分配一个底层数组 `[10, 20, 30]`
- 创建一个 slice 结构体：
  - `array` → 指向该数组首地址
  - `len = 3`
  - `cap = 3`

```go
s := make([]int, 2, 5)
```

- 分配一个长度为 5 的底层数组（初始化为 0）
- slice 结构体：
  - `array` → 指向数组首地址
  - `len = 2`
  - `cap = 5`

---

### 2. 切片操作（s[i:j]）

```go
a := []int{0, 1, 2, 3, 4, 5}
b := a[1:4]
```

- `b.array = a.array + 1 * sizeof(int)`（指针偏移）
- `b.len = 4 - 1 = 3`
- `b.cap = a.cap - 1 = 6 - 1 = 5`

> **不复制数据！只是调整指针和长度/容量。**

验证代码：

```go
package main

import (
    "fmt"
    "unsafe"
)

func main() {
    a := []int{0, 1, 2, 3, 4, 5}
    b := a[1:4]

    fmt.Printf("a 地址: %p, len=%d, cap=%d\n", &a[0], len(a), cap(a))
    fmt.Printf("b 地址: %p, len=%d, cap=%d\n", &b[0], len(b), cap(b))

    // 修改 b 影响 a
    b[0] = 999
    fmt.Println("修改 b[0] 后 a =", a) // [0 999 2 3 4 5]
}
```

Output：
```
a 地址: 0xc0000140c0, len=6, cap=6
b 地址: 0xc0000140c8, len=3, cap=5
修改 b[0] 后 a = [0 999 2 3 4 5]
```

> `b` 的起始地址比 `a` 大 8 字节（64 位系统，int 占 8 字节），说明指针偏移。

---

### 3. `append` 的底层逻辑

`append` 的伪代码逻辑如下：

```go
func append(slice []T, elements ...T) []T {
    if len(slice)+len(elements) > cap(slice) {
        // 容量不足，需要扩容
        newCap := growCap(cap(slice), len(slice), len(elements))
        newSlice := make([]T, len(slice), newCap)
        copy(newSlice, slice) // 复制旧数据
        slice = newSlice
    }
    // 将新元素追加到 slice[len(slice):]
    copy(slice[len(slice):], elements)
    slice.len += len(elements)
    return slice
}
```

#### 扩容策略（Go 1.18+）：

- 如果 `cap < 1024`：新容量 ≈ 2 * 旧容量
- 如果 `cap >= 1024`：每次增加约 1/4 容量（直到满足需求）

> 实际策略更复杂，考虑内存对齐等。

示例：观察扩容

```go
package main

import "fmt"

func main() {
    var s []int
    fmt.Printf("初始: len=%d, cap=%d\n", len(s), cap(s))

    for i := 0; i < 10; i++ {
        s = append(s, i)
        fmt.Printf("追加 %d 后: len=%d, cap=%d\n", i, len(s), cap(s))
    }
}
```

Output：
```
初始: len=0, cap=0
追加 0 后: len=1, cap=1
追加 1 后: len=2, cap=2
追加 2 后: len=3, cap=4
追加 3 后: len=4, cap=4
追加 4 后: len=5, cap=8
...
```

> 可见容量按 1→2→4→8 增长（指数增长）。

---

### 4. `copy` 的底层行为

```go
dst := make([]int, 3)
src := []int{1, 2, 3, 4}
n := copy(dst, src)
```

- 底层调用 `memmove`（或类似）复制 `min(len(dst), len(src))` 个元素
- **不改变 dst 的 len/cap，只改内容**

---

## 四、使用 `unsafe` 观察 slice 结构（高级）

> ⚠️ 仅用于学习，生产代码避免使用 `unsafe`

```go
package main

import (
    "fmt"
    "unsafe"
)

func main() {
    s := []int{10, 20, 30}
    fmt.Printf("slice s: %v\n", s)

    // 将 slice 强制转换为结构体指针
    type sliceHeader struct {
        ptr uintptr
        len int
        cap int
    }

    h := (*sliceHeader)(unsafe.Pointer(&s))
    fmt.Printf("ptr: 0x%x, len: %d, cap: %d\n", h.ptr, h.len, h.cap)

    // 验证 ptr 指向第一个元素
    fmt.Printf("s[0] 地址: %p\n", &s[0])
}
```

Output：
```
slice s: [10 20 30]
ptr: 0xc0000140c0, len: 3, cap: 3
s[0] 地址: 0xc0000140c0
```

> `ptr` 与 `&s[0]` 地址一致，验证了 slice 的指针指向底层数组首元素。

---
> 引用
> - [深入解析 Go 中 Slice 底层实现](https://halfrost.com/go_slice/#toc-1)
> - [Qwen](https://chat.qwen.ai/)
