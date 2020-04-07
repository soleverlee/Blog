---
title: 红黑树
date: 2020-03-18
categories:  
    - Programing
    - Algorithm
tags:
	- Red-black Tree
---
红黑树是一种自平衡的二叉树，每个节点都带有颜色，其定义如下：

* 节点要么是黑色，要么是红色
* 根节点是黑色
* 所有叶子节点（NIL节点，即空节点）都是黑色
* 每个红色节点必须有两个黑色的子节点，也就意味着不会有两个连续的红色节点
* 从任一节点到其每个叶子的所有简单路径都包含相同数目的黑色节点

<!--more-->

根据上面的约束，确保了红黑树有一个关键特性：

> 从根到叶子的最长可能路径不多于最短的可能路径的两倍长。