---
title: 手写一个JVM语言Jer(1)： Hello world
date: 2020-12-22
categories:  
    - Programing
    - JVM
tags:
  - JVM
  - Antlr
  - ASM
---
一直准备实现一个简单的编程语言，最近终于决定开始了。由于对JVM比较有兴趣，然后又希望深入研究一下JVM字节码，所以这门语言最终将会运行在JVM平台之上，类似Scala或者Koltin这种，通过编译器直接生成class文件。思路很简单，就是通过Antlr来解析语法树，然后通过ASM操作字节码，生成class文件。

<!-- more -->

# 基于JVM的新语言
这门语言我决定取名为Jer，"J"代表Java，"er"纯粹是个儿化音，请自行翻译成西南官话。没错，因为本身这门语言就是闹眼子玩的，所以取名也很随意了。虽然是好玩，但是设计这门语言我还是会认真来做的。

## Hello world

经过一番思考，由Jer语言实现的hello world长这样：

```rust
// Hello.jer
use java.lang.System.out.println;

fn main(args: string[]) {
    println("Hello, world");
}
```
如果你熟悉rust的话，你会发现这TM不就是rust的语法么... 没错，我也是设计完才发现的...暂时就只实现这个hello world，这里有这些考虑：

* 因为最终JVM class文件是面向对象的，也就是说必须要有一个类，并且main函数的签名必须为`public static void main(String[] args)`，所以最终的class文件就直接用文件名作为类名（这跟Koltin一样)
* `fn`用来定义静态方法，也会被放入类中作为类的静态方法
* 因为最终是构建在JVM平台之上的嘛，所以自然还是希望能够使用JDK的库，这里使用`use`来指定`println`方法，虽然有些啰嗦但是理论上应该可行
* 将`string`作为基本类型，将被编译为`java.lang.String`。

其等价的Java代码如下：

```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, world");
    }
}
```

## 其他特性
目前暂时没有考虑太多，如果有能力的话，那么这些特性是我希望引入的：

* mixin机制，类似dart那种
* 方法参数都是final的，如果有可能，设计一个完全不可变的类型
* 类似Koltin那种data class

# 实现
## 语法解析

使用Antlr可以很轻松的进行语法解析，实际上对于上面的hello world不需要太复杂的解析规则，但考虑到之后还要在上面进行修改，所以稍微做的多了一点：

```lua
lexer grammar JerLexer;

@header { package com.riguz.jer.antlr; }

STRING   : 'string';
FUNC     : 'fn';
USE      : 'use';

IDENTIFIER  : [a-zA-Z_][a-zA-Z_0-9]*;

ASSIGN     : '=';
OPEN_PAREN : '(';
CLOSE_PAREN: ')';
OPEN_BRACE : '{';
CLOSE_BRACE: '}';
OPEN_BRACK : '[';
CLOSE_BRACK: ']';
SEMI       : ';';
COMMA      : ',';
COLON      : ':';
DOT        : '.';

STRING_LITERAL:     '"' (~["\\\r\n] | EscapeSequence)* '"';

fragment EscapeSequence
    : '\\' [btnfr"'\\]
    | '\\' ([0-3]? [0-7])? [0-7]
    | '\\' 'u'+ HexDigit HexDigit HexDigit HexDigit
    ;
fragment Letter
    : [a-zA-Z$_]                      // these are the "java letters" below 0x7F
    | ~[\u0000-\u007F\uD800-\uDBFF]   // covers all characters above 0x7F which are not a surrogate
    | [\uD800-\uDBFF] [\uDC00-\uDFFF] // covers UTF-16 surrogate pairs encodings for U+10000 to U+10FFFF
    ;
fragment Digits
    : [0-9] ([0-9_]* [0-9])?
    ;
fragment HexDigits
    : HexDigit ((HexDigit | '_')* HexDigit)?
    ;
fragment HexDigit
    : [0-9a-fA-F]
    ;
fragment LetterOrDigit
    : Letter
    | [0-9]
    ;

// comments
COMMENT      : '/*' .*? '*/'    -> channel(HIDDEN);
LINE_COMMENT : '//' ~[\r\n]*    -> channel(HIDDEN);
WS           : [ \t\r\n\u000C]+ -> channel(HIDDEN);
```

```lua
parser grammar JerParser;

@header { package com.riguz.jer.antlr; }
options { tokenVocab=JerLexer; }

compilationUnit
    : importDeclaration*
      methodDeclaration
      EOF
    ;
importDeclaration
    : USE qualifiedName ';'
    ;

methodDeclaration
    : FUNC IDENTIFIER formalParameters '{' methodBody '}'
    ;
methodBody
    : methodCall*
    ;
formalParameters
    : '(' formalParameterList? ')'
    ;
formalParameterList
    : formalParameter (',' formalParameter)*
    ;
formalParameter
    : IDENTIFIER ':' type
    ;
methodCall
    : IDENTIFIER '(' parameterList? ')' ';'
    ;
parameterList
    : expression (',' expression) *
    ;
expression
    : STRING_LITERAL
    ;
primitiveType
    : STRING
    ;
type
    : primitiveType ('[' ']')*
    ;
qualifiedName
    : IDENTIFIER ('.' IDENTIFIER)*
    ;

```

这样解析出来的语法树是这样的：

![Jer helloworld AST](/images/jer_helloworld_ast.png)

## 使用ASM生成字节码
在实现编译之前，有必要先了解一下怎么使用ASM生成字节码文件。实际上我们知道期望的java程序，其对应的字节码如下：

```lua
# javap -v Hello
# ...省略了其他部分
  public static void main(java.lang.String[]);
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=1, args_size=1
         0: getstatic     #2                  // Field java/lang/System.out:Ljava/io/PrintStream;
         3: ldc           #3                  // String Hello, world
         5: invokevirtual #4                  // Method java/io/PrintStream.println:(Ljava/lang/String;)V
         8: return
      LineNumberTable:
        line 3: 0
        line 4: 8
}
```
这里关键的就是一个main函数。对应的使用ASM库直接生成字节码的方式如下：

```java
public static void main(String[] args) throws IOException {
    ClassNode classNode = new ClassNode();
    classNode.version = V1_8;
    classNode.access = ACC_PUBLIC + ACC_FINAL;
    classNode.name = "Hello";
    classNode.superName = "java/lang/Object";

    MethodNode mainMethod = new MethodNode(ACC_PUBLIC + ACC_STATIC,
        "main",
        "([Ljava/lang/String;)V",
        null,
        null
    );
    classNode.methods.add(mainMethod);
    InsnList instructions = mainMethod.instructions;
    instructions.add(new FieldInsnNode(GETSTATIC,
        "java/lang/System",
        "out",
        "Ljava/io/PrintStream;"));
    instructions.add(new LdcInsnNode("Hello, world"));
    instructions.add(new MethodInsnNode(INVOKEVIRTUAL,
        "java/io/PrintStream",
        "println",
        "(Ljava/lang/String;)V"));
    instructions.add(new InsnNode(RETURN));
    ClassWriter writer = new ClassWriter(COMPUTE_FRAMES);
    classNode.accept(writer);
    byte[] bytes = writer.toByteArray();

    saveToFile("Hello.class", bytes);
}
```