---
title: OAuth 2.0的一些问题
date: 2020-12-01
categories:  
    - Programing
    - Security
tags:
	- OAuth
	- OAuth2.0
  - OIDC
---
OAuth2或者OIDC是一个比较复杂的问题，但是很多人用的时候都是一知半解，所以出现一些不正确或者不建议的做法。
<!-- more -->

### Authentication与Authorization的区别

* Authentication指确认操作浏览器或者应用的人的确是其本人的过程
* Authorization是指授权一个已经认证的party权限的过程

在OpenID的标准中也有定义：

> Authentication: Process used to achieve sufficient confidence in the binding between the Entity and the presented Identity. 

### OAuth2为什么不能用来做认证（Authentication）？
OAuth2的`access_token`的实质是将用户的一些访问权限（scopes）代理给客户端。通过OAuth2客户端可以获取一个`access_token`，代表一个用户授权进行某些操作的凭证。客户端可以通过OAuth2的introspection endpoint来获取元数据，例如用户名等。虽然在OAuth2协议中，这个endpoint本身是给resource server验证token使用的，但实际上并没有限制说只有resource server可以访问。那么是否可以用OAuth来做认证呢？

但OAuth2设计access_token的本意是给资源服务器使用的。资源服务器根据其判断是否有权限访问资源，而并不关心client程序是谁。因此实际上access_token代表的是代理的用户权限，而不是用户本身。另外如果是client credential的授权流程的话。就根本没有用户存在了。

> They define mechanisms to obtain and use Access Tokens to access resources but do not define standard methods to provide identity information. Notably, without profiling OAuth 2.0, it is incapable of providing information about the authentication of an End-User.

### OpenID Connect与OAuth2的区别是什么？

> OpenID Connect implements authentication as an extension to the OAuth 2.0 authorization process. Use of this extension is requested by Clients by including the openid scope value in the Authorization Request. Information about the authentication performed is returned in a JSON Web Token (JWT) [JWT] called an ID Token (see Section 2). 

### 可以使用OAuth2 作为first-party的应用授权么？
OAuth2最初的设计初衷是为了授权第三方的应用去（有限地）访问资源服务器，而不需要得到用户的凭据。通常来讲，应用程序按照所有权可以分为first-party和third-party:

* first-party：如果应用跟授权服务器是被同一个组织，那么是个第一方应用
* third-party：如果应用跟授权服务器不属于同一个组织，而需要去访问受保护的资源，那么这个应用属于三方应用

# 实现细节
## OAuth2.0
### access_token的校验



## OIDC相关问题
### id_token可以当access_token使用么

id_token是由授权服务器颁发给client的，比如请求一个id_token的：
```
https://authorization-server.com/authorize?
  response_type=code
  &client_id=egHuu4oJxgOLeBzPAQ9sXg4i
  &redirect_uri=https://www.oauth.com/playground/oidc.html
  &scope=openid+profile+email+photos
  &state=sRROJ_iPTam39Dc7
  &nonce=eFRvo_n5ecyYU_Sv
```
最后得到的id_token是这样的：

```json
{
  "sub": "concerned-caracal@example.com",
  "name": "Concerned Caracal",
  "email": "concerned-caracal@example.com",
  "iss": "https://pk-demo.okta.com/oauth2/default",
  "aud": "egHuu4oJxgOLeBzPAQ9sXg4i",
  "iat": 1600674514,
  "exp": 1603266514,
  "amr": [
    "pwd"
  ]
}
```

这里`aud`即client的id，是可以被client所信任的。而



References:

* [Applications in Auth0](https://auth0.com/docs/applications)
* [A Guide To OAuth 2.0 Grants](https://alexbilbie.com/guide-to-oauth-2-grants/)
* [OpenID Connect FAQ and Q&As](https://openid.net/connect/faq/)
* [Authentication and Authorization](https://auth0.com/docs/authorization/authentication-and-authorization)
* [OAuth and authentication](https://stackoverflow.com/questions/48544500/oauth-and-authentication)
* [OAuth is Not Authentication](https://www.scottbrady91.com/OAuth/OAuth-is-Not-Authentication)
* [OpenID Connect Core 1.0 incorporating errata set 1](https://openid.net/specs/openid-connect-core-1_0.html)