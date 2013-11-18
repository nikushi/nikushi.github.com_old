---
layout: post
title: "Yohoushi screencasts!"
date: 2013-10-01 11:37
comments: true
categories: 
  - Yohoushi
tags:
  - Yohoushi
  - Graph
  - Rails
  - Ruby
---

グラフツール [Yohoushi](http://yohoushi.github.io/yohoushi/)を紹介するスクリーンキャストを作ってみた。

<!--more-->

[Yohoushi](http://yohoushi.github.io/yohoushi/)というグラフツールを[@sonots](https://twitter.com/sonots)さんと作っています。Yohoushiを使うと[GrowthForecast](http://kazeburo.github.io/GrowthForecast/)に登録したグラフと連携し検索やタギング、グラフ画像の拡大縮小、期間カスタム指定などができます。

会社の同僚の方々からYohoushiがどんなツールかもっと分かりやすく解説してよというコメントをいただきまして、Yohoushiの概要〜インストール、簡単な使い方までをscreencastにしてみました。"GrowthForecast使ってるからそろそろYohoushiも...でもYohoushiむずいんでしょ?" とおもわれている方にYohoushiの導入の簡単さを分かってもらえる内容になってるとおもいます。

各話3分程度です。エピソード1は概要なのでわかってる方は飛ばしてください。Yohoushiの雰囲気を知るだけならエピソード3、4だけでもおすすめです!


#### 1 Yohoushiとはなにか?

{% youtube ZjZjtzyx6Jc %}

#### 2 Yohoushiをインストールしてみよう 

{% youtube mqIR0RClP3o %}

#### 3 Yohoushiを使ってみよう

{% youtube q_vMqjpFRUc %}

#### 4 Yohoushiを使ってグラフにタグをつけよう 

{% youtube EV51EmjC74o %}

#### 補足

* インストールする際のrakeやbundleは`bin/`に同封のbinstubの`bin/bundle`, `bin/rake`を使ってください。`bin/`配下のコマンドで実行すると`RAILS_ENV=production`が自動的にセットされます。パスの通ったコマンドを使ってしまうと`RAILS_ENV=development`が自動的にセットされるので意図しない動作になるので注意してください。

* GrowthForecastのグラフはscreencast用のダミーで@sonotsさん作の[growthforecast-client](https://github.com/sonots/growthforecast-client)を使ってランダム値を定期POSTしてます。
