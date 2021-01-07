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

* bool : JVM boolean
* int8 : JVM byte
* int16: JVM short
* int32: JVM int
* int64: JVM long
* float: JVM float
* double: JVM double
* char: JVM char

## 方法
在Jer中方法分为过程(process)和函数(function)，过程即没有返回值的方法；函数即有返回值的方法。

```lisp
// Hello.jer

process main(args: String){
    (println "Hello world!")
}
```