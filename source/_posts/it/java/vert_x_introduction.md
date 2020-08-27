---
title:  Vert.X(1)：简介
date: 2020-08-25
categories:  
    - Programing
    - Java
tags:
    - Vert.X
    - Series-Vert-X
---
最开始了解到Vert.X是在[Web Framework Benchmarks](https://www.techempower.com)中看到，性能超群的一个web框架，但说实话知名度不是特别高。

![Vert.X Benchmark](/images/Vert.x_Benchmark.png)

<!-- more -->
而官网介绍也谦逊的很，甚至都说自己不算一个web框架，而是一个"tool-kit"：

> Eclipse Vert.x is a tool-kit for building reactive applications on the JVM.

# 特点

Vert.x采取的是事件驱动的非阻塞异步响应模型，而不是类似Servlet一样为每一个连接分配一个新的线程。这样做的好处就是可以利用少量的线程处理很多的并发连接。而采取blocking IO的线程在等待IO操作完成的时候，线程会被挂起，而后唤醒。但是这个操作本身也是有一定的开销的，当线程数很大的时候这个开销就尤为明显。