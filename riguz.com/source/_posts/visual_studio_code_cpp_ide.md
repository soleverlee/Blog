---
title: Visual Studio Code for C++ development on MacOS
date: 2018-12-18
categories:  
    - Programing
    - C++
tags:
	- Visual Studio Code
---
I've tried lot's of c++ IDEs on MacOS X, but none of them is as powerful as VS Studio on Windows. It's always hard for me to choose an IDE before I want to write some code, as it's called the *Selection phobia*. Generally we have the following choose:

* Vim/Emacs (I'm familiar with VIM but it's still not an easy way, for me)
* CodeBlocks (not good maintained on MacOS)
* CodeLite (it's a good choose!)
* XCode (I just don't like it, **Heavy** and ugly, can't get used to it)
* QT Creator (it's useful especially when developing Qt projects)
* Eclipse CDT
* NetBeans
* CLion (maybe the best c++ IDE on MaxOS, unfortunately does not have a free version)
* Textmate

Recently I tried Visual Studio Code, it's really a good choose for those who want to write some c++ code in a lightweight IDE.
<!--more-->
# Setup Visual Studio Code for C++ development

First we have to install [Visual Studio Code](https://code.visualstudio.com/), and a few extensions:

* C/C++
* Easy C++ projects

After installed those extensions, reload the editor to activate them. Now we can create a project:

* Choose File > Open folder to open a work directory
* Press F1 and type "c++", then select "Create new C++ project" command.

After the above steps a new project with Makefile is generated.

# Common usage
To debug or run the project, just click the button on the bottom status bar, it's easy:

![visual code studio snapshot](/images/vscode_debugging.png)

to run other commands, you could just press F1 and guess, for example, to format the code, just search "format" and then you got a choice.

Reference:

* [Developing C++ with Visual Studio Code](https://dev.to/acharluk/developing-c-with-visual-studio-code-4pb9)