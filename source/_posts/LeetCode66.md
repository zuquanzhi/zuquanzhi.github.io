---
title: LeetCode66
tags: 数组
categories: 题解
abbrlink: 51941
date: 2023-11-19 14:05:27
---

# [加一](https://leetcode.cn/problems/plus-one/)

---

## 题目描述

给定一个由 **整数** 组成的 **非空** 数组所表示的非负整数，在该数的基础上加一。

最高位数字存放在数组的首位， 数组中每个元素只存储**单个**数字。

你可以假设除了整数 0 之外，这个整数不会以零开头。

<!--more-->

 

**示例 1：**

```
输入：digits = [1,2,3]
输出：[1,2,4]
解释：输入数组表示数字 123。
```

**示例 2：**

```
输入：digits = [4,3,2,1]
输出：[4,3,2,2]
解释：输入数组表示数字 4321。
```

**示例 3：**

```
输入：digits = [0]
输出：[1]
```

 

**提示：**

- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`

## 代码实现



```c
int* plusOne(int* digits, int digitsSize, int* returnSize) {
    // 从数组的最后一位开始向前加一
    for (int i = digitsSize - 1; i >= 0; i--) {
        if (digits[i] < 9) {
            // 当前位加一不产生进位，直接返回数组
            digits[i]++;
            *returnSize = digitsSize;
            return digits;
        } else {
            // 当前位加一产生进位，将当前位设为0，继续向前一位加一
            digits[i] = 0;
        }
    }// 如果遍历完成后，最高位仍然产生进位，需要在数组最前面添加一个新的元素1
	int* result = (int*)malloc((digitsSize + 1) * sizeof(int));
	result[0] = 1;
	for (int i = 1; i <= digitsSize; i++) {
    	result[i] = digits[i - 1];
	}
	*returnSize = digitsSize + 1;
	return result;
}
```

s
