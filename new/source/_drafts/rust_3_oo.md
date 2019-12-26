
---
title: Rust(3) 面向对象编程
date: 2019-12-14
categories:  
    - Programing
    - Rust
---

# 结构体（Struct）

 类似于C语言，rust中可以使用结构体来封装一个对象：

## 普通结构体
 ```rust
struct User {
    name: String,
    age: i32,
}

fn main() {
    let age:i32 = 30;
    let usr = User {
        name: String::from("Riguz"),
        age,  // 如果名称相同可以省略，类似js
    };

    let usr1 = User {
        name: String::from("Solever"),
        ..usr // 确定不是从js抄过来的？噢，这里只有两个点，少了一个！
    };

    println!("user: {} {}", usr.name, usr.age);
}
 ```

## 命名元组（tuple struct)
如果你根本不关系结构体里面的属性名称，可以创建出像元组一样的结构，像这样：

```rust
struct Address(String, String);

let addr = Address(String::from("hubei"), String::from("Wuhan"));
```

虽然这样子很像元组，但是还是有区别的：

```rust
let t1:(i32, i32) = (100, 200);
let t2:(i32, i32) = (100, 200);
println!("{}", t1 == t2);       // true， 这两个是一样的类型，值也一样

```
如果是两个命名元组会怎么样呢？

```rust
let p = Point(100, 200);
let s = Size(100, 200);
println!("p = s ? {}", p == s);
```

这个编译都过不去：
```rust
10 |     println!("p = s ? {}", p == s);
   |                            - ^^ - main::Size
   |                            |
   |                            main::Point
   |
   = note: an implementation of `std::cmp::PartialEq` might be missing for `main::Point`
```
所以不同的命名元组类型不一样，可以利用这个实现一些特别的结构，例如“空结构”(Unit-Like Struct)，这个翻译很尴尬，想表达的意思就是说这个结构是个空的，没有任何属性，仅仅是用来区分不同的类型而已。

## 结构体方法
也可以像C结构体一样里面实现一些方法：

```rust
struct Animal {
    name: String,
    age: i32,
}

impl Animal {
    fn run(&self) {       // 等等，这不是python的搞法么...
        println!("{} is running!", self.name);
    }
}

impl Animal {             // 可以定义多个impl块
    fn say_hello() {      // 没有&self引用就相当于是静态方法了
        println!("hello");
    }
}

fn main() {
    let dog = Animal { name: String::from("dog"), age: 3 };
    dog.run();
    Animal::say_hello();
}
```
总结来说有以下几点：

* 传入`&self`为实例方法，否则就相当于静态方法了，在rust中称之为 Associated Function（可以用来定义工厂方法）
* 可以传入`&mut self`，如果需要更改自身的属性
* 如果有其他需要的参数，加到后面就好了

# 特质（Trait）
好吧，熟悉Scala的应该一看就知道是怎么回事，这就算是rust中的接口了。

```rust
trait Friend {
    fn say_hello(&self) -> String;
}

struct Animal {
    name: String,
    age: i32,
}


impl Friend for Animal {
    fn say_hello(&self) -> String {

        format!("I'm {}", self.name)
    }
}
``` 

trait可以有默认的实现，类似于Java中的default接口一般。trait可以作为参数使用，类似这样：

```rust
impl Animal {
    // 下面的写法于之等价：
    // fn say_hello_to_friend<T: Friend>(friend: T) {
    fn say_hello_to_friend(friend: impl Friend) {
        println!("{}", friend.say_hello());
    }
}
```
其中`<T: Friend>`被称之为边界，跟Java类似，如果定义多个泛型的话，可以这样：

```rust
fn raise<T: Friend + Nice, A: Good>(freind: T, animal: A) {
}
// 也可以使用where关键字写成下面的形式：
fn raise<T, A>(freind: T, animal: A)
    where T: Friend + Nice,
          A: Good {
}
```

# Rust中能够使用继承么？
rust文档中提到可以使用`derive`来自动生成一些预定义的接口，例如：

```rust
#[derive(PartialEq, PartialOrd)]
struct Centimeters(f64);
```

看着有点像是继承来着，但找遍了文档也没发现可以像其他编程语言一样来定义基类和继承。原来rust中不支持继承，最开始有一个`virtual struct`的方式，后来被去掉了。