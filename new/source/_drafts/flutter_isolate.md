---
title: Flutter中使用Isolate
date: 2019-11-20
categories:  
    - Programing
    - Android
tags:
    - Flutter
    - Swift
    - Argon2
---



```
E/flutter (32016): [ERROR:flutter/runtime/dart_isolate.cc(808)] Unhandled exception:
E/flutter (32016): error: native function 'Window_sendPlatformMessage' (4 arguments) cannot be found
E/flutter (32016): #0      Window.sendPlatformMessage (dart:ui/window.dart:1133:9)
E/flutter (32016): #1      _DefaultBinaryMessenger._sendPlatformMessage (package:flutter/src/services/binary_messenger.dart:85:15)
E/flutter (32016): #2      _DefaultBinaryMessenger.send (package:flutter/src/services/binary_messenger.dart:129:12)
E/flutter (32016): #3      MethodChannel.invokeMethod (package:flutter/src/services/platform_channel.dart:309:51)
E/flutter (32016): <asynchronous suspension>
E/flutter (32016): #4      Argon2.argon2i (package:encryptions/src/argon2.dart:21:22)
E/flutter (32016): #5      Argon2Kdf.derive (package:ben_app/crypto/kdf.dart:14:25)
E/flutter (32016): <asynchronous suspension>
E/flutter (32016): #6      PasswordCredential.kdfCall (package:ben_app/crypto/credential.dart:42:10)
E/flutter (32016): #7      _startIsolate.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:308:17)
E/flutter (32016): #8      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:172:12)
```


* [flutter_isolate](https://pub.dev/packages/flutter_isolate)
* ['Window_sendPlatformMessage' (4 arguments) cannot be found](https://github.com/flutter/flutter/issues/26413)
* [](https://stackoverflow.com/questions/54127158/flutter-window-sendplatformmessage-4-arguments-cannot-be-found)
* (https://github.com/dart-lang/sdk/issues/35962)