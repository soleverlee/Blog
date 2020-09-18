---
title: OAuth/JWT
date: 2020-09-17
categories:  
    - Programing
    - Security
tags:
	- OAuth
	- OAuth2.0
	- JWT
---
最近有一个问题一直比较困惑，起因是我们有一个React的应用使用OAuth进行权限验证，而我之前的实践通常是基于Token的权限验证（即通过用户名和密码获取JWT Token），那么这两种方式究竟有些什么差别？到底怎么做好一点？
<!-- more -->

# OAuth 2.0
## 什么是OAuth 

RFC6749对OAuth 2.0进行了介绍：

> The OAuth 2.0 authorization framework enables a third-party
   application to obtain limited access to an HTTP service, either on
   behalf of a resource owner by orchestrating an approval interaction
   between the resource owner and the HTTP service, or by allowing the
   third-party application to obtain access on its own behalf.  This
   specification replaces and obsoletes the OAuth 1.0 protocol described
   in RFC 5849.

从这个描述我们可以得出一些结论：

* OAuth 2.0 是一个授权（而不是“认证”）的框架
* OAuth 2.0 设计是为了授权一个第三方的应用访问受限的HTTP服务资源
* OAuth 2.0 出现取代了OAuth 1.0

那么，OAuth的出现时为了解决什么问题呢？对于一个典型的客户端请求服务器（受限）资源的场景，譬如一个网络相册服务，客户端需要将用户的认证信息（通常是用户名和密码）发送给服务端，这样才能保证有且仅有这个相册的owner能够访问该相册。现在假设有一个第三方的应用，比如一个什么打印机应用来帮用户打印照片，它也需要调用相册的服务来获取照片，那么显而易见的做法就是将用户的认证信息共享给第三方。但是这样做带来了一些问题：

* 第三方应用需要存储用户的认证信息，这样通常是不安全的
* 服务器需要能够支持密码认证
* 第三方获取到的权限可能比需要要大（比如也许打印机只需要访问一张照片，但是有了用户的认证信息实际上也可以访问到其他的照片，而无法进行限制），而且无法限制其使用时长
* 如果期望取消某一个第三方应用的授权，唯一的办法是修改密码，但假设有多个第三方应用那么都会收到影响

在OAuth中，客户端通过请求一个单独的access token来访问受限的资源，而token中包含了一些关于权限的描述信息（譬如范围、时效等）。这样在上面的打印照片的例子中，打印服务不需要知道用户的用户名和密码就可以获取到用户想打印的照片。

## OAuth 中的角色

OAuth中定义了四个角色：

* resource owner：资源所有者（通常是用户），可以授权应用访问其所有的受保护的资源
* resource server：资源服务器，可以根据access token获取受保护的资源
* client：代表resource owner及其授权、访问受保护资源的应用
* authorization server：通过对resource owner认证并获得其授权后，颁发access token的service

值得注意的是，这些角色并不要求是分开的实体，同一个server也可以拥有多个角色，例如resource server和authorization server可以是同一个服务。

## 授权流程

OAuth中定义了4种授权方式：

* Authorization Code
* Implicit
* Resource Owner Password Credentials
* Client Credentials

### Authorization Code Grant

客户端需要生成一个授权链接，包含如下参数：

* response_type: 必须为`code`
* client_id: 客户端标识
* redirect_uri(Optional): 重定向链接
* scope(Optional): 授权的scope
* state(Recommended):  用来防止跨站请求伪造

```lua
https://authorization-server.com/authorize?
  response_type=code
  &client_id=egHuu4oJxgOLeBzPAQ9sXg4i
  &redirect_uri=https://www.oauth.com/playground/authorization-code.html
  &scope=photo+offline_access
  &state=hCi3i1u67XgxqbO-
```

授权服务器收到请求后，对请求参数进行检查，如果无误则对用户进行认证，并取得用户授权；授权完成后，授权服务器重定向到请求中的redirect_uri上，并附加一些参数：

* code: 授权码，必须是在短期内失效（以降低泄漏后带来的风险），建议最长不超过10分钟；客户端对其应该只使用一次，否则授权服务器将拒绝请求并应该尽可能revoke之前通过该code颁发的token。
* state: 即请求中的state值

在上面的例子中，当用户授权之后，会跳转到：

```lua
https://www.oauth.com/playground/authorization-code.html?
  state=hCi3i1u67XgxqbO-
  &code=7RfqR_w09Ak75fZRlFCVL1ZtKUM3RR67Wd18I9tNZQwSANx9
```

客户端必须首先验证`state`是否与用户会话中的值一致（这个值可以保存在cookie、session或者通过其他方式保存），从而防止CSRF攻击。验证无误后，客户端需要使用这个code来换取token：

```lua
POST https://authorization-server.com/token

grant_type=authorization_code
&client_id=egHuu4oJxgOLeBzPAQ9sXg4i
&client_secret=p4NlH7i7o2JQJ9xpGdhG95eXWgX1I8teWYZo8pH5-vILSZXv
&redirect_uri=https://www.oauth.com/playground/authorization-code.html
&code=7RfqR_w09Ak75fZRlFCVL1ZtKUM3RR67Wd18I9tNZQwSANx9
```

其中：

* grant_type: 必须为`authorization_code`
* code: 上一步从认证服务器拿到的code
* redirect_uri: 如果拿code这一步有的话这里也必须一致
* client_id: 客户端标识，如果客户端不是public的话，需要对client进行认证(上面的例子中通过client_secret进行认证)

认证无误后，就可以换取到access_token了：

```json
{
  "token_type": "Bearer",
  "expires_in": 86400,
  "access_token": "Y80stMYZlsL6p6YSwwR16UiUueaV_BtuGVVtbmAj-b2Y_5u-yKtGqq2gWL2NY6ftKNMo6hin",
  "scope": "photo offline_access",
  "refresh_token": "eA-3mBXx8G9MLDzoKbJZNyV6"
}
```

![Authrozation code flow](/images/OAuth-authorization-code-flow.png)


### Authorization Code Grant with PKCE

上面一种流程通常推荐跟PKCE（Proof Key for Code Exchange）一起使用来增强安全，区别如下：

* 在跳转到authorization server之前，生成一个secret code verifier（43-128位，包含[a-zA-Z0-9-._~]的随机字符串 ）和challenge（通过 $Base64UrlEncode(SHA256(CodeVerifier))$ 生成）。如果不支持SHA256的话，则跟secret code verifier一致
* challenge在第一次获取code的时候回发送给服务端，服务端会保存challenge；而后在获取access token的时候，客户端需要发送code verifier，从而服务器可以重新进行一次hash来对比

例如，

```lua
code verifier = sz3-THfasVfv882QlbHeLsmBOdkEvgQXAYlce7MTeqzHG7Dk
code challenge = base64url(sha256(code_verifier)) 
               = pVx7RqTYem8RYTImvRC1M4EsoaOkeqYB6I4l5tnrPWg
```

客户端需要存储code verifier。然后在授权的URL中带上challenge参数：

```lua
https://authorization-server.com/authorize?
  response_type=code
  &client_id=egHuu4oJxgOLeBzPAQ9sXg4i
  &redirect_uri=https://www.oauth.com/playground/authorization-code-with-pkce.html
  &scope=photo+offline_access
  &state=G_SbnGGJEopEPN9A
  &code_challenge=pVx7RqTYem8RYTImvRC1M4EsoaOkeqYB6I4l5tnrPWg
  &code_challenge_method=S256
```

同样，授权服务器会重定向到请求的redirect_uri上并带上state和code

```lua
?state=G_SbnGGJEopEPN9A
&code=dS6-4QKtIsX6fNBPzxo4DffXTtgufG_MLbZntG6kQwoEKXUP
```

当客户端拿这个code换取token的时候，需要带上code_verifier。

```lua
POST https://authorization-server.com/token

grant_type=authorization_code
&client_id=egHuu4oJxgOLeBzPAQ9sXg4i
&client_secret=p4NlH7i7o2JQJ9xpGdhG95eXWgX1I8teWYZo8pH5-vILSZXv
&redirect_uri=https://www.oauth.com/playground/authorization-code-with-pkce.html
&code=dS6-4QKtIsX6fNBPzxo4DffXTtgufG_MLbZntG6kQwoEKXUP
&code_verifier=sz3-THfasVfv882QlbHeLsmBOdkEvgQXAYlce7MTeqzHG7Dk
```

授权服务器会依照这个code_verifier与之前的challenge进行比较，从而防止有人通过某些途径拿到autorization code之后使用它（因为hash是不可逆的，除非很难通过challenge得到原始的code_verifier）。

![OAuth PKCE](/images/OAuth-authorization-code-PKCE-flow.png)

### Implicit Grant

首先客户端需要生成一个授权的URL,例如：

```lua
https://authorization-server.com/authorize?
  response_type=token
  &client_id=egHuu4oJxgOLeBzPAQ9sXg4i
  &redirect_uri=https://www.oauth.com/playground/implicit.html
  &scope=photo
  &state=wjtEAa38CxUJbhKE
```

其中，response_type: 必须为token，其他参数与前面的授权流程一样。不同的是，服务端重定向的时候，带的参数为access token而不是code：

```lua
#access_token=cXoSzbih9UYXAZEQlN7gag4sWhvpP9J941OHOhrbXzGqlA_mzC-os3u3X4_g25I1x5epxRM_
  &token_type=Bearer
  &expires_in=86400
  &scope=photos
  &state=wjtEAa38CxUJbhKE
```

这种方式虽然简单，但是安全性是比较缺乏的，已经不被推荐使用：

> It is not recommended to use the implicit flow (and some servers prohibit this flow entirely) due to the inherent risks of returning access tokens in an HTTP redirect without any confirmation that it has been received by the client.

> Public clients such as native apps and JavaScript apps should now use the authorization code flow with the PKCE extension instead.

### Device Code

在这个流程中，客户端首先请求一个device code：

```lua
POST https://example.okta.com/device

client_id=https://www.oauth.com/playground/
```

然后拿到一个device code:

```json
{
  "device_code": "NGU5OWFiNjQ5YmQwNGY3YTdmZTEyNzQ3YzQ1YSA",
  "user_code": "BDWD-HQPK",
  "verification_uri": "https://example.okta.com/device",
  "interval": 5,
  "expires_in": 1800
}
```

其中的device code和user code是需要展示给用户的。

然后客户端需要一直去poll,

```lua
POST https://example.okta.com/token

grant_type=urn:ietf:params:oauth:grant-type:device_code
&client_id=https://www.oauth.com/playground/
&device_code=NGU5OWFiNjQ5YmQwNGY3YTdmZTEyNzQ3YzQ1YSA
```

当用户完成授权之后，可以得到一个token:

```json
{
  "token_type": "Bearer",
  "access_token": "RsT5OjbzRn430zqMLgV3Ia",
  "expires_in": 3600,
  "refresh_token": "b7a3fac6b10e13bb3a276c2aab35e97298a060e0ede5b43ed1f720a8"
}
```

### Resource Owner Password Credentials

这种方式即通过用户名和密码来直接获取access token，应用需要将用户的用户名和密码发送给授权服务器来获取token，已经不推荐使用。

### Client Credentials

将客户端的认证信息作为获取access token的凭证，通常用于访问一些客户端自身的一些资源（而不是用户的资源）。



Ref:

* [RFC6749 - The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749)
* [RFC7636 - PKCE extension](https://tools.ietf.org/html/rfc7636)
* [OAuth 2.0 Playground ](https://www.oauth.com/playground/)
* [OAuth 2.0 Security Best Current Practice](https://tools.ietf.org/html/draft-ietf-oauth-security-topics-15)
* [Common pitfalls for authentication using OAuth](https://oauth.net/articles/authentication/#common-pitfalls)