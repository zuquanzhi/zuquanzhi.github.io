---
title: LeetCode0724
tags: 数组
categories: 题解
abbrlink: 14479
date: 2023-11-20 21:15:39
---

# [寻找数组的中心下标](https://leetcode.cn/problems/find-pivot-index/)

---

## 题目描述

给你一个整数数组 `nums` ，请计算数组的 **中心下标** 。

数组 **中心下标** 是数组的一个下标，其左侧所有元素相加的和等于右侧所有元素相加的和。

如果中心下标位于数组最左端，那么左侧数之和视为 `0` ，因为在下标的左侧不存在元素。这一点对于中心下标位于数组最右端同样适用。

如果数组有多个中心下标，应该返回 **最靠近左边** 的那一个。如果数组不存在中心下标，返回 `-1` 。

 

<!--more-->

**示例 1：**

```
输入：nums = [1, 7, 3, 6, 5, 6]
输出：3
解释：
中心下标是 3 。
左侧数之和 sum = nums[0] + nums[1] + nums[2] = 1 + 7 + 3 = 11 ，
右侧数之和 sum = nums[4] + nums[5] = 5 + 6 = 11 ，二者相等。
```

**示例 2：**

```
输入：nums = [1, 2, 3]
输出：-1
解释：
数组中不存在满足此条件的中心下标。
```

**示例 3：**

```
输入：nums = [2, 1, -1]
输出：0
解释：
中心下标是 0 。
左侧数之和 sum = 0 ，（下标 0 左侧不存在元素），
右侧数之和 sum = nums[1] + nums[2] = 1 + -1 = 0 。
```

 

**提示：**

- `1 <= nums.length <= 104`
- `-1000 <= nums[i] <= 1000`



## 思路

* 刚开始没什么具体思路，非常脑残地一点点计算出SUM(左右)，代码如下：

```c
int pivotIndex(int* nums, int numsSize) {
    int sum = 0;
    int sum_left = 0, sum_right = 0;
    int i;
    for (int i = 0; i < numsSize; i++) {
        sum += nums[i];
    }
    if (sum == 0)
        return 0;
    else {
        for (i = 0; i < numsSize; i++) {
            for (int j = 0; j < i; j++)
                sum_left += nums[j];
            for (int p = i + 1; p < numsSize; p++)
                sum_right += nums[p];

            if (sum_left == sum_right)
                return i;

            // 重置 sum_left 和 sum_right
            sum_left = 0;
            sum_right = 0;
        }
    }
    return -1;
}
```

**中间那个重置千万别忘掉**



* 在GPT的帮助下，我把代码重构了一下，主要是针对右侧sum的计算逻辑修改

  ```C
  int pivotIndex(int* nums, int numsSize) {
      int sum = 0;
      int sum_left = 0;
      int sum_right;
  
      for (int i = 0; i < numsSize; i++) {
          sum += nums[i];
      }
  
      for (int i = 0; i < numsSize; i++) {
          sum_right = sum - sum_left - nums[i];
  
          if (sum_left == sum_right) {
              return i;
          }
  
          sum_left += nums[i];
      }
  
      return -1;
  }
  
  ```

  这个逻辑中无需先预判[0]元素是否可以直接PASS（其实前一个也不用，写麻烦了），并且用全数列的sum-左sum-当前元素，少了一丢丢运算过程，更加简洁明了
