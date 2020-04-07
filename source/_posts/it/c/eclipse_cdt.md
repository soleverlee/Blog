---
title: 使用Eclipse-CDT构建CMake项目
date: 2020-04-08
categories:  
    - Programing
    - C++
tags:
    - Eclipse
    - CMake
---
之前写过一篇文章[Visual Studio Code for C++ development on MacOS](../visual_studio_code_cpp_ide), 因为在Mac上一直没有找到免费且又比较好用的C++开发工具。但相比起Visual Studio而言，Visual Studio Code还是太难用了。最近Eclipse-CDT又更新了一下，所以再次体验了一下。

# 导入CMake工程
Eclipse CDT默认是支持CMake的，所以不用使用cmake生成eclipse的工程，直接就可以用。新建项目的时候是可以直接选用CMake项目的，那么，怎么导入一个现有的CMake工程呢？

实际上，并不能使用"Import"来导入，而是要用"File -> New -> C/C++ Project -> Empty or Existing CMake Project"，然后就可以选择现有项目，导入到Eclipse中去了。是不是很坑？

![Import project](/images/CDT_import_cmake_project.png)

# 运行Google Test测试
可以直接在Eclipse中运行Google Test，因为本身编译测试出来是一个应用，其实可以直接运行，但是eclipse集成的Unit Test可以让结果更好看一点：

![Run tests](/images/CDT_run_tests.png)

要运行这样的测试必须在Run Configuration中新建一个Unit Test的目标，并选择编译出来的test程序。

# Mac下字体设置
Eclipse在Mac下有一个问题就是默认的UI字体实在太小了，看着眼睛疼。

![默认字体](/images/CDT_smallfont.png)

有一个解决办法就是安装一个[TinkerTool](https://www.bresink.com/osx/TinkerTool.html)，然后设置“Help tags”字体的大小。参见这个[Bug](https://bugs.eclipse.org/bugs/show_bug.cgi?id=56558)。

![更改后的字体](/images/CDT_14px.png)