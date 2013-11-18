---
layout: post
title: "前日日付のファイル名でローテートし圧縮するlogrotateの設定例"
date: 2013-03-07 15:57
comments: true
categories: 
  - "Linux"
tags:
  - "logrotate"
---

ファイル名を前日の日付でローテートする方法をメモします。

<!--more-->

logrotateでdateextを設定するとローテートしたファイルに日付を含めることができます。しかし、00:00-早朝のあたりでlogrotateを実行するとローテートされた内容は前日分のログなのに日付は実行時(今日)になりログの内容とファイル名の日付が乖離してしまいます。ファイル名を前日の日付でローテートする方法をメモします。

{% gist 5105939 %}

一部説明

    ifempty        # 空ファイルでもローテートする。
                   # 過去ログを`ls | wc -l`などするときに
                   # 日数と数を合わせたいので。
    dateext        # ローテートしたファイルに実行時の日付を
                   # 付ける。ただし、00:00以降にlogrotateを実行する
                   # 場合は、ログ内容と日付が乖離するので別途
                   # lastactionで日付を前日分に変えている。
    extension .log # ローテート後のファイル名の場所の末尾に.log 
                   # を持ってくる。 圧縮する場合は.log.gzになる。
                   # 本オプション指定ない場合はapp.log-yyyymmdd となり
                   # 微妙なので調整のため。
    lastaction     # 最後に実行するコマンド
                   # postrotateを使わないのはpostrotateはcompressする前
                   # に実行されるため。compressしてlastactionが実行される。
