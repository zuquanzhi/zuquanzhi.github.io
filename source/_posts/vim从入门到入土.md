---
title: vim从入门到入土
tags: vim
categories: 工具
abbrlink: 25909
date: 2024-10-15 20:31:14
cover: https://www.loliapi.com/acg?24
---

首先声明我的vscode坚定拥护者身份，奈何十年老古董实在带不动，不得不重新捡起vim开始朴素（装逼）生活。
<!--more-->

## 1. 什么是 Vim？
Vim 是一个强大的文本编辑器，基于经典的 vi 编辑器。它的核心设计理念是高效编辑文本，特别适合程序员和技术用户 **(高逼格用户)**。

与大多数文本编辑器不同，Vim 的操作基于模式切换，它拥有多个操作模式，使你能够在插入、编辑、命令等操作之间快速切换。

***Vim vs Vi：Vim 是 vi 的增强版，提供了更多的功能，如多级撤销、语法高亮、扩展的脚本支持等。***

## 2. Vim 的主要模式

Vim 的操作基于不同的模式，主要有以下几种模式：
**1.普通模式 (Normal Mode)：**
```
	默认进入的模式，用于导航和操作文本。
	进入方式：启动 Vim 后默认进入，或按 Esc 回到普通模式。
	常用命令：
	h：向左移动光标。
	j：向下移动光标。
	k：向上移动光标。
	l：向右移动光标。
	dd：删除当前行。
	yy：复制当前行。
	p：在光标之后粘贴。
```
**2.插入模式 (Insert Mode)：**
```
	用于编辑文本，类似于普通文本编辑器的输入状态。
	进入方式：按 i 或 a 进入。
	退出方式：按 Esc 退出插入模式，回到普通模式。
```
**3.可视模式 (Visual Mode)：**

```
	用于选择文本块。
	进入方式：按 v 进入。
	常用操作：
	y：复制选中的文本。
	d：删除选中的文本。
	p：粘贴选中的文本。
```
**4.命令行模式 (Command-Line Mode)：**

```
	用于执行命令，如保存、退出、查找等。
	进入方式：按 : 进入。
	常用命令：
	:w：保存文件。
	:q：退出文件。
	:wq：保存并退出。
	:q!：强制退出（不保存修改）。
```
## 3. 基本操作指南

### 3.1 移动光标

Vim 的基本光标移动是基于 h、j、k、l 四个键，可以用来代替方向键。此外，Vim 提供了更多强大的导航功能：

	w：跳转到下一个单词的开头。
	b：跳转到上一个单词的开头。
	gg：跳转到文件开头。
	G：跳转到文件末尾。
	Ctrl + f：向下翻页。
	Ctrl + b：向上翻页。

### 3.2 插入和编辑文本

在普通模式下，通过按以下键进入插入模式以编辑文本：

	i：在光标前插入文本。
	I：在当前行的行首插入文本。
	a：在光标后插入文本。
	A：在当前行的行尾插入文本。
	o：在光标下方新建一行并插入。
	O：在光标上方新建一行并插入。

### 3.3 删除文本
```
x：删除光标所在的字符。
dd：删除当前行。
d + 移动命令：根据移动命令删除内容，例如 dw 删除到下一个单词开头，d$ 删除到行尾。
```
### 3.4 复制和粘贴
```
yy：复制当前行。
y + 移动命令：复制指定范围的内容，例如 yw 复制到下一个单词开头。
p：在光标后粘贴内容。
P：在光标前粘贴内容。
```
### 3.5 撤销和重做
```
u：撤销上一步操作。
Ctrl + r：重做撤销的操作。
```
## 4. Vim 高级操作

### 4.1 查找和替换

Vim 提供了强大的查找和替换功能：
```
	/pattern：向前查找 pattern。
	?pattern：向后查找 pattern。
	n：跳转到下一个匹配项。
	N：跳转到上一个匹配项。
	:s/old/new/g：将当前行中的 old 替换为 new。
	:%s/old/new/g：将整个文件中的 old 替换为 new。
```
### 4.2 多文件和窗口操作
```
	:e filename：打开一个新文件。
	:vsp filename：垂直分屏打开文件。
	:sp filename：水平分屏打开文件。
	Ctrl + w + h/j/k/l：在不同窗口间切换。
```
### 4.3 宏录制与回放

Vim 支持录制操作的宏，可以将常用操作记录下来并反复执行：
```
	q + 字母：开始录制宏到指定的字母键（如 q a 开始录制到 a）。
	执行所需操作。
	q：停止录制。
	@a：回放录制的宏 a。
```
## 5. Vim 的配置

Vim 可以通过编辑 .vimrc 文件进行自定义，这个文件通常位于用户的主目录下。通过编辑 .vimrc，你可以为 Vim 添加一些个性化的配置，以提高编辑效率。以下是一些常用配置选项：
```
set number        " 显示行号
set tabstop=4     " 设置 Tab 键宽度为 4 个空格
set shiftwidth=4  " 设置自动缩进为 4 个空格
set expandtab     " 将 Tab 转换为空格
set cursorline    " 高亮当前行
syntax on         " 启用语法高亮
set relativenumber " 显示相对行号
```
## 6. 常用 Vim 插件

Vim 的强大之处还在于其插件支持，可以通过插件扩展其功能。以下是一些常用的 Vim 插件：
1. NerdTree：文件浏览器插件，允许你在 Vim 中以树状结构浏览文件。
2. Vim-Airline：美化状态栏，提供更丰富的状态信息。
3. Fzf：强大的文件搜索工具，能够快速定位和打开文件。
4. YouCompleteMe：代码自动补全插件，支持多种编程语言的补全。
5. Syntastic：语法检查工具，能够帮助你及时发现代码中的错误。

可以通过 Vim 的插件管理工具（如 Vundle 或 Pathogen）来安装和管理这些插件。

## 7. 如何退出 Vim

退出 Vim 是初学者经常遇到的问题。以下是几种退出方式：
```
:q：退出（无修改时）。
:wq 或 ZZ：保存并退出。
:q!：强制退出（不保存修改）。
:wq!：强制保存并退出。
```


掌握了这些内容基本就足够在服务器终端上大展身手了，网上有很多大佬开发了各种各样的vim插件（说实话vim的最终解就是vscode），以后可能会继续更新这些插件配置相关内容