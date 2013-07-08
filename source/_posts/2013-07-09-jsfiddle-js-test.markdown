---
layout: post
title: "jsFiddleでjavascriptお手軽動作確認"
date: 2013-07-09 00:16
comments: true
categories: 
  - 'JavaScript'
tags:
  - 'JavasScript'
  - 'jQuery'
  - 'jsFiddle'
---

Webアプリを作っていると、思いついたUIのアイデアを実装して使用感や見た目を確認したくなることがしばしばあるとおもいます。そんな時はさくっと試せる [jsFiddle](http://jsfiddle.net/) がお勧めです!

[jQuery-UIのaccordion pluginの動作確認をしてみた例](http://jsfiddle.net/niku4i/5pg4m/)

使ってみた感想としては、css、html、javascriptのコードをフォームに入力して Run! ボタンを押すだけでとても簡単でした。

また、jsFiddleはgithub.comのgistに近い感覚でJavaScriptやCSSを試すことが出来るので、作った画面をSkypeやIRCで他人と共有できる点が優れています。StackOverflowでjs系で検索すると結構な確率で見ますね。

jQueryなどのライブラリの選択やバージョンの変更も左側のメニューからポチポチやるだけで切り替えれて簡単。

また、Ajax系の動作確認も可能です。サーバサイドのエンドポイントが必要ですが、jsFiddleでは `/echo/json/`, `/echo/html/`といったリクエストをresponseとしてechoするダミーのエンドポイントが提供されています。
