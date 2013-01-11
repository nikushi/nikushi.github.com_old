---
layout: post
title: "capistrano-colorized-stream gemで虹色のログライフを。"
date: 2013-01-12 01:03
comments: true
categories: 
  - 'Ruby'
tags:
  - 'Capistrano'
  - 'Ruby'
  - 'gem'
---

1年前に書いた[Streaming Log With Capistrano](http://orihubon.com/blog/2012/02/09/streaming-log-with-capistrano/)というポストが巡り巡って[gem](https://github.com/sonots/capistrano-colorized-stream)で利用できるようになりました、というお話。


<blockquote class="twitter-tweet" data-in-reply-to="288609436531052544" lang="ja"><p>@<a href="https://twitter.com/sonots">sonots</a> だいぶ昔書いたのでいけてなコードですが、こんな感じでしょうか。<a href="http://t.co/nifOD1YA" title="http://orihubon.com/blog/2012/02/09/streaming-log-with-capistrano/">orihubon.com/blog/2012/02/0…</a></p>&mdash; Nobuhiro Nikushiさん (@niku4i) <a href="https://twitter.com/niku4i/status/288612474276691968" data-datetime="2013-01-08T11:45:50+00:00">1月 8, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


[@sonots](https://twitter.com/sonots/)さんがCapistranoの話題のツイートしてて、昔似たことをやったので過去のポストを教えてあげたところgemになった!

<blockquote class="twitter-tweet" lang="ja"><p>@<a href="https://twitter.com/niku4i">niku4i</a> gemにしてみましたよ！ <a href="https://t.co/Q2tjd0kj" title="https://github.com/sonots/capistrano-colorized-stream">github.com/sonots/capistr…</a></p>&mdash; そのっつ (SEO Naotoshi)さん (@sonots) <a href="https://twitter.com/sonots/status/289690981152989184" data-datetime="2013-01-11T11:11:26+00:00">1月 11, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[capistrano-colorized-stream](https://github.com/sonots/capistrano-colorized-stream) 

[@sonots](https://twitter.com/sonots/)さん仕事早い。

せっかくgemにしていただいたので僕はこれをネタにブログを書くことにしました。

せっかくだしコードを読んでどう変わったか確認しました。

<!-- more -->

``` ruby
alias_method :stream_without_color, :stream
alias_method :stream, :stream_with_color
```
  * 既存メソッド(`stream()`)の機能は残しつつ、alias_methodで上書くことができるんですね
  * 実は`alias`との違いがピンときていないのでまた別途

試してみた。
``` ruby
class A
  def hello
    'Hello!'
  end
end

class A
  def aisatsu
    'Konichiwa!'
  end
  alias_method :greet, :hello
  alias_method :hello, :aisatsu
end

A.new.hello # => "Konichiwa!" 
A.new.greet # => "Hello!" 
```
`A#hello`が日本語に変更しつつ、`A#greet`にてオリジナルの英語で挨拶することができました。



``` ruby
lines = out.split(/\r?\n/m, -1)
```
  * `/\n/`ではなく`/\r?\n/`と各とCRLFとLFをサポートする
  * splitの第2引数に負の値を与え、改行のみの行を空要素として配列を返す


```
def colorize_host(host)
  @colors ||= {}
  @colors[host] ||= String.colors[str2acsii(host) % String.colors.size]
  host.colorize(@colors[host])
end
```
  * Hashでインスタンス変数を用意してキャッシュさせ高速化

