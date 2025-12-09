---
title: 缓存机制深度解析：Golang 实现与优化
cover: 'https://www.loliapi.com/acg?302'
categories: 数据结构与算法
tags: LRU
abbrlink: 55306
date: 2025-10-21 17:04:13
updated: 2025-10-21 17:04:13
---

## 1. LRU 缓存概述

LRU（Least Recently Used，最近最少使用）是一种经典的缓存淘汰策略。其核心思想是：**当缓存空间不足时，优先淘汰最久未被访问的数据**。

LRU 缓存广泛应用于操作系统（如页面置换）、数据库（如缓冲池）、Web 服务器（如 HTTP 缓存）以及各类应用系统中，用于在有限内存中高效管理热点数据。

---

## 2. LRU 缓存的核心操作

一个标准的 LRU 缓存需支持以下操作：

- **Get(key)**：获取 key 对应的值；若 key 不存在，返回 -1（或其他约定值）。访问后，该 key 应被标记为“最近使用”。
- **Put(key, value)**：插入或更新 key-value 对。若缓存已满，则淘汰最久未使用的项。

**时间复杂度要求**：
- Get 和 Put 操作均需 **O(1)** 时间复杂度。

---

## 3. 数据结构选择

要实现 O(1) 的 Get 和 Put，需结合两种数据结构：

### 3.1 哈希表（map）
- 提供 O(1) 的 key 查找。
- 存储 key 到链表节点的映射。

### 3.2 双向链表（Doubly Linked List）
- 头部：最近使用的元素。
- 尾部：最久未使用的元素。
- 支持 O(1) 的节点插入（头插）、删除（尾删）和移动（移到头部）。

> **为什么用双向链表？**  
> 单向链表无法在 O(1) 时间内删除尾节点（需遍历到倒数第二个节点）。双向链表通过 `tail.prev` 可直接定位前驱节点。

---

## 4. Golang 实现详解

### 4.1 定义数据结构

```go
package lru

// Node 表示双向链表的节点
type Node struct {
    key   int
    value int
    prev  *Node
    next  *Node
}

// LRUCache 是 LRU 缓存结构
type LRUCache struct {
    capacity int           // 缓存容量
    cache    map[int]*Node // 哈希表：key -> Node
    head     *Node         // 虚拟头节点
    tail     *Node         // 虚拟尾节点
}
```

### 4.2 初始化

```go
// NewLRUCache 创建一个新的 LRU 缓存
func NewLRUCache(capacity int) *LRUCache {
    // 创建虚拟头尾节点，简化边界处理
    head := &Node{}
    tail := &Node{}
    head.next = tail
    tail.prev = head

    return &LRUCache{
        capacity: capacity,
        cache:    make(map[int]*Node),
        head:     head,
        tail:     tail,
    }
}
```

### 4.3 辅助方法：链表操作

```go
// addToHead 将节点插入到头部（head 之后）
func (lru *LRUCache) addToHead(node *Node) {
    node.prev = lru.head
    node.next = lru.head.next
    lru.head.next.prev = node
    lru.head.next = node
}

// removeNode 从链表中移除指定节点
func (lru *LRUCache) removeNode(node *Node) {
    node.prev.next = node.next
    node.next.prev = node.prev
}

// moveToHead 将节点移动到头部（先移除，再插入头部）
func (lru *LRUCache) moveToHead(node *Node) {
    lru.removeNode(node)
    lru.addToHead(node)
}

// removeTail 移除尾部节点（tail 之前），并返回该节点
func (lru *LRUCache) removeTail() *Node {
    last := lru.tail.prev
    lru.removeNode(last)
    return last
}
```

### 4.4 核心方法：Get

```go
// Get 获取 key 对应的值
func (lru *LRUCache) Get(key int) int {
    if node, exists := lru.cache[key]; exists {
        // 访问后移到头部（标记为最近使用）
        lru.moveToHead(node)
        return node.value
    }
    return -1 // 未找到
}
```

### 4.5 核心方法：Put

```go
// Put 插入或更新 key-value
func (lru *LRUCache) Put(key int, value int) {
    if node, exists := lru.cache[key]; exists {
        // key 已存在：更新值，并移到头部
        node.value = value
        lru.moveToHead(node)
    } else {
        // key 不存在：创建新节点
        newNode := &Node{key: key, value: value}
        lru.cache[key] = newNode
        lru.addToHead(newNode)

        // 检查是否超出容量
        if len(lru.cache) > lru.capacity {
            // 淘汰尾部节点
            tail := lru.removeTail()
            delete(lru.cache, tail.key) // 从哈希表中删除
        }
    }
}
```

---

## 5. 关键设计细节解析

### 6.1 虚拟头尾节点（Sentinel Nodes）
- 避免处理空链表的边界情况。
- 插入/删除操作无需判断 `prev` 或 `next` 是否为 nil。

### 6.2 时间复杂度保证
| 操作        | 哈希表  | 链表操作 | 总体 |
|-------------|--------|----------|------|
| Get         | O(1)   | O(1)     | O(1) |
| Put（更新） | O(1)   | O(1)     | O(1) |
| Put（插入） | O(1)   | O(1)     | O(1) |

### 6.3 空间复杂度
- **O(N)**，其中 N 为缓存容量（哈希表 + 链表节点）。

---


> **延伸阅读**：  
> - LFU（Least Frequently Used）缓存  
> - ARC（Adaptive Replacement Cache）  
> - Redis 的 LRU 实现（近似 LRU）