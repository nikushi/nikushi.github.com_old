---
layout: post
title: "fluent-plugin-deriveで単位時間あたりの差分値を計算する"
date: 2013-12-23 14:57
comments: true
categories: 
  - Fluentd
---

[fluent-plugin-derive](https://github.com/niku4i/fluent-plugin-derive) というFluentd outputプラグインをリリースしました。初gem & 初Fluentd plugin作成。

<!--more-->

gemコマンドからインストールできます。

    $ gem install fluent-plugin-derive

何をするplug-inかというと、端的にいうと受け取ったrecordの前回分の値(timestamp, key, value)をキャッシュし2回目受信したrecordとの差(per second rate)をre-emitします。

例えばSNMPで取得するInterfaceのカウンタ値(バイトカウンタ)をFluentd内でbpsに変換するといったことで使えます。計算値を任意の値で掛け算したり割り算したりできるので、毎秒以外にも毎時や毎分にすることもできます。

### 設定

    <match foo.bar.**>
      type derive
      add_tag_prefix derive
      key1 foo_count *1000
      key2 bar_count *1000
    </match>

### 例

こういう入力があったとして...

    2013-12-19 20:01:00 +0900 foo.bar: {"foo_count":  100, "bar_count":  200}
    2013-12-19 20:02:00 +0900 foo.bar: {"foo_count":  700, "bar_count": 1400}
    2013-12-19 20:03:10 +0900 foo.bar: {"foo_count":  700, "bar_count": 1470}
    2013-12-19 20:04:10 +0900 foo.bar: {"foo_count": 1300, "bar_count":  870}

こう出力されます。

    2013-12-19 20:01:00 +0900 derive.foo.bar: {"foo_count":   nil, "bar_count":    nil}
    2013-12-19 20:02:00 +0900 derive.foo.bar: {"foo_count": 10000, "bar_count":  20000}
    2013-12-19 20:03:10 +0900 derive.foo.bar: {"foo_count":     0, "bar_count":   1000}
    2013-12-19 20:04:10 +0900 derive.foo.bar: {"foo_count": 10000, "bar_count": -10000}

`*1000`の部分はオプションで指定しないこともできます。上の例では差分値を1000倍しました。例えば`*8`にするとバイトバイトカウンタをbpsに変換できます。演算子は`*`と`/`をサポートしています。また、他にも`min`,`max`オプションで最小値、最大値を指定できます。カウンタ値がリセットされると値がマイナスになるので`min 0`にして使っています。

### 作った理由

ちなみにRRDToolやGrowthForecastを使っている場合はプラグインでやらずともRRDTool側でderiveをサポートしているのでカウンタ値をそのままつっこめばよいです。わざわざ途中で計算する必要はありません。GrowthForecastの場合はsubtractモードだけでもよいかもしれません。

ではなぜFluentd側で計算しているのかというと、1つはカウンタ値よりもbpsの方が扱いやすかったかで、Fluentdで閾値設定したり解析したりと二次用途に使いやすくなります。

もう1つはFluentdで生のカウンタ値を流してRRDへ格納する場合、取得して格納するまでに若干時差が発生するので、カウンタ値のようなderiveな値だとRRDへの値格納が少し遅れたり早かったりすると差分値が実際より大きくなったり小さくなったり揺れてしまいました。そのためderiveプラグインを作ってカウンタ値を取得した瞬間に計算するようにしました。

なお注意点としては、Fluentdではメッセージの到着順が保証されている訳ではないので、秒単位でメッセージがinされるようなタグに対しては正しく計算でき無い場合があるのでそのようなケースでは使えません。分毎に1メッセージがinされるとかそういうったタグ向けです。

作る前に既存プラグインを探してみましたが、前回値との差分を計算してくれるプラグインがなかったので自作に至りました。

以上!
