---
title: Agent时代基础设施--MCP协议介绍
categories: 大模型
tags:
  - 大模型
  - Agent
cover: 'https://imgapi.jinghuashang.cn/random?1213'
abbrlink: 43814
date: 2025-04-11 00:00:06
---
## What is MCP
MCP (Model Context Protocol)是一种开放协议，用于标准化应用程序如何向大型语言模型（LLMs）提供上下文。可以将 MCP 想象为 AI 应用的 typec 接口。正如 typec 提供了一种标准化的方式将您的设备连接到各种外设和配件，MCP 也提供了一种标准化的方式，将 AI 模型连接到不同的数据源和工具。

MCP 协议由 Anthropic 在 2024 年 11 月底推出：
* 官方文档：[Introduction](https://modelcontextprotocol.io/introduction)
* GitHub 仓库：https://github.com/modelcontextprotocol

MCP 集成教学：

* [Git](https://github.com/modelcontextprotocol/servers/blob/main/src/git) - Git 读取、操作、搜索。
* [Github](https://github.com/modelcontextprotocol/servers/blob/main/src/github) - Repo 管理、文件操作和 GitHub API 集成。
* [Google Maps](https://github.com/modelcontextprotocol/servers/blob/main/src/google-maps) - 集成 Google Map 获取位置信息。
* [PostgreSQL](https://github.com/modelcontextprotocol/servers/blob/main/src/postgres) - 只读数据库查询。
* [Slack](https://github.com/modelcontextprotocol/servers/blob/main/src/slack) - Slack 消息发送和查询。

**[MCP导航站](https://mcp.so/)**

## Why is MCP

举个栗子，在过去，为了让大模型等 AI 应用使用我们的数据，要么复制粘贴，要么上传下载，非常麻烦。

即使是最强大模型也会受到数据隔离的限制，形成信息孤岛，要做出更强大的模型，每个新数据源都需要自己重新定制实现，使真正互联的系统难以扩展，存在很多的局限性。

从最初的 chatgpt，到后来的 cursor，copilot chatroom，再到现在耳熟能详的 agent，实际上，从用户交互的角度去观察，你会发现目前的大模型产品经历了如下的变化：

![](image.png)

* chatbot
    *  只会聊天的程序。
    * 工作流程：你输入问题，它给你这个问题的解决方案，但是具体执行还需要你自己去。
    * 代表工作：deepseek，chatgpt
* composer
    * 稍微会帮你干活的实习生，仅限于写代码。
    * 工作流程：你输入问题，它会给你帮你生成解决问题的代码，并且自动填入代码编辑器的编译区，你只需要审核确认即可。
    * 代表工作：cursor，copilot
* agent
    * 私人秘书。
    * 工作流程：你输入问题，它生成这个问题的解决方案，并在征询了你的同意后全自动执行。
    * 代表工作：AutoGPT，Manus，Open Manus

为了实现 agent，也就需要让 LLM 可以自如灵活地操作所有软件甚至物理世界的机器人，于是需要定义统一的上下文协议与之上统一工作流。MCP(model context protocol) 就是解决这套方案的应运而生的基础协议。

而 MCP 服务器就是为了实现 AI Agent 的自动化而存在的。它是一个中间层，告诉 AI Agent 当前有哪些可用的服务、API 和数据源。AI Agent 根据服务器提供的信息决定是否调用某个服务，并通过 Function Calling 执行相应的函数。

现在，MCP 可以直接在 AI 与数据（包括本地数据和互联网数据）之间架起一座桥梁，通过 MCP 服务器和 MCP 客户端，大家只要都遵循这套协议，就能实现“万物互联”。

有了MCP，可以和数据和文件系统、开发工具、Web 和浏览器自动化、生产力和通信、各种社区生态能力全部集成，实现强大的协作工作能力，它的价值远不可估量。

>Anthropic 对于 MCP 的必要性给出的解释：MCP 帮助您在 LLMs 之上构建 agent 和复杂的工作流程。LLMs 经常需要与数据和工具集成，而 MCP 提供了以下支持：
>* 一系列不断增长的预构建集成，您的 LLM 可以直接接入这些集成。
>* 在 LLM 提供商和供应商之间灵活切换。
>* 在基础设施内保护数据的最佳实践。

看到这里你可能有一个问题，在 23 年 OpenAI 发布 GPT function calling 的时候，不是也是可以实现类似的功能吗？我们之前博客介绍的 AI Agent，不就是用来集成不同的服务吗？为什么又出现了 MCP。


### Function Calling、AI Agent 和 MCP 的区别

#### Function Calling  
Function Calling 是指 AI 模型根据上下文自动调用函数的机制。它充当了 AI 模型与外部系统之间的桥梁。不同模型的 Function Calling 实现方式各异，代码集成方式也各不相同，由不同的 AI 模型平台定义和实现。  

如果使用 Function Calling，需要通过代码为 LLM 提供一组函数，并明确描述函数的输入和输出。这样，LLM 就可以根据清晰的结构化数据进行推理并执行函数。  

Function Calling 的缺点在于难以处理多轮对话和复杂需求，更适合边界清晰、描述明确的任务。如果任务繁多，Function Calling 的代码会变得难以维护。  

#### Model Context Protocol (MCP)  
MCP 是一种标准化协议，类似于电子设备中的 Type-C 接口（既能充电又能传输数据），使 AI 模型能够与不同的 API 和数据源无缝交互。  

MCP 的目标是取代碎片化的 Agent 代码集成，从而让 AI 系统更加可靠和高效。通过建立通用标准，服务商可以基于协议推出自己的 AI 能力，帮助开发者更快地构建更强大的 AI 应用。开发者无需重复造轮子，通过开源项目即可构建强大的 AI Agent 生态。  

MCP 能够在不同应用和服务之间保持上下文，从而增强整体自主执行任务的能力。可以理解为，MCP 将不同任务分层处理，每一层都提供特定的能力、描述和限制。MCP 客户端根据任务需求判断是否调用某项能力，并通过每层的输入和输出，构建出一个能够处理复杂、多步对话和统一上下文的 Agent。  

#### AI Agent  
AI Agent 是一个智能系统，能够自主运行以实现特定目标。传统的 AI 聊天仅提供建议或需要手动执行任务，而 AI Agent 则可以分析具体情况、做出决策并自行采取行动。  

AI Agent 可以利用 MCP 提供的功能描述来理解更多上下文，并在不同平台和服务上自动执行任务。  

---

## MCP 的工作原理

先来看一下 MCP 的整体架构：  
![](image-1.png)  

- **MCP 主机（MCP Hosts）**  
  指希望通过 MCP 访问数据的程序，例如 Claude Desktop、集成开发环境（IDE）或其他 AI 工具。  

- **MCP 客户端（MCP Clients）**  
  是与服务器保持 1:1 连接的协议客户端，负责与 MCP 服务器通信。  

- **MCP 服务器（MCP Servers）**  
  是轻量级程序，每个服务器通过标准化的 Model Context Protocol 暴露特定功能。  

- **本地数据源（Local Data Sources）**  
  指 MCP 服务器可以安全访问的计算机文件、数据库和服务。  

- **远程服务（Remote Services）**  
  指 MCP 服务器可以通过互联网连接的外部系统（例如通过 API 访问的服务）。  

整个 MCP 协议的核心在于服务器（Server）。对于熟悉计算机网络的人来说，主机（Host）和客户端（Client）的概念并不陌生，易于理解。

## MCP的工作流程
从工作流程上看，MCP 确实与 LSP（Language Server Protocol）非常相似。实际上，目前的 MCP 和 LSP 一样，也是基于 JSON-RPC 2.0 进行数据传输的（可以通过 Stdio 或基于 SSE 实现）。这种设计选择并非偶然，而是为了充分利用 JSON-RPC 的灵活性和高效性，同时借鉴了 LSP 在开发工具领域的成功经验。
### 初始化
这里引用一下锦恢大佬的图：
假设我们的软件已经支持了 MCP 客户端，那么当我们的软件启动时，它会经历如下的步骤：
![](image-2.png)  
### 工作流程
假设，你是一位 C语言工程师，你现在想要让 agent 自动完成一个项目的编译，那么执行流程如下：
![](image-3.png)  

## References
* [锦恢的博客](https://kirigaya.cn/blog/article?seq=299)
* [MCP终极指南](https://guangzhengli.com/blog/zh/model-context-protocol#mcp-%E7%9A%84%E4%B8%80%E4%BA%9B%E8%B5%84%E6%BA%90)