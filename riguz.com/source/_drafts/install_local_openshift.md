---
title: 搭建Openshift本地环境
date: 2019-07-01
categories:  
    - Programing
    - Docker
tags:
	- OpenShift
	- Virtualbox
	- Docker
---
OpenShift是红帽基于Docker和Kubernetes的云开发平台即服务（PaaS）。而[OKD(The Origin Community Distribution of Kubernetes )](https://www.okd.io/)即Openshift的开源版本。在本机上搭建一套完整的Openshift环境较为麻烦，有以下几种方式：

* Running in a Container
* Run the All-In-One VM with Minishift
* 使用Virtualbox构建Openshift集群

<!-- more -->

# 使用Virtualbox构建Openshift集群

按照[安装文档](https://docs.openshift.com/container-platform/3.11/install/index.html)应该可以在本地搭建一个集群，但是纯手动安装的话比较复杂，幸好有[Openshift Vagrant](https://github.com/eliu/openshift-vagrant)这个项目可以帮助我们简单的构建出一个集群环境：

Node    IP         Role
------- ---------- ------------------
master  .101       node, master, etcd
node01  .102       node
node02  .103       node

安装起来也比较简单，总共分三步：

1.```vagrant up```启动虚拟机
2.```