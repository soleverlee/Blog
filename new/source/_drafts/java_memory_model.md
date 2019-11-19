---
title: Java内存模型
date: 2019-11-01
categories:  
    - Programing
    - Java
---

<!-- more -->

# 指令重排序（reordering)
Java 语义是允许编译器和CPU在保证不影响单个线程执行结果的前提下对指令进行重排序。目前大多数处理器都选择使用乱序执行(out-of-order execution)来提高程序的执行效率，在这种范式中，处理器处理器由输入数据的可用性来觉得执行的顺序，而不是由程序的原始数据决定，这样可以避免获取下一条程序指令所引起的处理器等待，取而代之是执行下一条可以立即执行的指令。

假设有两个线程按照下图的指令执行：

```
Thread1   | Thread2
1: r2 = A | 3: r1 = B
2: B = 1  | 4: A = 2
```


* [JSR 133 (Java Memory Model) FAQ](http://www.cs.umd.edu/~pugh/java/memoryModel/jsr-133-faq.html)
* [The Java Memory Model](http://www.cs.umd.edu/users/pugh/java/memoryModel/)
* [Java内存访问重排序的研究](https://tech.meituan.com/2014/09/23/java-memory-reordering.html)
