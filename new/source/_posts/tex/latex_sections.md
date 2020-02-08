
---
title: LaTeX(1)：章节和段落
date: 2020-02-07
categories:  
    - TeX
tags:
    - LaTeX
---

LaTeX适用于学术论文等的写作，在这类文章中一个很重要的部分就是段落和章节了。回想起当年使用Word写作的时候调整标题是何等的痛苦，那么在LaTeX中是怎样设置段落和章节的呢？
<!-- more -->

# 标题

通过下面的命令可以生成一个默认的标题：

```latex
\title{一种新型冠状病毒的防治方法}
\author{Dr. Riguz}
\date{2020-02-07}

\maketitle % 生成标题页
\newpage   % 分页
```
这样效果如下：

<img src="/images/Latex-title.png" style="width:400px">


# LaTeX段落层次
LaTeX中可以分成如下的几个部分：

* section：一级标题
* subsection：二级标题
* subsubsection：三级标题
* paragraph：段落
* subpragraph：二级段落

下面是一个例子：

<img src="/images/Latex-sections.png" style="width:400px">

对应的代码如下，非常简洁：

```latex
\section{背景}
首先简要介绍一下这个项目的背景。
\subsection{冠状病毒简介}
冠状病毒是一个大型病毒家族，包括引起普通感冒的病毒以及严重急性呼吸综合征冠状病毒和中东呼吸综合征冠状病毒。这一新病毒暂时命名为2019新型冠状病毒（2019-nCoV）。
\subsection{现有的防治方法}
\subsubsection{居家隔离法}
待在家里不出门。
\subsubsection{自我安慰法}
反正也死不了。
\section{新的防治方法}
实在编不下去了：
\paragraph{气功}
是一种中华民族祖传的神功。气功又可以分为两种：
\subparagraph{硬气功}
可以开山断石，金钟罩铁布衫。
\subparagraph{内功}
可以运行体内的真气激发一种神奇的力量运行于经络之上。
```

# 生成目录
想要生成目录页特别简单，一个命令就可以搞定：

```latex
\tableofcontents
\newpage
```

<img src="/images/Latex-contents.png" style="width:400px">


参考：

* [Using LaTeX paragraphs and sections](https://www.latex-tutorial.com/tutorials/sections/)
* [xelatex中文换行](http://yakeworld.myesci.com/node/1397)
* [LATEX Command Summary](https://www.ntg.nl/doc/biemesderfer/ltxcrib.pdf)