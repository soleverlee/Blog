---
title: TLA+ Basics
date: 2020-08-03
categories:  
    - Programing
    - Algorithm
tags:
	- TLA+
---

# 基础数学

* $\vee$ conjunction (and)
* $\wedge$ disjunction (or)
* $\Rightarrow$ implication (implies)
* $\equiv$ equivalence (is equivalent to)
* $\lnot$ negation (not)

集合

* $S \cap T$ S和T的交集
* $S \cup T$ S和T的并集
* $S \subseteq T$ S是否是T的子集
* $S \setminus T$ S中不包含在T中的元素集合

谓词逻辑(Predicate Logic)

* $\forall x \in S : F$ 对任意的S集合中的元素x，F都为true
* $\exists x \in S : F$ 存在x属于S， 使得F为true

可以得出：

$$
(\exists x \in S : F) \equiv \lnot(\forall x \in S: \lnot F)
$$

# TLA+

## TLA+ & PlusCal

PlusCal是一种用来描述算法的语言，可以用来替代伪代码，支持串行和并发的算法。


References:

* [List of logic symbols](http://jeiks.net/wp-content/uploads/2014/01/Table_of_logic_symbols.pdf)
* [List of LaTeX mathematical symbols](https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols)
* [](https://learntla.com/introduction/)
* [vscode-tlaplus](https://github.com/alygin/vscode-tlaplus/wiki/Getting-Started)
* [The PlusCal Algorithm Language](https://lamport.azurewebsites.net/pubs/pluscal.pdf)
