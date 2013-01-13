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

gemにしていただいたので僕はこれをネタにブログを書くことにしました。

<!-- more -->



### コードを読んでみた

#### alias_method

``` ruby lib/capistrano/colorized_stream.rb 
alias_method :stream_without_color, :stream
alias_method :stream, :stream_with_color
```
  * alias_methodを使うと既存メソッドは残しつつ、alias_methodで上書くことができるんですね
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


#### String#split

``` ruby lib/capistrano/colorized_stream.rb 
lines = out.split(/\r?\n/m, -1)
```
  * `/\n/`ではなく`/\r?\n/`と各とCRLFとLFをサポートする
  * splitの第2引数に負の値を与え、改行のみの行を空要素として配列を返す。すると改行がどの位置にあるか気にしなくてもよくなる(!)。

この`split`の第2引数のようにRubyのコアクラスのAPIの知識に深ければ小さくコードが書ける実例だなとおもいました。
このあたりは[プログラミング言語 Ruby](http://www.amazon.co.jp/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0%E8%A8%80%E8%AA%9E-Ruby-%E3%81%BE%E3%81%A4%E3%82%82%E3%81%A8-%E3%82%86%E3%81%8D%E3%81%B2%E3%82%8D/dp/4873113946)の9章Rubyプラットフォームが充実してますね。難しいコードを書いたな....というときは標準のAPIで対応できないか、考え直してみるとよさそうですね。

