---
title: Leetcode189
tags: 数组
categories: 题解
abbrlink: 50191
date: 2023-11-19 19:56:27
---

# [加一](https://leetcode.cn/problems/plus-one/)

---



**题目：**

给定一个整数数组 `nums`，将数组中的元素向右轮转 `k` 个位置，其中 `k` 是非负数。

<!--more-->

 

**示例 1:**

```
输入: nums = [1,2,3,4,5,6,7], k = 3
输出: [5,6,7,1,2,3,4]
解释:
向右轮转 1 步: [7,1,2,3,4,5,6]
向右轮转 2 步: [6,7,1,2,3,4,5]
向右轮转 3 步: [5,6,7,1,2,3,4]
```

**示例 2:**

```
输入：nums = [-1,-100,3,99], k = 2
输出：[3,99,-1,-100]
解释: 
向右轮转 1 步: [99,-1,-100,3]
向右轮转 2 步: [3,99,-1,-100]
```

 

**提示：**

- `1 <= nums.length <= 105`
- `-231 <= nums[i] <= 231 - 1`
- `0 <= k <= 105`

 

**进阶：**

- 尽可能想出更多的解决方案，至少有 **三种** 不同的方法可以解决这个问题。
- 你可以使用空间复杂度为 `O(1)` 的 **原地** 算法解决这个问题吗？





## 代码实现

```c
void rotate(int* nums, int numsSize, int k) {
    k %= numsSize; // 处理 k 大于数组大小的情况

    int count = numsSize; // 循环次数
    int begin = 0; // 循环开始的下标
    int tmp = nums[begin]; // 循环开始的值
    int len = begin; // 在循环中的当前下标

    // 循环执行
    while (count-- > 0) {
        int before = (len - k + numsSize) % numsSize; // 计算下一个位置

        nums[len] = nums[before]; // 将上一个值移动到当前值
        len = before;

        // 如果循环结束，将开始的值赋给结尾的值，进入下一个循环
        if (before == begin) {
            nums[len] = tmp;
            begin = (begin + 1) % numsSize;
            tmp = nums[begin];
            len = begin;
        }
    }
}
```

---

## 基本思路

1. 对 `k` 取余，处理 `k` 大于数组大小的情况，避免不必要的循环。
2. 使用变量 `begin` 记录当前循环的开始下标，`len` 记录在循环中的当前下标。
3. 循环执行，每次计算下一个位置 `before`，将上一个值移动到当前值。
4. 如果循环结束，将开始的值赋给结尾的值，进入下一个循环。



这样，通过不断地将值从上一个位置移动到当前位置，实现数组的循环右移。