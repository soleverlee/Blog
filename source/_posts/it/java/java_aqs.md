---
title: 理解Java并发(5)：AQS
date: 2020-06-01
categories:  
    - Programing
    - Java
tags:
    - AQS
---
AQS(AbstractQueuedSynchronizer)是一个机遇FIFO等待队列实现锁的框架，用来实现诸如ReentrantLock、Semaphore等。

```java
public abstract class AbstractQueuedSynchronizer
extends AbstractOwnableSynchronizer
implements Serializable
```
<!-- more -->

# 基本用法

AQS在类里面维护了一个原子int类型的状态值（这个值的具体含义由子类去定义）。要使用AQS，推荐的做法是在在一个私有的内部类中去实现AQS，然后需要通过AQS本身提供的几个方法：

* `getState()`
* `setState(int)`
* `compareAndSetState(int, int)`

通过调用上述三个方法来维护同步状态，并实现这些方法：

* `tryAcquire(int)`：尝试获取状态
* `tryRelease(int)`：尝试释放状态
* `tryAcquireShared(int)`
* `tryReleaseShared(int)`
* `isHeldExclusively() `: 判断当前线程是否持有排它锁

而其他的同步操作、队列管理等，在AQS中已经完成了。

## 样例：实现简单的锁

在AQS的文档中给了一个基本的用法:实现一个不可重入的锁。首先需要的就是实现内部的类：
```java
class Mutex implements Lock, java.io.Serializable {
   private static class Sync extends AbstractQueuedSynchronizer {
     protected boolean isHeldExclusively() {
       return getState() == 1;
     }

     public boolean tryAcquire(int acquires) {
       assert acquires == 1; // Otherwise unused
       if (compareAndSetState(0, 1)) {
         setExclusiveOwnerThread(Thread.currentThread());
         return true;
       }
       return false;
     }

     protected boolean tryRelease(int releases) {
       assert releases == 1; // Otherwise unused
       if (getState() == 0) throw new IllegalMonitorStateException();
       setExclusiveOwnerThread(null);
       setState(0);
       return true;
     }
   }
   // ...
}
```
然后，加锁、解锁等操作都可以通过这个内部类来完成了：
```java
class Mutex implements Lock, java.io.Serializable {
   // ...
   private final Sync sync = new Sync();

   // 这里通过获取或者释放状态1（1表示锁定）来实现加锁和解锁的操作
   public void lock()                { sync.acquire(1); }
   public boolean tryLock()          { return sync.tryAcquire(1); }
   public void unlock()              { sync.release(1); }
   public Condition newCondition()   { return sync.newCondition(); }
   public boolean isLocked()         { return sync.isHeldExclusively(); }
   public boolean hasQueuedThreads() { return sync.hasQueuedThreads(); }
   public void lockInterruptibly() throws InterruptedException {
     sync.acquireInterruptibly(1);
   }
   public boolean tryLock(long timeout, TimeUnit unit) throws InterruptedException {
     return sync.tryAcquireNanos(1, unit.toNanos(timeout));
   }
 }
```
# 原理

AQS内部是使用的基于CLH队列的同步机制。

## acquire获取状态

* [The java.util.concurrent Synchronizer Framework](http://gee.cs.oswego.edu/dl/papers/aqs.pdf)