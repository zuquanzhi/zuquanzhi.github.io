---
title: Transformer架构初步
abbrlink: 15915
date: 2024-09-20 16:20:04
tags: Transformer
categories: 科研

cover: https://imgapi.jinghuashang.cn/random?22
---
### Transformer 架构及技术细节详解

Transformer 是近年来自然语言处理 (NLP) 和序列建模任务中最具影响力的神经网络架构。它通过**自注意力机制**替代了传统的 RNN (递归神经网络) 和 LSTM (长短期记忆网络)，并凭借其并行化计算和捕捉长距离依赖的能力，在机器翻译、文本生成、文本分类等任务中取得了显著的效果。

#### Transformer 的核心模块：

- **多头自注意力机制 (Multi-Head Self-Attention)**
- **前馈神经网络 (Feed-Forward Network, FFN)**
- **残差连接 (Residual Connection) 和层归一化 (Layer Normalization)**
- **位置编码 (Positional Encoding)**
- **编码器-解码器架构 (Encoder-Decoder Architecture)**

#### Transformer 的架构整体由两个主要部分组成：
- **编码器 (Encoder)**：由多个相同的编码器层组成，每一层包含一个多头自注意力模块和一个前馈神经网络模块。
- **解码器 (Decoder)**：与编码器类似，但有额外的一个注意力机制，用于对编码器的输出进行处理。

下面详细介绍各个组成模块。

### 1. **自注意力机制 (Self-Attention Mechanism)**

自注意力机制的核心目标是捕捉序列中的长距离依赖，通过为输入中的每个 token 分配不同的重要性权重。自注意力机制是 Transformer 中最关键的部分，它通过以下步骤实现：

#### a. **Query, Key, Value 矩阵计算**：
每个输入 token $\( x_i \)$ 经过线性变换，分别得到 Query $\( Q_i \)$，Key $\( K_i \)$，Value $\( V_i \)$：

$$
Q_i = x_i W_Q, \quad K_i = x_i W_K, \quad V_i = x_i W_V
$$

其中 $\( W_Q \)$, $\( W_K \)$, \$( W_V \)$ 是可学习的权重矩阵。这些矩阵的维度通常为 $\( d_k \times d \)$ （这里 $\( d_k \)$ 是 Key 矩阵的维度）。

#### b. **计算注意力得分**：
通过 Query 和 Key 的点积计算每个 token 之间的相似性，接着通过 softmax 函数计算注意力权重：

$$
\text{Attention}(Q, K, V) = \text{softmax} \left( \frac{QK^T}{\sqrt{d_k}} \right) V
$$

这里的 $\( \sqrt{d_k} \)$ 是缩放因子，用来防止点积值过大导致梯度消失或爆炸问题。

#### c. **多头注意力机制 (Multi-Head Attention)**：
为了让模型从不同的子空间中学习到不同的上下文信息，Transformer 使用多个不同的 Query、Key 和 Value 矩阵来进行多次自注意力计算。然后将各个头的输出拼接起来：

$$
\text{MultiHead}(Q, K, V) = \text{Concat}(\text{head}_1, \text{head}_2, \dots, \text{head}_h)W_O
$$

每个头的输出 \( \text{head}_i \) 是通过单独的 Query、Key、Value 矩阵计算的注意力。最终拼接结果通过线性变换 \( W_O \) 进行整合。

### 2. **前馈神经网络 (Feed-Forward Network, FFN)**

每个注意力层的输出都会通过一个全连接前馈神经网络进行进一步处理。这个 FFN 通常包含两个线性变换和一个非线性激活函数：

$$
\text{FFN}(x) = \text{ReLU}(xW_1 + b_1)W_2 + b_2
$$

其中 $\( W_1 \)$ 和 $\( W_2 \)$ 是可学习的权重矩阵，$\( b_1 \)$ 和 $\( b_2 \)$ 是偏置向量。

### 4. **位置编码 (Positional Encoding)**

由于 Transformer 结构不依赖 RNN，因此它无法直接从序列中提取位置信息。为了让模型感知序列中的顺序，Transformer 引入了位置编码（Positional Encoding）。最常见的固定位置编码使用正弦和余弦函数表示：

$$
PE_{(pos, 2i)} = \sin \left( \frac{pos}{10000^{2i/d}} \right), \quad PE_{(pos, 2i+1)} = \cos \left( \frac{pos}{10000^{2i/d}} \right)
$$

其中 $\( pos \)$ 是序列中的位置，$\( i \)$ 是维度索引。这样的位置编码允许模型在不同的频率上为每个位置引入唯一的表示。

### 6. **掩码机制 (Masking Mechanism)**

掩码在 Transformer 中是一个重要的概念，特别是在解码器中，它确保模型只处理已生成的部分，避免将未来信息泄露给当前步骤。掩码主要分为两种：

- **填充掩码 (Padding Mask)**：用于忽略序列中的填充部分（padding tokens），以避免这些无关信息影响模型的计算。
- **未来掩码 (Future Mask or Look-ahead Mask)**：应用于解码器，防止模型在训练时看到未来的 tokens。未来掩码会将位于当前位置之后的 tokens 的注意力分数置为 -∞。

如果还有其他部分需要格式化为 LaTeX，欢迎指出，我可以继续帮助你完成整个文档的调整。