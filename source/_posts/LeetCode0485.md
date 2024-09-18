---
title: LeetCode0485
tags: 数组
categories: 题解
abbrlink: 22712
date: 2023-11-21 11:41:58
---

# [最大连续 1 的个数](https://leetcode.cn/problems/max-consecutive-ones/)

---

### 题目描述

给定一个二进制数组 `nums` ， 计算其中最大连续 `1` 的个数。

 <!--more-->

**示例 1：**

```
输入：nums = [1,1,0,1,1,1]
输出：3
解释：开头的两位和最后的三位都是连续 1 ，所以最大连续 1 的个数是 3.
```

**示例 2:**

```
输入：nums = [1,0,1,1,0,1]
输出：2
```

 

**提示：**

- `1 <= nums.length <= 105`

- `nums[i]` 不是 `0` 就是 `1`.

  

### 基本思路

本题中存在两个技术点：连续数和最大。

连续数是比较好求的，只需要条件判定再加上计数器就可以做到。

关键在于最大，使我引入了一个缓存变量tmp，用来实时更新“最大连击数”并不会占用1太多空间。

### 代码实现

```c
int findMaxConsecutiveOnes(int* nums, int numsSize) {
    int i;
    int count = 0;
    int tmp;

    for (i = 0; i < numsSize; i++) {
        tmp = 0;
        while (i < numsSize && nums[i] == 1) {
            tmp++;
            i++;
        }

        if (count < tmp) {
            count = tmp;
        }
    }

    return count;
}
```

