---
title: Hexo部署成功，页面却没更新？一次CDN缓存引发的灵异事件
toc: true
mathjax: false
copyright: true
cover: 'https://www.loliapi.com/acg?368'
categories: bug记录
tags:
  - CDN
  - Hexo
description: bug排查记录
keywords: 'hexo,CDN缓存'
abbrlink: 47447
date: 2026-04-15 01:30:36
updated: 2026-04-15 01:30:36
---

## 前情提要

昨天晚上，我往博客发了一篇新文章。

`hexo d` 执行完毕，终端显示一切正常：

```
Deploying: git
Site updated: 2026-04-15 00:52:55
HEAD -> master (forced update)
Deploy done: git
```

第二天打开博客首页一看————新文章呢？

再点进文章详情页——**居然是正常的**。

明明推送成功了，Hexo 没报错，GitHub 上 master 分支也能看到新文件。但网页就是不给力。

这是怎么回事？

---

## 排查思路：自下而上，一层一层排除

遇到"发布成功但页面不对"的问题，第一反应是不要慌，先搞清楚问题出在哪一层。

1. 源文件还在不在
2. 本地生成的静态文件对不对
3. Git 远端分支内容对不对
4. 线上域名实际返回什么
5. DNS 和响应头里有没有缓存的痕迹

---

## 第一步：确认源文件没问题

源文章在 `source/_posts/从Openclaw迁移到Hermes-三天真实体验.md`，front-matter 齐全，abbrlink、日期、分类都正常。

结论：源文件没问题。

## 第二步：确认本地生成产物

`public/` 目录下，`2026/04/14/32348/index.html` 存在，首页 `public/index.html` 里也有文章入口，归档页也正常。

结论：Hexo 生成阶段完全正常。

## 第三步：确认远端分支真的更新了

上 GitHub 看了一下 master 分支，`index.html`、`archives/index.html`、`2026/04/14/32348/index.html` 全都在。

`hexo d` 确实把东西推送上去了。

结论：Git 推送没问题，master 分支内容正确。

## 第四步：检查线上实际返回了什么

问题一定出在更上层。用 `curl -I` 看了响应头：

```
curl -I https://blog.zuquanzhi.top/
```

返回 **200**，但注意看响应头：

```
Server: Tengine
X-Cache: ...
Ali-Swift-Global-Savetime: ...
Via: ...
```

`Tengine` 是阿里云的 Web 服务器——说明博客不是直接暴露的，背后有一层**阿里云 CDN**。

这时我才想起来，之前被哥们吐槽博客打开速度慢，给Github Page搞了个阿里云的CDN加速。

再检查新文章路径：

```
curl -I https://blog.zuquanzhi.top/2026/04/14/32348/
```

返回 **404**。

`curl -L` 跟随重定向看实际内容，确认是真正的 404 页面，不是 Hexo 的主题 404 页面。

**同时首页也拿到的却是新版本**——文章数、归档统计都更新了。

这就对上了。

---

## 根因：阿里云 CDN 缓存

我点开阿里云的CDN界面一看，果然在缓存界面设置着主页的地址，这才是本次事故的罪魁祸首。

Hexo 发布成功了，GitHub master 也更新了，但阿里云 CDN 节点缓存的是旧内容：

- 首页：命中旧缓存，显示的是发布前的版本
- 新文章路径：可以正常访问

**不是发布失败，是 CDN 没刷新。**

---

## 解决办法

去阿里云 CDN 控制台手动刷新页面缓存：

https://cdn.console.aliyun.com/refresh/

刷新以下 URL：

- `https://blog.zuquanzhi.top/`
- `https://blog.zuquanzhi.top/index.html`
- `https://blog.zuquanzhi.top/archives/`
- 新文章路径及 `index.html`

刷新完成后，再次访问，新文章瞬间可见，问题解决。

---

## 经验总结

**Hexo 部署成功 ≠ 用户立刻看到新内容。**

如果你也用了 CDN（阿里云、又拍云、Cloudflare 等），发布后多了一层缓存延迟。新文章路径第一次访问时 CDN 没有缓存会返回 404，旧页面被 CDN 缓存着也不会自动更新。

**建议的发布流程：**

```
1. hexo d          # 部署
2. 刷新 CDN 缓存   # 刷新首页、归档页、本次新文章路径
3. 验证            # curl -I 检查关键 URL 的状态码和内容
```

**CDN 缓存策略建议（给后来者参考）：**

- HTML 页面：缓存时间设短一些，或者发布后自动刷新
- 静态资源（CSS/JS/图片）：可以长缓存，用版本号或 hash 方式控制更新
- 404 页面：缓存时间设极短，避免错误状态被长期固化

如果发布频繁，可以考虑用 CDN 提供的 API 做自动化刷新，就不用每次手动去控制台点了。

---

## 最后

这次问题不算大，但排查过程中"明明推送成功了为什么看不到"的那种困惑感很强。记录下来的目的就是下次遇到类似情况，能快速定位到 CDN 缓存这一层，少走弯路。

如果你也用 Hexo + CDN + 自定义域名，建议可以把"发布后刷新 CDN"变成标准流程的一部分。省心。