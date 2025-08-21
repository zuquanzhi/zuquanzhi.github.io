---
title: nth_element函数深入
tags: STL
categories: 数据结构与算法
cover: 'https://www.loliapi.com/acg?29'
abbrlink: 47436
date: 2024-10-02 22:48:02
---
`nth_element` 是 C++ 标准模板库 (STL) 中的一个非常有用的算法，它的功能是对范围内的元素进行部分排序，使得第 `n` 小的元素排到指定位置，其前面的元素都小于等于它，后面的元素都大于等于它，但前后的元素不一定是完全排序的。

`nth_element` 算法基于[快速排序](http://blog.zuquanzhi.top/2024/10/02/快排/)，时间复杂度在平均情况下是 O(n)，最坏情况是 O(n^2)，但通过随机化选取枢轴可以避免最坏情况的频繁发生。

### 函数原型
```cpp
template<class RandomIt>
void nth_element(RandomIt first, RandomIt nth, RandomIt last);

template<class RandomIt, class Compare>
void nth_element(RandomIt first, RandomIt nth, RandomIt last, Compare comp);
```

- `first`: 范围的起始迭代器。
- `nth`: 指定要找到的第 n 小元素的迭代器。
- `last`: 范围的结束迭代器（不包括 `last` 指向的元素）。
- `comp`: 可选的自定义比较器，用于自定义排序规则。

### `nth_element` 的核心特点
- 部分排序：`nth_element` 不会对整个数组进行完全排序，而只会确保第 `n` 小的元素排到第 `n` 位。
- 前后区间无序：在 `nth_element` 之后，`[first, nth)` 中的元素只会比 `*nth` 小，`[nth+1, last)` 中的元素比 `*nth` 大，但这些子区间并不会是有序的。

### 用法示例

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    std::vector<int> vec = {10, 4, 8, 2, 6, 1, 9, 3, 5, 7};

    // 找到第5小的元素，并确保它位于vec[4]
    std::nth_element(vec.begin(), vec.begin() + 4, vec.end());

    std::cout << "第5小的元素是：" << vec[4] << std::endl;

    std::cout << "前面的元素：";
    for (auto it = vec.begin(); it != vec.begin() + 4; ++it) {
        std::cout << *it << " ";
    }
    std::cout << std::endl;

    std::cout << "后面的元素：";
    for (auto it = vec.begin() + 5; it != vec.end(); ++it) {
        std::cout << *it << " ";
    }
    std::cout << std::endl;

    return 0;
}
```

输出：
```
第5小的元素是：5
前面的元素：1 2 4 3 
后面的元素：10 7 9 8 6 
```

在这个示例中，`nth_element` 保证 `vec[4]` 是第 5 小的元素（因为从 0 开始计数），并且前 4 个元素小于等于 5，后面的元素大于等于 5，但前后部分的元素是无序的。

### `nth_element` 的应用场景
1. **Top K 问题**：你可以用 `nth_element` 来高效找到数组中前 K 大（或前 K 小）元素，而不需要对整个数组排序。
2. **中位数查找**：用 `nth_element` 可以高效找到无序数组中的中位数，避免排序的 O(n log n) 时间开销。
3. **数据过滤**：可以用 `nth_element` 来过滤掉过大或过小的元素，只保留前面或后面的一部分。

### `nth_element` 与完整排序的对比
相比 `std::sort` 或 `std::partial_sort`，`nth_element` 只确保第 `n` 小的元素在正确位置，并且左右部分并不保证是有序的。这使得它在需要部分排序的场景下更加高效。

### 实现原理

`nth_element` 实际上是基于快速选择 (Quickselect) 算法的变种。它采用与快速排序类似的分区策略，只不过在每次分区后，它仅处理包含第 `n` 小元素的那一部分。这使得它比对整个数组进行完全排序更快。

1. 选取一个枢轴元素，并将比它小的元素放到左边，大的放到右边。
2. 如果 `n` 恰好是枢轴的位置，则排序结束。
3. 如果 `n` 小于枢轴的位置，则递归处理左半部分；如果 `n` 大于枢轴的位置，则递归处理右半部分。

### 自定义比较器

可以通过自定义比较器改变 `nth_element` 的排序规则。例如，按照降序排列：

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    std::vector<int> vec = {10, 4, 8, 2, 6, 1, 9, 3, 5, 7};

    // 自定义比较器：从大到小排序
    std::nth_element(vec.begin(), vec.begin() + 4, vec.end(), std::greater<int>());

    std::cout << "第5大的元素是：" << vec[4] << std::endl;
    return 0;
}
```