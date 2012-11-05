---
layout: post
title: "TEDの英文を取得する"
date: 2012-04-09 01:49
comments: true
categories: 
  - 'Ruby'
tags:
  - 'TED'
---

TEDのトークショーの内容をテキストデータで取得できるという話を聞きましたのでRubyで英文をprintするコードを書いてみました。

<!-- more -->

URLを叩くとJSONで返してくれるのでparseしてputsするだけでした。

{% gist 2338391 %}

[Matt Cutts: Try something new for 30 days](http://www.ted.com/talks/matt_cutts_try_something_new_for_30_days.html) という有名なTEDのトークをひとまずdumpしてみました。

    $ ./teddump.rb
    A few years ago,

    I felt like I was stuck in a rut,

    so I decided to follow in the footsteps

    of the great American philosopher, Morgan Spurlock,

    and try something new for 30 days.

    The idea is actually pretty simple.

    Think about something you've always wanted to add to your life

    and try it for the next 30 days.

    It turns out, 

    30 days is just about the right amount of time

できました。

ちなみに、idはページ中のHTMLのdata-idというパラメタから取得しないと分かりません。nokogiriとかでスクレイピングする方法があるようです。

以下を参考にしました。

* [Parsing and Converting TED Talks JSON Subtitles](http://stackoverflow.com/questions/1955618/parsing-and-converting-ted-talks-json-subtitles)
* [TEDの英語原稿を取得する - ギークを夢見るじょーぶん男子 ](http://d.hatena.ne.jp/meganii/20120320/1332214416)

