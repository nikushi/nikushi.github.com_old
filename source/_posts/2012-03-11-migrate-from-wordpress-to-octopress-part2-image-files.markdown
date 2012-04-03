---
layout: post
title: "Wordpressからoctopressに移行した(画像移行編)"
date: 2012-03-11 22:36
comments: true
categories: 
 - octopress
---

前回の記事とおり、ブログの過去の記事をWordpressからOctopressに移行したが、ブログの記事に貼付けた画像ファイルは移行後にリンク切れ状態のままでした。過去記事の画像を表示するよう修正します。

<!-- more -->

* 移行前(Wordpress)の画像ファイル置き場は/wp-content/uploads/
* 移行後(octopress)の画像ファイル置き場は/images/

Wordpressはxreaのサーバで運用していたので、sshでログインしてローカルのMacまでscpしてきた。 ~/tmp/uploads/ あたりに保存しとく。

つづいてローカルのoctopressディレクトリにコピーする。
``` 
cd ~/Documents/Blog/octopress
cp ~/tmp/uploads/* source/images/
```
source/images以下にコピーすると、`rake deploy`すると`http://username.github.com/images/`以下にマップされるみたい。

続いて過去記事のaタグとimgタグの修正。過去記事を確認したら、 ```<a href="http://orihubon.com/wp-contents/uploads/hogehoge.jpg"> ```みたいにhttp://で始まっていたので、方針としてはhttp://orihubon.com/uploads/をざっくり消して/imagesに置き換えることにする。
``` sh
cd source/_posts
for f in $( ls ); do  ruby -ne '$_.gsub!(%r!http://orihubon.com/wp-content/uploads/!, "/images/"); puts $_;' < $f > tmp; mv tmp $f; done
```
上のコードは単純に置換してるだけ。過去記事のaタグやimgタグ意外のテキストも置き換えるのですが、私の記事をgrepして確認したらなかったので、parseしなくていいやということでシンプルに置き換えた。

生成して確認する。
```
rake generate
rake preview
```
http://localhost:4000/にアクセスして確認する。

deployし公開。
```
rake deploy
```

commitもしとく。
```
git add -A
git commit -m "Imported image files from old wordpress blog"
git push
```
