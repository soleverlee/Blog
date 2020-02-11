
---
title: LaTeX(3)：使用TikZ绘制图形
date: 2020-02-09
categories:  
    - TeX
tags:
  - LaTeX
  - TikZ
---

[PGF](https://www.ctan.org/pkg/pgf)是一个用来进行图形绘制的（底层）包，TikZ是利用这个包实现的用户友好的接口。所以通常在LaTeX中会用TikZ来进行矢量图形的绘制。

<!-- more -->

# 基本概念
## 基本语法
要使用tikz进行图形绘制只需要简单引入tikz宏包，并将绘制代码包含在一个上下文中就可以了:

```latex
\usepackage{tikz}

\begin{tikzpicture}
% ...
\end{tikzpicture}

```

同样如果希望把图片作为一个figure，那么再套一层:

```latex
\usepackage{graphicx}
\usepackage{tikz}

\begin{document}
	\begin{figure}[h]
	\begin{tikzpicture}
		\draw (0, 0) -- (1, 1);
	\end{tikzpicture}
	\caption{这是一条直线}
	\end{figure}
\end{document}
```

# 坐标系
默认情况下TikZ使用的是笛卡尔坐标系，即是这样：

<img src="/images/Latex-tikz-coordinates.png" style="width:400px">

另外，TikZ提供了一个缩放的选项，可以用来缩放图形，所以不必要担心绝对坐标的问题：

```latex
\begin{tikzpicture}[scale=0.5]
```

甚至还可以针对x轴和y轴分别设置缩放：

```latex
\begin{tikzpicture}[xscale=0.5, yscale=0.3]
```

<img src="/images/Latex-tikz-scale.png" style="width:400px">




# 图形绘制

## 直线

绘制直线：

```latex
\draw (0, 0) -- (1, 1);
```

绘制折线：

```latex
\draw (0, 0) -- (1, 1) -- (2, 2) -- (1, 0) -- (0, 3);
```

绘制背景网格:

```latex
\draw[help lines] (0,0) grid (3,3);
```
<img src="/images/Latex-tikz-lines.png" style="width:400px">

* [Draw pictures in LaTeX - With tikz/pgf](https://www.latex-tutorial.com/tutorials/tikz/)
* [A very minimal introduction to TikZ∗](http://cremeronline.com/LaTeX/minimaltikz.pdf)

