---
layout: post
title: "OctopressにInstagramの写真を挿入するTag Pluginを作ってみた"
date: 2012-03-20 20:39
comments: true
categories: 
 - 'octopress'
tags:
 - 'octopress'
 - 'Ruby'
 - 'Instagram'
---
Octopressで書く記事の中に簡単にInstagramに載せた写真を挿入できたらいいなとおもい、プラグインを実装してみました。以下からダウンロードできます。

* [instag.rb](https://gist.github.com/2134897)

### 概要
    {{ "{% instag http://instagr.am/p/IYYs5bo0jd/ "%}}}
記事中でタグが使えます。表示したいinstagramページのURLは知っておく必要があります。

### インストール
[instag.rb](https://gist.github.com/2134897)をダウンロードし```plugins/```ディレクトリに配置してください。
    cd /var/tmp/
    git clone git://gist.github.com/2134897.git
    mv 2134897/instag.rb path/to/octopress/plugins
    rm -rf 2134897/

### 使い方
    # Syntax:
    {{ '{% instag [class name(s)] http://instagr.am/p/IYYs5bo0jd/ [width [height]] [title text | "title text" ["alt text"]] '%}}}

    # Examples:
    {{ '{% instag http://instagr.am/p/IYYs5bo0jd/ '%}}}
    {{ '{% instag left half http://instagr.am/p/IYYs5bo0jd/ my title '%}}}
    {{ '{% instag left half http://instagr.am/p/IYYs5bo0jd/ 150 150 "my title" "our title" '%}}}
     
    # Output:
    <img src="http://path/to/istagram/image.jpg">
    <img class="left half" src="http://path/to/instagram/image.jpg" title="my title" alt="my title">
    <img class="left half" src="http://path/to/instagram/image.jpg" width="150" height="150" title="my title" alt="our title">

### 例
今日、中野駅近くのベジタブル料理専門のカフェレストランに行ってきたときの写真で試します。

標準サイズ
    {{ '{% instag http://instagr.am/p/IYYs5bo0jd/ '%}}}
{% instag http://instagr.am/p/IYYs5bo0jd/ %}

125x125に縮小
    {{ '{% instag http://instagr.am/p/IYYs5bo0jd/ 125 125 '%}}}
{% instag http://instagr.am/p/IYYs5bo0jd/ 125 125 %}

[instag.rb](https://gist.github.com/2134897)はスクラッチから書いたわけではなく、標準で付属するimage.rbプラグインをまねて作った。ざっと作ったので例外処理がゆるい。

InstagramのページURLから画像を取得方法は[Embedding Endpoints](http://instagram.com/developer/embedding/)の機能を利用した。この方法は認証キーを取得しなくとも利用できるので、できることは限られるけど認証がないので簡単。こんな感じ。

```ruby sample
    require 'open-uri'
    require 'json'

    def get_info(url)
        url = 'http://api.instagram.com/oembed?url=' + url
        JSON.parse(open(url).read)
    end
```

現状キャッシュしてないので```rake generate```する度に問い合わせして遅い。気が向いたらキャッシュするといったことを実装するかも。同じようなプラグインでgist_tag.rbというのが標準でありまして、こいつを拝見するとキャッシュしてるので真似れば出来そうではある。

次はサイドバーにInstagramの画像を表示したくなるが誰か作ってくれないかなと期待。OctopressはWordpressに比べて圧倒的にプラグインの数が少ないのが難点ですがこうやって作れるのもまあ魅力かな。

Have happy life with Instagram!
