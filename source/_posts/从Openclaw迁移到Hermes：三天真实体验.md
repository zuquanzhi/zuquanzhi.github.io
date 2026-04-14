---
title: 从Openclaw迁移到Hermes：三天真实体验
toc: true
mathjax: false
copyright: true
cover: 'https://www.loliapi.com/acg?673'
categories: Agent
tags:
  - Openclaw
  - Hermes
  - Agent Cli
abbrlink: 51943
date: 2026-04-15 01:04:43
updated: 2026-04-15 01:04:43
---

## 前言

说起来挺巧的。

本来我不是要换 agent。龙虾用了两个多月，代码写得让我难受，但该跑的都在跑，没出什么大问题。换平台的念头有过，切换成本摆在那儿，一直没动。

前两天闲来无事刷 L 站，不知道怎么点开了 [Hermes 的 GitHub](https://github.com/NousResearch/hermes-agent)。

> The self-improving AI agent — it creates skills from experience, improves them during use, nudges itself to persist knowledge, searches its own past conversations.

看完了。

不是「哦，听起来不错」。是「这个设计……有点东西」。不确定它能不能做到，但这个目标本身让我觉得值得认真看一下。

花了一整天读架构文档，晚上开始迁移，把能跑的都跑起来了。现在是第三天，有些东西还在调。整体感受是：它超出了我最初的预期。

每当发现一个有意思的项目，我总想把为什么觉得它有意思说一说。

---

## 背景

OpenClaw（也就是前阵子很火的龙虾）实际跑了快俩月。

虽然有很多自媒体带节奏的原因，但是我确实没想到国内的大厂甚至官方（比如广东）也这么快下场了。不知道是好事还是坏事。

它能跑。微信接入、SOUL.md 人格、TTS 语音，核心需求都满足。理奈这个角色在里面活了几个月，记忆、习惯、工作流都沉淀了。

问题是它的代码。不是不能用，是每次打开 web 想加点东西，就感觉在往一个设计混乱的地方塞新的零件。想加个功能发现底层结构不支持，解决方案是重写那块。不是一个功能的问题，是架构的问题。

---

## Hermes 是什么

[Hermes](https://github.com/NousResearch/hermes-agent) 是 Nous Research 出品的开源项目，定位是 self-improving AI agent。核心目标不是「能聊天」，也不是「能用工具」，而是让 agent 真正具备持续改进自己的能力——从经验里创建 Skills，在使用中改进 Skills，主动沉淀知识，搜索自己的历史会话。

README 这句话我读了三遍才继续往下看。不是因为它难懂，是因为它说了一件大多数 agent 框架不愿意认真承诺的事。

---

## 搭建过程

### 安装

```bash
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash
```

Linux / macOS / WSL2 / Android Termux 支持。Windows 需要 WSL2。装完 `source ~/.bashrc`，`hermes` 命令生效。两分钟，全自动。

### 初始化配置

`hermes setup`，五步引导：

**模型与 Provider**

20+ provider 支持：OpenRouter、OpenAI、Anthropic、MiniMax、Nous Portal…… 我原来在用 MiniMax 的 Coding Plan，量大管饱，直接复用，两分钟切过去。`hermes model` 随时可换。

**终端后端**

这是 Hermes 和龙虾设计思路差异最明显的地方。

龙虾的 agent 跑在本地，没有「执行环境」这个概念。Hermes 把 agent 的运行环境抽象成了独立的「终端后端」，支持六种：Local、Docker、SSH、Modal、Daytona、Singularity。

这个设计解决了一个实际问题：不同场景需要不同的资源隔离策略。本地开发用 Local，需要 GPU 用 Modal，需要强隔离用 Docker，不想自己管理用 Daytona。切换后端不需要改 agent 代码，只需要改配置。

Modal 和 Daytona 支持休眠唤醒，idle 不花钱，需要时自动起来。试了一下 Modal，账单比预期低很多——大部分时间根本没在用它，它自己在睡觉。龙虾要么跑着烧钱，要么关掉。

**消息平台**

15 个平台适配器：Telegram、Discord、Slack、WhatsApp、Signal、钉钉、飞书、企业微信……微信和 Telegram 都是现接。

**工具集**

`hermes tools` 独立管理界面，48 个工具按平台开关。

**主题**

`hermes skin` 可切外观。`mono` 主题切完从金色 kawaii 变成纯黑白，差别大到像两个产品。熟悉我的朋友都知道我是钢铁侠审美的忠实粉丝，这个设计非常戳我的点。

### 从龙虾迁移

`hermes claw migrate --dry-run` 先看预演，确认内容后执行。两分半钟搞定，没有手动复制任何东西。Skills 迁移后检查路径引用，有一个报错了两分钟，修了半小时发现是 Openclaw 的屎太大了，垃圾到处扔。

### 启动

```bash
hermes               # CLI 界面
hermes gateway start # 消息网关（后台）
```

---

## 三天的感受

### CLI 是主战场

龙虾本质上是「消息平台上的 AI」，Hermes 本质上是「CLI 上的 AI，顺便支持消息平台」。我愿称它为 Agent 届的 Claude Code。

`hermes` 打开的是全屏 TUI 界面：多行编辑、命令历史、斜杠命令自动补全、流式输出。坐在电脑前时 CLI 比消息平台更高效，没有延迟，没有平台限制，token 用量清晰。

### 记忆系统

龙虾的记忆靠文件散落管理（随地大小便）。文件一多，agent 自己也容易混乱，context 满了就开始出现「读不进去」的问题。

Hermes 做了几件不一样的事：

**FTS5 全文搜索。**

这是三天里用得最多的功能。任何历史会话内容直接搜索，不是文件名索引，是全文检索。搜「上次处理 SSH 断线」，三秒钟出结果，不用让 agent 读一堆文件然后给你一个大概的答案。

**Memory Manager 插件化。**

龙虾的 memory 写死在 AGENTS.md 体系里。Hermes 抽象出了 Memory Manager 接口，可以接入 Honcho、mem0、Supermemory 等第三方方案。默认够用，但这个扩展性是真实存在的。

**Skill 创建与固化。**

`/skills save` 把当前会话的经验固化成一个可复用 Skill，下一次同类型任务直接调用。这比龙虾的「复制粘贴 Prompt 大法」省心很多。

### Skill 系统

龙虾的 Skills 更像是预设 Prompt，定义简单，功能有限。

Hermes 的 Skills 有完整生命周期：创建 → 携带脚本和参考资料 → 使用 → 自动改进。接入了 agentskills.io 开放标准和 ClawHub 社区市场，`hermes skills install <skill-name>` 直接装社区共享 Skills。

第二天逛了一下社区 Skills，质量参差不齐，但机制本身是完整的。龙虾没有这个——Skills 是私有的，想分享得手动导出文件。

### 定时任务

龙虾的 cron 靠外部调度器，配置有门槛。

Hermes 原生内置 cron：

```
/cron 每天早上九点给我发天气摘要 deliver=telegram
```

自然语言描述需求即可。Cron 运行在独立会话里，不污染主对话 context。

---

## 设计理念：为什么这个架构不一样

这部分是让我真正觉得有意思的东西，写详细一点。

### Self-improving 不是宣传语，是架构目标

大多数 agent 框架的 self-improving 是「我会记住你说的话」，本质上是把对话历史当记忆用。Hermes 不一样。

它的 self-improving 是结构化的：agent 每次完成复杂任务，可以创建 Skill；Skill 有完整的生命周期定义，可以携带脚本、参考资料、使用记录；agent 在使用 Skills 的过程中可以主动改进它们。这不是「记住你说的话」，是「形成可复用的能力模块，并在使用中迭代它们」。

要实现这个目标，底下的基础设施必须到位。不是加个 `learn()` 函数就能解决的。

在这股 AI 生产力大跃进的浪潮里，氛围编程、Agentic 编程的概念满天飞，焦虑感比方法论长得更快。Hermes 的难得之处恰恰是它没有随这个大流——它选择在代码结构和工程化上花力气，而不是堆功能、造概念。

这件事说起来简单，做起来完全是另一回事。架构一旦烂了，self-improving 就只是宣传语。Hermes 能把这个目标放进架构设计里，而不是事后打补丁，靠的正是对代码结构和秩序的坚持。这种敏感度和掌控度，在当下的环境里反而成了稀缺品。

某种程度上，这也是人类在 AI 时代还能站稳脚跟的东西——不是比谁能更快地调用 AI，而是谁能保持对复杂系统的结构和节奏的感知。

### 数据库驱动的会话存储是一切的基础

Hermes 的会话存储用 SQLite + FTS5（`hermes_state.py`），不是文件系统堆文件。

这个设计解决了一个根本问题：agent 的记忆必须是可查询的、可交叉引用的、可追踪改进历史的。

文件系统的天花板就是文件名和内容匹配。你想让 agent 回忆「三个月前处理的那个 SSH 问题」，在文件系统下只能靠 agent 读文件然后自己推理。在数据库下可以直接 FTS5 查询，精确到会话级别、工具调用级别、决策级别。

更重要的是：只有结构化的数据才能支撑上面说的 Skill 改进机制。Skill 的每次使用、每次改进、每个版本，都需要被记录和追踪。这在文件系统下是做不到的，不是「难」，是「天花板就在那里」。

龙虾的 memory 是 `.md` 文件。这不是技术路线的分歧，这是对「self-improving 需要什么基础设施」的不同理解。

### Prompt Caching 是认真的工程决策

Anthropic 提供的 Prompt Caching 接口，Hermes 是第一批认真接入的 agent 框架之一。

对于长上下文会话，重复发送完整的 system prompt 是浪费。Prompt Caching 把 system prompt 缓存起来，只传变更的部分，成本有时候能降 50% 以上。这不是可选项，是工程上的必然。

龙虾没有这个。不是龙虾不想，是龙虾的架构在设计之初就没有考虑这种优化。等你想加的时候，整个上下文管理层可能要重写。

这不是「功能有没有」的问题，是「架构是否允许你后续加这些东西」的问题。

### 工具注册机制决定了你能不能扩展

48 个工具通过中央 registry 注册（`tools/registry.py`），一次注册所有平台自动可用。

新增工具的流程：写工具实现 → 注册 → 分发。链路清晰，不容易出错，不需要为每个平台单独适配。

龙虾的插件体系更偏向预设 vs 注册。不是说不能扩展，是扩展成本更高，出错点更多，每次加新工具都要多考虑几个地方。

### Gateway 和 CLI 共享命令注册表

这是 Hermes 设计里我最喜欢的细节之一。

龙虾的消息模块和 CLI 是两套独立的命令处理。Hermes 的 Gateway 和 CLI 共用同一个 `COMMAND_REGISTRY`——`/model`、`/skills`、`/compress` 在两个入口的行为完全一致，不需要维护两套逻辑。

这个设计的好处不只是代码复用。它意味着你可以在 CLI 里调试好一个 workflow，然后无缝迁移到消息平台，反之亦然。不会有「这个命令在 CLI 里能用但 Telegram 里不能用」的问题。

---

## 优缺点都说说

### Hermes 真正做得好的地方

**架构一致性。** 从数据库设计到工具注册，从 Gateway 到 CLI，从 Skill 生命周期到 Prompt Caching，每一块都像是同一个设计思路的产物。这不是功能多，这是设计语言统一。

**扩展性是架构内置的，不是打补丁。** 想加新的 Memory Provider？接上去。想加新工具？注册一下。想换终端后端？改配置。不用动核心代码。

**多 Profile 体系。** 同一台机器上跑多个独立配置的 agent 实例，每个 Profile 有自己的目录、配置、Gateway。龙虾是单实例的，想跑第二个得另起进程，各种配置容易打架。

**多模型支持。** 20+ provider，`hermes model` 随时切换，不用改代码不用迁移数据。provider 绑定的风险低很多。

### Hermes 真正的短板

**开箱体验不如龙虾。** 龙虾装完基本能跑，需要配置的东西少。Hermes 选项多，选项多意味着初期决策成本高。不是说复杂，是「你得想清楚自己要什么」。

**Skill 自我改进的实际效果有待验证。** 文档里说 agent 会主动改进 Skills，三天时间不够验证这个能力在实际使用中的效果。目前能用的是 Skill 创建和复用，主动改进的部分还没有足够的样本观察。

**社区还在早期。** ClawHub 上的社区 Skills 质量参差不齐，好用的有，不好用的也有，需要自己筛选。龙虾没有社区 Skills，但胜在稳定——预设的东西虽然少，质量有保证。

**有些功能名字取得好听，实现还不完整。** 比如 trajectory 压缩、RL 训练数据采集这些功能，架构上是存在的，但普通用户用起来还是有一定门槛。不是不能用，是需要配置。

---

## 结论

用了三天 Hermes，该跑的都在跑了。

最大的感受不是「这个比那个好」。是「发现了一个架构设计认真的项目，它的思路让我觉得 self-improving 这个目标值得继续看」。

龙虾的问题不是不能用，是它的架构不支持真正的 self-improving。每次开新会话 agent 得从头认识你一遍，Skills 是静态的，记忆是文件堆出来的。Hermes 的架构是为 self-improvement 设计的，这些东西是它的底层设计目标，不只是功能清单。

三天不够验证它能走多远，但起步是认真的。

---

*写于 Hermes 第三天。Telegram 跑通了，WeChat 还在调，Skill 还在攒。*
*目前微信插件似乎还有一些bug，提了issue看看后面会不会修一下*
