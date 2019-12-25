---
title: 浅析Java中的InvokeDynamic
date: 2019-12-24
categories:  
    - Programing
    - Java
tags:
	- JVM
---
Java语言在被编译成class文件后，在class文件中，有专门的一个[“常量池”(Constant Pool)](https://docs.oracle.com/javase/specs/jvms/se7/html/jvms-4.html#jvms-4.4)区域来存储一些运行所需要的常量，包括一些写死的变量（比如定义一个字符串`String str = "Hello world"`以及一些符号（例如类和方法的的名称等）。在JVM(se7)规范中，有以下这些类型的常量：

```bash
CONSTANT_Class 	                         CONSTANT_Long 	          
CONSTANT_Fieldref 	                     CONSTANT_Double 	      
CONSTANT_Methodref 	                     CONSTANT_NameAndType 	  
CONSTANT_InterfaceMethodref              CONSTANT_Utf8 	          
CONSTANT_String 	                     CONSTANT_MethodHandle 	  
CONSTANT_Integer 	                     CONSTANT_MethodType 	  
CONSTANT_Float 	                         CONSTANT_InvokeDynamic 	  
```
大部分我们都可以顾名思义，知道是大概是干啥的，比如字符串啊，数字啊，方法名称之类的，但是可以注意到最后面一个是称之为`CONSTANT_InvokeDynamic`的常量，这个就有点陌生了。那么，这是一个什么样的常量？什么情况下会出现这个呢？

# `invokedynamic`指令
在JVM规范中有说，`CONSTANT_InvokeDynamic`常量是用来给`invokedynamic`指令指定一系列的参数的，那么有必要先了解一下`invokedynamic`这个指令了。这是Java 7引入的一个新指令，也是自Java 1.0以来第一次引入新的指令。

## Java7之前的`invoke-`指令
实际上，在此之前，已经有一些列的`invoke`开头的指令了：

* `invokevirtual`：用来调用类的实例方法，也就是最普遍的方式
* `invokestatic`：用来调用静态方法
* `invokeinterface`：用来调用通过接口调用的方法
* `invokespecial`：用来调用一些编译时就能够确定的，包括初始化(`<init>`)、类的私有方法，以及父类的方法(`super.someMethod()`)

拿一个简单的Java程序来看看是怎么回事：

```java
// Foo.java
public class Foo {
    public static void main(String[] args) {
        long now = System.currentTimeMillis();            //静态方法调用

        ArrayList<String> arrayList =  new ArrayList<>(); //构造函数将被调用
        List<String> list = arrayList;

        arrayList.add("hello");                           //调用类实例方法
        list.add("world");                                //通过接口调用
    }
}
```
通过`javac Foo.java && javap -v Foo`可以查看编译后生成的class文件，里面可以找到`invoke`相关的指令调用：

```
public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=5, args_size=1
         0: invokestatic  #2                  // Method java/lang/System.currentTimeMillis:()J
         3: lstore_1
         4: new           #3                  // class java/util/ArrayList
         7: dup
         8: invokespecial #4                  // Method java/util/ArrayList."<init>":()V
        11: astore_3
        12: aload_3
        13: astore        4
        15: aload_3
        16: ldc           #5                  // String hello
        18: invokevirtual #6                  // Method java/util/ArrayList.add:(Ljava/lang/Object;)Z
        21: pop
        22: aload         4
        24: ldc           #7                  // String world
        26: invokeinterface #8,  2            // InterfaceMethod java/util/List.add:(Ljava/lang/Object;)Z
        31: pop
        32: return
```
这样就比较好理解了，就跟我们平常调用函数一样，

* `System.currentTimeMillis()`静态函数的调用生成了`invokestatic`指令，这个指令的参数是静态方法（包含类名和方法名）
* `ArrayList`的构造方法调用生成了`invokespecial`指令，这里在`new`指令之后接着使用`invokespecial`指令来进行初始化操作
* 通过`ArrayList`的实例方法`add`调用生成了`invokevirtual`指令
* 而通过`List`接口的`add`方法调用生成了`invokeinterface`指令

尽管已经有了以上的四种指令，这些指令都有一个特点，那就是不管是什么方法，是静态还是实例方法，是子类还是父类的方法，在编译的时候已经能够确定出到底会调用到哪个方法了。有没有一种可能，就是我在编译的时候不能确定，而是在运行的时候才能确定呢？

## 鸭子类型（***Duck Typing***）

这就是所谓的[鸭子类型](https://zh.wikipedia.org/wiki/%E9%B8%AD%E5%AD%90%E7%B1%BB%E5%9E%8B)了，可能叫***Duck typing***其实更好理解一点，这个名称来源自[鸭子测试](https://zh.wikipedia.org/wiki/%E9%B8%AD%E5%AD%90%E6%B5%8B%E8%AF%95):

> “当看到一只鸟走起来像鸭子、游泳起来像鸭子、叫起来也像鸭子，那么这只鸟就可以被称为鸭子。”

![A humorous and apt representation of duck typing. Source: Mastracci, 2014.](https://devopedia.org/images/article/24/2998.1514520209.jpg)

我们知道，Java是一个强类型的语言，有很多的类型检查，比如你要调用某个接口，而被调用的对象没有实现这个接口那么是无法完成的。而Duck Typing正如上面这个图片形象的表示，我并不关心对象本身是个什么东西，而关心这个对象是否支持我所需要的所有属性或者方法。维基百科上的这个伪代码可以更直接的解释：

```
function calculate(a, b, c) => return (a+b)*c

example1 = calculate (1, 2, 3)
example2 = calculate ([1, 2, 3], [4, 5, 6], 2)
example3 = calculate ('apples ', 'and oranges, ', 3)
```

这些对象没有使用继承或者其他的方式相互发生联系，但只要它们支持`+`和`*`这两个方法，调用就可以成功。`invokedyanmic`指令从某种程度上来说，就是为了支持*Duck typing*。

看到这里可能细心的读者会注意到，咦，这东西看着好像`lambda`?

没错，事实上`lambda`的确是跟`invokedynamic`有关的，但有意思的是`lambda`是直到Java 8才推出（[JSR 335: Lambda Expressions for the JavaTM Programming Language](https://www.jcp.org/en/jsr/detail?id=335))。在此之前，是无法通过`javac`编译器生成包含这个指令的class的。`invokedynamic`指令是在[JSR 292: Supporting Dynamically Typed Languages on the JavaTM Platform](https://jcp.org/en/jsr/detail?id=292)中被引入的，可以注意到，原本是为了支持基于JVM的动态语言，并不是说要在Java中来做Duck typing，这样就比较合理了。

当然借助于一些字节码操作框架（例如[Javassit](http://www.csg.is.titech.ac.jp/~chiba/javassist/)、[ASM](http://asm.ow2.org/)等，是可以手动创造出含有`invokedynamic`的class的，不过会有些麻烦。


## lambda与invokedynamic
如果我们用支持`lambda`的Java 8是可以很容易的创建出一个包含`invokedynamic`常量和指令的class的，比如下面这个例子：

```java
import java.util.function.*;

public class Hello {

    public static void main(String[] args) {
        Supplier<String> welcome = () -> "Hello world!";
        System.out.println(welcome.get());
    }
}
```
当查看编译后的class文件会发现有下面的部分：

```
Constant pool:
   #1 = Methodref          #9.#20         // java/lang/Object."<init>":()V
   #2 = InvokeDynamic      #0:#26         // #0:get:()Ljava/util/function/Supplier;

public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=2, args_size=1
         0: invokedynamic #2,  0              // InvokeDynamic #0:get:()Ljava/util/function/Supplier;
```

一个就是在常量池中可以看到一个InvokeDynamic类型的常量，指向了`Supplier.get()`方法；另一个就是在`main`方法中对lambda的调用，被编译成`invokedynamic`指令。

# invokedynamic的机制
来研究一下`invokedyanmic`到底是怎么工作的吧。要了解它怎么工作的，我们先要知道编译生成的class文件中有些什么。刚我们看到，class文件中有两个部分与之相关，一个是常量池中的InvokeDyanmic信息，另一个是方法字节码中的`invokedynamic`指令调用。

## InvokeDynamic常量格式

InvokeDynamic常量的定义如下：

```c++
CONSTANT_InvokeDynamic_info {
    u1 tag;
    u2 bootstrap_method_attr_index;
    u2 name_and_type_index;
}
```

其中`bootstrap_method_attr_index`指向一个启动函数(BSM)的序号（在class文件中的另一个BootstrapMethods表中），`name_and_type_index`则表明方法的名称和描述。在上面的例子中，仅有一个BootstrapMethod:

```
BootstrapMethods:
  0: #22 invokestatic java/lang/invoke/LambdaMetafactory.metafactory:(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;
    Method arguments:
      #23 ()Ljava/lang/Object;
      #24 invokestatic Hello.lambda$main$0:()Ljava/lang/String;
      #25 ()Ljava/lang/String;
```


## invokedynamic指令格式


# JVM7 对lambda的支持

参考文章：

* [Invokedynamic - Java’s Secret Weapon](https://www.infoq.com/articles/Invokedynamic-Javas-secret-weapon/)
* [What's invokedynamic and how do I use it?](https://stackoverflow.com/questions/6638735/whats-invokedynamic-and-how-do-i-use-it)
* [Duck Typing - Wiki](https://zh.wikipedia.org/wiki/%E9%B8%AD%E5%AD%90%E7%B1%BB%E5%9E%8B)
* [Duck Typing](https://devopedia.org/duck-typing)
* [A First Taste of InvokeDynamic](http://blog.headius.com/2008/09/first-taste-of-invokedynamic.html)
* [Java 7: A complete invokedynamic example](https://www.javacodegeeks.com/2012/02/java-7-complete-invokedynamic-example.html)
* [你不知道Lambda的秘密和陷阱](https://my.oschina.net/lt0314/blog/3146028)