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
![Btree of order 5](/images/b-tree-order5.png)

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
根据B-Tree的定义，如果Btree的高度为${\displaystyle h}$, 则有：

* Root节点包含2个子节点
* 其他所有节点至少有${\displaystyle t}$ 个子节点

当除root外的其他节点含有的子节点数为${\displaystyle t}$ 时，这个树的节点最少，如图所示：

![Btree of height 3](/images/btree_height_3.gif)

* 当${\displaystyle h=0}$ 时，${\displaystyle S_{0}=n=1}$
* 当${\displaystyle h=1}$ 时，${\displaystyle S_{1}=n=2}$
* 当${\displaystyle h=2}$ 时，${\displaystyle S_{2}=n=2\cdot t}$

容易看出，${\displaystyle S_{n+1}=S_{n}\cdot t}$，即可得：
$$

$$

设${\displaystyle n}$ 为B-Tree的节点数，则有：

$$
n \geq 
$$