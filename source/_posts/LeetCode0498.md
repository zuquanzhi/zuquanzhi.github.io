---
title: LeetCode0498
tags: 二维数组
categories: 题解
abbrlink: 3448
date: 2023-11-23 18:27:43
---

# [对角线遍历](https://leetcode.cn/problems/diagonal-traverse/)

## 题目描述

给你一个大小为 `m x n` 的矩阵 `mat` ，请以对角线遍历的顺序，用一个数组返回这个矩阵中的所有元素。

<!--more-->

 

**示例 1：**

![img](https://assets.leetcode.com/uploads/2021/04/10/diag1-grid.jpg)

```
输入：mat = [[1,2,3],[4,5,6],[7,8,9]]
输出：[1,2,4,7,5,3,6,8,9]
```

**示例 2：**

```
输入：mat = [[1,2],[3,4]]
输出：[1,2,3,4]
```

 

**提示：**

- `m == mat.length`
- `n == mat[i].length`
- `1 <= m, n <= 104`
- `1 <= m * n <= 104`
- `-105 <= mat[i][j] <= 105`



## 基本思路

根据题目要求，矩阵按照对角线进行遍历。设矩阵的行数为 m, 矩阵的列数为 n, 我们仔细观察对角线遍历的规律可以得到如下信息:

<img src="C:\Users\祖全之\AppData\Roaming\Typora\typora-user-images\image-20231123183323953.png" alt="image-20231123183323953" style="zoom:80%;" />

**根据以上观察得出的结论，我们直接模拟遍历所有的对角线即可。**



代码实现如下：

```c
int* findDiagonalOrder(int** mat, int matSize, int* matnSize, int* returnSize) {
    int m = matSize;
    int n = matnSize[0];
    int *res = (int *)malloc(sizeof(int) * m * n);
    int pos = 0;

    // 遍历矩阵的所有对角线
    for (int i = 0; i < m + n - 1; i++) {
        // 如果对角线序号为奇数
        if (i % 2) {
            int x = i < n ? 0 : i - n + 1;
            int y = i < n ? i : n - 1;

            // 遍历当前对角线并将元素存入结果数组
            while (x < m && y >= 0) {
                res[pos] = mat[x][y];
                pos++;
                x++;
                y--;
            }
        }else { // 如果对角线序号为偶数
            int x = i < m ? i : m - 1;
            int y = i < m ? 0 : i - m + 1;

            // 遍历当前对角线并将元素存入结果数组
            while (x >= 0 && y < n) {
                res[pos] = mat[x][y];
                pos++;
                x--;
                y++;
            }
        }
    }

    // 设置返回的数组大小
    *returnSize = m * n;

    return res;
}
```

*一看就会一做就废系列*

大体上把情况分为两种：奇数和偶数对角线——这两种对角线也代表着不同的遍历顺序（从下到上or从上到下）

一边遍历一边把得到元素存到res数组里，得到新数组，及完成任务。
