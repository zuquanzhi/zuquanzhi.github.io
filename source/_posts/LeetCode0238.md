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

这个实现非常紧凑，核心是“前缀乘积 + 后缀乘积”的双向累积。

这种算法的思路可以这样理解：

* 先把结果数组 `ra` 初始化为全 1。
* 从左到右累计前缀乘积，并更新当前位置结果。
* 同时从右到左累计后缀乘积，更新对称位置结果。
* 一次循环完成双向累积，因此时间复杂度为 $O(n)$。
* 最后设置 `*returnSize` 并返回结果数组。



这种写法的好处在于：

1. 空间开销低：除结果数组外，只使用了常数级辅助变量。

2. 计算效率高：通过双向累积避免除法，且只需线性扫描。

对于这类题，建议优先建立“位置贡献”视角：
当前位置答案 = 左侧所有数的乘积 × 右侧所有数的乘积。
