---
title: "opensslコマンドでSNIな証明書をチェックする"
slug: openssl-sni
date: 2014-06-02T20:46:00+09:00
comments: true
categories: 
  - openssl
---

あるサーバの証明書のCNをチェックしようとして、opensslコマンドで確認すると想定と違うCNが返ってくる何で! ということが起きて軽くはまってしまった。ブラウザで証明書確認すると問題ない。

<!--more-->

結論としてはサーバ証明書がSNIなやつであれば、`-servername`を付けるべし。だった。

~~~
$ openssl s_client -connect test.example.com:443 -servername test.example.com 2>&1 < /dev/null 
~~~
