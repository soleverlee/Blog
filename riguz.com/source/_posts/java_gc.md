---
title: Java GC小结
date: 2019-03-03
categories:  
    - Programing
    - Java
tags:
	- Comment
---
![HotSpot JVM architecture](https://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/images/gcslides/Slide1.png){style="width:400px"}

<!-- more -->

# JVM Generations

![Hotspot Heap Structure](https://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/images/gcslides/Slide5.png){style="width:400px"}

Java的堆被划分成不同的区域：

* young generation：存放新创建的对象，当这个区域占满的时候，会触发minor GC，这时候存活的对象会被标记年龄，最终会移动到old generation。
* old generation：存放存活的比较久的对象。当yound generation存活的对象年龄到达设置的阈值后，就会被移动到这里来。当这个区域满了的时候，会触发major GC。
* permanent generation：存放一些JVM运行所需的元数据，例如类的信息等。full GC的时候也包括对这个区域的GC。
其中，minor GC和major GC都是Stop the World的，即当GC触发的时候，所有的程序线程都会停止等待GC完成。通常minor GC会比major GC快很多，因为major GC会遍历所有的存活对象。

其中，yound generation 又被划分成Eden space, Survivor Space1, Survivor Space2，其中Eden Space占了绝大部分的空间。当Eden space满的时候，GC 会将存活对象移动到其中一个Survivor Space中，两个Survivor Space是为了避免内存碎片，每次将存活的对象（Eden Space以及上一个Survivor Space）移动到另一个Survivor Space中。

![Mnior GC](https://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/images/gcslides/Slide9.png){style="width:400px"}

通过Java VisualVM和VisualGC插件可以很直观的看到GC的过程:
![Visual GC](/images/visualVM_GC.png)

```bash
java -Xmx50m \
-XX:-PrintGC \
-XX:+PrintHeapAtGC \
-XX:MaxTenuringThreshold=10 \
-XX:+UseConcMarkSweepGC \
-XX:+UseParNewGC TestGC
```

# Garbage Collectors

Argument        Description
--------------- ---------------------------------------------------------
-Xms	        Sets the initial heap size for when the JVM starts.
-Xmx	        Sets the maximum heap size.
-Xmn	        Sets the size of the Young Generation.
-XX:PermSize	Sets the starting size of the Permanent Generation.
-XX:MaxPermSize	Sets the maximum size of the Permanent Generation

* Serial GC:使用mark-compact算法进行GC，单线程的进行GC，适合单核CPU和在客户端允许的Java程序。
* Parallel GC(throughput collector):多线程进行GC
* Concurrent Mark Sweep (CMS) Collector: 在程序运行的时候并发的进行GC，以最大限度减少停止时间
* G1 Garbage Collector: CMS的替代品

* http://enos.itcollege.ee/~jpoial/allalaadimised/reading/Advanced-java.pdf
* https://codeahoy.com/2017/08/06/basics-of-java-garbage-collection/
* https://www.novatec-gmbh.de/en/blog/g1-action-better-cms/
* https://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html


