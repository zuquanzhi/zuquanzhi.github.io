---
title: 树莓派配合公网服务器frp转发实现内网穿透
tags:
  - frp转发
  - 树莓派
  - 内网穿透
categories: 工具
cover: 'https://www.loliapi.com/acg?245'
abbrlink: 14348
date: 2025-02-23 00:16:45
---
相信不少的同学都遇到过一个很麻烦的事情——实验室用的服务器只有连上实验室的内网后才能使用，一旦外出开impart或者回家后，就不能进入实验室的服务器继续玩耍（卷）了。这个时候怎么办呢？
如果你没有一个公网服务器又不想花钱，cpolar是你的最佳选择，但是如果你有事情就变得完全不一样了——**frp的优雅永不过时**。
- [FRP 项目官网](https://gofrp.org/)
- [GitHub 仓库](https://github.com/fatedier/frp)
- [项目文档](https://gofrp.org/docs/)

### frp是什么？
frp 是一个专注于内网穿透的高性能的反向代理应用，支持 TCP、UDP、HTTP、HTTPS 等多种协议。可以将内网服务以安全、便捷的方式通过具有公网 IP 节点的中转暴露到公网。

### 为什么使用 frp ？
通过在具有公网 IP 的节点上部署 frp 服务端，可以轻松地将内网服务穿透到公网，同时提供诸多专业的功能特性，这包括：

- 客户端服务端通信支持 TCP、KCP 以及 Websocket 等多种协议。
- 采用 TCP 连接流式复用，在单个连接间承载更多请求，节省连接建立时间。
- 代理组间的负载均衡。
- 端口复用，多个服务通过同一个服务端端口暴露。
- 多个原生支持的客户端插件（静态文件查看，HTTP、SOCK5 代理等），便于独立使用 frp 客户端完成某些工作。
- 高度扩展性的服务端插件系统，方便结合自身需求进行功能扩展。
- 服务端和客户端 UI 页面。
## 食材
为了达到这个目的，在硬件上，我们的读者需要准备如下三件东西：

一台公网服务器，它的 IP 可以在任何能上网的机器上被 ping 到。
一台实验室服务器，它只能在实验室内网被访问。
一台你自己的电脑，它能 ping 到公网服务器，但是当你带着它出去玩时，它无法 ping 到实验室服务器。

## 服务端
### 安装
我们记我们的公网服务器为 `pub` (public server)，实验室服务器为 `loc` (local server)。我们在 pub 和 loc 上同时下载对应操作系统和芯片指令集的[编译版本](https://github.com/fatedier/frp/releases)：

不过考虑到大部分的服务器都是 x86 芯片的 linux，所以可以直接下载解压如下：

```
wget -c https://github.com/fatedier/frp/releases/download/v0.55.1/frp_0.55.1_linux_amd64.tar.gz
tar -xvf frp_0.55.1_linux_amd64.tar.gz
```
进入 frp_0.55.1_linux_amd64 后，我们会看到如下几个文件：

- frpc： frp 客户端执行程序
- frpc.toml：frp 客户端配置文件
- frps：frp 服务端执行程序
- frps.toml：frp 服务端配置文件
- LICENSE：frp 软件开源协议，不用管
![从锦恢大佬那里偷的图](image.png)

### 配置
为了让我们可以在外部能够访问 `loc`，我们先来实现 SSH 协议的内网穿透。
首先在 `pub` 上，进入解压后的 `frp` 文件夹。修改 `frps.toml` 如下：
```
bindPort = 7000
```
bindPort 用于和 frpc 进行绑定。   
在后台执行如下指令：
```
./frps -c ./frps.toml
```
输出如下日志，代表 frps 启动成功：
```
2024-03-20 22:56:58.972 [I] [frps/root.go:105] frps uses config file: ./frps.toml
2024-03-20 22:56:59.041 [I] [server/service.go:225] frps tcp listen on 0.0.0.0:7000
2024-03-20 22:56:59.041 [I] [server/service.go:292] http service listen on 0.0.0.0:8080
2024-03-20 22:56:59.041 [I] [frps/root.go:114] frps started successfully
2024-03-20 22:57:12.775 [I] [server/service.go:563] [11abba605bc7fe77] client login info: ip [58.211.218.74:64089] version [0.55.1] hostname [] os [linux] arch [amd64]
2024-03-20 22:57:12.806 [I] [proxy/tcp.go:82] [11abba605bc7fe77] [ssh] tcp proxy listen port [7001]
2024-03-20 22:57:12.806 [I] [server/control.go:401] [11abba605bc7fe77] new proxy [ssh] type [tcp] success
```
## 客户端
### 安装
下载适用于树莓派的arm64架构的frp文件包：
```
sudo wget https://github.com/fatedier/frp/releases/download/v0.35.1/frp_0.35.1_linux_arm64.tar.gz
sudo tar -zxvf frp_0.35.1_linux_arm64.tar.gz
# 文件名可能会有不同，用ls -a命令查看
```
编辑其中的frpc.ini文件：
```
[common]
server_addr = 127.0.0.1
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000
```
按如下参数说明修改配置文件：

- server_addr：服务器的IP地址；

- server_port：服务器端的端口，与服务端配置文件的bind_port端口相同；

- local_ip：要在公网访问的本地设备的地址，这里指客户端本机，填127.0.0.1即可；

- local_port：本地设备要暴露的端口，即理解为提供服务的端口

- remote_port：在外网的访问端口，此端口上的流量会被转发到本地设备对应的local_port端口上

**还有别忘了在服务器防火墙上放行remote_port端口**

配置文件中默认有一个ssh的访问配置，如果我们还想让其他的端口在外网访问到，那就可以照猫画虎来添加一个配置。比如在外网用公网ip的8888端口访问本地设备的80端口，就可以这样写：
```
[http]                  # 名字自定，写在方括号里面
type = tcp
local_ip = 127.0.0.1
local_port = 80
remote_port = 8888
```
然后启动服务
```
./frps -c ./frps.ini
```
大功告成。
## 连接

以上配置完成，就可以在外网访问本地的服务了，访问方式是：服务器的IP地址/域名:端口。此处端口为客户端配置文件中的remote_port端口。
（如果想挂在后台或者开机自启动可以写个小脚本或者挂在终端工具上（如sceen），这里就不细说了。）

## 参考资料
- https://kirigaya.cn/blog/article?seq=192
- https://www.wlplove.com/archives/33/#1.%E5%9C%A8%E6%9C%8D%E5%8A%A1%E7%AB%AF%E9%83%A8%E7%BD%B2frp