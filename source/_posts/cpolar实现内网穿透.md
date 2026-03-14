---
title: cpolar实现内网穿透
categories: 工具
tags:
  - cpolar
  - 内网穿透
description: 使用 cpolar 在 Ubuntu 上快速暴露本地 HTTP 与 SSH 服务，并给出 Web UI 配置与安全建议。
keywords:
  - cpolar
  - 内网穿透
  - SSH
  - Ubuntu
toc: true
cover: 'https://www.loliapi.com/acg?34'
abbrlink: 63383
date: 2025-09-17 18:30:30
---
对于某些经常喜欢在宿舍干实验室活又没钱开公网的家伙比较有用，下面以ubuntu为例

## 快速上手（Ubuntu）

### 1. 安装与认证

```bash
sudo apt-get update
sudo apt-get install -y curl
curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash
cpolar version
cpolar authtoken <YOUR_TOKEN>
```

`<YOUR_TOKEN>` 可在 cpolar 控制台中获取。

### 2. 启动服务并检查状态

```bash
sudo systemctl enable cpolar
sudo systemctl start cpolar
sudo systemctl status cpolar
```

状态为 `active (running)` 说明服务正常。

### 3. HTTP 穿透测试

```bash
cpolar http 8080
```

出现公网地址后，可在外部网络直接访问该地址。测试完成使用 `Ctrl+C` 退出。

### 4. SSH 穿透测试

在 Web UI（默认 `127.0.0.1:9200`）创建 TCP 隧道，目标端口填 `22`。创建后拿到地址：

```text
1.tcp.cpolar.io:<PORT>
```

远程连接命令：

```bash
ssh -p <PORT> <USERNAME>@1.tcp.cpolar.io
```

### 5. 安全建议

1. 不要直接暴露 root 账户，优先使用普通用户 + sudo。
2. 建议启用 SSH 公钥认证，禁用弱口令。
3. 生产场景优先使用固定隧道并限制来源 IP。

## 详细步骤与界面说明

如果你是第一次接触 cpolar，下面这部分可以作为图文版说明。和前面的“快速上手”相比，这里保留更多界面截图，适合边看边做。

### 1 安装与初始化

### 1.1 安装 cpolar

在 Ubuntu 终端中先安装 curl：

```bash
sudo apt-get update
sudo apt-get install -y curl
```

国内网络一般直接使用官方安装脚本即可：

```bash
curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash
```

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104110-65e35921-4f0d-4537-ba93-ad39f02a92f0.png)

安装完成后，终端会给出成功提示。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722103770-e40612a5-12a5-4a56-b2ef-6f0d1d8bbf9e.png)

如果你使用的是另一套安装源，也可以尝试短链接脚本：

```bash
curl -sL https://git.io/cpolar | sudo bash
```

### 1.2 检查版本

```bash
cpolar version
```

能正常输出版本号，就说明客户端已经安装成功。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722103744-f2c58c68-f1cb-4b14-a0b8-a24769bf1d47.png)

### 1.3 完成 token 认证

登录 [cpolar 控制台](https://dashboard.cpolar.com/get-started)，在后台找到认证 token，然后执行：

```bash
cpolar authtoken xxxxxxx
```

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104829-5d90b361-8725-40d6-8865-e53ffc4cefef.png)

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104320-06e6b152-a413-4ce8-b718-8a8e24a59f0e.png)

认证完成后，这台机器就可以创建隧道了。

### 1.4 做一次本地 HTTP 测试

```bash
cpolar http 8080
```

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104385-08d9d5b3-e70c-4bd6-a69c-264f2777734d.png)

如果终端里出现公网访问地址，就说明本地 8080 端口已经被成功映射到公网。测试完成后按 Ctrl+C 退出即可。

### 1.5 配置后台服务与开机启动

```bash
sudo systemctl enable cpolar
sudo systemctl start cpolar
sudo systemctl status cpolar
```

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104827-aafc06ae-9ab5-489a-be32-539e342aa4a1.png)

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104919-8bdccfb1-0034-44d9-82a4-ed85c452d81a.png)

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104935-03de3dd3-7983-4a92-8d75-3d75a306c0b7.png)

状态显示为 `active (running)`，说明服务正在后台运行。

### 1.6 打开 Web UI

浏览器访问 `http://127.0.0.1:9200`，使用你的 cpolar 账号登录 Web UI。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722105461-2f3c48fd-4601-4889-8861-7c41c103b8cc.png)

登录后可以在这里创建隧道、查看在线地址、管理配置和检查运行状态。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722105544-76fe56ce-5421-4af4-998b-836a4cef4eef.png)

### 2 通过公网访问 SSH

如果你的目标是远程 SSH 到这台 Ubuntu 主机，推荐直接在 Web UI 中创建一个 TCP 隧道。

### 2.1 创建 TCP 隧道

在左侧进入“隧道管理” -> “创建隧道”。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722306629-7889ad20-7467-4ff0-aef3-298644b6d627.png)

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722307017-b787ec76-668f-42ad-9c80-d7adf11c481f.png)

这里可以按下面方式填写：

- 隧道名称：`ssh`，只是便于自己识别。
- 协议类型：选择 `TCP`。
- 本地地址：填写 `22`，也就是 SSH 默认端口。
- 端口类型：可以先用临时 TCP 端口测试。

填写完成后点击“创建”。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722306925-92107dd3-0521-4ff3-af2b-150665e901cf.png)

### 2.2 获取公网连接地址

隧道创建成功后，回到“在线隧道列表”，你会看到类似下面的地址：

```text
1.tcp.cpolar.io:XXXXX
```

其中 `XXXXX` 是本次分配到的公网端口。复制时不需要带 `tcp://` 前缀。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722307173-7b0d76df-5ff9-418d-8207-1a4a1d988d43.png)

### 2.3 从外部机器发起 SSH 连接

在另一台机器上执行：

```bash
ssh -p XXXXX 用户名@1.tcp.cpolar.io
```

这里需要注意两点：

- `-p` 后面跟的是 cpolar 分配的公网端口，不是本机的 `22`。
- `用户名` 需要替换成目标 Ubuntu 主机上的实际用户。

第一次连接时通常会先提示是否信任主机指纹，输入 `yes` 即可；随后再输入目标机器用户的密码或使用 SSH 密钥认证。

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722307116-a82242af-a6f6-4e8e-86ee-28787498665c.png)

如果你在 VS Code 的 Remote SSH 中使用，同样填这组主机名和端口即可，本质上没有区别。

### 3 使用建议

1. 临时测试可以使用随机端口，长期使用更建议配置固定隧道，避免地址频繁变化。
2. 如果要暴露的是 SSH、数据库或管理后台，优先增加账号权限控制，不要直接把高权限入口裸露到公网。
3. 远程访问链路一旦稳定，最好再补一层白名单、密钥认证或额外网关，不要只依赖隧道地址本身。

