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
每个输入 token \( x_i \) 经过线性变换，分别得到 Query \( Q_i \)，Key \( K_i \)，Value \( V_i \)：

\[
Q_i = x_i W_Q, \quad K_i = x_i W_K, \quad V_i = x_i W_V
\]

其中 \( W_Q, W_K, W_V \) 为可学习的权重矩阵。这些矩阵的维度通常为 \( d_k \times d \)（这里 \( d_k \) 是 Key 矩阵的维度）。

#### b. **计算注意力得分**：
通过 Query 和 Key 的点积计算每个 token 之间的相似性，接着通过 softmax 函数计算注意力权重：

\[
\text{Attention}(Q, K, V) = \text{softmax} \left( \frac{QK^T}{\sqrt{d_k}} \right) V
\]

这里的 \( \sqrt{d_k} \) 是缩放因子，用来防止点积值过大导致梯度消失或爆炸问题。

#### c. **多头注意力机制 (Multi-Head Attention)**：
为了让模型从不同的子空间中学习到不同的上下文信息，Transformer 使用多个不同的 Query、Key 和 Value 矩阵来进行多次自注意力计算。然后将各个头的输出拼接起来：

\[
\text{MultiHead}(Q, K, V) = \text{Concat}(\text{head}_1, \text{head}_2, ..., \text{head}_h)W_O
\]

每个头的输出 \( \text{head}_i \) 是通过单独的 Query、Key、Value 矩阵计算的注意力。最终拼接结果通过线性变换 \( W_O \) 进行整合。

### 2. **前馈神经网络 (Feed-Forward Network, FFN)**

每个注意力层的输出都会通过一个全连接前馈神经网络进行进一步处理。这个 FFN 通常包含两个线性变换和一个非线性激活函数：

\[
\text{FFN}(x) = \text{ReLU}(xW_1 + b_1)W_2 + b_2
\]

其中 \( W_1 \) 和 \( W_2 \) 是可学习的权重矩阵，\( b_1 \) 和 \( b_2 \) 是偏置向量。

### 3. **残差连接 (Residual Connection) 和层归一化 (Layer Normalization)**

为了避免梯度消失和加速模型的训练过程，Transformer 引入了残差连接和层归一化。每个子层的输入都会与输出相加，并通过层归一化：

\[
\text{LayerNorm}(x + \text{sub-layer}(x))
\]

这种设计使得模型可以更容易地优化，并在训练中保持稳定。

### 4. **位置编码 (Positional Encoding)**

由于 Transformer 结构不依赖 RNN，因此它无法直接从序列中提取位置信息。为了让模型感知序列中的顺序，Transformer 引入了位置编码（Positional Encoding）。最常见的固定位置编码使用正弦和余弦函数表示：

\[
PE_{(pos, 2i)} = \sin \left( \frac{pos}{10000^{2i/d}} \right), \quad PE_{(pos, 2i+1)} = \cos \left( \frac{pos}{10000^{2i/d}} \right)
\]

其中 \( pos \) 是序列中的位置，\( i \) 是维度索引。这样的位置编码允许模型在不同的频率上为每个位置引入唯一的表示。

### 5. **编码器-解码器架构 (Encoder-Decoder Architecture)**

Transformer 通常由堆叠的多个编码器和解码器层组成。编码器负责接收输入并生成上下文表示，解码器则利用编码器的输出来生成目标序列。每个编码器和解码器的具体组成如下：

#### a. **编码器 (Encoder)**：
- 每个编码器层包含两个子层：多头自注意力机制和前馈神经网络。
- 经过多个编码器层后，输入序列的上下文表示被生成，并用于解码器阶段。

#### b. **解码器 (Decoder)**：
- 解码器与编码器类似，但在多头注意力机制的基础上，多了一个对编码器输出的注意力机制。
- 解码器还使用遮掩（masking）机制，确保模型只关注已生成的部分，而不是未来的 token。


### 6. **掩码机制 (Masking Mechanism)**

掩码在 Transformer 中是一个重要的概念，特别是在解码器中，它确保模型只处理已生成的部分，避免将未来信息泄露给当前步骤。掩码主要分为两种：

- **填充掩码 (Padding Mask)**：用于忽略序列中的填充部分（padding tokens），以避免这些无关信息影响模型的计算。
- **未来掩码 (Future Mask or Look-ahead Mask)**：应用于解码器，防止模型在训练时看到未来的 tokens。未来掩码会将位于当前位置之后的 tokens 的注意力分数置为 -∞。

#### 掩码代码实现：
```python
def create_padding_mask(seq):
    # 对填充部分生成掩码，标记为 0 的部分是需要被掩盖的
    mask = (seq == 0).float().unsqueeze(1).unsqueeze(2)
    return mask  # (batch_size, 1, 1, seq_len)

def create_future_mask(size):
    # 创建下三角矩阵，阻止模型访问未来的 token
    mask = torch.tril(torch.ones(size, size)).unsqueeze(0).unsqueeze(1)
    return mask  # (1, 1, seq_len, seq_len)
```

### 7. **解码器层 (Decoder Layer)**

解码器层与编码器层类似，但除了自注意力外，还多了一个对编码器输出的交叉注意力（Encoder-Decoder Attention），用于捕捉输入序列和生成序列之间的关系。

#### 解码器层代码实现：
```python
class DecoderLayer(torch.nn.Module):
    def __init__(self, d_model, num_heads, d_ff, dropout=0.1):
        super(DecoderLayer, self).__init__()
        self.self_attn = MultiHeadAttention(d_model, num_heads)
        self.cross_attn = MultiHeadAttention(d_model, num_heads)
        self.ffn = FeedForward(d_model, d_ff, dropout)
        self.norm1 = torch.nn.LayerNorm(d_model)
        self.norm2 = torch.nn.LayerNorm(d_model)
        self.norm3 = torch.nn.LayerNorm(d_model)
        self.dropout = torch.nn.Dropout(dropout)

    def forward(self, x, enc_output, tgt_mask=None, src_mask=None):
        # 自注意力机制，防止未来信息泄露
        attn_output = self.self_attn(x, x, x, tgt_mask)
        x = x + self.dropout(attn_output)
        x = self.norm1(x)
        
        # 交叉注意力机制，使用编码器的输出
        attn_output = self.cross_attn(x, enc_output, enc_output, src_mask)
        x = x + self.dropout(attn_output)
        x = self.norm2(x)
        
        # 前馈网络
        ffn_output = self.ffn(x)
        x = x + self.dropout(ffn_output)
        x = self.norm3(x)
        return x
```

### 8. **完整的 Transformer 模型**

编码器和解码器的组合构成了完整的 Transformer 模型。在生成任务（如机器翻译）中，解码器通过接收编码器的上下文信息以及之前生成的 token 来生成新 token。通过堆叠多个编码器层和解码器层，模型可以捕捉更加复杂的上下文信息。

#### Transformer 模型代码实现：
```python
class Transformer(torch.nn.Module):
    def __init__(self, src_vocab_size, tgt_vocab_size, d_model, num_heads, num_layers, d_ff, dropout=0.1):
        super(Transformer, self).__init__()
        self.encoder = torch.nn.ModuleList([EncoderLayer(d_model, num_heads, d_ff, dropout) for _ in range(num_layers)])
        self.decoder = torch.nn.ModuleList([DecoderLayer(d_model, num_heads, d_ff, dropout) for _ in range(num_layers)])
        self.src_embed = torch.nn.Embedding(src_vocab_size, d_model)
        self.tgt_embed = torch.nn.Embedding(tgt_vocab_size, d_model)
        self.positional_encoding = PositionalEncoding(d_model)
        self.fc_out = torch.nn.Linear(d_model, tgt_vocab_size)
        self.dropout = torch.nn.Dropout(dropout)

    def forward(self, src, tgt, src_mask=None, tgt_mask=None):
        src = self.src_embed(src)
        src = self.positional_encoding(src)
        for layer in self.encoder:
            src = layer(src, src_mask)

        tgt = self.tgt_embed(tgt)
        tgt = self.positional_encoding(tgt)
        for layer in self.decoder:
            tgt = layer(tgt, src, tgt_mask, src_mask)
        
        output = self.fc_out(tgt)
        return output
```

### 9. **模型训练和优化**

Transformer 模型的训练涉及到使用损失函数（例如交叉熵损失）以及优化器（通常是 Adam）。此外，学习率调度器（如 `warmup_steps`）是 Transformer 成功训练的关键，因为它可以逐步增大学习率，防止模型在初始阶段震荡过大。

#### 学习率调度器代码实现：
```python
class NoamOpt:
    def __init__(self, d_model, warmup, optimizer):
        self.optimizer = optimizer
        self.warmup = warmup
        self.d_model = d_model
        self._step = 0
        self._rate = 0
    
    def step(self):
        self._step += 1
        rate = self.rate()
        for p in self.optimizer.param_groups:
            p['lr'] = rate
        self._rate = rate
        self.optimizer.step()
    
    def rate(self, step=None):
        if step is None:
            step = self._step
        return (self.d_model ** -0.5) * min(step ** -0.5, step * self.warmup ** -1.5)
```

### 10. **性能优化**

除了学习率调度器，以下是一些 Transformer 优化技巧：
- **混合精度训练 (Mixed Precision Training)**：通过减少部分计算的精度，可以加快训练速度，节省 GPU 内存。
- **模型并行化**：多 GPU 环境下，可以将模型和计算并行化，进一步提升训练效率。
- **梯度裁剪 (Gradient Clipping)**：防止梯度爆炸，使得训练更加稳定。

### 11. **Transformer 在不同任务中的应用**

Transformer 不仅在 NLP 领域中大放异彩，还在其他领域如图像处理（Vision Transformer, ViT）、强化学习和推荐系统中展现出强大性能。

#### a. **机器翻译任务**：
Transformer 最初的成功案例是机器翻译，通过编码器捕捉输入句子的上下文语义，并通过解码器生成目标语言的句子。

#### b. **文本生成任务**：
如 GPT 系列模型，基于 Transformer 架构，可以用于长文本生成、对话系统和代码生成等任务。

#### c. **图像处理 (Vision Transformer)**：
在计算机视觉任务中，Vision Transformer 将图像划分为小块，并通过 Transformer 捕捉图块之间的关系，从而进行图像分类、目标检测等任务。

---
### 12. **代码实现**

我们以 PyTorch 实现 Transformer 的核心模块为例。

#### a. **自注意力机制**代码实现：
```python
import torch
import torch.nn.functional as F

class ScaledDotProductAttention(torch.nn.Module):
    def forward(self, Q, K, V, mask=None):
        # 计算点积注意力得分
        attention_scores = torch.matmul(Q, K.transpose(-2, -1)) / torch.sqrt(K.size(-1))
        if mask is not None:
            attention_scores = attention_scores.masked_fill(mask == 0, -1e9)
        attention_probs = F.softmax(attention_scores, dim=-1)
        output = torch.matmul(attention_probs, V)
        return output, attention_probs
```

#### b. **多头注意力机制**代码实现：
```python
class MultiHeadAttention(torch.nn.Module):
    def __init__(self, d_model, num_heads):
        super(MultiHeadAttention, self).__init__()
        self.num_heads = num_heads
        self.d_k = d_model // num_heads
        
        self.W_q = torch.nn.Linear(d_model, d_model)
        self.W_k = torch.nn.Linear(d_model, d_model)
        self.W_v = torch.nn.Linear(d_model, d_model)
        self.fc = torch.nn.Linear(d_model, d_model)

    def forward(self, Q, K, V, mask=None):
        batch_size = Q.size(0)
        
        # 将 Q, K, V 分成 num_heads 个头
        Q = self.W_q(Q).view(batch_size, -1, self.num_heads, self.d_k).transpose(1, 2)
        K = self.W_k(K).view(batch_size, -1, self.num_heads, self.d_k).transpose(1, 2)
        V = self.W_v(V).view(batch_size, -1, self.num_heads, self.d_k).transpose(1, 2)
        
        # 计算每个头的自注意力
        output, attention_probs = ScaledDotProductAttention()(Q, K, V, mask)
        
        # 拼接所有头的输出并通过全连接层
        output = output.transpose(1, 2).contiguous().view(batch_size, -1, self.num_heads * self.d_k)
        output = self.fc(output)
        return output
```

#### c. **前馈神经网络**代码实现：
```python
class FeedForward(torch.nn.Module):
    def __init__(self, d_model, d_ff, dropout=0.1):
        super(FeedForward, self).__init__()
        self.fc1 = torch.nn.Linear(d_model, d_ff)
        self.fc2 = torch.nn.Linear(d_ff, d_model)
        self.dropout = torch.nn.Dropout(dropout)

    def forward(self, x):
        x = self.dropout(F.relu(self.fc1(x)))
        x = self.fc2(x)
        return x
```

#### d. **编码器层**代码实现：
```python
class EncoderLayer(torch.nn.Module):
    def __init__(self, d_model, num_heads, d_ff, dropout=0.1):
        super(EncoderLayer, self).__init__()
        self.self_attn = MultiHeadAttention(d_model, num_heads)
        self.ffn = FeedForward(d_model, d_ff, dropout)
        self.norm1 = torch.nn.LayerNorm(d_model)
        self.norm2 = torch.nn.LayerNorm(d_model)
        self.dropout = torch.nn.Dropout(dropout)

    def forward(self, x, mask=None):
        attn_output = self.self_attn(x, x, x, mask)
        x = x + self.dropout(attn_output)
        x = self.norm1(x)
        
        ffn_output = self.ffn(x)
        x = x + self.dropout(ffn_output)
        x = self.norm2(x)
        return x
```

#### e. **位置编码**代码实现：
```python
class PositionalEncoding(torch.nn.Module):
    def __init__(self, d_model, max_len=5000):
        super(PositionalEncoding, self).__init__()
        self.pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2) * -(torch.log(torch.tensor(10000.0)) / d_model))
        self.pe[:, 0::2] = torch.sin(position * div_term)
        self.pe[:, 1::2] = torch.cos(position * div_term)
        self.pe = self.pe.unsqueeze(0)

    def forward(self, x):
        return x + self.pe[:, :x.size(1)]
```

### 总结
Transformer 架构打破了 RNN 和 CNN 的局限性，凭借自注意力机制能够并行处理序列，并捕捉长距离依赖。其编码器-解码器结构，结合位置编码、多头注意力和前馈神经网络，使得它在自然语言处理任务中表现卓越。通过上述代码，我们可以更深入地理解其内部运作。