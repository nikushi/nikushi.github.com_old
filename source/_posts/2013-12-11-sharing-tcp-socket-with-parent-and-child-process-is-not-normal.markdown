---
layout: post
title: "親プロセスと子プロセスでTCPソケットを共有したらどうなるか"
date: 2013-12-11 19:53
comments: true
categories: 
  - Linux
---

前回の[Redisクライアントでforkするときは子プロセスでrecoonectする](http://orihubon.com/blog/2013/12/11/reconnect-after-fork-redis-client-ruby/)の続き。では[fluent-logger-ruby](https://github.com/fluent/fluent-logger-ruby)だとどうなるの? ってことで社内の同僚に質問してみました。色々なところでも書かれてますし混ざるんですよね。以下のコードは書かない方が良いってこと。

<!-- more -->

### サンプルコード

``` ruby このコードは一見動くけどよくない
require 'fluent-logger'
log = Fluent::Logger::FluentLogger.new(nil, :host=>'localhost', :port=>24224)
log.post("myapp.access", {"agent"=>"foo"})     # socket(A) が確立される
fork do                                        # socket(A)は子プロセスにもコピーされる
  log.post("myapp.access", {"agent"=>"foo"})   # socket(A)に書き込む
end
```

### 質問してみた

社内のIRCでちらっと聞いてみたところ同僚から助言いただきました。

    18:36 nikushi: forkしてTCPソケットを親、子で使いまわすの
    18:38 sonots: 同じソケットを、並列で利用したら、混ざってることになるけど
    18:39 nikushi: ふむふむ
    ..snip..
    18:41 nikushi: ぼくがおもったのは、TCPのデータペイロードの中(つまりmsgpackのところ)
    18:41 nikushi: が壊れるのかなーとおもったけど。
    ..snip..
    18:47 sonots: RST 受け取ったとき、どのプロセスが close するの？
    18:48 sonots: ruby 的には Errno::ECONNRESET
    18:49 sonots: proc1 が close しようとする前に、proc2 がデータ送っちゃったりするでしょ？
    18:49 sonots: ということを言いたい
    18:50 hirose31: 親子で共用するの辞めたほうがいいんじゃないのかなｗ
    18:57 hirose31: 一般的にやるべきじゃないと思いますよ
    19:06 hirose31: APUEに書いてないかな。。
    19:11 hirose31: If both parent and child write to the same descriptor, 
          without any form of synchronization, such as having the parent 
          wait for the child, their output will be intermixed 
          (assuming it’s a descriptor that was open before the fork). 
          Although this is possible—we saw it in Figure 8.2—it’s 
          not the normal mode of operation.
    19:11 hirose31: だそうな
    19:11 hirose31: p232

APUEによると、可能ではあるが出力が混ざる、通常のオペレーションではない。という記述がありました。@hirose31++

またクライアントの実装によっては再接続処理で変になったり、意図しない挙動になりそうですね。

APUEことAdvanced Programming in the UNIX Environment 3rd Editionについては、(ひ)メモの[『詳細UNIXプログラミング』の原書『Advanced Programming in the UNIX Environment](http://d.hatena.ne.jp/hirose31/20130731/1375248744)に紹介がありますので興味がある人か買うといいですね。私もこの機会に買いました。

### まとめ

    19:08 sonots: TCPコネクション１本で並列処理する方法があれば、知りたい感はあります。
    19:08 nikushi: SPDY w
    19:13 sonots: まさにSPDY
    19:12 hirose31: まさにSPDY
    19:13 sonots: ふむふむ、それを想定したプロトコル設計にしないといけないわけか
    19:13 nikushi: きょうの結論!

@hirose31先生, @sonots ありがとうございました。以上!
