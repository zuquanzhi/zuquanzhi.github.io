---
title: cpolar实现内网穿透
categories: 工具
tags:
  - cpolar
  - 内网穿透
cover: 'https://www.loliapi.com/acg?34'
abbrlink: 63383
date: 2025-09-17 18:30:30
---
对于某些经常喜欢在宿舍干实验室活又没钱开公网的家伙比较有用，下面以ubuntu为例

<h2 id="4d2ac073"><font style="color:rgb(10, 10, 10);">1. 安装cpolar内网穿透</font></h2>
<h3 id="c1c09284"><font style="color:rgb(17, 17, 17);">1.1 安装cpolar</font></h3>
<font style="color:rgb(12, 12, 12);">在Ubuntu上打开终端，执行命令</font>

<font style="color:rgb(12, 12, 12);">首先，我们需要安装curl：</font>

```cpp
sudo apt-get install curl
```

+ <font style="color:rgb(12, 12, 12);">国内安装（支持一键自动安装脚本）</font>

```cpp
curl -L https://www.cpolar.com/static/downloads/install-release-cpolar.sh | sudo bash 
```



![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104110-65e35921-4f0d-4537-ba93-ad39f02a92f0.png)

<font style="color:rgb(12, 12, 12);">安装成功，如下界面所示</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722103770-e40612a5-12a5-4a56-b2ef-6f0d1d8bbf9e.png)

+ <font style="color:rgb(12, 12, 12);">或国外安装使用，通过短连接安装方式</font>

```cpp
curl -sL https://git.io/cpolar | sudo 
```

<h3 id="457383a7"><font style="color:rgb(17, 17, 17);">1.2 正常显示版本号即安装成功</font></h3>
```cpp
cpolar version
```



![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722103744-f2c58c68-f1cb-4b14-a0b8-a24769bf1d47.png)

<h3 id="6c3524a2"><font style="color:rgb(17, 17, 17);">1.3 token认证</font></h3>
<font style="color:rgb(12, 12, 12);">登录</font>[<font style="color:rgb(12, 12, 12);">cpolar官网后台</font>](https://dashboard.cpolar.com/get-started)<font style="color:rgb(12, 12, 12);">，点击左侧的验证，查看自己的认证token，之后将token贴在命令行里</font>

```cpp
cpolar authtoken xxxxxxx
```



![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104829-5d90b361-8725-40d6-8865-e53ffc4cefef.png)

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104320-06e6b152-a413-4ce8-b718-8a8e24a59f0e.png)

<h3 id="0b53538d"><font style="color:rgb(17, 17, 17);">1.4 简单穿透测试一下</font></h3>
```cpp
cpolar http 8080
```



![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104385-08d9d5b3-e70c-4bd6-a69c-264f2777734d.png)

_<font style="color:rgb(12, 12, 12);">可以看到有正常生成相应的公网地址，测试穿透本地8080端口成功，按</font>_`_<font style="color:rgb(32, 128, 173);">Ctrl+C</font>_`_<font style="color:rgb(12, 12, 12);">返回</font>_

<h3 id="7e27ba31"><font style="color:rgb(17, 17, 17);">1.5 将cpolar配置为后台服务并开机自启动</font></h3>
```cpp
sudo systemctl enable cpolar
```



![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104827-aafc06ae-9ab5-489a-be32-539e342aa4a1.png)

<h3 id="cd209ac1"><font style="color:rgb(17, 17, 17);">1.6 启动服务</font></h3>
```cpp
sudo systemctl start cpolar
```



![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104919-8bdccfb1-0034-44d9-82a4-ed85c452d81a.png)

<h3 id="2a5b214c"><font style="color:rgb(17, 17, 17);">1.7 查看服务状态</font></h3>
```cpp
sudo systemctl status cpolar
```



<font style="color:rgb(12, 12, 12);">正常显示为</font>`<font style="color:rgb(32, 128, 173);">active</font>`<font style="color:rgb(12, 12, 12);">，为正常在线状态</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722104935-03de3dd3-7983-4a92-8d75-3d75a306c0b7.png)

<h3 id="63783964"><font style="color:rgb(17, 17, 17);">1.8 登录cpolar Web UI管理界面</font></h3>
<font style="color:rgb(12, 12, 12);">在浏览器上访问本地9200端口，【</font>[<font style="color:rgb(12, 12, 12);">127.0.0.1:9200</font>](https://www.cpolar.com/blog/127.0.0.1:9200)<font style="color:rgb(12, 12, 12);">】使用cpolar邮箱账号登录cpolar Web UI管理界面</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722105461-2f3c48fd-4601-4889-8861-7c41c103b8cc.png)

<font style="color:rgb(12, 12, 12);">登陆成功,接下来就可以在Web UI界面创建隧道、编辑隧道、配置隧道、获取生成的公网地址，查看系统状态等操作了。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722105544-76fe56ce-5421-4af4-998b-836a4cef4eef.png)

<h2 id="ux2f9">2.公网ssh访问</h2>
<font style="color:rgb(12, 12, 12);">我们在Ubuntu系统下登录cpolar，在cpolar的Web-UI界面左侧找到“隧道管理”项，在下拉菜单中点击“创建隧道”。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722306629-7889ad20-7467-4ff0-aef3-298644b6d627.png)

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722307017-b787ec76-668f-42ad-9c80-d7adf11c481f.png)

<font style="color:rgb(12, 12, 12);">这里我们需要对TCP隧道进行一些调整和设置：</font>

+ <font style="color:rgb(12, 12, 12);">对建立的TCP隧道进行命名，这里我们将隧道名称写为ssh（名称可自定义）；</font>
+ <font style="color:rgb(12, 12, 12);">数据协议选择“TCP”协议；</font>
+ <font style="color:rgb(12, 12, 12);">本地地址为端口22；</font>
+ <font style="color:rgb(12, 12, 12);">端口类型为可选择“临时TCP端口”。</font>

<font style="color:rgb(12, 12, 12);">在相关信息填写完毕后，即可点击下方的“创建”按钮，建立新的SSH隧道。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722306925-92107dd3-0521-4ff3-af2b-150665e901cf.png)

<font style="color:rgb(12, 12, 12);">在SSH隧道创建成功后，我们转回“在线隧道列表”界面，查看我们刚建立起的数据隧道相关信息。在这里，我们需要复制一段连接信息：“1.tcp.cpolar.io:XXXXX（XXXXX为数字端口号，每个隧道号码均不相同，前缀tcp://不必复制）”。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722307173-7b0d76df-5ff9-418d-8207-1a4a1d988d43.png)

<font style="color:rgb(12, 12, 12);">再将这段链接信息粘贴到其他系统的命令行界面，对应的命令为：</font>

```cpp
ssh -p XXXXX 用户名@1.tcp.cpolar.io
```

<font style="color:rgb(12, 12, 12);">（其中，X为cpolar生成的端口号，用户名需替换为主机用户名）。需要注意的是，在数字端口号之前，一定要添加“（空格）-p（空格）”，否则无法连接隧道；其次是“ssh -p XXXXX 用户名@”之后，必须输入复制客户端生成的tcp地址。</font>

<font style="color:rgb(12, 12, 12);">在输入正确的连接命令后，会出现两个提示信息，一是确认Ubuntu系统的连接提示信息，我们只要输入“yes”即可；二是要求输入Ubuntu系统密码（如果Ubuntu设置了密码）。</font>

![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1730722307116-a82242af-a6f6-4e8e-86ee-28787498665c.png)

<font style="color:rgb(12, 12, 12);">在vscode里同理</font>

