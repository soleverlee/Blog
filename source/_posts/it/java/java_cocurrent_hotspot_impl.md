---
title: 理解Java并发(3)：Hotspot并发实现浅析
date: 2020-05-20
categories:  
    - Programing
    - Java
tags:
    - Hotspot
    - JVM
---




# CAS 无锁操作

## 实现机制

在Java中很多原子操作是通过CAS实现的，是一种无锁的方式，比如AtomicIntger的自增操作：

```java
public class AtomicInteger extends Number implements java.io.Serializable {
    private static final long serialVersionUID = 6214790243416807050L;

    // setup to use Unsafe.compareAndSwapInt for updates
    private static final Unsafe unsafe = Unsafe.getUnsafe();
    private static final long valueOffset;

    static {
        try {
            valueOffset = unsafe.objectFieldOffset
                (AtomicInteger.class.getDeclaredField("value"));
        } catch (Exception ex) { throw new Error(ex); }
    }

    private volatile int value;
    // ...
    public final int getAndIncrement() {
        return unsafe.getAndAddInt(this, valueOffset, 1);
    }
    // ...
}

```
这里的操作调用了Unsafe类来实现，而这个Unsafe类里面的实代码是这样的：

```java
public final native boolean compareAndSwapInt(Object var1, long var2, int var4, int var5);
public final int getAndAddInt(Object var1, long var2, int var4) {
    int var5;
    do {
        var5 = this.getIntVolatile(var1, var2);
    } while(!this.compareAndSwapInt(var1, var2, var5, var5 + var4));
    return var5;
}
```

而最终是用到了native的方法compareAndSwapInt，这部分的源码可以在OpenJDK源码中找到，而最终是会调用到[CMPXCHG](https://www.felixcloutier.com/x86/cmpxchg)这样到CPU指令来完成CAS。

```c++
UNSAFE_ENTRY(jboolean, Unsafe_CompareAndSwapInt(JNIEnv *env, jobject unsafe, jobject obj, jlong offset, jint e, jint x))
  UnsafeWrapper("Unsafe_CompareAndSwapInt");
  oop p = JNIHandles::resolve(obj);
  jint* addr = (jint *) index_oop_from_field_offset_long(p, offset);
  return (jint)(Atomic::cmpxchg(x, addr, e)) == e;
UNSAFE_END
```

其中，源码位于：

* [openjdk8/unsafe.cpp](http://hg.openjdk.java.net/jdk8/jdk8/hotspot/file/tip/src/share/vm/prims/unsafe.cpp)
* [openjdk8/atomic.cpp](http://hg.openjdk.java.net/jdk8/jdk8/hotspot/file/tip/src/share/vm/runtime/atomic.cpp)

## ABA问题

使用CAS一个问题就是可能出现A-B-A问题，因为CAS到逻辑就是，假设更新到时候判断出值跟期望的一致那么就会进行更改；但实际值跟期望的一致并不能代表值没有发生过变化。可能的场景就是，值被改成别的然后又改回来了，就是从A-B，然后又变成A。

解决这个问题的思路在于，想办法标记出变化。通常的做法是利用版本号（而不是值），保证版本号每次都会变化。JDK中提供了AtomicStampedReference来解决A-B-A问题，实现如下：

```java
 public boolean compareAndSet(V   expectedReference,
                              V   newReference,
                              int expectedStamp,
                              int newStamp) {
     Pair<V> current = pair;
     return
         expectedReference == current.reference &&
         expectedStamp == current.stamp &&
         ((newReference == current.reference &&
           newStamp == current.stamp) ||
          casPair(current, Pair.of(newReference, newStamp)));
 }
```

# Hotspot synchronized锁机制

[openjdk8/unsafe.cpp](http://hg.openjdk.java.net/jdk8/jdk8/hotspot/file/tip/src/share/vm/oops/markOop.hpp)


32位虚拟机中对象头的结构：

```
//  32 bits:
//  --------
//             hash:25 ------------>| age:4    biased_lock:1 lock:2 (normal object)
//             JavaThread*:23 epoch:2 age:4    biased_lock:1 lock:2 (biased object)
//             size:32 ------------------------------------------>| (CMS free block)
//             PromotedObject*:29 ---------->| promo_bits:3 ----->| (CMS promoted object)
```

Java对象初始化的时候的header word有两种情况：

* 如果该类可以使用偏向锁，则对象包含thread id（初始化位0），biased_lock=1表示允许偏向
* 如果该类不可以使用偏向锁，则对象包含一个hash code，biased_lock被设置位0表示不允许偏向

## 轻量级加锁过程（thin lock）
对于不允许偏向的对象，当线程尝试给这个对象加锁的时候，步骤如下：

* 在当前线程的桢栈中创建一个lock record信息，保存对象的对象头和指针，然后尝试通过CAS把这个lock record的地址设置到对象的header word中
* 如果CAS成功，那么当前线程成功获取到锁，这时候最后两位是00，表示对象被轻量级锁定
* 如果CAS失败，表明在这个过程中，其他线程也尝试在获取锁。这时候，JVM首先判断对象头中的地址是否指向当前线程桢栈，如果是那么线程已经获得锁，直接继续执行（？）如果



https://docs.huihoo.com/javaone/2006/java_se/JAVA%20SE/TS-3412.pdf
https://fliphtml5.com/tzor/bqxz/basic
https://www.artima.com/insidejvm/ed2/index.html
[OpenJDK Wiki - Synchronization](https://wiki.openjdk.java.net/display/HotSpot/Synchronization)
https://www.zhihu.com/question/53826114