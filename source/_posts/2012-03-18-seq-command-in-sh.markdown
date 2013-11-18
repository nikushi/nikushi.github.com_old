---
layout: post
title: "seqコマンド"
date: 2012-03-18 12:55
comments: true
categories: 
 - 'shell script'
---

seqというコマンドというのを知らなかったのでメモ。

<!--more-->

    $ for i in seq 1 10; do expr $i \* 2; done
    2
    4
    6
    8
    10
    12
    14
    16
    18
    20

Rubyだとこうやるのかな。
    (1..10).each { |i| puts i * 2 }
