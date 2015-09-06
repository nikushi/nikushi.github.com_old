---
title: "git pushのトピックブランチ名を省略する方法"
slug: shortcut-to-push-origin-topicbranch
date: 2014-11-11T11:22:00+09:00
comments: true
categories: 
  - git
---

トピックブランチを完成させたあと `git push origin myfix` と毎度タイプしてたけどタイプがしんどいので省略する方法を調べた。

<!--more-->

[gitでカレントブランチをpushする](http://qiita.com/tkengo/items/5bae50fb7531d5a6bbcf) を参考に自分は以下のように `~/.gitconfig` を書いた。

~~~
#~/.gitconfig
[alias]
  cb             = rev-parse --abbrev-ref HEAD
  current-branch = rev-parse --abbrev-ref HEAD
  pcb            = !git push origin `git rev-parse --abbrev-ref HEAD`
~~~

自分は `git` を `g` にaliasしているので、`g pcb` で カレントブランチを origin に push できるようになった。また`git cb` or `git current-branch` はカレントブランチの名前を表示するショートカット。

これでまた少しタイプ数を減らせた。
