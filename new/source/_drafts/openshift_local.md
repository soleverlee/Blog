---
title: Openshift本地开发环境搭建
date: 2019-12-13
categories:  
    - Programing
    - Docker
tags:
	- Docker
    - Openshift
    - Kubernetes
---

在开发和测试的时候，如何在本地运行一个openshift的平台呢？目前大致有以下几种方式：

* 通过`oc cluster up`来启动一个包含Openshift平台的Docker镜像，但只支持Linux系统（Fedora, CentOS, RHEL)，Mac和Windows的oc只包含客户端
* 安装[Minishift](https://www.okd.io/minishift/)，创建一个单节点的Openshift环境
* 通过Virtualbox安装一个Openshift的集群环境
