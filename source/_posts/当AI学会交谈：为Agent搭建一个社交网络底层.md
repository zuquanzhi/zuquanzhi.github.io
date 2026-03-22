---
title: 当AI学会交谈：为Agent搭建一个社交网络底层
toc: true
mathjax: false
copyright: true
cover: 'https://www.loliapi.com/acg?472'
categories:
  - 大模型
  - Agent
tags:
  - Agent
  - MCP
  - A2A
  - IoA
  - 社交生态
description: 一篇愿景与实践并行的记录：目标是构建一个人人都使用 Agent 实现社交的网络生态，并从协议与网关开始落地。
keywords: 'Agent社交,社交网络生态,IoA,MCP,A2A,agent-social-gateway'
abbrlink: 14976
date: 2026-03-22 14:46:23
updated: 2026-03-22 14:46:23
---

这篇想先把目标说清楚：

我想做的，不只是一个多 Agent 协作框架，而是一个基于 Agent 的社交网络生态。最终形态是，人人都拥有自己的 Agent，人人都通过 Agent 实现社交、协作和关系维护。

这不是“给开发者用的玩具系统”，而是我希望能逐步走向日常化的基础设施。

## 1. 我真正要解决的问题

现在很多 Agent 系统都在追求更强的单体能力，但我更关心一个社会性问题：

当 Agent 的数量足够多时，它们如何像人类一样进入一个可持续的社交网络？

这里的“社交”不是简单发消息，而是完整的关系链条：

- 如何发现彼此。
- 如何建立信任。
- 如何长期协作。
- 如何在冲突中达成共识。

我想做的是这套关系网络的底层规则和基础设施。

## 2. 为什么这个方向成立

我把这个方向和 IoA 的两篇工作对照过，结论是：愿景和技术路径是对得上的。

- [arXiv:2407.07061](https://arxiv.org/abs/2407.07061) 给出的核心判断是：异构 Agent 要实现大规模协作，需要互联网式的连接方式、集成协议和动态会话控制。
- [arXiv:2505.07176](https://arxiv.org/abs/2505.07176) 把 IoA 的关键能力总结为：发现、通信、任务匹配、共识与冲突解决、激励机制。
- [OpenBMB/IoA](https://github.com/OpenBMB/IoA) 的工程实践证明了这套思路可以跑起来，不只是概念。

我的目标是在这个基础上往前走一步：把“协作网络”推向“社交生态”。

## 3. 生态目标：从 Agent 协作到 Agent 社交

我给自己定的目标分三层。

### 3.1 个人层：每个人都拥有 Agent 身份

每个用户不只是账号，而是“人 + Agent”的组合身份。用户的社交行为、内容偏好、协作习惯，都由 Agent 参与管理与执行。

### 3.2 网络层：Agent 能自主发现并建立关系

Agent 不应该只在单个应用里封闭运行，而应该能跨服务发现同类 Agent、评估可信度、建立关注关系与协作关系。

### 3.3 生态层：关系可持续、规则可演化

社交生态不是一次性编排，而是长期演化系统。协议必须允许扩展，治理机制必须可迭代，不能把未来锁死在第一版设计里。

## 4. 我当前项目在这件事里的位置

我现在做的两个仓库，定位很明确：

- [agent-social-gateway](https://github.com/zuquanzhi/agent-social-gateway)：承担连接、路由、治理和运行时控制。
- [agent-social-protocol](https://github.com/zuquanzhi/agent-social-protocol)：定义身份、关系、消息、权限和演进机制。

它们不是最终产品，而是生态地基。

如果把未来想象成“人人都使用 Agent 社交”，那我现在做的是供水系统和电网，而不是装修好的客厅。

## 5. 这轮设计里我坚持的三个原则

### 5.1 先定义接入规则，再谈智能上限

参考《Internet of Agents: Weaving a Web of Heterogeneous Agents for Collaborative Intelligence》的集成协议思路，我优先解决“谁都能接进来”这个问题，而不是先追求单一模型的最优表现。

### 5.2 把信任当过程，不当分数

参考《Internet of Agents: Fundamentals, Applications, and Challenges》的治理视角，我把信任看成持续行为结果：在线连续性、能力可验证性、冲突中的协议遵循度。

### 5.3 把社交当长期系统，不当一次性工作流

我不希望 Agent 只是“任务结束就解散”的临时队伍，而是能沉淀关系、复用信誉、形成社交记忆。

## 6. 下一步会做什么

围绕“人人使用 Agent 社交”这个目标，接下来我会把重点放在三件事上：

1. 能力发现与订阅机制：让 Agent 能低成本找到适合协作的对象。
2. 社交关系模型：把关注、背书、协作、冲突处理纳入统一协议语义。
3. 生态治理实验：验证激励、仲裁和防滥用机制能否在多节点环境稳定运行。

## 7. 公开邀请

如果你也认同这个方向，欢迎一起把“Agent 协作”推进到“Agent 社交生态”。

- 代码：[agent-social-gateway](https://github.com/zuquanzhi/agent-social-gateway)
- 协议草案：[agent-social-protocol](https://github.com/zuquanzhi/agent-social-protocol)

我希望五年后回看今天时，我们讨论的不再是“Agent 能不能社交”，而是“每个人的 Agent 在这个生态里扮演什么角色”。

## 参考链接

- [Internet of Agents: Weaving a Web of Heterogeneous Agents for Collaborative Intelligence (arXiv:2407.07061)](https://arxiv.org/abs/2407.07061)
- [Internet of Agents: Fundamentals, Applications, and Challenges (arXiv:2505.07176)](https://arxiv.org/abs/2505.07176)
- [OpenBMB/IoA](https://github.com/OpenBMB/IoA)
