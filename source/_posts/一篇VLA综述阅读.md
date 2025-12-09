---
title: 一篇VLA综述阅读
cover: 'https://www.loliapi.com/acg?983'
categories: 科研
tags: VLA
abbrlink: 64154
date: 2025-12-06 22:32:40
updated: 2025-12-06 22:32:40
---

**论文链接：**[Vision-Language-Action Models for Robotics: A Review Towards Real-World Applications](https://arxiv.org/abs/2510.07077)

如果用一句话概括这篇《Vision‑Language‑Action Models for Robotics: A Review Towards Real‑World Applications》，那就是：**它第一次用“全栈视角”认真回答——到底怎样把大模型真正变成会干活的机器人。**

很多文章谈“让 LLM 控制机器人”，停留在高层规划：模型输出“去拿红杯子”，下面是另一个控制模块去执行。作者认为，这还称不上真正的 **Vision‑Language‑Action（VLA） 模型**。他们给了一个非常严格的定义：

> “VLA 模型以视觉观测和自然语言指令为必需输入，并**直接输出控制命令**；只做技能索引的高层策略不算 VLA。” 

这篇文章的野心，就是在这个定义之上，给出 VLA 领域从**挑战 → 架构 → 模态处理 → 训练与数据 → 机器人平台 → 评测与实践指南**的一条完整主线（见论文第 2 页图 1）。

下面我按“读者视角”来拆解这篇综述：它到底在讲什么？我们能学什么？如果你在做具身智能/机器人产品，这篇文章能直接帮你**做架构和路线的选型**。

---

## 一、VLA 想解决什么问题？

论文一开头就指出一个现实：**早期把 LLM/VLM 接进机器人的工作，大多是“高层想一想，低层照做做”**。

> “早期工作把 LLM 和 VLM 与底层策略解耦，只负责任务推理或选择预定义动作原语；这在少量预定义任务上有效，却难以泛化到更广任务。” 

这带来几个痛点：

* 每个新任务都要重新收集示教、重训策略；
* 改一个机器人平台（不同机械臂、移动底盘），现有模型很难复用；
* 模型“知道很多”，但大部分知识没办法落实到低层控制。

于是，**VLA 的核心目标**就是：在大规模数据上**联合学习视觉‑语言‑动作**，得到一种“通用策略”，能：

* 在**新任务**上，用极少甚至零样本适配；
* 跨 **物体、环境和机器人形体（embodiment）** 迁移；
* 最终降低真实部署时的**每任务成本**。

如果把这件事做成，对产业落地的好处也相当大了：

* 仓储、制造、家政、医疗的场景里，可以**用一套方法支撑很多 SKU / 场景 / 流程**；
* 硬件厂商可以围绕统一的 VLA 接口共享数据和模型，而不是各自搞封闭系统（**生态构建**）；
* 有可能出现“云端 VLA + 边缘低成本机器人”的 **Robot‑as‑a‑Service** 模式。

---

## 二、从 CLIPort 到 GR00T：VLA 架构的时间线

论文在第 4 页给了一张非常关键的时间线（图 2），把代表性工作连成一条“进化史”：

> CLIPort → Gato/VIMA → RT‑1/RT‑2/RT‑X/OpenVLA → Octo/RDT‑1B/π0 → LAPA/π0.5/GR00T N1

这条时间线其实对应了**接口风格的变化**，我们可以分几代来看：

### 2.1 第一代：CNN 端到端 —— 桌面玩家 CLIPort

**CLIPort** 是最早真正意义上的 VLA 之一：

* 用 **CLIP** 提取图像 + 文本特征；
* 结合 **Transporter Network** 预测“在哪里抓、放到哪里”；
* 实现在桌面环境下的多对象操作。

局限也很明显：CNN + MLP 架构对模态统一能力有限、扩展到多任务/多平台困难。

### 2.2 第二代：Transformer 序列模型 —— “万能序列机”Gato / VIMA

接下来是 **Gato** 和 **VIMA** 这一类，把一切都 token 化：

* 图像切 patch → 视觉 token；
* 文本 → 文本 token；
* 动作（离散化后）→ 动作 token；
* 全部拼成一个序列，丢进 **decoder‑only Transformer** 里自回归预测。

Gato 展示了“一模型多任务”的可能性：聊天、VQA、游戏操作、机器人控制都能干，但机器人部分技能仍然有限。VIMA 则在仿真中展示了指令 + 目标图像的组合泛化能力。

### 2.3 第三代：现实世界 VLM 主干 —— RT‑系列 & OpenVLA

真正把 VLA 推向现实的，是 **RT‑1/RT‑2/RT‑X**：

* **RT‑1**：

  * EfficientNet 提视觉，Universal Sentence Encoder 提语言；
  * 用 TokenLearner 压缩视觉 token；
  * decoder‑only Transformer **一次性预测全部动作 token**（非自回归）；
  * 在 13 台 Google 机器人上收集了 13 万条轨迹、700+ 任务。

* **RT‑2**：

  * 直接用 **PaLM‑E / PaLI‑X 等 VLM** 做 backbone；
  * 一边做互联网视觉‑语言任务，一边做机器人 BC 训练；
  * 泛化到新物体、新环境的能力大幅提升。

* **RT‑X**：

  * 用多实验室、多机器人联合数据训练，
  * 证明了“跨 embodiment 大一统”的可行性。

基于 RT‑2 结构，**OpenVLA** 用 PrismaticVLM + DINOv2 + SigLIP 作为视觉‑语言主干，在 Open‑X Embodiment（OXE）上全模型微调，在多个 benchmark 上超过 RT‑2 和 Octo，成为目前开源的“主流 VLA 架构”。

### 2.4 第四代：扩散 / Flow / Diffusion Transformer —— Octo、RDT‑1B、π0

当大家发现离散动作 token 在控制频率与平滑度上有先天不足后，一条新路线出现了：**用生成模型直接生成连续动作**。

* **Octo**：第一个把 **Diffusion Policy** 引入 VLA 的公开开源系统。视觉 + 文本 token 过 Transformer 得到 readout，再用扩散模型生成动作序列。
* **RDT‑1B**：更激进，直接用 **Diffusion Transformer (DiT)** 做 backbone，扩散过程嵌在整个 Transformer 中。
* **π0**：用 **Flow Matching + PaliGemma**，把动作头做成 flow 模型，一次输出整段动作 chunk，最高支持 50Hz 控制，兼顾平滑与实时。

### 2.5 第五代：潜在动作 + 分层策略 —— LAPA、π0.5、GR00T N1

最新一代则开始把**人类视频、潜在动作和分层控制**统筹到 VLA 体系里：

* **LAPA**：从视频中学习离散的潜在动作 token，用 VQ‑VAE 压缩“当前图像 → N 步之后图像”的差异，把它当作动作再重建未来图像，从而在**没有显式机器人 action 的人类视频**上预训练。
* **π0.5**：把高层离散动作 token（FAST）和低层 flow 控制统一在一套网络里，既能做 CoT 式的高层决策，又能输出连续控制。
* **GR00T N1**：更进一步，把 LAPA 的潜在动作、RDT‑1B 的 Diffusion Transformer、π0 的 flow 控制，做成一个**多阶段策略结构**，用世界模型生成多样轨迹，再在此基础上学可泛化的策略。

> 从这条进化线可以看到：**LLM 控机器人只是起点，现在的主战场其实在“如何生成连续动作 + 如何用巨大的人类/机器人视频数据训练”。**

---

## 三、三个硬伤：数据、embodiment 和算力

论文第二节给 VLA 列了三宗原罪，这也是落地项目时必然会撞的墙。

### 3.1 数据：三模态对齐的稀缺

> “满足视觉、语言、动作三模态对齐的大规模数据集极其有限；机器人示教数据语言多样性差、任务范围窄，采集昂贵。” 

* 视觉‑语言数据：COCO、LAION 之类有海量图文，但**没动作**。
* 机器人数据：QT‑Opt、RT‑1、RoboNet 等有动作，但**语言贫乏**、任务窄。
* 加更多模态（触觉、音频、3D）后，稀缺程度乘以 N。

### 3.2 Embodiment：不同架构之间的翻译难

机器人千奇百怪：只有机械臂 vs 带轮子 vs 四足 vs 人形；关节 DOF、连杆、传感器都不同。

> “跨 embodiment 的策略迁移依然是重大难题；同样问题在人类 → 机器人迁移上更为严重。” 

这就引出 UniAct、CrossFormer 这类工作：通过统一 token 表示或者潜在动作空间，把不同身体映射到共享表示上。

### 3.3 计算：长序列 + 高频视觉的成本

VLA 大多基于 Transformer，不但要吃语言 token，还要吃高分辨率、多帧图像、可能还有 3D/触觉；序列长度和维度直接爆炸，训练和推理都极其耗算。

于是出现一堆算力区救火的方法：

* TokenLearner、Perceiver Resampler、Q‑Former 等视觉 token 压缩模块；
* RTC、VLA‑Cache、层级早停（DeeR‑VLA）等推理时优化技术。

---

## 四、模型设计全景：三大类架构 + 七种 sensorimotor

作者最硬核的贡献之一，是给出了一个**非常系统的 VLA 架构分类图谱**（图 3–6）。

### 4.1 三大架构家族

1. **Sensorimotor model（传感‑运动模型）**

   * 直接从视觉 + 语言 → 动作；
   * 可以是单层（flat）或分层（hierarchical）；
   * 是现在最主流的一类。

2. **World model（世界模型）**

   * 先预测未来观测（图像/latent），再由逆动力学模型或策略生成动作；
   * 支持规划、长时序推理。

3. **Affordance‑based model（可供性模型）**

   * 先预测“哪里能抓/能放/能走”等可供性，再规划动作。

### 4.2 七种 sensorimotor 架构（图 4）


| 型号                                | 主干          | 动作输出      | 代表                      |
| --------------------------------- | ----------- | --------- | ----------------------- |
| (1) Transformer + 离散 action token | Transformer | 离散 token  | Gato, VIMA, RT‑1 等      |
| (2) Transformer + Diffusion 头     | Transformer | 扩散连续动作    | Octo, NoMAD             |
| (3) Diffusion Transformer         | DiT         | 扩散连续动作    | RDT‑1B, LBM 等           |
| (4) VLM + 离散 token                | 预训练 VLM     | 离散 token  | RT‑2, OpenVLA, GR‑1 等   |
| (5) VLM + Diffusion 头             | 预训练 VLM     | 扩散连续动作    | Diffusion‑VLA, DexVLA 等 |
| (6) VLM + Flow 头                  | 预训练 VLM     | Flow 连续动作 | π0, GraspVLA 等          |
| (7) VLM + Diffusion Transformer   | VLM + DiT   | 分层连续动作    | GR00T N1, CogACT 等      |

这相当于给你一份**架构选型菜单**：

* 任务较短、频率不高 → (4) 类离散 token 架构；
* 要 50Hz 高频、平滑控制 → (6) Flow Matching；
* 要世界模型 + 分层规划 → (7) VLM + Diffusion Transformer。

### 4.3 世界模型 & 可供性

**世界模型（Fig.5）** 大致三种玩法：

1. 预测未来图像/视频，再用 IDM 反推动作（UniPi, DreamGen, SuSIE 等）；
2. 从视频学潜在动作 token，供 VLA 使用（LAPA, UniVLA, UniSkill）；
3. 在 sensorimotor 模型里，顺便预测未来观测（GR‑1/2/3, 3D‑VLA）。

**可供性模型（Fig.6）** 也是三条线：

1. 用 GPT‑4 + OWL‑ViT + SAM 这类 VLM，先产出 **Affordance / Constraint Map**，再 MPC 控制（VoxPoser, LERF‑TOGO 等）；
2. 从人类视频里自动抽取“接触点+轨迹”（VRB, HRP, VidBot）；
3. 把可供性模块嵌进 VLA 主体（CLIPort, RoboGround, Chain‑of‑Affordance）。

---

## 五、数据 & 训练：从 Ego4D 到 OXE，再到自动标注和增强

### 5.1 真实机器人数据：OXE & AgiBot World

表 1（第 19 页）列出了当前主流真实机器人数据集：

* **RT‑1**：130K 轨迹，12 个技能，700+ 任务，13 台 Google 机器人。
* **OXE (Open‑X Embodiment)**：1.4M 轨迹，527 技能，160,266 任务，22 种机器人。
* **AgiBot World**：1M 轨迹，87 技能，217 任务，100+ 台 AgiBot G1。

这些数字强烈暗示一个事实：**泛化 ≈ 足够大的、多平台、多任务数据**。

### 5.2 人类视频 & 自监督潜在动作

为了缓解机器人数据昂贵的问题，论文强调了各类 egocentric 数据集（Ego4D、EPIC‑KITCHENS、HOI4D 等）在 VLA 预训练中的价值。

关键是用世界模型/潜在动作学习，把“无显式动作标签”的人类视频变成可用信号，如 LAPA/UniVLA/UniSkill 那样。

### 5.3 自动标注 & 生成式增强：数据“增值流水线”

论文专门用了一个小节讲**数据增强**：

* 视觉增强：CACTI、GenAug、ROSIE 用 Stable Diffusion / Imagen Editor 改背景、改纹理、加干扰物，在不破坏几何结构和可供性的前提下提升鲁棒性；DreamGen 用视频 world model + IDM 做合成轨迹。
* 语言增强：DIAL 用小规模 seed，LLM 生成大量改写，再用 VLM 匹配轨迹，构建大规模指令标注数据。
* 动作增强：CCIL 等方法用局部动力学模型合成“纠错”轨迹，缓解分布外状态问题。

而在标注流水线方面，ECoT、EMMA‑X、NILS、RoboMIND 综合用 GroundingDINO + SAM + Gemini/GPT‑4 等，把原始视频自动切分成子任务、加状态/指令描述，大幅减少人力。

---

## 六、评测与落地：RobotPlatform、baseline && Safety

### 6.1 仿真 benchmark：LIBERO / ManiSkill / Habitat / RLBench…

表 2（第 23 页）把主流仿真基准梳理成一张表，包括任务类型、场景数量、模态和物理引擎等信息。

大致可以归类：

* MuJoCo 系：robosuite/robomimic/RoboCasa/LIBERO 等；
* PhysX/SAPIEN 系：ManiSkill 1–3、ManiSkill‑HAB、RoboTwin；
* PyBullet 系：Ravens/VIMA‑BENCH/LoHoRavens/CALVIN；
* V‑REP 系：RLBench/COLOSSEUM；
* Unity 系：AI2‑THOR/CHORES。

特别是 **LIBERO**（130 个自然语言操控任务）与 **COLOSSEUM**（20 任务、14 种环境扰动），已成为 VLA 评测的“新标准”。

同时，SIMPLER 和 RoboArena 开始解决“仿真 vs 现实” 的 gap：

* **SIMPLER**：强调 real‑to‑sim 评测的高相关性设计。
* **RoboArena**：在 7 所大学真实机器人上进行分布式 pairwise 评测，构建更公平的排行榜。

### 6.2 真实机器人：从机械臂到人形

论文第 7 节详细罗列了 VLA 中常见的机器人平台：

* Manipulator：Franka、UR、KUKA、xArm、WidowX/ViperX、ALOHA 系列……
* Gripper / Hand：两指夹爪、四指 LEAP hand、五指 Shadow hand 等；
* Mobile：LoCoBot、Hello Stretch、Google Robot、AgiBot G1 等；
* Quadruped：Unitree Go1/Go2、Spot、ANYmal；
* Humanoid：Fourier GR‑1、Unitree G1/H1、Booster T1 等。

这些平台上的代表应用包括：

* Shake‑VLA：机器人摇鸡尾酒；
* RoboNurse‑VLA：手术器械传递；
* TrackVLA/NaVILA：四足在野外导航；
* EgoVLA/GO‑1：家庭场景下的人形/四足操控。

### 6.3 安全与失败恢复：VLA 的现实考卷

作者在第 IX 节专门讨论了安全与故障恢复：

* 当前 VLA 很少显式处理意外人类出现、碰撞风险等安全场景；
* 多数系统缺乏系统性的**失败检测**和**重规划机制**；
* SAFE、Agentic Robot、LoHoVLA、FOREWARN 等开始用世界模型或层级架构来预测失败、触发恢复。

> 简单说，现在 VLA 还比较莽，要进工厂/医院/家庭，**安全与可控性，会成为下一个大主题**。

---

## 七、拿来主义的玩法

站在一个想做研究或产品的人角度，我觉得这篇综述可以直接变成几个非常实用的 checklist：

### 7.1 架构选型 checklist

根据论文图 4–6，可以为自己的项目做一个三步选型：

1. **任务属性**：短 vs 长时序、控制频率、有无复杂接触？
2. **数据类型**：有多少机器人轨迹？有无大量人类视频？有无 3D/触觉？
3. **算力预算**：训练与部署的 GPU 规模和实时性要求？

然后在七类 sensorimotor + 三类 world model + 三类 affordance 模型里挑组合，例如：

* 仓储拣选 + 机械臂 + 中低频控制 → VLM + 离散 action token（RT‑2/OpenVLA 风格）；
* 倒水/擦桌子 + 高速轨迹 → VLM + Flow Matching 头（π0）；
* 人形/四足 + 大量人类视频 → 世界模型 + 潜在动作（LAPA/UniVLA）+ VLM 头。

### 7.2 数据策略：NOT ONLY“多采点示教”

论文给了很多可以直接工程化的思路：

* 用人类 egocentric 视频 + 潜在动作学习扩充数据；
* 用 Stable Diffusion / 世界模型做 **视觉风格增强**，提升 domain generalization；
* 用 GroundingDINO + SAM + LLM 搭一套自动标注流水线，把“干净的小数据集合”扩展成“多标注的大数据”。

这几乎是一条现成的 **数据增值 pipeline**。

### 7.3 训练 recipe：如何不把预训练 VLM 训练废

作者明确推荐了**梯度隔离**和分阶段训练：

1. 预训练阶段：

   * 用人类视频 + 多机器人数据，训练世界模型/潜在动作和 VLA 主干；
   * 尽量冻结或部分冻结 VLM backbone，避免随机动作头梯度破坏已有表示。
2. 后训练阶段：

   * 在你的高质量机器人数据上，
   * 只训练动作头或用 LoRA 微调；
   * 如算力允许，再做有限次 full fine‑tune。

推理阶段，可以启用 RTC / VLA‑Cache / 层级早停等等小 trick，显著降低延迟。

### 7.4 背景知识

问了下GPT相关的概念，它推荐我顺带阅读以下背景知识，在这里贴一下。

* **Transformer & Diffusion/Flow Matching** 的基本原理；
* CLIP、SigLIP、DINOv2、BLIP‑2、LLaVA 这些 VLM/MLLM 的结构；
* 机器人运动学与控制接口（位置/速度/力控）；
* 行为克隆、DAgger、Diffusion Policy、Offline RL 等模仿/强化学习基础；
* 点云/体素/NeRF/高斯 Splatting 等 3D 表示。


