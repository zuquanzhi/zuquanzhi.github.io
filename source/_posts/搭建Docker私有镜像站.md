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


[Harbor &ndash; Harbor Installation and Configuration](https://goharbor.io/docs/2.13.0/install-config/)

技术难度一般，因为它本身就是一个容器在跑，当成[docker.io](https://www.docker.com/)用就好。

<h3 id="cfc90029"><font style="color:rgb(25, 27, 31);">1、什么是</font>[<font style="color:rgb(9, 64, 142);">Docker私有仓库</font>](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=Docker%E7%A7%81%E6%9C%89%E4%BB%93%E5%BA%93&zhida_source=entity)<font style="color:rgb(25, 27, 31);"></font></h3>
<font style="color:rgb(25, 27, 31);">Docker私有仓库是用于存储和管理Docker镜像的私有存储库。Docker默认会有一个公共的仓库</font>[<font style="color:rgb(9, 64, 142);">Docker Hub</font>](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=Docker+Hub&zhida_source=entity)<font style="color:rgb(25, 27, 31);">，而与Docker Hub不同，私有仓库是受限访问的，只有授权用户才能够上传、下载和管理其中的镜像。这种私有仓库可以部署在本地云环境中，用于组织内部开发、测试和生产环境中的容器镜像管理。保证数据安全性。</font>

<h3 id="c74ebac1"><font style="color:rgb(25, 27, 31);">2、Docker有哪些私有仓库</font></h3>
**<font style="color:rgb(25, 27, 31);">以下是一些常见的Docker私有仓库：</font>**<font style="color:rgb(25, 27, 31);">  
</font>

+ **<font style="color:rgb(25, 27, 31);">Harbor</font>**<font style="color:rgb(25, 27, 31);">：作为一个企业级的Docker Registry服务，Harbor提供了安全、可信赖的镜像存储和管理功能。它支持RBAC权限控制、镜像复制、镜像签名、漏洞扫描等功能。</font>
+ [**<font style="color:rgb(9, 64, 142);">Docker Trusted Registry</font>**](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=Docker+Trusted+Registry&zhida_source=entity)**<font style="color:rgb(25, 27, 31);"> </font>****<font style="color:rgb(25, 27, 31);">(DTR)</font>**<font style="color:rgb(25, 27, 31);">：由Docker官方推出的企业级Docker私有仓库服务，与Docker Engine紧密集成，支持高度的安全性和可靠性。</font>
+ [**<font style="color:rgb(9, 64, 142);">Portus</font>**](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=Portus&zhida_source=entity)<font style="color:rgb(25, 27, 31);">：一个开源的Docker镜像管理和认证服务，提供用户管理、团队管理、镜像审核等功能，与Docker Registry兼容。</font>
+ **<font style="color:rgb(25, 27, 31);">Nexus Repository Manager</font>**<font style="color:rgb(25, 27, 31);">：虽然主要是用于构建和管理Java组件，但也可以用作Docker私有仓库。它具有强大的存储管理和权限控制功能。</font>
+ [**<font style="color:rgb(9, 64, 142);">GitLab Container Registry</font>**](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=GitLab+Container+Registry&zhida_source=entity)<font style="color:rgb(25, 27, 31);">：GitLab集成了容器注册表功能，允许您存储、管理和分发Docker镜像。这是GitLab自带的功能，无需额外部署。</font>
+ [**<font style="color:rgb(9, 64, 142);">AWS Elastic Container Registry</font>**](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=AWS+Elastic+Container+Registry&zhida_source=entity)**<font style="color:rgb(25, 27, 31);"> (ECR)</font>**<font style="color:rgb(25, 27, 31);">：如果使用AWS云服务，可以考虑使用AWS ECR作为私有仓库。它与AWS的其他服务集成紧密，对AWS用户来说是一个方便的选择。</font>

<font style="color:rgb(25, 27, 31);">本篇使用Harbor搭建Docker私有仓库。</font>

<h3 id="f69114e1"><font style="color:rgb(25, 27, 31);">3、Harbor简介</font></h3>
<font style="color:rgb(25, 27, 31);">Harbor是一个开源的企业级Docker Registry服务，它提供了一个安全、可信赖的仓库来存储和管理Docker镜像。Harbor翻译为中文名称为"庇护；居住;"。可以理解为是Docker镜像的"居住环境"或者是镜像的"庇护所"。Harbor最初由</font>[<font style="color:rgb(9, 64, 142);">VMware</font>](https://zhida.zhihu.com/search?content_id=245844410&content_type=Article&match_order=1&q=VMware&zhida_source=entity)<font style="color:rgb(25, 27, 31);">公司开发，旨在解决企业级Docker镜像管理的安全和可信任性问题。VMware于2016年发布，在2017年，VMware将Harbor开源，这使得更广泛的社区和组织可以自由地使用和贡献代码。Harbor是一个成熟、功能丰富且安全可靠的企业级Docker Registry服务，为企业容器化应用的部署和管理提供了强大的支持。</font>

<font style="color:rgb(25, 27, 31);"></font>

<font style="color:rgb(25, 27, 31);">Harbor官网地址：</font>[Harbor (goharbor.io)](https://link.zhihu.com/?target=https%3A//goharbor.io/)<font style="color:rgb(25, 27, 31);"></font>

<font style="color:rgb(25, 27, 31);">Github开源地址：</font>[https://github.com/goharbor/harbor](https://link.zhihu.com/?target=https%3A//github.com/goharbor/harbor)<font style="color:rgb(25, 27, 31);"></font>

<h3 id="fabbg"><font style="color:rgb(25, 27, 31);">4、Harbor下载</font></h3>
<h4 id="sa11I"><font style="color:rgb(25, 27, 31);">4.1、通过Linux命令下载</font></h4>
```plain
wget https://github.com/goharbor/harbor/releases/download/v2.10.0/harbor-offline-installer-v2.10.0.tgz
```

<h4 id="sMZzM"><font style="color:rgb(25, 27, 31);">4.2、GitHub下载</font></h4>
<font style="color:rgb(25, 27, 31);">下载地址：</font>[https://github.com/goharbor/harbor/releases](https://link.zhihu.com/?target=https%3A//github.com/goharbor/harbor/releases)<font style="color:rgb(25, 27, 31);"> 下载离线版本</font>

<h4 id="x1kRL"><font style="color:rgb(25, 27, 31);">4.3、解压</font></h4>
<font style="color:rgb(25, 27, 31);">解压文件</font>

```plain
tar -zxvf harbor-offline-installer-v2.10.0.tgz
```

<h3 id="cff1f693"><font style="color:rgb(25, 27, 31);">5、启动Harbor</font></h3>
<h4 id="aeMOB"><font style="color:rgb(25, 27, 31);">5.1、修改配置文件</font></h4>
<font style="color:rgb(25, 27, 31);">复制</font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">harbor.yml.tmpl</font>`<font style="color:rgb(25, 27, 31);"> </font><font style="color:rgb(25, 27, 31);">文件并重命名为</font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">harbor.yml</font>`<font style="color:rgb(25, 27, 31);">修改此配置文件，需要设置hostname、端口、数据库密码等。</font>

```plain
cp harbor.yml.tmpl harbor.yml #拷贝

vim harbor.yml
```

<font style="color:rgb(25, 27, 31);">修改配置文件：</font>

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

<font style="color:rgb(25, 27, 31);">  
</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887672226-5d48f300-e744-4018-b494-3cc55009e72a.png)

<font style="color:rgb(25, 27, 31);"></font>

<h4 id="lp6U4"><font style="color:rgb(25, 27, 31);">5.2、启动</font></h4>
<font style="color:rgb(25, 27, 31);">配置文件修改成功后，执行</font><font style="color:rgb(25, 27, 31);"> </font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">install.sh</font>`<font style="color:rgb(25, 27, 31);"> </font><font style="color:rgb(25, 27, 31);">脚本进行安装harbor</font>

```plain
./install.sh
```

<font style="color:rgb(25, 27, 31);">启动报错：</font>

```plain
[Step 0]: checking if docker is installed ...

Note: docker version: 26.1.3

[Step 1]: checking docker-compose is installed ...
/opt/harbor/common.sh: line 119: docker-compose: command not found
✖ Failed to parse docker-compose version.
```

<font style="color:rgb(25, 27, 31);">可以看到，该服务器安装的 </font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">docker</font>`<font style="color:rgb(25, 27, 31);"> 没有安装 </font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">docker-compose</font>`<font style="color:rgb(25, 27, 31);"> 插件</font>

<h4 id="s2Evh"><font style="color:rgb(25, 27, 31);">5.3、安装docker-compose</font></h4>
<font style="color:rgb(25, 27, 31);"></font>

<font style="color:rgb(25, 27, 31);">进入</font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">docker-compose</font>`<font style="color:rgb(25, 27, 31);"> </font><font style="color:rgb(25, 27, 31);">官网下载执行文件，地址：</font><font style="color:rgb(25, 27, 31);"> </font>[https://github.com/docker/compose](https://link.zhihu.com/?target=https%3A//github.com/docker/compose)<font style="color:rgb(25, 27, 31);"> </font><font style="color:rgb(25, 27, 31);">下载成功后，把可执行文件加入</font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">Linux</font>`<font style="color:rgb(25, 27, 31);"> </font><font style="color:rgb(25, 27, 31);">系统命令目录</font>

```plain
cp docker-compose-linux-x86_64 /usr/local/bin/
```

<font style="color:rgb(25, 27, 31);">重命名：</font>

```plain
mv docker-compose-linux-x86_64 docker-compose
```

<font style="color:rgb(25, 27, 31);">授权：</font>

```plain
chmod +x /usr/local/bin/docker-compose
```

<font style="color:rgb(25, 27, 31);">执行命令查看是否安装成功：</font>

```plain
docker-compose --version
```

<font style="color:rgb(25, 27, 31);">如果需要卸载，直接删除即可：</font>

```plain
rm -f /usr/bin/docker-compose
```

<font style="color:rgb(25, 27, 31);">  
</font>

<h4 id="rijkf"><font style="color:rgb(25, 27, 31);">5.4、再次启动</font></h4>
<font style="color:rgb(25, 27, 31);"></font>

<font style="color:rgb(25, 27, 31);">再次执行 </font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">./install.sh</font>`<font style="color:rgb(25, 27, 31);"></font>

<font style="color:rgb(25, 27, 31);">提示安装成功。接下来就可以访问Harbor了。访问IP+端口：192.168.1.7:5000  
</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887524392-a8babaab-f73e-4c9e-a606-8b41a41620a9.png)

<font style="color:rgb(25, 27, 31);">访问成功，由于Harbor是通过docker管理的，所以启动非常方便。如果首页访问成功说明Docker私有仓库已经部署成功了。</font>

<h3 id="a3896d11"><font style="color:rgb(25, 27, 31);">6、Harbor Web页面操作说明</font></h3>
<font style="color:rgb(25, 27, 31);">默认用户名是admin，密码是启动时设置的密码：</font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">herodocker</font>`

<font style="color:rgb(25, 27, 31);">登录成功进入主页面了。从系统首页可以看到系统分为三个菜单：项目、日志、系统管理。</font>

<h4 id="ICD5n"><font style="color:rgb(25, 27, 31);">6.1、项目</font></h4>
<font style="color:rgb(25, 27, 31);">项目管理顾名思义就是用来管理项目的。可以为每一个开发项目创建一个私有项目库，然后把Docker镜像存储到指定的项目中，为每个项目实现项目镜像隔离。创建项目的时候，Harbor提供了公开库（public repository）和私有库（private repository）两种类型的镜像存储空间。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887710628-c2d36d33-63c8-42de-a689-0836c5ad27be.png)

<font style="color:rgb(25, 27, 31);">通过详情信息可以看到：</font>**<font style="color:rgb(25, 27, 31);">公开库中的镜像是对所有用户可见和可访问的，任何人都可以查看和拉取其中的镜像。而私有库中的镜像则需要登录才能访问控制，只有被授权的用户或团队才能够查看、拉取和推送镜像。</font>**<font style="color:rgb(25, 27, 31);"> 可以根据需要创建相关的项目。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887725468-c6afde0b-24a4-4004-84dc-5ff44bfff990.png)

<font style="color:rgb(25, 27, 31);">项目创建成功后，可以点击进入项目。在里面可以为每个项目单独设置不同的配置信息。可以为每一个项目添加成员信息。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887888761-3c1d162f-1f40-40a7-a10d-bb09ede9461d.png)

<font style="color:rgb(25, 27, 31);"></font>

<font style="color:rgb(25, 27, 31);">角色权限说明：</font>

+ **<font style="color:rgb(25, 27, 31);">项目管理员（Project Administrator）：</font>**<font style="color:rgb(25, 27, 31);">拥有项目的最高权限，可以对项目进行全面管理，包括创建和删除项目、管理项目成员和权限、配置项目属性、查看项目日志等。</font>
+ **<font style="color:rgb(25, 27, 31);">维护人员（Maintainer）：</font>**<font style="color:rgb(25, 27, 31);">类似于项目管理员，但权限稍低，通常用于协助管理项目，可以进行项目的部分管理操作，如添加和删除镜像、配置镜像的复制和同步规则等。</font>
+ **<font style="color:rgb(25, 27, 31);">开发者（Developer）：</font>**<font style="color:rgb(25, 27, 31);">具有对项目中镜像仓库的读写权限，可以拉取、推送和删除镜像，以及管理部分项目配置，但不能进行项目管理操作。</font>
+ **<font style="color:rgb(25, 27, 31);">访客（Guest）：</font>**<font style="color:rgb(25, 27, 31);">只具有对项目中镜像仓库的只读权限，可以查看镜像和元数据，但无法对镜像进行修改或删除操作。通常用于分享项目或镜像给外部团队或用户。</font>
+ **<font style="color:rgb(25, 27, 31);">受限访客（Restricted Guest）：</font>**<font style="color:rgb(25, 27, 31);">是一种更加受限的访客角色，通常用于提供给外部用户或系统，具有对项目中镜像仓库的只读权限，但可能会限制访问的部分内容或功能。</font>

<font style="color:rgb(25, 27, 31);">在右上角显示推送命令，可以通过提示命令进行docker镜像推送。  
</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887750856-cf536081-6d18-466b-89bc-e548677de0de.png)

<h4 id="OiITA"><font style="color:rgb(25, 27, 31);">6.2、日志</font></h4>
<font style="color:rgb(25, 27, 31);">日志菜单就是记录用户操作日志信息的。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887807171-0f832730-5888-44c8-b68e-61bc93271bfb.png)

<h4 id="G7nR4"><font style="color:rgb(25, 27, 31);">6.3、系统管理</font></h4>
<font style="color:rgb(25, 27, 31);">系统管理主要用来管理Harbor用户人员信息、镜像仓库的各种配置、权限和系统设置。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887795137-edf4b00f-b495-4a2c-93ca-c0bd54a8566b.png)

<h3 id="269793c3"><font style="color:rgb(25, 27, 31);">7、Docker命令使用私有仓库</font></h3>
<h4 id="jlXTW"><font style="color:rgb(25, 27, 31);">7.1、登录</font></h4>
<font style="color:rgb(25, 27, 31);">首先登录私有仓库地址：</font>

```plain
docker login  -u admin -p AdminHarbor12345 http://192.168.1.7:5000
```

<font style="color:rgb(25, 27, 31);">会报错：</font>

```plain
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
Error response from daemon: Get "https://192.168.1.7:5000/v2/": proxyconnect tcp: dial tcp 192.168.65.7:3128: connect: connection refused
```

<font style="color:rgb(25, 27, 31);">docker认为这个地址是不安全的，所以需要在docker守护进程配置文件中把该地址加入安全范围。</font>

```plain
{
  "registry-mirrors": ["https://ejes884z.mirror.aliyuncs.com"],
  "log-driver":"json-file",
  "log-opts": {"max-size":"1g", "max-file":"3"},
  "live-restore": true,
  "insecure-registries": ["192.168.1.7:5000"]
}

# insecure-registries 不安全的注册表配置一些不安全的地址信息，让Docker认为是安全的。多个地址使用 "," 分割
```

<font style="color:rgb(25, 27, 31);">加入配置成功后，再次登录。</font>

```plain
WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```

<font style="color:rgb(25, 27, 31);">通过输出发现登录成功。认证信息存储在 </font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">~/.docker/config.json</font>`<font style="color:rgb(25, 27, 31);"> 文件中，只要登录信息存在，登录会一直生效不需要每次推送拉取之前都登录。</font>

<h4 id="wLrO2"><font style="color:rgb(25, 27, 31);">7.2、推送</font></h4>
<font style="color:rgb(25, 27, 31);">重新命名镜像名称</font>

```plain
docker tag 94543a6c1aef 192.168.1.7:5000/blog_project/nginx:1.26.0
```

<font style="color:rgb(25, 27, 31);">推送</font>

```plain
docker push 192.168.42.7:5000/blog_project/nginx:1.26.0
```

<font style="color:rgb(25, 27, 31);">查看Harbor仓库，推送成功。</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887844513-431188a8-de89-4ea7-9c28-53077ae43235.png)

<h4 id="P7j4R"><font style="color:rgb(25, 27, 31);">7.3、拉取</font></h4>
<font style="color:rgb(25, 27, 31);">通过另一台服务器，使用</font><font style="color:rgb(25, 27, 31);"> </font>`<font style="color:rgb(25, 27, 31);background-color:rgb(248, 248, 250);">docker pull</font>`<font style="color:rgb(25, 27, 31);">拉取镜像从私有仓库拉取镜像：</font>

```plain
docker pull 192.168.1.7:5000/blog_project/nginx:1.26.0
```

<font style="color:rgb(25, 27, 31);">拉取成功</font>

![](https://cdn.nlark.com/yuque/0/2025/png/39221021/1746887025819-15347766-b057-429c-86d4-6272efc29bc2.png)

<font style="color:rgb(25, 27, 31);">查看下载数，发现已经更新了。</font>



<font style="color:rgb(25, 27, 31);"></font>

