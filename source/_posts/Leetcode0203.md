---
title: Leetcode0203
tags: 链表
categories: 题解
abbrlink: 33757
date: 2023-11-30 20:05:21
---

# [移除链表元素](https://leetcode.cn/problems/remove-linked-list-elements/)

## 题目描述

给你一个链表的头节点 `head` 和一个整数 `val` ，请你删除链表中所有满足 `Node.val == val` 的节点，并返回 **新的头节点** 。

<!--more-->

 

**示例 1：**

![img](https://assets.leetcode.com/uploads/2021/03/06/removelinked-list.jpg)

```
输入：head = [1,2,6,3,4,5,6], val = 6
输出：[1,2,3,4,5]
```

**示例 2：**

```
输入：head = [], val = 1
输出：[]
```

**示例 3：**

```
输入：head = [7,7,7,7], val = 7
输出：[]
```

 

**提示：**

- 列表中的节点数目在范围 `[0, 104]` 内
- `1 <= Node.val <= 50`
- `0 <= val <= 50`



## 基本思路

刚开始思路非常简单：检测到下一个节点是val，删除该节点。写出了下面这段蠢到家的代码：

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* removeElements(struct ListNode* head, int val) {
    struct ListNode* cur=head;
    while(cur->next){
        if (cur->next==val) {
            cur->next = cur->next->next;
        } else {
            cur = cur->next;
        }
    }
    return head;
}

```

仔细一看题：发现“**新的头节点**”还特意加粗了，看起来如果第一个节点就是空节点程序会直接寄掉。

1. `cur->next = cur->next->next;` 表示删除当前节点的下一个节点。这会导致无法处理连续相同值的节点。正确的做法是将当前节点的 `next` 指针直接指向下下个节点，而不是跳过一个节点。
2. 函数的返回值是链表的头指针 `head`，但是在删除节点的过程中，链表头部可能发生变化。因此，应该在删除节点后返回新的头指针。

修改为以下程序：

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* removeElements(struct ListNode* head, int val) {
    struct ListNode* dummy = malloc(sizeof(struct ListNode));
    dummy->next = head;//在头节点前创建一个空节点，用于解决其为val的情况
    struct ListNode* cur = dummy;//基操用cur遍历
    while(cur->next){
        if (cur->next->val==val) {
            cur->next = cur->next->next;
        } else {
            cur = cur->next;
        }
    }
    struct ListNode* newHead = dummy->next;
    free(dummy);

    return newHead;//返回新的头节点，并释放dummy的空间
}


```

