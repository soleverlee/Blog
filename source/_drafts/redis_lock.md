---
title: Redis基础知识
date: 2019-11-25
categories:  
    - Programing
    - Cache
tags:
	- Redis
---
准备花点时间系统性学习一下redis，特此记录。
<!-- more -->

# 数据类型

Redis是一个key-value的数据库，对于key而言就是字符串，但对于value实际上支持一些复杂的数据结构。redis中支持的数据类型有：

类型            说明
-------------- ------------------------------------------------------------------------------
String         Binary-safe字符串，意味着不会因为某些特殊字符而截断（例如`\0`)，最长支持512MB
List           字符串列表，按照插入的时间排序
Set            无序无重复的字符串集合
Sorted Set     有序的集合，每个元素有一个与之对应的`score`（浮点数）用来排序，可以操作一定范围的数据
Hash           表，一组k-v的组合，但键和值都必须为字符串
Bit array      也即bitmap，可以操作字符串中的单个值
HyperLog       
Stream         

# 过期时间

redis中可以支持设置数据的过期时间，有着如下的特性：

* 设置过期时间时可以使用秒或者毫秒，但在redis中精度是1毫秒
* 过期时间是被持久化了的，意味着如果redis停止重启之间的这段时间也是计算在内的

可以使用如下的命令来设置过期时间：

```bash
set foo bar
expire foo 5
set foo bar ex 5
ttl foo
```

