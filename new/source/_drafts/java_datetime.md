
---
title: Java中的时间
date: 2019-11-07
categories:  
    - Programing
    - Java
---
你如果以为，Java中谈到时间仅仅就意味着`java.util.Date`那就大错特错了，Java中的时间其实可以说五花八门，Java8发布后又增加了一些新的用来表示日期和时间的类，那么我们在构建应用程序的时候到底应该用哪个类来呢？彼此之间又有什么区别？

<!-- more -->

# 关于时间的表示
通常由于文化和地区的不同，世界上各个地方的人们对于时间的表达方式都不尽相同，比如在中国以前用农历和十二时辰来表示，而在西方是二十四小时制（巧合的是正好一个时辰能对应上两个小时，据称与”高合成数“有关）。那么在计算机领域，也有不同的表示方法，比较常见的有：

## Unix Timestamp
通过计算当前时间到Jan 01 1970(Unix Epoch)这一天（准确的说是00：00）经过的秒数来表示，例如 `1573090869`。

## ISO 8601
# Java中的时间类

>It is intended that ZonedDateTime or Instant is used to model data in simpler applications. This class may be used when modeling date-time concepts in more detail, or when communicating to a database or in a network protocol.


* [](https://stackoverflow.com/questions/30234594/whats-the-difference-between-java-8-zoneddatetime-and-offsetdatetime)
* (https://docs.oracle.com/javase/8/docs/api/java/time/OffsetDateTime.html)
* (https://docs.oracle.com/javase/8/docs/api/java/time/ZonedDateTime.html)