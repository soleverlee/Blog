---
title: 红黑树
date: 2020-03-18
categories:  
    - Programing
    - Algorithm
tags:
	- JDK1.8
---
HashMap算是最常用的数据结构之一了，在JDK1.8中对HashMap又引入了红黑树对其进行了优化。在HashMap中底层是用数组进行存储的，当发生hash冲突之后会形成链表，如果链表里面数据过多则转换为红黑树，所以整体就是这样：

