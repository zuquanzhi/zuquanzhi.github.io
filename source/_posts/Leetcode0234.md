---
title: Leetcode0234
tags: 链表
categories: 题解
abbrlink: 45468
date: 2023-11-30 20:36:25
---

# [回文链表](https://leetcode.cn/problems/palindrome-linked-list/)

## 题目描述

给你一个单链表的头节点 `head` ，请你判断该链表是否为回文链表。如果是，返回 `true` ；否则，返回 `false` 。

 <!--more-->

**示例 1：**

![img](https://assets.leetcode.com/uploads/2021/03/03/pal1linked-list.jpg)

```
输入：head = [1,2,2,1]
输出：true
```

**示例 2：**

![img](https://assets.leetcode.com/uploads/2021/03/03/pal2linked-list.jpg)

```
输入：head = [1,2]
输出：false
```

 

**提示：**

- 链表中节点数目在范围`[1, 105]` 内
- `0 <= Node.val <= 9`



## 基本思路

### 法一：复制到数组

小生不才，链表使用不够熟练，先用复制链表到数组的笨方法做出来一遍。

```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */
bool isPalindrome(struct ListNode* head) {
    struct ListNode* cur = head;
    int count = 0;

    // 计算链表长度
    while(cur) {
        count++;
        cur = cur->next;
    }

    // 动态分配数组
    int* a = (int*)malloc(count * sizeof(int));
    if (!a) {
        // 处理内存分配失败的情况
        return false;
    }

    // 重新遍历链表，将值存入数组
    cur = head;
    for(int i = 0; i < count; i++) {
        a[i] = cur->val;
        cur = cur->next;
    }

    // 检查是否为回文
    for(int i = 0; i < count / 2; i++) {
        if(a[i] != a[count - 1 - i]) {
            free(a);  // 释放动态分配的数组内存
            return false;
        }
    }

    free(a);  // 释放动态分配的数组内存
    return true;
}

```

### 法二：快慢指针

这也是我想到的第二个方法。

整个流程可以分为以下五个步骤：

1. 找到前半部分链表的尾节点。

2. 反转后半部分链表。

3. 判断是否回文。

4. 恢复链表。

5. 返回结果。

   

   执行步骤一，我们可以计算链表节点的数量，然后遍历链表找到前半部分的尾节点。

   我们也可以使用快慢指针在一次遍历中找到：慢指针一次走一步，快指针一次走两步，快慢指针同时出发。当快指针移动到链表的末尾时，慢指针恰好到链表的中间。通过慢指针将链表分为两部分。

   若链表有奇数个节点，则中间的节点应该看作是前半部分。

   步骤二可以使用[反转链表]([Leetcode0206 | 全之の博客 (blog.zuquanzhi.top)](http://blog.zuquanzhi.top/2023/11/30/Leetcode0206/#more))问题中的解决方法来反转链表的后半部分。

   步骤三比较两个部分的值，当后半部分到达末尾则比较完成，可以忽略计数情况中的中间节点。

   步骤四与步骤二使用的函数相同，再反转一次恢复链表本身。

   其代码如下：

   ```c
   struct ListNode* reverseList(struct ListNode* head) {
       struct ListNode* prev = NULL;//创建空节点用于存放“前一个”数据
       struct ListNode* curr = head;//基操curr遍历
       while (curr != NULL) {
           struct ListNode* nextTemp = curr->next;
           curr->next = prev;
           prev = curr;
           curr = nextTemp;
       }//反转函数
       return prev;
   }
   
   struct ListNode* endOfFirstHalf(struct ListNode* head) {
       struct ListNode* fast = head;//块指针
       struct ListNode* slow = head;//慢指针
       while (fast->next != NULL && fast->next->next != NULL) {
           fast = fast->next->next;//一次走两步
           slow = slow->next;//一次走一步
       }
       return slow;//由于快慢指针的数量关系，slow返回的应该是链表半节点处
   }
   
   bool isPalindrome(struct ListNode* head) {//最终的bool类型判断函数
       if (head == NULL) {
           return true;
       }
   
       // 找到前半部分链表的尾节点并反转后半部分链表
       struct ListNode* firstHalfEnd = endOfFirstHalf(head);
       struct ListNode* secondHalfStart = reverseList(firstHalfEnd->next);
   
       // 判断是否回文
       struct ListNode* p1 = head;
       struct ListNode* p2 = secondHalfStart;
       bool result = true;
       while (result && p2 != NULL) {
           if (p1->val != p2->val) {
               result = false;
           }
           p1 = p1->next;
           p2 = p2->next;
       }
   
       // 还原链表并返回结果
       firstHalfEnd->next = reverseList(secondHalfStart);
       return result;
   }
   
   ```

   

   

### 法三：递归

*这个递归来源于Leetcode官方题解，其风骚是我至今所遇最强。*



```c
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     struct ListNode *next;
 * };
 */

// 全局变量，用于存储前半部分链表的指针
struct ListNode* frontPointer;

// 递归检查是否回文
bool recursivelyCheck(struct ListNode* currentNode) {
    // 当前节点不为空时进行递归检查
    if (currentNode != NULL) {
        // 递归检查下一个节点，如果返回 false，则整体返回 false
        if (!recursivelyCheck(currentNode->next)) {
            return false;
        }
        
        // 检查当前节点的值是否与前半部分链表的节点值相等
        if (currentNode->val != frontPointer->val) {
            return false;
        }

        // 前半部分链表指针移动到下一个节点
        frontPointer = frontPointer->next;
    }

    // 若所有节点都检查完毕，返回 true
    return true;
}

// 检查链表是否为回文
bool isPalindrome(struct ListNode* head) {
    // 初始化全局变量 frontPointer
    frontPointer = head;

    // 调用递归检查函数
    return recursivelyCheck(head);
}

```

1. `isPalindrome` 函数设置 `frontPointer` 为链表头，并调用 `recursivelyCheck` 函数。
2. `recursivelyCheck` 函数首先检查当前节点是否为 `NULL`，如果是，则返回 `true`，因为链表的末尾已经达到。
3. 然后，`recursivelyCheck` 递归调用自己，传递当前节点的下一个节点。
4. 在递归返回之前，检查当前节点的值是否等于 `frontPointer` 指向的节点的值。如果不等，则返回 `false`，因为链表不是回文的。
5. 如果值相等，将 `frontPointer` 移动到下一个节点。
6. 最终，如果整个链表都被成功检查，并且没有发现值不相等的情况，那么整个函数返回 `true`，表示链表是回文的。

这种方法的核心思想是使用递归从链表的末尾开始比较节点的值，同时使用 `frontPointer` 从链表的头部开始。这两个指针相向移动，逐一比较节点的值，如果在整个过程中没有找到不相等的节点，则链表被认为是回文的。




