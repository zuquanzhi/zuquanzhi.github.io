---
title: Leetcode83
tags: 链表
categories: 题解
abbrlink: 51494
date: 2023-11-30 19:02:34
---



# [删除排序链表中的重复元素](https://leetcode.cn/problems/remove-duplicates-from-sorted-list/)

## 题目描述

给定一个已排序的链表的头 `head` ， *删除所有重复的元素，使每个元素只出现一次* 。返回 *已排序的链表* 。



<!--more-->

 

**示例 1：**

![img](https://assets.leetcode.com/uploads/2021/01/04/list1.jpg)

```
输入：head = [1,1,2]
输出：[1,2]
```

**示例 2：**

![img](https://assets.leetcode.com/uploads/2021/01/04/list2.jpg)

```
输入：head = [1,1,2,3,3]
输出：[1,2,3]
```

 

**提示：**

- 链表中节点数目在范围 `[0, 300]` 内
- `-100 <= Node.val <= 100`
- 题目数据保证链表已经按升序 **排列**

## 基本思路

根据题干描述，链表已经按照升序排列，即只需要判断前后两个节点是否相等从而确定删除与否即可。

代码如下：

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
struct ListNode* deleteDuplicates(struct ListNode* head) {
    if (!head) {
        return head;//即链表为空，没有重复元素可以删除。
    }

    struct ListNode* cur = head;
    while (cur->next) {//条件是当前节点的下一个节点不为空
        if (cur->val == cur->next->val) {
            cur->next = cur->next->next;
        } else {
            cur = cur->next;
        }
    }

    return head;
}

```

