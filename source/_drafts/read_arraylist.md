---
title: Java笔记:ArrayList
date: 2020-01-23
categories:  
    - Programing
    - Java
tags:
	- JDK1.8
---

读JDK1.8的源码时发现在ArrayList的构造函数中，发现有一个注释比较奇怪：

```java
public ArrayList(Collection<? extends E> c) {
    elementData = c.toArray();
    if ((size = elementData.length) != 0) {
        // c.toArray might (incorrectly) not return Object[] (see 6260652)
        if (elementData.getClass() != Object[].class)
            elementData = Arrays.copyOf(elementData, size, Object[].class);
    } else {
        // replace with empty array.
        this.elementData = EMPTY_ELEMENTDATA;
    }
}
```

> c.toArray might (incorrectly) not return Object[] (see 6260652)

# JDK-6260652 : (coll) Arrays.asList(x).toArray().getClass() should be Object[].class

原来这是一个JDK的BUG，