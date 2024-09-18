---
title: c语言中正则匹配的几种思路
tags: 正则匹配
categories: 编程
abbrlink: 15536
date: 2023-10-12 22:00:19
---
# 关于正则匹配的几种思路
注意：所谓正则表达指一整个字符串，而部分字符串   
下面来看这样一个实例：   
**写出一个程序，当输入“yuanshen”的时候，输出为“yes”；输入“no”的时候，输出为“no”**
<!-- more -->


输入示例：
``````bash
yuanshen
``````
输出示例：
``````bash
yes
``````
---
输入示例：
``````bash
qidong
``````
输出示例：
``````bash
no
``````
---
输入示例：
``````bash
balaba
``````
输出示例：
``````bash
Error
``````


## 思路一：无脑匹配

``````bash
#include <stdio.h>

int main() {
    char ans[10];
    int i = 0;
    while (i < 9) {
        char c;
        scanf("%c", &c);
        if (c == '\n')
            break;
        ans[i] = c;
        i++;
    }
    ans[i] = '\0';
    if (i >= 2 && ans[0] == 'y' && 
    ans[1] == 'u'&&ans[2] == 'a'&&ans[3] == 'n'&&ans[4] == 's'&&
    ans[5] == 'h'&&ans[6] == 'e'&&ans[7] == 'n') {
        printf("Yes\n");
    } elif (i >= 2 && ans[0] == 'q' && 
    ans[1] == 'i'&&ans[2] == 'd'&&ans[3] == 'o'&&ans[4] == 'n'&&
    ans[5] == 'g'){
        printf("No\n");
    }
    else{
        printf("Error");
    }
    return 0;
}
``````
这种思路看来有点麻烦（蠢），但是笔者作为初学者第一反应就是这样的。   
首先创建了一个char类型数组，用while持续输入，if换行符作为结束条件，最后再加上“\0”结束输入。  
匹配阶段则是用if挨个元素匹配。
#### **总而言之，低效、麻烦而直观**


## 思路二：使用strcmp函数
``````bash
#include <stdio.h>
#include <string.h>

int main() {
    char ans[10];
    int i = 0;
    // Read characters into the array until newline or reaching array size - 1
    while (i < 9 && scanf("%c", &ans[i]) == 1 && ans[i] != '\n') {
        i++;
    }

    // Null-terminate the string
    ans[i] = '\0';

    if (strncmp(ans, "yuanshen", 2) == 0) {
        printf("Yes\n");
    }
    else if (strncmp(ans, "qidong", 2) == 0) {
        printf("No\n");
    }
    else {
        printf("Error\n");
    }

    return 0;
}
``````
思路二的输入方式与思路一大同小异，关键区别在于判断匹配的方式  
### 简单介绍一下使用到的strcmp函数：  

strcmp 函数用于比较两个字符串是否相等。它返回一个整数，用于表示比较结果。这个整数的含义如下：  
-返回值小于 0：表示第一个字符串小于第二个字符串。  
-返回值等于 0：表示两个字符串相等。  
-返回值大于 0：表示第一个字符串大于第二个字符串。
``````bash
int strcmp(const char *str1, const char *str2) {
    while (*str1 && (*str1 == *str2)) {
        str1++;
        str2++;
    }

    return *(unsigned char *)str1 - *(unsigned char *)str2;
}
``````
以上为strcmp函数的声明代码，采用指针达到字符串的匹配检测。

## 思路三：
``````bash
#include <stdio.h>
#include <string.h>

int main() {
    char ans[10];
    // Read a line of input into ans
    fgets(ans, sizeof(ans), stdin);

    // Remove newline character if present
    size_t len = strlen(ans);
    if (len > 0 && ans[len - 1] == '\n') {
        ans[len - 1] = '\0';
    }

    // Check if ans starts with "yuanshen"
    if (strncmp(ans, "yuanshen", 2) == 0) {
        printf("Yes\n");
    } else if(strncmp(ans, "qidong", 2) == 0){
        printf("No\n");
    }
    else{
        printf("Error\n");
    }

    return 0;
}
``````
代码的基本思路是：  
使用 fgets 函数读取用户输入的字符串，将其存储在名为 ans 的字符数组中，限制最大输入字符数为9。

检查读取到的字符串的长度，如果大于0且最后一个字符是换行符（'\n'），则将该换行符替换为字符串终止符（'\0'），以确保字符串正确终止。

使用 strncmp 函数比较 ans 字符串的前两个字符与预期字符串是否相等。如果相等，输出 "Yes"/“No”，
否则输出 "Error"。

（萌新勿骂）