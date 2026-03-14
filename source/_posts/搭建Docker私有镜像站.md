---
title: 搭建Docker私有镜像站
tags:
  - docker
  - 镜像
  - 容器化
categories: 工具
abbrlink: 7375
date: 2025-09-17 18:44:21
cover: https://www.loliapi.com/acg?67
---

## 摘要

这篇文章给出一套可复现的 Harbor 私有镜像仓库部署流程，重点覆盖：安装、启动、登录、推送、常见报错与安全配置。适合内网团队快速落地。

## 一条可跑通的最小流程

```bash
# 1) 下载并解压 Harbor 离线安装包
wget https://github.com/goharbor/harbor/releases/download/v2.10.0/harbor-offline-installer-v2.10.0.tgz
tar -zxvf harbor-offline-installer-v2.10.0.tgz
cd harbor

# 2) 生成并编辑配置
cp harbor.yml.tmpl harbor.yml

# 3) 安装并启动
./install.sh
```

完成后访问 `http://<host>:<port>`，使用 `admin` 账号登录。

## 前置检查

```bash
docker --version
docker compose version
```

若 `docker compose` 不存在，再补装 compose 插件，避免 `docker-compose: command not found`。


[Harbor &ndash; Harbor Installation and Configuration](https://goharbor.io/docs/2.13.0/install-config/)

整体实现难度中等，核心在于把 Harbor 当作团队内部的镜像分发基础设施来维护，而不仅是一次性部署。

## 1 什么是 Docker 私有仓库

Docker 私有仓库用于存储和管理团队内部镜像。与公共仓库 Docker Hub 不同，私有仓库通常需要认证授权，适合部署在内网或受控网络环境中，用于开发、测试和生产镜像分发。

## 2 常见的 Docker 私有仓库方案

常见方案包括：

1. Harbor：企业级功能较完整，支持 RBAC、镜像复制、签名和漏洞扫描。
2. Docker Trusted Registry：Docker 官方的企业方案。
3. Portus：开源的镜像认证与管理方案。
4. Nexus Repository Manager：除容器镜像外，还能管理多种制品。
5. GitLab Container Registry：适合已经把 CI/CD 放在 GitLab 上的团队。
6. AWS ECR：适合主要运行在 AWS 上的环境。

本文选择 Harbor，因为它在自建场景下功能较全、社区成熟、资料也比较丰富。

## 3 Harbor 简介

Harbor 是一个开源的企业级容器镜像仓库，最初由 VMware 推出，后续开源并持续维护。它的定位不是单纯“存镜像”，而是把权限控制、项目隔离、安全扫描和复制策略等能力一起提供出来，更适合团队协作。

参考资料：

1. 官方文档：[Harbor Installation and Configuration](https://goharbor.io/docs/2.13.0/install-config/)
2. 源码仓库：[https://github.com/goharbor/harbor](https://github.com/goharbor/harbor)

## 4 Harbor 下载

### 4.1 通过命令下载
```plain
wget https://github.com/goharbor/harbor/releases/download/v2.10.0/harbor-offline-installer-v2.10.0.tgz
```

### 4.2 手动下载

也可以直接到发布页下载离线安装包：

[https://github.com/goharbor/harbor/releases](https://github.com/goharbor/harbor/releases)

### 4.3 解压

```plain
tar -zxvf harbor-offline-installer-v2.10.0.tgz
```

## 5 启动 Harbor

### 5.1 修改配置文件

先把 `harbor.yml.tmpl` 复制为 `harbor.yml`，再修改 `hostname`、端口和管理员密码等关键配置：

```plain
cp harbor.yml.tmpl harbor.yml #拷贝

vim harbor.yml
```

一个典型的最小配置如下：

```plain
#修改hostname的值，如果没有域名就使用本机IP地址
hostname: 192.168.1.7

#配置启动端口号
# http related config 
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 5000

# 如果没有申请证书，需要隐藏https
#https:
  # https port for harbor, default is 443
#  port: 443
  # The path of cert and key files for nginx
#  certificate: /your/certificate/path
#  private_key: /your/private/key/path

#启动成功后，admin用户登录密码
# Remember Change the admin password from UI after launching Harbor.
harbor_admin_password: AdminHarbor12345
```

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887672226-5d48f300-e744-4018-b494-3cc55009e72a.png)

## 5.2 启动 Harbor

配置文件修改完成后，执行 `./install.sh` 进行安装：

```bash
./install.sh
```

如果启动时报错，可以优先看是否缺少 compose 组件：

```text
[Step 0]: checking if docker is installed ...

Note: docker version: 26.1.3

[Step 1]: checking docker-compose is installed ...
/opt/harbor/common.sh: line 119: docker-compose: command not found
✖ Failed to parse docker-compose version.
```

从报错可以看出，当前环境缺少 `docker-compose` 或 `docker compose` 兼容能力。

## 5.3 安装 compose 组件

如果你的 Harbor 安装脚本依赖传统的 `docker-compose` 可执行文件，可以按下面方式安装：

```bash
cp docker-compose-linux-x86_64 /usr/local/bin/
```

重命名：

```bash
mv docker-compose-linux-x86_64 docker-compose
```

授权：

```bash
chmod +x /usr/local/bin/docker-compose
```

检查是否安装成功：

```bash
docker-compose --version
```

如果需要卸载，直接删除即可：

```bash
rm -f /usr/bin/docker-compose
```

## 5.4 再次启动

再次执行：

```bash
./install.sh
```

安装成功后，访问 `192.168.1.7:5000` 即可进入 Harbor。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887524392-a8babaab-f73e-4c9e-a606-8b41a41620a9.png)

如果首页能够正常打开，说明私有仓库已经部署成功。

## 6 Harbor Web 页面

默认用户名是 `admin`，密码以 `harbor.yml` 中的 `harbor_admin_password` 为准。

登录成功后，首页常用的几个入口包括：项目、日志、系统管理。

### 6.1 项目

项目是 Harbor 中的基本隔离单元。你可以为不同业务或团队创建不同项目，把镜像分别存放进去。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887710628-c2d36d33-63c8-42de-a689-0836c5ad27be.png)

公开项目中的镜像对所有用户可见；私有项目则需要登录并具备相应权限后才能访问。根据你的团队协作方式选择即可。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887725468-c6afde0b-24a4-4004-84dc-5ff44bfff990.png)

项目创建完成后，可以继续配置成员、权限、复制策略等信息。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887888761-3c1d162f-1f40-40a7-a10d-bb09ede9461d.png)

角色权限说明：

- 项目管理员（Project Administrator）：拥有项目最高权限，适合负责仓库治理、成员管理和策略配置的人。
- 维护人员（Maintainer）：可以协助维护镜像、复制规则和部分项目设置，但权限低于项目管理员。
- 开发者（Developer）：适合日常推送和拉取镜像的研发角色，具备读写权限。
- 访客（Guest）：只读访问，适合需要查看镜像但不参与维护的成员。
- 受限访客（Restricted Guest）：权限比访客更小，通常用于对外部协作方做最小权限开放。

右上角通常会直接给出推送命令，可以按提示把本地镜像推送到对应项目。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887750856-cf536081-6d18-466b-89bc-e548677de0de.png)

### 6.2 日志

日志页面用于查看用户操作记录，便于审计和排查问题。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887807171-0f832730-5888-44c8-b68e-61bc93271bfb.png)

### 6.3 系统管理

系统管理主要负责用户、权限、仓库配置和系统级参数维护。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887795137-edf4b00f-b495-4a2c-93ca-c0bd54a8566b.png)

## 7 Docker 命令使用私有仓库

### 7.1 登录

首先登录私有仓库地址：

```bash
echo 'AdminHarbor12345' | docker login 192.168.1.7:5000 -u admin --password-stdin
```

若登录失败，常见报错示例如下：

```text
Error response from daemon: Get "https://192.168.1.7:5000/v2/": proxyconnect tcp: dial tcp 192.168.65.7:3128: connect: connection refused
```

这类错误通常由两类原因触发：代理配置干扰，或私有仓库未加入信任列表。可在 Docker 守护进程配置中加入仓库地址，并检查代理设置。

```json
{
  "registry-mirrors": ["https://ejes884z.mirror.aliyuncs.com"],
  "log-driver":"json-file",
  "log-opts": {"max-size":"1g", "max-file":"3"},
  "live-restore": true,
  "insecure-registries": ["192.168.1.7:5000"]
}

# insecure-registries 不安全的注册表配置一些不安全的地址信息，让Docker认为是安全的。多个地址使用 "," 分割
```

加入配置成功后，再次登录。

```text
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

登录成功后，认证信息会存储在 `~/.docker/config.json` 中。只要登录信息有效，后续推送和拉取通常不需要重复登录。

### 7.2 推送

先重新标记本地镜像：

```bash
docker tag 94543a6c1aef 192.168.1.7:5000/blog_project/nginx:1.26.0
```

再推送到 Harbor：

```bash
docker push 192.168.1.7:5000/blog_project/nginx:1.26.0
```

推送完成后，可以在 Harbor 页面中确认镜像是否已上传成功。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887844513-431188a8-de89-4ea7-9c28-53077ae43235.png)

### 7.3 拉取

在另一台服务器上，可以直接从私有仓库拉取镜像：

```bash
docker pull 192.168.1.7:5000/blog_project/nginx:1.26.0
```

拉取成功后，可用 `docker images` 再次确认。

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887025819-15347766-b057-429c-86d4-6272efc29bc2.png)

如果 Harbor 页面中的下载次数发生变化，说明拉取记录已经被统计到。

如果这台机器同样是首次访问该仓库，也要提前把 `192.168.1.7:5000` 加入 Docker 的 `insecure-registries`，否则拉取阶段也可能因为证书校验失败而报错。

