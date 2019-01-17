---
title: B-Tree算法
date: 2018-12-18
categories:  
    - Programing
    - Algorithm
tags:
	- B-Tree
---
B-Tree(区别于二叉树)是一种平衡多叉搜索树。它的插入、搜索、删除、

```
         .7.16.
        /  |   \
.1.2.5.6 .9.12. .18.21.
```

<!--more-->
# B-Tree的定义

根据Knuth的定义^[https://en.wikipedia.org/wiki/B-tree]，${\displaystyle m}$阶的B-Tree有如下的特性：

#. 节点左边的元素都比它小，节点右边的元素都比它大
#. 每个节点最多有${\displaystyle m}$个子节点
#. 除了根节点之外，非叶节点^[没有孩子的节点]至少有${\displaystyle m/2}$个子节点
#. 如果根节点不是叶子节点则其至少有两个子节点
#. 包含${\displaystyle k}$个子节点的节点共有${\displaystyle k-1}$个键
#. 所有的叶子节点的高度相同

一般表示B-Tree有两种表示方法^[https://stackoverflow.com/questions/28846377/what-is-the-difference-btw-order-and-degree-in-terms-of-tree-data-structure]：

* B-Tree of order ${\displaystyle d}$ or ${\displaystyle M}$
* B-Tree of degree or ${\displaystyle t}$

## Kuath：B-Tree of Order ${\displaystyle d}$
其中${\displaystyle M=5}$ 表示每一个节点中*至多有5个子节点*；则有如下的特性：
$$
\begin{align}
&Max(children) = 5 \\
&Min(children) = ceil(M/2) = 3 \\
&Max(keys) = Max(children) - 1 = 4 \\
&Min(keys) = Min(children) - 1 = 2
\end{align}
$$

## CLRS: B-Tree of min degree ${\displaystyle t}$
而${\displaystyle t=5}$ 则定义了一个节点中*至少有5个子节点*
$$
\begin{align}
&Max(children) = 2t = 10 \\
&Min(children) = t = 5 \\
&Max(keys) = 2t -1 = 9 \\
&Min(keys) = t - 1 = 4
\end{align}
$$

```
Knuth Order, k |  (min,max)  | CLRS Degree, t
---------------|-------------|---------------
     0         |      -      |        –
     1         |      –      |        –
     2         |      –      |        –
     3         |    (2,3)    |        –
     4         |    (2,4)    |      t = 2
     5         |    (3,5)    |        –
     6         |    (3,6)    |      t = 3
     7         |    (4,7)    |        –
     8         |    (4,8)    |      t = 4
     9         |    (5,9)    |        –
     10        |    (5,10)   |      t = 5
```

## B-Tree的高度^[http://staff.ustc.edu.cn/~csli/graduate/algorithms/book6/chap19.htm]
根据B-Tree的定义（Min Degree t)，如果Btree的高度为${\displaystyle h}$, 考虑最少含有多少个key, 则当：

* Root节点包含1个key
* 其他所有节点有且仅有有${\displaystyle t-1}$ 个key

这种场景时，所包含的key最少：

![Btree of height 3](/images/btree_height_3.gif)

设${\displaystyle S_{h}}$为Btree第h层的节点数，容易看出:

* 当${\displaystyle depth=0}$ 时，${\displaystyle S_{0}=1}$
* 当${\displaystyle depth=1}$ 时，${\displaystyle S_{1}=2}$
* 当${\displaystyle depth=2}$ 时，${\displaystyle S_{2}=2\cdot t}$
* 当${\displaystyle depth=h}$ 时，${\displaystyle S_{h}=2\cdot t^{h-1}}$

从${\displaystyle h=1}$开始，每一层的key数目即${\displaystyle S(key)_{h}=S_{h}\cdot (t-1)}$，根据等比数列求和公式即可算出总的key数目为：

$$
\begin{aligned}	 
Min(keys) &=1 + \sum_{i=1}^{h}{(t-1)\cdot 2t^{i-1}} \\
    &=1 + (t-1)\sum_{i=1}^{h}{2t^{i-1}} \\
    &=1 + 2(t-1)\sum_{i=1}^{h}{t^{i-1}} \\
    &=1 + 2(t-1){\Big(\frac{1-t^h}{1-t}\Big)} \\
    &=2t^h-1
\end{aligned}
$$

设${\displaystyle n}$ 为B-Tree的所有key数，则有：

$$
\begin{aligned}	
n &\geq Min(keys) \\
  &=2t^h-1
\end{aligned}
$$

可以得：

$$
h \leq log_{t}\frac{1+n}{2}
$$
More:

* [Graduate Algorithms CS673-2016F-11 B-Trees](https://www.cs.usfca.edu/~galles/cs673/lecture/lecture11.pdf)
