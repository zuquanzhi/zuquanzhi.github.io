---
title: screen命令应用
tags: 命令
categories: 工具
cover: 'https://www.loliapi.com/acg?13'
abbrlink: 60232
date: 2024-09-18 23:42:35
---
`screen` 是一个非常强大的终端会话管理工具，它可以让你在多个终端窗口中运行任务，并在会话断开后继续保持任务的执行状态。特别适合长时间运行的任务或远程连接的任务管理。
对于远程服务器player简直是屠龙宝刀。

### 常见用法：
以下是一些常见的 `screen` 命令和用法：

#### 1. **启动新的 `screen` 会话**
```bash
screen
```
- 启动一个新的 `screen` 会话。在新窗口中，你可以运行任何命令。
- 默认情况下，`screen` 会自动分配一个会话 ID。

#### 2. **启动带名称的 `screen` 会话**
```bash
screen -S session_name
```
- 通过 `-S` 选项为会话指定名称 `session_name`，便于管理多个会话。

#### 3. **分离（Detach）会话**
```bash
Ctrl + A + D
```
- 使用快捷键 `Ctrl + A + D`，可以将当前会话暂时分离（detach），但命令仍会继续在后台执行。

#### 4. **恢复（Reattach）已分离的会话**
```bash
screen -r
```
- 恢复上一个分离的 `screen` 会话。

#### 5. **查看现有 `screen` 会话**
```bash
screen -ls
```
- 列出当前所有的 `screen` 会话，包括那些分离的会话。例如：
  ```
  There are screens on:
      1234.session_name    (Detached)
      5678.pts-0.hostname  (Attached)
  ```

#### 6. **恢复指定的会话**
```bash
screen -r session_name
```
- 恢复名为 `session_name` 的会话。你可以通过 `screen -ls` 查看到所有会话名称。

#### 7. **杀掉 `screen` 会话**
```bash
screen -X -S session_name quit
```
- `-S session_name` 指定会话名，`-X quit` 用于杀掉该会话。

#### 8. **在会话中分屏操作**
- **水平分屏：**
  ```bash
  Ctrl + A + S
  ```
  然后使用 `Ctrl + A + Tab` 来在不同的屏幕之间切换。

- **垂直分屏：**
  ```bash
  Ctrl + A + |  # 使用 | 进行垂直分屏
  ```

- **关闭分屏：**
  将光标聚焦到需要关闭的分屏窗口中，使用命令：
  ```bash
  Ctrl + A + X
  ```

#### 9. **退出 `screen` 会话**
在会话窗口中直接输入 `exit`，或在分屏中通过 `Ctrl + A + X` 来关闭。

---
