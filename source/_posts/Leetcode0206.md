---
title: Leetcode0206
tags: 链表
categories: 题解
abbrlink: 32797
date: 2023-11-30 19:21:11
---

# [反转链表](https://leetcode.cn/problems/reverse-linked-list/)

## 题目描述

给你单链表的头节点 `head` ，请你反转链表，并返回反转后的链表。

<!--more-->

 

**示例 1：**

![img](https://assets.leetcode.com/uploads/2021/02/19/rev1ex1.jpg)

```
输入：head = [1,2,3,4,5]
输出：[5,4,3,2,1]
```

**示例 2：**

![img](https://assets.leetcode.com/uploads/2021/02/19/rev1ex2.jpg)

```
输入：head = [1,2]
输出：[2,1]
```

**示例 3：**

```
输入：head = []
输出：[]
```

 

**提示：**

- 链表中节点的数目范围是 `[0, 5000]`
- `-5000 <= Node.val <= 5000`

## 基本思路

基本想法是把列表的首尾节点调换，即每一个指针都指向前一个节点。

代码如下：

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* reverseList(struct ListNode* head) {
    struct ListNode* prev =NULL;//创建一个空头节点
    struct ListNode* curr=head;//创建curr用于遍历链表
    while(curr){
        struct ListNode* next =curr->next;
        curr->next =prev;
        prev =curr;//把pre遍历到当前节点
        curr=next;//把当前指针遍历到下一个节点
    }
    return prev;
}
```

