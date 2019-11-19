
---
title: Java字节码初探
date: 2019-03-20
categories:  
    - Programing
    - Java
tags:
    - JVM
    - ASM
---

# Primitive types

Type     Length Signed Min                Max                Description
-------- ------ ------ -----------------  ------------------ -----------------------------
byte     1       ✓     ${-2^{7}}$          ${2^{7} - 1 }$
short    2       ✓     ${-2^{15}}$         ${2^{15} - 1 }$
int      4       ✓     ${-2^{31}}$         ${2^{31} - 1 }$ 
long     8       ✓     ${-2^{63}}$         ${2^{63} - 1 }$ 
float    4             
double   8         
char     2       ×     0                   65535

References:

* [Chapter 6. The Java Virtual Machine Instruction Set](https://docs.oracle.com/javase/specs/jvms/se9/html/jvms-6.html)
* [Introduction to Java Bytecode](https://dzone.com/articles/introduction-to-java-bytecode)
* [Bytecode basics](https://www.javaworld.com/article/2077233/bytecode-basics.html)
* [ava Language and Virtual Machine Specifications](https://docs.oracle.com/javase/specs/index.html)
* [Creating JVM language](http://jakubdziworski.github.io/categories.html#Enkel-ref)
* [very simple expression language demonstrating how to build a JVM byte code generating compiler](https://github.com/stephentu/calclang)