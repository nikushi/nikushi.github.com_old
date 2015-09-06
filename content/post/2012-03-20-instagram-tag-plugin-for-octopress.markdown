---
title: "OctopressにInstagramの写真を挿入するTag Pluginを作ってみた"
slug: instagram-tag-plugin-for-octopress
date: 2012-03-20T20:39:00+09:00
comments: true
categories: 
 - 'octopress'
tags:
 - 'octopress'
 - 'Ruby'
 - 'Instagram'
---
Octopressで書く記事の中に簡単にInstagramに載せた写真を挿入できたらいいなとおもい、プラグインを実装してみました。

<!-- more -->

以下からダウンロードできます。
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

[instag.rb](https://gist.github.com/2134897)はスクラッチから書いたわけではなく、標準で付属するimage.rbプラグインとgist_tag.rbプラグイン参考にしました。

InstagramのページURLから画像を取得方法は[Embedding Endpoints](http://instagram.com/developer/embedding/)の機能を利用しました。認証キーを取得しなくとも利用できるので簡単に利用できます。画像ページのURLから実際のjpgのURLを取得する方法はこんな感じです。

    require 'open-uri'
    require 'json'

    api  = 'http://api.instagram.com/oembed?url='
    page = 'http://instagr.am/p/IYYs5bo0jd/'
    p JSON.parse(open(url+page).read)
     => {"provider_url"=>"http://instagram.com/", "media_id"=>"150979225957124317_1267257", "title"=>"dal curry!!! yumyum", "url"=>"http://distilleryimage1.s3.amazonaws.com/2a3e47fa724611e181bd12313817987b_7.jpg", "author_name"=>"niku4i", "height"=>612, "width"=>612, "version"=>"1.0", "author_url"=>"http://instagram.com/", "author_id"=>1267257, "type"=>"photo", "provider_name"=>"Instagram"} 

**2012/04/03 追記 キャッシュ対応しました**

コードは[引き続きgist](https://gist.github.com/2134897)からダウンロードできます。
APIを参照するのみでは```rake generate```するたびに問い合わせるのでAPI問い合わせ結果をキャッシュするよう修正しました。なお、.instag-cache/というディレクトリ以下にキャッシュファイルが生成されますので、```git commti```しても含まれないように.gitignoreに.instag-cacheを追記してください。
~~~sh
# 変更後の.gitignoreをgit diffコマンドで確認
$ git diff .gitignore 
diff --git a/.gitignore b/.gitignore
index 68a6830..c80293a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,6 +2,7 @@
 .DS_Store
 .sass-cache
 .gist-cache
+.instag-cache
 .pygments-cache
(略)
~~~

次はサイドバーにInstagramの画像を表示したくなりました。OctopressはWordpressに比べて圧倒的にプラグインの数が少ないのが難点ですがこうやって作れるは魅力的です。

