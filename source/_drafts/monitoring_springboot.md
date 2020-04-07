---
title: 使用Prometheus和Grafana监控SpringBoot应用
date: 2020-01-06
categories:  
    - Programing
    - MicroService
tags:
	- Docker
	- Prometheus
    - SpringBoot
    - Grafana
---
通常对于一个服务而言，如果想了解服务的健康状况，或者业务运行情况，我们就需要采取监控的措施了。对基于Springboot微服务的监控，已经有比较成熟的方案：Prometheus+Grafana。
<!-- more -->

# Micrometer

>Micrometer is a metrics instrumentation library for JVM-based applications..

简单来说，Micrometer就是一个通用的接口标准，更准确来说是一些Jar包，因此只能用于JVM的相关系统。它基本上可以类比于Slf4j，支持的监控平台很多，大致有这些：

```
AppOptics, Atlas, Azure Monitor, Datadog, Elastic, Graphite, Ganglia,
Humio, Influx, JMX, Kairos, New Relic, all StatsD flavors, SignalFx, 
Prometheus, Wavefront
```

对于我们需要使用的Prometheus而言，它与Grafana的集成相对于其他系统有以下的特点：

Prometheus         描述
------------------ ----------------------------
是否支持Tag         支持
Rate aggregation   Server-side
数据发布方式         服务端polling

## 基础概念
Micrometer中有一些比较常用的概念，了解它们可以帮助我们理解系统是如何工作的：

* Metrics(指标): 一些可度量的数据
* Meter（测量器): 一些`metrics`的集合
* MeterRegistry: 用来创建和保存`Meter`的注册器，所有支持的监控系统中都实现了它

# Springboot Actuator
实际上Springboot官方支持的Actuator已经提供了一些列的接口供我们使用，来获取系统的运行情况。只要添加了`spring-boot-starter-actuator`依赖之后，就可以通过`/actuator`路径得到一些列的系统信息：

```json
{
  "_links": {
    "self": {
      "href": "http://localhost:8080/actuator",
      "templated": false
    },
    "health": {
      "href": "http://localhost:8080/actuator/health",
      "templated": false
    },
    "health-path": {
      "href": "http://localhost:8080/actuator/health/{*path}",
      "templated": true
    },
    "info": {
      "href": "http://localhost:8080/actuator/info",
      "templated": false
    }
  }
}
```
这些是默认开启的，其实还有更多的选项，可以通过下面的设置来打开：

```property
management.endpoints.web.exposure.include=*
```



* [Monitoring Spring Boot Apps with Micrometer, Prometheus, and Grafana](https://stackabuse.com/monitoring-spring-boot-apps-with-micrometer-prometheus-and-grafana/)
* [Observability 3 ways: Logging, Metrics & Tracing](https://www.dotconferences.com/2017/04/adrian-cole-observability-3-ways-logging-metrics-tracing)