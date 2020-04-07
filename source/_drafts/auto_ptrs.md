---
title: C++中的智能指针
layout: false
date: 2020-02-04
categories:  
    - Programing
    - C++
tags:
    - auto
---
在C++中内存管理一直是最头疼的一个问题，稍不注意就有可能出现内存泄漏或者访问到错误的内存地址上这种问题。以前读书的时候刚学会C++的动态内存管理是根本瞧不起类似`auto_ptr`这种智能指针的，觉得这样写没意思，没有自己手动`delete`来的舒服；最近在尝试用C++写一个Java类加载器的时候，遇到了很多问题，着实有些困扰，所以决定系统性地学习一下智能指针。

<!-- more -->

# 智能指针管理内存的原理

## 不使用智能指针

通常情况下，我们可以使用`new`操作符和`delete`操作符配合，将对象内存分配到堆上，并在不需要的时候进行释放。

```c++
Resource* resource = new Resource();
// ...其他操作
delete resource;

// or
Resource* resource = new Resource[3];
// ...其他操作
delete[] resource;
```
如果某一个`new`操作忘了或者是因为程序中出现了异常导致对应的`delete`操作没有能够得到执行，那么就会导致内存泄漏了。比如下面这样：

```c++
Resource *resources = new Resource[3];

Resource *notExisted = nullptr;
cout << "id:" << notExisted->getId() << endl; // 这里会出现异常

delete[] resources;
```

## RAII（Resource Application Immediately Initialize）

通常在C++中如果是类的成员变量需要动态分配的话，可以在析构函数中进行资源的释放，保证当类对象离开作用域的时候，不会发生内存泄漏。


# 智能指针
# `auto_ptr` (C++11)
# `unique_ptr` 
