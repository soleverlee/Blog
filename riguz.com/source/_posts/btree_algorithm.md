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