
---
title: ThreadPoolExecutor解析
date: 2019-10-28
categories:  
    - Programing
    - Java
---
使用多线程技术可以有效的利用CPU时间，在同一个时间内完成更多的任务，那么是不是线程越多就越好呢？
<!-- more -->

# 线程数的限制

## 操作系统的最大线程数
首先希望搞清楚的一个问题就是，到底我们可以创建多少个线程呢？在linux上，可以通过以下的方式查看系统的最大线程数限制：
```
# cat /proc/sys/kernel/threads-max
15734
# ulimit -v
unlimited
```
据说是按照这个公式计算出来的:
```c
max_threads = mempages / (8 * THREAD_SIZE / PAGE_SIZE);
```
在windows上也比较类似，总结来说就是，每个系统的最大线程数都不尽相同，不仅与系统有关还与内存大小以及用户的设置有关系。

## JVM限制

# ThreadPoolExecutor

ThreadPoolExecutor 是一个利用线程池技术实现的多任务处理器。
```java
public ThreadPoolExecutor(int corePoolSize,
                            int maximumPoolSize,
                            long keepAliveTime,
                            TimeUnit unit,
                            BlockingQueue<Runnable> workQueue) {
    this(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue,
            Executors.defaultThreadFactory(), defaultHandler);
}
```    

## 类继承关系



References:
* [Maximum number of threads per process in Linux?](https://stackoverflow.com/questions/344203/maximum-number-of-threads-per-process-in-linux)
* [Max Number of Threads Per Windows Process](https://eknowledger.wordpress.com/2012/05/01/max-number-of-threads-per-windows-process/)
* [Java: What is the Limit to the Number of Threads You Can Create?](https://dzone.com/articles/java-what-limit-number-threads)
