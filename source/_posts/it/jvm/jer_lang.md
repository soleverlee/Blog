---
title: Jer语言(1)：语法设计
date: 2021-01-05
categories:  
    - Programing
    - JVM
tags:
    - Antlr
    - JVM
    - Bytecode
---
最近准备实现一个基于JVM的新语言"Jer"，一开始想先实现一个Hello world，然后逐步再朝上面添加新的功能；后来觉得还是需要先把这个语言的语法层面大致设计好再动手才行。本身是出于好玩的一个目的，但是也的确希望这个语言有一些特点，而不是单纯换一个语法而已。在这个期间思考了很多，但一直没有想到自己满意的方法，姑且先按照现在的想法设计一版出来吧。

<!-- more -->

# 设计目标
我对这个语言有这些期望：

* 基于JVM平台，即最终通过代码编译生成class字节码
* 跟Java能够兼容（可以互相调用）
* 尽量简单，应该基本的数据类型、流程控制等，支持OO，但对于一些高级特性例如泛型、lambda等就不考虑了
* 依然是强类型的语言

# 语法设计
## 基本格式
每一个代码文件有且仅对应一个java的类或者接口。这个类或者接口的名字就是文件名，例如Hello.jer最终生成一个Hello.class，目前尚不确定是否一个文件最终需要生成多个类来实现某些功能，但尽可能不增加复杂度。

## 数据类型
数据类型与Java基本一致，对应到JVM的各个数据类型：

* Bool : JVM boolean
* Byte : JVM byte
* Short: JVM short
* Integer: JVM int
* Long: JVM long
* Float: JVM float
* Double: JVM double
* Char: JVM char
* Class: class type

## 变量

变量分为普通变量和常量，但不论哪种类型都必须在申明的时候赋予初始值，这样不存在null的情况。
```lisp
Bool x -> true
Float f -> 3.1415926
String msg -> "Hello world!"
Person me -> Person("Riguz")

const Float PI -> 3.1415926
```

## 方法
在Jer中方法分为过程(process)和函数(function)，过程即没有返回值的方法；函数即有返回值的方法。

```lisp
// Hello.jer
process sayHello -> {
    println("Hello world")
}

process sayHelloTo(Person someone) -> {
    String msg -> "Hello" + someone__name
    System__out::println(msg)
}
```

而函数是具有返回值的，

```lisp
function<Integer> sum(Integer a, Integer b) -> {
    return a::add(b)
}

function<String> buildErrorMsg(Integer code, String desc) -> {
    StringBuilder sb -> StringBuilder()
    sb => sb::append(code::toString())
    sb => sb::append("\n")
    sb => sb::append(desc)

    return sb::toString()
}
```

## 类
每一个源文件对应到一个类或者多个类。其中可以包含：

* program 对应一个无状态的类
* abstract 即对应到Java的接口
* type 对应到一个有状态的类

```lisp
program Hello {
    const String MESSAGE = "Hello world!"

    process sayHello(String name) -> {
        println(buildMessage(name))
    }

    function<String> buildMessage(String name) -> {
        return "Hello ${name}"
    }
}
```

而对于有状态的类，则按如下方式进行编写：

```lisp

abstract Animal {
   name -> String
   age  -> Integer

   run      -> ()
   sayHello -> ( -> String)
   sayHelloTo -> (friend -> Animal)
}

type Person {
    String name -> ""
    Integer age -> 0

    new(String n, Integer a) -> {
        name => n
        age => a
    }
}
```

```lisp
// Animal.jer

abstract Animal {
    String name
    function<Integer> getAge()
}

// Dog.jer
type Dog is Animal {
    Integer age

    new(String n, Integer a) {
        name => n
        age => a
    }

    finction<Integer> getAge() -> {
        return age
    }
}
```