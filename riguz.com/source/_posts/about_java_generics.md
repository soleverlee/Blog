---
title: 关于 Java泛型
date: 2017-12-21
categories:  
    - Programing
    - Java
tags:
	- generics
---
## ？ wildcard(通配符）
使用 ? 修饰符可以用作类型转换，List<?> 意味着是一个未知类型的List，可能是`List<A>` 也可能是`List<B>`
```java
private final List<String> strList = Arrays.asList("Hello", "World!");
private final List<Integer> intList = Arrays.asList(1, 2, 3);
private final List<Float> floatList = Arrays.asList(1.1f, 2.1f, 3.1f);
private final List<Number> numberList = Arrays.asList(1, 1.0f, 3000L);

public void cast() {
    List<?> unknownList = null;
    unknownList = strList;
    unknownList = intList;
    unknownList = floatList;
    unknownList = numberList;

    for (int i = 0; i < unknownList.size(); i++) {
        // Number item = unknownList.get(i); wrong! 
        Object item = unknownList.get(i);
        System.out.println(item + "(" + item.getClass() + ")");
    }
}
/* output
1(class java.lang.Integer)
1.0(class java.lang.Float)
3000(class java.lang.Long)
*/
```
这里因为无法确定unknownList的类型，因此从中取出的元素只能用Object去标识，即使可以确切的知道每个元素的类型。那么，我们现在想设置List里面的值，怎么办？
```java
for (int i = 0; i < unknownList.size(); i++) {
    //Number item = unknownList.get(i); Error: incompatible types: capture#1 of ? cannot be converted to java.lang.Number
    Object item = unknownList.get(i);
    // unknownList.set(i, item); Error: java.lang.Object cannot be converted to capture#1 of ?
    System.out.println(item + "(" + item.getClass() + ")");
}
```
这样连Set 传入一个Object都不行！天呐。因此需要这样做：
```java
changeValueHelper(unknownList);
}

private static <T> void changeValueHelper(List<T> list){
    for(int i = 0 ; i < list.size(); i++){
        list.set(i, list.get(i));
    }
}
```

## extends VS super
实际上泛型仅仅是为了做一个编译时的检查，从逻辑上确保程序是类型安全的。假设我们有这样的类定义：
Object->Parent->T->Child
我们有这样几种写法：

* ```List<?>``` 代表一种未知类型的List，可能是```List<Object>```，也可能是```List<Child>```，都可以
* ```List<? extends T>``` 代表T或者T的子类的List，可以是```List<T>```，也可以是```List<Child> ```
* ```List<? super T>``` 代表T或者T的父类的List，可以是```List<T>，List<Parent>，List<Object>```

我们有一个事实就是，Child是一定可以转化T或者Parent的，但是一个T不一定能转化成Child，因为可能会是别的子类。
比如我们现在做两个列表的拷贝，
```java
public static <T> void copy(List dest, List src)
```
想实现从一个列表拷贝到另一个列表，比如
```java
List<Parent> parents;
List<T> ts;
List<Child> childs;
```
基于上面说的类的继承的事实，ts/childs显然是可以转化成parents的，但是ts无法确保能转化成childs。因此我们的拷贝方法要这样定义：
```java
public class Collections { 
  public static <T> void copy  
  ( List<? super T> dest, List<? extends T> src) {  // uses bounded wildcards 
      for (int i=0; i<src.size(); i++) 
        dest.set(i,src.get(i)); 
  } 
}
```
因为在desc.set()方法中，需要的是一个能够转化为T的对象的，src中<? extends T> 保证了src中的元素一定是一个T。
