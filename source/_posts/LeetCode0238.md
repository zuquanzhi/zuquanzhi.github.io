---
title: LeetCode0238
tags: 数组
categories: 题解
abbrlink: 44190
date: 2023-11-22 08:39:26
---

# [除自身以外数组的乘积](https://leetcode.cn/problems/product-of-array-except-self/)

## 题目描述

给你一个整数数组 `nums`，返回 *数组 `answer` ，其中 `answer[i]` 等于 `nums` 中除 `nums[i]` 之外其余各元素的乘积* 。

题目数据 **保证** 数组 `nums`之中任意元素的全部前缀元素和后缀的乘积都在 **32 位** 整数范围内。

请 **不要使用除法，**且在 `O(*n*)` 时间复杂度内完成此题。

<!--more-->

 

**示例 1:**

```
输入: nums = [1,2,3,4]
输出: [24,12,8,6]
```

**示例 2:**

```
输入: nums = [-1,1,0,-3,3]
输出: [0,0,9,0,0]
```

 

**提示：**

- `2 <= nums.length <= 105`
- `-30 <= nums[i] <= 30`
- **保证** 数组 `nums`之中任意元素的全部前缀元素和后缀的乘积都在 **32 位** 整数范围内



---

## 基本思路

刚开始我想得比较简单，认为只需要把所有元素的乘积求出，再在循环里一个个除就好。

```c
#include <stdlib.h>

int* productExceptSelf(int* nums, int numsSize, int* returnSize) {
    int* answer = (int*)malloc(numsSize * sizeof(int));
    if (answer == NULL) { // 检查内存分配是否成功
        *returnSize = 0;
        return NULL;
    }

    int product = 1;
    for (int i = 0; i < numsSize; i++) {
        product *= nums[i];
    }

    for (int i = 0; i < numsSize; i++) {
        answer[i] = product / nums[i];
    }

    *returnSize = numsSize;
    return answer;
}

```

`Line 16: Char 29: runtime error: division by zero [solution.c]`把我拉回了现实：只要有个0，这段代码全线崩盘，而且根本没有修改的余地，故舍弃此方法。





```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */
int* productExceptSelf(int* nums, int numsSize, int* returnSize)
{
    //除自身的乘积的的值 等于 左乘积 *  右乘积
    int leftPro[numsSize];
    int rightPro[numsSize];

    //左乘积
    leftPro[0] = 1;
    for(int i = 1; i < numsSize; i++)
    {
        leftPro[i] =  leftPro[i-1] *  nums[i-1];
    }



    //右乘积
    rightPro[numsSize-1] = 1;
    for(int i = numsSize - 1 - 1; i  >= 0 ; i--)
    {
        rightPro[i] =  rightPro[i+1] *  nums[i+1];
    }

    *returnSize = numsSize;
    int * returnNums = (int *)malloc(sizeof(int) * numsSize);
    for(int i =0; i < numsSize; i++)
    {
        returnNums[i] = leftPro[i] * rightPro[i];
    }
    return returnNums;
}

```

正确的思路应该像是这样，分别求出左边和右边序列的乘积加以乘法。





后来我在评论区看到这样一种思路：

```c
/**
 * Note: The returned array must be malloced, assume caller calls free().
 */

int ra[100000];

int* productExceptSelf(int* nums, int numsSize, int* returnSize){
    for(int i = 0; i < numsSize; i++){
        ra[i] = 1;
    }

    int pre = 1, suf = 1;
    for(int i = 1; i < numsSize; i++){
        pre *= nums[i - 1];
        suf *= nums[numsSize - i];
        ra[i] *= pre;
        ra[numsSize - i - 1] *= suf;
    }
    *returnSize = numsSize;
    return ra;
}

作者：随心
链接：https://leetcode.cn/problems/product-of-array-except-self/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
```

（话说大佬都是不写注释的嘛）

这种算法的思路大致如下：

* 初始化数组`ra`的前缀和和后缀和都为1。
* 遍历数组`nums`，从第二个元素开始（下标为1）。
* 对于第`i`个元素，计算前缀和（即前面所有元素的乘积）并赋值给`pre`，计算后缀和（即后面所有元素的乘积）并赋值给`suf`。
* 将前缀和和后缀和的乘积赋值给`ra[i]`，即`ra[i] = pre * suf`。
* 将数组的长度赋值给返回值`*returnSize`，并返回动态分配的数组`ra`。



这种算法好处在于：

1. 空间利用率高：使用了一个数组`ra`来存储每个元素与其他元素乘积的结果，避免了重复计算，提高了空间利用率。

2. 计算效率高：通过计算前缀和和后缀和，减少了乘法操作的次数，提高了计算效率。

   (草怎么写得这么牛逼)

   **学到了有木有 **
